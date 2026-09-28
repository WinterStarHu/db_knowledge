# Enabling Distinguished Name (DN) Matching

DN matching allows a connection to the Oracle Database server when the server certificate name or DN matches what the client expects.
**Tip:** Oracle strongly recommends using either partial or full DN matching so the client connects to the correct host.
When DN matching is enabled, the listener certificate and the database server certificate will both be checked against the certificate expected by the client. Without using DN matching, any server certificate signed by the same or valid public CA will be accepted by the client to establish the TLS session.
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both the `TLS_` and `SSL_` versions of a parameter are configured, then the `SSL_` version is ignored.
It is recommended to first successfully configure TLS in a test environment prior to setting up DN matching. See Configuring TLS Using a Public Certificate Authority Root of Trust for the Database Server Certificate.
**To enable DN Matching:**
``````
```
TLS_SERVER_DN_MATCH = TRUE
```
```
TLS_CLIENT_AUTHENTICATION = FALSE WALLET_LOCATION = (SOURCE= (METHOD=File) (METHOD_DATA= (DIRECTORY=wallet_location))) TLS_SERVER_DN_MATCH = TRUE
```
- Set the TLS_SERVER_DN_MATCH parameter to TRUE in the sqlnet.ora file: The sqlnet.ora file will look similar to:
**Note:**  Only completing this step will result in partial DN matching. Perform step three to establish full DN matching.
Partial DN matching will check the host parameter value in the connect string against the certificate’s common name (CN). If a match isn’t found, the client will then compare the host parameter value against the entries in the certificate’s Subject Alternate Name (SAN) field. If there are no matches, the connection will be refused.
``````````
```
$ORACLE_HOME/network/admin/
```
  - Linux:
```
ORACLE_BASE\ORACLE_HOME\network\admin\
```
  - Windows:
````
****````
```
finance= (DESCRIPTION= (ADDRESS_LIST= (ADDRESS=(PROTOCOL = tcps)(HOST = finance) (PORT = 1575))) (CONNECT_DATA= (SERVICE_NAME= finance.us.example.com)) (SECURITY= (TLS_SERVER_DN_MATCH = TRUE) (TLS_SERVER_CERT_DN="cn=finance,cn=OracleContext,c=us,o=example")))
```
- If you can’t use partial DN matching, then configure full DN matching by setting the TLS_SERVER_CERT_DN parameter connection string in the tnsnames.ora file: Note: If you can’t set the host value in tnsnames.ora or sqlnet.ora to the value of the certificate common name (CN) or one of the entries in the SAN field, then consider using full DN matching. Both the listener and server certificate will be checked with both partial and full DN matching. When using full DN matching, while the server and listener certificate can be different, their DN must be the same for the connection to succeed. The tnsnames.ora file will look similar to:
