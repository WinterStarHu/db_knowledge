# Granting and Revoking Roles

You can grant or revoke privileges to and from roles, and then grant these roles to users or to other roles.
- About Granting and Revoking Roles You can grant system or object privileges to a role, and grant any role to any database user or to another role.
- Who Can Grant or Revoke Roles? The GRANT ANY ROLE system privilege enables users to grant or revoke any role except global roles to or from other users or roles.
- Granting and Revoking Roles to and from Program Units You can grant roles to function, procedure, and PL/SQL package program units.
## About Granting and Revoking Roles
You can grant system or object privileges to a role, and grant any role to any database user or to another role.
However, a role cannot be granted to itself, nor can the role be granted circularly, that is, role `X` cannot be granted to role `Y` if role `Y` has previously been granted to role `X`.
To provide selective availability of privileges, Oracle Database permits applications and users to enable and disable roles. Each role granted to a user is, at any given time, either enabled or disabled. The security domain of a user includes the privileges of all roles currently enabled for the user and excludes the privileges of any roles currently disabled for the user.
A role granted to a role is called an indirectly granted role. You can explicitly enable or disable it for a user. However, whenever you enable a role that contains other roles, you implicitly enable all indirectly granted roles of the directly granted role.
You grant roles by using the `GRANT` statement, and revoke them by using the `REVOKE` statement. Privileges are granted to and revoked from roles using the same statements.
You cannot grant a secure role (that is, an `IDENTIFIED BY` role, `IDENTIFIED USING` role, or `IDENTIFIED EXTERNALLY` role) to either another secure role or to a non-secure role. You can use the `SET ROLE` statement to enable the secure role for the session.
## Who Can Grant or Revoke Roles?
The `GRANT ANY ROLE` system privilege enables users to grant or revoke any role except global roles to or from other users or roles.
A global role is managed in a directory, such as Oracle Internet Directory, but its privileges are contained within a single database. By default, the `SYS` or `SYSTEM` user has the `GRANT ANY ROLE` privilege. You should grant this system privilege conservatively because it is very powerful.
Any user granted a role with the `ADMIN` `OPTION` can grant or revoke that role to or from other users or roles of the database. This option allows administrative powers for roles to be granted on a selective basis.
## Granting and Revoking Roles to and from Program Units
You can grant roles to function, procedure, and PL/SQL package program units.
The role then becomes enabled during the execution of the program unit, but not during the compilation of the program unit. This enables you to temporarily escalate privileges in the PL/SQL code without granting the role directly to the user. It also increases security for applications and helps to enforce the principle of least privilege.
  ````- Use the GRANT or REVOKE statement to grant or revoke a role to a program unit.
The following example shows how to grant the same role to the PL/SQL package `checkstats_pkg`:
```
GRANT clerk_admin TO package psmith.checkstats_pkg;
```
This example shows how to revoke the `clerk_admin` role from the PL/SQL package `checkstats_pkg`:
```
REVOKE clerk_admin FROM package psmith.checkstats_pkg;
```
The following example shows how to grant the role `clerk_admin` to the procedure `psmith.check_stats_proc`.
```
GRANT clerk_admin TO PROCEDURE psmith.checkstats_proc;
```
## Related Topics
  **- Oracle Database Enterprise User Security Administrator’s Guide for information about global roles
  - Using Code Based Access Control for Definer’s Rights and Invoker’s Rights
