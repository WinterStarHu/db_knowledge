# Tutorial: Implementing an Oracle Virtual Private Database Policy Group

This tutorial demonstrates how to create an Oracle Virtual Private Database policy group.
- About This Tutorial This tutorial shows how you can use Oracle Virtual Private Database (VPD) to create a policy group.
- Step 1: Create User Accounts and Other Components for This Tutorial First, you must create user accounts and tables for this tutorial, and grant the appropriate privileges.
````
- Step 2: Create the Two Policy Groups Next, you must create a policy group for each of the two nondatabase users, provider_a and provider_b.
- Step 3: Create PL/SQL Functions to Control the Policy Groups A policy group must have a function that defines how the application can control data access for users.
- Step 4: Create the Driving Application Context The application context determines which policy the nondatabase user who is the logging on should use.
- Step 5: Add the PL/SQL Functions to the Policy Groups Now that you have created the necessary functions, you are ready to associate them with their appropriate policy groups.
- Step 6: Test the Policy Groups Now you are ready to test the two policy groups.
- Step 7: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
## About This Tutorial
This tutorial shows how you can use Oracle Virtual Private Database (VPD) to create a policy group.
Oracle Virtual Private Database Policy Groups describes how you can group a set of policies for use in an application. When a nondatabase user logs onto the application, Oracle Database grants the user access based on the policies defined within the appropriate policy group.
For column-level access control, every column or set of hidden columns is controlled by one policy. In this tutorial, you must hide two sets of columns. So, you must create two policies, one for each set of columns that you want to hide. You only want one policy for each user; the driving application context separates the policies for you.
**Note:**   If you are using a multitenant environment, then this tutorial applies to the current PDB only.
## Step 1: Create User Accounts and Other Components for This Tutorial
First, you must create user accounts and tables for this tutorial, and grant the appropriate privileges.
  ````- Log on as user SYS with the SYSDBA administrative privilege.
```
sqlplus sys as sysdba
Enter password: password
```
- In a multitenant environment, connect to the appropriate PDB. For example:
```
CONNECT SYS@hrpdb AS SYSDBA
Enter password: password
```
```
To find the available PDBs, run the `show pdbs` command. To check the current PDB, run the `show con_name` command.
```
  - Create the following local users:
```
CREATE USER apps_user IDENTIFIED BY password CONTAINER = CURRENT;
GRANT CREATE SESSION TO apps_user;
CREATE USER sysadmin_pg  IDENTIFIED BY password CONTAINER = CURRENT;
GRANT CREATE SESSION, CREATE PROCEDURE, CREATE ANY CONTEXT TO sysadmin_pg;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
```
  - Grant the following additional privilege to user sysadmin_pg:
```
GRANT EXECUTE ON DBMS_RLS TO sysadmin_pg;
```
  - Log on as user OE.
```
CONNECT OE -- Or, CONNECT OE@hrpdb
Enter password: password
```
```
If the `OE` account is locked and expired, then reconnect as user `SYS` with the `SYSDBA` administrative privilege and enter the following statement to unlock the account and give it s new password:
```
```
ALTER USER OE ACCOUNT UNLOCK IDENTIFIED BY password;
```
```
Replace *password* with a password that is secure. For greater security, do not reuse the same password that was used in previous releases of Oracle Database.
```
  - Create the product_code_names table:
```
CREATE TABLE product_code_names(
group_a     varchar2(32),
year_a      varchar2(32),
group_b     varchar2(32),
year_b      varchar2(32));
```
  - Insert some values into the product_code_names table:
```
INSERT INTO product_code_names values('Biffo','2008','Beffo','2004');
INSERT INTO product_code_names values('Hortensia','2008','Bunko','2008');
INSERT INTO product_code_names values('Boppo','2006','Hortensia','2003');
COMMIT;
```
  ``````- Grant the apps_user user SELECT privileges on the product_code_names table.
```
GRANT SELECT ON product_code_names TO apps_user;
```
## Step 2: Create the Two Policy Groups
Next, you must create a policy group for each of the two nondatabase users, `provider_a` and `provider_b`.
  - Connect as user sysadmin_pg.
