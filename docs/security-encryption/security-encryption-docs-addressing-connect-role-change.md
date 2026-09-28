# Addressing the CONNECT Role Change

The `CONNECT` role, introduced with Oracle Database version 7, added new and robust support for database roles.
- Why Was the CONNECT Role Changed? The CONNECT role is used in sample code, applications, documentation, and technical papers.
- How the CONNNECT Role Change Affects Applications The CONNECT role changes can be seen in database upgrades, account provisioning, and installation of applications using new databases.
- How the CONNECT Role Change Affects Users The change to the CONNECT role affects general users, application developers, and client/server applications differently.
- Approaches to Addressing the CONNECT Role Change Oracle recommends three approaches to address the impact of the CONNECT role change.
## Why Was the CONNECT Role Changed?
The `CONNECT` role is used in sample code, applications, documentation, and technical papers.
In Oracle Database 10*g* Release 2 (10.2), the `CONNECT` role was changed. If you are upgrading from a release earlier than Oracle Database 10.2 to the current release, then you should be aware of how the `CONNECT` role has changed in the most recent release.
The `CONNECT` role was originally established a special set of privileges. These privileges were as follows: `ALTER SESSION`, `CREATE CLUSTER`, `CREATE DATABASE LINK`, `CREATE SEQUENCE`, `CREATE SESSION`, `CREATE SYNONYM`, `CREATE TABLE`, `CREATE VIEW`.
Beginning in Oracle Database 10*g* Release 2, the `CONNECT` role has only the `CREATE SESSION` privilege, all other privileges are removed. Starting with Oracle Database 12*c* Release 1, the `CONNECT` role had the `CREATE SESSION` and `SET CONTAINER` privileges.
Although the `CONNECT` role was frequently used to provision new accounts in Oracle Database, connecting to the database does not require all those privileges. Making this change enables you to enforce good security practices more easily.
Each user should have only the privileges needed to perform his or her tasks, an idea called the principle of least privilege. Least privilege mitigates risk by limiting privileges, so that it remains easy to do what is needed while concurrently reducing the ability to do inappropriate things, either inadvertently or maliciously.
## How the CONNNECT Role Change Affects Applications
The `CONNECT` role changes can be seen in database upgrades, account provisioning, and installation of applications using new databases.
- How the CONNECT Role Change Affects Database Upgrades You should be aware of how the CONNECT role affects database upgrades.
- How the CONNECT Role Change Affects Account Provisioning You should be aware of how the CONNECT role affects accounts provisioning.
- How the CONNECT Role Change Affects Applications Using New Databases You should be aware of how the CONNECT role affects applications that use new databases.
### How the CONNECT Role Change Affects Database Upgrades
You should be aware of how the CONNECT role affects database upgrades.
Upgrading your existing Oracle database to Oracle Database 10*g* Release 2 (10.2) automatically changes the `CONNECT` role to have only the `CREATE SESSION` privilege.
Most applications are not affected because the applications objects already exist: no new tables, views, sequences, synonyms, clusters, or database links need to be created.
Applications that create tables, views, sequences, synonyms, clusters, or database links, or that use the `ALTER SESSION` command dynamically, may fail due to insufficient privileges.
### How the CONNECT Role Change Affects Account Provisioning
You should be aware of how the CONNECT role affects accounts provisioning.
If your application or DBA grants the `CONNECT` role as part of the account provisioning process, then only `CREATE SESSION` privileges are included. Any additional privileges must be granted either directly or through another role.
This issue can be addressed by creating a new customized database role.
### How the CONNECT Role Change Affects Applications Using New Databases
You should be aware of how the CONNECT role affects applications that use new databases.
New databases created using the Oracle Database 10*g* Release 2 (10.2) Utility (DBCA), or using database creation templates generated from DBCA, define the `CONNECT` role with only the `CREATE SESSION` privilege.
Installing an application to use a new database may fail if the database schema used for the application is granted privileges solely through the `CONNECT` role.
## How the CONNECT Role Change Affects Users
The change to the `CONNECT` role affects general users, application developers, and client/server applications differently.
- How the CONNECT Role Change Affects General Users You should be aware of how the CONNECT role affects general users.
- How the CONNECT Role Change Affects Application Developers You should be aware of how the CONNECT role affects application developers.
- How the CONNECT Role Change Affects Client Server Applications You should be aware of how the CONNECT role affects client server applications.
### How the CONNECT Role Change Affects General Users
You should be aware of how the `CONNECT` role affects general users.
The new `CONNECT` role supplies only the `CREATE SESSION` privilege. Users who connect to the database to use an application are not affected, because the `CONNECT` role still has the `CREATE SESSION` privilege.
However, appropriate privileges will not be present for a certain set of users if they are provisioned solely with the `CONNECT` role. These are users who create tables, views, sequences, synonyms, clusters, or database links, or use the `ALTER SESSION` command. The privileges they need are no longer provided with the `CONNECT` role. To authorize the additional privileges needed, the database administrator must create and apply additional roles for the appropriate privileges, or grant them directly to the users who need them.
Note that the `ALTER SESSION` privilege is required for setting events. Few database users should require the `ALTER SESSION` privilege.
The `ALTER SESSION` privilege is *not* required for other alter session commands.
### How the CONNECT Role Change Affects Application Developers
You should be aware of how the CONNECT role affects application developers.
Application developers provisioned solely with the `CONNECT` role do not have appropriate privileges to create tables, views, sequences, synonyms, clusters, or database links, nor to use the `ALTER SESSION` statement.
You must either create and apply additional roles for the appropriate privileges, or grant them directly to the application developers who need them.
### How the CONNECT Role Change Affects Client Server Applications
You should be aware of how the CONNECT role affects client server applications.
Most client/server applications that use dedicated user accounts will not be affected by this change.
However, applications that create private synonyms or temporary tables using dynamic SQL in the user schema during account provisioning or run-time operations will be affected. They will require additional roles or grants to acquire the system privileges appropriate to their activities.
## Approaches to Addressing the CONNECT Role Change
Oracle recommends three approaches to address the impact of the `CONNECT` role change.
- Creating a New Database Role The privileges removed from the CONNECT role can be managed by creating a new database role.
````
- Restoring the CONNECT Privilege The rstrconn.sql script restores the CONNECT privileges.
````
- Data Dictionary View to Show CONNECT Grantees The DBA_CONNECT_ROLE_GRANTEES data dictionary view enables administrators who continue using the old CONNECT role to see which users have that role.
- Least Privilege Analysis Studies Oracle partners and application providers should conduct a least privilege analysis so that they can deliver more secure products to their Oracle customers.
### Creating a New Database Role
The privileges removed from the `CONNECT` role can be managed by creating a new database role.
- Connect to the upgraded Oracle database and create a new database role. The following example uses a role called my_app_developer.
```
CREATE ROLE my_app_developer;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE SYNONYM, CREATE CLUSTER, CREATE DATABASE LINK, ALTER SESSION TO my_app_developer;
```
  - Determine which users or database roles have the CONNECT role, and grant the new role to these users or roles.
