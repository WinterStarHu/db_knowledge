# LNNVL

## Syntax
Description of the illustration lnnvl.gif Description of the illustration lnnvl.eps
## Purpose
`LNNVL` provides a concise way to evaluate a condition when one or both operands of the condition may be null. The function can be used in the `WHERE` clause of a query, or as the `WHEN` condition in a searched `CASE` expression. It takes as an argument a condition and returns `TRUE` if the condition is `FALSE` or `UNKNOWN` and `FALSE` if the condition is `TRUE`. `LNNVL` can be used anywhere a scalar expression can appear, even in contexts where the `IS` [`NOT`] `NULL`, `AND`, or `OR` conditions are not valid but would otherwise be required to account for potential nulls.
Oracle Database sometimes uses the `LNNVL` function internally in this way to rewrite `NOT` `IN` conditions as `NOT` `EXISTS` conditions. In such cases, output from `EXPLAIN` `PLAN` shows this operation in the plan table output. The *condition* can evaluate any scalar values but cannot be a compound condition containing `AND`, `OR`, or `BETWEEN`.
The table that follows shows what `LNNVL` returns given that `a` = 2 and `b` is null.

| Condition | Truth of Condition | LNNVL Return Value |
|---|---|---|
| a = 1 | FALSE | TRUE |
| a = 2 | TRUE | FALSE |
| a IS NULL | FALSE | TRUE |
| b = 1 | UNKNOWN | TRUE |
| b IS NULL | TRUE | FALSE |
| a = b | UNKNOWN | TRUE |

## Examples
Suppose that you want to know the number of employees with commission rates of less than 20%, including employees who do not receive commissions. The following query returns only employees who actually receive a commission of less than 20%:
```
SELECT COUNT(*)
  FROM employees
  WHERE commission_pct < .2;
  COUNT(*)
----------
        11
```
To include the 72 employees who receive no commission at all, you could rewrite the query using the `LNNVL` function as follows:
```
SELECT COUNT(*)
  FROM employees
  WHERE LNNVL(commission_pct >= .2);
  COUNT(*)
----------
        83
```
