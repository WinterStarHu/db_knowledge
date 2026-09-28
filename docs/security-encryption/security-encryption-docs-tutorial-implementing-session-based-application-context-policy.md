# Tutorial: Implementing a Session-Based Application Context Policy

This tutorial demonstrates how to create an Oracle Virtual Private Database policy that uses a database session-based application context.
- About This Tutorial This tutorial shows how to use a database session-based application context to implement a policy in which customers see only their own orders.
- Step 1: Create User Accounts and Sample Tables First, create user accounts and the sample tables.
- Step 2: Create a Database Session-Based Application Context Next, you are ready to create the database session-based application context.
- Step 3: Create a PL/SQL Package to Set the Application Context After you create the application context, you are ready to create a package to set the context.
- Step 4: Create a Logon Trigger to Run the Application Context PL/SQL Package The logon trigger runs the PL/SQL package procedure so that the next time a user logs on, the application context is set.
- Step 5: Test the Logon Trigger The logon trigger sets the application context for the user when the trigger runs the sysadmin_vpd.orders_ctx_pkg.set_custnum procedure.
- Step 6: Create a PL/SQL Policy Function to Limit User Access to Their Orders The next step is to create a PL/SQL function to control the display of the user’s query.
- Step 7: Create the New Security Policy Finally, you are ready to create the VPD security policy.
- Step 8: Test the New Policy Now that you have created all the components, you are ready to test the policy.
- Step 9: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
## About This Tutorial
This tutorial shows how to use a database session-based application context to implement a policy in which customers see only their own orders.
If you are using a multitenant environment, then this tutorial applies to the current PDB only.
In this tutorial, you create the following layers of security:
- When a user logs on, a database session-based application context checks whether the user is a customer. If a user is not a customer, the user still can log on, but this user cannot access the orders entry table you will create for this example.
- If the user is a customer, he or she can log on. After the customer has logged on, an Oracle Virtual Private Database policy restricts this user to see only his or her orders.
- As a further restriction, the Oracle Virtual Private Database policy prevents users from adding, modifying, or removing orders.
## Step 1: Create User Accounts and Sample Tables
First, create user accounts and the sample tables.
  - Start SQL*Plus and log on as a user who has administrative privileges.
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
To find the available PDBs, query the `DBA_PDBS` data dictionary view. To check the current PDB, run the `show con_name` command.
```
- Create the following administrative user, who will administer the Oracle Virtual Private Database policy. The following SQL statements create this user and then grant the user the necessary privileges for completing this tutorial.
```
CREATE USER sysadmin_vpd IDENTIFIED BY password CONTAINER = CURRENT;
GRANT CREATE SESSION, CREATE ANY CONTEXT, CREATE PROCEDURE, CREATE TRIGGER, ADMINISTER DATABASE TRIGGER TO sysadmin_vpd;
GRANT EXECUTE ON DBMS_SESSION TO sysadmin_vpd;
GRANT EXECUTE ON DBMS_RLS TO sysadmin_vpd;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
```
  - Create the following local users:
```
CREATE USER tbrooke IDENTIFIED BY password CONTAINER = CURRENT;
CREATE USER owoods IDENTIFIED BY password CONTAINER = CURRENT;
GRANT CREATE SESSION TO tbrooke, owoods;
```
```
Replace *password* with a password that is secure.
```
  - Check the account status of the sample user SCOTT, who you will use for this tutorial:
```
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS WHERE USERNAME = 'SCOTT';
```
```
The status should be `OPEN`. If the `DBA_USERS` view lists user `SCOTT` as locked and expired, then enter the following statement to unlock the `SCOTT` account and create a new password for him:
```
```
ALTER USER SCOTT ACCOUNT UNLOCK IDENTIFIED BY password;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure. For greater security, do not reuse the same password that was used in previous releases of Oracle Database.
```
  - Connect as user SCOTT.
```
CONNECT SCOTT -- Or, CONNECT SCOTT@hrpdb
Enter password: password
```
  - Create and populate the customers table.
```
CREATE TABLE customers (
 cust_no    NUMBER(4),
 cust_email VARCHAR2(20),
 cust_name  VARCHAR2(20));
