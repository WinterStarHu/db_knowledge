# User Privilege and Role Data Dictionary Views

You can use special queries to find information about various types of privilege and role grants.
- Data Dictionary Views to Find Information about Privilege and Role Grants Oracle Database provides data dictionary views that describe privilege and role grants.
- Query to List All System Privilege Grants The DBA_SYS_PRIVS data dictionary view returns all system privilege grants made to roles and users.
- Query to List All Role Grants The DBA_ROLE_PRIVS query returns all the roles granted to users and other roles.
````
- Query to List Object Privileges Granted to a User The DBA_TAB_PRIVS and DBA_COL_PRIVS data dictionary views list object privileges that have bee granted to users.
````
- Query to List the Current Privilege Domain of Your Session The SESSION_ROLES and SESSION_PRIVS data dictionary views list the current privilege domain of a database session.
- Query to List Roles of the Database The DBA_ROLES data dictionary view lists all roles of a database and the authentication used for each role.
``````
- Query to List Information About the Privilege Domains of Roles The ROLE_ROLE_PRIVS, ROLE_SYS_PRIVS, and ROLE_TAB_PRIVS data dictionary views list information about the privilege domains of roles.
## Data Dictionary Views to Find Information about Privilege and Role Grants
Oracle Database provides data dictionary views that describe privilege and role grants.
The following table lists views that you can query to access information about grants of privileges and roles.

| View | Description |
|---|---|
| ALL_COL_PRIVS | Describes all column object grants for which the current user or PUBLIC is the object owner, grantor, or grantee |
| ALL_COL_PRIVS_MADE | Lists column object grants for which the current user is object owner or grantor |
| ALL_COL_PRIVS_RECD | Describes column object grants for which the current user or PUBLIC is the grantee |
| ALL_TAB_PRIVS | Lists the grants on objects where the user or PUBLIC is the grantee |
| ALL_TAB_PRIVS_MADE | Lists the all object grants made by the current user or made on the objects owned by the current user |
| ALL_TAB_PRIVS_RECD | Lists object grants for which the user or PUBLIC is the grantee |
| DBA_COL_PRIVS | Describes all column object grants in the database |
| DBA_CONTAINER_DATA | In a multitenant environment, displays default (user-level) and object-specific CONTAINER_DATA attributes. Objects that are created with the CONTAINER_DATA clause include CONTAINER_DATA attributes. |
| DBA_EPG_DAD_AUTHORIZATION | Describes the database access descriptors (DAD) that are authorized to use a different user’s privileges |
| DBA_LOCKDOWN_PROFILES | Describes information that pertains to PDB lockdown profiles |
| DBA_OBJECTS | Lists objects that have object links or metadata links. To find these objects, query the OBJECT_NAME and SHARING columns. |
| DBA_TAB_PRIVS | Lists all grants on all objects in the database |
| DBA_ROLES | Lists all roles that exist in the database, including secure application roles. Note that it does not list the PUBLIC role |
| DBA_ROLE_PRIVS | Lists roles directly granted to users and roles |
| DBA_SYS_PRIVS | Lists system privileges granted to users and roles |
| ROLE_ROLE_PRIVS | Lists roles granted to other roles. Information is provided only about roles to which the user has access |
| ROLE_SYS_PRIVS | Lists system privileges granted to roles. Information is provided only about roles to which the user has access |
| ROLE_TAB_PRIVS | Lists object privileges granted to roles. Information is provided only about roles to which the user has access |
| SESSION_PRIVS | Lists the privileges that are currently enabled for the user |
| SESSION_ROLES | Lists all roles that are enabled for the current user. Note that it does not list the PUBLIC role |
| USER_COL_PRIVS | Describes column object grants for which the current user is the object owner, grantor, or grantee |
| USER_COL_PRIVS_MADE | Describes column object grants for which the current user is the object owner |
| USER_COL_PRIVS_RECD | Describes column object grants for which the current user is the grantee |
| USER_EPG_DAD_AUTHORIZATION | Describes the database access descriptors (DAD) that are authorized to use a different user’s privileges |
| USER_ROLE_PRIVS | Lists roles directly granted to the current user |
| USER_TAB_PRIVS | Lists grants on all objects where the current user is the grantee |
| USER_SYS_PRIVS | Lists system privileges granted to the current user |
| USER_TAB_PRIVS_MADE | Lists grants on all objects owned by the current user |
| USER_TAB_PRIVS_RECD | Lists object grants for which the current user is the grantee |
| V$PWFILE_USERS | Lists all users in the current PDB who have been granted administrative privileges |