```
CONNECT sysadmin_pg -- Or, CONNECT sysadmin_pg@hrpdb Enter password: password
```
  ````- Create the provider_a_group policy group, to be used by user provider_a:
```
BEGIN
 DBMS_RLS.CREATE_POLICY_GROUP(
 object_schema   => 'oe',
 object_name     => 'product_code_names',
 policy_group    => 'provider_a_group');
END;
/
```
  ````- Create the provider_b_group policy group, to be used by user provider_b:
```
BEGIN DBMS_RLS.CREATE_POLICY_GROUP( object_schema   => 'oe', object_name     => 'product_code_names', policy_group    => 'provider_b_group');
END;
/
```
## Step 3: Create PL/SQL Functions to Control the Policy Groups
A policy group must have a function that defines how the application can control data access for users.
The function that you will create for this policy group applies to users `provider_a` and `provider_b`.
  ````- Create the vpd_function_provider_a function, which restricts the data accessed by user provider_a.
```
CREATE OR REPLACE FUNCTION
```
```
This function checks that the user logging in is really user `provider_a`. If this is true, then only the data in the `product_code_names` table columns `group_a` and `year_a` will be visible to `provider_a`. Data in columns `group_b` and `year_b` will not appear for `provider_a`. This works as follows: Setting `predicate := '1=2'` hides the relevant columns. In [Step 5: Add the PL/SQL Functions to the Policy Groups](#GUID-3A3B0993-327A-4E02-B74D-4B6741AFE691), you specify these columns in the `SEC_RELEVANT_COLS` parameter.
```
  ````- Create the vpd_function_provider_b, function, which restricts the data accessed by user provider_a.
```
CREATE OR REPLACE FUNCTION
```
```
Similar to the `vpd_function_provider_a` function, this function checks that the user logging in is really user `provider_b`. If this is true, then only the data in the columns `group_b` and `year_b` will be visible to `provider_b`, with data in the `group_a` and `year_a` not appearing for `provider_b`. Similar to the `vpd_function_provider_a` function, `predicate := '1=2'` hides the relevant columns specified [Step 5: Add the PL/SQL Functions to the Policy Groups](#GUID-3A3B0993-327A-4E02-B74D-4B6741AFE691) in the `SEC_RELEVANT_COLS` parameter.
```
## Step 4: Create the Driving Application Context
The application context determines which policy the nondatabase user who is the logging on should use.
  - As user sysadmin_pg, create the driving application context as follows:
```
CREATE OR REPLACE CONTEXT provider_ctx USING provider_package;
```
  - Create the PL/SQL provider_package package for the application context.
```
CREATE OR REPLACE PACKAGE provider_package IS PROCEDURE set_provider_context (policy_group varchar2 default NULL);
END;
/ CREATE OR REPLACE PACKAGE BODY provider_package AS PROCEDURE set_provider_context (policy_group varchar2 default NULL) IS BEGIN CASE LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) WHEN 'provider_a' THEN DBMS_SESSION.SET_CONTEXT('provider_ctx','policy_group','PROVIDER_A_GROUP');
WHEN 'provider_b' THEN DBMS_SESSION.SET_CONTEXT('provider_ctx','policy_group','PROVIDER_B_GROUP');
END CASE;
END set_provider_context;
END;
/
```
  ````- Associate the provider_ctx application context with the product_code_names table, and then provide a name.
```
BEGIN
 DBMS_RLS.ADD_POLICY_CONTEXT(
 object_schema  =>'oe',
 object_name    =>'product_code_names',
 namespace      =>'provider_ctx',
 attribute      =>'policy_group');
END;
/
```
  ``````- Grant the apps_user account the EXECUTE privilege for the provider_package package.
```
GRANT EXECUTE ON provider_package TO apps_user;
```
## Step 5: Add the PL/SQL Functions to the Policy Groups
Now that you have created the necessary functions, you are ready to associate them with their appropriate policy groups.
  ````- Add the vpd_function_provider_a function to the provider_a_group policy group.
