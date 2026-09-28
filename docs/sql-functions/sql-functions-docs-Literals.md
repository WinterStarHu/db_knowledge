# Literals

The terms **literal** and **constant value** are synonymous and refer to a fixed data value. For example, ‘JACK’, ‘BLUE ISLAND’, and ‘101’ are all character literals; 5001 is a numeric literal. Character literals are enclosed in single quotation marks so that Oracle can distinguish them from schema object names.
This section contains these topics:
- Text Literals
- Numeric Literals
- Datetime Literals
- Interval Literals
Many SQL statements and functions require you to specify character and numeric literal values. You can also specify literals as part of expressions and conditions. You can specify character literals with the ‘*text*’ notation, national character literals with the *N’text’* notation, and numeric literals with the *integer*, or *number* notation, depending on the context of the literal. The syntactic forms of these notations appear in the sections that follow.
To specify a datetime or interval data type as a literal, you must take into account any optional precisions included in the data types. Examples of specifying datetime and interval data types as literals are provided in the relevant sections of Data Types.
## Text Literals
Use the text literal notation to specify values whenever *string* appears in the syntax of expressions, conditions, SQL functions, and SQL statements in other parts of this reference. This reference uses the terms**text literal**, **character literal**, and **string** interchangeably. Text, character, and string literals are always surrounded by single quotation marks. If the syntax uses the term *char*, then you can specify either a text literal or another expression that resolves to character data - for example, the `last_name` column of the `hr.employees` table. When *char* appears in the syntax, the single quotation marks are not used.
The syntax of text literals or strings follows:
***string*::=** Description of the illustration string.gif Description of the illustration string.eps where `N` or `n` specifies the literal using the national character set (`NCHAR` or `NVARCHAR2` data). By default, text entered using this notation is translated into the national character set by way of the database character set when used by the server. To avoid potential loss of data during the text literal conversion to the database character set, set the environment variable `ORA_NCHAR_LITERAL_REPLACE` to `TRUE`. Doing so transparently replaces the `n'` internally and preserves the text literal for SQL processing.
**See Also:**   *Oracle Database Globalization Support Guide* for more information about N-quoted literals In the top branch of the syntax:
**
- cis any member of the user’s character set. A single quotation mark (‘) within the literal must be preceded by an escape character. To represent one single quotation mark within a literal, enter two single quotation marks.
- ’ ‘ are two single quotation marks that begin and end text literals.
In the bottom branch of the syntax:
````
- Q or q indicates that the alternative quoting mechanism will be used. This mechanism allows a wide range of delimiters for the text string.
````**
- The outermost ' ' are two single quotation marks that precede and follow, respectively, the opening and closing quote_delimiter.
****
- c is any member of the user’s character set. You can include quotation marks (“) in the text literal made up of c characters. You can also include the quote_delimiter, as long as it is not immediately followed by a single quotation mark.
****** **````````**````````**
- quote_delimiter is any singleor multibyte character except space, tab, and return. The quote_delimiter can be a single quotation mark. However, if the quote_delimiter appears in the text literal itself, ensure that it is not immediately followed by a single quotation mark. If the opening quote_delimiter is one of [, {, , or ). In all other cases, the opening and closing quote_delimiter must be the same character.
Text literals have properties of both the `CHAR` and `VARCHAR2` data types:
- Within expressions and conditions, Oracle treats text literals as though they have the data type CHAR by comparing them using blank-padded comparison semantics.
````````````
- A text literal can have a maximum length of 4000 bytes if the initialization parameter MAX_STRING_SIZE = STANDARD, and 32767 bytes if MAX_STRING_SIZE = EXTENDED. See Extended Data Types for more information.
Here are some valid text literals:
```
'Hello' 'ORACLE.dbs' 'Jackie''s raincoat' '09-MAR-98' N'nchar literal'
```
Here are some valid text literals using the alternative quoting mechanism:
```
q'!name LIKE '%DBMS_%%'!' q'' q'{SELECT * FROM employees WHERE last_name = 'Smith';}' nq'ï Ÿ1234 ï' q'"name like '['"'
```
**See Also:**   Blank-Padded and Nonpadded Comparison Semantics
## Numeric Literals
Use numeric literal notation to specify fixed and floating-point numbers.
### Integer Literals
You must use the integer notation to specify an integer whenever *integer* appears in expressions, conditions, SQL functions, and SQL statements described in other parts of this reference.
The syntax of *integer* follows:
***integer*::=**
Description of the illustration integer.gif
Description of the illustration integer.eps
where *digit* is one of 0, 1, 2, 3, 4, 5, 6, 7, 8, 9.
An integer can store a maximum of 38 digits of precision.
Here are some valid integers:
```
7 +255
```
### NUMBER and Floating-Point Literals
You must use the number or floating-point notation to specify values whenever *number* or *n* appears in expressions, conditions, SQL functions, and SQL statements in other parts of this reference.
The syntax of *number* follows:
***number*::=**
Description of the illustration number.gif
Description of the illustration number.eps
where
    - or - indicates a positive or negative value. If you omit the sign, then a positive value is the default.
**
- digit is one of 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9.
- e or E indicates that the number is specified in scientific notation. The digits after the E specify the exponent. The exponent can range from -130 to 125.
- f or F indicates that the number is a 32-bit binary floating point number of type BINARY_FLOAT.
````````
- d or D indicates that the number is a 64-bit binary floating point number of type BINARY_DOUBLE. If you omit f or F and d or D, then the number is of type NUMBER. The suffixes f (F) and d (D) are supported only in floating-point number literals, not in character strings that are to be converted to NUMBER. For example, if Oracle is expecting a NUMBER and it encounters the string '9', then it converts the string to the number 9. However, if Oracle encounters the string '9f', then conversion fails and an error is returned.
A number of type `NUMBER` can store a maximum of 38 digits of precision. If the literal requires more precision than provided by `NUMBER`, `BINARY_FLOAT`, or `BINARY_DOUBLE`, then Oracle truncates the value. If the range of the literal exceeds the range supported by `NUMBER`, `BINARY_FLOAT`, or `BINARY_DOUBLE`, then Oracle raises an error.
Numeric literals are SQL syntax elements, which are not sensitive to NLS settings. The decimal separator character in numeric literals is always the period (.). However, if a text literal is specified where a numeric value is expected, then the text literal is implicitly converted to a number in an NLS-sensitive way. The decimal separator contained in the text literal must be the one established with the initialization parameter `NLS_NUMERIC_CHARACTERS`. Oracle recommends that you use numeric literals in SQL scripts to make them work independently of the NLS environment.
The following examples illustrate the behavior of decimal separators in numeric literals and text literals. These examples assume that you have established the comma (,) as the NLS decimal separator for the current session with the following statement:
```
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=',.';
```
The previous statement also establishes the period (.) as the NLS group separator, but that is irrelevant for these examples.
This example uses the required decimal separator (.) in the numeric literal `1.23` and the established NLS decimal separator (,) in the text literal ‘`2,34`’. The text literal is converted to the numeric value 2.34, and the output is displayed using commas for the decimal separators.
```
SELECT 2 * 1.23, 3 * '2,34' FROM DUAL;
    2*1.23   3*'2,34'
---------- ----------
      2,46       7,02
```
The next example shows that a comma is not treated as part of a numeric literal. Rather, the comma is treated as the delimiter in a list of two numeric expressions: `2*1` and `23`.
```
SELECT 2 * 1,23 FROM DUAL;
       2*1         23
---------- ----------
         2         23
```
The next example shows that the decimal separator in a text literal must match the NLS decimal separator in order for implicit text-to-number conversion to succeed. The following statement fails because the decimal separator (.) does not match the established NLS decimal separator (,):
```
SELECT 3 * '2.34' FROM DUAL;
           *
ERROR at line 1:
ORA-01722: invalid number
```
**See Also:**   ALTER SESSION and *Oracle Database Reference* Here are some valid `NUMBER` literals:
```
25
+6.34
0.5
25e-03
-1
```
Here are some valid floating-point number literals:
```
25f
+6.34F
0.5d
-1D
```
You can also use the following supplied floating-point literals in situations where a value cannot be expressed as a numeric literal:
Table 11 Floating-Point Literals

| Literal | Meaning | Example |
|---|---|---|
| binary_float_nan | A value of type BINARY_FLOAT for which the condition IS NAN is true | SELECT COUNT(*) FROM employees WHERE TO_BINARY_FLOAT(commission_pct) != BINARY_FLOAT_NAN; |
| binary_float_infinity | Single-precision positive infinity | SELECT COUNT(*) FROM employees WHERE salary < BINARY_FLOAT_INFINITY; |
| binary_double_nan | A value of type BINARY_DOUBLE for which the condition IS NAN is true | SELECT COUNT(*) FROM employees WHERE TO_BINARY_FLOAT(commission_pct) != BINARY_FLOAT_NAN; |
| binary_double_infinity | Double-precision positive infinity | SELECT COUNT(*) FROM employees WHERE salary < BINARY_DOUBLE_INFINITY; |

## Datetime Literals
Oracle Database supports four datetime data types: `DATE`, `TIMESTAMP`, `TIMESTAMP` `WITH` `TIME` `ZONE`, and `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`.
**Date Literals** You can specify a `DATE` value as a string literal, or you can convert a character or numeric value to a date value with the `TO_DATE` function. `DATE` literals are the only case in which Oracle Database accepts a `TO_DATE` expression in place of a string literal.
To specify a `DATE` value as a literal, you must use the Gregorian calendar. You can specify an ANSI literal, as shown in this example:
```
DATE '1998-12-25'
```
The ANSI date literal contains no time portion, and must be specified in the format ‘`YYYY-MM-DD`’. Alternatively you can specify an Oracle date value, as in the following example:
```
TO_DATE('98-DEC-25 17:30','YY-MON-DD HH24:MI')
```
The default date format for an Oracle `DATE` value is specified by the initialization parameter `NLS_DATE_FORMAT`. This example date format includes a two-digit number for the day of the month, an abbreviation of the month name, the last two digits of the year, and a 24-hour time designation.
Oracle automatically converts character values that are in the default date format into date values when they are used in date expressions.
If you specify a date value without a time component, then the default time is midnight (00:00:00 or 12:00:00 for 24-hour and 12-hour clock time, respectively). If you specify a date value without a date, then the default date is the first day of the current month.
Oracle `DATE` columns always contain both the date and time fields. Therefore, if you query a `DATE` column, then you must either specify the time field in your query or ensure that the time fields in the `DATE` column are set to midnight. Otherwise, Oracle may not return the query results you expect. You can use the `TRUNC` date function to set the time field to midnight, or you can include a greater-than or less-than condition in the query instead of an equality or inequality condition.
Here are some examples that assume a table `my_table` with a number column `row_num` and a `DATE` column `datecol`:
```
INSERT INTO my_table VALUES (1, SYSDATE);
INSERT INTO my_table VALUES (2, TRUNC(SYSDATE));
SELECT *
  FROM my_table;
   ROW_NUM DATECOL
---------- ---------
         1 03-OCT-02
         2 03-OCT-02
SELECT *
  FROM my_table
  WHERE datecol > TO_DATE('02-OCT-02', 'DD-MON-YY');
   ROW_NUM DATECOL
---------- ---------
         1 03-OCT-02
         2 03-OCT-02
SELECT *
  FROM my_table
  WHERE datecol = TO_DATE('03-OCT-02','DD-MON-YY');
   ROW_NUM DATECOL
---------- ---------
         2 03-OCT-02
```
If you know that the time fields of your `DATE` column are set to midnight, then you can query your `DATE` column as shown in the immediately preceding example, or by using the `DATE` literal:
```
SELECT *
  FROM my_table
  WHERE datecol = DATE '2002-10-03';
   ROW_NUM DATECOL
---------- ---------
         2 03-OCT-02
```
However, if the `DATE` column contains values other than midnight, then you must filter out the time fields in the query to get the correct result. For example:
```
SELECT *
  FROM my_table
  WHERE TRUNC(datecol) = DATE '2002-10-03';
   ROW_NUM DATECOL
---------- ---------
         1 03-OCT-02
         2 03-OCT-02
```
Oracle applies the `TRUNC` function to each row in the query, so performance is better if you ensure the midnight value of the time fields in your data. To ensure that the time fields are set to midnight, use one of the following methods during inserts and updates:
  - Use the TO_DATE function to mask out the time fields:
```
INSERT INTO my_table
  VALUES (3, TO_DATE('3-OCT-2002','DD-MON-YYYY'));
```
  - Use the DATE literal:
```
INSERT INTO my_table
  VALUES (4, '03-OCT-02');
```
  - Use the TRUNC function:
```
INSERT INTO my_table
  VALUES (5, TRUNC(SYSDATE));
```
The date function `SYSDATE` returns the current system date and time. The function `CURRENT_DATE` returns the current session date. For information on `SYSDATE`, the `TO_*` datetime functions, and the default date format, see Datetime Functions.
**TIMESTAMP Literals** The `TIMESTAMP` data type stores year, month, day, hour, minute, and second, and fractional second values. When you specify `TIMESTAMP` as a literal, the *fractional_seconds_precision* value can be any number of digits up to 9, as follows:
```
TIMESTAMP '1997-01-31 09:26:50.124'
```
**TIMESTAMP WITH TIME ZONE Literals** The `TIMESTAMP` `WITH` `TIME` `ZONE` data type is a variant of `TIMESTAMP` that includes a time zone region name or time zone offset. When you specify `TIMESTAMP` `WITH` `TIME` `ZONE` as a literal, the *fractional_seconds_precision* value can be any number of digits up to 9. For example:
```
TIMESTAMP '1997-01-31 09:26:56.66 +02:00'
```
Two `TIMESTAMP` `WITH` `TIME` `ZONE` values are considered identical if they represent the same instant in UTC, regardless of the `TIME` `ZONE` offsets stored in the data. For example,
```
TIMESTAMP '1999-04-15 8:00:00 -8:00'
```
is the same as
```
TIMESTAMP '1999-04-15 11:00:00 -5:00'
```
8:00 a.m. Pacific Standard Time is the same as 11:00 a.m. Eastern Standard Time.
You can replace the UTC offset with the `TZR` (time zone region name) format element. For example, the following example has the same value as the preceding example:
```
TIMESTAMP '1999-04-15 8:00:00 US/Pacific'
```
To eliminate the ambiguity of boundary cases when the daylight saving time switches, use both the `TZR` and a corresponding `TZD` format element. The following example ensures that the preceding example will return a daylight saving time value:
```
TIMESTAMP '1999-10-29 01:30:00 US/Pacific PDT'
```
You can also express the time zone offset using a datetime expression:
```
SELECT TIMESTAMP '2009-10-29 01:30:00' AT TIME ZONE 'US/Pacific'
  FROM DUAL;
```
**See Also:**   Datetime Expressions for more information If you do not add the `TZD` format element, and the datetime value is ambiguous, then Oracle returns an error if you have the `ERROR_ON_OVERLAP_TIME` session parameter set to `TRUE`. If that parameter is set to `FALSE`, then Oracle interprets the ambiguous datetime as standard time in the specified region.
**TIMESTAMP WITH LOCAL TIME ZONE Literals** The `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE` data type differs from `TIMESTAMP` `WITH` `TIME` `ZONE` in that data stored in the database is normalized to the database time zone. The time zone offset is not stored as part of the column data. There is no literal for `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`. Rather, you represent values of this data type using any of the other valid datetime literals. The table that follows shows some of the formats you can use to insert a value into a `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE` column, along with the corresponding value returned by a query.
Table 12 TIMESTAMP WITH LOCAL TIME ZONE Literals

| Value Specified in INSERT Statement | Value Returned by Query |
|---|---|
| '19-FEB-2004' | 19-FEB-2004.00.00.000000 AM |
| SYSTIMESTAMP | 19-FEB-04 02.54.36.497659 PM |
| TO_TIMESTAMP('19-FEB-2004', 'DD-MON-YYYY') | 19-FEB-04 12.00.00.000000 AM |
| SYSDATE | 19-FEB-04 02.55.29.000000 PM |
| TO_DATE('19-FEB-2004', 'DD-MON-YYYY') | 19-FEB-04 12.00.00.000000 AM |
| TIMESTAMP'2004-02-19 8:00:00 US/Pacific' | 19-FEB-04 08.00.00.000000 AM |

Notice that if the value specified does not include a time component (either explicitly or implicitly), then the value returned defaults to midnight.
## Interval Literals
An interval literal specifies a period of time. You can specify these differences in terms of years and months, or in terms of days, hours, minutes, and seconds. Oracle Database supports two types of interval literals, `YEAR` `TO` `MONTH` and `DAY` `TO` `SECOND`. Each type contains a leading field and may contain a trailing field. The leading field defines the basic unit of date or time being measured. The trailing field defines the smallest increment of the basic unit being considered. For example, a `YEAR` `TO` `MONTH` interval considers an interval of years to the nearest month. A `DAY` `TO` `MINUTE` interval considers an interval of days to the nearest minute.
If you have date data in numeric form, then you can use the `NUMTOYMINTERVAL` or `NUMTODSINTERVAL` conversion function to convert the numeric data into interval values.
Interval literals are used primarily with analytic functions.
**See Also:**   Analytic Functions, NUMTODSINTERVAL, and NUMTOYMINTERVAL
### INTERVAL YEAR TO MONTH
Specify `YEAR` `TO` `MONTH` interval literals using the following syntax:
***interval_year_to_month*::=** Description of the illustration interval_year_to_month.gif Description of the illustration interval_year_to_month.eps where **````
- ‘integer [-integer]’ specifies integer values for the leading and optional trailing field of the literal. If the leading field is YEAR and the trailing field is MONTH, then the range of integer values for the month field is 0 to 11.
**
- precision is the maximum number of digits in the leading field. The valid range of the leading field precision is 0 to 9 and its default value is 2.
**Restriction on the Leading Field** If you specify a trailing field, then it must be less significant than the leading field. For example, `INTERVAL` ‘`0-1`’ `MONTH` `TO` `YEAR` is not valid.
The following `INTERVAL` `YEAR` `TO` `MONTH` literal indicates an interval of 123 years, 2 months:
```
INTERVAL '123-2' YEAR(3) TO MONTH
```
Examples of the other forms of the literal follow, including some abbreviated versions:
Table 13 Forms of INTERVAL YEAR TO MONTH Literals

| Form of Interval Literal | Interpretation |
|---|---|
| INTERVAL '123-2' YEAR(3) TO MONTH | An interval of 123 years, 2 months. You must specify the leading field precision if it is greater than the default of 2 digits. |
| INTERVAL '123' YEAR(3) | An interval of 123 years 0 months. |
| INTERVAL '300' MONTH(3) | An interval of 300 months. |
| INTERVAL '4' YEAR | Maps to INTERVAL '4-0' YEAR TO MONTH and indicates 4 years. |
| INTERVAL '50' MONTH | Maps to INTERVAL '4-2' YEAR TO MONTH and indicates 50 months or 4 years 2 months. |
| INTERVAL '123' YEAR | Returns an error, because the default precision is 2, and ‘123’ has 3 digits. |

You can add or subtract one `INTERVAL` `YEAR` `TO` `MONTH` literal to or from another to yield another `INTERVAL` `YEAR` `TO` `MONTH` literal. For example:
```
INTERVAL '5-3' YEAR TO MONTH + INTERVAL'20' MONTH =
INTERVAL '6-11' YEAR TO MONTH
```
### INTERVAL DAY TO SECOND
Specify `DAY` `TO` `SECOND` interval literals using the following syntax:
***interval_day_to_second*::=** Description of the illustration interval_day_to_second.gif Description of the illustration interval_day_to_second.eps where **
- integer specifies the number of days. If this value contains more digits than the number specified by the leading precision, then Oracle returns an error.
********************************
- time_expr specifies a time in the format HH[:MI[:SS[.n]]] or MI[:SS[.n]] or SS[.n], where n specifies the fractional part of a second. If n contains more digits than the number specified by fractional_seconds_precision, then n is rounded to the number of digits specified by the fractional_seconds_precision value. You can specify time_expr following an integer and a space only if the leading field is DAY.
**
- leading_precision is the number of digits in the leading field. Accepted values are 0 to 9. The default is 2.
**
- fractional_seconds_precision is the number of digits in the fractional part of the SECOND datetime field. Accepted values are 1 to 9. The default is 6.
**Restriction on the Leading Field:** If you specify a trailing field, then it must be less significant than the leading field. For example, `INTERVAL` `MINUTE` `TO` `DAY` is not valid. As a result of this restriction, if `SECOND` is the leading field, the interval literal cannot have any trailing field.
The valid range of values for the trailing field are as follows:
- HOUR: 0 to 23
- MINUTE: 0 to 59
- SECOND: 0 to 59.999999999
Examples of the various forms of `INTERVAL` `DAY` `TO` `SECOND` literals follow, including some abbreviated versions:
Table 14 Forms of INTERVAL DAY TO SECOND Literals

| Form of Interval Literal | Interpretation |
|---|---|
| INTERVAL '4 5:12:10.222' DAY TO SECOND(3) | 4 days, 5 hours, 12 minutes, 10 seconds, and 222 thousandths of a second. |
| INTERVAL '4 5:12' DAY TO MINUTE | 4 days, 5 hours and 12 minutes. |
| INTERVAL '400 5' DAY(3) TO HOUR | 400 days 5 hours. |
| INTERVAL '400' DAY(3) | 400 days. |
| INTERVAL '11:12:10.2222222' HOUR TO SECOND(7) | 11 hours, 12 minutes, and 10.2222222 seconds. |
| INTERVAL '11:20' HOUR TO MINUTE | 11 hours and 20 minutes. |
| INTERVAL '10' HOUR | 10 hours. |
| INTERVAL '10:22' MINUTE TO SECOND | 10 minutes 22 seconds. |
| INTERVAL '10' MINUTE | 10 minutes. |
| INTERVAL '4' DAY | 4 days. |
| INTERVAL '25' HOUR | 25 hours. |
| INTERVAL '40' MINUTE | 40 minutes. |
| INTERVAL '120' HOUR(3) | 120 hours. |
| INTERVAL '30.12345' SECOND(2,4) | 30.1235 seconds. The fractional second ‘12345’ is rounded to ‘1235’ because the precision is 4. |

You can add or subtract one `DAY` `TO` `SECOND` interval literal from another `DAY` `TO` `SECOND` literal. For example.
```
INTERVAL'20' DAY - INTERVAL'240' HOUR = INTERVAL'10-0' DAY TO SECOND
```
