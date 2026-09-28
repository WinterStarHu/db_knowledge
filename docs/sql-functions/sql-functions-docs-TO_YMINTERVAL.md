# TO_YMINTERVAL

## Syntax
Description of the illustration to_yminterval.gif Description of the illustration to_yminterval.eps
## *ym_iso_format*::=
Description of the illustration ym_iso_format.gif Description of the illustration ym_iso_format.eps
## Purpose
`TO_YMINTERVAL` converts its argument to a value of `INTERVAL` `MONTH` `TO` `YEAR` data type.
For the argument, you can specify any expression that evaluates to a character string of `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type.
`TO_YMINTERVAL` accepts argument in one of the two formats:
- SQL interval format compatible with the SQL standard (ISO/IEC 9075)
- ISO duration format compatible with the ISO 8601:2004 standard
In the SQL format, *years* is an integer between 0 and 999999999, and *months* is an integer between 0 and 11. Additional blanks are allowed between format elements.
In the ISO format, years and months are integers between 0 and 999999999. Days, *hours*, *minutes*, *seconds*, and frac_secs are non-negative integers, and are ignored, if specified. No blanks are allowed in the value. If you specify `T`, then you must specify at least one of the *hours*, *minutes*, or *seconds* values.
The optional `DEFAULT` *return_value* `ON` `CONVERSION` `ERROR` clause allows you to specify the value this function returns if an error occurs while converting the argument to an `INTERVAL` `MONTH` `TO` `YEAR` type. This clause has no effect if an error occurs while evaluating the argument. The *return_value* can be an expression or a bind variable, and it must evaluate to a character string of `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type. It can be in either the SQL format or ISO format, and need not be in the same format as the function argument. If *return_value* cannot be converted to an `INTERVAL` `MONTH` `TO` `YEAR` type, then the function returns an error.
## Examples
The following example calculates for each employee in the sample `hr.employees` table a date one year two months after the hire date:
```
SELECT hire_date, hire_date + TO_YMINTERVAL('01-02') "14 months"
   FROM employees;
HIRE_DATE 14 months
--------- ---------
17-JUN-03 17-AUG-04
21-SEP-05 21-NOV-06
13-JAN-01 13-MAR-02
20-MAY-08 20-JUL-09
21-MAY-07 21-JUL-08
. . .
```
The following example makes the same calculation using the ISO format:
```
SELECT hire_date, hire_date + TO_YMINTERVAL('P1Y2M') FROM employees;
```
The following example returns the default value because the specified expression cannot be converted to an `INTERVAL` `MONTH` `TO` `YEAR` value:
```
SELECT TO_YMINTERVAL('1x-02'
       DEFAULT '00-00' ON CONVERSION ERROR) "Value"
  FROM DUAL;
Value
-------------
+000000000-00
```
