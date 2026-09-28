# Tutorial: Creating and Using a Database Session-Based Application Context

This tutorial demonstrates how to create an application context that checks the ID of users who try to log in to the database.
- Step 1: Create User Accounts and Ensure the User SCOTT Is Active To begin this tutorial, you must create the necessary database accounts and endure that the SCOTT user account is active.
- Step 2: Create the Database Session-Based Application Context As the sysadmin_ctx user, you are ready to create the database session-based application context.
- Step 3: Create a Package to Retrieve Session Data and Set the Application Context Next, you must create a PL/SQL package that retrieves the session data and then sets the application context.
- Step 4: Create a Logon Trigger for the Package The logon trigger will execute when the user logs in.
- Step 5: Test the Application Context Now that the components are all in place, you are ready to test the application context.
- Step 6: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
## Step 1: Create User Accounts and Ensure the User SCOTT Is Active
To begin this tutorial, you must create the necessary database accounts and endure that the `SCOTT` user account is active.
  ````- Log on as user SYS and connect using the SYSDBA administrative privilege.
```
sqlplus sys as sysdba Enter password: password
```
- In a multitenant environment, connect to the appropriate PDB. For example:
```
CONNECT SYS@hrpdb AS SYSDBA Enter password: password
```
```
To find the available PDBs, run the `show pdbs` command. To check the current PDB, run the `show con_name` command.
```
  - Create the local user account sysadmin_ctx, who will administer the database session-based application context.
```
CREATE USER sysadmin_ctx IDENTIFIED BY password;
GRANT CREATE SESSION, CREATE ANY CONTEXT, CREATE PROCEDURE, CREATE TRIGGER, ADMINISTER DATABASE TRIGGER TO sysadmin_ctx;
GRANT READ ON HR.EMPLOYEES TO sysadmin_ctx;
GRANT EXECUTE ON DBMS_SESSION TO sysadmin_ctx;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
```
  ````- Create the following user account for Lisa Ozer, who is listed as having lozer for her email account in the HR.EMPLOYEES table.
```
GRANT CREATE SESSION TO LOZER IDENTIFIED BY password;
```
```
Replace *password* with a password that is secure.
```
  ````````- The sample user SCOTT will also be used in this tutorial, so query the DBA_USERS data dictionary view to ensure that the account status for SCOTT is OPEN.
```
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS WHERE USERNAME = 'SCOTT';
```
```
If the `DBA_USERS` view lists user `SCOTT` as locked and expired, then enter the following statement to unlock the `SCOTT` account and create a new password for him:
```
```
ALTER USER SCOTT ACCOUNT UNLOCK IDENTIFIED BY password;
```
```
Enter a password that is secure. For greater security, do **not** give the `SCOTT` account the same password from previous releases of Oracle Database. See [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) for the minimum requirements for creating passwords.
```
## Step 2: Create the Database Session-Based Application Context
As the `sysadmin_ctx` user, you are ready to create the database session-based application context.
  - Log on to SQL*Plus as sysadmin_ctx.
```
CONNECT sysadmin_ctx -- Or, CONNECT sysadmin_ctx@hrpdb Enter password: password
```
  - Create the application context using the following statement:
```
CREATE CONTEXT empno_ctx USING set_empno_ctx_pkg;
```
```
Remember that even though user `sysadmin_ctx` has created this application context, the `SYS` schema owns the context.
```
## Step 3: Create a Package to Retrieve Session Data and Set the Application Context
Next, you must create a PL/SQL package that retrieves the session data and then sets the application context.
  - To create the package, use the CREATE OR REPLACE PACKAGE statement.
