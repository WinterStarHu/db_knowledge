# Configuring PKI Certificate Authentication

You can configure Oracle Database to use PKI certificates for end-user authentication.
- How Oracle Database Uses Transport Layer Security for Authentication Transport Layer Security works with the core Oracle Database features such as encryption and data access controls.
````
- Enabling Oracle Internet Directory to Use Transport Layer Security Authentication To enable Oracle Internet Directory (OID) to use Transport Layer Security (TLS), create a wallet and certificates, and modify tnsnames.ora and sqlnet.ora.
- Configuring User Authentication with Transport Layer Security Both the client and server side can authenticate administrative users with Transport Layer Security (TLS).
- Configuring Transport Layer Security for Client Authentication and Encryption with X.509 Certificates You must perform this type of configuration on the server first, then the client.
- Configuring Email over Transport Layer Security with an Oracle Wallet You can use an Oracle wallet, PL/SQL packages, and security access control lists (ACLs) to configure email over a Transport Layer Security (TLS) connection.
- Troubleshooting Transport Layer Security Errors Oracle provides a utility to help troubleshoot PKI certificate configurations as well as additional guidance below. A utility is available through the support website to review and provide feedback on your PKI certificate authentication client and server configuration.
## How Oracle Database Uses Transport Layer Security for Authentication
Transport Layer Security works with the core Oracle Database features such as encryption and data access controls.
By using Oracle Database TLS functionality to secure communications between clients and servers, you can
- Use TLS to encrypt the connection between clients and servers
- Authenticate any client or server, such as Oracle Application Server 10g, to any Oracle database server that is configured to communicate over TLS
You can use TLS features by themselves or in combination with other authentication methods supported by Oracle Database. For example, you can use the encryption provided by TLS in combination with the authentication provided by Kerberos. TLS supports any of the following authentication modes:
- Only the server authenticates itself to the client
- Both client and server authenticate themselves to each other
## Enabling Oracle Internet Directory to Use Transport Layer Security Authentication
To enable Oracle Internet Directory (OID) to use Transport Layer Security (TLS), create a wallet and certificates, and modify `tnsnames.ora` and `sqlnet.ora`.
- Log in to the database client server that has Oracle Internet Directory (OID) installed.
- Go to the $ORACLE_HOME/ldap/lib directory
- Run the following command:
```
make -f ins_ldap.mk install
```
- Go to the directory where the OID tnsnames.ora file is located. By default, this directory is $ORACLE_HOME/network/admin.
****``````````
- Edit the tnsnames.ora file to include the following OID settings, which will specify the TCPS port. Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both TLS_SERVER_CERT_DN and SSL_SERVER_CERT_DN parameters are configured, then the SSL_SERVER_CERT_DN parameter is ignored. For example:
```
OIDDB=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCPS) (HOST=sales_db.us.example.com)(PORT=5500)) (CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=orcl.us.example.com))) (SECURITY=(TLS_SERVER_CERT_DN="CN=Server,O=Example,ST=California,C=US"))
```
```
In this example, `TLS_SERVER_CERT_DN` points to the DN of the database server certificate.
```
- Configure the wallet location in the sqlnet.ora file. For example:
```
ENCRYPTION_WALLET_LOCATION= (SOURCE= (METHOD=FILE) (METHOD_DATA= (DIRECTORY=/etc/ORACLE/WALLETS/$ORACLE_SID/)))
```
****``````````
- Ensure that the sqlnet.ora file has the following settings: Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both the TLS_ and SSL_ versions of a parameter are configured, then the SSL_ version is ignored.
```
TLS_CLIENT_AUTHENTICATION = FALSE TLS_SERVER_DN_MATCH=OFF
```
- Use the orapki utility to create a new wallet and add database certificates to it. For example:
```
orapki wallet create -wallet /etc/ORACLE/WALLETS/$ORACLE_SID/oid_wallet -auto_login -pwd wallet_password orapki wallet add -wallet /etc/ORACLE/WALLETS/$ORACLE_SID/oid_wallet -trusted_cert -cert /etc/ORACLE/certificates/dbssl/root/b64certificate.txt -pwd wallet_password ./orapki wallet add -wallet /etc/ORACLE/WALLETS/$ORACLE_SID/oid_gwallet -trusted_cert -cert /etc/ORACLE/certificates/dbssl/netadmin/cert.txt -pwd wallet_password
```
## Configuring User Authentication with Transport Layer Security
Both the client and server side can authenticate administrative users with Transport Layer Security (TLS).
- The client needs to specify use of the PKI certificate to authenticate the end-user. If all the client connections will use this authentication method, then set AUTHENTICATION_SERVICES=(tcps). Alternatively, you can set it separately for each connection by using AUTHENTICATION_SERVICE=tcps in the connect string.
**Note:**   The connection string parameter is singular, while the sqlnet.ora parameter is plural.
- For both the client and the server, ensure that the wallet has Certificate Authority (CA) certificates for user’s certificate and the server’s certificates. These CA certifcates can be different on the client and server.
****``````````
  - Add the signed user certificate to the client wallet. The CA root trust certificate should already be in the client wallet. Ensure that any intermediate certificates that are required for the user certificate are added to the wallet before you add the user certificate. You can use orapki to configure the client wallet and user certificate.
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
  - Set TLS as an authentication service in the sqlnet.ora file.
  - Optionally, for better security, set the client to use full or partial DN matching. When DN matching is enabled, the client will check the server certificate to ensure that host names will match what the client is configured to match. You perform this step when you enable Oracle Internet Directory to use TLS.
**Note:**  The database client and server will use the strongest TLS protocol and cipher suite to establish a connection. Therefore, you do not need to specify the TLS version and cipher suites unless you have specific security requirements that require it. Be aware that if you set specific TLS versions and cipher suites, you will need to update the configuration when the older versions are no longer used.
```
LISTENER = (DESCRIPTION_LIST = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = example.com)(PORT = 1521)) (ADDRESS = (PROTOCOL = TCPS)(HOST = example.com)(PORT = 1522)) ) )
```
  - Create a separate listener entry for TLS connections using the secure database port 1522. For example:
````
  - Comment out the non-TLS listener entry (for example, the line with PROTOCOL = TCP) or leave it in for non-TLS required connections. The same wallet that the server uses can be used by the listener, along with the same server certificate. The listener will look for the wallet using the standard Oracle Database wallet search order. Alternatively, you can specify the wallet location in the listener by setting the WALLET_LOCATION parameter. (You cannot use the WALLET_ROOT parameter for this purpose, because the listener cannot use it.)
****``````````
  - Set the WALLET_ROOT parameter to a location for the TLS server.
````
    - Create the tls directory under WALLET_ROOT/pdb_guid.
    - Move the TLS server wallet to the WALLET_ROOT/pdb_guid/tls directory.
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
````
  - In the sqlnet.ora file, add the following parameter: If you want to restrict authentication to only TCPS, then set AUTHENTICATION_SERVICES to TCPS.
```
CREATE USER user_name IDENTIFIED EXTERNALLY AS 'user DN on certificate';
```
```
CREATE USER user_name IDENTIFIED EXTERNALLY AS 'user DN on certificate'
  WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
**
```
CREATE USER user_name IDENTIFIED EXTERNALLY AS ''
  WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
- Create a new schema or alter an existing schema to map to the user. You can add the WITH THUMBPRINT clause to map the user to the certificate thumbprint. The same clause is available with the ALTER USER statement. To identify the user only by the certificate thumbprint, enable thumbprint-only authentication and specify an empty certificate DN. For more information about PKI_CERT_AUTH_METHOD, see the Oracle Database Reference.
````
```
CONNNECT /@pdb_name AS SYSOPER
```
- Grant the database schema to appropriate administrative privileges, such as SYSDBA, SYSOPER, and so on. Administrative users with TLS authentication can authenticate with TLS. To enable these users, grant the appropriate administrative privilege to the user schema. The administrative user must log in using this administrative privilege. For example, for a user who was granted the SYSOPER administrative privilege:
Afterward, this user can log in by including the net service name in the `CONNECT` statement in SQL*Plus. For example, to log on as `SYSDBA` if the net service name is `orcl`:
```
CONNECT /@orcl AS SYSDBA
```
**Related Topics**
- Enabling Oracle Internet Directory to Use Transport Layer Security Authentication
- Oracle Database Wallet Search Order
## Configuring Transport Layer Security for Client Authentication and Encryption with X.509 Certificates
You must perform this type of configuration on the server first, then the client.
- About Configuring TLS for Client Authentication and Encryption with X.509 Certificates You can enable Public Key Infrastructure (PKI) authentication between Oracle Database clients and an Oracle database with X.509 certificates.
````
- Configuring the Server for Authentication and Encryption with X.509 Certificates You must configure the server’s listener.ora, sqlnet.ora, and initialization files and create a database user account for authentication and encryption with X.509 certificates.
``````
- Configuring the Client for Authentication and Encryption with X.509 Certificates You must configure the client’s sqlnet.ora, tnsnames.oralistener.ora files, and configure the Microsoft Certificate Store (MCS) for authentication and encryption with X.509 certificates.
### About Configuring TLS for Client Authentication and Encryption with X.509 Certificates
You can enable Public Key Infrastructure (PKI) authentication between Oracle Database clients and an Oracle database with X.509 certificates.
The configuration entails having to enable Public Key Infrastructure (PKI) authentication between Oracle Database clients and an Oracle database. It can be used with U.S. Federal Government Personal Identity Verification (PIV) and Department of Defense Common Access Card (CAC) cards as external keystores with the Microsoft Certificate Store (MCS) on the Windows operating system. In addition, the configuration enables Java-based Oracle Database clients to authenticate against the Oracle Database through use of client certificates stored in an Oracle wallet.
Before you begin the configuration process, note the following:
- TLS communications must run on a separate network port from normal database connections. This may affect requirements for firewall exceptions.
- TLS connections can take a longer time to establish than connections with native encryption or without any encryption, because the key exchange process introduces additional overhead.
### Configuring the Server for Authentication and Encryption with X.509 Certificates
You must configure the server’s `listener.ora`, `sqlnet.ora`, and initialization files and create a database user account for authentication and encryption with X.509 certificates.
- Step 1: Create and Configure the Server Wallet for the X.509 Certificate You can use the orapki utility to perform this configuration.
- Step 2: Shut Down the Oracle Listener on the Server You use different methods to shut down the Oracle listener on the server.
- Step 3: Configure the sqlnet.ora File on the Server You must add or modify several sqlnet.ora parameters on the server.
- Step 4: For Logical Volume Management, Configure the Server listener.ora File A logical volume management environment requires special settings for the listener.ora file on the server.
- Step 5: For Grid Infrastructure, Configure the Server Listener Process A Grid Infrastructure environment requires special settings for the listener.ora file on the server.
- Step 6: Set Initialization Parameters on the Server To avoid problems with prefixed user names, you may need to set some Oracle database initialization parameters on the server.
- Step 7: Create an External Database User on the Server You must create the database user by specifying the distinguished name (DN) of the user’s client certificate.
- Step 8: Restart and Check the Listener Process on the Server If the Oracle database does not use Grid Infrastructure, then you must restart the listener on the server and check its process.
#### Step 1: Create and Configure the Server Wallet for the X.509 Certificate
You can use the `orapki` utility to perform this configuration.
- Connect to the server as the oracle user.
- Create a directory in which to put the server’s wallet if this directory does not exist, and then cd to this directory.
```
orapki wallet create -wallet wallet_file_directory -auto_login -pwd password
```
- Use orapki to create the initial wallet and give it a strong password.
````````
```
orapki wallet add -wallet wallet_file_directory -dn "CN=host_address,other_attributes" -asym_alg RSA -keysize 4096 -pwd password
```
- Generate the certificate signing request (CSR) for your server. Use the fully qualified domain name of the server for host_address (for example, hostname.af.mil). Ensure that you include the additional O and C attributes in the distinguished name as appropriate. If you do not,then the final certificate created by Federal Agency PKI will not match the request and you will not be able to import the certificate into your wallet.
```
orapki wallet export -wallet wallet_file_directory -dn "CN=host_address,other_attributes" -request ~/host_name.csr -pwd password
```
````
- Export the CSR so that you can submit the request to your certificate authority (CA) to generate the unique server certificate and the certificate trust chain. If you are using Oracle Real Application Clusters (Oracle RAC), then set [HOST_ADDRESS] to the SCAN DNSname.
- Submit the CSR (that is, host_name.csr) to the appropriate CA.
- Download the appropriate root and intermediate CA certificates for your organization, any user X509 cards (CAC and PIV), and any certificates issued to non-person entities (NPEs) or service accounts.
```
orapki wallet add -wallet wallet_file_directory -trusted_cert -cert cert_file_path -pwd password
```
```
find cert_file_path -name "*.txt" -exec orapki wallet add -wallet wallet_file_directory -trusted_cert -cert {} -pwd password \;
```
- Import these certificates and cards into your server wallet to establish the necessary trust chain for your server certificate and all client certificates. On Linux, you can import all the certificates in a single command:
```
orapki wallet add -wallet wallet_file_directory -user_cert -cert base64_cert_file_path -pwd password
```
- When the signed server certificate is received, import the base64 certificate as a user certificate on the Oracle wallet on the server.
- As your site adds more root and intermediate CAs, update the Oracle wallet with their certificates similar to Steps 7 and 8.
```
wallet display -wallet wallet_file_directory -pwd password
```
- Confirm that the server, root CA, and intermediate CA certificates are present in the Oracle wallet. Check the Requested Certificates section of the output for a listing of the certificates.
If the Oracle database uses Grid Infrastructure, then configure the Oracle wallet directory and files located at `wallet_file_directory` to be readable by the grid user. Additionally, if it is an Oracle RAC database, then make the Oracle wallet available in a similar manner on all supporting database nodes.
#### Step 2: Shut Down the Oracle Listener on the Server
You use different methods to shut down the Oracle listener on the server.
Depending on your environment, use one of the following commands to stop the listener:
````
```
lsnrctl stop
```
- If the Oracle database does not use Oracle Real Applications (Oracle RAC) or Oracle Grid Infrastructure Storage Management, then as the oracle user, use the following lsnrctl command:
```
srvctl stop listener
```
- If the Oracle database uses Oracle Grid Infrastructure Storage Management, then as the grid user, use the following lsnrctl command:
```
srvctl stop scan_listener
```
- If the Oracle database is an Oracle RAC database, as the grid user, then use the following srvctl command:
#### Step 3: Configure the sqlnet.ora File on the Server
You must add or modify several `sqlnet.ora` parameters on the server.
````
- Back up the sqlnet.ora file, which is typically located in the ORACLE_HOME/network/admin directory.
````
****``````````
```
###Begin required parameters to be Added or Modified
SQLNET.AUTHENTICATION_SERVICES = (beq, tcps)
TLS_VERSION = 1.2
TLS_CIPHER_SUITES = (TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256)
TLS_CLIENT_AUTHENTICATION = TRUE
WALLET_LOCATION = (SOURCE = (METHOD = FILE)(METHOD_DATA = (DIRECTORY = wallet_file_directory)))
#Added when NATIVE Encryption is also configured
SQLNET.IGNORE_ANO_ENCRYPTION_FOR_TCPS = TRUE
###End required parameters to be Added or Modified
###Begin optional parameters to be Added or Modified
#TLS_CERT_REVOCATION = #set to none, requested, or required
#TLS_CRL_PATH = #set to directory containing CRLs
#TLS_CRL_FILE = #set to file containing CRLs
#TLS_EXTENDED_KEY_USAGE = #set to extended key the client cert is to present
###End optional parameters
```
- Edit the sqlnet.ora file to include the following parameters. In the following settings, the TLS_VERSION and TLS_CIPHER_SUITES parameters are optional and depend on your site’s requirements. Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both the TLS_ and SSL_ versions of a parameter are configured, then the SSL_ version is ignored.
#### Step 4: For Logical Volume Management, Configure the Server listener.ora File
A logical volume management environment requires special settings for the `listener.ora` file on the server.
This procedure assumes that you will modify an existing `listener.ora` file. However, it also possible to configure a newly created listener by using Net Manager (`netmgr`) as well. Oracle recommends that you use a standard TCPS port setting of 2484, but you can still use another port number. Your firewalls, security lists, and network security groups must be configured to allow traffic from your clients to the TCPS port that you specify.
````
- As the oracle user, back up the listener.ora file.
````
****``````````
```
###Modify the LISTENER parameter to add the following ADDRESS parameter
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = host_address)(PORT = 1521))
      (ADDRESS = (PROTOCOL = TCPS)(HOST = host_address)(PORT = 2484))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )
###Begin required parameters to be Added or Modified
TLS_VERSION = 1.2
TLS_CLIENT_AUTHENTICATION = TRUE
WALLET_LOCATION = (SOURCE = (METHOD = FILE)(METHOD_DATA = (DIRECTORY = wallet_file_directory)))
###End required parameters to be Added or Modified
```
- Edit the listener.ora file to include the following parameters: Ensure that you add the ADDRESS parameters in the order shown. Note that the TLS_VERSION parameter is optional and depends on your site’s requirements. Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both the TLS_ and SSL_ versions of a parameter are configured, then the SSL_ version is ignored.
#### Step 5: For Grid Infrastructure, Configure the Server Listener Process
A Grid Infrastructure environment requires special settings for the `listener.ora` file on the server.
You must perform this procedure as the grid user on all nodes that are associated with the Oracle database.
- As the grid user, back up the listener.ora file.
****``````````
```
###Begin required parameters to be Added or Modified
TLS_VERSION = 1.2
TLS_CLIENT_AUTHENTICATION = TRUE
WALLET_LOCATION = (SOURCE = (METHOD = FILE)(METHOD_DATA = (DIRECTORY = wallet_file_directory)))
###End required parameters to be Added or Modified
```
- Edit the listener.ora file to include the following parameters: Ensure that you add the ADDRESS parameters in the order shown. Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both the TLS_ and SSL_ versions of a parameter are configured, then the SSL_ version is ignored.
```
srvctl modify listener -endpoints "TCP:1521/TCPS:2484"
```
- Add TCPS services to the listener.
```
srvctl modify scan_listener -endpoints "TCP:1521/TCPS:2484"
```
- If this is an Oracle Real Applications Clusters (Oracle RAC) database, then run the following command:
#### Step 6: Set Initialization Parameters on the Server
To avoid problems with prefixed user names, you may need to set some Oracle database initialization parameters on the server.
- Connect to the database as a user who has the ALTER SYSTEM system privilege.
```
ALTER SYSTEM SET OS_AUTHENT_PREFIX='' SCOPE=SPFILE;
```
- Set the following parameters:
- Restart the database instance.
#### Step 7: Create an External Database User on the Server
You must create the database user by specifying the distinguished name (DN) of the user’s client certificate.
Though users that are identified externally can be granted proxy privileges to connect through to other schemas (as in the case of developers accessing an application schema in a test environment), they cannot be granted privileges such as `SYSDBA` that require credentials to be stored in the database password file.
- Connect to the database as a user who has the CREATE USER system privilege.
```
CREATE USER pfitch IDENTIFIED EXTERNALLY AS 'CN=FITCH.PETER.I.1234567890,other_attributes';
```
```
CREATE USER pfitch IDENTIFIED EXTERNALLY AS 'CN=FITCH.PETER.I.1234567890,other_attributes'
  WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
**
```
CREATE USER pfitch IDENTIFIED EXTERNALLY AS ''
  WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
