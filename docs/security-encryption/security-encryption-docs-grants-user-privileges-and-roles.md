# Grants of User Privileges and Roles

The `GRANT` statement provides privileges for a user to perform specific actions, such as executing a procedure.
- Granting System Privileges and Roles to Users and Roles Before you grant system privileges and roles to users and roles, be aware of how privileges for these types of grants work.
- Granting Object Privileges to Users and Roles You can grant object privileges to users and roles, and enable the grantee to grant the privilege to other users.
## Granting System Privileges and Roles to Users and Roles
Before you grant system privileges and roles to users and roles, be aware of how privileges for these types of grants work.
- Privileges for Grants of System Privileges and Roles to Users and Roles You can use the GRANT SQL statement to grant system privileges and roles to users and roles.
- Example: Granting a System Privilege and a Role to a User You can use the GRANT statement to grant system privileges and roles to users.
- Example: Granting the EXECUTE Privilege on a Directory Object You can use the GRANT statement to grant the EXECUTE privilege on a directory object.
- Use of the ADMIN Option to Enable Grantee Users to Grant the Privilege The WITH ADMIN OPTION clause can be used to expand the capabilities of a privilege grant.
- Creating a New User with the GRANT Statement You can create a new user and grant this user a privilege in one GRANT SQL statement.
### Privileges for Grants of System Privileges and Roles to Users and Roles
You can use the `GRANT` SQL statement to grant system privileges and roles to users and roles.
The following privileges are required:
````
- To grant a system privilege, a user must be granted the system privilege with the ADMIN option or must be granted the GRANT ANY PRIVILEGE system privilege.
````****
- To grant a role, a user must be granted the role with the ADMIN option or was granted the GRANT ANY ROLE system privilege. Note: Object privileges cannot be granted along with system privileges and roles in the same GRANT statement.
### Example: Granting a System Privilege and a Role to a User
You can use the GRANT statement to grant system privileges and roles to users.
Example 4-9 grants the system privilege `CREATE SESSION` and the `accts_pay` role to the user `jward`.
Example 4-9 Granting a System Privilege and a Role to a User
```
GRANT CREATE SESSION, accts_pay TO jward;
```
### Example: Granting the EXECUTE Privilege on a Directory Object
You can use the GRANT statement to grant the EXECUTE privilege on a directory object.
Example 4-9 grants the `EXECUTE` privilege on the `exec_dir` directory object to the user `jward`.
Example 4-10 Granting the EXECUTE Privilege on a Directory Object
```
GRANT EXECUTE ON DIRECTORY exec_dir TO jward;
```
### Use of the ADMIN Option to Enable Grantee Users to Grant the Privilege
The `WITH ADMIN OPTION` clause can be used to expand the capabilities of a privilege grant.
These capabilities are as follows:
- The grantee can grant or revoke the system privilege or role to or from any other user or role in the database. Users cannot revoke a role from themselves.
- The grantee can grant the system privilege or role with the ADMIN option.
- The grantee of a role can alter or drop the role.
Example 4-11 grants the `new_dba` role with the `WITH ADMIN OPTION` clause to user `michael`.
Example 4-11 Granting the ADMIN Option
```
GRANT new_dba TO michael WITH ADMIN OPTION;
```
User `michael` is able to not only use all of the privileges implicit in the `new_dba` role, but he can also grant, revoke, and drop the `new_dba` role as deemed necessary. Because of these powerful capabilities, use caution when granting system privileges or roles with the `ADMIN` option. These privileges are usually reserved for a security administrator, and are rarely granted to other administrators or users of the system. Be aware that when a user creates a role, the role is automatically granted to the creator with the `ADMIN` option.
### Creating a New User with the GRANT Statement
You can create a new user and grant this user a privilege in one `GRANT` SQL statement.
In most cases, you will want to grant the user the `CREATE SESSION` privilege.
  ````- To create a new user with the GRANT statement, include the privilege and the IDENTIFIED BY clause.
For example, to create user `psmith` as a new user while granting `psmith` the `CREATE SESSION` system privilege:
```
GRANT CREATE SESSION TO psmith IDENTIFIED BY password;
```
If you specify a password using the `IDENTIFIED BY` clause, and the user name does not exist in the database, then a new user with that user name and password is created.
## Granting Object Privileges to Users and Roles
You can grant object privileges to users and roles, and enable the grantee to grant the privilege to other users.
- About Granting Object Privileges to Users and Roles You can use the GRANT statement to grant object privileges to roles and users.
````
- How the WITH GRANT OPTION Clause Works The WITH GRANT OPTION clause with the GRANT statement can enable a grantee to grant object privileges to other users.
- Grants of Object Privileges on Behalf of the Object Owner The GRANT ANY OBJECT PRIVILEGE system privilege enables users to grant and revoke any object privilege on behalf of the object owner.
``````
- Grants of Privileges on Columns You can grant INSERT, UPDATE, or REFERENCES privileges on individual columns in a table.
- Row-Level Access Control You can provide access control at the row level, that is, within objects, but not with the GRANT statement.
### About Granting Object Privileges to Users and Roles
You can use the `GRANT` statement to grant object privileges to roles and users.
To grant an object privilege, you must fulfill one of the following conditions:
- You own the object specified.
- You have been granted the GRANT ANY OBJECT PRIVILEGE system privilege. This privilege enables you to grant and revoke privileges on behalf of the object owner.
****
- The WITH GRANT OPTION clause was specified when you were granted the object privilege. Note: System privileges and roles cannot be granted along with object privileges in the same GRANT statement.
The following example grants the `READ`, `INSERT`, and `DELETE` object privileges for all columns of the `emp` table to the users `jfee` and `tsmith`.
```
GRANT READ, INSERT, DELETE ON emp TO jfee, tsmith;
```
To grant all object privileges on the `salary` view to user `jfee`, use the `ALL` keyword as shown in the following example:
```
GRANT ALL ON salary TO jfee;
```
**Note:**   A grantee cannot regrant access to objects unless the original grant included the `GRANT OPTION`. Thus in the example just given, `jfee` cannot use the `GRANT` statement to grant object privileges to anyone else.
### How the WITH GRANT OPTION Clause Works
The `WITH GRANT OPTION` clause with the `GRANT` statement can enable a grantee to grant object privileges to other users.
The user whose schema contains an object is automatically granted all associated object privileges with the `WITH GRANT OPTION` clause. This special privilege allows the grantee several expanded privileges:
- The grantee can grant the object privilege to any user in the database, with or without the GRANT OPTION, and to any role in the database.
  - The grantee receives object privileges for the table with the GRANT OPTION.
