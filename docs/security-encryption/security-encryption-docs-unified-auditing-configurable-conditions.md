# Creating a Condition for a Unified Audit Policy

You can use the `CREATE AUDIT POLICY` statement to create conditions for a unified audit policy.
- About Conditions in Unified Audit Policies You can create a unified audit policy that uses a SYS_CONTEXT namespace-attribute pair to specify a condition.
````
- Configuring a Unified Audit Policy with a Condition The WHEN clause in the CREATE AUDIT POLICY statement defines the condition in the audit policy.
*
*
- [Example: Auditing Access to SQLPlus](#GUID-A107C42E-94EF-4E11-AC65-D7334FC153AB) The CREATE AUDIT POLICY statement can audit access to SQLPlus.
- Example: Auditing Actions Not in Specific Hosts The CREATE AUDIT POLICY statement can audit actions that are not in specific hosts.
- Example: Auditing Both a System-Wide and a Schema-Specific Action The CREATE AUDIT POLICY statement can audit both system-wide and schema-specific actions.
- Example: Auditing a Condition Per Statement Occurrence The CREATE AUDIT POLICY statement can audit conditions.
- Example: Unified Audit Session ID of a Current Administrative User Session The SYS_CONTEXT function can be used to find session IDs.
- Example: Unified Audit Session ID of a Current Non-Administrative User Session The SYS_CONTEXT function can find the session ID of a current non-administrative user session.
- How Audit Records from Conditions Appear in the Audit Trail The audit record conditions from a unified audit policy do not appear in the audit trail.
## About Conditions in Unified Audit Policies
You can create a unified audit policy that uses a `SYS_CONTEXT` namespace-attribute pair to specify a condition.
For example, this audit condition can apply to a specific user who may fulfil the audit condition, or a computer host where the audit condition is fulfilled.
If the audit condition is satisfied, then Oracle Database creates an audit record for the event. As part of the condition definition, you must specify whether the audited condition is evaluated per statement occurrence, session, or database instance.
**Note:**   Audit conditions can use both secure and insecure application contexts.
## Configuring a Unified Audit Policy with a Condition
The `WHEN` clause in the `CREATE AUDIT POLICY` statement defines the condition in the audit policy.
  - Use the following syntax to create a unified audit policy that uses a condition:
```
CREATE AUDIT POLICY policy_name action_privilege_role_audit_option [WHEN function_operation_value_list_1 [[AND | OR] function_operation_value_list_n] EVALUATE PER STATEMENT | SESSION | INSTANCE];
```
In this specification:
**
- action_privilege_role_audit_option refers to audit options for system actions, object actions, privileges, and roles.
**
``````````
``````
````
````````**
  - function uses the following types of functions: Numeric functions, such as BITAND, CEIL, FLOOR, and LN POWER Character functions that return character values, such as CONCAT, LOWER, and UPPER Character functions that return numeric values, such as LENGTH or INSTR Environment and identifier functions, such as SYS_CONTEXT and UID. For SYS_CONTEXT, in most cases, you may want to use the USERENV namespace, which is described in Oracle Database SQL Language Reference.
**````````````````
  - operation can be any the following operators: AND, OR, IN, NOT IN, =, , <>
**
  - value_list refers to the condition for which you are testing.
You can include additional conditions for each *function_operation_value_list* set, separated by `AND` or `OR`.
When you write the `WHEN` clause, follow these guidelines:
**
  - Enclose the entire function operation value setting in single quotation marks. Within the clause, enclose each quoted component within two pairs of single quotation marks. Do not use double quotation marks.
  - Do not exceed 4000 bytes for the WHEN condition.
  - STATEMENT evaluates the condition for each relevant auditable statement that occurs.
  - SESSION evaluates the condition only once during the session, and then caches and re-uses the result during the remainder of the session. Oracle Database evaluates the condition the first time the policy is used, and then stores the result in UGA memory afterward.
````
  - INSTANCE evaluates the condition only once during the database instance lifetime. After Oracle Database evaluates the condition, it caches and re-uses the result for the remainder of the instance lifetime. As with the SESSION evaluation, the evaluation takes place the first time it is needed, and then the results are stored in UGA memory afterward.
For example:
```
CREATE AUDIT POLICY oe_orders_pol
 ACTIONS UPDATE ON OE.ORDERS
 WHEN 'SYS_CONTEXT(''USERENV'', ''IDENTIFICATION_TYPE'') = ''EXTERNAL'''
 EVALUATE PER STATEMENT;
```
Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing Access to SQL*Plus
The `CREATE AUDIT POLICY` statement can audit access to SQL*Plus.
Example 27-12 shows how to audit access to the database with SQL*Plus by users who have been directly granted the roles `emp_admin` and `sales_admin`.
Example 27-12 Auditing Access to SQL*Plus
```
CREATE AUDIT POLICY logon_pol
 ACTIONS LOGON
 WHEN 'INSTR(UPPER(SYS_CONTEXT(''USERENV'', ''CLIENT_PROGRAM_NAME'')), ''SQLPLUS'') > 0'
 EVALUATE PER SESSION;
AUDIT POLICY logon_pol BY USERS WITH GRANTED ROLES emp_admin, sales_admin;
```
## Example: Auditing Actions Not in Specific Hosts
The `CREATE AUDIT POLICY` statement can audit actions that are not in specific hosts.
Example 27-13 shows how to audit two actions (`UPDATE` and `DELETE` statements) on the `OE.ORDERS` table, but excludes the host names `sales_24` and `sales_12` from the audit. It performs the audit on a per session basis and writes audit records for failed attempts only.
Example 27-13 Auditing Actions Not in Specific Hosts
```
CREATE AUDIT POLICY oe_table_audit1
 ACTIONS UPDATE ON OE.ORDERS, DELETE ON OE.ORDERS
 WHEN 'SYS_CONTEXT (''USERENV'', ''HOST'') NOT IN (''sales_24'',''sales_12'')'
 EVALUATE PER SESSION;
AUDIT POLICY oe_table_audit1 WHENEVER NOT SUCCESSFUL;
```
## Example: Auditing Both a System-Wide and a Schema-Specific Action
The `CREATE AUDIT POLICY` statement can audit both system-wide and schema-specific actions.
Example 27-14 shows a variation of Example 27-13 in which the `UPDATE` statement is audited system wide. The `DELETE` statement audit is still specific to the `OE.ORDERS` table.
Example 27-14 Auditing Both a System-Wide and a Schema-Specific Action
```
CREATE AUDIT POLICY oe_table_audit2
 ACTIONS UPDATE, DELETE ON OE.ORDERS
 WHEN 'SYS_CONTEXT (''USERENV'', ''HOST'') NOT IN (''sales_24'',''sales_12'')'
 EVALUATE PER SESSION;
AUDIT POLICY oe_table_audit2;
```
## Example: Auditing a Condition Per Statement Occurrence
The `CREATE AUDIT POLICY` statement can audit conditions.
Example 27-15 shows how to audit a condition based on each occurrence of the `DELETE` statement on the `OE.ORDERS` table and exclude user `jmartin` from the audit.
Example 27-15 Auditing a Condition Per Statement Occurrence
```
CREATE AUDIT POLICY sales_clerk_pol
 ACTIONS DELETE ON OE.ORDERS
 WHEN 'SYS_CONTEXT(''USERENV'', ''CLIENT_IDENTIFIER'') = ''sales_clerk'''
 EVALUATE PER STATEMENT;
AUDIT POLICY sales_clerk_pol EXCEPT jmartin;
```
## Example: Unified Audit Session ID of a Current Administrative User Session
The `SYS_CONTEXT` function can be used to find session IDs.
Example 27-16 shows how to find the unified audit session ID of current user session for an administrative user.
Example 27-16 Unified Audit Session ID of a Current Administrative User Session
```
CONNECT SYS AS SYSDBA
Enter password: password
SELECT SYS_CONTEXT('USERENV', 'UNIFIED_AUDIT_SESSIONID') FROM DUAL;
```
Output similar to the following appears:
```
SYS_CONTEXT('USERENV','UNIFIED_AUDIT_SESSIONID')
--------------------------------------------------------------------------------
2318470183
```
Note that in mixed mode auditing, the `UNIFIED_AUDIT_SESSIONID` value in the `USERENV` namespace is different from the value that is recorded by the `SESSIONID` parameter. Hence, if you are using mixed mode auditing and want to find the correct audit session ID, you should use the `USERENV UNIFIED_AUDIT_SESSIONID` parameter, not the `SESSIONID` parameter. In pure unified auditing, the `SESSIONID` and `UNIFIED_AUDIT_SESSIONID` values are the same.
## Example: Unified Audit Session ID of a Current Non-Administrative User Session
The `SYS_CONTEXT` function can find the session ID of a current non-administrative user session.
Example 27-17 shows how to find the unified audit session ID of a current user session for a non-administrative user.
Example 27-17 Unified Audit Session ID of a Current Non-Administrative User Session
```
CONNECT mblake -- Or, CONNECT mblake@hrpdb for a PDB
Enter password: password
SELECT SYS_CONTEXT('USERENV', 'UNIFIED_AUDIT_SESSIONID') FROM DUAL;
```
Output similar to the following appears:
```
SYS_CONTEXT('USERENV','UNIFIED_AUDIT_SESSIONID')
--------------------------------------------------------------------------------
2776921346
```
## How Audit Records from Conditions Appear in the Audit Trail
The audit record conditions from a unified audit policy do not appear in the audit trail.
If the condition evaluates to true and the record is written, then the record appears in the audit trail. You can check the audit trail by querying the `UNIFIED_AUDIT_TRAIL` data dictionary view.
## Related Topics
**- Oracle Database SQL Language Reference for more information about functions that you can use in conditions
  - Audit Policy Data Dictionary Views
