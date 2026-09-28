# Using the Predefined REDACT_AUDIT Policy to Mask Bind Values

The predefined `REDACT_AUDIT` policy masks bind values, which can appear in trace files when an event is set.
- About the REDACT_AUDIT Policy The predefined REDACT_AUDIT transparent sensitive data protection policy masks bind values.
``````
- Variables Associated with Sensitive Columns Bind variables affect the use of sensitive columns with conditions, SELECT items, and INSERT or UPDATE operations.
- How Bind Variables on Sensitive Columns Behave with Views A bind variable that appears in a query on a view is considered sensitive if the view column references a sensitive column.
- Disabling the REDACT_AUDIT Policy By default, the REDACT_AUDIT policy is enabled for all sensitive columns.
- Enabling the REDACT_AUDIT Policy You can enable the REDACT_AUDIT policy for a specific sensitive column or for all columns in the database.
## About the REDACT_AUDIT Policy
The predefined `REDACT_AUDIT` transparent sensitive data protection policy masks bind values.
The bind values of the bind variables that are used in SQL statements can appear in audit records when auditing is configured. Similarly, bind values can appear in trace files when the appropriate event is set. Bind values can also appear when you query the `V$SQL_BIND_DATA` dynamic view.
The `REDACT_AUDIT` transparent sensitive data protection policy displays the data as an asterisk (`*`) in audit records, trace files, and in `V$SQL_BIND_DATA` view queries. By default the `REDACT_AUDIT` policy is associated with every sensitive type in the database. When you identify a column as sensitive, by default, the `REDACT_AUDIT` policy is enabled for it.
You can disable and enable the `REDACT_AUDIT` policy, but you cannot alter or drop it.
## Variables Associated with Sensitive Columns
Bind variables affect the use of sensitive columns with conditions, `SELECT` items, and `INSERT` or `UPDATE` operations.
- About Variables Associated with Sensitive Columns You can associate variables with sensitive columns in TSDP policies.
- Bind Variables and Sensitive Columns in the Expressions of Conditions You can include sensitive columns in SQL queries that have WHERE clauses.
````
- A Bind Variable and a Sensitive Column Appearing in the Same SELECT Item If a column in a SELECT item is sensitive, then all the binds in the SELECT item are considered sensitive.
````
- Bind Variables in Expressions Assigned to Sensitive Columns in INSERT or UPDATE Operations You can assign multiple bind variables to different columns in one INSERT or UPDATE statement.
### About Variables Associated with Sensitive Columns
You can associate variables with sensitive columns in TSDP policies.
A bind variable can be considered to be sensitive or “associated” with a sensitive column if the bind variable occurs in the same comparison condition as a sensitive column, if it occurs in a `SELECT` statement alongside a sensitive column, or if it occurs in an `INSERT` or `UPDATE` operation that involves a sensitive column.
### Bind Variables and Sensitive Columns in the Expressions of Conditions
You can include sensitive columns in SQL queries that have `WHERE` clauses.
A SQL query that contains a `WHERE` clause can include sensitive columns and bind variables for use with comparison operators such as `=`, `IS`, `IS NOT`, `LIKE`, `BETWEEN`, and `IN`, as well as in subqueries.
In the following comparison query, the bind value in `VAR1` is masked because `VAR1` and the sensitive column `SALARY` appear in the expression that is compared using the comparison condition `>`.
```
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES WHERE SALARY > :VAR1;
```
In the next query, the bind values in `VAR1` and `VAR2` are masked because `VAR1`, `VAR2`, and the sensitive column `SALARY` appear in the expression that uses the comparison equality condition `=`.
```
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES WHERE SALARY + :VAR1 = TO_NUMBER(:VAR2, '9G999D99');
```
For floating point conditions, the sensitive column and the bind variable appear in the expression that is evaluated. In the following example, the bind value in `VAR1` is masked because `VAR1` and the sensitive column `SALARY` appear in the expression for the `IS NOT NAN` condition.
```
SELECT COUNT( ) FROM HR.EMPLOYEES WHERE (SALARY * :VAR1) IS NOT NAN;
```
In pattern matching conditions, the sensitive column and the bind variable appear as arguments. In the following example, the bind value in `VAR1` is masked because `VAR1` and the sensitive column `LAST_NAME` are the arguments for the `LIKE` condition.
```
SELECT LAST_NAME FROM HR.EMPLOYEES WHERE LAST_NAME LIKE :VAR1;
```
For `BETWEEN` conditions, the sensitive column and the bind variable appear in the expressions that are arguments. In the following example, bind values in `VAR1` and `VAR2` are masked because `VAR1`, `VAR2`, and `SALARY` appear in expressions that are arguments to the `BETWEEN` condition.
```
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES WHERE SALARY BETWEEN :VAR1 AND :VAR2;
```
In the next example, the sensitive column and the bind variable are the arguments of the `IN` condition. Here, the bind values in `VAR1` and `VAR2` are masked because `VAR1`, `VAR2`, and the sensitive column `SALARY` appear as arguments to the `IN` condition.
```
SELECT COUNT( ) FROM HR.EMPLOYEES WHERE SALARY IN ( :VAR1, :VAR2);
```
When a condition has a nested subquery as an argument, the bind variables and sensitive columns that appear in the nested subquery are not considered to be associated with the condition. In the following query, the sensitive column `SALARY` and the subquery are expressions for the greater-than condition `>`.
```
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES WHERE SALARY > (SELECT SALARY FROM HR.EMPLOYEES WHERE MANAGER_ID = :VAR1);
```
However, variable `VAR1` is associated with column `MANAGER_ID` as variable `VAR1` and `MANAGER_ID` appears in expressions being compared using the condition `=`. Because `MANAGER_ID` is not a sensitive column, variable `VAR1` is not considered sensitive. The variable `VAR1` is not considered to be associated with the sensitive column `SALARY`.
In the case of the logical conditions, model conditions, multiset conditions, XML conditions, compound conditions, `IS OF` type conditions, and `EXISTS` conditions, there can be no cases where a bind variable and a sensitive column are associated with each other. This is due to the structure or the nature of these conditions.
### A Bind Variable and a Sensitive Column Appearing in the Same SELECT Item
If a column in a `SELECT` item is sensitive, then all the binds in the `SELECT` item are considered sensitive.
For example, assume that `HR.EMPLOYEES.SALARY` and `HR.EMPLOYEES.COMMISSION_PCT` are sensitive columns. In the following query, the bind variable `VAR1` is considered sensitive because it appears in the same `SELECT` item as the sensitive column `SALARY`, so its bind value is masked.
```
SELECT (SALARY * :VAR1) AS BONUS AS FROM HR.EMPLOYEES WHERE EMPLOYEE_ID = :VAR2;
```
In the next example, the bind variable `VAR1` is considered sensitive because it appears in the same `SELECT` item as `SALARY`. `VAR2` is considered sensitive because it appears in the same `SELECT` item as the sensitive column `COMMISSION_PCT`.
```
SELECT (SALARY * :VAR1), (COMMISSION_PCT * :VAR2), (EMPNO + :VAR3) AS BONUS AS FROM PAYROLL.ACCOUNT;
```
### Bind Variables in Expressions Assigned to Sensitive Columns in INSERT or UPDATE Operations
You can assign multiple bind variables to different columns in one `INSERT` or `UPDATE` statement.
Consider the following `INSERT` statement:
```
INSERT INTO PAYROLL.ACCOUNT (ACCOUNT_NUM, SALARY) VALUES (:VAR1 * :VAR2 , :VAR3);
```
In this `INSERT` statement, the following takes place:
````````
- The bind variables VAR1 and VAR2 appear in the expression (:VAR1 * :VAR2), which is assigned to the sensitive column ACCOUNT_NUM.
````
- The bind variable VAR3 is assigned to sensitive column SALARY.
Consider the following `UPDATE` statement:
```
UPDATE PAYROLL.ACCOUNT SET ACCOUNT_NUM = :VAR1, SALARY = :VAR2;
```
In this `UPDATE` statement, the following takes place:
````
- The bind variable VAR1 is assigned to sensitive column ACCOUNT_NUM.
````
- The bind variable VAR2 is assigned to sensitive column SALARY.
## How Bind Variables on Sensitive Columns Behave with Views
A bind variable that appears in a query on a view is considered sensitive if the view column references a sensitive column.
For example, suppose you identify the `SALARY` column in the `HR.EMPLOYEES` table as sensitive. Then you create the view `EMPLOYEES_VIEW` as follows:
```
CREATE OR REPLACE VIEW HR.EMPLOYEES_VIEW AS SELECT * FROM HR.EMPLOYEES;
```
When a user references the `SALARY` column from this view in a SQL statement, any bind variable that has been associated with the `SALARY` column is considered sensitive and its bind value then masked.
```
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES_VIEW WHERE SALARY = :VAR1;
```
In this case, the bind variable `VAR1` is masked because it is associated with the `HR.EMPLOYEES_VIEW.SALARY` column, which references the sensitive column `HR.EMPLOYEES.SALARY`.
## Disabling the REDACT_AUDIT Policy
By default, the `REDACT_AUDIT` policy is enabled for all sensitive columns.
You can disable it for a specific sensitive column or all sensitive columns, and when needed, re-enable it. Remember that you cannot alter or delete the `REDACT_AUDIT` policy.
  ````- To disable the REDACT_AUDIT policy, use the DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN procedure.
