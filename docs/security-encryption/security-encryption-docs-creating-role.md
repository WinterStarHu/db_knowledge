# Creating a Role

You can create a role that is authenticated with or without a password. You also can create external or global roles.
- About the Creation of Roles You can create a role by using the CREATE ROLE statement.
- Creating a Role That Is Authenticated With a Password You can create a password authenticated role by using the IDENTIFIED BY clause.
- Creating a Role That Has No Password Authentication You can create a role that does not require a password by omitting the IDENTIFIED BY clause.
- Creating a Role That Is External or Global External or global roles allow services that are outside the database to associate database roles to authenticated users.
- Altering a Role The ALTER ROLE statement can modify the authorization method for a role.
## About the Creation of Roles
You can create a role by using the `CREATE ROLE` statement.
To create the role, you must have the `CREATE ROLE` system privilege. Typically, only security administrators have this system privilege. After you create a role, the role has no privileges associated with it. Your next step is to grant either privileges or other roles to the new role.
You must give each role that you create a unique name among existing user names and role names of the database. Roles are not contained in the schema of any user. In a database that uses a multi-byte character set, Oracle recommends that each role name contain at least one single-byte character. If a role name contains only multi-byte characters, then the encrypted role name and password combination is considerably less secure. See Guideline 1 in Guidelines for Securing Passwords for password guidelines.
You can use the `IDENTIFIED BY` clause to authorize the role with a password. This clause specifies how the user must be authorized before the role can be enabled for use by a specific user to which it has been granted. If you do not specify this clause, or if you specify `NOT IDENTIFIED`, then no authorization is required when the role is enabled. Roles can be specified to be authorized by the following:
- The database using a password
- An application using a specified package
- Externally by the operating system, network, or other external source
- Globally by an enterprise directory service
As an alternative to creating password-protected roles, Oracle recommends that you use secure application roles instead.
Note the following restrictions about the creation of roles:
- A role and a user cannot have the same name.
````
- The role name cannot start with the value of the COMMON_USER_PREFIX parameter (which defaults to C##) unless this role is a CDB common role.
## Creating a Role That Is Authenticated With a Password
You can create a password authenticated role by using the `IDENTIFIED BY` clause.
  ````- To create a password-authenticated role, use the CREATE ROLE statement with the IDENTIFIED BY clause.
For example:
```
CREATE ROLE clerk IDENTIFIED BY password;
```
**Note:**
- __COMMENT_2__You can enable password-protected roles in a proxy session. Both secure application roles and password-protected roles provide a secure method for enabling a role in a session. Oracle recommends using secure password roles instead of password-protected roles where the password has to be maintained and transmitted over insecure channels or if more than one person needs to know the password. Password-protected roles in a proxy session are suitable for situations where automation is used to set the role.
``````
- If you set the SQLNET.ALLOWED_LOGON_VERSION_SERVER parameter is to 11 or higher, then you must recreate roles that have been created with the IDENTIFIED BY clause.
## Creating a Role That Has No Password Authentication
You can create a role that does not require a password by omitting the `IDENTIFIED BY` clause.
  - Use the CREATE ROLE statement with no clauses to create a role that has no password authentication.
For example:
```
CREATE ROLE salesclerk;
```
## Creating a Role That Is External or Global
External or global roles allow services that are outside the database to associate database roles to authenticated users.
Database external roles are associated with operating system and RADIUS groups. This way, database user authorization can be managed externally from the database.
An external user must be authorized by an external service, such as an operating system or a third-party service, before the external user can enable the role.
Global roles are used by globally authenticated users, using centrally managed users or Oracle Enterprise User Security. A global user must be authorized to use the role by the enterprise directory service before the role is enabled at login time.
````
- To create a role that is to be authorized externally, include the IDENTIFIED EXTERNALLY clause in the CREATE ROLE statement. For example:
```
CREATE ROLE clerk_external IDENTIFIED EXTERNALLY;
```
- To create a role to be authorized globally, use the CREATE ROLE statement. For example:
```
CREATE ROLE clerk_global IDENTIFIED GLOBALLY;
```
You can authorize roles globally to a user through a directory service mapping such as with centrally managed users.
## Altering a Role
The `ALTER ROLE` statement can modify the authorization method for a role.
To alter the authorization method for a role, you must have the `ALTER ANY ROLE` system privilege or have been granted the role with `ADMIN` option.
Remember that you can only directly grant secure application roles or password-authenticated roles to a user. Be aware that if you create a common role in the root, you cannot change it to a local role.
- To alter a role, use the ALTER ROLE statement. For example, to alter the clerk role to specify that the user must be authorized by an external source before enabling the role:
```
ALTER ROLE clerk IDENTIFIED EXTERNALLY;
```
## Related Topics
  - Role Privileges and Secure Application Roles
  - Creating Secure Application Roles to Control Access to Applications
  - Rules for Creating Common Roles
  - Management of Case Sensitivity for Secure Role Passwords
  - Grants of Roles Using the Operating System or Network
  - Configuring RADIUS Authentication
  - Mapping a Directory Group to a Global Role
**- Oracle Database Enterprise User Security Administrator’s Guide
