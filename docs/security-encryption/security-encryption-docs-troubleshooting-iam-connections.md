# Troubleshooting IAM Connections

The `ORA-01017: invalid username/password; logon denied` error can be caused by several different issues throughout the Oracle DBaaS integration with Identity and Access Management (IAM).
- Areas to Check on the Client-Side for ORA-01017 Errors Client-side ORA-01017 errors can result from problems with IAM credentials, client configuration, or problems with the IAM profile.
- Database Client Trace Files You can generate two levels of trace files to troubleshoot IAM connections on client side.
- Check in the Oracle Cloud Infrastructure IAM and the Oracle Database for ORA-01017 Errors ORA-01017 errors in the Oracle Database instance can arise from the way that the database was enabled to work with IAM.
- ORA-01017 Errors Caused by Improperly Configured IAM Users Several ORA-01017 errors can arise from improperly configured IAM users.
````
- ORA-12599 and ORA-03114 Errors Caused When Trying to Access a Database Using a Token The ORA-12599: TNS: cryptographic checksum mismatch and ORA-03114: not connected to ORACLE errors indicate that the database to which you are trying to connect is protected by native network encryption.
- Actions IAM Administrators Can Take to Address ORA-01017 Errors Several actions to remedy ORA-01017 errors can only be performed by IAM administrators.
## Areas to Check on the Client-Side for ORA-01017 Errors
Client-side `ORA-01017` errors can result from problems with IAM credentials, client configuration, or problems with the IAM profile.
**Troubleshooting the IAM Token**
****
```
oci --version
```
- Check the version of the Oracle Cloud Infrastructure (OCI) CLI used for the token. The OCI CLI must be at least OCI version 3.4, which includes the command to get the new db-token from IAM. To check the version of OCI, run the following command:
****
  - JDBC: Version 19.13.0.0.1 and later versions of 19c JDBC clients JDBC: Version 21.5 and later versions of 21c
  - Instant Client/SQL*Plus (Linux only): Version 19.13 (annotated with -2) and later versions of 19c
  - Instant Client/OCI/SQL*Plus (Linux only): Version 21.5 and later versions of 21c (Not all features are supported with Instant Client/OCI version 21c. Oracle recommends that you use the latest 19c or version 23c client, if possible.)
  - SQLcl: version 21.4 and later
  - ODP.net: Version 19.13 and higher versions of 19c
  - ODP.net: Version 21.4 and higher versions of 21c
  - Oracle Database release 23c: All clients
The latest version of these drivers is needed when you use IAM tokens to access the database. All supported database clients will work when using IAM database passwords.
****``````````````
- Check the token location that was specified in the tnsnames.ora file. The database clients and OCI CLI use the same default location for storing and retrieving database tokens and the private key (~/.oci/db-token). You can specify a different location, but both OCI CLI and the database client must be configured to use the same directory. Ensure that the correct TOKEN_LOCATION value is specified in the connect string, in the tnsnames.ora or sqlnet.ora file. The connect string takes precedence over tnsnames.ora, which takes precedence over the value of TOKEN_LOCATION in sqlnet.ora.
****
```
oci iam db-token get
```
- Check if the token has expired. The IAM database token is only valid for one hour. After the database token has expired, re-run the following OCI CLI command to request another token if you are using an API-key:
****````````````
- Check the TOKEN_AUTH parameter value in tnsnames.ora. Ensure that the parameter TOKEN_AUTH=OCI_TOKEN is set in either the connect string, tnsnames.ora, or sqlnet.ora. The connect string takes precedence over tnsnames.ora, which takes precedence over sqlnet.ora for the value of TOKEN_AUTH.
****``````
```
[oracle@localhost ~]$ oci iam db-token get
```
```
Private key written at /home/oracle/.oci/db-token/oci_db_key.pem db-token written at: /home/oracle/.oci/db-token/token db-token is valid until 2022-01-05 15:36:51
```
````
- Check if there is a missing token or private key from the default user-specified token location. Ensure that both the token and the private key are in the directory that is specified by the TOKEN_LOCATION after you run the OCI CLI command oci cli db-token get. You can find the db-token and private key location by running the following command: Output similar to the following appears: If the location does not match the TOKEN_LOCATION setting, either update the OCI CLI command or update the TOKEN_LOCATION parameter.
****
````
  - Ensure that the public API-key exists in the OCI user account. The OCI CLI will default to using the API-key on the client to request a db-token from IAM. If the public API-key is not in the OCI user account, then IAM will not return a database token.
  - Ensure that the IAM account is not locked. If it is, then ask the IAM administrator to unlock it.
  - If you are using the IAM database password, then ensure that you set the IAM database password in your IAM profile.
