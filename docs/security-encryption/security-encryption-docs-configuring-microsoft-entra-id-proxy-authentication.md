# Configuring Microsoft Azure AD Proxy Authentication

Proxy authentication allows an Azure AD user to proxy to a database schema for tasks such as application maintenance.
- About Configuring Microsoft Azure AD Proxy Authentication Azure users can connect to Oracle Autonomous Database by using proxy authentication.
- Configuring Proxy Authentication for the Azure AD User To configure proxy authentication for an Azure AD user, this user must already have a mapping to a global schema (exclusive or shared mapping). A separate database schema for the Azure AD user to proxy to must also be available.
- Validating the Azure AD User Proxy Authentication You can validate the Azure AD user proxy configuration for token authentication.
## About Configuring Microsoft Azure AD Proxy Authentication
Azure users can connect to Oracle Autonomous Database by using proxy authentication.
Proxy authentication is typically used to authenticate the real user and then authorize them to use a database schema with the schema privileges and roles in order to manage an application. Alternatives such as sharing the application schema password are considered insecure and unable to audit which actual user performed an action.
A use case can be in an environment in which a named Azure AD user who is an application database administrator can authenticate by using their credentials and then proxy to a database schema user (for example, `hrapp`). This authentication enables the Azure AD administrator to use the `hrapp` privileges and roles as user `hrapp` in order to perform application maintenance, yet still use their Azure AD credentials for authentication. An application database administrator can sign in to the database and then proxy to an application schema to manage this schema.
## Configuring Proxy Authentication for the Azure AD User
To configure proxy authentication for an Azure AD user, this user must already have a mapping to a global schema (exclusive or shared mapping). A separate database schema for the Azure AD user to proxy to must also be available.
After you ensure that you have this type of user, alter the database user to allow the Azure AD user to proxy to it.
- Log in to the Autonomous Database instance as a user who has the ALTER USER system privileges.
``````
```
ALTER USER hrapp GRANT CONNECT THROUGH peterfitch_schema;
```
- Grant permission for the Azure AD user to proxy to the local database user account. An Azure AD user cannot be referenced in the command so the proxy must be created between the database global user (mapped to the Azure AD user) and the target database user. In the following example, hrapp is the database schema to proxy to, and peterfitch_schema is the database global user exclusively mapped to user peterfitch.
At this stage, the Azure AD user can log in to the database instance using the proxy. For example:
```
CONNECT [hrapp]/@connect_string
```
## Validating the Azure AD User Proxy Authentication
You can validate the Azure AD user proxy configuration for token authentication.
````
- Log in to the Oracle Autonomous Database instance as a user who has the CREATE USER and ALTER USER system privileges.
````
````
```
CONNECT [hrapp]/@connect_string
SHOW USER;
--The output should be USER is "HRAPP "
SELECT SYS_CONTEXT('USERENV','AUTHENTICATION_METHOD') FROM DUAL;
--The output should be "TOKEN_GLOBAL"
SELECT SYS_CONTEXT('USERENV','PROXY_USER') FROM DUAL;
--The output should be "PETERFITCH_SCHEMA"
SELECT SYS_CONTEXT('USERENV','CURRENT_USER') FROM DUAL;
--The output should be "HRAPP"
```
- Connect as the Azure AD user and run the SHOW USER and SELECT SYS_CONTEXT commands. For example, suppose you want to check the proxy authentication of the Azure AD user peterfitch when they proxy to database user hrapp:
