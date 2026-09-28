# APPROX_COUNT_DISTINCT

## Syntax
Description of the illustration approx_count_distinct.gif Description of the illustration approx_count_distinct.eps
## Purpose
`APPROX_COUNT_DISTINCT` returns the approximate number of rows that contain a distinct value for *expr*.
This function provides an alternative to the `COUNT` `(DISTINCT` *expr*`)` function, which returns the exact number of rows that contain distinct values of *expr*. `APPROX_COUNT_DISTINCT` processes large amounts of data significantly faster than `COUNT`, with negligible deviation from the exact result.
For *expr*, you can specify a column of any scalar data type other than `BFILE`, `BLOB`, `CLOB`, `LONG`, `LONG` `RAW`, or `NCLOB`.
`APPROX_COUNT_DISTINCT` ignores rows that contain a null value for *expr*. This function returns a `NUMBER`.
**See Also:**
````**
- COUNT for more information on the COUNT (DISTINCT expr) function
****
- in Oracle Database Globalization Support Guide for the collation determination rules, which define the collation APPROX_COUNT_DISTINCT uses to compare character values for expr
## Examples
The following statement returns the approximate number of rows with distinct values for `manager_id`:
```
SELECT APPROX_COUNT_DISTINCT(manager_id) AS "Active Managers" FROM employees;
Active Managers
---------------
18
```
The following statement returns the approximate number of distinct customers for each product:
```
SELECT prod_id, APPROX_COUNT_DISTINCT(cust_id) AS "Number of Customers" FROM sales GROUP BY prod_id ORDER BY prod_id;
PROD_ID Number of Customers
---------- -------------------
13                2516 14                2030 15                2105 16                2367 17                2093 18                2975 19                2630 20                3791 . . .
```
