# Tutorial: Analyzing Privilege Use by a User Who Has the DBA Role

This tutorial demonstrates how to analyze the privilege use of a user who has the `DBA` role and performs database tuning operations.
- Step 1: Create User Accounts You must create two users, one to create the privilege analysis policy and a second user whose privilege use will be analyzed.
- Step 2: Create and Enable a Privilege Analysis Policy User pa_admin must create the and enable the privilege analysis policy.
````
- Step 3: Perform the Database Tuning Operations User tjones uses the DBA role to perform database tuning operations.
- Step 4: Disable the Privilege Analysis Policy You must disable the policy before you can generate a report that captures the actions of user tjones.
- Step 5: Generate and View Privilege Analysis Reports With the privilege analysis policy disabled, user pa_admin can generate and view privilege analysis reports.
- Step 6: Remove the Components for This Tutorial You can remove the components that you created for this tutorial if you no longer need them.
## Step 1: Create User Accounts
You must create two users, one to create the privilege analysis policy and a second user whose privilege use will be analyzed.
- Log into the database instance as a user who has the CREATE USER system privilege. For example:
```
sqlplus sec_admin Enter password: password
```
```
In a multitenant environment, you must log into the appropriate pluggable database (PDB).
For example:
```
```
sqlplus sec_admin@hrpdb Enter password: password
```
```
To find the available PDBs, query the `DBA_PDBS` data dictionary view. To check the current PDB, run the `show con_name` command.
```
  - Create the following users:
```
CREATE USER pa_admin IDENTIFIED BY password;
CREATE USER tjones IDENTIFIED BY password;
```
- Connect as a user who has the privileges to grant roles and system privileges to other users, and who has been granted the owner authorization for the Oracle System Privilege and Role Management realm. (User SYS has these privileges by default.) For example:
```
CONNECT dba_psmith -- Or, CONNECT dba_psmith@hrpdb Enter password: password
```
```
In SQL*Plus, a user who has been granted the `DV_OWNER` role can check the authorization by querying the `DBA_DV_REALM_AUTH` data dictionary view. To grant the user authorization, use the `DBMS_MACADM.ADD_AUTH_TO_REALM` procedure.
```
  - Grant the following roles and privileges to the users.
```
GRANT CREATE SESSION, CAPTURE_ADMIN TO pa_admin;
GRANT CREATE SESSION, DBA TO tjones;
```
```
User `pa_admin` will create the privilege analysis policy that will analyze the database tuning operations that user `tjones` will perform.
```
## Step 2: Create and Enable a Privilege Analysis Policy
User `pa_admin` must create the and enable the privilege analysis policy.
  - Connect as user pa_admin.
```
CONNECT pa_admin -- Or, CONNECT pa_admin@hrpdb Enter password: password
```
  - Create the following privilege analysis policy:
```
BEGIN DBMS_PRIVILEGE_CAPTURE.CREATE_CAPTURE( name             => 'dba_tuning_priv_analysis_pol',
  description      => 'Analyzes DBA tuning privilege use',
type             => DBMS_PRIVILEGE_CAPTURE.G_CONTEXT, condition        => 'SYS_CONTEXT(''USERENV'', ''SESSION_USER'')=''TJONES''');
END;
/
```
```
In this example:
- `type` specifies the type of capture condition that is defined by the `condition` parameter, described next. In this policy, the type is a context-based condition.
- `condition` specifies condition using a Boolean expression that must evaluate to `TRUE` for the policy to take effect. In this case, the condition checks if the session user is `tjones`.
```
  - Enable the policy.
```
EXEC DBMS_PRIVILEGE_CAPTURE.ENABLE_CAPTURE ('dba_tuning_priv_analysis_pol');
```
```
At this point, the policy is ready to start recording the actions of user `tjones`.
```
## Step 3: Perform the Database Tuning Operations
User `tjones` uses the `DBA` role to perform database tuning operations.
  - Connect as user tjones.
```
CONNECT tjones -- Or, CONNECT tjones@hrpdb Enter password: password
```
  - Run the following script to create the PLAN_TABLE table.
```
@$ORACLE_HOME/rdbms/admin/utlxplan.sql
```
```
The location of this script may vary depending on your operating system. This script creates the `PLAN_TABLE` table in the `tjones` schema.
```
  ````- Run the following EXPLAIN PLAN SQL statement on the HR.EMPLOYEES table:
```
EXPLAIN PLAN
 SET STATEMENT_ID = 'Raise in Tokyo'
 INTO PLAN_TABLE
 FOR UPDATE HR.EMPLOYEES
 SET SALARY = SALARY * 1.10
 WHERE DEPARTMENT_ID =
  (SELECT DEPARTMENT_ID FROM HR.DEPARTMENTS WHERE LOCATION_ID = 110);
```
```
Next, user `tjones` will analyze the `HR.EMPLOYEES` table.
```
  - Run either of the following scripts to create the CHAINED_ROWS table
