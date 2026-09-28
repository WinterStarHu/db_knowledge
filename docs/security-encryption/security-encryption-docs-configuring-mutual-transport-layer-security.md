# Configuring Mutual Transport Layer Security (mTLS)

In traditional Transport Layer Security (TLS), only the server authenticates to the client by presenting its certificate. With mutual Transport Layer Security (mTLS), both the server and the client present their certificates so that they are mutually authenticated.
The `TLS_CLIENT_AUTHENTICATION` parameter controls whether the client certificate needs to be authenticated. This doesn’t authenticate or authorize the end user. It authenticates that the certificates used by both the server and client are valid and signed by a known certificate authority (CA). Configuring PKI Certificate Authentication goes into detail about end-user authentication using PKI certificates.
The default for `TLS_CLIENT_AUTHENTICATION` is `TRUE` for the database server, listener, and client, which will require mTLS (mutual TLS requiring a client certificate in a client wallet). Settings are as follows:
````
- OFF/FALSE disables mTLS, which enables one-way TLS.
````
- ON/TRUE enables mTLS. If it is set to On/TRUE on the server, one-way TLS will be disabled. If it is set to On/TRUE on the client, the client will try to establish mTLS; however, one-way TLS is still allowed if the server is configured with one-way TLS.
  - If the client sends a certificate, the connection will be completed as an mTLS connection after the client certificate is authenticated.
  - If the client does not send a certificate, then the connection will be completed as a one-way TLS connection.
- Server Certificate DN Matching Oracle recommends using Server certificate DN matching, similar to using server DN matching with one-way TLS, to ensure the client is connecting to the intended server.
## Create the Server and Listener Wallet
To get a certificate signed by a publicly signed certificate authority, you must create the database server and listener wallet and export a certificate signing request (CSR).
- Login to the host where the database is installed.
```
orapki wallet create -wallet  -pwd  -auto_login
```
- Create the wallet.
```
orapki wallet add -wallet  -trusted_cert -cert /rootCA.crt -pwd
```
- Add the trusted root certificate to the wallet (get this from your certificate administrator).
```
orapki wallet add -wallet  -keysize 2048 -dn  -pwd
```
- Create a private key and certificate request in the wallet.
```
orapki wallet export -wallet  -dn  -request /.csr -pwd
```
- Export the certificate request to get it signed.
```
orapki wallet display -wallet
```
- Display the contents of the wallet. There will be an entry under Requested Certificates.
```
cat /.csr
```
- View the contents of the CSR (certificate signing request) file.
- Send the CSR file to your certificate administrator to have it signed by the root certificate authority (CA) or an intermediate CA.
```
orapki wallet add -wallet  -user_cert -cert /.crt -pwd
```
- Import the signed database server user certificate into the database wallet.
```
orapki wallet display -wallet
```
- Display the contents of the wallet:
- Ensure that the database server user certificate is now displayed under User Certificates. The wallet you will use for the database server and listener is now ready to be deployed for use.
## Set WALLET_ROOT and deploy the database server wallet
```
SHOW PARAMETER WALLET_ROOT
```
````
- Check to see if WALLET_ROOT already exists. Login as a user with privileges to check system parameters and run: If WALLET_ROOT is not already setup, run the next command to create WALLET_ROOT.
```
alter system set wallet_root = '' scope=spfile;
```
- Create WALLET_ROOT, a system parameter. Run the following SQL command:
- Reboot the database.
```
show parameter wallet_root;
```
- Show the modified wallet_root parameter. Run the following SQL command:
````
```
mkdir -p -v //tls
```
```
select guid from v$containers;
```
- If the TLS directory does not yet exist under WALLET_ROOT, create a directory for TLS under your WALLET_ROOT PDB directory in the operating system. You can find the PDB GUID for your PDB by running the following SQL command:
```
sudo chown oracle:oinstall -R -v //tls
```
- Change ownership of the directory.
```
cp ./ewallet.p12 ./cwallet.sso //tls
```
- Copy the database server ewallet.p12 and the cwallet.sso files to this new tls directory. Perform this command from the same directory where the wallets were created:
## Database server configuration for mTLS
- Log in to the server where the Oracle database resides.
``````
``````
****``````````
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
- Check that TLS_CLIENT_AUTHENTICATION in the sqlnet.ora file is set to TRUE as this enables mTLS: By default, the sqlnet.ora file is located in the $ORACLE_HOME/network/admin directory or in the location set by the TNS_ADMIN environment variable. Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both the TLS_ and SSL_ versions of a parameter are configured, then the SSL_ version is ignored. You may set this to OPTIONAL instead which enables both TLS and mTLS and is dependent on whether the client sends the client user certificate.
## Listener configuration for mTLS
````
````
```
LISTENER = (ADDRESS=(PROTOCOL=tcps)(HOST=)(PORT=1522))
```
- Check the PROTOCOL parameter in the listener.ora file to ensure TLS is specified. By default, listener.ora is located in the $ORACLE_HOME/network/admin directory. The parameter PROTOCOL=tcps tells the listener to only use TLS (or mTLS) for database connections. For example:
````
```
WALLET_LOCATION= (SOURCE= (METHOD=file) (METHOD_DATA= (DIRECTORY=$WALLET_DIR//tls)))
```
````
- Ensure that the listener wallet exists in the location of the WALLET_LOCATION parameter in the listener.ora file. Use the same wallet as you did for the database server. If the listener is on the same server as the database server and the server TLS wallet is in the default location, set the listener WALLET_LOCATION to the same location. Alternatively, the server wallet can be copied to a different location for the listener. If you set the TLS_SERVER_DN_MATCH parameter to TRUE for DN matching (partial or full DN match), then the hostname or DN check will happen against both the listener certificate and the server certificate. They don’t have to be the same certificate, but matching will be done with both certificates.
``````
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
- Ensure the TLS_CLIENT_AUTHENTICATION parameter is set to TRUE in listener.ora file to enable mutual TLS.
## Client Configuration for mTLS
- Log in to the client for the Oracle database.
````````
````````
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
- Set TLS_CLIENT_AUTHENTICATION in the sqlnet.ora and tnsnames.ora files to TRUE. A setting of TRUE, will send a client side user certificate to the server. Because this applies to every connection, you can change the TLS_CLIENT_AUTHENTICATION parameter in the tnsnames.ora connection string using the same parameter setting which will take precedence over the sqlnet.ora setting.
**Tip:** While the default value for this parameter is true, setting it explicitly to true will make troubleshooting connection problems easier.
````
  - Specify a common mTLS client wallet by setting WALLET_LOCATION in sqlnet.ora. This will result in every mTLS connection using the same client wallet to connect with their database.
  - Set TLS_CLIENT_AUTHENTICATION = FALSE to override the mTLS client wallet setting.
  - Set WALLET_LOCATION = SYSTEM to specify the system default certificate store.
