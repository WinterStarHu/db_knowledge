# Auditing Object Actions

You can use the `CREATE AUDIT POLICY` statement to audit object actions.
````
- About Auditing Object Actions You can audit actions performed on specific objects, such as UPDATE statements on the HR.EMPLOYEES table.
- Object Actions That Can Be Audited Auditing object actions can be broad or focused (for example, auditing all user actions or only a select list of user actions).
````
- Configuring an Object Action Unified Audit Policy The ACTIONS clause in the CREATE AUDIT POLICY statement creates a policy that captures object actions.
````
- Example: Auditing Actions on SYS Objects The CREATE AUDIT POLICY statement can audit actions on SYS objects.
- Example: Auditing Multiple Actions on One Object The CREATE AUDIT POLICY statement can audit multiple actions on one object.
``````
- Example: Auditing GRANT and REVOKE Operations on an Object The CREATE AUDIT POLICY statement can audit GRANT and REVOKE operations on objects, such as tables.
- Example: Auditing Both Actions and Privileges on an Object The CREATE AUDIT POLICY statement can audit both actions and privileges on an object, using a single policy.
- Example: Auditing All Actions on a Table The CREATE AUDIT POLICY statement can audit all actions on a table.
- Example: Auditing All Actions in the Database The CREATE AUDIT POLICY statement can audit all actions in the database.
- How Object Action Unified Audit Policies Appear in the Audit Trail The UNIFIED_AUDIT_TRAIL data dictionary view lists object action audit events.
- Auditing Functions, Procedures, Packages, and Triggers You can audit functions, procedures, PL/SQL packages, and triggers.
- Auditing of Oracle Virtual Private Database Predicates The unified audit trail automatically captures the predicates that are used in Oracle Virtual Private Database (VPD) policies.
- Audit Policies for Oracle Virtual Private Database Policy Functions Auditing can affect dynamic VPD policies, static VPD policies, and context-sensitive VPD policies.
- Unified Auditing with Editioned Objects When an editioned object has a unified audit policy, it applies in all editions in which the object is visible.
## About Auditing Object Actions
You can audit actions performed on specific objects, such as `UPDATE` statements on the `HR.EMPLOYEES` table.
When a unified audit policy configured with `ALL ACTIONS` audits a `MERGE` statement, the unified audit trail records the underlying database actions performed by the `MERGE` operation.
Depending on the execution path of the statement, a `MERGE` operation can internally perform `INSERT` operations, `UPDATE` operations, or both. Unified auditing records the corresponding underlying actions that are executed during statement processing.
As a result, the audit trail for a `MERGE` statement can contain audit records that reflect the internal DML actions associated with the statement execution, rather than a single generic `MERGE` action entry.
The audit can include both DDL and DML statements that were used on the object. A single unified audit policy can contain both privilege and action audit options, as well as audit options set for multiple objects.
For tables that contain sensitive information, Oracle recommends that you include the `ACTIONS ALL` clause in the unified audit policy so that the audit record will capture indirect `SELECT` operations.
## Object Actions That Can Be Audited
Auditing object actions can be broad or focused (for example, auditing all user actions or only a select list of user actions).
The following table lists the object-level standard database action options. Audit policies for the `SELECT` SQL statement will capture `READ` actions as well as `SELECT` actions.

| Object | SQL Action That Can Be Audited |
|---|---|
| Table | ALTER, AUDIT, COMMENT, DELETE, FLASHBACK, GRANT, INDEX, INSERT, LOCK, RENAME, SELECT, UPDATE |
| View | AUDIT, COMMENT, DELETE, FLASHBACK, GRANT, INSERT, LOCK, RENAME, SELECT, UPDATE |
| Sequence | ALTER, AUDIT, GRANT, SELECT |
| Procedure (including triggers) | AUDIT, EXECUTE, GRANT |
| Function | AUDIT, EXECUTE, GRANT |
| Package | AUDIT, EXECUTE, GRANT |
| Materialized views | ALTER, AUDIT, COMMENT, DELETE, INDEX, INSERT, LOCK, SELECT, UPDATE |
| Mining Model | AUDIT, COMMENT, GRANT, RENAME, SELECT |
| Directory | AUDIT, GRANT, READ |
| Library | EXECUTE, GRANT |
| Object type | ALTER, AUDIT, GRANT |
| Java schema objects (source, class, resource) | AUDIT, EXECUTE, GRANT |