````****
  - The grantee has the CREATE VIEW or CREATE ANY VIEW system privilege. Note: The WITH GRANT OPTION clause is not valid if you try to grant an object privilege to a role. Oracle Database prevents the propagation of object privileges through roles so that grantees of a role cannot propagate object privileges received by means of roles.
### Grants of Object Privileges on Behalf of the Object Owner
The `GRANT ANY OBJECT PRIVILEGE` system privilege enables users to grant and revoke any object privilege on behalf of the object owner.
This privilege provides a convenient means for database and application administrators to grant access to objects in any schema without requiring that they connect to the schema. Login credentials do not need to be maintained for schema owners who have this privilege, which reduces the number of connections required during configuration.
This system privilege is part of the Oracle Database supplied `DBA` role and is thus granted (with the `ADMIN option`) to any user connecting `AS SYSDBA` (user `SYS`). As with other system privileges, the `GRANT ANY OBJECT PRIVILEGE` system privilege can only be granted by a user who possesses the `ADMIN option`.
The *recorded* grantor of access rights to an object is either the object owner or the person exercising the `GRANT ANY OBJECT PRIVILEGE` system privilege. If the grantor with `GRANT ANY OBJECT PRIVILEGE `does *not* have the object privilege with the `GRANT OPTION`, then the object owner is shown as the grantor. Otherwise, when that grantor has the object privilege with the `GRANT OPTION`, then that grantor is recorded as the grantor of the grant.
**Note:**   The audit record generated by the `GRANT` statement always shows the actual user who performed the grant.
For example, consider the following scenario. User `adams` possesses the `GRANT ANY OBJECT PRIVILEGE` system privilege. He does not possess any other grant privileges. He issues the following statement:
```
GRANT SELECT ON HR.EMPLOYEES TO blake WITH GRANT OPTION;
```
If you examine the `DBA_TAB_PRIVS` view, then you will see that `hr` is shown as the grantor of the privilege:
```
SELECT GRANTEE, GRANTOR, PRIVILEGE, GRANTABLE
  FROM DBA_TAB_PRIVS
  WHERE TABLE_NAME = 'EMPLOYEES' and OWNER = 'HR';
GRANTEE  GRANTOR PRIVILEGE    GRANTABLE
-------- ------- -----------  ----------
BLAKE    HR       SELECT      YES
```
Now assume that user `blake` also has the `GRANT ANY OBJECT PRIVILEGE` system. He issues the following statement:
```
GRANT SELECT ON HR.EMPLOYEES TO clark;
```
In this case, when you query the `DBA_TAB_PRIVS` view again, you see that `blake` is shown as being the grantor of the privilege:
```
GRANTEE  GRANTOR  PRIVILEGE  GRANTABLE
-------- -------- ---------  ----------
BLAKE    HR       SELECT     YES
CLARK    BLAKE    SELECT     NO
```
This occurs because `blake` already possesses the `SELECT` privilege on `HR.EMPLOYEES` with the `GRANT OPTION`.
### Grants of Privileges on Columns
You can grant `INSERT`, `UPDATE`, or `REFERENCES` privileges on individual columns in a table.
**Note:**   Before granting a column-specific `INSERT` privilege, determine if the table contains any columns on which `NOT NULL` constraints are defined. Granting selective insert capability without including the `NOT NULL` columns prevents the user from inserting any rows into the table. To avoid this situation, ensure that each `NOT NULL` column can either be inserted into or has a non-`NULL` default value. Otherwise, the grantee will not be able to insert rows into the table and will receive an error.
The following statement grants the `INSERT` privilege on the `acct_no` column of the `accounts` table to user `psmith`:
```
GRANT INSERT (acct_no) ON accounts TO psmith;
```
In the following example, object privilege for the `ename` and `job` columns of the `emp` table are granted to the users `jfee` and `tsmith`:
```
GRANT INSERT(ename, job) ON emp TO jfee, tsmith;
```
You can grant the `INSERT` and `UPDATE` privileges on individual columns of a view.
### Row-Level Access Control
You can provide access control at the row level, that is, within objects, but not with the `GRANT` statement.
To perform this kind of access control, you must use either Oracle Virtual Private Database (VPD) or Oracle Label Security (OLS).
## Related Topics
  - Creating User Accounts
  - Minimum Requirements for Passwords
  - Revokes of Object Privileges on Behalf of the Object Owner
  - Using Oracle Virtual Private Database to Control Data Access
  - Policies for Column-Level Oracle Virtual Private Database
**- Oracle Label Security Administrator’s Guide
