# Configuring TLS Connection With a Client Wallet

A client wallet is sometimes required when configuring TLS with a public or self-signed CA trust certificate.
A client wallet for a TLS connection includes the trust certificate for the certificate authority that signed the database server certificate. Only the root of trust certificate is required. Intermediate certificates are not required.
Using a client wallet is required if you cannot use the system’s default certificate store.
```
orapki wallet create -wallet  -pwd  -auto_login
```
- Create the client wallet.
```
orapki wallet export -wallet  -dn  -cert
```
- Get the CA trusted certificate. This may already be available in a file or you may need to export it from the root certificate wallet or a database server wallet. For more information see orapki Utility Commands Summary.
```
orapki wallet add -wallet  -trusted_cert -cert
```
- Add the CA trusted certificate into the client wallet.
- Move or copy the client wallet to the desired location.
````
``````
```
WALLET_LOCATION=
    (SOURCE=
        (METHOD=file)
        (METHOD_DATA=
            (DIRECTORY=/etc/oracle/wallets/databases)))
```
**
- Update sqlnet.ora to add WALLET_LOCATION for the client wallet. This will be used by all client connections unless this is overridden by the connect string parameter WALLET_LOCATION. When WALLET_LOCATION is not set in sqlnet.ora or the connect string, then the client will check the system’s default certificate store. See WALLET_LOCATION in the Oracle Database Net Services Reference guide for more information.
## (Optional) Set TLS_CLIENT_AUTHENTICATION for the Client
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