Example 13-5 shows how to create the package you need to retrieve the session data and set the application context. Before creating the package, ensure that you are still logged on as user `sysadmin_ctx`. (You can copy and paste this text by positioning the cursor at the start of `CREATE OR REPLACE` in the first line.)
Example 13-5 Package to Retrieve Session Data and Set a Database Session Context
```
CREATE OR REPLACE PACKAGE set_empno_ctx_pkg IS PROCEDURE set_empno;
END;
/ CREATE OR REPLACE PACKAGE BODY set_empno_ctx_pkg IS PROCEDURE set_empno IS emp_id HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
BEGIN SELECT EMPLOYEE_ID INTO emp_id FROM HR.EMPLOYEES WHERE email = SYS_CONTEXT('USERENV', 'SESSION_USER');
DBMS_SESSION.SET_CONTEXT('empno_ctx', 'employee_id', emp_id);
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
END;
/
```
This package creates a procedure called `set_empno` that performs the following actions:
````````
- emp_id HR.EMPLOYEES.EMPLOYEE_ID%TYPE declares a variable, emp_id, to store the employee ID for the user who logs on. It uses the same data type as the EMPLOYEE_ID column in HR.EMPLOYEES.
``````````
- SELECT EMPLOYEE_ID INTO emp_id FROM HR.EMPLOYEES performs a SELECT statement to copy the employee ID that is stored in the employee_id column data from the HR.EMPLOYEES table into the emp_id variable.
````````````
- WHERE email = SYS_CONTEXT('USERENV', 'SESSION_USER') uses a WHERE clause to find all employee IDs that match the email account for the session user. The SYS_CONTEXT function uses the predefined USERENV context to retrieve the user session ID, which is the same as the email column data. For example, the user ID and email address for Lisa Ozer are both the same: lozer.
````
``````
  - 'empno_ctx': Calls the application context empno_ctx. Enclose empno_ctx in single quotes.
````````
  - 'employee_id': Creates the attribute value of the empno_ctx application context name-value pair, by naming it employee_id. Enclose employee_id in single quotes.
``````
  - emp_id: Sets the value for the employee_id attribute to the value stored in the emp_id variable.
To summarize, the `set_empno_ctx_pkg.set_empno` procedure says, “Get the session ID of the user and then match it with the employee ID and email address of any user listed in the `HR.EMPLOYEES` table.”
``````````
- EXCEPTION ... WHEN_NO_DATA_FOUND adds a WHEN NO_DATA_FOUND system exception to catch any no data found errors that may result from the SELECT statement. Without this exception, the package and logon trigger will work fine and set the application context as needed, but then any non-system administrator users other than the users listed in the HR.EMPLOYEES table will not be able to log in to the database. Other users should be able to log in to the database, assuming they are valid database users. Once the application context information is set, then you can use this session information as a way to control user access to a particular application.
## Step 4: Create a Logon Trigger for the Package
The logon trigger will execute when the user logs in.
  ````- As user sysadmin_ctx, create a logon trigger for set_empno_ctx_pkg.set_empno package procedure.
```
CREATE TRIGGER set_empno_ctx_trig AFTER LOGON ON DATABASE
 BEGIN
  sysadmin_ctx.set_empno_ctx_pkg.set_empno;
 END;
/
```
## Step 5: Test the Application Context
Now that the components are all in place, you are ready to test the application context.
  - Log on as user lozer.
```
CONNECT lozer -- Or, CONNECT lozer@hrpdb
Enter password: password
```
```
When user `lozer` logs on, the `empno_ctx` application context collects her employee ID. You can check it as follows:
```
```
SELECT SYS_CONTEXT('empno_ctx', 'employee_id') emp_id FROM DUAL;
```
```
The following output should appear:
```
```
EMP_ID
--------------------------------------------------------
168
```
  - Log on as user SCOTT.
```
CONNECT SCOTT -- Or, CONNECT SCOTT@hrpdb
Enter password: password
```
```
User `SCOTT` is not listed as an employee in the `HR.EMPLOYEES` table, so the `empno_ctx` application context cannot collect an employee ID for him.
```
```
SELECT SYS_CONTEXT('empno_ctx', 'employee_id') emp_id FROM DUAL;
```
```
The following output should appear:
```
```
EMP_ID
--------------------------------------------------------
```
From here, the application can use the user session information to determine how much access the user can have in the database. You can use Oracle Virtual Private Database to accomplish this. .
## Step 6: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  ````- Connect as SYS with the SYSDBA administrative privilege.
```
CONNECT SYS AS SYSDBA -- Or, CONNECT SYS@hrpdb AS SYSDBA Enter password: password
```
  ````- Drop the users sysadmin_ctx and lozer:
```
DROP USER sysadmin_ctx CASCADE;
DROP USER lozer;
```
  - Drop the application context.
```
DROP CONTEXT empno_ctx;
```
```
Remember that even though `sysadmin_ctx` created the application context, it is owned by the `SYS` schema.
```
  - If you want, lock and expire SCOTT, unless other users want to use this account:
```
ALTER USER SCOTT PASSWORD EXPIRE ACCOUNT LOCK;
```
## Related Topics
  - Using Oracle Virtual Private Database to Control Data Access