```
BEGIN
 DBMS_RLS.ADD_GROUPED_POLICY(
 object_schema         => 'oe',
 object_name           => 'product_code_names',
 policy_group          => 'provider_a_group',
 policy_name           => 'filter_provider_a',
 function_schema       => 'sysadmin_pg',
 policy_function       => 'vpd_function_provider_a',
 statement_types       => 'select',
 policy_type           => DBMS_RLS.CONTEXT_SENSITIVE,
 sec_relevant_cols     => 'group_b,year_b',
 sec_relevant_cols_opt => DBMS_RLS.ALL_ROWS,
 namespace             => 'provider_ctx',
 attribute             => 'provider_group');
END;
/
```
```
The `group_b` and `year_b` columns specified in the `sec_relevant_cols` parameter are hidden from user `provider_a`.
```
  ````- Add the vpd_function_provider_b function to the provider_b_group policy group.
```
BEGIN DBMS_RLS.ADD_GROUPED_POLICY( object_schema         => 'oe', object_name           => 'product_code_names', policy_group          => 'provider_b_group', policy_name           => 'filter_provider_b', function_schema       => 'sysadmin_pg', policy_function       => 'vpd_function_provider_b', statement_types       => 'select', policy_type           => DBMS_RLS.CONTEXT_SENSITIVE, sec_relevant_cols     => 'group_a,year_a', sec_relevant_cols_opt => DBMS_RLS.ALL_ROWS, namespace             => 'provider_ctx', attribute             => 'provider_group');
END;
/
```
```
The `group_a` and `year_a` columns specified in the `sec_relevant_cols` parameter are hidden from user `provider_b`.
```
## Step 6: Test the Policy Groups
Now you are ready to test the two policy groups.
  - Connect as user apps_user and then enter the following statements to ensure that the output you will create later on is nicely formatted.
```
CONNECT apps_user -- Or, CONNECT apps_user@hrpdb Enter password: password col group_a format a16 col group_b format a16;
col year_a format a16;
col year_b format a16;
```
  - Set the session identifier to provider_a.
```
EXEC DBMS_SESSION.SET_IDENTIFIER('provider_a');
```
```
Here, the application sets the identifier. Setting the identifier to `provider_a` sets the `apps_user` user to a user who should only see the products available to products in the `provider_a_group` policy group.
```
  - Run the provider_package to set the policy group based on the context.
```
EXEC sysadmin_pg.provider_package.set_provider_context;
```
```
At this stage, you can check the application context was set, as follows:
```
```
SELECT SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') AS END_USER FROM DUAL;
```
```
The following output should appear:
```
```
END_USER
-----------------
provider_a
```
  - Enter the following SELECT statement:
```
SELECT * FROM oe.product_code_names;
```
```
The following output should appear:
```
```
GROUP_A          YEAR_A           GROUP_B          YEAR_B
---------------- ---------------- ---------------- ----------------
Biffo            2008 Hortensia        2008 Boppo            2006
```
  - Set the client identifier to provider_b and then enter the following statements:
```
EXEC DBMS_SESSION.SET_IDENTIFIER('provider_b');
EXEC sysadmin_pg.provider_package.set_provider_context;
SELECT * FROM oe.product_code_names;
```
```
The following output should appear:
```
```
GROUP_A          YEAR_A           GROUP_B          YEAR_B
---------------- ---------------- ---------------- ----------------
Beffo            2004 Bunko            2008 Hortensia        2003
```
## Step 7: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  - Connect as user OE.
```
CONNECT OE -- Or, CONNECT OE@hrpdb Enter password: password
```
  - Drop the product_code_names table.
```
DROP TABLE product_code_names;
```
  ````- Connect as user SYS with the SYSDBA administrative privilege.
```
CONNECT SYS AS SYSDBA -- Or, CONNECT SYS@hrpdb AS SYSDBA
Enter password: password
```
  - Drop the application context and users for this tutorial.
```
DROP CONTEXT provider_ctx;
DROP USER sysadmin_pg cascade;
DROP USER apps_user;
```
## Related Topics
  - Function to Generate the Dynamic WHERE Clause
