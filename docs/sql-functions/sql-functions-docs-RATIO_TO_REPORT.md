# RATIO_TO_REPORT

## Syntax
Description of the illustration ratio_to_report.gif Description of the illustration ratio_to_report.eps **See Also:**   “Analytic Functions” for information on syntax, semantics, and restrictions, including valid forms of *expr*
## Purpose
`RATIO_TO_REPORT` is an analytic function. It computes the ratio of a value to the sum of a set of values. If *expr* evaluates to null, then the ratio-to-report value also evaluates to null.
The set of values is determined by the *query_partition_clause*. If you omit that clause, then the ratio-to-report is computed over all rows returned by the query.
You cannot nest analytic functions by using `RATIO_TO_REPORT` or any other analytic function for *expr*. However, you can use other built-in function expressions for *expr*. Refer to “About SQL Expressions” for information on valid forms of *expr*.
## Examples
The following example calculates the ratio-to-report value of each purchasing clerk’s salary to the total of all purchasing clerks’ salaries:
```
SELECT last_name, salary, RATIO_TO_REPORT(salary) OVER () AS rr
   FROM employees
   WHERE job_id = 'PU_CLERK'
   ORDER BY last_name, salary, rr;
LAST_NAME                     SALARY         RR
------------------------- ---------- ----------
Baida                           2900 .208633094
Colmenares                      2500 .179856115
Himuro                          2600  .18705036
Khoo                            3100 .223021583
Tobias                          2800 .201438849
```
