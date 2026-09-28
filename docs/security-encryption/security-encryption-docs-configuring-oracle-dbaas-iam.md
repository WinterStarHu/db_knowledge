# Configuring Oracle DBaaS for IAM

To configure Oracle DBaaS to work with IAM, an Oracle DBaaS database administrator must first enable the IAM integration and then authorize IAM users and roles for Oracle DBaaS.
- Enabling External Authentication for Oracle DBaaS The method of enabling an IAM connection with Oracle DBaaS depends on the platform of Oracle DBaaS that you are using.
- Configuring Authorization for IAM Users and Oracle Cloud Infrastructure Applications An Oracle DBaaS database administrator can map IAM users and Oracle Cloud Infrastructure (OCI) applications to the Oracle Database global schemas and global roles.
- Configuring IAM Proxy Authentication Proxy authentication allows an IAM user to proxy to a database schema for tasks such as application maintenance.
## Enabling External Authentication for Oracle DBaaS
The method of enabling an IAM connection with Oracle DBaaS depends on the platform of Oracle DBaaS that you are using.
******
- Oracle Autonomous Database on Dedicated Exadata Infrastructure: The IAM connection is automatically configured to work with this platform. See Using Oracle Autonomous Database on Dedicated Exadata Infrastructure.
******
- Oracle Autonomous Database Serverless: The IAM connection must be enabled to work with this platform. See Using Oracle Autonomous Database Serverless.
****
- Oracle Base Database Service: See Use Identity and Access Management Authentication with Base Database Service.
****
- Oracle Exadata Database Service on Dedicated Infrastructure: See Connect Identity and Access Management (IAM) Users to Oracle Exadata Database Service on Dedicated Infrastructure.
**Databases Other Than Oracle Autonomous Database Serverless**
- Refer to the documentation for your Oracle DBaaS platform for prerequisites and other information you may need.
```
ALTER SYSTEM SET IDENTITY_PROVIDER_TYPE=OCI_IAM SCOPE=BOTH;
```
```
ALTER SYSTEM RESET IDENTITY_PROVIDER_CONFIG SCOPE=BOTH;
```
- For non-Oracle Autonomous Database instances, set the IDENTITY_PROVIDER_CONFIG parameter. If IDENTITY_PROVIDER_CONFIG had been set to a different value, then run the following statement: The IDENTITY_PROVIDER_CONFIG parameter may have been set to a different value because a different identity provider, such as Microsoft Azure, had been used.
## Configuring Authorization for IAM Users and Oracle Cloud Infrastructure Applications
An Oracle DBaaS database administrator can map IAM users and Oracle Cloud Infrastructure (OCI) applications to the Oracle Database global schemas and global roles.
- About Configuring Authorization for IAM Users and Oracle Cloud Infrastructure Applications You create the mappings for IAM users and Oracle Cloud Infrastructure (OCI) applications to database users (schemas) in the Oracle DBaaS.
- Mapping an IAM Group to a Shared Oracle Database Global User Oracle Database global users that are mapped to IAM groups and IAM dynamic groups give IAM users and OCI applications a schema when they log in along with the privileges and roles granted to that schema.
- Mapping an IAM Group to an Oracle Database Global Role Oracle Database global roles that are mapped to IAM groups and dynamic groups give member users and applications additional privileges and roles above what they have been granted through their login schemas.
- Exclusively Mapping an IAM User to an Oracle Database Global User You can map an IAM user exclusively to an Oracle Database global user.
- Altering or Migrating an IAM User Mapping Definition You can update an IAM user to a database global user mapping by using the ALTER USER statement.
- Mapping Instance and Resource Principals Applications can use instance principals and resource principals to retrieve database tokens and establish a connection to an Oracle DBaaS instance.
- Verifying the IAM User Logon Information After you configure and authorize an IAM user for the Oracle DBaaS instance, you can verify the user logon information by executing a set of SQL queries on the Oracle database side.
### About Configuring Authorization for IAM Users and Oracle Cloud Infrastructure Applications
You create the mappings for IAM users and Oracle Cloud Infrastructure (OCI) applications to database users (schemas) in the Oracle DBaaS.
There is a difference with authorization between IAM database password authentication and using IAM token based authentication. IAM database password verifier authorization is only based on mappings of database schemas and global roles to IAM users and group. With IAM token based authentication, IAM policies are an additional authorization for IAM users to access their tenancy databases. An IAM user must be authorized through an IAM policy **and** be authorized through a mapping to a database global schema (exclusive or shared).
For both token and password verifier database access, you create the mappings for IAM users and OCI applications to the Oracle DBaaS instance. The IAM user accounts themselves are managed in IAM. The user accounts and user groups can be in either the default domain or in a custom, non-default domain.
When the IAM user accesses the Oracle DBaaS instance with a token, the database will perform an authorization check against IAM policies to ensure the user is allowed to access the database. If the IAM user is allowed to access the database by IAM policy, then the database will query IAM for the user groups. When using password verifier authentication, the database will query IAM for user groups once the IAM user successfully completes authentication. The database queries the IAM endpoint to find the groups of which the user is a member. If your deployment is using shared schemas, then one of the IAM groups will map to a shared database schema and the IAM user will be assigned to that database schema. The IAM user will have the roles and privileges that are granted to the database schema. Because multiple IAM users can be assigned to the same shared database schema, only the minimal set of roles and privileges should be granted to the shared schema. In some cases, no privileges and roles should be granted to the shared schema. Users will be assigned the appropriate set of roles and schemas through database global roles. Global roles are mapped to IAM groups. This way, different users can have different roles and privileges even if they are mapped to the same database shared schema. A newly hired user will be assigned to an IAM group mapped to a shared schema and then to one or more additional groups mapped to global roles to gain the additional roles and privileges required to complete their tasks. The combination of shared schemas and global roles allows for centralized authorization management with minimal changes to the database operationally. The database must be initially provisioned with the set of shared schemas and global roles mapped to the appropriate IAM groups, but then user authorization management can happen within IAM.
Ensure that the IAM user is only mapped to one schema, either through exclusive mapping to a database schema or as a member of one IAM group that is mapped to a shared database schema. If more than one schema is mapped for an IAM user, then the database will take exclusive mapping as precedence over any group mapping to a shared schema. If more than one group is mapped for a user, then the database will select the oldest mapping.
When using global roles to grant privileges and roles to the user, remember that the maximum number of enabled roles in a session is 150.
If you drop and recreate IAM users and groups using the same names, then the mappings from the database to IAM using the same names will continue to work. However, recreating an IAM user will require the IAM user to do one or more of the following: create the IAM database password, re-upload the API public key, update the OCI configuration file, and then re-examine the IAM policy for database authentication and authorization with IAM. If the IAM policy specifies a group that can use or manage the `database-connections` and `autonomous-database-family` resource types, then the user will need to be added to that group to allow IAM authentication and authorization.
Accessing the database with tokens requires the user to be authorized by IAM policy and by database mapping. Accessing the database with the IAM database password verifier requires authorization through database mapping. If no database schema mapping exists for the IAM user, the IAM user is prevented from accessing the database even if they have a valid token or password.
IAM users get their authorizations to perform various tasks based on the roles that they have been granted. The following scenarios are possible:
****
- IAM group mapped to a shared Oracle Database global user: With the shared database global user account, an IAM user is assigned to a shared database schema (user) through the mapping of an IAM group to the shared schema. The IAM users that are members of the group can connect to the database through this shared schema. Use of shared schemas allows for centralized management of user authorization in IAM.
****
- IAM group mapped to an Oracle Database global role: The privileges that have been granted to the shared Oracle Database global role become available to the users who have added to the IAM group.
****
- Local IAM user exclusively mapped to an Oracle Database global user: With an exclusive global user mapping, a dedicated database user is exclusively mapped to a local IAM user. Not as common as the shared database schema, this user is created for when the user requires their own schema objects. Oracle recommends that you grant database privileges to these users through global roles, which facilitates authorization management. These users can also have direct privilege and role grants to their exclusive schema. In IAM with Identity Domains, users and groups are supported in the default domain as well as custom non-default domains. When you specify users and groups in the default domain, then no domain prefix is required. When you specify users and groups in a non-default domain, then the domain must be prefixed.
### Mapping an IAM Group to a Shared Oracle Database Global User
Oracle Database global users that are mapped to IAM groups and IAM dynamic groups give IAM users and OCI applications a schema when they log in along with the privileges and roles granted to that schema.
````
- Log in to the Oracle DBaaS instance as a user who has the CREATE USER or ALTER USER system privilege.
``````
````
```
CREATE USER shared_sales_schema IDENTIFIED GLOBALLY AS 'IAM_GROUP_NAME=WidgetSalesGroup';
```
```
CREATE USER shared_sales_schema IDENTIFIED GLOBALLY AS 'IAM_GROUP_NAME=sales_domain/WidgetSalesGroup';
```
- Run the CREATE USER or ALTER USER statement with the IDENTIFIED GLOBALLY AS clause specifying the IAM group name (which can be a dynamic group). For example, to create a new database global user account named shared_sales_schema and map it to an existing IAM group named WidgetSalesGroup: The following example shows how to accomplish this for a non-default domain:
### Mapping an IAM Group to an Oracle Database Global Role
Oracle Database global roles that are mapped to IAM groups and dynamic groups give member users and applications additional privileges and roles above what they have been granted through their login schemas.
Global roles cannot be granted to a database schema (user), they can only be mapped to a group and be assigned to an IAM user when accessing the database.
````
- Log in to the Oracle DBaaS instance as a user who has been granted the CREATE ROLE or ALTER ROLE system privilege
``````
````
```
CREATE ROLE widget_mgr_role IDENTIFIED GLOBALLY AS
'IAM_GROUP_NAME=WidgetManagerGroup';
```
```
CREATE ROLE widget_sales_role IDENTIFIED GLOBALLY AS
'IAM_GROUP_NAME=sales_domain/WidgetManagerGroup';
```
``````
- Run the CREATE ROLE or ALTER ROLE statement with the IDENTIFIED GLOBALLY AS clause specifying the name of the IAM group (which can be a dynamic group). For example, to create a new database global role named widget_mgr_role and map it to an existing IAM group named WidgetManagerGroup, using the default domain: The following example shows how to create the role by specifying a non-default domain, sales_domain: All members of the WidgetManagerGroup in the sales_domain domain will be authorized with the database global role widget_sales_role when they log in to the database.
### Exclusively Mapping an IAM User to an Oracle Database Global User
You can map an IAM user exclusively to an Oracle Database global user.
````
- Log in to the Oracle DBaaS instance as a user who has been granted the CREATE USER or ALTER USER system privilege.
``````
````
```
CREATE USER peter_fitch IDENTIFIED GLOBALLY AS
'IAM_PRINCIPAL_NAME=peterfitch';
```
```
CREATE USER peter_fitch2 IDENTIFIED GLOBALLY AS
'IAM_PRINCIPAL_NAME=sales_domain/peterfitch';
```
- Run the CREATE USER or ALTER USER statement with the IDENTIFIED GLOBALLY AS clause specifying the IAM database user name. By default, the IAM database user name is the same as the IAM user name, including the domain name. You can also create a unique IAM database user name for ease of authentication to the database. In your OCI IAM user profile, you can create a unique IAM database user name for ease of authentication to the database. This can be set when you create and manage your IAM database password in your IAM profile. Adding or changing the IAM database user name will invalidate the IAM user to schema mapping, so the database schema will need to be remapped to the new IAM database user name. For example, to create a new database global user named peter_fitch and map this user to an existing IAM user named with an IAM database user name of peterfitch, using the default domain: The following example shows how to create the user by specifying a non-default domain, sales_domain:
### Altering or Migrating an IAM User Mapping Definition
You can update an IAM user to a database global user mapping by using the `ALTER USER` statement.
You can update database schemas that were mapped to an IAM user, and whose accounts were created using any of the `CREATE USER` statement clauses: `IDENTIFIED BY` password, `IDENTIFIED EXTERNALLY`, or `IDENTIFIED GLOBALLY`. This is useful when migrating existing schemas to using IAM. If you delete and recreate an IAM user or an IAM group using the exact same name as the previous IAM user or group, then the existing mapping from the database that uses that IAM user or IAM group name will continue to work.
- Log in to the Oracle DBaas instance as a user who has been granted the ALTER USER system privilege.
````
```
ALTER USER shared_sales_schema IDENTIFIED GLOBALLY AS 'IAM_GROUP_NAME=BiggerWidgetSalesGroup';
```
```
ALTER USER shared_sales_schema IDENTIFIED GLOBALLY AS 'IAM_GROUP_NAME=sales_domain/BiggerWidgetSalesGroup';
```
- Run the ALTER USER statement with the IDENTIFIED GLOBALLY AS clause. For example, suppose you want to change the existing schema shared_sales_schema to a different IAM group: The following example shows how to modify the schema by specifying a non-default domain, sales_domain:
### Mapping Instance and Resource Principals
Applications can use instance principals and resource principals to retrieve database tokens and establish a connection to an Oracle DBaaS instance.
You can exclusively map instance principals and resource principals to a global schema (database user) or you can map them by using dynamic groups to a shared schema.
You can only use instance principal and resource principal `OCID`s to map them exclusively or to a shared schema. Instance principal and resource principal dynamic groups can also be mapped to global roles.
Examples are as follows:
````
```
CREATE USER ip_user IDENTIFIED GLOBALLY AS 'IAM_PRINCIPAL_OCID=ocid1.instance.region1.sea.abcdef123456';
CREATE USER rp_user IDENTIFIED GLOBALLY AS 'IAM_PRINCIPAL_OCID=ocid1.dbsystem.oc1.sea.abcdef123456';
```
- Exclusive schema mapping using an instance principal (ip_user) and a resource principal (rp_user):
```
CREATE USER iam_dg IDENTIFIED GLOBALLY AS 'IAM_GROUP_NAME=DB_Principals';
```
- Shared schema mapping using dynamic group:
```
CREATE ROLE app_role IDENTIFIED GLOBALLY AS 'IAM_GROUP_NAME=application_principals';
```
- Mapping to a global role;
### Verifying the IAM User Logon Information
After you configure and authorize an IAM user for the Oracle DBaaS instance, you can verify the user logon information by executing a set of SQL queries on the Oracle database side.
````
- Log in to the Oracle DBaaS instance as an IAM user that you have just configured and authorized. For example, to log in to the database instance inst1 as the database global user peterfitch, who is using the default domain in IAM:
```
sqlplus /nolog CONNECT "peterfitch"@inst1 Enter password: password
```
```
This example shows how to log in if user `peterfitch` is in a non-default domain, `sales_domain`:
```
```
sqlplus /nolog CONNECT "sales_domain/peterfitch"@inst1 Enter password: password
```
``````````
- Verify the mapped global user. The mapped global user is the database user account that has the IAM user authorization. User PETER_FITCH_SCHEMA is considered a global user with exclusive mapping for the IAM user peterfitch, while user WIDGET_SALES is considered a global user with shared mapping for IAM group widget_sales_group of which peterfitch is a member.
```
SHOW USER;
```
```
Output similar to the following appears, depending on if it is an exclusive mapping or a shared mapping:
```
```
USER is "PETER_FITCH_SCHEMA"
```
```
Or
```
```
USER is "WIDGET_SALES"
```
  - Find the roles that have been granted to the centrally managed user.