INSERT INTO customers VALUES (1234, 'TBROOKE', 'Thadeus Brooke');
INSERT INTO customers VALUES (5678, 'OWOODS', 'Oberon Woods');
```
```
When you enter the user email IDs, enter them in upper-case letters. Later on, when you create the application context PL/SQL package, the `SESSION_USER` parameter of the `SYS_CONTEXT` function expects the user names to be in upper case. Otherwise, you will be unable to set the application context for the user.
```
  ``````- User sysadmin_vpd will need SELECT privileges for the customers table, so as user SCOTT, grant him this privilege.
```
GRANT READ ON customers TO sysadmin_vpd;
```
  - Create and populate the orders_tab table.
```
CREATE TABLE orders_tab ( cust_no  NUMBER(4), order_no NUMBER(4));
INSERT INTO orders_tab VALUES (1234, 9876);
INSERT INTO orders_tab VALUES (5678, 5432);
INSERT INTO orders_tab VALUES (5678, 4592);
```
  ````````- Users tbrooke and owoods need to query the orders_tab table, so grant them the READ object privilege.
```
GRANT READ ON orders_tab TO tbrooke, owoods;
```
At this stage, the two sample customers, `tbrooke` and `owoods`, have a record of purchases in the `orders_tab` order entry table, and if they tried right now, they can see all the orders in this table.
## Step 2: Create a Database Session-Based Application Context
Next, you are ready to create the database session-based application context.
  - Connect as user sysadmin_vpd.
```
CONNECT sysadmin_vpd -- Or, CONNECT sysadmin_vpd@hrpdb
Enter password: password
```
  - Enter the following statement:
```
CREATE OR REPLACE CONTEXT orders_ctx USING orders_ctx_pkg;
```
```
This statement creates the `orders_ctx` application context. Remember that even though user `sysadmin_vpd` has created this context and it is associated with the `sysadmin_vpd` schema, the `SYS` schema owns the application context.
```
## Step 3: Create a PL/SQL Package to Set the Application Context
After you create the application context, you are ready to create a package to set the context.
``````
```
CREATE OR REPLACE PACKAGE orders_ctx_pkg IS PROCEDURE set_custnum;
END;
/ CREATE OR REPLACE PACKAGE BODY orders_ctx_pkg IS PROCEDURE set_custnum AS custnum NUMBER;
BEGIN SELECT cust_no INTO custnum FROM SCOTT.CUSTOMERS WHERE cust_email = SYS_CONTEXT('USERENV', 'SESSION_USER');
DBMS_SESSION.SET_CONTEXT('orders_ctx', 'cust_no', custnum);
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END set_custnum;
END;
/
```
````
  - custnum NUMBER creates the custnum variable, which will hold the customer ID.
``````````
  - SELECT cust_no INTO custnum performs a SELECT statement to copy the customer ID that is stored in the cust_no column data from the scott.customers table into the custnum variable.
````
  - WHERE cust_email = SYS_CONTEXT('USERENV', 'SESSION_USER') uses a WHERE clause to find all the customer IDs that match the user name of the user who is logging on.
````````
  - DBMS_SESSION.SET_CONTEXT('orders_ctx', 'cust_no', custnum) sets the orders_ctx application context values by creating the cust_no attribute and then setting it to the value stored in the custnum variable.
``````````
  - EXCEPTION ... WHEN adds a WHEN NO_DATA_FOUND system exception to catch any no data found errors that may result from the SELECT statement in the SELECT cust_no INTO custnum ... statement.
To summarize, the `sysadmin_vpd.set_custnum` procedure identifies whether or not the session user is a registered customer by attempting to select the user’s customer ID into the `custnum` variable. If the user is a registered customer, then Oracle Database sets an application context value for this user. The policy function uses the context value to control the access a user has to data in the `orders_tab` table.
## Step 4: Create a Logon Trigger to Run the Application Context PL/SQL Package
The logon trigger runs the PL/SQL package procedure so that the next time a user logs on, the application context is set.
  - As user sysadmin_vpd, create the following logon trigger:
```
CREATE TRIGGER set_custno_ctx_trig AFTER LOGON ON DATABASE
 BEGIN
  sysadmin_vpd.orders_ctx_pkg.set_custnum;
 END;
/
```
## Step 5: Test the Logon Trigger
The logon trigger sets the application context for the user when the trigger runs the `sysadmin_vpd.orders_ctx_pkg.set_custnum` procedure.
  - Connect as user tbrooke.
```
CONNECT tbrooke -- For a CDB, connect to the PDB, e.g., @hrpdb
Enter password: password
```
  - Execute the following query:
```
SELECT SYS_CONTEXT('orders_ctx', 'cust_no') custnum FROM DUAL;
```
```
The following output should appear:
```
```
EMP_ID
-------------------------------------------------------------------
1234
```
## Step 6: Create a PL/SQL Policy Function to Limit User Access to Their Orders
The next step is to create a PL/SQL function to control the display of the user’s query.
When the user who has logged in performs a `SELECT * FROM scott.orders_tab` query, the function should cause the output to display only the orders of that user.
  - Connect as user sysadmin_vpd.
```
CONNECT sysadmin_vpd -- Or, CONNECT sysadmin_vpd@hrpdb
Enter password: password
```
  - Create the following function:
```
CREATE OR REPLACE FUNCTION get_user_orders(
  schema_p   IN VARCHAR2,
  table_p    IN VARCHAR2)
 RETURN VARCHAR2
 AS
  orders_pred VARCHAR2 (400);
 BEGIN
  orders_pred := 'cust_no = SYS_CONTEXT(''orders_ctx'', ''cust_no'')';
 RETURN orders_pred;