- Create the external user as follows: For example, to create the external user pfitch: To map the user to a certificate thumbprint, add the WITH THUMBPRINT clause. To identify the user only by the certificate thumbprint, enable thumbprint-only authentication and specify an empty certificate DN. For more information about PKI_CERT_AUTH_METHOD, see the Oracle Database Reference.
**
```
GRANT CREATE SESSION TO pfitch;
```
- At minimum, grant this user the CREATE SESSION privilege so that the user can connect to theother_attributes database.
#### Step 8: Restart and Check the Listener Process on the Server
If the Oracle database does not use Grid Infrastructure, then you must restart the listener on the server and check its process.
Depending on your environment, use one of the following commands to restart and check the listener:
````
```
lsnrctl start lsnrctl status
```
- If the Oracle database does not use Oracle Real Applications (Oracle RAC) or Oracle Grid Infrastructure Storage Management, then as the oracle user, use the following lsnrctl commands:
```
srvctl start listener srvctl status listener
```
- If the Oracle database uses Oracle Grid Infrastructure Storage Management, then as the grid user, use the following lsnrctl commands:
```
srvctl start scan_listener srvctl status scan_listener
```
- If the Oracle database is an Oracle RAC database, as the grid user, then use the following srvctl commands:
### Configuring the Client for Authentication and Encryption with X.509 Certificates
You must configure the client’s `sqlnet.ora`, `tnsnames.oralistener.ora` files, and configure the Microsoft Certificate Store (MCS) for authentication and encryption with X.509 certificates.
- Step 1: Configure the sqlnet.ora File on the Client You must add or modify several sqlnet.ora parameters on the client.
- Step 2: Configure the tnsnames.ora File on the Client You must modify the tnsnames.ora file on the client.
- Step 3: Configure Microsoft Certificate Store on the Client The Microsoft Certificate Store (MCS), which enables you to store and manage certificates locally, can be configured on an Oracle Database Windows client.
#### Step 1: Configure the sqlnet.ora File on the Client
You must add or modify several `sqlnet.ora` parameters on the client.
This configuration will enable you to use the Microsoft Certificate Store (MCS) to store and manage certificates.
````
- Back up the sqlnet.ora file, which is typically located in the ORACLE_HOME/network/admin directory.
****``````````
```
###Begin required parameters to be Added or Modified
SQLNET.AUTHENTICATION_SERVICES = (nts, tcps)
TLS_VERSION = 1.2
TLS_SERVER_DN_MATCH = TRUE
WALLET_LOCATION = (SOURCE = (METHOD = MCS))
###Begin optional parameters to be Added or Modified
#TLS_CIPHER_SUITES = algorithms to be used for TLS encryption
###End optional parameters
```
- Edit the sqlnet.ora file to include the following parameters. The TLS_VERSION parameter setting depends on your site’s requirements. Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both the TLS_ and SSL_ versions of a parameter are configured, then the SSL_ version is ignored.
#### Step 2: Configure the tnsnames.ora File on the Client
You must modify the `tnsnames.ora` file on the client.
````
- Back up the tnanames.ora file, which is typically located in the ORACLE_HOME/network/admin directory.
****``````````
```
service_alias = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCPS) (HOST = host_ip_address) (PORT = 2484) ) (CONNECT_DATA = (SERVICE_NAME = database_service_name) ) (SECURITY = (TLS_SERVER_CERT_DN = "CN=host_ip_address,other_attributes) ) )
```
- Edit the tnsnames.ora file to include the following parameters: Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both TLS_SERVER_CERT_DN and SSL_SERVER_CERT_DN parameters are configured, then the SSL_SERVER_CERT_DN parameter is ignored.
#### Step 3: Configure Microsoft Certificate Store on the Client
The Microsoft Certificate Store (MCS), which enables you to store and manage certificates locally, can be configured on an Oracle Database Windows client.
- About Configuring Microsoft Certificate Store on the Client Before you configure Microsoft Certificate Store (MCS) on the client, you should ensure that your client environment is properly set up.
- Setting the TNS_ADMIN Environment Variable The TNS_ADMIN environment variable must be set in a special way to facilitate the MCS operation.
- Configuring Microsoft Certificate Store on the Client For the mTLS configuration to work, the certificates for the root and intermediate CAs that signed the certificate that the database server used must be added to the MCS.
- Testing the Microsoft Certificate Store Configuration Using tnsping The tnsping utility determines whether an Oracle service can be successfully reached.
*
*
- [Testing the Microsoft Certificate Store Configuration Using SQLPlus](#GUID-DCEC68EB-C2FF-4289-829A-954AC342ABB4) SQLPlus is the most basic Oracle Database utility commonly used by users, administrators, and programmers that can be used to confirm mTLS and user authentication to the database.
##### About Configuring Microsoft Certificate Store on the Client
Before you configure Microsoft Certificate Store (MCS) on the client, you should ensure that your client environment is properly set up.
These instructions assume the following:
- The Oracle Database client has been installed and configured to communicate with the Oracle Database server.
- All clients have the latest patches installed.
- You have installed the appropriate hardware and software to enable MCS to read the certificates from the X509 smart cards (Common Access Card (CAC), Personal Identity Verification (PIV)
You can also configure MCS to work on the client with SQL Developer and with Java using JDBC Type 4 Drivers. See My Oracle Support note 2959952.1.
The following diagram illustrates a smart card and MCS in an Oracle Database environment.
Figure 1: Smart Card and MCS in an Oracle Database Environment
Description of the illustration mcs_architecture.png
In this diagram:
- A user logs in to the Oracle database. The user’s user certificate, private key, and other necessary certificates are on the smart card.
- The database connection from the client is configured to use MCS.
- The wallet in the Oracle database is a PKCS11 wallet with a private key an certificate. The Oracle Database wallet holds the server private key and the trusted root certificate.
##### Setting the TNS_ADMIN Environment Variable
The `TNS_ADMIN` environment variable must be set in a special way to facilitate the MCS operation.
The following setting enables a user to place all necessary `*.ora` files within their own user profile where they have ownership and control. It also allows each user of a system to have individual, personalized configurations.
- Open the System Properties window on Windows. (Search for Advanced System Settings.)
****
- Select the Advanced tab.
****
- Click Environment Variables.
********
- In the Environment Variables window, if TNS_ADMIN is not listed, then click New. If it is listed, then click Edit.
****
```
%USERPROFILE%\Oracle\admin
```
- In the New (or Edit) User Variable dialog box, enter the following value in the Variable value field:
****
- Click OK.
##### Configuring Microsoft Certificate Store on the Client
For the mTLS configuration to work, the certificates for the root and intermediate CAs that signed the certificate that the database server used must be added to the MCS.
- Download the certificates for the root and intermediate CAs that were used to sign the database server certificate when you created and configured the server wallet.
- Start the MCS Certificate Import wizard.
********
- In the Welcome to the Certificate Import Wizard page, select the Current User option, and then click Next.
********
- On the Certificate Store page, select the Automatically select the certificate store based on the type of certificate option, and then click Next.
********
- In the Completing the Certificate Import Wizard page, check the settings that you made, and then click Finish. Click OK in the Certificate Import Wizard confirmation window.
  - In the Console Root tree on the left, under Certificates - Current User, expand the Trusted Root Certificates folder.
  - Select the Certificates folder to display the Certificate window.
****
  - Check the contents. The window will describe the purpose of the certificate, who it was issued to, who issued it, and the dates the certificate will be valid for. Click OK to dismiss the window.
**Related Topics**
  - Step 1: Create and Configure the Server Wallet for the X.509 Certificate
##### Testing the Microsoft Certificate Store Configuration Using tnsping
The `tnsping` utility determines whether an Oracle service can be successfully reached.
- On the client, confirm that there is TCP/IP connectivity to the TLS port (that is, 2484) configured from the client to the database using your utility of choice. If there does not appear to be connectivity, work with your network and system administrators to confirm that the appropriate firewall, security list, network security groups, and so on are a configured to allow the communication.
``````
```
tnsping service_alias
```
- Run the tnsping command (by default in the ORACLE_HOME/bin directory) against the service alias that you defined in the tnsnames.ora file.
```
Used parameter files:
[ORACLE_HOME]\network\admin\sqlnet.ora
Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCPS) (HOST = host_address) (PORT = 2484)) (CONNECT_DATA = (SERVICE_NAME = database_service_name]))
 (SECURITY = (TLS_SERVER_CERT_DN = CN=host_addres,other_attributes)))
OK (4920 msec)
```
- When prompted, select the certificate that you associated with the external Oracle Database user account that you created earlier. After you provide the Personal Identification Number (PIN) for the certificate, output similar to the following appears: The response time may seem large. The elapsed time shown includes the amount of time it takes the user to react to the prompt and select a certificate, so it will always be several seconds.
**Related Topics**
  - Step 2: Configure the tnsnames.ora File on the Client
##### Testing the Microsoft Certificate Store Configuration Using SQL*Plus
SQL*Plus is the most basic Oracle Database utility commonly used by users, administrators, and programmers that can be used to confirm mTLS and user authentication to the database.
```
sqlplus /@service_alias
```
- On the client, run SQL*Plus against the service alias you defined earlier in the client tnsnames.ora file.
```
SQL*Plus: Release release - Production on Mon May 23 14:03:10 2022
Version release
Copyright (c) 1982, 2019, 2023 Oracle.  All rights reserved.
Last Successful login time: Wed Oct 18 2023 16:47:43 +00:00
Connected to:
Oracle Database release - Production
Version release
```
- When prompted, select the certificate that you associated with the external Oracle Database user account that you created earlier. After you provide the Personal Identification Number (PIN) for the certificate, output similar to the following appears:
```
show user;
```
- Confirm that you are connected as the user associated with the client certificate you used.
```
SELECT SYS_CONTEXT('USERENV','NETWORK_PROTOCOL') FROM DUAL;
```
```
SYS_CONTEXT('USERENV','NETWORK_PROTOCOL')
--------------------------------------------------
tcps
```
- Confirm that the TCPS protocol is being used. Output similar to the following should appear:
**Related Topics**
  - Step 2: Configure the tnsnames.ora File on the Client
## Configuring Email over Transport Layer Security with an Oracle Wallet
You can use an Oracle wallet, PL/SQL packages, and security access control lists (ACLs) to configure email over a Transport Layer Security (TLS) connection.
``````
```
$ openssl s_client -showcerts -connect office365.com:443
```
```
depth=2 C = US, O = DigiCert Inc, CN = DigiCert Global Root CA verify return:1 depth=1 C = US, O = DigiCert Inc, CN = DigiCert Cloud Services CA-1 verify return:1 depth=0 C = US, ST = Washington, L = Redmond, O = Microsoft Corporation, CN = outlook.com verify return:1
---
Certificate chain 0 s:/C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=outlook.com i:/C=US/O=DigiCert Inc/CN=DigiCert Cloud Services CA-1
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
...
DONE
```
- Use openssl to get the URL certificates from the mail server. You can perform this step with email server, to dump the certificate chain to a standard output (stdout). Typically, this command dumps the server certificate (cert 0) and the intermediate trusted certificate (cert 1...n). For example: Output similar to the following appears:
````
  - file_root.cer
  - file_trusted.cer
  - file_user.cer
```
openssl x509 -in file_root.cer -text | grep -i issuer
Issuer: C=US, O=DigiCert Inc, CN=DigiCert Global Root CA
openssl x509 -in file_root.cer -text | grep -i subject
Subject: C=US, O=DigiCert Inc, CN=DigiCert Global Root CA
```
  - To check the root certificate:
```
openssl x509 -in file_trusted.cer -text | grep -i issuer
Issuer: C=US, O=DigiCert Inc, CN=DigiCert Global Root CA
openssl x509 -in file_trusted.cer -text | grep -i subject
Subject: C=US, O=DigiCert Inc, CN=DigiCert SHA2 Secure Server CA
```
  - To check the trusted certificate:
```
openssl x509 -in file_user.cer -text | grep -i issuer
Issuer: C=US, O=DigiCert Inc, CN=DigiCert Global Root CA
openssl x509 -in file_user.cer -text | grep -i subject
Subject: C=US, O=DigiCert Inc, CN=DigiCert SHA2 Secure Server CA
```
  - To check the user certificate:
```
mkdir app/oracle/product/network/admin/email
```
- Create a folder location. For example:
```
orapki wallet create -wallet wallet_file_directory -auto_login [-pwd wallet_password]
```
  - Create an empty wallet. For example: If you omit the pwd prompt, then a password prompt appears. For better security, enter the password at the prompt instead of entering it at the command line.
```
orapki wallet add -wallet wallet_file_directory -trusted_cert -cert trusted.cer
[-pwd wallet_password]
```
  - Put the certificate into the wallet. For example:
```
##############################################################################
##
DECLARE
k_host CONSTANT VARCHAR2(100) := 'us.example.com';
k_port CONSTANT INTEGER := 587;
k_wallet_path CONSTANT VARCHAR2(100) :=
'file:app/oracle/product/network/admin/email';
k_wallet_password CONSTANT VARCHAR2(100) := 'wallet_password';
k_domain CONSTANT VARCHAR2(100) := 'localhost';
k_username CONSTANT VARCHAR2(100) := 'email_account';
k_password CONSTANT VARCHAR2(100) := 'email_account_password';
k_sender CONSTANT VARCHAR2(100) := 'email_account';
k_recipient CONSTANT VARCHAR2(100) := 'email_account_sending_too';
k_subject CONSTANT VARCHAR2(100) := 'Test TLS mail';
k_body CONSTANT VARCHAR2(100) := 'We Love Database Security';
l_conn utl_smtp.connection;
l_reply utl_smtp.reply;
l_replies utl_smtp.replies;
BEGIN
dbms_output.put_line('utl_smtp.open_connection');
l_reply := utl_smtp.open_connection
( host => k_host
, port => k_port
, c => l_conn
, wallet_path => k_wallet_path
, wallet_password => k_wallet_password
, secure_connection_before_smtp => FALSE
);
IF l_reply.code != 220
THEN
raise_application_error(-20000, 'utl_smtp.open_connection: '||l_reply.code||'
       - '||l_reply.text);
END IF;
dbms_output.put_line('utl_smtp.ehlo');
l_replies := utl_smtp.ehlo(l_conn, k_domain);
FOR ri IN 1..l_replies.COUNT
LOOP
dbms_output.put_line(l_replies(ri).code||' - '||l_replies(ri).text);
END LOOP;
dbms_output.put_line('utl_smtp.starttls');
l_reply := utl_smtp.starttls(l_conn);
IF l_reply.code != 220
THEN
raise_application_error(-20000, 'utl_smtp.starttls: '||l_reply.code||' -
'||l_reply.text);
END IF;
dbms_output.put_line('utl_smtp.ehlo');
l_replies := utl_smtp.ehlo(l_conn, k_domain);
FOR ri IN 1..l_replies.COUNT
LOOP
dbms_output.put_line(l_replies(ri).code||' - '||l_replies(ri).text);
END LOOP;
dbms_output.put_line('utl_smtp.auth');
l_reply := utl_smtp.auth(l_conn, k_username, k_password,
utl_smtp.all_schemes);
IF l_reply.code != 235
THEN
raise_application_error(-20000, 'utl_smtp.auth: '||l_reply.code||' -
'||l_reply.text);
END IF;
dbms_output.put_line('utl_smtp.mail');
l_reply := utl_smtp.mail(l_conn, k_sender);
IF l_reply.code != 250
THEN
raise_application_error(-20000, 'utl_smtp.mail: '||l_reply.code||' -
'||l_reply.text);
END IF;
dbms_output.put_line('utl_smtp.rcpt');
l_reply := utl_smtp.rcpt(l_conn, k_recipient);
IF l_reply.code NOT IN (250, 251)
THEN
raise_application_error(-20000, 'utl_smtp.rcpt: '||l_reply.code||' -
'||l_reply.text);
END IF;
dbms_output.put_line('utl_smtp.open_data');
l_reply := utl_smtp.open_data(l_conn);
IF l_reply.code != 354
THEN
raise_application_error(-20000, 'utl_smtp.open_data: '||l_reply.code||' -
'||l_reply.text);
END IF;
dbms_output.put_line('utl_smtp.write_data');
utl_smtp.write_data(l_conn, 'From: '||k_sender||utl_tcp.crlf);
utl_smtp.write_data(l_conn, 'To: '||k_recipient||utl_tcp.crlf);
utl_smtp.write_data(l_conn, 'Subject: '||k_subject||utl_tcp.crlf);
utl_smtp.write_data(l_conn, utl_tcp.crlf||k_body);
dbms_output.put_line('utl_smtp.close_data');
l_reply := utl_smtp.close_data(l_conn);
IF l_reply.code != 250
THEN
raise_application_error(-20000, 'utl_smtp.close_data: '||l_reply.code||' -
'||l_reply.text);
END IF;
dbms_output.put_line('utl_smtp.quit');
l_reply := utl_smtp.quit(l_conn);
IF l_reply.code != 221
THEN
raise_application_error(-20000, 'utl_smtp.quit: '||l_reply.code||' -
'||l_reply.text);
END IF;
EXCEPTION
WHEN utl_smtp.transient_error
OR utl_smtp.permanent_error
THEN
BEGIN
utl_smtp.quit(l_conn);
EXCEPTION
WHEN utl_smtp.transient_error
OR utl_smtp.permanent_error
THEN
NULL;
END;
raise_application_error(-20000, 'Failed to send mail due to the following
error: '||SQLERRM);
END;
/
```
``````
```
ERROR at line 1:
ORA-29019: The protocol version is incorrect.
ORA-06512: at "SYS.UTL_TCP", line 63 ORA-06512: at "SYS.UTL_TCP", line 314 ORA-06512: at "SYS.UTL_SMTP", line 177 ORA-06512: at line 20
```
- Prepare the email SQL code. For example: Ensure that you set the secure_connection_before_smtp parameter to FALSE. This translates to “do not use TLS before the email is sent”. Setting it to TRUE generates the following error if we only want to send the email over TLS:
```
CREATE USER user_name IDENTIFIED BY password;
GRANT CREATE SESSION TO user_name;
```
- Create the user who will send emails. For example:
```
BEGIN DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE ( host => 'us.example.com', lower_port => 587, upper_port => 587, ace => xs$ace_type(privilege_list => xs$name_list('http'), principal_name => 'user_name', principal_type => xs_acl.ptype_db));
END;
/ BEGIN DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE ( host => 'us.example.com', lower_port => 587, upper_port => 587, ace => xs$ace_type(privilege_list => xs$name_list('connect'), principal_name => 'user_name', principal_type => xs_acl.ptype_db));
END;
/ BEGIN DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE ( host => 'us.example.com', lower_port => null, upper_port => null, ace => xs$ace_type(privilege_list => xs$name_list('resolve'), principal_name => 'user_name', principal_type => xs_acl.ptype_db));
END;
/
```
  - Append the host access control entry (ACE).
```
BEGIN DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE( wallet_path => 'file:/u01/64bit/app/oracle/product/network/admin/email', ace => xs$ace_type(privilege_list => xs$name_list('use_client_certificates', 'use_passwords'), principal_name => 'user_name', principal_type => xs_acl.ptype_db));
END;
/
```
  - Append the wallet ACE.
## Troubleshooting Transport Layer Security Errors
Oracle provides a utility to help troubleshoot PKI certificate configurations as well as additional guidance below. A utility is available through the support website to review and provide feedback on your PKI certificate authentication client and server configuration.
See DBSecChk Utility 2.0.0.5 (Doc ID 3066006.1).
- Step 1: Check the TLS Connection with the tnsping Utility A successful connection using the tnsping utility shows that the database service has been registered to the listener on the TCPS endpoint.
- Step 2: Check the TLS_VERSION Parameter An incorrectly set TLS_VERSION parameter can cause Transport Layer Security (TLS) problems.
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_VERSION` and `SSL_VERSION` parameters are configured, then the `SSL_VERSION` parameter is ignored.
- Step 3: Check the Wallet File Permissions The Transport Layer Security (TLS) connection requires the database and listener to have access to the auto-login wallet file (cwallet.sso).
````
- Step 4: Check the Wallet Settings in the sqlnet.ora and listener.ora Files Transparent Layer Security (TLS) problems can arise from wallet and certificate configuration errors in the sqlnet.ora and listener.ora files.
**
- [Step 5: Enable Tracing for the SQLNet and Listener Connections](#GUID-49936D5A-BB02-40DF-9C16-D816BB536569) In the sqlnet.ora file, you can enable tracing for SQLNet and listener connections.
### Step 1: Check the TLS Connection with the tnsping Utility
A successful connection using the `tnsping` utility shows that the database service has been registered to the listener on the TCPS endpoint.
```
tnsping net_service_name [count]
```
```
tnsping sales count
```
``````
  - net_service_name (sales) is the service name that is specified in the tnsnames.ora file, or it can be the name service that is in use, such as NIS.
  - count, which is optional, determines how many times the program attempts to reach the server.
Output similar to the following appears:
```
TNS Ping Utility for Linux: Version 23.0.0.0.0 - Production on 26-APR-2023 18:21:47 Copyright (c) 1997, 2023, Oracle. All rights reserved.
Used parameter files:
$ORACLE_HOME/network/admin/sqlnet.ora Used TNSNAMES adapter to resolve the alias Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCPS)(HOST = host_name)(PORT = port)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = sales))) OK (30 msec)
```
If the test fails with an `TNS-12560: NS:protocol adapter error` error, then ensure that the lines in the `sqlnet.ora` and `listener.ora` files do not have leading spaces. If the connection still has errors, then you must investigate further, such as checking the permissions of wallet files or other settings.
See *Oracle Database Net Services Administrator’s Guide* for detailed information about using the `tnsping` utility.
### Step 2: Check the TLS_VERSION Parameter
An incorrectly set `TLS_VERSION` parameter can cause Transport Layer Security (TLS) problems.
You should ensure that the `TLS_VERSION` parameter in the server and client `sqlnet.ora` file is set to the correct version of TLS, so that connections can be established. For example:
```
TLS_VERSION=(1.3)
```
By default, Oracle Database uses the most secure protocol that is available when `TLS_VERSION` is not set.
See *Oracle Database Net Services Reference* to learn more about how to set the `TLS_VERSION` parameter for the correct version of TLS.
### Step 3: Check the Wallet File Permissions
The Transport Layer Security (TLS) connection requires the database and listener to have access to the auto-login wallet file (`cwallet.sso`).
In the case of an Oracle Real Application Clusters (Oracle RAC) database, both the Grid Infrastructure Oracle Home owner and the Database Oracle Home owner must have access to the contents of a `cwallet.sso` file containing the correct certificates. Quite often the configuration implies the usage of the same `cwallet.sso` file for both environments, in which case the permissions should be set appropriately so that both users can have access to the file no matter who is the owner of the file.
By default, the wallet permissions are as follows:
```
$ ls -ltr -rw-------. 1  ewallet.p12 -rw-------. 1  cwallet.sso
```
If the `cwallet.sso` file will be used by the Grid Infrastructure Oracle Home owner (usually `grid`) then user `grid` must be a member of the `oinstall` group. You can change the permissions as follows:
```
$ chmod 640 cwallet.sso $ ls -ltr -rw-------. 1 oracle oinstall 75 Mar 6 10:47 ewallet.p12 -rw-r-----. 1 oracle oinstall 120 Mar 6 10:47 cwallet.sso
```
### Step 4: Check the Wallet Settings in the sqlnet.ora and listener.ora Files
Transparent Layer Security (TLS) problems can arise from wallet and certificate configuration errors in the `sqlnet.ora` and `listener.ora` files.
These settings enable you to encrypt the connections between the database and its clients. (Another way to handle this encryption is with the external network services PL/SQL packages, `UTL_SMTP`, `UTL_HTTP`, and `UTL_TCP`.)
Note the following:
****````
- For the server: Set the WALLET_ROOT parameter. (The WALLET_LOCATION parameter can still be used.) Both trusted certificate and server certificate are required.
****````
- For the client: Set the WALLET_LOCATION in sqlnet.ora. Only trusted certificates are required if one-way TLS is configured. If mTLS is configured, then both trusted certificate and server certificate are required.
****````
- For the listener: Set the WALLET_LOCATION parameter in the listener.ora file. Both trusted certificate and server certificate are required.
An example `WALLET_LOCATION` parameter setting is as follows:
```
WALLET_LOCATION = (SOURCE = (METHOD = FILE) (METHOD_DATA = (DIRECTORY = wallet_location) ) )
```
The certificates can be self-signed or they can be signed by a third-party authority.
You can use the `orapki wallet display -wallet` command to view the contents of a wallet to find if it has self-signed certificates. For example:
```
$ orapki wallet display -wallet .
Requested Certificates:
User Certificates:
Subject: C=US,CN=MYROOT Trusted Certificates:
Subject: C=US,CN=MYROOT
```
The following example shows the output for a wallet that has wallet that has certificates that were provided by a third-party authority:
```
Requested Certificates:
User Certificates:
Subject: CN=*.us.example.com,O=Example Corporation,L=Redwood City,ST=California,C=US Trusted Certificates:
Subject: CN=DigiCert Global Root CA,O=DigiCert Inc,C=US Subject: CN=DigiCert TLS RSA SHA256 2020 CA1,O=DigiCert Inc,C=US
```
### Step 5: Enable Tracing for the SQL*Net and Listener Connections
In the `sqlnet.ora` file, you can enable tracing for SQL*Net and listener connections.
For example, to enabling tracing for SQL*Net:
```
TRACE_LEVEL_CLIENT=SUPPORT TRACE_DIRECTORY_CLIENT=trace_dir TRACE_LEVEL_SERVER=SUPPORT TRACE_DIRECTORY_SERVER=trace_dir DIAG_ADR_ENABLED=OFF
```
For the listener, you can set the following tracing parameters:
```
TRACE_FILE_LISTENER = LISTENER.TRC TRACE_DIRECTORY_LISTENER = trace_dir TRACE_LEVEL_LISTENER = SUPPORT TRACE_FILELEN_LISTENER = 10240 TRACE_FILENO_LISTENER=10
```
The following output indicates that the TLS connection failed because the wrong TLS protocol was used. To find how to address these errors, see My Oracle Support note 244527.1.
```
[] ntzdosecneg: entry [] nttrd: entry [] nttrd: socket 13 had bytes read=11 [] nttrd: exit [] ntzdosecneg: SSL handshake failed with error 29019. [] ntzdosecneg: exit [] ntzcontrol: failed with error 542 [] ntzcontrol: exit [] nserror: entry [] nserror: nsres: id=0, op=79, ns=12561, ns2=0; nt[0]=0, nt[1]=0, nt[2]=0; ora[0]=0, ora[1]=0, ora[2]=0 [] nsclose: entry [] nsvntx_dei: entry [] nsvntx_dei: exit
```
See Troubleshooting the Transport Layer Security Configuration for information about common error codes.
See also *Oracle Database Net Services Administrator’s Guide* for more information about using trace settings to track connections.
