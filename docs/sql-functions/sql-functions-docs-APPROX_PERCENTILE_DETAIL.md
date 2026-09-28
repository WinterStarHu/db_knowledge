# APPROX_PERCENTILE_DETAIL

## Syntax
Description of the illustration approx_percentile_detail.eps
## Purpose
`APPROX_PERCENTILE_DETAIL` calculates approximate percentile information for the values of *expr* and returns a `BLOB` value, called a detail, which contains that information in a special format.
The acceptable data types for *expr* depend on the algorithm that you specify with the `DETERMINISTIC` clause. Refer to the DETERMINISTIC clause for more information.
This function is commonly used with the `GROUP` `BY` clause in a `SELECT` statement. It calculates approximate percentile information for *expr* within each group of rows and returns a single detail for each group.
The details returned by `APPROX_PERCENTILE_DETAIL` can be used as input to the `APPROX_PERCENTILE_AGG` function, which enables you to perform aggregations of the details, or the `TO_APPROX_PERCENTILE` function, which converts a detail to a specified percentile value. You can use these three functions together to perform resource-intensive approximate percentile calculations once, store the resulting details, and then perform efficient aggregations and queries on those details. For example:
- Use the APPROX_PERCENTILE_DETAIL function to perform approximate percentile calculations and store the resulting details in a table or materialized view. These could be highly-granular percentile details, such as income percentile information for cities.
- Use the APPROX_PERCENTILE_AGG function to aggregate the details obtained in the previous step and store the resulting details in a table or materialized view. These could be details of lower granularity, such as income percentile information for states.
````````
- Use the TO_APPROX_PERCENTILE function to convert the stored detail values to percentile values. You can use the TO_APPROX_PERCENTILE function to query detail values created by the APPROX_PERCENTILE_DETAIL function or the APPROX_PERCENTILE_AGG function.
**DETERMINISTIC**
This clause lets you control the type of algorithm used to calculate the approximate percentile values.
**
- If you specify DETERMINISTIC, then this function calculates deterministic approximate percentile information. In this case, expr must evaluate to a numeric value, or to a value that can be implicitly converted to a numeric value.
**
```
**See Also:**
- [APPROX_PERCENTILE_AGG](APPROX_PERCENTILE_AGG.html#GUID-72A1DAB0-4A3E-42BF-9E20-92273AD62E11)
- [TO_APPROX_PERCENTILE](TO_APPROX_PERCENTILE.html#GUID-463702B2-9199-41ED-AE03-865CABAD3E23)
```
- If you omit DETERMINSTIC, then this function calculates nondeterministic approximate percentile information. In this case, expr must evaluate to a numeric or datetime value, or to a value that can be implicitly converted to a numeric or datetime value.
## Examples
The examples in this section demonstrate how to use the `APPROX_PERCENTILE_DETAIL`, `APPROX_PERCENTILE_AGG`, and `TO_APPROX_PERCENTILE` functions together to perform resource-intensive approximate percentile calculations once, store the resulting details, and then perform efficient aggregations and queries on those details.
**APPROX_PERCENTILE_DETAIL: Example**
The following statement queries the tables `sh`.`customers` and `sh`.`sales` for the monetary amounts for products sold to each customer. The `APPROX_PERCENTILE_DETAIL` function returns the information in a detail, called `city_detail`, for each city in which customers reside. The returned details are stored in a materialized view called `amt_sold_by_city_mv`.
```
CREATE MATERIALIZED VIEW amt_sold_by_city_mv ENABLE QUERY REWRITE AS SELECT c.country_id country, c.cust_state_province state, c.cust_city city, APPROX_PERCENTILE_DETAIL(s.amount_sold) city_detail FROM customers c, sales s WHERE c.cust_id = s.cust_id GROUP BY c.country_id, c.cust_state_province, c.cust_city;
```
**APPROX_PERCENTILE_AGG: Examples**
The following statement uses the `APPROX_PERCENTILE_AGG` function to read the details stored in `amt_sold_by_city_mv` and create aggregated details that contain the monetary amounts for products sold to customers in each state. These aggregated details are stored in a materialized view called `amt_sold_by_state_mv`.
```
CREATE MATERIALIZED VIEW amt_sold_by_state_mv AS SELECT country, state, APPROX_PERCENTILE_AGG(city_detail) state_detail FROM amt_sold_by_city_mv GROUP BY country, state;
```
The following statement is similar to the previous statement, except it creates aggregated details that contain the approximate monetary amounts for products sold to customers in each country. These aggregated details are stored in a materialized view called `amt_sold_by_country_mv`.
```
CREATE MATERIALIZED VIEW amt_sold_by_country_mv AS SELECT country, APPROX_PERCENTILE_AGG(city_detail) country_detail FROM amt_sold_by_city_mv GROUP BY country;
```
**TO_APPROX_PERCENTILE: Examples**
The following statement uses the `TO_APPROX_PERCENTILE` function to query the details stored in `amt_sold_by_city_mv` and return approximate 25th percentile, 50th percentile, and 75th percentile values for monetary amounts for products sold to customers in each city:
```
SELECT country, state, city, TO_APPROX_PERCENTILE(city_detail, .25, 'NUMBER') "25th Percentile", TO_APPROX_PERCENTILE(city_detail, .50, 'NUMBER') "50th Percentile", TO_APPROX_PERCENTILE(city_detail, .75, 'NUMBER') "75th Percentile" FROM amt_sold_by_city_mv ORDER BY country, state, city;
COUNTRY STATE        CITY           25th Percentile 50th Percentile 75th Percentile
------- ------------ -------------- --------------- --------------- ---------------
52769 Kuala Lumpur Kuala Lumpur             19.29            38.1           53.84 52769 Penang       Batu Ferringhi           21.51           42.09           57.26 52769 Penang       Georgetown               19.15           33.25           56.12 52769 Selangor     Klang                    18.08           32.06           51.29 52769 Selangor     Petaling Jaya            19.29           35.43            60.2 . . .
```
The following statement uses the `TO_APPROX_PERCENTILE` function to query the details stored in `amt_sold_by_state_mv` and return approximate 25th percentile, 50th percentile, and 75th percentile values for monetary amounts for products sold to customers in each state:
```
SELECT country, state, TO_APPROX_PERCENTILE(state_detail, .25, 'NUMBER') "25th Percentile", TO_APPROX_PERCENTILE(state_detail, .50, 'NUMBER') "50th Percentile", TO_APPROX_PERCENTILE(state_detail, .75, 'NUMBER') "75th Percentile" FROM amt_sold_by_state_mv ORDER BY country, state;
COUNTRY STATE        25th Percentile 50th Percentile 75th Percentile
------- ------------ --------------- --------------- ---------------
52769 Kuala Lumpur           19.29            38.1           53.84 52769 Penang                 20.19           36.84           56.12 52769 Selangor               16.97           32.41           52.69 52770 Drenthe                16.76            31.7           53.89 52770 Flevopolder            20.38           39.73           61.81 . . .
```
The following statement uses the `TO_APPROX_PERCENTILE` function to query the details stored in `amt_sold_by_country_mv` and return approximate 25th percentile, 50th percentile, and 75th percentile values for monetary amounts for products sold to customers in each country:
```
SELECT country, TO_APPROX_PERCENTILE(country_detail, .25, 'NUMBER') "25th Percentile", TO_APPROX_PERCENTILE(country_detail, .50, 'NUMBER') "50th Percentile", TO_APPROX_PERCENTILE(country_detail, .75, 'NUMBER') "75th Percentile" FROM amt_sold_by_country_mv ORDER BY country;
COUNTRY 25th Percentile 50th Percentile 75th Percentile
--------- --------------- --------------- ---------------
52769            19.1           35.43           52.78 52770           19.29           38.99           59.58 52771           11.99           44.99          561.47 52772           18.08           33.72           54.16 52773           15.67           29.61           50.65 . . .
```
`APPROX_PERCENTILE_AGG` takes as its input a column of details containing approximate percentile information, and enables you to perform aggregations of that information. The following statement demonstrates how approximate percentile details can interpreted by `APPROX_PERCENTILE_AGG` to provide an input to the `TO_APPROX_PERCENTILE` function. Like the previous example, this query returns approximate 25th percentile values for monetary amounts for products sold to customers in each country. Note that the results are identical to those returned for the 25th percentile in the previous example.
```
SELECT country, TO_APPROX_PERCENTILE(APPROX_PERCENTILE_AGG(city_detail), .25, 'NUMBER') "25th Percentile" FROM amt_sold_by_city_mv GROUP BY country ORDER BY country;
COUNTRY 25th Percentile
---------- ---------------
52769            19.1 52770           19.29 52771           11.99 52772           18.08 52773           15.67 . . .
```
**Query Rewrite and Materialized Views Based on Approximate Queries: Example**
In APPROX_PERCENTILE_DETAIL: Example, the `ENABLE` `QUERY` `REWRITE` clause is specified when creating the materialized view `amt_sold_by_city_mv`. This enables queries that contain approximation functions, such as `APPROX_MEDIAN` or `APPROX_PERCENTILE`, to be rewritten using the materialized view.
For example, ensure that query rewrite is enabled at either the database level or for the current session, and run the following query:
```
SELECT c.country_id country, APPROX_MEDIAN(s.amount_sold) amount_median FROM customers c, sales s WHERE c.cust_id = s.cust_id GROUP BY c.country_id;
```
Explain the plan by querying `DBMS_XPLAN`:
```
SET LINESIZE 300 SET PAGESIZE 0 COLUMN plan_table_output FORMAT A150 SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(format=>'BASIC'));
```
As shown in the following plan, the optimizer used the materialized view `amt_sold_by_city_mv` for the query:
```
EXPLAINED SQL STATEMENT:
------------------------
SELECT c.country_id country, APPROX_MEDIAN(s.amount_sold) amount_median FROM customers c, sales s WHERE c.cust_id = s.cust_id GROUP BY c.country_id Plan hash value: 2232676046
-------------------------------------------------------------

| Id  | Operation                     | Name                |

-------------------------------------------------------------

|   0 | SELECT STATEMENT              |                     |
|   1 |  HASH GROUP BY APPROX         |                     |
|   2 |   MAT_VIEW REWRITE ACCESS FULL| AMT_SOLD_BY_CITY_MV |

-------------------------------------------------------------
```
