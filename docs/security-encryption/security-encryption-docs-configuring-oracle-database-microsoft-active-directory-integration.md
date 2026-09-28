# Configuring the Oracle Database-Microsoft Active Directory Integration

Before you can use Microsoft Active Directory to authenticate and authorize users, you must configure the connection from the Oracle database to Active Directory.
- About Configuring the Oracle Database-Microsoft Active Directory Connection Before you configure this connection, you must have Microsoft Active Directory installed and configured.
- Connecting to Microsoft Active Directory You can configure a Microsoft Active Directory connection during the Oracle database creation or with an existing Oracle database.
## About Configuring the Oracle Database-Microsoft Active Directory Connection
Before you configure this connection, you must have Microsoft Active Directory installed and configured.
You must create an Oracle service directory user in Active Directory, configure the Oracle Database connection to Active Directory, and then depending on the authentication type, configure the database and Active Directory for password, Kerberos, or public key infrastructure (PKI) authentication. Before you map Database users and global roles to Active Directory users and groups, you must ensure that the Active Directory users and groups have been created. You will map the database users and global roles to Active Directory users and groups by using the `CREATE USER`, `CREATE ROLE`, `ALTER USER`, `ALTER ROLE` SQL statements with the `GLOBALLY` clause. An Active Directory system administrator must also set up new Active Directory groups with Active Directory users to meet your requirements.
The Active Directory system administrator is responsible for setting Active Directory connections with or without SASL bind. The Oracle Database will automatically try the Active Directory connection first with SASL bind and if it fails, it will try it without SASL bind but still secured with TLS. This means that regardless of how the Microsoft Active Directory administrator may have the SASL settings configured on Active Directory, the Oracle database will connect even if the SASL bind is unsuccessful.
## Connecting to Microsoft Active Directory
You can configure a Microsoft Active Directory connection during the Oracle database creation or with an existing Oracle database.
- Step 1: Create an Oracle Service Directory User Account on Microsoft Active Directory and Grant Permissions The Oracle service directory user account is for the interaction between Oracle Database and the LDAP directory service.
- Step 2: For Password Authentication, Install the Password Filter and Extend the Microsoft Active Directory Schema You can use the Oracle opwdintg.exe executable on the Active Directory server to install the password filter and extend the Active Directory schema.
- Step 3: If Necessary, Install the Oracle Database Software If you have not done so yet, then use Oracle Universal Installer (OUI) to install the Oracle software.
````
- Step 4: Create the dsi.ora or ldap.ora File The dsi.ora and ldap.ora files specify connections for centrally managed users for Active Directory.
````
- Step 5: Request an Active Directory Certificate for a Secure Connection After you have configured the dsi.ora or ldap.ora file, you are ready to prepare Microsoft Active Directory and Oracle Database certificates for a secure connection.
- Step 6: Create the Wallet for a Secure Connection After you have copied the Active Directory certificate, you are ready to add it to the Oracle wallet.
- Step 7: Configure the Microsoft Active Directory Connection Next, you are ready to connect the database to Active Directory using the settings you have so far.
- Step 8: Verify the Oracle Wallet The orapki utility can verify that the wallet for this database was created successfully.
``````
- Step 9: Test the Integration To test the integration, you must set the ORACLE_HOME, ORACLE_BASE, and ORACLE_SID environment variables and then verify the LDAP parameter settings.
### Step 1: Create an Oracle Service Directory User Account on Microsoft Active Directory and Grant Permissions
The Oracle service directory user account is for the interaction between Oracle Database and the LDAP directory service.
In addition to being used for the Oracle Database-to-LDAP directory service interaction, the Oracle service directory user account can be used for Kerberos.
This account is an Active Directory user account that Oracle Database uses to bind to Active Directory domain controllers and query for users and groups information from Active Directory, update login success or failure, and if Kerberos is configured, update Kerberos authentication. The minimum permissions required for this account are `Read properties` (of Active Directory users who will log in to a database) permission, and if database password authentication is to be used by Active Directory users, the `Write lockoutTime` (property of the Active Directory users) permission, and `Control Access` (of the `orclCommonAttribute` property of the Active Directory users) permission.
- Log in to a Windows domain controller of Microsoft Active Directory as an administrator who has administrative privileges to create a user account and grant permissions to the user account.
  - If all the Active Directory users will be in one domain, then create this account in that domain. Doing so will help performance.
    - The domain chosen must be trusted by all other domains.
    - The service user must be able to bind to all of these multiple Windows domains, and must be able to access the properties of Active Directory users in all of these multiple Windows domains with the granted permissions.
    - All other domains must support simple bind over TLS/SSL to allow the access of the service user from the trusted domain.
    - All other domains administrators must grant the required minimum permissions to the service user account from the trusted domain.
  - Read properties (of Active Directory users who will log in to an Oracle database)
  - Write lockoutTime (property of Active Directory users who will use password authentication to log in to an Oracle database)
