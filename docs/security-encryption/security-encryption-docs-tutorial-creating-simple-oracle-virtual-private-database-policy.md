# Tutorial: Creating a Simple Oracle Virtual Private Database Policy

This tutorial shows how to create a simple Oracle Virtual Private Database policy using the `OE` user account.
- About This Tutorial This tutorial shows how to create a VPD policy that limits access to orders created by Sales Representative 159 in the OE.ORDERS table.
- Step 1: Ensure That the OE User Account Is Active First, you must ensure that OE user account is active.
- Step 2: Create a Policy Function Next, you are ready to create a policy function.
- Step 3: Create the Oracle Virtual Private Database Policy After you create the policy function, you are ready to associate it with a VPD policy.
- Step 4: Test the Policy After you create the Oracle Virtual Private Database policy, it goes into effect immediately.
- Step 5: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
## About This Tutorial
This tutorial shows how to create a VPD policy that limits access to orders created by Sales Representative 159 in the `OE.ORDERS` table.
In essence, the policy translates the following statement:
```
SELECT * FROM OE.ORDERS;
```
To the following statement:
```
SELECT * FROM OE.ORDERS WHERE SALES_REP_ID = 159;
```
**Note:**   If you are using a multitenant environment, then this tutorial applies to the current PDB only.
## Step 1: Ensure That the OE User Account Is Active
First, you must ensure that `OE` user account is active.
  ````- Log on to SQL*Plus as user SYS with the SYSDBA administrative privilege.
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
  ````- Query the DBA_USERS data dictionary view to find the account status of OE.
```
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS WHERE USERNAME = 'OE';
```
```
The status should be `OPEN`. If the `DBA_USERS` view lists user `OE` as locked and expired, then enter the following statement to unlock the `OE` account and create a new password:
```
```
ALTER USER OE ACCOUNT UNLOCK IDENTIFIED BY password;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure. For greater security, do not reuse the same password that was used in previous releases of Oracle Database.
```
## Step 2: Create a Policy Function
Next, you are ready to create a policy function.
As user `SYS`, create the following function, which will append the `WHERE SALES_REP_ID = 159` clause to any `SELECT` statement on the `OE.ORDERS` table. (You can copy and paste this text by positioning the cursor at the start of `CREATE OR REPLACE` in the first line.)
```
CREATE OR REPLACE FUNCTION auth_orders(
  schema_var IN VARCHAR2,
  table_var  IN VARCHAR2
 )
 RETURN VARCHAR2
 IS
  return_val VARCHAR2 (400);
 BEGIN
  return_val := 'SALES_REP_ID = 159';
  RETURN return_val;
 END auth_orders;
/
```
In this example:
``````````
- schema_var and table_var create input parameters to specify to store the schema name, OE, and table name, ORDERS. First, define the parameter for the schema, and then define the parameter for the object, in this case, a table. Always create them in this order. The Virtual Private Database policy you create will need these parameters to specify the OE.ORDERS table.
``````
- RETURN VARCHAR2 returns the string that will be used for the WHERE predicate clause. Remember that return value is always a VARCHAR2 data type.
````
- IS ... RETURN return_val encompasses the creation of the WHERE SALES_REP_ID = 159 predicate.
## Step 3: Create the Oracle Virtual Private Database Policy
After you create the policy function, you are ready to associate it with a VPD policy.
````
```
BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema    => 'oe',
    object_name      => 'orders',
    policy_name      => 'orders_policy',
    function_schema  => 'sys',
    policy_function  => 'auth_orders',
    statement_types  => 'select'
   );
 END;
/
```
````
  - object_schema => 'oe' specifies the schema that you want to protect, that is, OE.
````
  - object_name => 'orders' specifies the object within the schema to protect, that is, the ORDERS table.
````
  - policy_name => 'orders_policy' names this policy orders_policy.
````````
  - function_schema => 'sys' specifies the schema in which the auth_orders function was created. In this example, auth_orders was created in the SYS schema. But typically, it should be created in the schema of a security administrator.
````
  - policy_function => 'auth_orders' specifies a function to enforce the policy. Here, you specify the auth_orders function that you created in Step 2: Create a Policy Function.
````
  - statement_types => 'select' specifies the operations to which the policy applies. In this example, the policy applies to all SELECT statements that the user may perform.
## Step 4: Test the Policy
After you create the Oracle Virtual Private Database policy, it goes into effect immediately.
The next time a user, including the owner of the schema, performs a `SELECT` on `OE.ORDERS`, only the orders by Sales Representative 159 will be accessed.
  - Connect as user OE.
```
CONNECT oe -- Or, CONNECT OE@hrpdb
Enter password: password
```
  - Enter the following SELECT statement:
```
SELECT COUNT(*) FROM ORDERS;
```
```
The following output should appear:
```
```
 COUNT(*)
---------
        7
```
```
The policy is in effect for user `OE`: As you can see, only 7 of the 105 rows in the orders table are returned.
But users with administrative privileges still have access to all the rows in the table.
```
  ````- Connect as user SYS with the SYSDBA administrative privilege.
```
CONNECT SYS AS SYSDBA -- Or, CONNECT SYS@hrpdb AS SYSDBA Enter password: password
```
  - Enter the following SELECT statement:
```
SELECT COUNT(*) FROM OE.ORDERS;
```
```
The following output should appear:
```
```
COUNT(*)
---------
105
```
## Step 5: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  - As user SYS, remove the function and policy as follows:
```
DROP FUNCTION auth_orders;
EXEC DBMS_RLS.DROP_POLICY('OE','ORDERS','ORDERS_POLICY');
```
  - If you need to lock and expire the OE account, then enter the following statement:
```
ALTER USER OE ACCOUNT LOCK PASSWORD EXPIRE;
```
