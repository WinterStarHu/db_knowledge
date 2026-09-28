# Specifying the Type of Role Authorization

You can configure a role to be authorized through different sources, such the database or an external source.
- Authorizing a Role by Using the Database You can protect a role authorized by the database by assigning the role a password.
- Authorizing a Role by Using an Application An application role can be enabled only by applications that use an authorized PL/SQL package.
- Authorizing a Role by Using an External Source Oracle Database supports the use of external roles but with certain limitations.
- Authorizing a Role by Using the Operating System Oracle Database supports role authentication through the operating system but with certain limitations.
- Authorizing a Role by Using a Network Client Oracle Database supports role authentication by a network client but you must be aware of security risks.
- Authorizing a Global Role by an Enterprise Directory Service A global role enables a global user to be authorized only by an enterprise directory service.
## Authorizing a Role by Using the Database
You can protect a role authorized by the database by assigning the role a password.
If you are granted a role protected by a password, then you can enable or disable the role by supplying the proper password for the role in the `SET ROLE` statement. You cannot authenticate a password-authenticated role on logon, even if the role is a member of your list of default roles. You must explicitly enable it with the `SET ROLE` statement using the required password.
````
````
- Use the CREATE ROLE statement with the IDENTIFIED BY clause to create the password-authenticated role. Creating a Role That Is Authenticated With a Password shows a CREATE ROLE statement that creates a role called clerk. When the role is enabled, the password must be supplied.
- Use the SET ROLE statement to set the password-authenticated role. The following example shows how to set a password-authenticated role by using the SET ROLE statement.
```
SET ROLE clerk IDENTIFIED BY password;
```
```
See [Guidelines for Securing Passwords](guidelines-securing-passwords.html#GUID-451679EB-8676-47E6-82A6-DF025FD65156).
```
## Authorizing a Role by Using an Application
An application role can be enabled only by applications that use an authorized PL/SQL package.
Application developers do not need to secure a role by embedding passwords inside applications. Instead, they can create an application role (secure application role) and specify which PL/SQL package is authorized to enable the role.
**- To create a role enabled by an authorized PL/SQL package, use the IDENTIFIED USING package_name clause in the CREATE ROLE SQL statement.
For example, to indicate that the role `admin_role` is an application role and the role can only be enabled by any module defined inside the PL/SQL package `hr.admin`:
```
CREATE ROLE admin_role IDENTIFIED USING hr.admin;
```
## Authorizing a Role by Using an External Source
Oracle Database supports the use of external roles but with certain limitations.
You can define an external role locally in the database, but you cannot grant the external role to global users, to global roles, or to any other roles in the database. You can create roles that are authorized by the operating system or network clients.
  ````- To authorize a role by using an external source, use the CREATE ROLE statement with the IDENTIFIED EXTERNALLY clause.
For example:
```
CREATE ROLE accts_rec IDENTIFIED EXTERNALLY;
```
## Authorizing a Role by Using the Operating System
Oracle Database supports role authentication through the operating system but with certain limitations.
Role authentication through the operating system is useful only when the operating system is able to dynamically link operating system privileges with applications.
When a user starts an application, the operating system grants an operating system privilege to the user. The granted operating system privilege corresponds to the role associated with the application. At this point, the application can enable the application role. When the application is terminated, the previously granted operating system privilege is revoked from the operating system account of the user.
  - If a role is authorized by the operating system, then configure information for each user at the operating system level. This operation is operating system dependent.
If roles are granted by the operating system, then you do not need to have the operating system authorize them also.
## Authorizing a Role by Using a Network Client
Oracle Database supports role authentication by a network client but you must be aware of security risks.
If users connect to the database over Oracle Net, then by default, the operating system cannot authenticate their roles. This includes connections through a shared server configuration, as this connection requires Oracle Net. This restriction is the default because a remote user could impersonate another operating system user over a network connection. Oracle recommends that you set `REMOTE_OS_ROLES` to `FALSE`, which is the default.
  ````- If you are not concerned with this security risk and want to use operating system role authentication for network clients, then set the initialization parameter REMOTE_OS_ROLES in the database initialization parameter file to TRUE.
The change takes effect the next time you start the instance and mount the database.
## Authorizing a Global Role by an Enterprise Directory Service
A global role enables a global user to be authorized only by an enterprise directory service.
You define the global role locally in the database by granting privileges and roles to it, but you cannot grant the global role itself to any user or other role in the database. When a global user attempts to connect to the database, the enterprise directory is queried to obtain any global roles associated with the user. Global roles are one component of enterprise user security. A global role only applies to one database, but you can grant it to an enterprise role defined in the enterprise directory. An enterprise role is a directory structure that contains global roles on multiple databases and can be granted to enterprise users.
  ````- To create a global role to be authorized by an enterprise directory service, use the CREATE ROLE statement with the IDENTIFIED GLOBALLY clause.
For example:
```
CREATE ROLE supervisor IDENTIFIED GLOBALLY;
```
## Related Topics
  - Role Privileges and Secure Application Roles
  - Creating Secure Application Roles to Control Access to Applications
  - Grants of Roles Using the Operating System or Network
  - Global User Authentication and Authorization for a general discussion of global authentication and authorization of users, and its role in enterprise user management
  **- Oracle Database Enterprise User Security Administrator’s Guide for information about implementing enterprise user management
