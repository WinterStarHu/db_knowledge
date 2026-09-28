# LAST_DAY

## Syntax
Description of the illustration last_day.gif Description of the illustration last_day.eps
## Purpose
`LAST_DAY` returns the date of the last day of the month that contains *date*. The last day of the month is defined by the session parameter `NLS_CALENDAR`. The return type is always `DATE`, regardless of the data type of *date*.
## Examples
The following statement determines how many days are left in the current month.
```
SELECT SYSDATE,
       LAST_DAY(SYSDATE) "Last",
       LAST_DAY(SYSDATE) - SYSDATE "Days Left"
  FROM DUAL;
SYSDATE   Last       Days Left
--------- --------- ----------
30-MAY-09 31-MAY-09          1
```
The following example adds `5` months to the hire date of each employee to give an evaluation date:
```
SELECT last_name, hire_date,
       TO_CHAR(ADD_MONTHS(LAST_DAY(hire_date), 5)) "Eval Date"
  FROM employees
  ORDER BY last_name, hire_date;
LAST_NAME                 HIRE_DATE Eval Date
------------------------- --------- ---------
Abel                      11-MAY-04 31-OCT-04
Ande                      24-MAR-08 31-AUG-08
Atkinson                  30-OCT-05 31-MAR-06
Austin                    25-JUN-05 30-NOV-05
Baer                      07-JUN-02 30-NOV-02
Baida                     24-DEC-05 31-MAY-06
Banda                     21-APR-08 30-SEP-08
Bates                     24-MAR-07 31-AUG-07
. . .
```