```
@$ORACLE_HOME/rdbms/admin/utlchain.sql
```
```
Or
```
```
@$ORACLE_HOME/rdbms/admin/utlchn1.sql
```
  ````- Run the ANALYZE TABLE statement on the HR.EMPLOYEES table.
```
ANALYZE TABLE HR.EMPLOYEES LIST CHAINED ROWS INTO CHAINED_ROWS;
```
## Step 4: Disable the Privilege Analysis Policy
You must disable the policy before you can generate a report that captures the actions of user `tjones`.
  - Connect as user pa_admin.
```
CONNECT pa_admin -- Or, CONNECT pa_admin@hrpdb Enter password: password
```
  - Disable the dba_tuning_priv_analysis_pol privilege policy.
```
EXEC DBMS_PRIVILEGE_CAPTURE.DISABLE_CAPTURE ('dba_tuning_priv_analysis_pol');
```
## Step 5: Generate and View Privilege Analysis Reports
With the privilege analysis policy disabled, user `pa_admin` can generate and view privilege analysis reports.
  - As user pa_admin, generate the privilege analysis results.
```
EXEC DBMS_PRIVILEGE_CAPTURE.GENERATE_RESULT ('dba_tuning_priv_analysis_pol');
```
```
The generated results are stored in the privilege analysis data dictionary views.
```
  - Enter the following commands to format the data dictionary view output:
```
col username format a8 col sys_priv format a18 col used_role format a20 col path format a150 col obj_priv format a10 col object_owner format a10 col object_name format a10 col object_type format a10
```
  - Find the system privileges and roles that user tjones used during the privilege analysis period.
```
SELECT USERNAME, SYS_PRIV, USED_ROLE, PATH FROM DBA_USED_SYSPRIVS_PATH WHERE USERNAME = 'TJONES' ORDER BY 1, 2, 3;
```
```
Output similar to the following appears:
```
```
USERNAME SYS_PRIV           USED_ROLE
-------- ------------------ --------------------
PATH
-------------------------------------------------------------------------------
TJONES   ANALYZE ANY        IMP_FULL_DATABASE GRANT_PATH('TJONES', 'DBA') TJONES   ANALYZE ANY        IMP_FULL_DATABASE GRANT_PATH('TJONES', 'DBA', 'IMP_FULL_DATABASE') TJONES   ANALYZE ANY        IMP_FULL_DATABASE GRANT_PATH('TJONES', 'DBA', 'DATAPUMP_IMP_FULL_DATABASE', 'IMP_FULL_DATABASE') ...
```
```
```
  - Find the object privileges and roles that user tjones used during the privilege analysis period.
```
col username format a9 col used_role format a10 col object_name format a22 col object_type format a12 SELECT USERNAME, OBJ_PRIV, USED_ROLE, OBJECT_OWNER, OBJECT_NAME, OBJECT_TYPE FROM DBA_USED_OBJPRIVS WHERE USERNAME = 'TJONES' ORDER BY 1, 2, 3, 4, 5, 6;
```
Output similar to the following appears:
```
USERNAME  OBJ_PRIV   USED_ROLE  OBJECT_OWN OBJECT_NAME            OBJECT_TYPE
--------- ---------- ---------- ---------- ---------------------- ------------
TJONES    EXECUTE    PUBLIC     SYS        DBMS_APPLICATION_INFO  PACKAGE TJONES    SELECT     PUBLIC     SYS        DUAL                   TABLE TJONES    SELECT     PUBLIC     SYS        DUAL                   TABLE TJONES    SELECT     PUBLIC     SYSTEM     PRODUCT_PRIVS          VIEW ...
```
  - Find the unused system privileges for user tjones.
```
col username format a9 col sys_priv format a35 SELECT USERNAME, SYS_PRIV FROM DBA_UNUSED_SYSPRIVS WHERE USERNAME = 'TJONES' ORDER BY 1, 2;
USERNAME SYS_PRIV
-------- ------------------------------
TJONES   ADMINISTER ANY SQL TUNING SET TJONES   ADMINISTER DATABASE TRIGGER TJONES   ADMINISTER RESOURCE MANAGER TJONES   ADMINISTER SQL TUNING SET TJONES   ALTER ANY ASSEMBLY TJONES   ON COMMIT REFRESH ...
```
## Step 6: Remove the Components for This Tutorial
You can remove the components that you created for this tutorial if you no longer need them.
  ````- As user pa_admin, drop the dba_tuning_priv_analysis_pol privilege analysis policy.
```
EXEC DBMS_PRIVILEGE_CAPTURE.DROP_CAPTURE ('dba_tuning_priv_analysis_pol');
```
```
Even though in the next steps you will drop the `pa_admin` user, including any objects created in this user's schema, you must manually drop the `dba_tuning_priv_analysis_pol` privilege analysis policy because this object resides in the `SYS` schema.
```
- Connect as the user who created the user accounts. For example:
```
CONNECT sec_admin -- Or, CONNECT sec_admin@hrpdb
Enter password: password
```
  ````- Drop the users pa_admin and tjones.
```
DROP USER pa_admin CASCADE;
DROP USER tjones;
```
