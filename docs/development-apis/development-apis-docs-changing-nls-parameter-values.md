# Changing NLS Parameter Values

You can change the value of one or more NLS parameters in any of the following ways.
- Change the values for all SQL Developer connections, current and future.
```
% setenv NLS_SORT FRENCH
```
****
- On the client, change the settings of the corresponding NLS environment variables. Only on the client, the new values of the NLS environment variables override the values of the corresponding NLS parameters. You can use environment variables to specify locale-dependent behavior for the client. For example, on a Linux system, this statement sets the value of the NLS_SORT environment variable to FRENCH, overriding the value of the NLS_SORT parameter: Note: Environment variables might be platform-dependent.
```
ALTER SESSION SET parameter_name=parameter_value
  [ parameter_name=parameter_value ]... ;
```
- Change the values only for the current session, using an ALTER SESSION statement with this syntax: Only in the current session, the new values override those set in all of the preceding ways. You can use the ALTER SESSION to test your application with the settings for different locales.
- Change the values only for the current SQL function invocation. Only for the current SQL function invocation, the new values override those set in all of the preceding ways.
**See Also:** **
- Oracle Database SQL Language Reference for more information about the ALTER SESSION statement
**
- Oracle Database Globalization Support Guide for more information about setting NLS parameters
## Changing NLS Parameter Values for All SQL Developer Connections
You can change the values of NLS parameters for all SQL Developer connections, current and future.
**Steps to change National Language Support Parameter values:** ****
- From the SQL Developer menu Tools, select Preferences.
****
- In the Preferences window, in the left frame, expand Database.
****
- In the list of database preferences, click NLS. A list of NLS parameters and their current values appears. The value fields are menus.
- From the menu to the right of each parameter whose value you want to change, select the desired value.
****
- Click OK. The NLS parameters now have the values that you specified. To verify these values, see “Viewing NLS Parameter Values”.
**Note:**   If the NLS parameter values do not reflect your changes, click the icon **Run Report**.
**See Also:**   *Oracle SQL Developer User’s Guide* for more information about SQL Developer preferences
## Changing NLS Parameter Values for the Current SQL Function Invocation
SQL functions whose behavior depends on the values of NLS parameters are called **locale-dependent**. Some locale-dependent SQL functions have optional NLS parameters.
The local-dependent functions that have optional NLS parameters are:
- TO_CHAR
- TO_DATE
- TO_NUMBER
- NLS_UPPER
- NLS_LOWER
- NLS_INITCAP
- NLSSORT
In all of the preceding functions, you can specify these NLS parameters:
- NLS_DATE_LANGUAGE
- NLS_DATE_LANGUAGE
- NLS_NUMERIC_CHARACTERS
- NLS_CURRENCY
- NLS_ISO_CURRENCY
- NLS_DUAL_CURRENCY
- NLS_CALENDAR
- NLS_SORT
In the `NLSSORT` function, you can also specify these NLS parameters:
- NLS_LANGUAGE
- NLS_TERRITORY
- NLS_DATE_FORMAT
To specify NLS parameters in a function, use the following syntax:
```
'parameter=value' ['parameter=value']...
```
Suppose that you want NLS_DATE_LANGUAGE to be `AMERICAN` when this query is evaluated:
```
SELECT last_name FROM employees WHERE hire_date > '01-JAN-1999';
```
You can set NLS_DATE_LANGUAGE to `AMERICAN` before running the query:
```
ALTER SESSION SET NLS_DATE_LANGUAGE=American;
SELECT last_name FROM employees WHERE hire_date > '01-JAN-1999';
```
Alternatively, you can set NLS_DATE_LANGUAGE to `AMERICAN` inside the query, using the locale-dependent SQL function TO_DATE with its optional NLS_DATE_LANGUAGE parameter:
```
SELECT last_name FROM employees
WHERE hire_date > TO_DATE('01-JAN-1999', 'DD-MON-YYYY',
                          'NLS_DATE_LANGUAGE=AMERICAN');
```
**Tip:**    Using session default values for NLS parameters in SQL functions usually results in better performance. Therefore, specify optional NLS parameters in locale-dependent SQL functions only in SQL statements that must not use the default NLS parameter values.
**See Also:**   *Oracle Database Globalization Support Guide* for more information about locale-dependent SQL functions with optional NLS parameters
