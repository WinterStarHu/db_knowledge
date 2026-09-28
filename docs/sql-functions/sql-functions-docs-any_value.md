# ANY_VALUE

## Syntax
Description of the illustration any_value.eps
## Purpose
`ANY_VALUE` returns a single non-deterministic value of `expr`. You can use it as an aggregate function.
Use `ANY_VALUE` to optimize a query that has a `GROUP BY` clause. `ANY_VALUE` returns a value of an expression in a group. It is optimized to return the first value.
It ensures that there are no comparisons for any incoming row and also eliminates the necessity to specify every column as part of the `GROUP BY` clause. Because it does not compare values, `ANY_VALUE` returns a value more quickly than `MIN` or `MAX` in a `GROUP BY` query.
## Semantics
`ALL`, `DISTINCT`: These keywords are supported by `ANY_VALUE` although they have no effect on the result of the query.
`expr`: The expression can be a column, constant, bind variable, or an expression involving them.
NULL values in the expression are ignored.
Supports all of the data types, except for `LONG`, `LOB`, `FILE`, or `COLLECTION`.
If you use `LONG`, `ORA-00997` is raised.
If you use `LOB`, `FILE`, or `COLLECTION` data types, `ORA-00932` is raised.
`ANY_VALUE` follows the same rules as `MIN` and `MAX`.
Returns any value within each group based on the `GROUP BY` specification. Returns NULL if all rows in the group have NULL expression values.
The result of `ANY_VALUE` is not deterministic.
**Restrictions** `XMLType` and `ANYDATA` are not supported.
Example 7-1 Using ANY_VALUE As an Aggregate Function This example uses `ANY_VALUE` as an aggregate function in a `GROUP BY` query of the SH schema.
```
SELECT c.cust_id, ANY_VALUE(cust_last_name), SUM(amount_sold)
  FROM customers c, sales s
  WHERE s.cust_id = c.cust_id
  GROUP BY c.cust_id;
```
In the following result of the query, only the first eleven rows are shown.
```
CUST_ID  ANY_VALUE(CUST_LAST_NAME) SUM(AMOUNT_SOLD)
------- -------------------------- ----------------
   6950 Sandburg                                 78
  17920 Oliver                                 3201
  66800 Case                                   2024
  37280 Edwards                                2256
 109850 Lindegreen                              757
   3910 Oddell                                  185
  84700 Marker                                164.4
  26380 Remler                                  118
  11600 Oppy                                    158
  23030 Rothrock                                533
  42780 Zanis                                   182
...
630 rows selected.
```