```
SELECT USER$.NAME, ADMIN_OPTION, DEFAULT_ROLE
 FROM USER$, SYSAUTH$, DBA_ROLE_PRIVS
 WHERE PRIVILEGE# =
 (SELECT USER# FROM USER$ WHERE NAME = 'CONNECT')
 AND USER$.USER# = GRANTEE#
 AND GRANTEE = USER$.NAME
 AND GRANTED_ROLE = 'CONNECT';
NAME                           ADMIN_OPTI DEF
------------------------------ ---------- ---
R1                             YES        YES
R2                             NO         YES
GRANT my_app_developer TO R1 WITH ADMIN OPTION;
GRANT my_app_developer TO R2;
```
- Determine the privileges that users require by creating a privilege analysis policy. The information that you gather can then be analyzed and used to create additional database roles with finer granularity. Privileges that are not used can then be revoked for specific users. For example:
```
BEGIN
 DBMS_PRIVILEGE_CAPTURE.CREATE_CAPTURE(
  name          => 'my_app_dev_role_pol',
  description   => 'Captures my_app_developer role use',
  type          => DBMS_PRIVILEGE_CAPTURE.G_ROLE,
  roles         => role_name_list('my_app_developer');
END;
/
EXEC DBMS_PRIVILEGE_CAPTURE.ENABLE_CAPTURE ('my_app_dev_role_pol');
```
  - After a period of time, disable the privilege analysis policy and then generate a report.
