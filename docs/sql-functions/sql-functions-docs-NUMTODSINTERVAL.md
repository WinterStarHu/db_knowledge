# NUMTODSINTERVAL

## Syntax
Description of the illustration numtodsinterval.gif Description of the illustration numtodsinterval.eps
## Purpose
`NUMTODSINTERVAL` converts *n* to an `INTERVAL` `DAY` `TO` `SECOND` literal. The argument *n* can be any `NUMBER` value or an expression that can be implicitly converted to a `NUMBER` value. The argument *interval_unit* can be of `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type. The value for *interval_unit* specifies the unit of *n* and must resolve to one of the following string values:
- ‘DAY’
- ‘HOUR’
- ‘MINUTE’
- ‘SECOND’
*interval_unit* is case insensitive. Leading and trailing values within the parentheses are ignored. By default, the precision of the return is 9.
**See Also:**   Table 2-8 for more information on implicit conversion
## Examples
The following example uses `NUMTODSINTERVAL` in a `COUNT` analytic function to calculate, for each employee, the number of employees hired by the same manager within the past 100 days from his or her hire date. Refer to “Analytic Functions” for more information on the syntax of the analytic functions.
```
SELECT manager_id, last_name, hire_date,
       COUNT(*) OVER (PARTITION BY manager_id ORDER BY hire_date
       RANGE NUMTODSINTERVAL(100, 'day') PRECEDING) AS t_count
  FROM employees
  ORDER BY last_name, hire_date;
MANAGER_ID LAST_NAME                 HIRE_DATE    T_COUNT
---------- ------------------------- --------- ----------
       149 Abel                      11-MAY-04          1
       147 Ande                      24-MAR-08          3
       121 Atkinson                  30-OCT-05          2
       103 Austin                    25-JUN-05          1
. . .
       124 Walsh                     24-APR-06          2
       100 Weiss                     18-JUL-04          1
       101 Whalen                    17-SEP-03          1
       100 Zlotkey                   29-JAN-08          2
```