****
```
oci iam db-token get --auth security_token
```
- If you are not using the API-key, then explicitly state that you are using the security token. Use the following command: If the security token does not exist or has expired, this command will try to open the browser for you to sign into IAM (or your federated IdP). This command will fail if you do not have a browser in your environment.
**Troubleshooting Both the IAM Database Password and the IAM Token**
  ****- Check client tracing on Oracle Instant Client only. Client tracing can provide some information when you use SQL*Plus with the Instant Client. You can generate Oracle Database client trace files using two different tracing levels.
## Database Client Trace Files
You can generate two levels of trace files to troubleshoot IAM connections on client side.
The two levels of trace files that you can generate are as follows:
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both the `TLS_` and `SSL_` versions of a parameter are configured, then the `SSL_` version is ignored.
  - If TCPS is not set up for the IAM connection, then it prints a message that the protocol has to be TCPS.
``````
  - If TLS_SERVER_DN_MATCH is not set to TRUE, then it prints a message that the value is FALSE.
  - If an invalid TOKEN_LOCATION has been specified, then it prints a message that the token location does not exist.
````
  - If the db-token and private key are not present at the specified TOKEN_LOCATION or the default token location, then it prints a message.
  - If the application has passed in only db-token or private key, it prints a message for the missing attribute.
  - If the db-token has expired, then it prints a message.
``````````
  - It prints where TLS_SERVER_DN_MATCH is present, tnsnames.ora or sqlnet.ora. It also prints the value as TRUE if set to TRUE.
  - If both the db-token and private key are set by the application, then it prints a message.
````
  - If TOKEN_AUTH has the correct value OCI_TOKEN, then it prints the value.
  - If db-token is not expired, then it prints a message.
To control client tracing for IAM connections, you can use one of these methods:
  - EVENT_25701=14 for low level tracing
  - EVENT_25701=15 for high level tracing
  - EVENT_25701=14 for low level tracing
  - EVENT_25701=15 for high level tracing
