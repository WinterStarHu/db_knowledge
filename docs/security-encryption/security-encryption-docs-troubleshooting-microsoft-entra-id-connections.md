# Troubleshooting Microsoft Azure AD Connections

You can use trace files to diagnose problems with Microsoft Azure AD connections. You also can easily remedy `ORA-12599` and `ORA-03114` errors.
- Trace Files for Troubleshooting Oracle Database Client Connections with Azure AD You can use trace files to troubleshoot the Oracle Database integration with Microsoft Azure AD.
````
- ORA-12599 and ORA-03114 Errors Caused When Trying to Access a Database Using a Token The ORA-12599: TNS: cryptographic checksum mismatch and ORA-03114: not connected to ORACLE errors indicate that the database to which you are trying to connect is protected by native network encryption.
- Checking the Azure AD Access Token Version You can check the version of the Microsoft Azure AD access token that your site uses by using the JSON Web Tokens web site.
## Trace Files for Troubleshooting Oracle Database Client Connections with Azure AD
You can use trace files to troubleshoot the Oracle Database integration with Microsoft Azure AD.
- About Trace Files Used for Troubleshooting Connections You can generate two levels of trace files to troubleshoot Microsoft Azure AD connections on client side.
````
- Setting Client Tracing for Token Authentication You can add EVENT settings to the client-side sqlnet.ora file to control client tracing.
### About Trace Files Used for Troubleshooting Connections
You can generate two levels of trace files to troubleshoot Microsoft Azure AD connections on client side.
The two levels of trace files that you can generate are as follows:
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both the `TLS_` and `SSL_` versions of a parameter are configured, then the `SSL_` version is ignored.
  - If TCPS is not set up for the Azure AD connection, then it prints a message that the protocol has to be TCPS.
``````
  - If TLS_SERVER_DN_MATCH is not set to TRUE, then it prints a message that the value is FALSE.
  - If TOKEN_LOCATION has not been specified, then it prints a message that the token location does not exist.
  - If the token is not present at the specified TOKEN_LOCATION, then it prints a message.
  - If the application has passed in the token without setting OCI_ATTR_TOKEN_ISBEARER to true, it prints a message for the missing attribute.
````
  - If the application has set OCI_ATTR_TOKEN_ISBEARER to TRUE and not passed in the token, it prints a message for the missing attribute.
  - If the token has expired, then it prints a message.
``````````
  - It prints where TLS_SERVER_DN_MATCH is present, tnsnames.ora or sqlnet.ora. It also prints the value as TRUE if set to TRUE.
  - If both the token and OCI_ATTR_TOKEN_ISBEARER=true are set by the application, then it prints a message.
````
  - If TOKEN_AUTH has the correct value OAUTH, then it prints the value.
  - If the token is not expired, then it prints a message.
### Setting Client Tracing for Token Authentication
You can add `EVENT` settings to the client-side `sqlnet.ora` file to control client tracing.
These `EVENT` settings can be used for both IAM and Azure AD connections with Oracle Database.
  - EVENT_25701=14 for low level tracing
  - EVENT_25701=15 for high level tracing
  - EVENT_25701=14 for low level tracing
  - EVENT_25701=15 for high level tracing
Client trace files are created in the following locations:
****
  - Linux: $ORACLE_HOME/log/diag/clients
****
  - Windows: %ORACLE_HOME%\log\diag\clients
You can use the `ADR_BASE` parameter in the client side `sqlnet.ora` to specify the directory in which tracing messages are stored. Ensure that the directory path is valid and has write permissions. Ensure that the `DIAG_ADR_ENABLED` parameter is not set to `FALSE`.
An example of setting `ADR_BASE` is as follows:
```
ADR_BASE=/oracle/oauth2/trace
```
## ORA-12599 and ORA-03114 Errors Caused When Trying to Access a Database Using a Token
The `ORA-12599: TNS: cryptographic checksum mismatch` and `ORA-03114: not connected to ORACLE` errors indicate that the database to which you are trying to connect is protected by native network encryption.
When tokens are being used to access an Oracle database, a Transport Layer Security (TLS) connection must be established, not network native encryption. To remedy these errors, ensure that TLS is properly configured for your database. You should test the configuration with a local database user name and password and check the following `SYSCONTEXT USERENV` parameters:
- NETWORK_PROTOCOL
- TLS_VERSION
## Checking the Azure AD Access Token Version
You can check the version of the Microsoft Azure AD access token that your site uses by using the JSON Web Tokens web site.
By default, Azure AD Microsoft Azure AD v1 access token, but your site may have chosen to use v2. Oracle Database supports v1 tokens and Autonomous Database Serverless supports v2 tokens, as well. If you want to use the v2 access tokens, then you can enable their use for the Oracle database. To find the version of the Azure AD access token that you are using, you can either check with your Azure AD administrator, or confirm the version from the JSON Web Tokens website, as follows.
```
https://jwt.io/
```
- Go to the JSON Web Tokens website.
****
- Copy and paste the token string into the Encoded field.
****
  - "ver": "1.0"
  - "ver": "2.0"
## Related Topics
  - Configuring Transport Layer Security Encryption
  - Enabling Microsoft Azure AD v2 Access Tokens
