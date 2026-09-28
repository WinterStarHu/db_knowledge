# Tutorial: Using Capture Runs to Analyze ANY Privilege Use

This tutorial demonstrates how to create capture runs to analyze the use of the `READ ANY TABLE` system privilege.
- Step 1: Create User Accounts You must create two users, one user to create the policy and a second user whose privilege use will be analyzed.
- Step 2: Create and Enable a Privilege Analysis Policy The user pa_admin must create and enable the privilege analysis policy.
````
- Step 3: Use the READ ANY TABLE System Privilege User app_user uses the READ ANY TABLE system privilege.
- Step 4: Disable the Privilege Analysis Policy You must disable the policy before you can generate a report that captures the actions of user app_user.
- Step 5: Generate and View a Privilege Analysis Report With the privilege analysis policy disabled, user pa_admin then can generate and view a privilege analysis report.
- Step 6: Create a Second Capture Run Next, you are ready to create a second capture run for the ANY_priv_analysis_pol privilege analysis policy.
- Step 7: Remove the Components for This Tutorial You can remove the components that you created for this tutorial if you no longer need them.
## Step 1: Create User Accounts
You must create two users, one user to create the policy and a second user whose privilege use will be analyzed.
- Log into the database instance as a user who has the CREATE USER system privilege. For example:
```
sqlplus sec_admin Enter password: password
```
```
In a multitenant environment, you must connect to the appropriate pluggable database (PDB).
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
CREATE USER app_user IDENTIFIED BY password;
```
- Connect as a user who has the privileges to grant roles and system privileges to other users, and who has been granted the owner authorization for the Oracle System Privilege and Role Management realm. (User SYS has these privileges by default.) For example:
```
CONNECT dba_psmith -- Or, CONNECT dba_psmith@hrpdb Enter password: password
```
```
In SQL*Plus, a user who has been granted the `DV_OWNER` role can check the authorization by querying the `DBA_DV_REALM_AUTH` data dictionary view. To grant the user authorization, use the `DBMS_MACADM.ADD_AUTH_TO_REALM` procedure.
```
  - Grant the following role and privilege to the users.
```
GRANT CREATE SESSION, CAPTURE_ADMIN TO pa_admin;
GRANT CREATE SESSION, READ ANY TABLE TO app_user;
```
```
User `pa_admin` will create the privilege analysis policy that will analyze the `READ ANY TABLE` query that user `app_user` will perform.
```
## Step 2: Create and Enable a Privilege Analysis Policy
The user `pa_admin` must create and enable the privilege analysis policy.
  - Connect as user pa_admin.
```
CONNECT pa_admin -- Or, CONNECT pa_admin@hrpdb Enter password: password
```
  - Create the following privilege analysis policy:
```
BEGIN DBMS_PRIVILEGE_CAPTURE.CREATE_CAPTURE( name           => 'ANY_priv_analysis_pol',
  description    => 'Analyzes system privilege use',
type           => DBMS_PRIVILEGE_CAPTURE.G_CONTEXT, condition      => 'SYS_CONTEXT(''USERENV'', ''SESSION_USER'')=''APP_USER''');
END;
/
```
```
In this example:
- `type` specifies the type of capture condition that is defined by the `condition` parameter, described next. In this policy, the type is a context-based condition.
- `condition` specifies condition using a Boolean expression that must evaluate to `TRUE` for the policy to take effect. In this case, the condition checks if the session user is `app_user`.
```
  - Enable the policy and create a capture run for it.
```
BEGIN DBMS_PRIVILEGE_CAPTURE.ENABLE_CAPTURE ( name       => 'ANY_priv_analysis_pol', run_name   => 'ANY_priv_pol_run_1');
END;
/
```
```
At this point, the policy is ready to start recording the actions of user `app_user`.
```
## Step 3: Use the READ ANY TABLE System Privilege
User `app_user` uses the `READ ANY TABLE` system privilege.
  - Connect as user app_user.
```
CONNECT app_user -- Or, CONNECT app_user@hrpdb Enter password: password
```
  - Query the HR.EMPLOYEES table.
```
SELECT FIRST_NAME, LAST_NAME, SALARY FROM HR.EMPLOYEES WHERE SALARY > 12000 ORDER BY SALARY DESC;
FIRST_NAME           LAST_NAME                     SALARY
-------------------- ------------------------- ----------
Steven               King                           24000 Neena                Kochhar                        17000 Lex                  De Haan                        17000 John                 Russell                        14000 Karen                Partners                       13500 Michael              Hartstein                      13000 Shelley              Higgins                        12008 Nancy                Greenberg                      12008
```
## Step 4: Disable the Privilege Analysis Policy
You must disable the policy before you can generate a report that captures the actions of user `app_user`.
  - Connect as user pa_admin.
```
CONNECT pa_admin -- Or, CONNECT pa_admin@hrpdb Enter password: password
```
  - Disable the ANY_priv_analysis_pol privilege policy.
```
EXEC DBMS_PRIVILEGE_CAPTURE.DISABLE_CAPTURE ('ANY_priv_analysis_pol');
```
## Step 5: Generate and View a Privilege Analysis Report
With the privilege analysis policy disabled, user `pa_admin` then can generate and view a privilege analysis report.
  - As user pa_admin, generate the privilege analysis results.
```
BEGIN DBMS_PRIVILEGE_CAPTURE.GENERATE_RESULT ( name      => 'ANY_priv_analysis_pol', run_name  => 'ANY_priv_pol_run_1');
END;
/
```
```
The generated results are stored in the privilege analysis data dictionary views.
```
  - Enter the following commands to format the data dictionary view output:
```
col username format a10 col sys_priv format a16 col object_owner format a13 col object_name format a23 col run_name format a27
```
  - Find the system privileges that app_user used and the objects on which he used them during the privilege analysis period.
```
SELECT SYS_PRIV, OBJECT_OWNER, OBJECT_NAME, RUN_NAME FROM DBA_USED_PRIVS WHERE USERNAME = 'APP_USER';
```
```
Output similar to the following appears. The first row shows that `app_user` used the `READ ANY TABLE` privilege on the `HR.EMPLOYEES` table.
```
```
SYS_PRIV         OBJECT_OWNER  OBJECT_NAME             RUN_NAME
---------------- ------------- ----------------------- ------------------
SYSTEM        PRODUCT_PRIVS           ANY_PRIV_POL_RUN_1 SYS           DUAL                    ANY_PRIV_POL_RUN_1 SYS           DUAL                    ANY_PRIV_POL_RUN_1 CREATE SESSION                                         ANY_PRIV_POL_RUN_1 SYS           DBMS_APPLICATION_INFO   ANY_PRIV_POL_RUN_1 READ ANY TABLE   HR            EMPLOYEES               ANY_PRIV_POL_RUN_1
```
At this stage, the privilege analysis results remain available in the privilege analysis data dictionary views, even if you create additional capture runs in the future.
## Step 6: Create a Second Capture Run
Next, you are ready to create a second capture run for the `ANY_priv_analysis_pol` privilege analysis policy.
  ``````- As user pa_admin, enable the ANY_priv_analysis_pol privilege analysis policy to use capture run ANY_priv_pol_run_1.
```
BEGIN
  DBMS_PRIVILEGE_CAPTURE.ENABLE_CAPTURE (
   name       => 'ANY_priv_analysis_pol',
   run_name   => 'ANY_priv_pol_run_2');
END;
/
```
  - Connect as user app_user.
```
CONNECT app_user -- Or, CONNECT app_user@hrpdb
Enter password: password
```
  - Query the HR.JOBS table.
```
SELECT MAX_SALARY FROM HR.JOBS WHERE MAX_SALARY > 20000;
```
  - Connect as user pa_admin.
```
CONNECT pa_admin -- Or, CONNECT pa_admin@hrpdb
Enter password: password
```
  - Disable the ANY_priv_analysis_pol privilege policy.
```
EXEC DBMS_PRIVILEGE_CAPTURE.DISABLE_CAPTURE ('ANY_priv_analysis_pol');
```
  - Generate a second privilege analysis report.
```
BEGIN
  DBMS_PRIVILEGE_CAPTURE.GENERATE_RESULT (
    name      => 'ANY_priv_analysis_pol',
    run_name  => 'ANY_priv_pol_run_2');
END;
/
```
  - Find the system privileges that app_user used and the objects on which he used them during the privilege analysis period.
```
SELECT SYS_PRIV, OBJECT_OWNER, OBJECT_NAME, RUN_NAME FROM DBA_USED_PRIVS WHERE USERNAME = 'APP_USER' ORDER BY RUN_NAME;
```
```
Output similar to the following appears, which now shows the results of both of the capture runs that user `pa_admin` created.
```
```
SYS_PRIV         OBJECT_OWNER  OBJECT_NAME             RUN_NAME
---------------- ------------- ----------------------- ----------------------
READ ANY TABLE   HR            EMPLOYEES               ANY_PRIV_POL_RUN_1
                 SYS           DUAL                    ANY_PRIV_POL_RUN_1
CREATE SESSION                                         ANY_PRIV_POL_RUN_1
                 SYS           DUAL                    ANY_PRIV_POL_RUN_1
                 SYSTEM        PRODUCT_PRIVS           ANY_PRIV_POL_RUN_1
                 SYS           DBMS_APPLICATION_INFO   ANY_PRIV_POL_RUN_1
                 SYS           DUAL                    ANY_PRIV_POL_RUN_2
                 SYS           DBMS_APPLICATION_INFO   ANY_PRIV_POL_RUN_2
                 SYSTEM        PRODUCT_PRIVS           ANY_PRIV_POL_RUN_2
                 SYS           DUAL                    ANY_PRIV_POL_RUN_2
READ ANY TABLE   HR            JOBS                    ANY_PRIV_POL_RUN_2
```
## Step 7: Remove the Components for This Tutorial
You can remove the components that you created for this tutorial if you no longer need them.
  ````- As user pa_admin, drop the ANY_priv_analysis_pol privilege analysis policy and its associated capture runs.
```
EXEC DBMS_PRIVILEGE_CAPTURE.DROP_CAPTURE ('ANY_priv_analysis_pol');
```
```
Any capture runs that are associated with this policy are dropped automatically when you run the `DBMS_PRIVILEGE_CAPTURE.DROP_CAPTURE` procedure.
Even though in the next steps you will drop the `pa_admin` user, including any objects created in this user's schema, you must manually drop the `ANY_priv_analysis_pol` privilege analysis policy because this object resides in the `SYS` schema.
```
- Connect as the user who created the user accounts. For example:
```
CONNECT sec_admin -- Or, CONNECT sec_admin@hrpdb Enter password: password
```
  ````- Drop the users pa_admin and app_user.
```
DROP USER pa_admin CASCADE;
DROP USER app_user;
```