Client trace files are created in the following locations:
****
- Linux: $ORACLE_HOME/log/diag/clients
****
- Windows: %ORACLE_HOME%\log\diag\clients
You can use the `ADR_BASE` parameter in the client side `sqlnet.ora` to specify the directory in which tracing messages are stored. Ensure that the directory path is valid and has write permissions. Ensure that the `diag_adr_enabled` parameter is not set to `false`.
An example of setting `ADR_BASE` is as follows:
```
ADR_BASE=/oracle/iam/trace
```
## Check in the Oracle Cloud Infrastructure IAM and the Oracle Database for ORA-01017 Errors
`ORA-01017` errors in the Oracle Database instance can arise from the way that the database was enabled to work with IAM.
****
```
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME='identity_provider_type';
```
```
SHOW PARAMETER IDENTITY_PROVIDER_TYPE
```
- Check if the IAM configuration has been enabled. The OCI server must be configured for IAM integration and one or more database schemas (database users) must be mapped to IAM users or groups. This applies to both the IAM token and IAM database password use cases. To check if the configuration has been enabled, run the following command in SQL*Plus: Alternatively, you can use this command: If the returned value does not equal OCI_IAM, then enable the external authentication.
****
```
SELECT USERNAME, EXTERNAL_NAME, CREATED FROM DBA_USERS WHERE AUTHENTICATION_TYPE='GLOBAL';
```
``````
- Check the schemas that have been mapped to IAM. Note which IAM users and IAM groups are used in the mapping. You can find this information by running the following query in SQL*Plus: In the output, check that there is at least one EXTERNAL_NAME that starts with either IAM_USER or IAM_GROUP. Make a note of the IAM user or group name. If there are no global schemas, then you must create a new schema, or alter an existing schema, and then map it to an IAM user or IAM group that the user is a member of.
****
- Check if the Oracle Database instance needs to be restarted. In some cases, a database instance that existed before the IAM configuration was introduced may need to be restarted. But before doing so, follow all other troubleshooting guidelines before trying to restart the database.
## ORA-01017 Errors Caused by Improperly Configured IAM Users
Several `ORA-01017` errors can arise from improperly configured IAM users.
****
- Ensure that the IAM user can log in to the Oracle DBaaS instance. Ask the IAM user to try logging in an IAM user but not as a federated user. Ensure that this user is not locked out of the account. (The user should contact an IAM administrator if this happens.) If the user’s IAM account is locked, then this user cannot log in to the Oracle DBaaS instance. You should also check the IAM user name and IAM groups that the user is a member of. One of these (user name or group names) should match the mapped IAM user and group name that you found from the Oracle DBaaS server. If there is no mapping, then the user will be denied access to the database. If this is the case, then an IAM administrator should add the user to an IAM group that is mapped to the DBaaS instance that the user needs to access.
****
- Ensure that the API public key is registered in the IAM user profile. If the Oracle DBaaS instance configuration with IAM uses tokens, and if you use an API-key to retrieve the database token, then the API public key needs to be registered in the user’s IAM user profile.
****````
- Ensure that the IAM database password has been set in the IAM user profile. If the Oracle DBaaS instance configuration with IAM uses database password authentication, then ensure that an IAM database password has been set in the user IAM user profile. In addition, ensure that Database Passwords is an allowed setting in the User Capability section of the IAM user profile.
## ORA-12599 and ORA-03114 Errors Caused When Trying to Access a Database Using a Token
The `ORA-12599: TNS: cryptographic checksum mismatch` and `ORA-03114: not connected to ORACLE` errors indicate that the database to which you are trying to connect is protected by native network encryption.
When tokens are being used to access an Oracle database, a Transport Layer Security (TLS) connection must be established, not network native encryption. To remedy these errors, ensure that TLS is properly configured for your database. You should test the configuration with a local database user name and password and check the following `SYSCONTEXT USERENV` parameters:
- NETWORK_PROTOCOL
- TLS_VERSION
## Actions IAM Administrators Can Take to Address ORA-01017 Errors
Several actions to remedy `ORA-01017` errors can only be performed by IAM administrators.
****
- Check if the IAM user needs to recreate API-keys. If the IAM user was deleted and then recreated with the exact same user name, then Oracle Cloud Infrastructure (OCI) IAM will consider this as a different user with a different user OCID. In this case, the IAM user will need to recreate their user account and API-key. This action does not affect the IAM user and IAM group mappings in the database.
****
- If necessary, unlock the IAM user account. If the user is inactive or otherwise locked, then an IAM administrator will need to unlock the user account before database access can be allowed.
****````````
````
  - Set allow all-users to use autonomous-database-family in the tenancy. This enables all IAM tenancy users to use IAM database tokens to access all Oracle DBaaS instances in the tenancy.
``````````
  - Set allow group DBUsers to use database-connections in the production_compartment compartment. This enables IAM users who are members of the DBUsers IAM group to use IAM tokens to access databases in the production_compartment compartment.
****
```
SELECT USERNAME, EXTERNAL_NAME,
FROM DBA_USERS
WHERE AUTHENTICATION_TYPE='GLOBAL';
```
- Check the mappings for IAM users and groups. The IAM user either has an exclusive mapping from a schema (that is, a database user) in the database or is a member of an IAM group that is mapped to a schema in the database. Run the following SQL*Plus query and review its output to find the mapped IAM users and groups. Ensure that the user has one mapping to a database schema.
## Related Topics
  - Database Client Trace Files
  - Configuring Authorization for IAM Users and Oracle Cloud Infrastructure Applications
  - Configuring Transport Layer Security Encryption
  - Creating an IAM Policy to Authorize Users Authenticating with Tokens
