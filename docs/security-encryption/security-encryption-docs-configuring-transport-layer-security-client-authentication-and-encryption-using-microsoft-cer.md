# Configuring Transport Layer Security for Client Authentication and Encryption Using Microsoft Certificate Store

To perform this configuration with Microsoft Certificate Store (MCS), you use the `orapki` command-line tool to generate certificates and manipulate the Oracle wallets.
This configuration can be used with the next-generation cryptographic provider or the legacy provider. The Microsoft Certificate Store wallet configuration is the same, but protocol and algorithm support differs by provider. Use TLS 1.2 for compatibility between providers. Use the next-generation provider when TLS 1.3 is required, and ensure that certificates do not use MD5 or SHA-1 signatures.
Use the following provider order when configuring Microsoft Certificate Store:
****````````
- Next-generation cryptographic provider: Use this workflow for new configurations. Create wallets and certificates with orapki, use SHA-256 or stronger signing algorithms, configure TLS_VERSION and TLS_CIPHER_SUITES for TLS 1.2 or TLS 1.3, and configure TLS_KEY_EXCHANGE_GROUPS when TLS 1.3 is enabled. The next-generation provider supports Microsoft Certificate Store certificates whose private keys are stored in a Microsoft CNG key storage provider.
****
- Legacy provider: Use the same Microsoft Certificate Store and wallet workflow for existing legacy environments, but configure only TLS versions and cipher suites that the legacy provider supports. TLS 1.3 and TLS_KEY_EXCHANGE_GROUPS are not available.
- About Configuring Transport Layer Security for Client Authentication and Encryption Using Microsoft Certificate Store This type of configuration is the foundation of the Common Access Cards and PIV cards authentication.
- Step 1: Create and Configure the Server Wallet You must use orapki to create a server wallet and the server’s self-signed certificate.
- Step 2: Create and Configure the Client Wallet You must use orapki to create a client wallet and a certificate request.
- Step 3: Create an External User in the Oracle Database You must create an external user to be used with the client and server connection.
- Step 4: Configure the Server listener.ora File Next, you must check and then restart the server listener.ora file.
- Step 5: Configure the Server sqlnet.ora File You must ensure that the sqlnet.ora file points to the server wallet that you created earlier.
- Step 6: Import the Client Wallet into the Microsoft Certificate Store You must use the Microsoft Management Console (MMC) to perform this import operation.
- Step 7: Configure the Client sqlnet.ora File You must configure the client sqlnet.ora file to use Microsoft Certificate Store for the client wallet.
````
- Step 8: Configure the Oracle Database In the Oracle database, configure the OS_AUTHENT_PRE and REMOTE_OS_AUTH parameters.
- Step 9: Test the Client and Server Connection After you complete the Microsoft Certificate Store configuration, you should test the client and server connection.
## About Configuring Transport Layer Security for Client Authentication and Encryption Using Microsoft Certificate Store
This type of configuration is the foundation of the Common Access Cards and PIV cards authentication.
As long as the software libraries that are delivered with the Common Access Cards and PIV cards are capable of transparently loading the necessary certificates into the Microsoft Certificate Store, then the Transport Layer Security (TLS) authentication that you configure will be transparently performed.
It is important to note that all the signing certificates of the user certificate that is loaded to the PIV card must be manually loaded into the server’s wallet as part of the TLS configuration at the server level.
## Step 1: Create and Configure the Server Wallet
You must use `orapki` to create a server wallet and the server’s self-signed certificate.
For the next-generation cryptographic provider, use a supported signature algorithm such as SHA-256 or stronger when creating certificates. For the legacy provider, the same `orapki` wallet creation workflow applies, but TLS 1.3 certificate and key exchange settings do not apply.
- Log in to the Oracle Database server.
```
mkdir /home/oracle/wallet_tls/server
```
- Create a directory for the server wallet. For example:
```
cd /home/oracle/wallet_tls/server
```
- Go to this directory.
```
orapki wallet create -wallet . -auto_login -pwd password
```
- Create the server wallet.
```
ls -la
```
```
total 16 drwxr-xr-x. 2 oracle oinstall 4096 Oct 28 07:18 .
drwxr-xr-x. 6 oracle oinstall 4096 Oct 28 07:17 ..
-rw-------. 1 oracle oinstall 120 Oct 28 07:18 cwallet.sso -rw-rw-rw-. 1 oracle oinstall 0 Oct 28 07:18 cwallet.sso.lck -rw-------. 1 oracle oinstall 75 Oct 28 07:18 ewallet.p12 -rw-rw-rw-. 1 oracle oinstall 0 Oct 28 07:18 ewallet.p12.lck
```
- Check the directory. For example: Output similar to the following appears:
```
orapki wallet add -wallet . -dn "cn=server" -self_signed -keysize 2048 -sign_alg sha256 -validity 365 -pwd password
```
- Create the server’s self-signed certificate.
## Step 2: Create and Configure the Client Wallet
You must use `orapki` to create a client wallet and a certificate request.
For the next-generation cryptographic provider, create the client certificate request with supported key sizes and a supported signing algorithm. For the legacy provider, create the client wallet with the existing legacy wallet workflow.
- Log in to the Oracle Database client.
```
mkdir /home/oracle/wallet_tls/client
```
- Create a directory for the client wallet. For example:
```
cd /home/oracle/wallet_tls/client
```
- Go to this directory.
```
orapki wallet create -wallet . -auto_login -pwd password
```
- Create the client wallet.
```
orapki wallet add -wallet . -dn "cn=client" -keysize 2048 -sign_alg sha256 -pwd password orapki wallet export -wallet . -dn "cn=client" -request req.txt -pwd password
```
- Create a request for a user certificate and export the request.
```
cp req.txt ../server/ cd ../server/
```
- Copy the certificate request from the client directory to the server directory. For example:
```
orapki cert create -wallet . -request req.txt -cert sign.txt -validity 1000 -pwd password orapki wallet export -wallet . -dn "cn=server" -cert server.txt cp server.txt ../client cp sign.txt ../client orapki wallet add -wallet . -trusted_cert -cert server.txt -pwd password orapki wallet add -wallet . -user_cert -cert sign.txt -pwd password cp sign.txt server.txt ../client/ cd ../client
```
- Sign the certificate of the client and also export server’s CA certificate. For example:
## Step 3: Create an External User in the Oracle Database
You must create an external user to be used with the client and server connection.
- As a user who can create users and grant them privileges, log in to the PDB that will use this external user account.
```
CREATE USER tlsuser IDENTIFIED EXTERNALLY AS 'cn=client';
```
```
CREATE USER tlsuser IDENTIFIED EXTERNALLY AS 'cn=client' WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
**
```
CREATE USER tlsuser IDENTIFIED EXTERNALLY AS '' WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
- Create the external user. For example: To map the user to a certificate thumbprint, add the WITH THUMBPRINT clause. To identify the user only by the certificate thumbprint, enable thumbprint-only authentication and specify an empty certificate DN. For more information about PKI_CERT_AUTH_METHOD, see the Oracle Database Reference.
```
GRANT CONNECT TO tlsuser;
```
- Grant this account the CONNECT privilege.
## Step 4: Configure the Server listener.ora File
Next, you must check and then restart the server `listener.ora` file.
For the next-generation cryptographic provider, ensure that the listener TCPS endpoint uses TLS versions and cipher suites supported by the next-generation cryptographic provider. For the legacy provider, use TLS versions and cipher suites supported by the legacy provider.
- Log in to the Oracle Database server.
```
cat /u01/app/oracle/product/release/dbhome_1/network/admin/listener.or
```
```
LISTENERBOS = (DESCRIPTION_LIST = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = domain.com)(PORT = 1529)) ) (DESCRIPTION = (ADDRESS = (PROTOCOL = TCPS)(HOST = domain.com)(PORT = 1530)) ) ) WALLET_LOCATION = (SOURCE = (METHOD = File) (METHOD_DATA = (DIRECTORY = /home/oracle/wallet_tls/server))
```
- Check the server listener.ora file to ensure that it is correctly configured. For example: Output similar to the following appears:
```
su - oracle ./lsnrctl start
```
```
Listener Parameter File /u01/app/oracle/product/release/dbhome_1/network/admin/listener.ora Listener Log File /u01/app/oracle/diag/tnslsnr/service/instance/alert/log.xml Listening Endpoints Summary...
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=domain.com)(PORT=1523))) (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=domain.com)(PORT=1525))) Services Summary...
Service "service" has 1 instance(s).
Instance "instance", status READY, has 1 handler(s) for this service...
Service "serviceDB" has 1 instance(s).
Instance "instance", status READY, has 1 handler(s) for this service...
The command completed successful
```
- Restart the listener and check if the database is registered to this listener. Output similar to the following appears:
## Step 5: Configure the Server sqlnet.ora File
You must ensure that the `sqlnet.ora` file points to the server wallet that you created earlier.
For the next-generation cryptographic provider, add provider-compatible `TLS_VERSION` and `TLS_CIPHER_SUITES` settings, and add `TLS_KEY_EXCHANGE_GROUPS` if you enable TLS 1.3. For the legacy provider, use provider-supported `TLS_VERSION` and `TLS_CIPHER_SUITES` values and omit TLS 1.3 key exchange groups.
- Log in to the Oracle Database server.
****``````````
```
NAMES.DIRECTORY_PATH=(TNSNAMES) SQLNET.AUTHENTICATION_SERVICES=(BEQ,TCPS) TLS_CLIENT_AUTHENTICATION = TRUE WALLET_LOCATION = (SOURCE = (METHOD = FILE) (METHOD_DATA = (DIRECTORY = /home/oracle/wallet_tls/server) ) )
```
- Check the sqlnet.ora file to ensure that it points to the server wallet. Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both TLS_CLIENT_AUTHENTICATION and SSL_CLIENT_AUTHENTICATION parameters are configured, then the SSL_CLIENT_AUTHENTICATION parameter is ignored. For example:
## Step 6: Import the Client Wallet into the Microsoft Certificate Store
You must use the Microsoft Management Console (MMC) to perform this import operation.
- Start the MMC (mmc.exe).
********
- Select File, then add/remove snap-in.
********
- Select Certificates, then Add.
************
- Select My user account, then Finish, and then OK.
****************
- Go to the Console Root, then Certificates Current User, then Personal, then Certificates.
****************
- Right-click All Tasks, then select Import, then Next, then Browse.
- Select the certificate file that contains the certificate needed for the connection (for example, ewallet.p12).
********
- Select Open, then Next.
- Enter the wallet password.
****
- Select the Mark this as exportable checkbox.
****
- Select the Include all extended properties checkbox.
****
- Select Place all certificates in the following store: Personal.
********
- Select Next, then Finish.
********************
- Ensure that the client’s certificate was added to the MY store, by going to Console Root, and then selecting Certificates Current User, then Personal, then Certificates.
********************
- Ensure that the CA certificates were added to the ROOT store by going to Console Root, and then selecting Certificates Current User, then Trusted Root Certification Authorities, then Certificates.
## Step 7: Configure the Client sqlnet.ora File
You must configure the client `sqlnet.ora` file to use Microsoft Certificate Store for the client wallet.
For the next-generation cryptographic provider, configure the client with the same TLS version, cipher suite, and TLS 1.3 key exchange policy as the server. For the legacy provider, configure only TLS versions and cipher suites that the legacy provider supports.
- Log in to the Oracle Database client.
```
WALLET_LOCATION = (SOURCE = (METHOD=MCS))
```
- Check the client side sqlnet.ora file. For example:
## Step 8: Configure the Oracle Database
In the Oracle database, configure the `OS_AUTHENT_PRE` and `REMOTE_OS_AUTH` parameters.
````
```
ALTER SYSTEM SET REMOTE_OS_AUTHENT=FALSE SCOPE=SPFILE;
ALTER SYSTEM SET OS_AUTHENT_PREFIX='' SCOPE=SPFILE;
```
- Set the OS_AUTHENT_PRE and REMOTE_OS_AUTH parameters.
  - Restart the database instance.
## Step 9: Test the Client and Server Connection
After you complete the Microsoft Certificate Store configuration, you should test the and server connection.
```
trace_level_client=16
trace_directory_client=trace_directory
DIAG_ADR_ENABLED=OFF
```
- To verify that the MCS is used for the TLS connection, enable the client trace by adding the following lines in the client’s sqlnet.ora file.
```
nztwOpenWallet: [enter]
nztwOpenWallet: WRL mcs:, type = 24
nztwOpenWallet: Loading the EXTKS provider for MCS type wallet
nztwOpenWallet: [exit] OK
```
- Make a connection to the server using SQL*Plus and then ensure that the certificates are loaded successfully from MCS.