````
  - Control Access (of the orclCommonAttribute property of the Active Directory users who will use password authentication to log in to an Oracle database)
### Step 2: For Password Authentication, Install the Password Filter and Extend the Microsoft Active Directory Schema
You can use the Oracle `opwdintg.exe` executable on the Active Directory server to install the password filter and extend the Active Directory schema.
You do not need to perform this step if your authentication method is Kerberos or SSL. The `opwdintg.exe` executable installs the Oracle password filter, extends the Active Directory schema, and creates Active Directory groups to allow Oracle Database password authentication with Active Directory. This procedure adds an `orclCommonAttribute` property to the Active Directory schema for user accounts.
**Note:**  You must install the Oracle password filter on **every** Windows domain controller in a domain, to ensure that Oracle password verifiers will be generated for Active Directory users in this domain if they need to use password authentication to log in Oracle database. Note also that `orclCommonAttribute` stores Oracle password verifier for the Active Directory user. This attribute is also used for password authentication by other Oracle products or features such as Enterprise User Security. For security consideration, you should deny everyone except the Oracle service directory user from accessing the `orclCommonAttribute` property.
****
  - If you have a My Oracle Support account: Log in to your account at My Oracle Support and then search for Doc ID https://support.oracle.com/epmos/faces/DocumentDisplay?id=2462012.1. Download opwdintg.exe from this location. This version is the latest version.
****
  - If you do not have a My Oracle Support account: Register for a My Oracle Support account so that you can download the latest version of opwdintg.exe from Doc ID https://support.oracle.com/epmos/faces/DocumentDisplay?id=2462012.1.
``````
- Using a secure method of copying (such as sftp), copy opwdintg.exe to a temporary directory (for example, C:\temp) on each Windows domain controller.
- Connect to each Windows domain controller as the Active Directory administrator. Currently, the opwdintg.exe utility requires English for the Windows OS.
- Ensure that the Windows OS language setting is English.
````
  - Open the Windows Explorer and then double click the opwdintg.exe utility.
  - Navigate to the directory where the opwdintg.exe utility is located. For example:
```
cd c:\temp
```
  - Execute the utility from the command line by typing the following command:
```
.\opwdintg.exe
```
****
  - Do you want to extend AD schema? [Yes/No]: Enter Yes. Extending the Active Directory schema requires the Windows OS language setting to be English.
****
  - You can only extend the Active Directory schema one time. If you try to extend the schema again, error messages appear, but you can ignore these errors.
  - ORA_VFR_MD5 is required when the Oracle Database WebDAV client is used.
  - ORA_VFR_11G enables the use of the Oracle Database 11G password verifier.
  - ORA_VFR_12C enables the use of the Oracle Database 12C password verifier.
  - Unless you have backed up the Active Directory schema, once extended, the Active Directory schema extension cannot be reverted.
The next two prompts depend on whether the password filter has been installed already.
****
````
  - Found password filter installed already. Do you want to deinstall? [Yes/No]: This prompt appears if the password filter has already been installed. In most cases, enter No to not deinstall the filter. If you enter Yes to deinstall the password filter, then you must re-run opwdintg.exe to re-install the password filter after you complete these prompts. Otherwise, after you restart the computer, the password verifiers will be no longer be generated when Active Directory users change their passwords.
****
  - Do you want to install Oracle password filter? [Yes/No]: This prompt appears if the password filter has not been installed yet. Enter Yes.
****
  - The change requires machine reboot. Do you want to reboot now? [Yes/No]: Enter Yes.
### Step 3: If Necessary, Install the Oracle Database Software
If you have not done so yet, then use Oracle Universal Installer (OUI) to install the Oracle software.
You only need to install the Oracle Database software, not the full database. After you install the Oracle database software, you can configure centrally managed users with Active Directory during database creation by using Database Configuration Assistant (DBCA). You can also configure centrally managed users with Active Directory using DBCA or manually after database creation.
  **- Follow the instructions in the Oracle Database Installation Guide for your platform to install the Oracle software.
After you install the Oracle database software, then you can configure centrally managed users with Active Directory during database creation using DBCA. You can also configure centrally managed users with Active Directory using DBCA or manually after the database creation.
### Step 4: Create the dsi.ora or ldap.ora File
The `dsi.ora` and `ldap.ora` files specify connections for centrally managed users for Active Directory.
``````
- Comparison of the dsi.ora and ldap.ora Files How you use the dsi.ora and ldap.ora depends on how ldap.ora is used with other services.
- About Using a dsi.ora File You use a dsi.ora file to specify Active Directory servers for centrally managed users.
- Creating the dsi.ora File The dsi.ora configuration file sets the information to find the Active Directory servers for centrally managed users.
- About Using an ldap.ora File You can use an ldap.ora file to specify Active Directory servers for centrally managed users.
- Creating the ldap.ora File These steps assume that ldap.ora is not being used for net naming services and can be used to set up the connection with Active Directory for centrally managed users.
#### Comparison of the dsi.ora and ldap.ora Files
How you use the `dsi.ora` and `ldap.ora` depends on how `ldap.ora` is used with other services.
The `dsi.ora` file specifies connections for centrally managed users for Active Directory. The `ldap.ora` file can also specify the connection to the Active Directory server. However, because each individual PDB cannot have its own `ldap.ora`, and also `ldap.ora` may already be used (or may be used in the future) for other services like net naming services, Oracle recommends the use of `dsi.ora` for centrally managed users.
#### About Using a dsi.ora File
You use a `dsi.ora` file to specify Active Directory servers for centrally managed users.
You must manually create the `dsi.ora` file to identify the Active Directory servers. The `dsi.ora` file provides Active Directory connection information for all pluggable databases if it is located in the same places where the `ldap.ora` file can be placed. A `dsi.ora` file in a PDB-specific wallet location takes precedence over the main `dsi.ora` file for that PDB only.
**Note:**  If you are using `ldap.ora` for naming services, then do not make any changes to `ldap.ora` for the CMU with Active Directory configuration. Only use `dsi.ora` to configure CMU-Active Directory.
**Placement of dsi.ora** Oracle recommends that you use directories for writable files under `$ORACLE_BASE`, not under `$ORACLE_HOME`. Starting with Oracle Database 18c, you can optionally set the `$ORACLE_HOME` directory to be read-only. Hence, you should place the `dsi.ora` file in a directory that is outside of `$ORACLE_HOME` to accommodate the `dsi.ora` configuration for future releases.
**Search Order for dsi.ora** When you create the `dsi.ora` file, Oracle Database searches for it in the following order:
````````
- If the WALLET_LOCATION setting is included in the sqlnet.ora file, then for a non-multitenant database or the root container of a multitenant database, Oracle searches for it in the location that is specified in sqlnet.ora. For a PDB of a multitenant database, Oracle searches for it in the per-PDB wallet location that is in the WALLET_LOCATION_specified_in_sqlnet.ora/pdb_guid directory.
````
- If the WALLET_LOCATION setting is not included in the sqlnet.ora file, then Oracle Database searches for it in the default wallet location.
````
  - $LDAP_ADMIN environment variable setting
  - $ORACLE_HOME/ldap/admin directory
  - $TNS_ADMIN environment variable setting
  - $ORACLE_HOME/network/admin directory
**When to Use dsi.ora**
Oracle recommends that you use only `dsi.ora` to identify the Active Directory servers for centrally managed users. If both `dsi.ora` and `ldap.ora` are configured in the same database for centrally managed users for Active Directory and are both located in the same directory, then `dsi.ora` takes precedence over the `ldap.ora` file. If they are in different directories, then Oracle uses the first one that it finds in the location precedence list above to find the Active Directory server. If the directory server type in the first found `dsi.ora` or `ldap.ora` is not Active Directory, then centrally managed users will **not** be enabled.
**Using dsi.ora in a Multitenant Environment**
You can specify `dsi.ora` files for individual PDBs in a multitenant database. A PDB-specific `dsi.ora` will override the common settings in the shared `dsi.ora` or `ldap.ora` for that one PDB. Different PDBs can connect to different Active Directory servers for CMU. The `dsi.ora` file for an individual PDB is located in the same directory as the wallet for that PDB.
When the `WALLET_LOCATION` parameter in the `sqlnet.ora` file is set, then the `dsi.ora` file for an individual PDB will be in the per-PDB wallet in the `WALLET_LOCATION_specified_in_sqlnet.ora/pdb_guid/` directory.
When the `WALLET_LOCATION` parameter in the `sqlnet.ora` file is not set, then the default wallet location for an individual container in a multitenant database is the `$ORACLE_BASE/admin/db_unique_name/pdb_guid/wallet/` directory. For each PDB to use the default wallet location, you must not set `WALLET_LOCATION` in `sqlnet.ora`.
To find the `db_unique_name`, connect to the CDB root and execute the following query:
```
SELECT DB_UNIQUE_NAME FROM V$DATABASE;
```
To find the `pdb_guid`, from the CDB root, execute the following query:
```
SELECT PDB_NAME,GUID FROM DBA_PDBS;
```
**How the WALLET_LOCATION Parameter in sqlnet.ora Affects dsi.ora**
Setting or not setting the `WALLET_LOCATION` parameter in `sqlnet.ora` has the following effects:
````````
- If WALLET_LOCATION is not set in sqlnet.ora, then you can also place dsi.ora in the default wallet directory for the CDB root container, located in the $ORACLE_BASE/admin/db_unique_name/wallet directory. However, this will only connect the CDB root container to the Active Directory, not the entire CDB database.
``````
- If WALLET_LOCATION is set in sqlnet.ora, then you can place the dsi.ora in that wallet location, and this will also only connect the CDB root container to the Active Directory, not the entire CDB database.
**Changing the Contents of dsi.ora**
If you change the contents of `dsi.ora` after the database has been started, then you must either restart the database instance or re-execute the following DDL to make the updated content in `dsi.ora` effective:
```
ALTER SYSTEM SET LDAP_DIRECTORY_ACCESS = 'PASSWORD';
```
In a multitenant environment, you should set the `LDAP_DIRECTORY_ACCESS` parameter in each PDB, not in the CDB root.
#### Creating the dsi.ora File
The `dsi.ora` configuration file sets the information to find the Active Directory servers for centrally managed users.
To use the `dsi.ora` configuration file:
- Log in to the host where the Oracle database is located.
``````
- Choose a directory where to use the dsi.ora file, based on the search order for the dsi.ora file. (See Related Topics.) If this directory does not exist, then create the directory. Then go to this directory to create the dsi.ora file.
```
DSI_DIRECTORY_SERVERS = (AD-server.production.examplecorp.com:389:636, sparky.production.examplecorp.com:389:636)
```
  - Using a load balancer in front of the Active Directory domain servers
  - Listing each Active Directory domain server by host name or IP address in a list
  - Using a domain name that returns a different Active Directory domain server
Using a load balancer is the preferred choice, especially if you already use one for the Active Directory domain servers. The load balancer enables you to manage and add or subtract Active Directory domain servers behind the load balancer without having to make any changes to the `dsi.ora` file. Specifying a list of Active Directory domain servers is quicker and less expensive, but it ties you to the Active Directory domain servers so changes (new or dropped servers) must be reflected in `dsi.ora`. Using a domain name offers some high availability and failover, but it is not an ideal solution. The DNS will need to return different servers instead of the same server every time. CMU will try the first returned server from a domain name look-up and if that fails, then the authentication will fail. However, using domain names gives you some ability to use different Active Directory domain servers without having to specify the list of servers in `dsi.ora`.
****
```
DSI_DEFAULT_ADMIN_CONTEXT = "OU=sales,DC=production,DC=examplecorp,DC=com"
```
  - DSI_DEFAULT_ADMIN_CONTEXT, which sets the search base where the Active Directory users and groups are located. This parameter is optional. By default, Oracle locates Active Directory users and groups in Active Directory’s default naming context. Oracle recommends that you do not set this parameter. Set this parameter only if you want to limit the search scope for Active Directory users and groups. For example:
````
```
DSI_DIRECTORY_SERVER_TYPE = AD
```
  - DSI_DIRECTORY_SERVER_TYPE, which determines the Active Directory server access. You must set it to AD for Active Directory. Enter this value in upper case.
