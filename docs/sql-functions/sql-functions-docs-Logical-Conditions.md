# Logical Conditions

A logical condition combines the results of two component conditions to produce a single result based on them or to invert the result of a single condition. Table 6-4 lists logical conditions.
Table 4 Logical Conditions

| Type of Condition | Operation | Examples |
|---|---|---|
| NOT | Returns TRUE if the following condition is FALSE. Returns FALSE if it is TRUE. If it is UNKNOWN, then it remains UNKNOWN. | SELECT * FROM employees WHERE NOT (job_id IS NULL) ORDER BY employee_id; SELECT * FROM employees WHERE NOT (salary BETWEEN 1000 AND 2000) ORDER BY employee_id; |
| AND | Returns TRUE if both component conditions are TRUE. Returns FALSE if either is FALSE. Otherwise returns UNKNOWN. | SELECT * FROM employees WHERE job_id = 'PU_CLERK' AND department_id = 30 ORDER BY employee_id; |
| OR | Returns TRUE if either component condition is TRUE. Returns FALSE if both are FALSE. Otherwise returns UNKNOWN. | SELECT * FROM employees WHERE job_id = 'PU_CLERK' OR department_id = 10 ORDER BY employee_id; |

Table 6-5 shows the result of applying the `NOT` condition to an expression.
Table 5 NOT Truth Table

| – | TRUE | FALSE | UNKNOWN |
|---|---|---|---|
| NOT | FALSE | TRUE | UNKNOWN |

Table 6-6 shows the results of combining the `AND` condition to two expressions.
Table 6 AND Truth Table

| AND | TRUE | FALSE | UNKNOWN |
|---|---|---|---|
| TRUE | TRUE | FALSE | UNKNOWN |
| FALSE | FALSE | FALSE | FALSE |
| UNKNOWN | UNKNOWN | FALSE | UNKNOWN |

For example, in the `WHERE` clause of the following `SELECT` statement, the `AND` logical condition is used to ensure that only those hired before 2004 and earning more than $2500 a month are returned:
```
SELECT * FROM employees
WHERE hire_date < TO_DATE('01-JAN-2004', 'DD-MON-YYYY')
  AND salary > 2500
  ORDER BY employee_id;
```
Table 6-7 shows the results of applying `OR` to two expressions.
Table 7 OR Truth Table

| OR | TRUE | FALSE | UNKNOWN |
|---|---|---|---|
| TRUE | TRUE | TRUE | TRUE |
| FALSE | TRUE | FALSE | UNKNOWN |
| UNKNOWN | TRUE | UNKNOWN | UNKNOWN |

For example, the following query returns employees who have a 40% commission rate or a salary greater than $20,000:
```
SELECT employee_id FROM employees
   WHERE commission_pct = .4 OR salary > 20000
   ORDER BY employee_id;
```
