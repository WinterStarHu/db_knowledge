# Configuring TLS Using a Public Certificate Authority Root of Trust for the Database Server Certificate

Before you can configure TLS without using client wallets, you must first create the server wallet and ensure that the database and listener are properly configured.
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
## Database server configuration for TLS
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both the `TLS_` and `SSL_` versions of a parameter are configured, then the `SSL_` version is ignored.
- Log in to the server where the Oracle database resides.
``````
``````
````
```
TLS_CLIENT_AUTHENTICATION=FALSE
```
- Check that TLS_CLIENT_AUTHENTICATION in the sqlnet.ora file is set to FALSE as this enables one-way TLS: By default, the sqlnet.ora file is located in the $ORACLE_HOME/network/admin directory or in the location set by the TNS_ADMIN environment variable. When using read-only Oracle home, the default location for sqlnet.ora is $ORACLE_HOME/network/admin. You may set this to OPTIONAL instead which enables both TLS and mTLS and is dependent on whether the client sends the client user certificate.
## Listener configuration for TLS
````
````
```
LISTENER = (ADDRESS=(PROTOCOL=tcps)(HOST=)(PORT=1522))
```
- Check the PROTOCOL parameter in the listener.ora file to ensure TLS is specified. By default, listener.ora is located in the $ORACLE_HOME/network/admin directory. The parameter PROTOCOL=tcps tells the listener to only use TLS (or mTLS) for database connections. For example:
````
```
WALLET_LOCATION=
    (SOURCE=
        (METHOD=file)
        (METHOD_DATA=
            (DIRECTORY=$WALLET_DIR//tls)))
```
````
- Ensure that the listener wallet exists in the location of the WALLET_LOCATION parameter in the listener.ora file. Use the same wallet as you did for the database server. If the listener is on the same server as the database server and the server TLS wallet is in the default location, set the listener WALLET_LOCATION to the same location. Alternatively, the server wallet can be copied to a different location for the listener. If you set the TLS_SERVER_DN_MATCH parameter to TRUE for DN matching (partial or full DN match), then the hostname or DN check will happen against both the listener certificate and the server certificate. They don’t have to be the same certificate, but matching will be done with both certificates.
``````
```
TLS_CLIENT_AUTHENTICATION=FALSE
```
- Ensure the TLS_CLIENT_AUTHENTICATION parameter is set to FALSE in listener.ora file to disable mutual TLS.
**Note:**  If the listener supports multiple databases, some with one-way TLS and some with mTLS, then set `TLS_CLIENT_AUTHENTICATION=OPTIONAL`.
## Client Configuration for TLS
### Configure Client Connect String for TLS
Add the parameter `protocol=tcps` in the connect string to enforce TLS from the client. The connection will use TLS from the client to the listener.
```
(description=
    (address=
        (protocol=tcps)
        (port=1522)
        (host=example.com))
    (connect_data=
    (service_name=dbservicename.example.com)))
```
**Note:** `protocol=tcps` parameter is not available in `sqlnet.ora`.
### (Optional) Set TLS_CLIENT_AUTHENTICATION for the Client
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CLIENT_AUTHENTICATION` and `SSL_CLIENT_AUTHENTICATION` parameters are configured, then the `SSL_CLIENT_AUTHENTICATION` parameter is ignored.
- If you have a client-side user certificate, but don’t want to use it for mTLS, then you must complete this step.
- If you don’t have a client-side user certificate, you can skip this step as the client will go ahead and make a one-way TLS connection regardless of this parameter setting.
- Log in to the client for the Oracle database.
``````
```
TLS_CLIENT_AUTHENTICATION=FALSE
```
````````
- Set TLS_CLIENT_AUTHENTICATION in the sqlnet.ora file to FALSE. Setting this parameter in sqlnet.ora to FALSE, will block sending a client side user certificate for all the connections. You can override this for a particular connection by setting TLS_CLIENT_AUTHENTICATION=TRUE in the connection string in tnsnames.ora so that connection will use the client-side user certificate. The connection string parameter will take precedence over the sqlnet.ora parameter setting. This setting is optional and only required if you have a client-side user certificate and you don’t want to use it for an mTLS connection.
``````
- In order to preserve existing mTLS connections that use the client-side wallet and user certificate and also to establish one-way TLS connection without using the user certificate, set TLS_CLIENT_AUTHENTICATION=TRUE, which is the default setting, in sqlnet.ora. Then for every connection that you want to use without a client-side user wallet, add TLS_CLIENT_AUTHENTICATION=FALSE in the connect string.
## Connect to the database
Connect to the database using the connection name with the tcps protocol.
```
sqlplus @
```
## Verify the connection
```
select sys_context ('userenv','NETWORK_PROTOCOL') from dual;
```
- Run the following command: This will show ‘tcps’ if TLS is enabled and ‘tcp’ if TLS is not enabled.
```
select sys_context ('userenv','TLS_VERSION') from dual;
```
- Run the following command: This will show the TLS protocol for the connection ending at the database server.
```
select sys_context ('userenv','TLS_CIPHERSUITE') from dual;
```
- Run the following command: This will show the TLS ciphersuite for the connection ending at the database server.
