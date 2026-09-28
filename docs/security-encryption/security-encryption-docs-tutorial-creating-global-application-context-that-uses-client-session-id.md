# Tutorial: Creating a Global Application Context That Uses a Client Session ID

This tutorial demonstrates how you can create a global application context that uses a client session ID.
- About This Tutorial This tutorial shows how to create a global application context that uses a client session ID for a lightweight user application.
- Step 1: Create User Accounts A security administrator will manage the application context and its package, and a user account will own the connection pool.
- Step 2: Create the Global Application Context Next, you are ready to create the global application context.
- Step 3: Create a Package for the Global Application Context The PL/SQL package will manage the global application context that you created.
- Step 4: Test the Newly Created Global Application Context At this stage, you are ready to explore how this global application context and session ID settings work.
- Step 5: Modify the Session ID and Test the Global Application Context Again Next, clear and then modify the session ID and test the global application context again.
- Step 6: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
## About This Tutorial
This tutorial shows how to create a global application context that uses a client session ID for a lightweight user application.
It demonstrates how to control nondatabase user access by using a connection pool. If you are using a multitenant environment, then this tutorial applies to the current PDB only.
## Step 1: Create User Accounts
A security administrator will manage the application context and its package, and a user account will own the connection pool.
  ````- Log on to SQL*Plus as SYS with the SYSDBA administrative privilege.
```
sqlplus sys as sysdba Enter password: password
```
- In a multitenant environment, connect to the appropriate PDB. For example:
```
CONNECT SYS@my_pdb AS SYSDBA Enter password: password
```
```
To find the available PDBs, query the `DBA_PDBS` data dictionary view. To check the current PDB, run the `show con_name` command.
```
  - Create the local user account sysadmin_ctx, who will administer the global application context.
```
CREATE USER sysadmin_ctx IDENTIFIED BY password CONTAINER = CURRENT;
GRANT CREATE SESSION, CREATE ANY CONTEXT, CREATE PROCEDURE TO sysadmin_ctx;
GRANT EXECUTE ON DBMS_SESSION TO sysadmin_ctx;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
```
  - Create the local database account apps_user, who will own the connection pool.
```
CREATE USER apps_user IDENTIFIED BY password CONTAINER = CURRENT;
GRANT CREATE SESSION TO apps_user;
```
```
Replace *password* with a password that is secure.
```
## Step 2: Create the Global Application Context
Next, you are ready to create the global application context.
  - Log on as the security administrator sysadmin_ctx.
```
CONNECT sysadmin_ctx -- Or, CONNECT sysadmin_ctx@hrpdb Enter password: password
```
  - Create the cust_ctx global application context.
```
CREATE CONTEXT global_cust_ctx USING cust_ctx_pkg ACCESSED GLOBALLY;
```
```
The `cust_ctx` context is created and associated with the schema of the security administrator `sysadmin_ctx`. However, the `SYS` schema owns the application context.
```
## Step 3: Create a Package for the Global Application Context
The PL/SQL package will manage the global application context that you created.
  - As sysadmin_ctx, create the following PL/SQL package:
```
CREATE OR REPLACE PACKAGE cust_ctx_pkg AS PROCEDURE set_session_id(session_id_p IN NUMBER);
PROCEDURE set_cust_ctx(sec_level_attr IN VARCHAR2, sec_level_val IN VARCHAR2);
PROCEDURE clear_hr_session(session_id_p IN NUMBER);
PROCEDURE clear_hr_context;
END;
/ CREATE OR REPLACE PACKAGE BODY cust_ctx_pkg AS session_id_global NUMBER;
PROCEDURE set_session_id(session_id_p IN NUMBER) AS BEGIN session_id_global := session_id_p;
DBMS_SESSION.SET_IDENTIFIER(session_id_p);
END set_session_id;
PROCEDURE set_cust_ctx(sec_level_attr IN VARCHAR2, sec_level_val IN VARCHAR2) AS BEGIN DBMS_SESSION.SET_CONTEXT( namespace  => 'global_cust_ctx', attribute  => sec_level_attr, value      => sec_level_val, username   => USER, -- Retrieves the session user, in this case, apps_user client_id  => session_id_global);
END set_cust_ctx;
PROCEDURE clear_hr_session(session_id_p IN NUMBER) AS BEGIN DBMS_SESSION.SET_IDENTIFIER(session_id_p);
DBMS_SESSION.CLEAR_IDENTIFIER;
END clear_hr_session;
PROCEDURE clear_hr_context AS BEGIN DBMS_SESSION.CLEAR_CONTEXT('global_cust_ctx', session_id_global);
END clear_hr_context;
END;
/
```
```
For a detailed explanation of how this type of package works, see [Example 13-9](pl-sql-package-manage-global-application-context.html#GUID-32003F45-C354-49F4-9BC7-812E469B941B__CIHIEJHD).
```
  ``````- Grant EXECUTE privileges on the cust_ctx_pkg package to the connection pool owner, apps_user.
