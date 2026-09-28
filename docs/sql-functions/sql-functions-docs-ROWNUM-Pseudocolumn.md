# ROWNUM Pseudocolumn

**Note:**
- The ROW_NUMBER built-in SQL function provides superior support for ordering the results of a query. Refer to ROW_NUMBER for more information.
****
- The row_limiting_clause of the SELECT statement provides superior support for limiting the number of rows returned by a query. Refer to row_limiting_clause for more information.
For each row returned by a query, the `ROWNUM` pseudocolumn returns a number indicating the order in which Oracle selects the row from a table or set of joined rows. The first row selected has a `ROWNUM` of 1, the second has 2, and so on.
You can use `ROWNUM` to limit the number of rows returned by a query, as in this example:
```
SELECT *
  FROM employees
  WHERE ROWNUM < 11;
```
If an `ORDER` `BY` clause follows `ROWNUM` in the same query, then the rows will be reordered by the `ORDER` `BY` clause. The results can vary depending on the way the rows are accessed. For example, if the `ORDER` `BY` clause causes Oracle to use an index to access the data, then Oracle may retrieve the rows in a different order than without the index. Therefore, the following statement does not necessarily return the same rows as the preceding example:
```
SELECT *
  FROM employees
  WHERE ROWNUM < 11
  ORDER BY last_name;
```
If you embed the `ORDER` `BY` clause in a subquery and place the `ROWNUM` condition in the top-level query, then you can force the `ROWNUM` condition to be applied after the ordering of the rows. For example, the following query returns the employees with the 10 smallest employee numbers. This is sometimes referred to as **top-N** **reporting**:
```
SELECT *
  FROM (SELECT * FROM employees ORDER BY employee_id)
  WHERE ROWNUM < 11;
```
In the preceding example, the `ROWNUM` values are those of the top-level `SELECT` statement, so they are generated after the rows have already been ordered by `employee_id` in the subquery.
Conditions testing for `ROWNUM` values greater than a positive integer are always false. For example, this query returns no rows:
```
SELECT *
  FROM employees
  WHERE ROWNUM > 1;
```
The first row fetched is assigned a `ROWNUM` of 1 and makes the condition false. The second row to be fetched is now the first row and is also assigned a `ROWNUM` of 1 and makes the condition false. All rows subsequently fail to satisfy the condition, so no rows are returned.
You can also use `ROWNUM` to assign unique values to each row of a table, as in this example:
```
UPDATE my_table
  SET column1 = ROWNUM;
```
Refer to the function ROW_NUMBER for an alternative method of assigning unique numbers to rows.
**Note:**   Using `ROWNUM` in a query can affect view optimization.
