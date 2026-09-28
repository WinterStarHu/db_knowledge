# Guidelines for Securing User Accounts and Privileges

Oracle provides guidelines to secure user accounts and privileges.
  - **Lock and expire default (predefined) user accounts.** Oracle Database installs with several default database user accounts. Upon successful installation of the database, the Database Configuration Assistant automatically locks and expires most default ****database user accounts. If you perform a manual (without using Database Configuration Assistant) installation of Oracle Database, then no default database users are locked upon successful installation of the database server. Or, if you have upgraded from a previous release of Oracle Database, you may have default accounts from earlier releases. Left open in their default states, these user accounts can be exploited, to gain unauthorized access to data or disrupt database operations. You should *lock* **and *expire* all default database user accounts. Oracle Database provides SQL statements to perform these operations. For example:
```
ALTER USER ANONYMOUS PASSWORD EXPIRE ACCOUNT LOCK;
```
```
Installing additional products and components after the initial installation also results in creating more default database accounts. Database Configuration Assistant automatically locks and expires all additionally created database user accounts. Unlock only those accounts that need to be accessed on a regular basis and assign a strong, meaningful password to each of these unlocked accounts. Oracle provides SQL and password management to perform these operations.
If any default database user account other than the ones left open is required for any reason, then a database administrator (DBA) must unlock and activate that account with a new, secure password.
If a default database user account, other than the ones left open, is required for any reason, then a database administrator (DBA) can unlock and activate that account with a new, secure password.
**Securing Oracle Enterprise Manager Accounts**
If you install Oracle Enterprise Manager, the `SYSMAN` and `DBSNMP` accounts are open, unless you configure Oracle Enterprise Manager for central administration. In this case, the `SYSMAN` account (if present) will be locked.
If you do not install Oracle Enterprise Manager, then only the `SYS` and `SYSTEM` accounts are open. Database Configuration Assistant locks and expires all other accounts (including `SYSMAN` and `DBSNMP`).
```
****
````
- Discourage users from using the NOLOGGING clause in SQL statements. In some SQL statements, the user has the option of specifying the NOLOGGING clause, which indicates that the database operation is not logged in the online redo log file. Even though the user specifies the clause, a redo record is still written to the online redo log file. However, there is no data associated with this record. Because of this, using NOLOGGING has the potential for malicious code to be entered can be accomplished without an audit trail.
****
****
**
**
````
  - The number of SYSTEM and OBJECT privileges granted to database users.
  - The number of people who are allowed to make SYS-privileged connections to the database.
``````
    - The number of users who are granted the ANY privileges, such as the DROP ANY TABLE privilege. For example, there is generally no need to grant CREATE ANY TABLE privileges to a non-DBA-privileged user.
``````
  - The number of users who are allowed to perform actions that create, modify, or drop database objects, such as the TRUNCATE TABLE, DELETE TABLE, DROP TABLE statements, and so on.
****
````
  - Limit granting the CREATE ANY EDITION and DROP ANY EDITION privileges. To maintain additional versions of objects, editions can increase resource and disk space consumption in the database. Only grant the CREATE ANY EDITION and DROP ANY EDITION privileges to trusted users who are responsible for performing upgrades.
****
``````````
  - Re-evaluate the SELECT object privilege and SELECT ANY TABLE system privileges that you have granted to users. If you want to restrict users to only being able to query tables, views, materialized views, and synonyms, then grant users the READ object privilege, or for trusted users only, the READ ANY TABLE system privilege. If in addition to performing query operations, you want users to be able to lock tables in exclusive mode or perform SELECT ... FOR UPDATE statements, then grant the user the SELECT object privilege or, for trusted users only, the SELECT ANY TABLE system privilege.
****
  - Restrict the CREATE ANY JOB, BECOME USER, EXP_FULL_DATABASE, and IMP_FULL_DATABASE privileges. Also restrict grants of the CREATE DIRECTORY and CREATE ANY DIRECTORY privileges. These are powerful security-related privileges. Only grant these privileges to users who need them.
****
``````
    - Oracle Data Pump Import utilities impdp and imp, to assume the identity of another user to perform operations that cannot be directly performed by a third party (for example, loading objects such as object privilege grants). In an Oracle Database Vault environment, Database Vault provides several levels of required authorization that affect grants of BECOME USER.
````
  - DBMS_WORKLOAD_CAPTURE and DBMS_WORKLOAD_REPLAY PL/SQL packages, as a required privilege to be granted to users who must use these packages.
