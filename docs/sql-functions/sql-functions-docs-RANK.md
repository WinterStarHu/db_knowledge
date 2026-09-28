# RANK

## Aggregate Syntax
## *rank_aggregate*::=
Description of the illustration rank_aggregate.gif Description of the illustration rank_aggregate.eps
## Analytic Syntax
## *rank_analytic*::=
Description of the illustration rank_analytic.gif Description of the illustration rank_analytic.eps **See Also:**   “Analytic Functions” for information on syntax, semantics, and restrictions
## Purpose
`RANK` calculates the rank of a value in a group of values. The return type is `NUMBER`.
**See Also:**   Table 2-8 for more information on implicit conversion and “Numeric Precedence” for information on numeric precedence Rows with equal values for the ranking criteria receive the same rank. Oracle Database then adds the number of tied rows to the tied rank to calculate the next rank. Therefore, the ranks may not be consecutive numbers. This function is useful for top-N and bottom-N reporting.
``````
- As an aggregate function, RANK calculates the rank of a hypothetical row identified by the arguments of the function with respect to a given sort specification. The arguments of the function must all evaluate to constant expressions within each aggregate group, because they identify a single row within each group. The constant argument expressions and the expressions in the ORDER BY clause of the aggregate match by position. Therefore, the number of arguments must be the same and their types must be compatible.
****
- As an analytic function, RANK computes the rank of each row returned from a query with respect to the other rows returned by the query, based on the values of the value_exprs in the order_by_clause.
**See Also:**   in *Oracle Database Globalization Support Guide* for the collation determination rules, which define the collation `RANK` uses to compare character values for the `ORDER` `BY` clause
## Aggregate Example
The following example calculates the rank of a hypothetical employee in the sample table `hr.employees` with a salary of $15,500 and a commission of 5%:
```
SELECT RANK(15500, .05) WITHIN GROUP (ORDER BY salary, commission_pct) "Rank" FROM employees;
Rank
----------
105
```
Similarly, the following query returns the rank for a $15,500 salary among the employee salaries:
```
SELECT RANK(15500) WITHIN GROUP (ORDER BY salary DESC) "Rank of 15500" FROM employees;
Rank of 15500
--------------
4
```
## Analytic Example
The following statement ranks the employees in the sample `hr` schema in department 60 based on their salaries. Identical salary values receive the same rank and cause nonconsecutive ranks. Compare this example with the analytic example for DENSE_RANK.
```
SELECT department_id, last_name, salary, RANK() OVER (PARTITION BY department_id ORDER BY salary) RANK FROM employees WHERE department_id = 60 ORDER BY RANK, last_name;
DEPARTMENT_ID LAST_NAME                     SALARY       RANK
------------- ------------------------- ---------- ----------
60 Lorentz                         4200          1 60 Austin                          4800          2 60 Pataballa                       4800          2 60 Ernst                           6000          4 60 Hunold                          9000          5
```
