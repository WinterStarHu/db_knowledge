# TO_DSINTERVAL

## Syntax
Description of the illustration to_dsinterval.gif Description of the illustration to_dsinterval.eps
## *sql_format*::=
Description of the illustration sql_format.gif Description of the illustration sql_format.eps
## *ds_iso_format*::=
Description of the illustration ds_iso_format.gif Description of the illustration ds_iso_format.eps **Note:**   In earlier releases, the `TO_DSINTERVAL` function accepted an optional *nlsparam* clause. This clause is still accepted for backward compatibility, but has no effect.
## Purpose
`TO_DSINTERVAL` converts its argument to a value of `INTERVAL` `DAY` `TO` `SECOND` data type.
For the argument, you can specify any expression that evaluates to a character string of `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type.
`TO_DSINTERVAL` accepts argument in one of the two formats:
- SQL interval format compatible with the SQL standard (ISO/IEC 9075)
- ISO duration format compatible with the ISO 8601:2004 standard
In the SQL format, *days* is an integer between 0 and 999999999, *hours* is an integer between 0 and 23, and *minutes* and *seconds* are integers between 0 and 59. *frac_secs* is the fractional part of seconds between .0 and .999999999. One or more blanks separate days from hours. Additional blanks are allowed between format elements.
In the ISO format, *days*, *hours*, *minutes* and *seconds* are integers between 0 and 999999999. *frac_secs* is the fractional part of seconds between .0 and .999999999. No blanks are allowed in the value. If you specify `T`, then you must specify at least one of the *hours*, *minutes*, or *seconds* values.
The optional `DEFAULT` *return_value* `ON` `CONVERSION` `ERROR` clause allows you to specify the value this function returns if an error occurs while converting the argument to an `INTERVAL` `DAY` `TO` `SECOND` type. This clause has no effect if an error occurs while evaluating the argument. The *return_value* can be an expression or a bind variable, and it must evaluate to a character string of `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type. It can be in either the SQL format or ISO format, and need not be in the same format as the function argument. If *return_value* cannot be converted to an `INTERVAL` `DAY` `TO` `SECOND` type, then the function returns an error.
## Examples
The following example uses the SQL format to select from the `hr.employees` table the employees who had worked for the company for at least 100 days on November 1, 2002:
```
SELECT employee_id, last_name FROM employees
   WHERE hire_date + TO_DSINTERVAL('100 00:00:00')
<= DATE '2002-11-01'
   ORDER BY employee_id;
EMPLOYEE_ID LAST_NAME
----------- ---------------
        102 De Haan
        203 Mavris
        204 Baer
        205 Higgins
        206 Giet
```
The following example uses the ISO format to display the timestamp 100 days and 5 hours after the beginning of the year 2009:
```
SELECT TO_CHAR(TIMESTAMP '2009-01-01 00:00:00' + TO_DSINTERVAL('P100DT05H'),
   'YYYY-MM-DD HH24:MI:SS') "Time Stamp"
     FROM DUAL;
Time Stamp
-------------------
2009-04-11 05:00:00
```
The following example returns the default value because the specified expression cannot be converted to an `INTERVAL` `DAY` `TO` `SECOND` value:
```
SELECT TO_DSINTERVAL('1o 1:02:10'
       DEFAULT '10 8:00:00' ON CONVERSION ERROR) "Value"
  FROM DUAL;
Value
-----------------------------
+000000010 08:00:00.000000000
```