#### About Using an ldap.ora File
You can use an `ldap.ora` file to specify Active Directory servers for centrally managed users.
If you are already using an `ldap.ora` file for another purpose such as net naming services, then you must use the `dsi.ora` file to configure centrally managed users to connect with Active Directory for user authentication and authorization. Even if Active Directory is already being used for net naming services, then you must create and use a `dsi.ora` file to identify the Active Directory servers for centrally managed users. Even if the database currently is not using `ldap.ora` for another service, Oracle recommends using `dsi.ora` in case `ldap.ora` will be used at a future time for net naming services.
If `ldap.ora` is being used for naming services, then do not make any changes to `ldap.ora`. Only use `dsi.ora` to configure CMU-Active Directory.
**Benefit of Using ldap.ora**
The benefit of using `ldap.ora` is that you can use the DBCA graphical interface or the DBCA silent mode to complete configuring the connection to the Active Directory servers. When using `dsi.ora`, the steps to complete configuring the connection to Active Directory must be done separately.
**Placement of ldap.ora**
Typically, the `ldap.ora` file is stored in the `$ORACLE_HOME/network/admin` directory. Usually, the `ldap.ora` file cannot be in the same directory as the `WALLET_LOCATION` that is specified in the `sqlnet.ora` file, unless the `WALLET_LOCATION` is set to `$ORACLE_HOME/network/admin`.
**Search Order for ldap.ora**
After you create the `ldap.ora` file, Oracle Database searches for it in the following order:
- $LDAP_ADMIN environment variable setting
- $ORACLE_HOME/ldap/admin directory
- $TNS_ADMIN environment variable setting
- $ORACLE_HOME/network/admin directory
**Changing the Contents of ldap.ora**
If you change the contents of `ldap.ora` after the database has been started, then you must either restart the database instance or re-execute the following DDL to make the updated content in `ldap.ora` effective:
```
ALTER SYSTEM SET LDAP_DIRECTORY_ACCESS = 'PASSWORD';
```
In a multitenant environment, set the `LDAP_DIRECTORY_ACCESS` parameter in each PDB, not in the CDB root.
#### Creating the ldap.ora File
These steps assume that `ldap.ora` is not being used for net naming services and can be used to set up the connection with Active Directory for centrally managed users.
- Log in to the host where the Oracle database is located.
``````
- Choose a directory where to use the ldap.ora file, based on the search order for the ldap.ora file. (See Related Topics.) If this directory does not exist, then create the directory. Then go to this directory to create the ldap.ora file.
````
- If the ldap.ora file does not exist, then create it by using a text editor. If the ldap.ora file does exist, create a backup of this file, and then open ldap.ora.
```
DIRECTORY_SERVERS = (AD-server.production.examplecorp.com:389:636, sparky.production.examplecorp.com:389:636)
```
  - DIRECTORY_SERVERS, which sets the Active Directory server host and port number, and alternate directory servers. You can also have multiple Active Directory servers here if you want to use multiple Windows domains. The directory server name must be a fully qualified name. For example:
****
```
DEFAULT_ADMIN_CONTEXT = "OU=sales,DC=production,DC=examplecorp,DC=com"
```
  - DEFAULT_ADMIN_CONTEXT, which sets the search base where the Active Directory users and groups are located. This parameter is optional. By default, Oracle locates Active Directory users and groups in the Active Directory’s default naming context. Oracle recommends that you do not set this parameter. Set this parameter only if you want to limit the search scope for Active Directory users and groups. For example:
````
```
DIRECTORY_SERVER_TYPE = AD
```
  - DIRECTORY_SERVER_TYPE, which determines the LDAP server access. You must set it to AD for Active Directory. Enter this value in upper case.
### Step 5: Request an Active Directory Certificate for a Secure Connection
After you have configured the `dsi.ora` or `ldap.ora` file, you are ready to prepare Microsoft Active Directory and Oracle Database certificates for a secure connection.
  - Request the Active Directory certificate from an Active Directory administrator.
### Step 6: Create the Wallet for a Secure Connection
After you have copied the Active Directory certificate, you are ready to add it to the Oracle wallet.
````
  - $ORACLE_BASE/admin/db_unique_name/wallet/
  - $ORACLE_HOME/admin/db_unique_name/wallet/
For a PDB in a multitenant database:
  - $ORACLE_BASE/admin/db_unique_name/pdb_guid/wallet/
  - $ORACLE_HOME/admin/db_unique_name/pdb_guid/wallet/
