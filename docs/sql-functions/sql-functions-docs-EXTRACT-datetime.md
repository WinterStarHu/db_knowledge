# EXTRACT (datetime)

## Syntax
## *extract_datetime*::=
Description of the illustration extract_datetime.gif Description of the illustration extract_datetime.eps
## Purpose
`EXTRACT` extracts and returns the value of a specified datetime field from a datetime or interval expression. The *expr* can be any expression that evaluates to a datetime or interval data type compatible with the requested field:
````**``````````````````````````````
- If YEAR or MONTH is requested, then expr must evaluate to an expression of data type DATE, TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE, or INTERVAL YEAR TO MONTH.
**``````````````````````````````
- If DAY is requested, then expr must evaluate to an expression of data type DATE, TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE, or INTERVAL DAY TO SECOND.
``````**````````````````````````````````
- If HOUR, MINUTE, or SECOND is requested, then expr must evaluate to an expression of data type TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE, or INTERVAL DAY TO SECOND. DATE is not valid here, because Oracle Database treats it as ANSI DATE data type, which has no time fields.
``````````**``````````````````
- If TIMEZONE_HOUR, TIMEZONE_MINUTE, TIMEZONE_ABBR, TIMEZONE_REGION, or TIMEZONE_OFFSET is requested, then expr must evaluate to an expression of data type TIMESTAMP WITH TIME ZONE or TIMESTAMP WITH LOCAL TIME ZONE.
`EXTRACT` interprets *expr* as an ANSI datetime data type. For example, `EXTRACT` treats `DATE` not as legacy Oracle `DATE` but as ANSI `DATE`, without time elements. Therefore, you can extract only `YEAR`, `MONTH`, and `DAY` from a `DATE` value. Likewise, you can extract `TIMEZONE_HOUR` and `TIMEZONE_MINUTE` only from the `TIMESTAMP` `WITH` `TIME` `ZONE` data type.
When you specify `TIMEZONE_REGION` or `TIMEZONE_ABBR` (abbreviation), the value returned is a `VARCHAR2` string containing the appropriate time zone region name or abbreviation. When you specify any of the other datetime fields, the value returned is an integer value of `NUMBER` data type representing the datetime value in the Gregorian calendar. When extracting from a datetime with a time zone value, the value returned is in UTC. For a listing of time zone region names and their corresponding abbreviations, query the `V$TIMEZONE_NAMES` dynamic performance view.
This function can be very useful for manipulating datetime field values in very large tables, as shown in the first example below.
**Note:**    Time zone region names are needed by the daylight saving feature. These names are stored in two types of time zone files: one large and one small. One of these files is the default file, depending on your environment and the release of Oracle Database you are using. For more information regarding time zone files and names, see *Oracle Database Globalization Support Guide*.
Some combinations of datetime field and datetime or interval value expression result in ambiguity. In these cases, Oracle Database returns `UNKNOWN` (see the examples that follow for additional information).
**See Also:**
**
- Oracle Database Globalization Support Guide for a complete listing of the time zone region names in both files
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of EXTRACT
****
- Datetime/Interval Arithmetic for a description of datetime_value_expr and interval_value_expr
**
- Oracle Database Reference for information on the dynamic performance views
## Examples
The following example returns from the `oe.orders` table the number of orders placed in each month:
```
SELECT EXTRACT(month FROM order_date) "Month", COUNT(order_date) "No. of Orders" FROM orders GROUP BY EXTRACT(month FROM order_date) ORDER BY "No. of Orders" DESC, "Month";
Month No. of Orders
---------- -------------
11            15 6            14 7            14 3            11 5            10 2             9 9             9 8             7 10             6 1             5 12             4 4             1 12 rows selected.
```
The following example returns the year 1998.
```
SELECT EXTRACT(YEAR FROM DATE '1998-03-07') FROM DUAL;
EXTRACT(YEARFROMDATE'1998-03-07')
---------------------------------
1998
```
The following example selects from the sample table `hr.employees` all employees who were hired after 2007:
```
SELECT last_name, employee_id, hire_date FROM employees WHERE EXTRACT(YEAR FROM (hire_date, 'DD-MON-RR')) > 2007 ORDER BY hire_date;
LAST_NAME                 EMPLOYEE_ID HIRE_DATE
------------------------- ----------- ---------
Johnson                           179 04-JAN-08 Grant                             199 13-JAN-08 Marvins                           164 24-JAN-08 . . .
```
The following example results in ambiguity, so Oracle returns `UNKNOWN`:
```
SELECT EXTRACT(TIMEZONE_REGION FROM TIMESTAMP '1999-01-01 10:00:00 -08:00') FROM DUAL;
EXTRACT(TIMEZONE_REGIONFROMTIMESTAMP'1999-01-0110:00:00-08:00')
----------------------------------------------------------------
UNKNOWN
```
The ambiguity arises because the time zone numerical offset is provided in the expression, and that numerical offset may map to more than one time zone region name.