If you use the `AUTHID CURRENT_USER` clause when invoking one of these subsystems (for example, in static references in PL/SQL code), then ensure that the `CURRENT_USER` is granted the `BECOME USER` privilege, either by a direct grant or through a role.
****
````````````**````````**
  - Restrict library-related privileges to trusted users only. The CREATE LIBRARY, CREATE ANY LIBRARY, ALTER ANY LIBRARY, and EXECUTE ANY LIBRARY privileges, and grants of EXECUTE ON library_name convey a great deal of power to users. If you plan to create PL/SQL interfaces to libraries, only grant the EXECUTE privilege to the PL/SQL interface. Do not grant EXECUTE on the underlying library. You must have the EXECUTE privilege on a library to create the PL/SQL interface to it. However, users have this privilege implicitly on libraries that they create in their own schemas. Explicit grants of EXECUTE ON library_name are rarely required. Only make an explicit grant of these privileges to trusted users, and never to the PUBLIC role.
****
````
  - Restrict synonym-related privileges to trusted users only. The CREATE PUBLIC SYNONYM and DROP PUBLIC SYNONYM system privileges convey a great deal of power to these users. Do not grant these privileges to users, unless they are trusted.
****
````````````
  - Do not allow non-administrative users access to objects owned by the SYS schema. Do not allow users to alter table rows or schema objects in the SYS schema, because doing so can compromise data integrity. Limit the use of statements such as DROP TABLE, TRUNCATE TABLE, DELETE, INSERT, or similar object-modification statements on SYS objects only to highly privileged administrative users.
********
  - Restrict permissions on run-timefacilities. Many Oracle Database products use run-time facilities, such as Oracle Java Virtual Machine (OJVM). Do not assign all permissions to a database run-time facility. Instead, grant specific permissions to the explicit document the root file paths for facilities that might run files and packages outside the database. Here is an example of a vulnerable run-time call, which individual files are specified:
```
call dbms_java.grant_permission('wsmith', 'SYS:java.io.FilePermission','>','read');
```
```
Here is an example of a better (more secure) run-time call, which specifies a directory path instead:
```
```
call dbms_java.grant_permission('wsmith', 'SYS:java.io.FilePermission','>','read');
```
****
``````
  - The SYS.USER_HISTORY$ table from all users except SYS and DBA accounts
  - The RESOURCE role from typical application accounts
  - The CONNECT role from typical application accounts
  - The DBA role from users who do not need this role
****
- Grant privileges only to roles. Granting privileges to roles and not individual users makes the management and tracking of privileges much easier.
****
- Limit the proxy account (for proxy authorization) privileges to CREATE SESSION only.
****
- Use secure application roles to protect roles that are enabled by application code. Secure application roles allow you to define a set of conditions, within a PL/SQL package, that determine whether or not a user can log on to an application. Users do not need to use a password with secure application roles. Another approach to protecting roles from being enabled or disabled in an application is the use of role passwords. This approach prevents a user from directly accessing the database in SQL (rather than the application) to enable the privileges associated with the role. However, Oracle recommends that you use secure application roles instead, to avoid having to manage another set of passwords.
****
- Create privilege captures to find excessively granted privileges. Privilege analysis captures the privileges that users and applications use, and then presents these in a format for easy analysis. From there, you can revoke unnecessary privileges if you want.
****
  - ALTER SYSTEM
  - AUDIT SYSTEM
  - CREATE EXTERNAL JOB
Oracle recommends that you also audit the following privileges:
````````
  - ALL PRIVILEGES (which includes privileges such as BECOME USER, CREATE LIBRARY, and CREATE PROCEDURE)
  - DBMS_BACKUP_RESTORE package
````
  - EXECUTE to DBMS_SYS_SQL
  - SELECT ANY TABLE
````
  - SELECT on PERFSTAT.STATS$SQLTEXT
````
  - SELECT on PERFSTAT.STATS$SQL_SUMMARY
````
  - SELECT on SYS.SOURCE$
  - Privileges that have the WITH ADMIN clause
  - Privileges that have the WITH GRANT clause
  - Privileges that have the CREATE keyword
****
  - DBA_*
  - DBA_ROLES
  - DBA_SYS_PRIVS
  - DBA_ROLE_PRIVS
  - DBA_TAB_PRIVS
  - DBA_AUDIT_TRAIL (if standard auditing is enabled)
  - DBA_FGA_AUDIT_TRAIL (if fine-grained auditing is enabled)
## Related Topics
  **- Oracle Database Vault Administrator’s Guide
  - Performing Privilege Analysis to Identify Privilege Use
