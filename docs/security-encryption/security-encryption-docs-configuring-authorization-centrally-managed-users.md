# Configuring Authorization for Centrally Managed Users

With centrally managed users, you can manage the authorization for Active Directory users to access Oracle databases.
Users can be added, modified, or dropped from an organization by using Active Directory without your having to add, modify, or drop the user from every database in your organization.
- About Configuring Authorization for Centrally Managed Users You can manage user authorization for a database within Active Directory.
- Mapping a Directory Group to a Shared Database Global User Most users of the database will be mapped to a shared global database user (schema) through membership in a directory group.
- Mapping a Directory Group to a Global Role Database global roles mapped to directory groups give member users additional privileges and roles above what they have been granted through their login schemas.
- Exclusively Mapping a Directory User to a Database Global User You can map a Microsoft Active Directory user exclusively to an Oracle Database global user.
- Altering or Migrating a User Mapping Definition You can update an Active Directory user to a Database global user mapping by using the ALTER USER statement.
- Configuring Administrative Users Administrative users can work as they have in the past, but with CMUs, they can be controlled with centralized authentication and authorization if they are using shared schemas.
- Verifying the Centrally Managed User Logon Information After you configure and authorize a centrally managed user, you can verify the user logon information by executing a set of SQL queries on the Oracle database side.
## About Configuring Authorization for Centrally Managed Users
You can manage user authorization for a database within Active Directory.
Most Oracle Database users will be mapped to a shared database schema (user). This minimizes the work that must be done in each Oracle database when directory users are hired, change jobs within the company, or leave the company. A directory user will be assigned to an Active Directory group that is mapped to an Oracle database global user (schema). When the user logs into the database, the database will query Active Directory to find the groups the user is a member of. If your deployment is using shared schemas, then one of the groups will map to a shared database schema and the user will be assigned to that database schema. The user will have the roles and privileges that granted to the database schema. Because multiple users will be assigned to the same shared database schema, only the minimal set of roles and privileges should be granted to the shared schema. In some cases, no privileges and roles should be granted to the shared schema. Users will be assigned the appropriate set of roles and schemas through database global roles. Global roles are mapped to Active Directory groups. This way, different users can have different roles and privileges even if they are mapped to the same database shared schema. A newly hired user will be assigned to an Active Directory group mapped to a shared schema and then to one or more additional groups mapped to global roles to gain the additional roles and privileges required to complete their tasks. The combination of shared schemas and global roles allows for centralized authorization management with minimal changes to the database operationally. The database must be initially provisioned with the set of shared schemas and global roles mapped to the appropriate Active Directory groups, but then user authorization management can happen within Active Directory.
An Active Directory user can also be exclusively mapped to a database global user. This requires a new user in the database that is mapped directly to the Active Directory user. New users and departing users will require updates to each database they are members of.
Active Directory users requiring administrative privileges such as `SYSOPER` and` SYSBACKUP` cannot be granted these through global roles. Administrative privileges can only be granted to a schema and not a role. But even in these cases with administrative privileges, shared schemas can be used to provide ease of user authorization management. Using a shared schema with the `SYSOPER` privilege will allow new users to be easily added to the Active Directory group mapped to the schema with `SYSOPER` without having to create a new user schema in the database. Even if only one user is assigned to the shared schema, it can still be managed centrally.
When using global roles to grant privileges and roles to the user, remember that the maximum number of enabled roles in a session is 150.
The following types of global user mappings are supported for authorization:
- Map shared global users, in which directory users are assigned to a shared database schema (user) through the mapping of a directory group to the shared schema. The directory users that are members of the group can connect to the database through this shared schema. Use of shared schemas allows for centralized management of user authorization in Active Directory.
- Exclusive global user mappings, in which a dedicated database user is exclusively mapped to a directory user. Not as common as the shared database schema, this user is created for direct database access by using either SQL*Plus or the schema user for two-tier or three-tier applications. Oracle recommends that you grant database privileges to these users through global roles, which facilitates authorization management. However, these users can also have direct privilege grants in the Oracle database, although this is not recommended. This is because two-tier and three-tier applications can use the global user as the database schema, so the global user has the full database privileges on the schema objects as the owner.
It is common for a directory user to be a member of multiple groups. However, only one of these groups should be mapped to a shared schema.
## Mapping a Directory Group to a Shared Database Global User
Most users of the database will be mapped to a shared global database user (schema) through membership in a directory group.
The Active Directory group must be created before the database global user can be mapped to it. You can add Active Directory users to the group at any time before the user needs to log in to the database. On the database side, you must have the `CREATE USER` and `ALTER USER` privileges to perform these mappings. This configuration can be used for users who have the password authentication, Kerberos authentication, and public key infrastructure (PKI) authentication methods.
You can assign users who share the same database schema for an application into an Active Directory group. A shared Oracle Database global user (that is, a shared schema) is mapped to an Active Directory group. This way, any Active Directory user of this group can log in to the database through that shared global user account. Although the database global user account is shared by group members, the Active Directory user’s authenticated identity (Windows domain and his or her `samAccountName`), and enterprise identity (DN) are tracked and audited inside the database.
````
- Log in to the database instance as a user who has been granted the CREATE USER or ALTER USER system privilege.
``````
````````
- Execute the CREATE USER or ALTER USER statement with the IDENTIFIED GLOBALLY AS clause specifying the DN of an Active Directory group. For example, to map a directory group named widget_sales_group in the sales organization unit of the production.examplecorp.com domain to a shared database global user named WIDGET_SALES:
```
CREATE USER widget_sales IDENTIFIED GLOBALLY AS 'CN=widget_sales_group,OU=sales,DC=production,DC=examplecorp,DC=com';
```
```
All members of the `widget_sales_group` will be assigned to the `widget_sales` shared schema when they log in to the database.
```
## Mapping a Directory Group to a Global Role
Database global roles mapped to directory groups give member users additional privileges and roles above what they have been granted through their login schemas.
````
- Log in to the database instance as a user who has been granted the CREATE ROLE or ALTER ROLE system privilege.
``````
````````
- Execute the CREATE ROLE or ALTER ROLE statement with the IDENTIFIED GLOBALLY AS clause specifying the DN of an Active Directory group. For example, to map a directory user group named widget_sales_group in the sales organization unit of the production.examplecorp.com domain to a database global role WIDGET_SALES_ROLE:
```
CREATE ROLE widget_sales_role IDENTIFIED GLOBALLY AS
'CN=widget_sales_group,OU=sales,DC=production,DC=examplecorp,DC=com';
```
```
In a multitenant environment, to create a common role called `C##WIDGET_SALES_ROLE`:
```
```
CREATE ROLE c##widget_sales_role IDENTIFIED GLOBALLY AS
'CN=widget_sales_group,OU=sales,DC=production,DC=examplecorp,DC=com'
CONTAINER = ALL;
```
```
All members of the `widget_sales_group` will be authorized with the database role `widget_sales_role` when they log in to the database.
```
## Exclusively Mapping a Directory User to a Database Global User
You can map a Microsoft Active Directory user exclusively to an Oracle Database global user.
You perform the configuration on the Oracle Database side only, not the Active Directory side. You must have the `CREATE USER` and `ALTER USER` privileges to perform these mappings. This configuration can be used for users who have the password authentication, Kerberos authentication, and public key infrastructure (PKI) authentication methods.
````
- Log in to the database instance as a user who has been granted the CREATE USER or ALTER USER system privilege.
``````
````````````
- Execute the CREATE USER or ALTER USER statement with the IDENTIFIED GLOBALLY AS clause specifying the DN of an Active Directory user. For example, to map an existing Active Directory user named Peter Fitch (whose samAccountName is pfitch) in the sales organization unit of the production.examplecorp.com domain to a database global user named PETER_FITCH:
```
CREATE USER peter_fitch IDENTIFIED GLOBALLY AS 'CN=Peter Fitch,OU=sales,DC=production,DC=examplecorp,DC=com';
```
## Altering or Migrating a User Mapping Definition
You can update an Active Directory user to a Database global user mapping by using the `ALTER USER` statement.
You can update users whose accounts were created using any of the `CREATE USER` statement clauses: `IDENTIFIED BY password`, `IDENTIFIED EXTERNALLY`, or `IDENTIFIED GLOBALLY`. This is useful when migrating users to using CMU. For example, a database user that is externally authenticated to Kerberos will be identified by their user principal name (UPN). To migrate the user to use CMU with Kerberos authentication, you would need to run the `ALTER USER` statement to declare a global user and identify the user with their Active Directory distinguished name (DN).
- Log in to the database instance as a user who has been granted the ALTER USER system privilege.
````
- Execute the ALTER USER statement with the IDENTIFIED GLOBALLY AS clause. For example:
```
ALTER USER peter_fitch IDENTIFIED GLOBALLY AS
'CN=Peter Fitch,OU=sales,DC=production,DC=examplecorp,DC=com';
```
## Configuring Administrative Users
Administrative users can work as they have in the past, but with CMUs, they can be controlled with centralized authentication and authorization if they are using shared schemas.
- Configuring Database Administrative Users with Shared Access Accounts Using shared accounts simplifies the management of database administrators for multiple databases as they join, move, and leave the organization.
- Configuring Database Administrative Users Using Exclusive Mapping Database administrators can also be mapped to exclusive schemas in databases.
### Configuring Database Administrative Users with Shared Access Accounts
Using shared accounts simplifies the management of database administrators for multiple databases as they join, move, and leave the organization.
You can assign new database administrators to shared accounts in multiple databases using Active Directory groups without having to create new Oracle database accounts.
  - Ensure that the password file for the current database instance is in the 12.2 format.
```
orapwd file=pwd_file FORMAT=12.2
Enter password for SYS: password
```
- In Active Directory, create an Active Directory group (for example, for a database administrator backup users group called ad_dba_backup_users).
````
- In Oracle Database, create a global user (shared schema) (for example, db_dba_backup_global_user) and map this user to the Active Directory ad_dba_backup_users group.
````
- Grant the SYSBACKUP administrative privilege to the global user db_dba_backup_global_user.
At this stage, any Active Directory user who is added to the `ad_dba_backup_users` Active Directory group will be assigned to the new database shared schema with the `SYSBACKUP` administrative privilege.
### Configuring Database Administrative Users Using Exclusive Mapping
Database administrators can also be mapped to exclusive schemas in databases.
  - Ensure that the password file for the current database instance is in the 12.2 format.
```
orapwd file=pwd_file FORMAT=12.2
Enter password for SYS: password
```
- Log in to the database instance as a user who can create users and grant administrative privileges to other users.
- Create a database global user. For example:
```
CREATE USER peter_fitch IDENTIFIED GLOBALLY AS
'CN=Peter Fitch,OU=sales,DC=production,DC=examplecorp,DC=com';
```
- Grant this user the administrative privilege. For example, to grant a user the SYSKM administrative privilege:
```
GRANT SYSKM TO peter_fitch;
```
Due to the amount of work to maintain accounts and the mapping in both the database and Active Directory, a more centralized approach would be to use shared schemas for these administrative accounts as well, even if only one Active Directory user is assigned to the shared database account in some cases.
## Verifying the Centrally Managed User Logon Information
After you configure and authorize a centrally managed user, you can verify the user logon information by executing a set of SQL queries on the Oracle database side.
``````
- Log in to the database as a centrally managed user from Active Directory that you have just configured and authorized. For example, to log in to the database instance inst1 as the enterprise user pfitch, who is on the Windows domain production:
```
sqlplus /nolog connect "production\pfitch"@inst1 Enter password: password
```
``````````
- Verify the mapped global user. The mapped global user is the database user account that has the centrally managed user authorization. User PETER_FITCH is considered a global user with exclusive mapping for the Active Directory user pfitch, while user WIDGET_SALES is considered a global user with shared mapping for Active Directory group widget_sales_group of which pfitch is a member. A global user account has its own schema.
```
SHOW USER;
```
```
Output similar to the following appears, depending on if it is an exclusive mapping or a shared mapping:
```
```
USER is "PETER_FITCH"
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
PETER_FITCH
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
PETER_FITCH
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
PETER_FITCH
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
- Verify the authenticated identity for the enterprise user. The Active Directory authenticated user identity is captured and audited when this user logs on to the database.
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
production\pfitch
```
```
- Verify the centrally managed user's enterprise identity.
```
```
SELECT SYS_CONTEXT('USERENV', 'ENTERPRISE_IDENTITY') FROM DUAL;
```
```
  Output similar to the following appears:
```
```
SYS_CONTEXT('USERENV','ENTERPRISE_IDENTITY')
----------------------------------------------------------------------
cn=Peter Fitch,ou=sales,dc=production,dc=examplecorp,dc=com
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
- Verify the LDAP server type.
```
```
SELECT SYS_CONTEXT('USERENV', 'LDAP_SERVER_TYPE') FROM DUAL;
```
```
  Output similar to the following appears. In this case, the LDAP server type is Active Directory.
```
```
SYS_CONTEXT('USERENV','LDAP_SERVER_TYPE')
----------------------------------------------------------------------
AD
```
## Related Topics
  - Logging in to an Oracle Database Using Password Authentication