For example, to disable the `REDACT_AUDIT` policy for the `SALARY` column of `HR.EMPLOYEES`:
```
BEGIN
 DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN(
  schema_name          => 'HR',
  table_name           => 'EMPLOYEES',
  column_name          => 'SALARY',
  policy               => 'REDACT_AUDIT');
END;
/
```
The following example shows how to disable the `REDACT_AUDIT` policy for all sensitive columns in the current database.
```
BEGIN
 DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN(
  policy               => 'REDACT_AUDIT');
END;
/
```
## Enabling the REDACT_AUDIT Policy
You can enable the `REDACT_AUDIT` policy for a specific sensitive column or for all columns in the database.
  ````- To enable the REDACT_AUDIT policy, use the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_COLUMN procedure.
For example, to re-enable the `REDACT_AUDIT` policy for the `SALARY` column of `HR.EMPLOYEES`:
```
BEGIN DBMS_TSDP_PROTECT.ENABLE_PROTECTION_COLUMN( schema_name          => 'HR', table_name           => 'EMPLOYEES', column_name          => 'SALARY', policy               => 'REDACT_AUDIT');
END;
/
```
The following example shows how to enable the `REDACT_AUDIT` policy for all sensitive columns in the current database.
```
BEGIN DBMS_TSDP_PROTECT.ENABLE_PROTECTION_COLUMN( policy               => 'REDACT_AUDIT');
END;
/
```