````
    - Set WALLET_LOCATION = SYSTEM in sqlnet.ora to allow the TLS connections to connect without using a wallet.
    - Set the WALLET_LOCATION for every mTLS connection to specify the unique wallet location for each connection.
**Related Topics**
  - Oracle Wallet Location
## Connect to the database
Connect to the database using the connection name with the tcps protocol.
```
sqlplus @
```
## Server Certificate DN Matching
Oracle recommends using Server certificate DN matching, similar to using server DN matching with one-way TLS, to ensure the client is connecting to the intended server.
Configure full DN matching by setting the `TLS_SERVER_CERT_DN` parameter connection string in the `tnsnames.ora` file:
**Note:**
If you can’t set the host value in `tnsnames.ora` or `sqlnet.ora` to the value of the certificate common name (CN) or one of the entries in the SAN field, then consider using full DN matching.
Both the listener and server certificate will be checked with both partial and full DN matching. When using full DN matching, while the server and listener certificate can be different, their DN must be the same for the connection to succeed.
The `tnsnames.ora` file will look similar to:
```
finance= (DESCRIPTION= (ADDRESS_LIST= (ADDRESS=(PROTOCOL = tcps)(HOST = finance) (PORT = 1575))) (CONNECT_DATA= (SERVICE_NAME= finance.us.example.com)) (SECURITY= (TLS_SERVER_DN_MATCH = TRUE) (TLS_SERVER_CERT_DN="cn=finance,cn=OracleContext,c=us,o=example")))
```