Oracle recommends that for each individual container in a multitenant database, you place the wallet files in the default wallet location under `$ORACLE_BASE`, that is, in the `$ORACLE_BASE/admin/db_unique_name/pdb_guid/wallet/` directory.
To find the `db_unique_name`, connect to the CDB root and execute the following query:
```
SELECT DB_UNIQUE_NAME FROM V$DATABASE;
```
```
To find the `pdb_guid`, from the CDB root, execute the following query:
```
```
SELECT PDB_NAME,GUID FROM DBA_PDBS;
```
```
If you are using `sqlnet.ora` to specify the wallet location, then the wallet location specified is for a non-multitenant database, or the root container of a multitenant database. For each PDB of the multitenant database, its wallet is located at `WALLET_LOCATION_specified_in_sqlnet.ora/pdb_guid`. You can also place an individual PDB `dsi.ora` in `WALLET_LOCATION_specified_in_sqlnet.ora/pdb_guid`.
```
- Create a new wallet. The following command creates an auto-login wallet in the specified path.
```
orapki wallet create -wallet path_of_wallet -auto_login Enter password: password
```
- Create an entry in wallet with the user name of the Oracle service directory user account for performing searches in Active Directory (created in the first step). For example:
```
mkstore -wrl path_of_wallet -createEntry ORACLE.SECURITY.USERNAME oracle
```
- Create an entry in wallet with the DN of the Oracle service directory user account. For example:
```
mkstore -wrl path_of_wallet -createEntry ORACLE.SECURITY.DN cn=oracle,cn=users,dc=production,dc=examplecorp,dc=com
```
```
In this example, the `DN` indicates that the DNS domain is `production.examplecorp.com`. The Windows domain name is just `production`.
```
- Create an entry in wallet with the user password credential of the Oracle service directory user account. For example:
```
mkstore -wrl path_of_wallet -createEntry ORACLE.SECURITY.PASSWORD password
```
- Add the certificate to the wallet. Use the Active Directory certificate that you received from the Active Directory administrator. For example:
```
orapki wallet add -wallet path_of_wallet -cert /tmp/AD_CA_Root_cert.txt -trusted_cert
```
```
If `WALLET_LOCATION` is specified in `sqlnet.ora`, then you must add Active Directory certificates to the PDB specific wallet location (that is, `WALLET_LOCATION_specified_in_sqlnet.ora/pdb_guid`, for each individual PDB). You can also add the Active Directory certificate to the `WALLET_LOCATION_specified_in_sqlnet.ora`. However, it will only be effective for the root container, not for the entire CDB.
```
- Verify the credentials. For example:
```
orapki wallet display -wallet path_of_wallet
```
```
The output should be similar to the following:
```
```
Requested Certificates:
User Certificates:
Oracle Secret Store entries:
ORACLE.SECURITY.DN ORACLE.SECURITY.PASSWORD ORACLE.SECURITY.USERNAME Trusted Certificates:
Subject: CN=ADSVR,DC=production,DC=examplecorp,DC=com
```
```
Changes to the wallet take effect immediately and do not require a database restart.
```
### Step 7: Configure the Microsoft Active Directory Connection
Next, you are ready to connect the database to Active Directory using the settings you have so far.
- About Configuring the Microsoft Active Directory Connection To configure the Microsoft Active Directory connection, you can set the parameters in the database or use DBCA.
- Configuring the Access Manually Using Database System Parameters You can configure the Active Directory services connection manually by using LDAP-specific Oracle Database system parameters.
- Configuring the Access Using the Database Configuration Assistant GUI Oracle Database Configuration Assistant (DBCA) completes the LDAP connection configuration and automatically creates the wallet and stores the Active Directory certificate for use. DBCA only works when ldap.ora is configured for CMU-Active Directory.
````
- Configuring the Access Using Database Configuration Assistant Silent Mode Assuming ldap.ora (not dsi.ora) has been created in the correct location and configured properly, DBCA silent mode can create a new database or alter an existing database for the Microsoft Active Directory-Oracle Database integration.
#### About Configuring the Microsoft Active Directory Connection
To configure the Microsoft Active Directory connection, you can set the parameters in the database or use DBCA.
DBCA only recognizes the `ldap.ora` that is configured for centrally managed users, and only creates the wallet in the recommended default location. To use the default wallet locations, you must **not** set `WALLET_LOCATION` in `sqlnet.ora`.
**Note:**   Oracle recommends using `dsi.ora` for CMU-Active Directory.
#### Configuring the Access Manually Using Database System Parameters
You can configure the Active Directory services connection manually by using LDAP-specific Oracle Database system parameters.
````
- Ensure that you have created the dsi.ora file or the ldap.ora file, and that you have created the wallet.
- Log in to the database instance as a user who has the ALTER SYSTEM system privilege. For example, in a non-multitenant database:
```
sqlplus sec_admin Enter password: password
```
```
In a multitenant environment, log in to the appropriate PDB.
```
```
sqlplus sec_admin@pdb_name Enter password: password
```
```
To find the available PDBs in a CDB, log in to the CDB root container and then query the `PDB_NAME` column of the `DBA_PDBS` data dictionary view. To check the current container, run the `show con_name` command.
```
``````
- Modify the LDAP_DIRECTORY_ACCESS parameter, which determines the type of LDAP directory access. If you are using a multitenant environment, then set LDAP_DIRECTORY_ACCESS in each PDB, not in the CDB root. Setting this parameter in the CDB root will apply it only to the root, not to the PDBs. Valid values are PASSWORD and NONE (to disable the connection). PASSWORD requires an Active Directory server certificate and when you create the wallet, you must include the credentials for the Active Directory service user account for Oracle. For example:
```
ALTER SYSTEM SET LDAP_DIRECTORY_ACCESS = 'PASSWORD';
```
```
You can also set this parameter in the spfile or in the `init.ora` file (if the `init.ora` file is used). Afterward, restart the database.
```
````````````````
- Set the LDAP_DIRECTORY_SYSAUTH parameter to YES, so that administrative users from Active Directory can log in to Oracle Database with the SYSDBA, SYSOPER, SYSBACKUP, SYSDG, SYSKM, or SYSRAC administrative privilege. Set LDAP_DIRECTORY_SYSAUTH in each PDB, not in the CDB root. Setting this parameter in the CDB root will apply it only to the root, not to the PDBs. If you set this parameter to NO, then centrally managed users from Active Directory cannot log in to Oracle database with these privileges.
```
ALTER SYSTEM SET LDAP_DIRECTORY_SYSAUTH = YES SCOPE=SPFILE ;
```
```
You can also set this parameter in the spfile or in the `init.ora` file (if the `init.ora` file is used). Afterward, restart the database.
```
  - If you are in a non-multitenant environment, then restart the database:
```
SHUTDOWN IMMEDIATE STARTUP
```
```
- If you are in a multitenant environment, then close and re-open the PDB:
```
```
ALTER PLUGGABLE DATABASE pdb_name CLOSE IMMEDIATE;
ALTER PLUGGABLE DATABASE pdb_name OPEN;
```
After you restart the database or re-open the PDB, you can log in with the `SYSDBA` administrative privilege and check the LDAP parameters settings as follows:
```
show parameter ldap
```
#### Configuring the Access Using the Database Configuration Assistant GUI
Oracle Database Configuration Assistant (DBCA) completes the LDAP connection configuration and automatically creates the wallet and stores the Active Directory certificate for use. DBCA only works when `ldap.ora` is configured for CMU-Active Directory.
These instructions assume that you have already installed the Oracle software and that you are using an `ldap.ora` file (not `dsi.ora`) to identify the Active Directory servers for the centrally managed users. If you have not installed the database software yet, then you can install the software using Oracle Universal Installer (OUI). After that, use DBCA to create the database, and at the same time you can configure the connection for Active Directory centrally managed users.
- Log in to the host where the Oracle database software is installed as a user who has administrative privileges.
````
- Start DBCA. By default, the DBCA utility is located in the $ORACLE_HOME/bin directory. For example:
```
cd $ORACLE_HOME/bin
./dbca
```
````
- Select the Network Configuration option (or when you get to the Network Configuration option when creating the database). The Specify Network Configuration Details window appears. If the Directory Service Integration area is not visible, then the ldap.ora file was not configured correctly. Check the ldap.ora configuration that you did earlier, and after you have corrected the file, rerun DBCA.
****
  - In the Service username field, enter the name of the Oracle service directory user account.
****
  - In the Password field, enter the password of the Oracle service directory user account.
****
  - In the Service user DN field, enter the DN for the Oracle service directory user account. The DN can be retrieved directly from the Active Directory server or from an Active Directory system administrator.
************````````
  - For Access Type, select the type of authentication from the list (for example, PASSWORD). (This setting sets the LDAP_DIRECTORY_ACCESS parameter.) If necessary, select the Allow admin privileges authentication checkbox, which allows Active Directory users to authenticate and use database schemas with administrative privileges (for example, SYSDBA, SYSOPER, SYSBACKUP, and so on). Otherwise, centrally managed users from Active Directory cannot log in to the database with administrative privileges. (This setting corresponds to the LDAP_DIRECTORY_SYSAUTH parameter.)
****
  - Provide the path to the Active Directory certificate in the Certificate file location field. In a multitentant environment, DBCA recognizes and sets up Active Directory connections for the database instance connection. You must manually configure PDB connections if you want to connect a different Active Directory server to a PDB.
********
  - In the Wallet password and Confirm password fields, enter and confirm the password for the Oracle wallet that will store the certificate and credential of the Oracle service directory user account. Afterward, DBCA automatically validates the service directory user account, creates the wallet, stores the user credential, and imports the certificate.
