# LISTAGG

## Syntax
Description of the illustration listagg.eps (*listagg_overflow_clause::=*, *order_by_clause::=*, *query_partition_clause::=*)
## *listagg_overflow_clause*::=
Description of the illustration listagg_overflow_clause.eps **See Also:**   “Analytic Functions” for information on syntax, semantics, and restrictions of the `ORDER` `BY` clause and `OVER` clause
## Purpose
For a specified measure, `LISTAGG` orders data within each group specified in the `ORDER` `BY` clause and then concatenates the values of the measure column.
- As a single-set aggregate function, LISTAGG operates on all rows and returns a single output row.
````
- As a group-set aggregate, the function operates on and returns an output row for each group defined by the GROUP BY clause.
**
- As an analytic function, LISTAGG partitions the query result set into groups based on one or more expression in the query_partition_clause.
The arguments to the function are subject to the following rules:
- The ALL keyword is optional and is provided for semantic clarity.
**
- The measure_expr is the measure column and can be any expression. Null values in the measure column are ignored.
**
````````````
- The delimiter designates the string that is to separate the measure column values. This clause is optional and defaults to NULL. If measure_expr is of type RAW, then the delimiter must be of type RAW. You can achieve this by specifying the delimiter as a character string that can be implicitly converted to RAW, or by explicitly converting the delimiter to RAW, for example, using the UTL_RAW.CAST_TO_RAW function.
**````
- The order_by_clause determines the order in which the concatenated values are returned. The function is deterministic only if the ORDER BY column list achieved unique ordering.
**
- If you specify order_by_clause, you must also specify WITHIN GROUP and vice versa. These two clauses must be specified together or not at all.
The `DISTINCT` keyword removes duplicate values from the list.
If the measure column is of type `RAW`, then the return data type is `RAW`. Otherwise, the return data type is `VARCHAR2`.
The maximum length of the return data type depends on the value of the `MAX_STRING_SIZE` initialization parameter. If `MAX_STRING_SIZE` `=` `EXTENDED`, then the maximum length is 32767 bytes for the `VARCHAR2` and `RAW` data types. If `MAX_STRING_SIZE` `=` `STANDARD`, then the maximum length is 4000 bytes for the `VARCHAR2` data type and 2000 bytes for the `RAW` data type. A final delimiter is not included when determining if the return value fits in the return data type.
**See Also:**
- Extended Data Types for more information on the MAX_STRING_SIZE initialization parameter
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of LISTAGG
**
- Database Data Warehousing Guide for details.
## *listagg_overflow_clause*
This clause controls how the function behaves when the return value exceeds the maximum length of the return data type.
**ON OVERFLOW ERROR** If you specify this clause, then the function returns an ORA-01489 error. This is the default.
**ON OVERFLOW TRUNCATE** If you specify this clause, then the function returns a truncated list of measure values.
** **``````````
- The truncation_indicator designates the string that is to be appended to the truncated list of measure values. If you omit this clause, then the truncation indicator is an ellipsis (...). If measure_expr is of type RAW, then the truncation indicator must be of type RAW. You can achieve this by specifying the truncation indicator as a character string that can be implicitly converted to RAW, or by explicitly converting the truncation indicator to RAW, for example, using the UTL_RAW.CAST_TO_RAW function.
````
- If you specify WITH COUNT, then after the truncation indicator, the database appends the number of truncated values, enclosed in parentheses. In this case, the database truncates enough measure values to allow space in the return value for a final delimiter, the truncation indicator, and 24 characters for the number value enclosed in parentheses.
````
- If you specify WITHOUT COUNT, then the database omits the number of truncated values from the return value. In this case, the database truncates enough measure values to allow space in the return value for a final delimiter and the truncation indicator.
If you do not specify `WITH` `COUNT` or `WITHOUT` `COUNT`, then the default is `WITH` `COUNT`.
## Aggregate Examples
The following single-set aggregate example lists all of the employees in Department 30 in the `hr.employees` table, ordered by hire date and last name:
```
SELECT LISTAGG(last_name, '; ')
         WITHIN GROUP (ORDER BY hire_date, last_name) "Emp_list",
       MIN(hire_date) "Earliest"
  FROM employees
  WHERE department_id = 30;
Emp_list                                                     Earliest
------------------------------------------------------------ ---------
Raphaely; Khoo; Tobias; Baida; Himuro; Colmenares            07-DEC-02
```
The following group-set aggregate example lists, for each department ID in the `hr.employees` table, the employees in that department in order of their hire date:
```
SELECT department_id "Dept.",
       LISTAGG(last_name, '; ') WITHIN GROUP (ORDER BY hire_date) "Employees"
  FROM employees
  GROUP BY department_id
  ORDER BY department_id;
Dept. Employees
------ ------------------------------------------------------------
    10 Whalen
    20 Hartstein; Fay
    30 Raphaely; Khoo; Tobias; Baida; Himuro; Colmenares
    40 Mavris
    50 Kaufling; Ladwig; Rajs; Sarchand; Bell; Mallin; Weiss; Davie
       s; Marlow; Bull; Everett; Fripp; Chung; Nayer; Dilly; Bissot
       ; Vollman; Stiles; Atkinson; Taylor; Seo; Fleaur; Matos; Pat
       el; Walsh; Feeney; Dellinger; McCain; Vargas; Gates; Rogers;
        Mikkilineni; Landry; Cabrio; Jones; Olson; OConnell; Sulliv
       an; Mourgos; Gee; Perkins; Grant; Geoni; Philtanker; Markle
    60 Austin; Hunold; Pataballa; Lorentz; Ernst
    70 Baer
. . .
```
The following example is identical to the previous example, except it contains the `ON` `OVERFLOW` `TRUNCATE` clause. For the purpose of this example, assume that the maximum length of the return value is an artificially small number of 200 bytes. Because the list of employees for department 50 exceeds 200 bytes, the list is truncated and appended with a final delimiter ‘`;` ‘, the specified truncation indicator ‘`...`’, and the number of truncated values ‘`(23)`’.
```
SELECT department_id "Dept.",
       LISTAGG(last_name, '; ' ON OVERFLOW TRUNCATE '...')
               WITHIN GROUP (ORDER BY hire_date) "Employees"
  FROM employees
  GROUP BY department_id
  ORDER BY department_id;
Dept. Employees
------ ------------------------------------------------------------
    10 Whalen
    20 Hartstein; Fay
    30 Raphaely; Khoo; Tobias; Baida; Himuro; Colmenares
    40 Mavris
    50 Kaufling; Ladwig; Rajs; Sarchand; Bell; Mallin; Weiss; Davie
       s; Marlow; Bull; Everett; Fripp; Chung; Nayer; Dilly; Bissot
       ; Vollman; Stiles; Atkinson; Taylor; Seo; Fleaur; ... (23)
    70 Baer
. . .
```
## Analytic Example
The following analytic example shows, for each employee hired earlier than September 1, 2003, the employee’s department, hire date, and all other employees in that department also hired before September 1, 2003:
```
SELECT department_id "Dept", hire_date "Date", last_name "Name",
       LISTAGG(last_name, '; ') WITHIN GROUP (ORDER BY hire_date, last_name)
         OVER (PARTITION BY department_id) as "Emp_list"
  FROM employees
  WHERE hire_date < '01-SEP-2003'
  ORDER BY "Dept", "Date", "Name";
 Dept Date      Name            Emp_list
----- --------- --------------- ---------------------------------------------
   30 07-DEC-02 Raphaely        Raphaely; Khoo
   30 18-MAY-03 Khoo            Raphaely; Khoo
   40 07-JUN-02 Mavris          Mavris
   50 01-MAY-03 Kaufling        Kaufling; Ladwig
   50 14-JUL-03 Ladwig          Kaufling; Ladwig
   70 07-JUN-02 Baer            Baer
   90 13-JAN-01 De Haan         De Haan; King
   90 17-JUN-03 King            De Haan; King
  100 16-AUG-02 Faviet          Faviet; Greenberg
  100 17-AUG-02 Greenberg       Faviet; Greenberg
  110 07-JUN-02 Gietz           Gietz; Higgins
  110 07-JUN-02 Higgins         Gietz; Higgins
```
