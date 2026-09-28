# CURRENT_TIMESTAMP

## Syntax
Description of the illustration current_timestamp.gif Description of the illustration current_timestamp.eps
## Purpose
`CURRENT_TIMESTAMP` returns the current date and time in the session time zone, in a value of data type `TIMESTAMP` `WITH` `TIME` `ZONE`. The time zone offset reflects the current local time of the SQL session. If you omit precision, then the default is 6. The difference between this function and `LOCALTIMESTAMP` is that `CURRENT_TIMESTAMP` returns a `TIMESTAMP` `WITH` `TIME` `ZONE` value while `LOCALTIMESTAMP` returns a `TIMESTAMP` value.
In the optional argument, *precision* specifies the fractional second precision of the time value returned.
**See Also:**   LOCALTIMESTAMP
## Examples
The following example illustrates that `CURRENT_TIMESTAMP` is sensitive to the session time zone:
```
ALTER SESSION SET TIME_ZONE = '-5:0';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;
SESSIONTIMEZONE CURRENT_TIMESTAMP
--------------- ---------------------------------------------------
-05:00          04-APR-00 01.17.56.917550 PM -05:00
ALTER SESSION SET TIME_ZONE = '-8:0';
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;
SESSIONTIMEZONE CURRENT_TIMESTAMP
--------------- ----------------------------------------------------
-08:00          04-APR-00 10.18.21.366065 AM -08:00
```
When you use the `CURRENT_TIMESTAMP` with a format mask, take care that the format mask matches the value returned by the function. For example, consider the following table:
```
CREATE TABLE current_test (col1 TIMESTAMP WITH TIME ZONE);
```
The following statement fails because the mask does not include the `TIME` `ZONE` portion of the type returned by the function:
```
INSERT INTO current_test VALUES
  (TO_TIMESTAMP_TZ(CURRENT_TIMESTAMP, 'DD-MON-RR HH.MI.SSXFF PM'));
```
The following statement uses the correct format mask to match the return type of `CURRENT_TIMESTAMP`:
```
INSERT INTO current_test VALUES
  (TO_TIMESTAMP_TZ(CURRENT_TIMESTAMP, 'DD-MON-RR HH.MI.SSXFF PM TZH:TZM'));
```
