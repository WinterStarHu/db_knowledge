# NTH_VALUE

## Syntax
Description of the illustration nth_value.gif Description of the illustration nth_value.eps **See Also:**   “Analytic Functions” for information on syntax, semantics, and restrictions of the *analytic_clause*
## Purpose
`NTH_VALUE` returns the *measure_expr* value of the *n*th row in the window defined by the *analytic_clause*. The returned value has the data type of the *measure_expr*.
``````**````
- {RESPECT \ IGNORE} NULLS determines whether null values of measure_expr are included in or eliminated from the calculation. The default is RESPECT NULLS.
**********
- n determines the nth row for which the measure value is to be returned. n can be a constant, bind variable, column, or an expression involving them, as long as it resolves to a positive integer. The function returns NULL if the data source window has fewer than n rows. If n is null, then the function returns an error.
``````````
- FROM {FIRST \ LAST} determines whether the calculation begins at the first or last row of the window. The default is FROM FIRST.
If you omit the *windowing_clause* of the *analytic_clause*, it defaults to `RANGE` `BETWEEN` `UNBOUNDED` `PRECEDING` `AND` `CURRENT` `ROW`. This default sometimes returns an unexpected value for `NTH_VALUE` … `FROM` `LAST` … , because the last value in the window is at the bottom of the window, which is not fixed. It keeps changing as the current row changes. For expected results, specify the *windowing_clause* as `RANGE` `BETWEEN` `UNBOUNDED` `PRECEDING` `AND` `UNBOUNDED` `FOLLOWING`. Alternatively, you can specify the *windowing_clause* as `RANGE` `BETWEEN` `CURRENT` `ROW` `AND` `UNBOUNDED` `FOLLOWING`.
**See Also:** **
- Oracle Database Data Warehousing Guide for more information on the use of this function
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the return value of NTH_VALUE when it is a character value
## Examples
The following example shows the minimum *amount_sold* value for the second *channel_id* in ascending order for each *prod_id* between 13 and 16:
```
SELECT prod_id, channel_id, MIN(amount_sold),
    NTH_VALUE(MIN(amount_sold), 2) OVER (PARTITION BY prod_id ORDER BY channel_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) nv
  FROM sales
  WHERE prod_id BETWEEN 13 and 16
  GROUP BY prod_id, channel_id;
   PROD_ID CHANNEL_ID MIN(AMOUNT_SOLD)         NV
---------- ---------- ---------------- ----------
        13          2           907.34      906.2
        13          3            906.2      906.2
        13          4           842.21      906.2
        14          2          1015.94    1036.72
        14          3          1036.72    1036.72
        14          4           935.79    1036.72
        15          2           871.19     871.19
        15          3           871.19     871.19
        15          4           871.19     871.19
        16          2           266.84     266.84
        16          3           266.84     266.84
        16          4           266.84     266.84
        16          9            11.99     266.84
13 rows selected.
```
