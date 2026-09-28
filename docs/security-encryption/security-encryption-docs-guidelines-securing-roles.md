# Guidelines for Securing Roles

Oracle provides guidelines for role management.
****
````
````````
- Grant a role to users only if they need all privileges of the role. Roles (groups of privileges) are useful for quickly and easily granting permissions to users. Although you can use Oracle-defined roles, you have more control and continuity if you create your own roles containing only the privileges pertaining to your requirements. Oracle may change or remove the privileges in an Oracle Database-defined role, as it has with the CONNECT role, which now has only the CREATE SESSION privilege. Formerly, this role had eight other privileges. Ensure that the roles you define contain only the privileges that reflect job responsibility. If your application users do not need all the privileges encompassed by an existing role, then apply a different set of roles that supply just the correct privileges. Alternatively, create and assign a more restricted role. For example, it is imperative to strictly limit the privileges of user SCOTT, because this is a well known account that may be vulnerable to intruders. Because the CREATE DBLINK privilege allows access from one database to another, drop its privilege for SCOTT. Then, drop the entire role for the user, because privileges acquired by means of a role cannot be dropped individually. Re-create your own role with only the privileges needed, and grant that new role to that user. Similarly, for better security, drop the CREATE DBLINK privilege from all users who do not require it.
****
- Do not grant user roles to application developers. Roles are not meant to be used by application developers, because the privileges to access schema objects within stored programmatic constructs need to be granted directly. Remember that roles are not enabled within stored procedures except for invoker’s right procedures. See How Roles Work in PL/SQL Blocks for information about this topic.
****
````
- Create and assign roles specific to each Oracle Database installation. This principle enables the organization to retain detailed control of its roles and privileges. This also avoids the necessity to adjust if Oracle Database changes or removes Oracle Database-defined roles, as it has with CONNECT, which now has only the CREATE SESSION privilege. Formerly, it also had eight other privileges.
****
  - Global User Authentication and Authorization
  - Authorizing a Global Role by an Enterprise Directory Service
**
  - Oracle Database Enterprise User Security Administrator’s Guide