END;
/
```
This function creates and returns a `WHERE` predicate that translates to “where the orders displayed belong to the user who has logged in.” It then appends this `WHERE` predicate to any queries this user may run against the `scott.orders_tab` table. Next, you are ready to create an Oracle Virtual Private Database policy that applies this function to the `orders_tab` table.
## Step 7: Create the New Security Policy
Finally, you are ready to create the VPD security policy.
  ````- As user sysadmin_vpd, use the DBMS_RLS.ADD_POLICY procedure to create the policy as follows:
```
BEGIN DBMS_RLS.ADD_POLICY ( object_schema    => 'scott', object_name      => 'orders_tab', policy_name      => 'orders_policy', function_schema  => 'sysadmin_vpd', policy_function  => 'get_user_orders', statement_types  => 'select', policy_type      => DBMS_RLS.CONTEXT_SENSITIVE, namespace        => 'orders_ctx', attribute        => 'cust_no');
END;
/
```
This statement creates a policy named `orders_policy` and applies it to the `orders_tab` table, which customers will query for their orders, in the `SCOTT` schema. The `get_user_orders` function implements the policy, which is stored in the `sysadmin_vpd` schema. The policy further restricts users to issuing `SELECT` statements only. The `namespace` and `attribute` parameters specify the application context that you created earlier.
## Step 8: Test the New Policy
Now that you have created all the components, you are ready to test the policy.
  - Connect as user tbrooke.
```
CONNECT tbrooke -- Or, CONNECT tbrooke@hrpdb Enter password: password
```
```
User `tbrooke` can log on because he has passed the requirements you defined in the application context.
```
  - As user tbrooke, access your purchases.
```
SELECT * FROM scott.orders_tab;
```
```
The following output should appear:
```
```
CUST_NO    ORDER_NO
----------  ----------
1234        9876
```
```
User `tbrooke` has passed the second test. He can access his own orders in the `scott.orders_tab` table.
```
  - Connect as user owoods, and then access your purchases.
```
CONNECT owoods -- For a CDB, connect to the PDB, e.g., @hrpdb Enter password: password SELECT * FROM scott.orders_tab
```
```
The following output should appear:
```
```
CUST_NO    ORDER_NO
----------  ----------
5678        5432 5678        4592
```
```
As with user `tbrooke`, user `owoods` can log on and see a listing of his own orders.
```
Note the following:
- You can create several predicates based on the position of a user. For example, a sales representative would be able to see records only for his customers, and an order entry clerk would be able to see any customer order. You could expand the custnum_sec function to return different predicates based on the user position context value.
- The use of an application context in a fine-grained access control package effectively gives you a bind variable in a parsed statement. For example:
```
SELECT * FROM scott.orders_tab WHERE cust_no = SYS_CONTEXT('order_entry', 'cust_num');
```
This is fully parsed and optimized, but the evaluation of the `cust_num` attribute value of the user for the `order_entry` context takes place at run-time. This means that you get the benefit of an optimized statement that executes differently for each user who issues the statement.
**Note:**   You can improve the performance of the function in this tutorial by indexing `cust_no`.
  ******- You can set context attributes based on data from a database table or tables, or from a directory server using Lightweight Directory Access Protocol (LDAP). Note: Oracle Database PL/SQL Language Reference for more information about triggers
Compare this tutorial, which uses an application context within the dynamically generated predicate, with About Oracle Virtual Private Database Policies, which uses a subquery in the predicate.
## Step 9: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  - Connect as user SCOTT.
```
CONNECT SCOTT -- Or, CONNECT SCOTT@hrpdb Enter password: password
```
  ````- Remove the orders_tab and customers tables.
```
DROP TABLE orders_tab;
DROP TABLE customers;
```
  ````- Connect as user SYS, connecting with AS SYSDBA.
```
CONNECT SYS AS SYSDBA -- Or, CONNECT SYS@hrpdb AS SYSDBA Enter password: password
```
  - Run the following statements to drop the components for this tutorial:
```
DROP CONTEXT orders_ctx;
DROP USER sysadmin_vpd CASCADE;
DROP USER tbrooke;
DROP USER owoods;
```
## Related Topics
  - Logon Triggers to Run a Database Session Application Context Package
