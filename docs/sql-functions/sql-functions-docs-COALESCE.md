# COALESCE

## Syntax
Description of the illustration coalesce.gif Description of the illustration coalesce.eps
## Purpose
`COALESCE` returns the first non-null *expr* in the expression list. You must specify at least two expressions. If all occurrences of *expr* evaluate to null, then the function returns null.
Oracle Database uses **short-circuit evaluation**. The database evaluates each *expr* value and determines whether it is `NULL`, rather than evaluating all of the *expr* values before determining whether any of them is `NULL`.
If all occurrences of *expr* are numeric data type or any nonnumeric data type that can be implicitly converted to a numeric data type, then Oracle Database determines the argument with the highest numeric precedence, implicitly converts the remaining arguments to that data type, and returns that data type.
**See Also:**
- Table 2-8 for more information on implicit conversion and Numeric Precedence for information on numeric precedence
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the return value of COALESCE when it is a character value
This function is a generalization of the `NVL` function.
You can also use `COALESCE` as a variety of the `CASE` expression. For example,
```
COALESCE(expr1, expr2)
```
is equivalent to:
```
CASE WHEN expr1 IS NOT NULL THEN expr1 ELSE expr2 END
```
Similarly,
```
COALESCE(expr1, expr2, ..., exprn)
```
where `n` >= 3, is equivalent to:
```
CASE WHEN expr1 IS NOT NULL THEN expr1
   ELSE COALESCE (expr2, ..., exprn) END
```
**See Also:**   NVL and CASE Expressions
## Examples
The following example uses the sample `oe.product_information` table to organize a clearance sale of products. It gives a 10% discount to all products with a list price. If there is no list price, then the sale price is the minimum price. If there is no minimum price, then the sale price is “5”:
```
SELECT product_id, list_price, min_price,
       COALESCE(0.9*list_price, min_price, 5) "Sale"
  FROM product_information
  WHERE supplier_id = 102050
  ORDER BY product_id;
PRODUCT_ID LIST_PRICE  MIN_PRICE       Sale
---------- ---------- ---------- ----------
      1769         48                  43.2
      1770                    73         73
      2378        305        247      274.5
      2382        850        731        765
      3355                                5
```
