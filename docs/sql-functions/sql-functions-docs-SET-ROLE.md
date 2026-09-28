# SET ROLE

## Purpose
When a user logs on to Oracle Database, the database enables all privileges granted explicitly to the user and all privileges in the user’s default roles. During the session, the user or an application can use the `SET` `ROLE` statement any number of times to enable or disable the roles currently enabled for the session.
You cannot enable more than 148 user-defined roles at one time.
**Note:**
````**
- For most roles, you cannot enable or disable a role unless it was granted to you either directly or through other roles. However, a secure application role can be granted and enabled by its associated PL/SQL package. See the CREATE ROLE semantics for USING package and Oracle Database Security Guide for information about secure application roles.
````````````**
- SET ROLE succeeds only if there are no definer's rights units on the call stack. If at least one DR unit is on the call stack, then issuing the SET ROLE command causes ORA-06565. See Oracle Database PL/SQL Language Reference for more information about definer's rights units.
````````**
- To run the SET ROLE command from PL/SQL, you must use dynamic SQL, preferably the EXECUTE IMMEDIATE statement. See Oracle Database PL/SQL Language Reference for more information about this statement.
You can see which roles are currently enabled by examining the `SESSION_ROLES` data dictionary view.
**See Also:**
- CREATE ROLE for information on creating roles
- ALTER USER for information on changing a user's default roles
**
- Oracle Database Reference for information on the SESSION_ROLES session parameter
## Prerequisites
You must already have been granted the roles that you name in the `SET` `ROLE` statement.
## Syntax
## *set_role*::=
Description of the illustration set_role.eps
## Semantics
## *role*
Specify one or more roles to be enabled for the current session. All roles not specified are disabled for the current session or until another `SET` `ROLE` statement is issued in the current session.
In the `IDENTIFIED` `BY` *password* clause, specify the password for a role. If the role has a password, then you must specify the password to enable the role.
**Restriction on Setting Roles**
You cannot specify a role identified globally. Global roles are enabled by default at login, and cannot be reenabled later.
## ALL Clause
Specify `ALL` to enable all roles granted to you for the current session except those optionally listed in the `EXCEPT` clause.
Roles listed in the `EXCEPT` clause must be roles granted directly to you. They cannot be roles granted to you through other roles.
If you list a role in the `EXCEPT` clause that has been granted to you both directly and through another role, then the role remains enabled by virtue of the role to which it has been granted.
**Restrictions on the ALL Clause**
The following restrictions apply to the `ALL` clause:
- You cannot use this clause to enable roles with passwords that have been granted directly to you.
****
- You cannot use this clause to enable a secure application role, which is a role that can be enabled only by applications using an authorized package. Refer to Oracle Database Security Guide for information on creating a secure application role and Oracle Database 2 Day + Security Guide for a tutorial.
## NONE
Specify `NONE` to disable all roles for the current session, including the `DEFAULT` role.
## Examples
**Setting Roles: Examples**
To enable the role `dw_manager` identified by the password `warehouse` for your current session, issue the following statement:
```
SET ROLE dw_manager IDENTIFIED BY warehouse;
```
To enable all roles granted to you for the current session, issue the following statement:
```
SET ROLE ALL;
```
To enable all roles granted to you except `dw_manager`, issue the following statement:
```
SET ROLE ALL EXCEPT dw_manager;
```
To disable all roles granted to you for the current session, issue the following statement:
```
SET ROLE NONE;
```
