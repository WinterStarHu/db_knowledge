# Configuring the Database Client Connection

Configuring the IAM client connection controls the authentication of IAM users to the Oracle DBaaS instance.
- About Connecting to an Autonomous Database Instance Using IAM IAM users can connect to the Autonomous Database instance by using either an IAM database password verifier or an IAM token.
- Supported Client Drivers for IAM Connections Oracle DBaaS supports several types of client drivers for IAM connections.
- Using Centralized Oracle Cloud Infrastructure Services for Net Naming and Secrets You can use the Oracle Cloud Infrastructure (OCI) object store and vault to centrally store net names and secrets.
- Client Connections That Use an IAM Database Password Verifier After you have configured the authorization needed for the IAM user, this user can log in using existing client application, such as SQL*Plus or SQLcl without additional configuration.
- Client Connections That Use a Token Requested by an IAM User Name and Database Password You can create a client connection that uses a token requested by an IAM user name and database password.
- Client Connections That Use a Token Requested by a Client Application or Tool For IAM token access to the Oracle DBaaS, the client application or tool requests a database token from IAM for the IAM user.
- TLS Connections without Client Wallets The use of Transport Layer Security (TLS) connections without client wallets is supported for IAM connections.
- Common Database Client Configurations IAM users can connect to the Oracle DBaaS instance using client tools such as SQLcl on a laptop.
## About Connecting to an Autonomous Database Instance Using IAM
IAM users can connect to the Autonomous Database instance by using either an IAM database password verifier or an IAM token.
Using the IAM database password verifier is similar to the Oracle Database password authentication process. However, instead of the password verifier (encrypted hash of the password) being stored in the Oracle database, the verifier is instead stored as part of the Oracle Cloud Infrastructure (OCI) IAM user profile.
The second connection method, the use of an IAM token for the database, is more modern. The use of token-based access is a better fit for Cloud resources such as Autonomous Database. The token is based on the strength that the IAM endpoint can enforce. This can be multi-factor authentication, which is stronger than the use of passwords alone. Another benefit of using tokens is that the password verifier (which is considered sensitive) is never stored or available in memory. A TCPS (TLS) connection is required when using tokens for database access.
**Note:**  You cannot configure native network encryption when passing an IAM token. Only Transport Layer Security (TLS) by itself is supported, not native network encryption or native network encryption with TLS.
## Supported Client Drivers for IAM Connections
Oracle DBaaS supports several types of client drivers for IAM connections.
IAM database password verifiers work with any supported database client. Using IAM tokens requires the latest Oracle Database client 19c (at least 19.16). Some earlier clients (19c and 21c) provide a limited set of capabilities for token access. Oracle Database client 21c does not fully support the IAM token access feature. Oracle Database client 23c supports the IAM token access feature.
## Using Centralized Oracle Cloud Infrastructure Services for Net Naming and Secrets
You can use the Oracle Cloud Infrastructure (OCI) object store and vault to centrally store net names and secrets.
This functionality is currently supported with the JDBC-thin and .NET-thin drivers.
See the following guides:
**
- Oracle Database Net Services Administrator’s Guide
**
- Oracle Database Net Services Reference
## Client Connections That Use an IAM Database Password Verifier
After you have configured the authorization needed for the IAM user, this user can log in using existing client application, such as SQL*Plus or SQLcl without additional configuration.
The IAM user enters the IAM user name and IAM database password (not the Oracle Cloud Infrastructure (OCI) console password) using any currently supported database client. The only constraint is that the database client version be either Oracle Database release 12.1.0.2 or later to use Oracle Database 12c passwords. The database client must be able to use the `12C` password verifier. Using the `11G` verifier encryption is not supported with IAM. No special client or tool configuration is needed for the IAM user to connect to the OCI DBaaS instance.
## Client Connections That Use a Token Requested by an IAM User Name and Database Password
You can create a client connection that uses a token requested by an IAM user name and database password.
- About Client Connections That Use a Token Requested by an IAM User Name and Database Password IAM users can connect to the Oracle DBaaS instance by using an IAM token that was retrieved using an IAM user name and IAM database password.
````
- Parameters to Set for Client Connections That Use a Token Requested by an IAM User Name and Database Password To set these parameters, you modify either the sqlnet.ora file or the tnsnames.ora file.
- Configuring the Database Client to Retrieve a Token Using an IAM User Name and Database Password You can configure the database client to retrieve the IAM database token using the provided IAM user name and IAM database password.
- Configuring a Secure External Password Store Wallet to Retrieve an IAM Token You can enable an IAM user name and a secure external password store (SEPS) to request the IAM database token.
### About Client Connections That Use a Token Requested by an IAM User Name and Database Password
IAM users can connect to the Oracle DBaaS instance by using an IAM token that was retrieved using an IAM user name and IAM database password.
In both cases, the token is retrieved by using a database password, either by using SQL*Plus or through a SEPS.
In previous releases, you could only use the IAM user name and database password to get a password verifier from IAM. Getting a token with these credentials is more secure than getting a password verifier because a password verifier is considered sensitive. Using a token means that you do not need to pass or use the verifier. Applications cannot pass a token that was retrieved by the IAM user name and password through the database client API. Only the database client can retrieve this type of token. A database client can only retrieve a database token using the IAM user name and IAM database password.
You can enter the IAM username and IAM database password directly into the tool or use a SEPS wallet to hold these credentials securely.
### Parameters to Set for Client Connections That Use a Token Requested by an IAM User Name and Database Password
To set these parameters, you modify either the `sqlnet.ora` file or the `tnsnames.ora` file.
**Token-Specific Parameters for IAM User Name and Database Password Token Requests**
****
```
PASSWORD_AUTH=authentication_method
```
```
PASSWORD_AUTH=OCI_TOKEN
```
- PASSWORD_AUTH Parameter Sets sets the authentication method. This configuration must use a setting of OCI_TOKEN. Getting a token using the user and password credentials is more secure than using a password verifier, since a password verifier is considered sensitive. This parameter is required for retrieving the IAM bearer token with an IAM user name and database password. Syntax: Example:
****
```
OCI_IAM_URL=authentication_regional_endpoint.com/v1/actions/generateScopedAccessBearerToken
```
```
https://auth.us-phoenix-1.oraclecloud.com/v1/actions/generateScopedAccessBearerToken
```
- OCI_IAM_URL Parameter Specifies the IAM URL that the database client must connect with to get the database token. This parameter is required for retrieving the IAM bearer token with an IAM user name and database password. This setting is specific to your region. See Identity and Access Management Data Plane API for the appropriate URL for your region. Then append /v1/actions/generateScopedAccessBearerToken to the regional URL. Syntax: Example: The following example uses the Phoenix URL (https://auth.us-phoenix-1.oraclecloud.com):
****
```
OCI_TENANCY=tenancy_OCI..OCID
```
```
OCI_TENANCY=ocid1.tenancy.region1..12345
```
- OCI_TENANCY Parameter Specifies the OCID of the user’s tenancy. You can find this setting under the user’s icon at the top right of the OCI console. This parameter is required for retrieving the IAM bearer token with an IAM user name and database password. Syntax: Example:
****
````
```
OCI_COMPARTMENT=compartment_OCID
```
```
OCI_COMPARTMENT=ocid1.compartment.region1..12345
```
- OCI_COMPARTMENT Parameter Specifies defines the scope of the database token request. Note that there are two periods after region_name. The token will only be usable for databases in the specified compartment. If you omit this value, then the entire tenancy is the scope of the request. This parameter is optional, except if OCI_DATABASE is set. Syntax: Example: Note that there are two periods after region1.
****
```
OCI_DATABASE=database_OCID
```
```
OCI_DATABASE=ocid1.autonomousdatabase.oc1.iad.12345
```
- OCI_DATABASE Parameter Specifies the OCID of the database to access. This parameter limits the token to the database only. This parameter is optional. Syntax: Example:
**DN-Specific Parameters for IAM User Name and Database Password Token Requests** **Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both the `TLS_` and `SSL_` versions of a parameter are configured, then the `SSL_` version is ignored.
****
```
TLS_SERVER_CERT_DN=DN
```
```
TLS_SERVER_CERT_DN="C=US,O=ExampleCorporation,CN=sslserver2"
```
- TLS_SERVER_CERT_DN Parameter Specifies the distinguished name (DN) of the database server for this client. (Note that this parameter is not specific to the bearer tokens.) Syntax: Example:
****
```
TLS_SERVER_DN_MATCH=TRUE|FALSE
```
```
TLS_SERVER_DN_MATCH=TRUE
```
- TLS_SERVER_DN_MATCH Parameter Enforces server-side validation through DN matching. Set this parameter to TRUE. Syntax: Example:
**sqlnet.ora Example**
```
PASSWORD_AUTH=OCI_TOKEN
OCI_IAM_URL=https://auth.region1.example.com/v1/actions/generateScopedAccessBearerToken
OCI_TENANCY=ocid1.tenancy..12345
OCI_COMPARTMENT=ocid1.compartment.region1..12345
OCI_DATABASE=ocid1.autonomousdatabase.oc1.iad.12345
TLS_SERVER_CERT_DN="C=US,O=ExampleCorporation,CN=sslserver2",
TLS_SERVER_DN_MATCH=TRUE
```
**tnsnames.ora Example**
```
db_connection=
  (DESCRIPTION=
    (ADDRESS=(PROTOCOL=tcps)(HOST=sales1-svr)(PORT=5678))
    (SECURITY=
      (PASSWORD_AUTH=OCI_TOKEN)
      (OCI_IAM_URL=https://auth.region1.example.com/v1/actions/generateScopedAccessBearerToken)
      (OCI_TENANCY=ocid1.tenancy..12345)
      (OCI_COMPARTMENT=ocid1.compartment.region1..12345)
      (OCI_DATABASE=ocid1.autonomousdatabase.oc1.iad.12345)
      (TLS_SERVER_CERT_DN="C=US,O=ExampleCorporation,CN=sslserver2")
      (TLS_SERVER_DN_MATCH=TRUE))
    (CONNECT_DATA=(SERVICE_NAME=sales.us.example.com)))
```
In this specification:
- (PROTOCOL=tcps) sets the protocol to TCPS. You must use TCPS as the protocol or the connection will fail. TCPS must be enabled when passing tokens from the database client to the server.
- SECURITY is where you set the authentication and DN parameters.
### Configuring the Database Client to Retrieve a Token Using an IAM User Name and Database Password
You can configure the database client to retrieve the IAM database token using the provided IAM user name and IAM database password.
- Log in to the Oracle DBaaS client.
- Set the appropriate parameters to retrieve a token that will be requested by an IAM user name and database password.
````
```
WALLET_LOCATION = (SOURCE= (METHOD=FILE) (METHOD_DATA= DIRECTORY=/ora_db/wallet)
```
- In the sqlnet.ora file, set the WALLET_LOCATION parameter to the location of the client. The root certificates will reside in this directory. For example:
### Configuring a Secure External Password Store Wallet to Retrieve an IAM Token
You can enable an IAM user name and a secure external password store (SEPS) to request the IAM database token.
- Log in to the Oracle DBaaS client.
- Configure this client to use the secure external password store.
- Set the appropriate parameters to retrieve a token that will be requested by an IAM user name and database password.
## Client Connections That Use a Token Requested by a Client Application or Tool
For IAM token access to the Oracle DBaaS, the client application or tool requests a database token from IAM for the IAM user.
The client application will pass the database token directly to the database client through the database client API.
If the application or tool has not been updated to request an IAM token, then the IAM user can use Oracle Cloud Infrastructure (OCI) command line interface (CLI) to request and store the database token. You can request a database access token (`db-token`) using the following credentials:
- Security tokens (with IAM authentication), delegation tokens (in the OCI cloud shell) and API-keys, which are credentials that represent the IAM user to enable the authentication
- Instance principal tokens, which enable instances to be authorized actors (or principals) to perform actions on service resources after authenticating
- Resource principal token, which is a credential that enables the application to authenticate itself to other Oracle Cloud Infrastructure services
When the IAM users logs into the client with a slash `/` login and the `OCI_IAM` parameter is configured (`sqlnet.ora`, `tnsnames.ora`, or as part of a connect string), then the database client retrieves the database token from a file. If the IAM user submits a user name and password, the connection will use the IAM database verifier access described for client connections that use IAM database password verifiers. The instructions in this guide show how to use the OCI CLI as a helper for the database token. If the application or tool has been updated to work with IAM, then follow the instructions for the application or tool. Some common use cases include the following: SQLPlus on-premises, SQLcl on-premises, SQL*Plus in Cloud Shell, or applications that use SEP wallets.
## TLS Connections without Client Wallets
The use of Transport Layer Security (TLS) connections without client wallets is supported for IAM connections.
Before you configure this type of connection, ensure that the Oracle DBaaS environment meets the requirements.
## Common Database Client Configurations
IAM users can connect to the Oracle DBaaS instance using client tools such as SQLcl on a laptop.
*
*
- [Configuring a Client Connection for SQLPlus That Uses an IAM Database Password](#GUID-A857AD76-8F96-42FC-BFAD-671FE83E57F2) You can configure SQLPlus to use an IAM database password.
*
*
- [Configuring a Client Connection for SQLPlus That Uses an IAM Token](#GUID-6527F0AC-9402-49B8-9929-DCF576084FA4) You can configure a client connection for SQLPlus that uses an IAM token.
### Configuring a Client Connection for SQL*Plus That Uses an IAM Database Password
You can configure SQL*Plus to use an IAM database password.
```
CONNECT user_name@db_connect_string Enter password: password
```
````
```
sqlplus /nolog
connect peter_fitch@db_connect_string
Enter password: password
```
````
```
"peter_fitch@example.com"@db_connect_string "IAM database password"
```
- As the IAM user, log in to the Autonomous Database instance by using the following syntax: In this specification, user_name is the IAM user name. There is a limit of 128 bytes for the combined domain_name/user_name. The following example shows how IAM user peter_fitch can log in to an Autonomous Database instance. Some special characters will require double quotation marks around user_name and password. For example:
### Configuring a Client Connection for SQL*Plus That Uses an IAM Token
You can configure a client connection for SQL*Plus that uses an IAM token.
- Ensure you have an IAM user account.
- Check with an IAM administrator and an Oracle Database administrator to ensure you have a policy allowing you to access the database in the compartment or your tenancy and that you are mapped to a global schema in the database.
  - Set up the API key access for the IAM user.
````
```
oci iam db-token get
```
  - Retrieving a db-token with an API-key using the Oracle Cloud Infrastructure (OCI) command-line interface:
```
oci iam db-token get --auth security_token
```
  - Retrieving a db-token with a security (or session) token: If the security token has expired, a window will appear so the user can log in to OCI again. This generates the security token for the user. OCI CLI will use this refreshed token to get the db-token.
````
```
oci iam db-token get
```
    - Retrieving a db-token with a delegation token: When you log in to the cloud shell, the delegation token is automatically generated and placed in the /etc directory. To get this token, execute the following command in the cloud shell:
```
oci iam db-token get --auth instance_principal
```
    - Retrieving an instance token by using the OCI command-line interface:
  - The database client can also be configured to retrieve a database token using the IAM username and IAM database password. See Client Connections That Use a Token Requested by an IAM User Name and Database Password for more information.
See Required Keys and OCIDs for more information.
- Ensure that you are using the latest release updates for the Oracle Database client releases 19c and 21c. This configuration only works with the Oracle Database client release 19c or 21c.
````
  - Confirm that DN matching is enabled by looking for TLS_SERVER_DN_MATCH=ON in sqlnet.ora.
````
  - Configure the database client to use the IAM token by adding TOKEN_AUTH=OCI_TOKEN to the sqlnet.ora file. Because you will be using the default locations for the database token file, you do not need to include the token location.
The `TOKEN_AUTH` and `TOKEN_LOCATION` values in the `tnsnames.ora` connect strings take precedence over the `sqlnet.ora` settings for that connection. For example, for the connect string, assuming that the token is in the default location (`~/.oci/db-token` for Linux):
```
(description= (retry_count=20)(retry_delay=3) (address=(protocol=tcps)(port=1522) (host=example.us-phoenix-1.oraclecloud.com)) (connect_data=(service_name=aaabbbccc_exampledb_high.example.oraclecloud.com)) (security=(tls_server_cert_dn="CN=example.uscom-east-1.oraclecloud.com, OU=Oracle BMCS US, O=Example Corporation, L=Redwood City, ST=California, C=US") (TOKEN_AUTH=OCI_TOKEN)))
```
After the connect string is updated with the `TOKEN_AUTH` parameter, the IAM user can log in to the Autonomous Database instance by running the following command to start SQL*Plus. You can include the connect descriptor itself or use the name of the descriptor from the `tnsnames.ora` file.
```
connect /@exampledb_high
```
Or:
```
connect /@(description= (retry_count=20)(retry_delay=3) (address=(protocol=tcps)(port=1522) (host=example.us-phoenix-1.oraclecloud.com)) (connect_data=(service_name=aaabbbccc_exampledb_high.example.oraclecloud.com)) (security=(tls_server_cert_dn="CN=example.uscom-east-1.oraclecloud.com, OU=Oracle BMCS US, O=Example Corporation, L=Redwood City, ST=California, C=US") (TOKEN_AUTH=OCI_TOKEN)))
```
The database client is already configured to get a `db-token` because `TOKEN_AUTH` has already been set, either through the `sqlnet.ora` file or in a connect string. The database client gets the `db-token` and signs it using the private key and then sends the token to the Autonomous Database. If an IAM user name and IAM database password are specified instead of slash `/`, then the database client will connect using the password instead of using the `db-token`.
## Related Topics
  - Parameters to Set for Client Connections That Use a Token Requested by an IAM User Name and Database Password
  - Configuring a Client to Use the Secure External Password Store
  - Client Connections That Use an IAM Database Password Verifier
  - Transport Layer Security Connection without a Client Wallet