****
- Click Next until you reach the Finish page.
****
- Click Finish.
#### Configuring the Access Using Database Configuration Assistant Silent Mode
Assuming `ldap.ora` (not `dsi.ora`) has been created in the correct location and configured properly, DBCA silent mode can create a new database or alter an existing database for the Microsoft Active Directory-Oracle Database integration.
- Log in to the host that will have the Oracle database to be used for the integration.
- Make sure ldap.ora is created with the correct content in a correct location.
````
- Make sure that the WALLET_LOCATION parameter is not specified in the sqlnet.ora file.
- Run Database Configuration Assistant (DBCA) in silent mode. For example, to create a single instance non-multitenant database:
```
cd $ORACLE_HOME/bin
./dbca -silent -createDatabase -gdbName inst1.production.examplecorp.com
-templateName General_Purpose.dbc -totalMemory 1000
-registerWithDirService true
-dirServiceUser oracle
-dirServiceUserName cn=oracle,cn=users,dc=production,dc=examplecorp,dc=com
-dirServicePassword service_user_password
-ldapDirectoryAccessType PASSWORD
-useSysAuthForLDAPAccess true
-dirServiceCertificatePath /tmp/AD_CA_Root_cert.txt
-walletPassword wallet_password
-sysPassword sys_password
-systemPassword system_password
```
```
To configure the root container of a CDB or a non-multitenant database:
```
```
cd $ORACLE_HOME/bin
./dbca -silent -configureDatabase -sourceDB db_name
-registerWithDirService true
-dirServiceUser oracle
-dirServiceUserName cn=oracle,cn=users,dc=production,dc=examplecorp,dc=com
-dirServicePassword service_user_password
-ldapDirectoryAccessType PASSWORD
-useSYSAuthForLDAPAccess true
-dirServiceCertificatePath /tmp/AD_CA_Root_cert.txt
-walletPassword wallet_password
```
```
To configure a pluggable database in a CDB:
```
```
cd $ORACLE_HOME/bin
./dbca -silent -configurePluggableDatabase -pdbName pdb_name -sourceDB db_name
-registerWithDirService true
-dirServiceUser oracle
-dirServiceUserName cn=oracle,cn=users,dc=production,dc=examplecorp,dc=com
-dirServicePassword service_user_password
-dirServiceCertificatePath /tmp/AD_CA_Root_cert.txt
-walletPassword wallet_password
```
### Step 8: Verify the Oracle Wallet
The `orapki` utility can verify that the wallet for this database was created successfully.
- Log in to the host where a database is used in the integration.
````
````
  - For the CDB root, the wallet is in the $ORACLE_BASE/admin/db_unique_name/wallet/ directory.
  - For a PDB, the wallet is in the $ORACLE_BASE/admin/db_unique_name/pdb_guid/wallet/ directory.
````
- At the command line, enter the following commands: ls -ltr wallet_location (to check that the wallet directory contains wallet files) For example:
```
$ ls -ltr $ORACLE_BASE/admin/db_unique_name/pdb_guid/wallet/ total 12 -rw------- 1 creator_user creator_group 1597 Nov 27 22:47 cwallet.sso -rw------- 1 creator_user creator_group 1552 Nov 27 22:47 ewallet.p12 -rw-rw-r-- 1 creator_user creator_group 86   Nov 27 22:48 dsi.ora
```
```
`orapki wallet display -wallet wallet_location` (to find the Oracle Secret Store entries) The output should contain the following entries:
```
```
Requested Certificates:
User Certificates:
Oracle Secret Store entries:
ORACLE.SECURITY.DN ORACLE.SECURITY.PASSWORD ORACLE.SECURITY.USERNAME Trusted Certificates:
Subject: CN=ADSVR,DC=production,DC=examplecorp,DC=com
```
### Step 9: Test the Integration
To test the integration, you must set the `ORACLE_HOME`, `ORACLE_BASE,` and `ORACLE_SID` environment variables and then verify the LDAP parameter settings.
- Log in to the host where a database is used for the integration.
``````
- Set the ORACLE_HOME, ORACLE_BASE, and ORACLE_SID environment variables. For example:
```
export ORACLE_HOME=/app/product/18.1/dbhome_1
export ORACLE_BASE=/app
export ORACLE_SID=sales_db
```
- Log in to the database instance as a user who has the SYSDBA administrative privilege. For example:
```
sqlplus sec_admin as sysdba
Enter password: password
```
```
In a multitenant environment, log in to the appropriate PDB. For example:
```
```
sqlplus sec_admin@pdb_name as sysdba
Enter password: password
```
```
To find the available PDBs in a CDB, log in to the CDB root container and then query the `PDB_NAME` column of the `DBA_PDBS` data dictionary view. To check the current container, run the `show con_name` command.
```
  - Check the LDAP parameter settings:
```
show parameter ldap
```
```
The output should be similar to the following:
```
```
NAME                          TYPE       VALUE
---------------------------   ---------  -----------------
ldap_directory_access         string     PASSWORD
ldap_directory_sysauth        string     YES
```
## Related Topics
  - About Using an ldap.ora File
  - About Using an ldap.ora File
  - Management of Certificate Revocation Lists (CRLs) with orapki Utility
  - Configuring the Access Using Database Configuration Assistant Silent Mode
  - Step 4: Create the dsi.ora or ldap.ora File
  - Configuring the Access Using Database Configuration Assistant Silent Mode