The following table lists views that you can query to access information about grants of privileges and roles.
This section provides some examples of using these views. For these examples, assume the following statements were issued:
```
CREATE ROLE security_admin IDENTIFIED BY password;
GRANT CREATE PROFILE, ALTER PROFILE, DROP PROFILE, CREATE ROLE, DROP ANY ROLE, GRANT ANY ROLE, AUDIT ANY, AUDIT SYSTEM, CREATE USER, BECOME USER, ALTER USER, DROP USER TO security_admin WITH ADMIN OPTION;
GRANT READ, DELETE ON SYS.AUD$ TO security_admin;
GRANT security_admin, CREATE SESSION TO swilliams;
GRANT security_admin TO system_administrator;
GRANT CREATE SESSION TO jward;
GRANT READ, DELETE ON emp TO jward;
GRANT INSERT (ename, job) ON emp TO swilliams, jward;
```
## Query to List All System Privilege Grants
The `DBA_SYS_PRIVS` data dictionary view returns all system privilege grants made to roles and users.
For example:
```
SELECT GRANTEE, PRIVILEGE, ADM FROM DBA_SYS_PRIVS;
GRANTEE            PRIVILEGE                         ADM
--------------     --------------------------------- ---
SECURITY_ADMIN     ALTER PROFILE                     YES SECURITY_ADMIN     ALTER USER                        YES SECURITY_ADMIN     AUDIT ANY                         YES SECURITY_ADMIN     AUDIT SYSTEM                      YES SECURITY_ADMIN     BECOME USER                       YES SECURITY_ADMIN     CREATE PROFILE                    YES SECURITY_ADMIN     CREATE ROLE                       YES SECURITY_ADMIN     CREATE USER                       YES SECURITY_ADMIN     DROP ANY ROLE                     YES SECURITY_ADMIN     DROP PROFILE                      YES SECURITY_ADMIN     DROP USER                         YES SECURITY_ADMIN     GRANT ANY ROLE                    YES SWILLIAMS          CREATE SESSION                    NO JWARD              CREATE SESSION                    NO
```
## Query to List All Role Grants
The `DBA_ROLE_PRIVS` query returns all the roles granted to users and other roles.
For example:
```
SELECT * FROM DBA_ROLE_PRIVS;
GRANTEE            GRANTED_ROLE                         ADM
------------------ ------------------------------------ ---
SWILLIAMS          SECURITY_ADMIN                       NO
```
## Query to List Object Privileges Granted to a User
The `DBA_TAB_PRIVS` and `DBA_COL_PRIVS` data dictionary views list object privileges that have bee granted to users.
The `DBA_TAB_PRIVS` data dictionary view returns all object privileges (not including column-specific privileges) granted to the specified user.
For example:
```
SELECT TABLE_NAME, PRIVILEGE, GRANTABLE FROM DBA_TAB_PRIVS WHERE GRANTEE = 'jward';
TABLE_NAME   PRIVILEGE    GRANTABLE
-----------  ------------ ----------
EMP          SELECT       NO EMP          DELETE       NO
```
To list all the column-specific privileges that have been granted, you can use the following query:
```
SELECT GRANTEE, TABLE_NAME, COLUMN_NAME, PRIVILEGE FROM DBA_COL_PRIVS;
GRANTEE      TABLE_NAME     COLUMN_NAME      PRIVILEGE
-----------  ------------   -------------    --------------
SWILLIAMS    EMP            ENAME            INSERT SWILLIAMS    EMP            JOB              INSERT JWARD        EMP            NAME             INSERT JWARD        EMP            JOB              INSERT
```
## Query to List the Current Privilege Domain of Your Session
The `SESSION_ROLES` and `SESSION_PRIVS` data dictionary views list the current privilege domain of a database session.
The `SESSION_ROLES` view lists all roles currently enabled for the issuer.
For example:
```
SELECT * FROM SESSION_ROLES;
```
If user `swilliams` has the `security_admin` role enabled and issues the previous query, then Oracle Database returns the following information:
```
ROLE
------------------------------
SECURITY_ADMIN
```
The following query lists all system privileges currently available in the security domain of the issuer, both from explicit privilege grants and from enabled roles:
```
SELECT * FROM SESSION_PRIVS;
```
If user `swilliams` has the `security_admin` role enabled and issues the previous query, then Oracle Database returns the following results:
```
PRIVILEGE
----------------------------------------
AUDIT SYSTEM CREATE SESSION CREATE USER BECOME USER ALTER USER DROP USER CREATE ROLE DROP ANY ROLE GRANT ANY ROLE AUDIT ANY CREATE PROFILE ALTER PROFILE DROP PROFILE
```
If the `security_admin` role is disabled for user `swilliams`, then the first query would return no rows, while the second query would only return a row for the `CREATE SESSION` privilege grant.
## Query to List Roles of the Database
The `DBA_ROLES` data dictionary view lists all roles of a database and the authentication used for each role.
For example:
```
SELECT * FROM DBA_ROLES;
ROLE                  PASSWORD
----------------      --------
CONNECT               NO RESOURCE              NO DBA                   NO SECURITY_ADMIN        YES
```
## Query to List Information About the Privilege Domains of Roles
The `ROLE_ROLE_PRIVS`, `ROLE_SYS_PRIVS`, and `ROLE_TAB_PRIVS` data dictionary views list information about the privilege domains of roles.
For example:
```
SELECT GRANTED_ROLE, ADMIN_OPTION FROM ROLE_ROLE_PRIVS WHERE ROLE = 'SYSTEM_ADMIN';
GRANTED_ROLE              ADM
----------------          ----
SECURITY_ADMIN            NO
```
The following query lists all the system privileges granted to the `security_admin` role:
```
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'SECURITY_ADMIN';
ROLE                    PRIVILEGE                      ADM
----------------------- -----------------------------  ---
SECURITY_ADMIN           ALTER PROFILE                 YES SECURITY_ADMIN           ALTER USER                    YES SECURITY_ADMIN           AUDIT ANY                     YES SECURITY_ADMIN           AUDIT SYSTEM                  YES SECURITY_ADMIN           BECOME USER                   YES SECURITY_ADMIN           CREATE PROFILE                YES SECURITY_ADMIN           CREATE ROLE                   YES SECURITY_ADMIN           CREATE USER                   YES SECURITY_ADMIN           DROP ANY ROLE                 YES SECURITY_ADMIN           DROP PROFILE                  YES SECURITY_ADMIN           DROP USER                     YES SECURITY_ADMIN           GRANT ANY ROLE                YES
```
The following query lists all the object privileges granted to the `security_admin` role:
```
SELECT TABLE_NAME, PRIVILEGE FROM ROLE_TAB_PRIVS WHERE ROLE = 'SECURITY_ADMIN';
TABLE_NAME                     PRIVILEGE
---------------------------    ----------------
AUD$                           DELETE AUD$                           SELECT
```
## Related Topics
  **- Oracle Database Reference
  **- Oracle Database Reference for detailed information about the DBA_SYS_PRIVS view
  **- Oracle Database Reference for detailed information about the DBA_ROLE_PRIVS view
  **- Oracle Database Reference for detailed information about the DBA_TAB_PRIVS view
  **- Oracle Database Reference for detailed information about the SESSION_ROLES view
  **- Oracle Database Reference for detailed information about the DBA_ROLES view