```
GRANT EXECUTE ON cust_ctx_pkg TO apps_user;
```
## Step 4: Test the Newly Created Global Application Context
At this stage, you are ready to explore how this global application context and session ID settings work.
  - Log on to SQL*Plus as the connection pool owner, user apps_user.
```
CONNECT apps_user -- Or, CONNECT apps_user@hrpdb
Enter password: password
```
  - When the connection pool user logs on, the application sets the client session identifier as follows:
```
BEGIN
 sysadmin_ctx.cust_ctx_pkg.set_session_id(34256);
END;
/
```
```
```
  - Set the session ID:
```
EXEC sysadmin_ctx.cust_ctx_pkg.set_session_id(34256);
```
  - Check the session ID:
```
SELECT SYS_CONTEXT('userenv', 'client_identifier') FROM DUAL;
```
```
 The following output should appear:
```
```
SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')
--------------------------------------------------
34256
```
- Set the global application context as follows:
```
EXEC sysadmin_ctx.cust_ctx_pkg.set_cust_ctx('Category', 'Gold Partner');
EXEC sysadmin_ctx.cust_ctx_pkg.set_cust_ctx('Benefit Level', 'Highest');
```
```
(In a real-world scenario, the middle-tier application would set the global application context values, similar to how the client session identifier was set in Step [2](#GUID-445250D8-B9F1-4221-A541-A8502110154F__CIHIGCDB).)
```
  - Enter the following SELECT SYS_CONTEXT statement to check that the settings were successful:
```
col category format a13
col benefit_level format a14
SELECT SYS_CONTEXT('global_cust_ctx', 'Category') category, SYS_CONTEXT('global_cust_ctx', 'Benefit Level') benefit_level FROM DUAL;
```
```
The following output should appear:
```
```
CATEGORY       BENEFIT_LEVEL
-------------  --------------
Gold Partner   Highest
```
What `apps_user` has done here, within the client session 34256, is set a global application context on behalf of a nondatabase user. This context sets the `Category` and `Benefit Level` `DBMS_SESSION.SET_CONTEXT attributes` to be `Gold Partner` and `Highest`, respectively. The context exists only for user `apps_user` with client ID 34256. When a nondatabase user logs in, behind the scenes, he or she is really logging on as the connection pool user `apps_user`. Hence, the `Gold Partner` and `Highest` context values are available to the nondatabase user.
Suppose the user had been a database user and could log in without using the intended application. (For example, the user logs in using SQL*Plus.) Because the user has not logged in through the connection pool user `apps_user`, the global application context appears empty to our errant user. This is because the context was created and set under the `apps_user` session. If the user runs the `SELECT SYS_CONTEXT` statement, then the following output appears:
```
CATEGORY       BENEFIT_LEVEL
-------------  --------------
```
## Step 5: Modify the Session ID and Test the Global Application Context Again
Next, clear and then modify the session ID and test the global application context again.
  - As user apps_user, clear the session ID.
```
EXEC sysadmin_ctx.cust_ctx_pkg.clear_hr_session(34256);
```
  - Check the global application context settings again.
```
SELECT SYS_CONTEXT('global_cust_ctx', 'Category') category, SYS_CONTEXT('global_cust_ctx', 'Benefit Level') benefit_level FROM DUAL;
CATEGORY       BENEFIT_LEVEL
-------------  --------------
```
```
Because `apps_user` has cleared the session ID, the global application context settings are no longer available.
```
  - Restore the session ID to 34256, and then check the context values.
```
EXEC sysadmin_ctx.cust_ctx_pkg.set_session_id(34256);
SELECT SYS_CONTEXT('global_cust_ctx', 'Category') category, SYS_CONTEXT('global_cust_ctx', 'Benefit Level') benefit_level FROM DUAL;
```
```
The following output should appear:
```
```
CATEGORY       BENEFIT_LEVEL
-------------  --------------
Gold Partner   Highest
```
```
As you can see, resetting the session ID to 34256 brings the application context values back again. To summarize, the global application context must be set only *once* for this user, but the client session ID must be set *each time* the user logs on.
```
  - Now try clearing and then checking the global application context values.
```
EXEC sysadmin_ctx.cust_ctx_pkg.clear_hr_context;
SELECT SYS_CONTEXT('global_cust_ctx', 'Category') category, SYS_CONTEXT('global_cust_ctx', 'Benefit Level') benefit_level FROM DUAL;
```
```
The following output should appear:
```
```
CATEGORY       BENEFIT_LEVEL
-------------  --------------
```
```
At this stage, the client session ID, 34256 is still in place, but the application context settings no longer exist. This enables you to continue the session for this user but without using the previously set application context values.
```
## Step 6: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  ````- Connect as SYS with the SYSDBA administrative privilege.
```
CONNECT SYS AS SYSDBA -- Or, CONNECT SYS@mypdb AS SYSDBA Enter password: password
```
  - Drop the global application context.
```
DROP CONTEXT global_cust_ctx;
```
```
Remember that even though `sysadmin_ctx` created the global application context, it is owned by the `SYS` schema.
```
  - Drop the two sample users.
```
DROP USER sysadmin_ctx CASCADE;
DROP USER apps_user;
```
