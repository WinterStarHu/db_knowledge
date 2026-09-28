# Managing System Privileges

To perform actions on schema objects, you must be granted the appropriate system privileges.
- About System Privileges A system privilege is the right to perform an action or to perform actions on schema objects.
- Why Is It Important to Restrict System Privileges? System privileges are very powerful, so only grant them to trusted users. You should also secure the data dictionary and SYS schema objects.
- Grants and Revokes of System Privileges You can grant or revoke system privileges to users and roles.
- Who Can Grant or Revoke System Privileges? Only two types of users can grant system privileges to other users or revoke those privileges from them.
- About ANY Privileges and the PUBLIC Role System privileges that use the ANY keyword enable you to set privileges for an entire category of objects in the database.
## About System Privileges
A system privilege is the right to perform an action or to perform actions on schema objects.
For example, the privileges to create tablespaces and to delete the rows of any table in a database are system privileges.
There are over 100 distinct system privileges. Each system privilege allows a user to perform a particular database operation or class of database operations. *Remember that system privileges are very powerful.* Only grant them when necessary to roles and trusted users of the database. To find the system privileges that have been granted to a user, you can query the `DBA_SYS_PRIVS` data dictionary view.
System privileges such as `SELECT ANY TABLE` do not work on `SYS` objects or other objects that are protected by the `SELECT ANY DICTIONARY` privilege.
## Why Is It Important to Restrict System Privileges?
System privileges are very powerful, so only grant them to trusted users. You should also secure the data dictionary and `SYS` schema objects.
- About the Importance of Restricting System Privileges System privileges are very powerful, so by default the database is configured to prevent typical (non-administrative) users from exercising the ANY system privileges.
````
- User Access to Objects in the SYS Schema Users with explicit object privileges or those who connect with administrative privileges (SYSDBA) can access objects in the SYS schema.
### About the Importance of Restricting System Privileges
System privileges are very powerful, so by default the database is configured to prevent typical (non-administrative) users from exercising the `ANY` system privileges.
For example, users are prevented from exercising `ANY` system privileges such as `UPDATE ANY TABLE` on the data dictionary.
### User Access to Objects in the SYS Schema
Users with explicit object privileges or those who connect with administrative privileges (`SYSDBA`) can access objects in the `SYS` schema.
The following table lists roles that you can grant to users who need access to objects in the `SYS` schema.

| Role | Description |
|---|---|
| SELECT_CATALOG_ROLE | Grant this role to allow users SELECT privileges on data dictionary views. |
| EXECUTE_CATALOG_ROLE | Grant this role to allow users EXECUTE privileges for packages and procedures in the data dictionary. |

Additionally, you can grant the `SELECT ANY DICTIONARY` system privilege to users who require access to tables created in the `SYS` schema. This system privilege allows query access to any object in the `SYS` schema, including tables created in that schema. It must be granted individually to each user requiring the privilege. It is not included in `GRANT ALL PRIVILEGES`, but it can be granted through a role.
In earlier releases, the `DBA_TAB_STAT_PREFS` view could be queried by any user with the `PUBLIC` role. Starting with Oracle Database 19c, Release Update 19.28, this view adheres to the convention for `DBA_` views, that is, it can be queried only by users with the `SYSDBA` system privilege or `SELECT ANY DICTIONARY` privilege, or `SELECT_CATALOG_ROLE` role, or by users with direct privileges granted to them. This change improves access control for optimizer and statistics metadata and reduces information disclosure.
  **Note:**   You should grant these roles and the `SELECT ANY DICTIONARY` system privilege with extreme care, because the integrity of your system can be compromised by their misuse.
## Grants and Revokes of System Privileges
You can grant or revoke system privileges to users and roles.
If you grant system privileges to roles, then you can use the roles to exercise system privileges. For example, roles permit privileges to be made selectively available. Ensure that you follow the separation of duty guidelines described in Guidelines for Securing Roles.
Use either of the following methods to grant or revoke system privileges to or from users and roles:
````
- GRANT and REVOKE SQL statements
- Oracle Enterprise Manager Cloud Control
## Who Can Grant or Revoke System Privileges?
Only two types of users can grant system privileges to other users or revoke those privileges from them.
These users are as follows:
````
- Users who were granted a specific system privilege with the ADMIN OPTION
``````
- Users with the system privilege GRANT ANY PRIVILEGE
For this reason, only grant these privileges to trusted users.
## About ANY Privileges and the PUBLIC Role
System privileges that use the `ANY` keyword enable you to set privileges for an entire category of objects in the database.
For example, the `CREATE ANY PROCEDURE` system privilege permits a user to create a procedure anywhere in the database. The behavior of an object created by users with the `ANY` privilege is not restricted to the schema in which it was created. For example, if user `JSMITH` has the `CREATE ANY PROCEDURE` privilege and creates a procedure in the schema `JONES`, then the procedure will run as `JONES`. However, `JONES` may not be aware that the procedure `JSMITH` created is running as him (`JONES`). If `JONES` has `DBA` privileges, letting `JSMITH` run a procedure as `JONES` could pose a security violation.
The `PUBLIC` role is a special role that every database user account automatically has when the account is created. By default, it has no privileges granted to it, but it does have numerous grants, mostly to Java objects. You cannot drop the `PUBLIC` role, and a manual grant or revoke of this role has no meaning, because the user account will always assume this role. Because all database user accounts assume the `PUBLIC` role, it does not appear in the `DBA_ROLES` and `SESSION_ROLES` data dictionary views.
You can grant privileges to the `PUBLIC` role, but remember that this makes the privileges available to every user in the Oracle database. For this reason, be careful about granting privileges to the `PUBLIC` role, particularly powerful privileges such as the `ANY` privileges and system privileges. For example, if `JSMITH` has the `CREATE PUBLIC SYNONYM` system privilege, he could redefine an interface that he knows everyone else uses, and then point to it with the `PUBLIC SYNONYM` that he created. Instead of accessing the correct interface, users would access the interface of `JSMITH`, which could possibly perform illegal activities such as stealing the login credentials of users.
These types of privileges are very powerful and could pose a security risk if given to the wrong person. Be careful about granting privileges using `ANY` or `PUBLIC`. As with all privileges, you should follow the principles of “least privilege” when granting these privileges to users.
## Related Topics
  - How Commonly Granted System Privileges Work
**- Oracle Database SQL Language ReferenceGRANT
  - Guidelines for Securing User Accounts and Privileges
  - User Privilege and Role Data Dictionary Views
  - Guidelines for Securing a Database Installation and Configuration