```
EXEC DBMS_PRIVILEGE_CAPTURE.DISABLE_CAPTURE ('my_app_dev_role_pol');
EXEC DBMS_PRIVILEGE_CAPTURE.GENERATE_RESULT ('my_app_dev_role_pol');
```
- After you generate the report, query the privilege analysis data dictionary views. For example:
```
SELECT USERNAME, SYS_PRIV, OBJECT_OWNER, OBJECT_NAME FROM DBA_USED_PRIVS;
```
### Restoring the CONNECT Privilege
The `rstrconn.sql` script restores the `CONNECT` privileges.
After a database upgrade or new database creation, you can use this script to grant the privileges that were removed from the `CONNECT` role in Oracle Database 10*g* release 2 (10.2). If you use this approach, then you should revoke privileges that are not used from users who do not need them.
To restore the `CONNECT` privilege:
  ````- Run the rstrconn.sql script, which is in the $ORACLE_HOME/rdbms/admin directory.
```
@$ORACLE_HOME/rdbm_admin/rstrconn.sql
```
- Monitor the privileges that are used. For example:
```
CREATE AUDIT POLICY connect_priv_pol PRIVILEGES AUDIT CREATE TABLE, CREATE SEQUENCE, CREATE SYNONYM, CREATE DATABASE LINK, CREATE CLUSTER, CREATE VIEW, ALTER SESSION;
AUDIT POLICY connect_priv_pol BY psmith;
```
- Periodically, monitor database privilege usage. For example:
```
SELECT USERID, NAME FROM AUD$, SYSTEM_PRIVILEGE_MAP WHERE - PRIV$USED = PRIVILEGE;
USERID                         NAME
------------------------------ ----------------
ACME                           CREATE TABLE ACME                           CREATE SEQUENCE ACME                           CREATE TABLE ACME                           ALTER SESSION APPS                           CREATE TABLE APPS                           CREATE TABLE APPS                           CREATE TABLE APPS                           CREATE TABLE 8 rows selected.
```
### Data Dictionary View to Show CONNECT Grantees
The `DBA_CONNECT_ROLE_GRANTEES` data dictionary view enables administrators who continue using the old `CONNECT` role to see which users have that role.
The following table shows the columns in the `DBA_CONNECT_ROLE_GRANTEES` view.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| GRANTEE | VARCHAR2(128) | NULL | User granted the CONNECT role |
| PATH_OF_CONNECT_ROLE_GRANT | VARCHAR2(4000 | NULL | Role (or nested roles) by which the user is granted CONNECT |
| ADMIN_OPT | VARCHAR2(3) | NULL | YES if user has the ADMIN option on CONNECT; otherwise, NO |

### Least Privilege Analysis Studies
Oracle partners and application providers should conduct a least privilege analysis so that they can deliver more secure products to their Oracle customers.
The principle of least privilege mitigates risk by limiting privileges to the minimum set required to perform a given function.
For each class of users that the analysis shows need the same set of privileges, create a role with only those privileges. Remove all other privileges from those users, and assign that role to those users. As needs change, you can grant additional privileges, either directly or through these new roles, or create new roles to meet new needs. This approach helps to ensure that inappropriate privileges have been limited, thereby reducing the risk of inadvertent or malicious harm.
You can create privilege analysis policies that show the use of privileges by database users. The policies capture this information and make it available in data dictionary views. Based on these reports, you can determine who should have access to your data.
## Related Topics
  - Approaches to Addressing the CONNECT Role Change
  - Performing Privilege Analysis to Identify Privilege Use