```
SELECT ROLE FROM SESSION_ROLES ORDER BY ROLE;
```
```
Output similar to the following appears:
```
```
ROLE
----------------------------------------------------------------------
WIDGET_SALES_ROLE
...
```
  - Verify the current schema that is being used in this database session. A database schema is an object container that identifies the objects it contains. The current schema is the default container for objects name resolution in this database session.
```
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL;
```
```
  Output similar to the following appears, depending on if it is an exclusive mapping or a shared mapping:
```
```
SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
----------------------------------------------------------------------
PETER_FITCH_SCHEMA
```
```
  Or
```
```
SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
----------------------------------------------------------------------
WIDGET_SALES
```
```
- Verify the current user. In this case, the current user is the same as the current schema.
```
```
SELECT SYS_CONTEXT('USERENV', 'CURRENT_USER') FROM DUAL;
```
```
  Output similar to the following appears, depending on if it is an exclusive mapping or a shared mapping:
```
```
SYS_CONTEXT('USERENV','CURRENT_USER')
----------------------------------------------------------------------
PETER_FITCH_SCHEMA
```
```
  Or
```
```
SYS_CONTEXT('USERENV','CURRENT_USER')
----------------------------------------------------------------------
WIDGET_SALES
```
```
- Verify the session user.
```
```
SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') FROM DUAL;
```
```
  Output similar to the following appears, depending on if it is an exclusive mapping or a shared mapping:
```
```
SYS_CONTEXT('USERENV','SESSION_USER')
----------------------------------------------------------------------
PETER_FITCH_SCHEMA
```
```
  Or
```
```
SYS_CONTEXT('USERENV','SESSION_USER')
----------------------------------------------------------------------
WIDGET_SALES
```
```
- Verify the authentication method.
```
```
SELECT SYS_CONTEXT('USERENV', 'AUTHENTICATION_METHOD') FROM DUAL;
```
```
  Output similar to the following appears:
```
```
SYS_CONTEXT('USERENV','AUTHENTICATION_METHOD')
----------------------------------------------------------------------
PASSWORD_GLOBAL
```
```
  If the user is authenticating with a token, then the output is `TOKEN_GLOBAL`.
- Verify the authenticated identity for the enterprise user. The IAM authenticated user identity is captured and audited when this user logs on to the database.
```
```
SELECT SYS_CONTEXT('USERENV', 'AUTHENTICATED_IDENTITY') FROM DUAL;
```
```
  Output similar to the following appears:
```
```
SYS_CONTEXT('USERENV','AUTHENTICATED_IDENTITY')
----------------------------------------------------------------------
sales_domain/peterfitch
```
```
- If a user nickname has been set for the enterprise user, then verify this nickname.
```
```
SELECT SYS_CONTEXT('USERENV', 'USER_NICKNAME') FROM DUAL;
```
```
  Output similar to the following appears:
```
```
SYS_CONTEXT('USERENV','USER_NICKNAME')
----------------------------------------------------------------------
pfitch
```
```
- Verify the centrally managed user's enterprise identity.
```
```
SELECT SYS_CONTEXT('USERENV', 'ENTERPRISE_IDENTITY') FROM DUAL;
```
```
  Enterprise Identity will show the OCI Identity (OCID) of the IAM user or OCI application. Output similar to the following appears:
```
```
SYS_CONTEXT('USERENV','ENTERPRISE_IDENTITY')
----------------------------------------------------------------------
ocid1.user.region1..aaaaaaaaj7ot4g2sagkjtw3enbg4ied3x554zwyywurgrm2232j4crm5zha
```
```
- Verify the identification type.
```
```
SELECT SYS_CONTEXT('USERENV', 'IDENTIFICATION_TYPE') FROM DUAL
```
```
  Output similar to the following appears, depending on if it is an exclusive mapping or a shared mapping:
```
```
SYS_CONTEXT('USERENV','IDENTIFICATION_TYPE')
----------------------------------------------------------------------
GLOBAL EXCLUSIVE
```
```
  Or
```
```
SYS_CONTEXT('USERENV','IDENTIFICATION_TYPE')
----------------------------------------------------------------------
GLOBAL SHARED
```
```
- Verify the server type.
```
```
SELECT SYS_CONTEXT('USERENV', 'LDAP_SERVER_TYPE') FROM DUAL;
```
```
  Output similar to the following appears. In this case, the LDAP server type is IAM.
```
```
SYS_CONTEXT('USERENV','LDAP_SERVER_TYPE')
----------------------------------------------------------------------
OCI_IAM
```
## Configuring IAM Proxy Authentication
Proxy authentication allows an IAM user to proxy to a database schema for tasks such as application maintenance.
- About Configuring IAM Proxy Authentication IAM users can connect to Oracle DBaaS by using proxy authentication.
- Configuring Proxy Authentication for the IAM User To configure proxy authentication for an IAM user, the IAM user must already have a mapping to a global schema (exclusive or shared mapping). A separate database schema for the IAM user to proxy to must also be available.
- Validating the IAM User Proxy Authentication You can validate the IAM user proxy configuration for both password and token authentication methods.
### About Configuring IAM Proxy Authentication
IAM users can connect to Oracle DBaaS by using proxy authentication.
Proxy authentication is typically used to authenticate the real user and then authorize them to use a database schema with the schema privileges and roles in order to manage an application. Alternatives such as sharing the application schema password are considered insecure and unable to audit which actual user performed an action.
A use case can be in an environment in which a named IAM user who is an application database administrator can authenticate by using their credentials and then proxy to a database schema user (for example, `hrapp`). This authentication enables the IAM administrator to use the `hrapp` privileges and roles as user `hrapp` in order to perform application maintenance, yet still use their IAM credentials for authentication. An application database administrator can sign in to the database and then proxy to an application schema to manage this schema.
You can configure proxy authentication for both the password authentication and token authentication methods.
### Configuring Proxy Authentication for the IAM User
To configure proxy authentication for an IAM user, the IAM user must already have a mapping to a global schema (exclusive or shared mapping). A separate database schema for the IAM user to proxy to must also be available.
After you ensure that you have this type of user, alter the database user to allow the IAM user to proxy to it.
- Log in to the Autonomous Database instance as a user who has the ALTER USER system privileges.
``````
```
ALTER USER hrapp GRANT CONNECT THROUGH peterfitch_schema;
```
- Grant permission for the IAM user to proxy to the local database user account. An IAM user cannot be referenced in the command so the proxy must be created between the database global user (mapped to the IAM user) and the target database user. In the following example, hrapp is the database schema to proxy to, and peterfitch_schema is the database global user exclusively mapped to user peterfitch.
At this stage, the IAM user can log in to the database instance using the proxy. For example, to connect using a password verifier:
```
CONNECT peterfitch[hrapp]@connect_string Enter password: password
```
To connect using a token:
```
CONNECT [hrapp]/@connect_string
```
### Validating the IAM User Proxy Authentication
You can validate the IAM user proxy configuration for both password and token authentication methods.
````
- Log in to the Autonomous Database instance as a user who has the CREATE USER and ALTER USER system privileges.
````
````
```
CONNECT peterfitch[hrapp]/password!@connect_string
SHOW USER;
--The output should be "USER is HRAPP"
SELECT SYS_CONTEXT('USERENV','AUTHENTICATION_METHOD') FROM DUAL;
--The output should be "PASSWORD_GLOBAL_PROXY"
SELECT SYS_CONTEXT('USERENV','PROXY_USER') FROM DUAL;
--The output should be "PETERFITCH_SCHEMA"
SELECT SYS_CONTEXT('USERENV','CURRENT_USER') FROM DUAL;
--The output should be "HRAPP"
```
  - For password authentication, assuming the IAM user is in the default domain:
```
CONNECT [hrapp]/@connect_string
SHOW USER;
--The output should be USER is "HRAPP "
SELECT SYS_CONTEXT('USERENV','AUTHENTICATION_METHOD') FROM DUAL;
--The output should be "TOKEN_GLOBAL_PROXY"
SELECT SYS_CONTEXT('USERENV','PROXY_USER') FROM DUAL;
--The output should be "PETERFITCH_SCHEMA"
SELECT SYS_CONTEXT('USERENV','CURRENT_USER') FROM DUAL;
--The output should be "HRAPP"
```
  - For token authentication, for a user who is in a non-default domain, sales_domain:
## Related Topics
  - Managing Dynamic Groups
  - Calling Services from an Instance
  - Accessing Other Oracle Cloud Infrastructure Resources from Running Functions
