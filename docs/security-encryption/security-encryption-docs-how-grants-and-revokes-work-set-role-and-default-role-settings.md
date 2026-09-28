# How Grants and Revokes Work with SET ROLE and Default Role Settings

Privilege grants and the `SET ROLE` statement affect when and how grants and revokes take place.
- When Grants and Revokes Take Effect Depending on the privilege that is granted or revoked, a grant or revoke takes effect at different times.
- How the SET ROLE Statement Affects Grants and Revokes During a user session, a user or an application can use the SET ROLE statement multiple times to change the roles enabled for the session.
- Specifying the Default Role for a User When a user logs on, Oracle Database enables all privileges granted explicitly to the user and all privileges in the user’s default roles.
- The Maximum Number of Roles That a User Can Have Enabled You can grant a user as many roles as you want, but no more than 148 roles can be enabled for a logged-in user at any given time.
## When Grants and Revokes Take Effect
Depending on the privilege that is granted or revoked, a grant or revoke takes effect at different times.
The grants and revokes take effect as follows:
- All grants and revokes of system and object privileges to anything (users, roles, and PUBLIC) take immediate effect.
````
- All grants and revokes of roles to anything (users, other roles, PUBLIC) take effect only when a current user session issues a SET ROLE statement to reenable the role after the grant and revoke, or when a new user session is created after the grant or revoke.
You can see which roles are currently enabled by examining the `SESSION_ROLES `data dictionary view.
## How the SET ROLE Statement Affects Grants and Revokes
During a user session, a user or an application can use the `SET ROLE` statement multiple times to change the roles enabled for the session.
The user must already be granted the roles that are named in the `SET ROLE` statement.
The following example enables the role `clerk`, which you have already been granted, and specifies the password.
```
SET ROLE clerk IDENTIFIED BY password;
```
Follow the guidelines in Minimum Requirements for Passwords to replace *password* with a password that is secure.
The following example shows how to use `SET ROLE` to disable all roles.
```
SET ROLE NONE;
```
## Specifying the Default Role for a User
When a user logs on, Oracle Database enables all privileges granted explicitly to the user and all privileges in the user’s default roles.
````
- Ensure that the user who you want to set the default role for has been directly granted the role with a GRANT statement, or that the role was created by the user with the CREATE ROLE privilege.
````
- Use the ALTER USER statement with the DEFAULT ROLE clause to specify the default role for the user.
For example, to set the default roles `payclerk` and `pettycash` for user `jane`:
```
ALTER USER jane DEFAULT ROLE payclerk, pettycash;
```
For information about the restrictions of the `DEFAULT ROLE` clause of the `ALTER USER` statement, see *Oracle Database SQL Language Reference*.
You cannot set default roles for a user in the `CREATE USER` statement. When you first create a user, the default user role setting is `ALL`, which causes all roles subsequently granted to the user to be default roles. Use the `ALTER USER` statement to limit the default user roles.
**Note:**   When you create a role (other than a global role or an application role), it is granted implicitly to you, and your set of default roles is updated to include the new role. Be aware that only 148 roles can be enabled for a user session. When aggregate roles, such as the `DBA` role, are granted to a user, the roles granted to the role are included in the number of roles the user has. For example, if a role has 20 roles granted to it and you grant that role to the user, then the user now has 21 additional roles. Therefore, when you grant new roles to a user, use the `DEFAULT ROLE` clause of the `ALTER USER` statement to ensure that not too many roles are specified as that user’s default roles.
## The Maximum Number of Roles That a User Can Have Enabled
You can grant a user as many roles as you want, but no more than 148 roles can be enabled for a logged-in user at any given time.
Therefore, not all privileges will be available to this user during the user session. As a best practice, restrict the number of roles granted to a user to the minimum roles the user needs.
## Related Topics
  - Guidelines for Securing Roles
