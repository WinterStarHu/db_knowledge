# Configuring SQL*Plus for Azure AD Access Tokens

You must configure SQL*Plus to retrieve the Azure AD database access token from a location and use it when the `/` slash login is used.
Only the latest SQL*Plus and Instant Client will work with Azure AD `OAuth2` tokens. There is no default location for the Azure AD token, so you must specify this location.
- Ensure that you have an Azure AD user account.
  - An application client ID that you can use to get Azure AD tokens. If you have Azure AD privileges to do so, then create your own client app registration, similar to registering the Oracle Database instance with an Azure AD tenancy.
  - You are mapped to a global schema in the database.
- Ensure that you are using the latest release updates for the Oracle Database client releases 19c. This configuration only works with the Oracle Database client release 19c.
- Follow the existing process to download the wallet from the Oracle Database instance and then follow the directions for configuring it for use with SQL*Plus.
****``````````
  - Check for the parameter TLS_SERVER_DN_MATCH = ON to ensure that DN matching is enabled.
````
```
TOKEN_AUTH=OAUTH TOKEN_LOCATION="token_location"
```
``````````
  - Set the TOKEN_AUTH parameter to enable the client to use the Azure AD token. Include the TOKEN_LOCATION parameter to point to the token location. For example: Note that there is no default location. If the token is named token, then you only need to specify the file directory (for example, /test/oracle/aad-token). If the token name is different from token (for example, azure.token), then you must include this name in the path (for example, /test/oracle/aad-token/azure.token).
You can specify the `TOKEN_AUTH` and `TOKEN_LOCATION` parameters in `tnsnames.ora`, as well as in `sqlnet.ora`. The `TOKEN_AUTH` and `TOKEN_LOCATION` values in the `tnsnames.ora` connect strings take precedence over the `sqlnet.ora` settings for that connection. For example:
```
(description=
  (retry_count=20)(retry_delay=3)
  (address=(protocol=tcps)(port=1522)
  (host=example.us-phoenix-1.oraclecloud.com))
  (connect_data=(service_name=aaabbbccc_exampledb_high.example.oraclecloud.com))
  (security=(tls_server_cert_dn="CN=example.uscom-east-1.oraclecloud.com,
     OU=Oracle BMCS US, O=Example Corporation,
     L=Redwood City, ST=California, C=US")
  (TOKEN_AUTH=OAUTH)(TOKEN_LOCATION="/test/oracle/aad-token"))
```
After the connect string is updated with the `TOKEN_AUTH` and `TOKEN_LOCATION` parameters, the Azure user can log in to the Oracle Database instance by running the following command to start SQL*Plus. You can include the connect descriptor itself or use the name of the descriptor from the `tnsnames.ora` file.
```
connect /@exampledb_high
```
Or the user can use the connect string. For example:
```
connect /@(description=
  (retry_count=20)(retry_delay=3)
  (address=(protocol=tcps)(port=1522)
  (host=example.us-phoenix-1.oraclecloud.com))
  (connect_data=(service_name=aaabbbccc_exampledb_high.example.oraclecloud.com))
  (security=(tls_server_cert_dn="CN=example.uscom-east-1.oraclecloud.com,
     OU=Oracle BMCS US, O=Example Corporation,
     L=Redwood City, ST=California, C=US") (TOKEN_AUTH=OAUTH)(TOKEN_LOCATION="/test/oracle/aad-token")
```
The database client is already configured to get an Azure `OAuth2` token because `TOKEN_AUTH` has already been set, either through the `sqlnet.ora` file or in a connect string. The database client gets the `OAuth2` token and then sends the token to the Oracle Database instance.
## Related Topics
  - Registering the Oracle Database Instance with a Microsoft Azure AD Tenancy