## Configuring an Object Action Unified Audit Policy
The `ACTIONS` clause in the `CREATE AUDIT POLICY` statement creates a policy that captures object actions.
  - Use the following syntax to create a unified audit policy that audits object actions:
```
CREATE AUDIT POLICY policy_name
 ACTIONS action1 [, action2 ON object1] [, action3 ON object2];
```
For example:
```
CREATE AUDIT POLICY my_simple_obj_policy
 ACTIONS SELECT ON OE.ORDERS, UPDATE ON HR.EMPLOYEES;
```
Note that you can audit multiple actions on multiple objects, as shown in this example.
You can build complex object action unified audit policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing Actions on SYS Objects
The `CREATE AUDIT POLICY` statement can audit actions on `SYS` objects.
Example 27-6 shows how to create an audit policy that audits `SELECT` statements on the `SYS.USER$` system table. The audit policy applies to all users, including `SYS` and `SYSTEM`.
Example 27-6 Auditing Actions on SYS Objects
```
CREATE AUDIT POLICY select_user_dictionary_table_pol ACTIONS SELECT ON SYS.USER$;
AUDIT POLICY select_user_dictionary_table_pol;
```
## Example: Auditing Multiple Actions on One Object
The `CREATE AUDIT POLICY` statement can audit multiple actions on one object.
Example 27-7 shows how to audit multiple SQL statements performed by users `jrandolph` and `phawkins` on the `app_lib` library.
Example 27-7 Auditing Multiple Actions on One Object
```
CREATE AUDIT POLICY actions_on_hr_emp_pol1
 ACTIONS EXECUTE, GRANT
 ON app_lib;
AUDIT POLICY actions_on_hr_emp_pol1 BY jrandolph, phawkins;
```
## Example: Auditing GRANT and REVOKE Operations on an Object
The `CREATE AUDIT POLICY` statement can audit `GRANT` and `REVOKE` operations on objects, such as tables.
Enabling auditing on `GRANT` operations on an object automatically enables the audit of `REVOKE` operations on the object as well.
Example 27-8 Auditing GRANT and REVOKE Operations
```
CREATE AUDIT POLICY grant_revoke_pol
ACTIONS GRANT ON HR.EMPLOYEES;
AUDIT POLICY grant_revoke_pol;
```
To select from the `UNIFIED_AUDIT_TRAIL` data dictionary view for this type of policy, you can perform a query similar to the following. The grantee name (to whom the privilege is granted) is recorded in the `TARGET_USER` column.
```
SELECT DBUSERNAME, OBJECT_PRIVILEGES, ACTION_NAME, OBJECT_SCHEMA, OBJECT_NAME, TARGET_USER
FROM UNIFIED_AUDIT_TRAIL
WHERE ACTION_NAME IN ('GRANT', 'REVOKE');
```
## Example: Auditing Both Actions and Privileges on an Object
The `CREATE AUDIT POLICY` statement can audit both actions and privileges on an object, using a single policy.
Example 27-9 shows a variation of Example 27-7, in which all `EXECUTE` and `GRANT` statements on the `app_lib` library using the `CREATE LIBRARY` privilege are audited.
Example 27-9 Auditing Both Actions and Privileges on an Object
```
CREATE AUDIT POLICY actions_on_hr_emp_pol2
 PRIVILEGES CREATE LIBRARY
 ACTIONS EXECUTE, GRANT
 ON app_lib;
AUDIT POLICY actions_on_hr_emp_pol2 BY jrandolph, phawkins;
```
You can audit directory objects. For example, suppose you create a directory object that contains a preprocessor program that the `ORACLE_LOADER` access driver will use. You can audit anyone who runs this program within this directory object.
## Example: Auditing All Actions on a Table
The `CREATE AUDIT POLICY` statement can audit all actions on a table.
You can use the `ALL` keyword to audit all actions. Oracle recommends that you audit all actions only on sensitive objects. `ALL` is useful in that it captures indirect `SELECT` operations. Example 27-10 shows how to audit all actions on the `HR.EMPLOYEES` table, except actions by user `pmulligan`.
Example 27-10 Auditing All Actions on a Table
```
CREATE AUDIT POLICY all_actions_on_hr_emp_pol
 ACTIONS ALL ON HR.EMPLOYEES;
AUDIT POLICY all_actions_on_hr_emp_pol EXCEPT pmulligan;
```
## Example: Auditing All Actions in the Database
The `CREATE AUDIT POLICY` statement can audit all actions in the database.
To prevent the scenario of a large number of audit records being generated and quickly filling up the audit trail, even for all the recursive actions for this audit policy configuration, include the `ONLY TOPLEVEL` clause in the `CREATE AUDIT POLICY` statement. As an alternative to `ONLY TOPLEVEL`, you can create the `ACTIONS ALL` policy using a condition to so that only a subset of records are captured.
**Note:**  Use `ACTIONS ALL` auditing with caution. Do not enable it for users who must perform online transaction processing (OLTP) workloads. This will avoid generating a large number of audit records.
Example 27-11 shows how to audit all actions in the entire database.
Example 27-11 Auditing All Actions in the Database
```
CREATE AUDIT POLICY all_actions_pol ACTIONS ALL ONLY TOPLEVEL;
AUDIT POLICY all_actions_pol;
```
## How Object Action Unified Audit Policies Appear in the Audit Trail
The `UNIFIED_AUDIT_TRAIL` data dictionary view lists object action audit events.
For example:
```
SELECT ACTION_NAME, OBJECT_SCHEMA, OBJECT_NAME FROM UNIFIED_AUDIT_TRAIL
WHERE DBUSERNAME = 'SYS';
ACTION_NAME OBJECT_SCHEMA OBJECT_NAME
----------- ------------- ------------
SELECT      HR            EMPLOYEES
```
## Auditing Functions, Procedures, Packages, and Triggers
You can audit functions, procedures, PL/SQL packages, and triggers.
The areas that you can audit are as follows:
- You can individually audit standalone functions, standalone procedures, and PL/SQL packages.
- If you audit a PL/SQL package, Oracle Database audits all functions and procedures within the package.
- If you enable auditing for all executions, Oracle Database audits all triggers in the database, as well as all the functions and procedures within PL/SQL packages.
- You cannot audit individual functions or procedures within a PL/SQL package.
``````
- When you audit the EXECUTE operation on a PL/SQL stored procedure or stored function, the database considers only its ability to find the procedure or function and authorize its execution when determining the success or failure of the operation for the purposes of auditing. Therefore, if you specify the WHENEVER NOT SUCCESSFUL clause, then only invalid object errors, non-existent object errors, and authorization failures are audited; errors encountered during the execution of the procedure or function are not audited. If you specify the WHENEVER SUCCESSFUL clause, then all executions that are not blocked by invalid object errors, non-existent object errors, or authorization failures are audited, regardless of whether errors are encountered during execution.
## Auditing of Oracle Virtual Private Database Predicates
The unified audit trail automatically captures the predicates that are used in Oracle Virtual Private Database (VPD) policies.
You do not need to create a unified audit policy to capture the VPD predicate audit information.
This type of audit enables you to identify the predicate expression that was run as part of a DML operation and thereby help you to identify other actions that may have occurred as part of the DML operation. For example, if a malicious attack on your database is performed using a VPD predicate, then you can track the attack by using the unified audit trail. In addition to predicates from user-created VPD policies, the internal predicates from Oracle Label Security and Oracle Real Application Security policies are captured as well. For example, Oracle Label Security internally creates a VPD policy while applying an OLS policy to a table. Oracle Real Application Security generates a VPD policy while enabling an Oracle RAS policy.
The unified audit trail writes this predicate information to the `RLS_INFO` column of the `UNIFIED_AUDIT_TRAIL` data dictionary view. If you have fine-grained audit policies, then the `RLS_INFO` column of these views captures VPD predicate information as well.
The audit trail can capture the predicates and their corresponding policy names if multiple VPD policies are enforced on the object. The audit trail captures the policy schema and policy name to enable you to differentiate predicates that are generated from different policies. By default, this information is concatenated in the `RLS_INFO` column, but Oracle Database provides a function in the `DBMS_AUDIT_UTIL` PL/SQL package that enables you to reformat the results in an easy-to-read format.
The following example shows how you can audit the predicates of a VPD policy:
  - Create the following VPD policy function:
```
CREATE OR REPLACE FUNCTION auth_orders( schema_var IN VARCHAR2, table_var  IN VARCHAR2 ) RETURN VARCHAR2 IS return_val VARCHAR2 (400);
BEGIN return_val := 'SALES_REP_ID = 159';
RETURN return_val;
END auth_orders;
/
```
  - Create the following VPD policy:
```
BEGIN DBMS_RLS.ADD_POLICY ( object_schema    => 'oe', object_name      => 'orders', policy_name      => 'orders_policy', function_schema  => 'sec_admin', policy_function  => 'auth_orders', statement_types  => 'select, insert, update, delete' );
END;
/
```
  - Create and enable the following the unified audit policy:
```
CREATE AUDIT POLICY oe_pol ACTIONS SELECT ON OE.ORDERS;
AUDIT POLICY oe_pol;
```
  ````- Connect as user OE and query the OE.ORDERS table.
```
CONNECT OE
Enter password: password
SELECT COUNT(*) FROM ORDERS;
```
  ````- Connect as a user who has been granted the AUDIT_ADMIN role, and then query the UNIFIED_AUDIT_TRAIL data dictionary view.
```
CONNECT sec_admin Enter password: password SELECT RLS_INFO FROM UNIFIED_AUDIT_TRAIL;
```
```
Output similar to the following should appear:
```
```
((POLICY_TYPE=[3]'VPD'),(POLICY_SCHEMA=[9]'SEC_ADMIN'),(POLICY_NAME=[13]'ORDERS_POLICY'),(PREDICATE=[16]'SALES_REP_ID=159'));
```
- To extract these details and add them to their own columns, run the appropriate function from the DBMS_AUDIT_UTIL PL/SQL package. For unified auditing, you must run the DBMS_AUDIT_UTIL.DECODE_RLS_INFO_ATRAIL_UNI function. For example:
```
SELECT DBUSERNAME, ACTION_NAME, OBJECT_NAME, SQL_TEXT, RLS_PREDICATE, RLS_POLICY_TYPE, RLS_POLICY_OWNER, RLS_POLICY_NAME FROM TABLE (DBMS_AUDIT_UTIL.DECODE_RLS_INFO_ATRAIL_UNI (CURSOR (SELECT * FROM UNIFIED_AUDIT_TRAIL)));
```
```
The reformatted audit trail output appears similar to the following:
```
```
DBUSERNAME ACTION_NAME OBJECT_NAME SQL_TEXT
---------- ----------- ----------- ---------------------------
RLS_PREDICATE       RLS_POLICY_TYPE RLS_POLICY_OWNER RLS_POLICY_NAME
------------------ ---------------  ---------------- ---------------
OE         SELECT      ORDERS      SELECT COUNT(*) FROM ORDERS SALES_REP_ID = 159  VPD             SEC_ADMIN        ORDERS_POLICY
```
## Audit Policies for Oracle Virtual Private Database Policy Functions
Auditing can affect dynamic VPD policies, static VPD policies, and context-sensitive VPD policies.
****
- Dynamic policies: Oracle Database evaluates the policy function twice, once during SQL statement parsing and again during execution. As a result, two audit records are generated for each evaluation.
****
- Static policies: Oracle Database evaluates the policy function once and then caches it in the SGA. As a result, only one audit record is generated.
****
- Context-sensitive policies: Oracle Database executes the policy function once, during statement parsing. As a result, only one audit record is generated.
## Unified Auditing with Editioned Objects
When an editioned object has a unified audit policy, it applies in all editions in which the object is visible.
When an editioned object is actualized, any unified audit policies that are attached to it are newly attached to the new actual occurrence. When you newly apply a unified audit policy to an inherited editioned object, this action will actualize it.
You can find the editions in which audited objects appear by querying the `OBJECT_NAME` and `OBJ_EDITION_NAME` columns in the `UNIFIED_AUDIT_TRAIL` data dictionary view.
## Related Topics
  - Audit Policies for Oracle Virtual Private Database Policy Functions
  - Audit Policies for Oracle Virtual Private Database Policy Functions
  - Syntax for Creating a Unified Audit Policy
  - Example: Auditing All Actions in the Database
  - Creating a Condition for a Unified Audit Policy
  - Using Oracle Virtual Private Database to Control Data Access for more information about Oracle Virtual Private Database
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_AUDIT_UTIL PL/SQL package
  **- Oracle Database Development Guide for detailed information about editions
