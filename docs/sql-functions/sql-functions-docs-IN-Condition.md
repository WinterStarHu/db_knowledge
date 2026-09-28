# IN Condition

An *in_condition* is a membership condition. It tests a value for membership in a list of values or subquery
## *in_condition*::=
Description of the illustration in_condition.gif Description of the illustration in_condition.eps
## *expression_list*::=
Description of the illustration expression_list.gif Description of the illustration expression_list.eps If you use the upper form of the *in_condition* condition (with a single expression to the left of the operator), then you must use the upper form of *expression_list*. If you use the lower form of this condition (with multiple expressions to the left of the operator), then you must use the lower form of *expression_list*, and the expressions in each *expression_list* must match in number and data type the expressions to the left of the operator. You can specify up to 1000 expressions in *expression_list*.
Oracle Database does not always evaluate the expressions in an *expression_list* in the order in which they appear in the `IN` list. However, expressions in the select list of a subquery are evaluated in their specified order.
**See Also:**   Expression Lists Table 6-12 lists the form of `IN` condition.
Table 12 IN Condition

| Type of Condition | Operation | Example |
|---|---|---|
| IN | Equal-to-any-member-of test. Equivalent to =ANY. | SELECT * FROM employees WHERE job_id IN ('PU_CLERK','SH_CLERK') ORDER BY employee_id; SELECT * FROM employees WHERE salary IN (SELECT salary FROM employees WHERE department_id =30) ORDER BY employee_id; |
| NOT IN | Equivalent to !=ALL. Evaluates to FALSE if any member of the set is NULL. | SELECT * FROM employees WHERE salary NOT IN (SELECT salary FROM employees WHERE department_id = 30) ORDER BY employee_id; SELECT * FROM employees WHERE job_id NOT IN ('PU_CLERK', 'SH_CLERK') ORDER BY employee_id; |

If any item in the list following a `NOT` `IN` operation evaluates to null, then all rows evaluate to `FALSE` or `UNKNOWN`, and no rows are returned. For example, the following statement returns the string ‘`True`’ for each row:
```
SELECT 'True' FROM employees
   WHERE department_id NOT IN (10, 20);
```
However, the following statement returns no rows:
```
SELECT 'True' FROM employees
    WHERE department_id NOT IN (10, 20, NULL);
```
The preceding example returns no rows because the `WHERE` clause condition evaluates to:
```
department_id != 10 AND department_id != 20 AND department_id != null
```
Because the third condition compares `department_id` with a null, it results in an `UNKNOWN`, so the entire expression results in `FALSE` (for rows with `department_id` equal to 10 or 20). This behavior can easily be overlooked, especially when the `NOT` `IN` operator references a subquery.
Moreover, if a `NOT` `IN` condition references a subquery that returns no rows at all, then all rows will be returned, as shown in the following example:
```
SELECT 'True' FROM employees
   WHERE department_id NOT IN (SELECT 0 FROM DUAL WHERE 1=2);
```
For character arguments, the `IN` condition is collation-sensitive. The collation determination rules determine the collation to use.
**See Also:**   in *Oracle Database Globalization Support Guide* for the collation determination rules for the `IN` condition
## Restriction on LEVEL in WHERE Clauses
In a [`NOT`] `IN` condition in a `WHERE` clause, if the right-hand side of the condition is a subquery, you cannot use `LEVEL` on the left-hand side of the condition. However, you can specify `LEVEL` in a subquery of the `FROM` clause to achieve the same result. For example, the following statement is not valid:
```
SELECT employee_id, last_name FROM employees
   WHERE (employee_id, LEVEL)
      IN (SELECT employee_id, 2 FROM employees)
   START WITH employee_id = 2
   CONNECT BY PRIOR employee_id = manager_id;
```
But the following statement is valid because it encapsulates the query containing the `LEVEL` information in the `FROM` clause:
```
SELECT v.employee_id, v.last_name, v.lev FROM
      (SELECT employee_id, last_name, LEVEL lev
      FROM employees v
      START WITH employee_id = 100
      CONNECT BY PRIOR employee_id = manager_id) v
   WHERE (v.employee_id, v.lev) IN
      (SELECT employee_id, 2 FROM employees);
```
