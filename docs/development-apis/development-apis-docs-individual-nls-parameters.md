# About Individual NLS Parameters

Many individual NLS parameters are available.
**See Also:** **
- Oracle Database Globalization Support Guide for more information about setting up a globalization support environment
- “Changing NLS Parameter Values”
## About Locale and the NLS_LANG Parameter
A **locale** is a linguistic and cultural environment in which a system or application runs. The simplest way to specify a locale for Oracle Database software is to set the NLS_LANG parameter.
The NLS_LANG parameter sets the default values of the parameters NLS_LANGUAGE and NLS_TERRITORY for both the server session (for example, SQL statement processing) and the client application (for example, display formatting in Oracle Database tools). The NLS_LANG parameter also sets the character set that the client application uses for data entered or displayed.
The default value of NLS_LANG is set during database installation. You can use the ALTER SESSION statement to change the values of NLS parameters, including those set by NLS_LANG, for your session. However, only the client can change the NLS settings in the client environment.
**See Also:** **
- Oracle Database Globalization Support Guide for more information about specifying a locale with the NLS_LANG parameter
**
- Oracle Database Globalization Support Guide for information about languages, territories, character sets, and other locale data supported by Oracle Database
- “About the NLS_LANGUAGE Parameter”
- “About the NLS_TERRITORY Parameter”
- “Changing NLS Parameter Values”
## About the NLS_LANGUAGE Parameter
This parameter specifies the default language of the database.
**Specifies:** Default language of the database. Default conventions for:
- Language for server messages
- Language for names and abbreviations of days and months that are specified in the SQL functions TO_CHAR and TO_DATE
- Symbols for default-language equivalents of AM, PM, AD, and BC
- Default sorting order for character data when the ORDER BY clause is specified
- Writing direction
- Affirmative and negative response strings (for example, YES and NO)
**Acceptable Values:** Any language name that Oracle supports. For a list, see *Oracle Database Globalization Support Guide*.
**Default Value:** Set by NLS_LANG, described in “About Locale and the NLS_LANG Parameter”.
**Sets default values of:**
- NLS_DATE_LANGUAGE, described in “About the NLS_DATE_LANGUAGE Parameter”.
- NLS_SORT, described in “About the NLS_SORT Parameter”.
Example 7-1 shows how setting NLS_LANGUAGE to `ITALIAN` and `GERMAN` affects server messages and month abbreviations.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-1 NLS_LANGUAGE Affects Server Message and Month Abbreviations**
- Note the current value of NLS_LANGUAGE.
```
 ALTER SESSION SET NLS_LANGUAGE=ITALIAN;
```
- If the value in step 1 is not ITALIAN, change it:
```
 SELECT * FROM nonexistent_table;
```
```
 SELECT * FROM nonexistent_table
             *
 ERROR at line 1:
 ORA-00942: tabella o vista inesistente
```
- Query a nonexistent table: Result:
```
 SELECT LAST_NAME, HIRE_DATE
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID IN (111, 112, 113);
```
```
 LAST_NAME                 HIRE_DATE
 ------------------------- ---------
 Sciarra                   30-SET-97
 Urman                     07-MAR-98
 Popp                      07-DIC-99
 3 rows selected.
```
- Run the following query: Result:
```
 ALTER SESSION SET NLS_LANGUAGE=GERMAN;
```
- Change the value of NLS_LANGUAGE to GERMAN:
```
 SELECT * FROM nonexistent_table
             *
 ERROR at line 1:
 ORA-00942: Tabelle oder View nicht vorhanden
```
- Repeat the query from step 3. Result:
```
 LAST_NAME                 HIRE_DATE
 ------------------------- ---------
 Sciarra                   30-SEP-97
 Urman                     07-MRZ-98
 Popp                      07-DEZ-99
 3 rows selected.
```
- Repeat the query from step 4. Result:
  - Set NLS_LANGUAGE to the value that it had at step 1.
**See Also:** **
- Oracle Database Globalization Support Guide for more information about the NLS_LANGUAGE parameter
- “About Language Support”
- “Changing NLS Parameter Values”
## About the NLS_TERRITORY Parameter
This parameter specifies default conventions for date format, time stamp format, decimal and group separator, local currency symbol, ISO currency symbol, and dual currency symbol.
**Specifies:** Default conventions for:
- Date format
- Time stamp format
- Decimal character and group separator
- Local currency symbol
- ISO currency symbol
- Dual currency symbol
**Acceptable Values:** Any territory name that Oracle supports. For a list, see *Oracle Database Globalization Support Guide*.
**Default Value:** Set by NLS_LANG, described in “About Locale and the NLS_LANG Parameter”.
**Sets default values of:**
- NLS_DATE_FORMAT, described in “About the NLS_DATE_FORMAT Parameter”.
- NLS_TIMESTAMP_FORMAT and NLS_TIMESTAMP_TZ_FORMAT, described in “About NLS_TIMESTAMP_FORMAT and NLS_TIMESTAMP_TZ_FORMAT Parameters”.
- NLS_NUMERIC_CHARACTERS, described in “About the NLS_NUMERIC_CHARACTERS Parameter”.
- NLS_CURRENCY, described in “About the NLS_CURRENCY Parameter”.
- NLS_ISO_CURRENCY, described in “About the NLS_ISO_CURRENCY Parameter”.
- NLS_DUAL_CURRENCY, described in “About the NLS_DUAL_CURRENCY Parameter”.
Example 7-2 shows how setting NLS_TERRITORY to `JAPAN` and `AMERICA` affects the currency symbol.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-2 NLS_TERRITORY Affects Currency Symbol**
- Note the current value of NLS_TERRITORY.
```
 ALTER SESSION SET NLS_TERRITORY=JAPAN;
```
- If the value in step 1 is not JAPAN, change it:
```
 SELECT TO_CHAR(SALARY,'L99G999D99') SALARY
 FROM EMPLOYEES
 WHERE EMPLOYEE_ID IN (100, 101, 102);
```
```
 SALARY
 --------------------
         ©24,000.00
         ©17,000.00
         ©17,000.00
 3 rows selected.
```
- Run the following query: Result:
````
```
ALTER SESSION SET NLS_TERRITORY=AMERICA;
```
- Change the value of NLS_TERRITORY to AMERICA:
```
SALARY
 --------------------
$24,000.00 $17,000.00 $17,000.00 3 rows selected.
```
- Repeat the query from step 3. Result:
  - Set NLS_TERRITORY to the value that it had at step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_TERRITORY parameter
- “About Territory Support”
- “Changing NLS Parameter Values”
## About the NLS_DATE_FORMAT Parameter
This parameter specifies the default date format to use with the TO_CHAR and TO_DATE functions.
**Specifies:** Default date format to use with the TO_CHAR and TO_DATE functions (which are introduced in “Using Conversion Functions in Queries”).
**Acceptable Values:** Any any valid datetime format model. For example:
```
NLS_DATE_FORMAT='MM/DD/YYYY'
```
For information about datetime format models, see *Oracle Database SQL Language Reference*.
**Default Value:** Set by NLS_TERRITORY, described in “About the NLS_TERRITORY Parameter”.
The default date format might not correspond to the convention used in a given territory. To get dates in localized formats, you can use the ‘DS’ (short date) and ‘DL’ (long date) formats.
Example 7-3 shows how setting NLS_TERRITORY to `AMERICA` and `FRANCE` affects the default, short, and long date formats.
Example 7-4 changes the value of NLS_DATE_FORMAT, overriding the default value set by NLS_TERRITORY.
To try the examples in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
Example 7-3 NLS_TERRITORY Affects Date Formats
- Note the current value of NLS_TERRITORY.
```
ALTER SESSION SET NLS_TERRITORY=AMERICA;
```
- If the value in step 1 is not AMERICA, change it:
```
SELECT hire_date "Default", TO_CHAR(hire_date,'DS') "Short", TO_CHAR(hire_date,'DL') "Long" FROM employees WHERE employee_id IN (111, 112, 113);
```
```
Default    Short      Long
 --------- ---------- -----------------------------
30-SEP-05 9/30/2005  Friday, September 30, 2005 07-MAR-98 3/7/2006   Tuesday, March 07, 2006 07-DEC-99 12/7/2007  Friday, December 07, 2007 3 rows selected.
```
- Run the following query: Result:
```
ALTER SESSION SET NLS_TERRITORY=FRANCE;
```
- Change the value of NLS_TERRITORY to FRANCE:
```
Default  Short      Long
 -------- ---------- ---------------------------
30/09/05 30/09/2005 friday 30 september 2005 07/03/06 07/03/2006 tuesday 7 march 2006 07/12/07 07/12/2007 friday 7 december 2007 3 rows selected.
```
- Repeat the query from step 3. Result: (To get the names of the days and months in French, you must set either NLS_LANGUAGE or NLS_DATE_LANGUAGE to FRENCH before running the query.)
  - Set NLS_TERRITORY to the value that it had at step 1.
**Example 7-4 NLS_DATE_FORMAT Overrides NLS_TERRITORY**
- Note the current values of NLS_TERRITORY and NLS_DATE_FORMAT.
```
ALTER SESSION SET NLS_TERRITORY=AMERICA;
```
- If the value of NLS_TERRITORY in step 1 is not AMERICA, change it:
```
ALTER SESSION SET NLS_DATE_FORMAT='Day Month ddth';
```
- If the value of NLS_DATE_FORMAT in step 1 is not 'Day Month ddth', change it:
```
SELECT hire_date "Default", TO_CHAR(hire_date,'DS') "Short", TO_CHAR(hire_date,'DL') "Long" FROM employees WHERE employee_id IN (111, 112, 113);
```
```
Default                  Short      Long
 ------------------------ ---------- -----------------------------
Friday    September 30th 9/30/2005  Tuesday, September 30, 2005 Tuesday   March     07th 3/7/2006   Saturday, March 07, 2006 Friday    December  07th 12/7/2007  Tuesday, December 07, 2007 3 rows selected.
```
- Run this query (from previous example, step 3): Result:
  - Set NLS_TERRITORY and NLS_DATE_FORMAT to the values that they had at step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_DATE_FORMAT parameter
**
- Oracle Database SQL Language Reference for more information about the TO_CHAR function
**
- Oracle Database SQL Language Reference for more information about the TO_DATE function
- “About Date and Time Formats”
- “Changing NLS Parameter Values”
## About the NLS_DATE_LANGUAGE Parameter
This parameter specifies the language for names and abbreviations of days and months that are produced by: SQL functions TO_CHAR and TO_DATE, the default date format (set by NLS_DATE_FORMAT), and symbols for the default-language equivalents of AM, PM, AD, and BC.
**Specifies:** Language for names and abbreviations of days and months that are produced by:
- SQL functions TO_CHAR and TO_DATE (which are introduced in “Using Conversion Functions in Queries”)
- Default date format (set by NLS_DATE_FORMAT, described in “About the NLS_DATE_FORMAT Parameter”)
- Symbols for default-language equivalents of AM, PM, AD, and BC
**Acceptable Values:** Any language name that Oracle supports. For a list, see *Oracle Database Globalization Support Guide*.
**Default Value:** Set by NLS_LANGUAGE, described in “About the NLS_LANGUAGE Parameter”.
Example 7-5 shows how setting NLS_DATE_LANGUAGE to `FRENCH` and `SWEDISH` affects the displayed system date.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-5 NLS_DATE_LANGUAGE Affects Displayed SYSDATE**
- Note the current value of NLS_DATE_LANGUAGE.
```
ALTER SESSION SET NLS_DATE_LANGUAGE=FRENCH;
```
- If the value of NLS_DATE_LANGUAGE in step 1 is not FRENCH, change it:
```
SELECT TO_CHAR(SYSDATE, 'Day:Dd Month yyyy') "System Date" FROM DUAL;
```
```
System Date
 --------------------------
Vendredi:28 December   2012
```
- Run this query: Result:
```
ALTER SESSION SET NLS_DATE_LANGUAGE=SWEDISH;
```
- Change the value of NLS_DATE_LANGUAGE to SWEDISH:
```
System Date
 -------------------------
Fredag :28 December   2012
```
- Repeat the query from step 3. Result:
  - Set NLS_DATE_LANGUAGE to the value that it had at step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_DATE_LANGUAGE parameter
**
- Oracle Database SQL Language Reference for more information about the TO_CHAR function
**
- Oracle Database SQL Language Reference for more information about the y function
- “About Date and Time Formats”
- “Changing NLS Parameter Values”
## About NLS_TIMESTAMP_FORMAT and NLS_TIMESTAMP_TZ_FORMAT Parameters
This parameter specifies the default date format for the TIMESTAMP audiotape and TIMESTAMP WITH LOCAL TIME ZONEaudiotapeTIMESTAMP WITH LOCAL TIME ZONEaudiotape.
**Specify:** Default date format for:
- TIMESTAMP audiotape
- TIMESTAMP WITH LOCAL TIME ZONEaudiotape
**Acceptable Values:** Any any valid datetime format model. For example:
```
NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH:MI:SS.FF' NLS_TIMESTAMP_TZ_FORMAT='YYYY-MM-DD HH:MI:SS.FF TZH:TZM'
```
For information about datetime format models, see *Oracle Database SQL Language Reference*.
**Default Value:** Set by NLS_TERRITORY, described in “About the NLS_TERRITORY Parameter”.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_TIMESTAMP_FORMAT parameter
**
- Oracle Database Globalization Support Guide for more information about the NLS_TIMESTAMP_TZ_FORMAT parameter
**
- Oracle Database Globalization Support Guide for information about date/time data types and time zone support
**
- Oracle Database SQL Language Reference for more information about the TIMESTAMP audiotape
**
- Oracle Database SQL Language Reference for more information about the TIMESTAMP WITH LOCAL TIME ZONE data type
- “About Date and Time Formats”
- “Changing NLS Parameter Values”
## About the NLS_CALENDAR Parameter
This parameter specifies the calendar system for the database.
**Specifies:** Calendar system for the database.
**Acceptable Values:** Any calendar system that Oracle supports. For a list, see *Oracle Database Globalization Support Guide*.
**Default Value:** `Gregorian`
Example 7-6 shows how setting NLS_CALENDAR to `'English Hijrah'` and `Gregorian` affects the displayed system date.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-6 NLS_CALENDAR Affects Displayed SYSDATE**
  - Note the current value of NLS_CALENDAR.
```
ALTER SESSION SET NLS_CALENDAR='English Hijrah';
```
- If the value of NLS_CALENDAR in step 1 is not 'English Hijrah', change it:
```
SELECT SYSDATE FROM DUAL;
```
```
SYSDATE
 -------------------------
17 Safar             1434
```
- Run the following query: Result:
```
ALTER SESSION SET NLS_CALENDAR='Gregorian';
```
- Change the value of NLS_CALENDAR to 'Gregorian':
```
SELECT SYSDATE FROM DUAL;
```
```
SYSDATE
 ---------
31-DEC-12
```
- Run the following query: Result:
  - Set NLS_CALENDAR to the value that it had at step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_CALENDAR parameter
- “About Calendar Formats”
- “Changing NLS Parameter Values”
## About the NLS_NUMERIC_CHARACTERS Parameter
This parameter specifies the decimal character (which separates the integer and decimal parts of a number) and group separator (which separates integer groups to show thousands and millions, for example). The group separator is the character returned by the numeric format element G.
**Specifies:** Decimal character (which separates the integer and decimal parts of a number) and group separator (which separates integer groups to show thousands and millions, for example). The group separator is the character returned by the numeric format element G.
**Acceptable Values:** Any two different single-byte characters except:
- A numeric character
- Plus (+)
- Minus (-)
- Less than (<)
- Greater than (>)
**Default Value:** Set by `NLS_TERRITORY`, described in “About the NLS_TERRITORY Parameter”.
In a SQL statement, you can represent a number as either:
- Numeric literal A numeric literal is not enclosed in quotation marks, always uses a period (.) as the decimal character, and never contains a group separator.
- Text literal A text literal is enclosed in single quotation marks. It is implicitly or explicitly converted to a number, if required, according to the current NLS settings.
Example 7-7 shows how two different NLS_NUMERIC_CHARACTERS settings affect the displayed result of the same query.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-7 NLS_NUMERIC_CHARACTERS Affects Decimal Character and Group Separator**
  - Note the current value of NLS_NUMERIC_CHARACTERS.
```
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=",.";
```
- If the value of NLS_NUMERIC_CHARACTERS in step 1 is not ",." (decimal character is comma and group separator is period), use the following command to change it:
```
SELECT TO_CHAR(4000, '9G999D99') "Number" FROM DUAL;
```
```
Number
 ---------
 4.000,00
```
- Run the following query: Result:
```
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
```
- Change the value of NLS_NUMERIC_CHARACTERS to ",." (decimal character is period and group separator is comma):
```
SELECT TO_CHAR(4000, '9G999D99') "Number" FROM DUAL;
```
```
Number
 ---------
4,000.00
```
- Run the following query: Result:
  - Set NLS_NUMERIC_CHARACTERS to the value that it had at step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_NUMERIC_CHARACTERS parameter
- “About Numeric and Monetary Formats”
- “Changing NLS Parameter Values”
## About the NLS_CURRENCY Parameter
This parameter specifies the local currency symbol (the character string returned by the numeric format element L).
**Specifies:** Local currency symbol (the character string returned by the numeric format element L).
**Acceptable Values:** Any valid currency symbol string.
**Default Value:** Set by NLS_TERRITORY, described in “About the NLS_TERRITORY Parameter”.
Example 7-8 changes the value of NLS_CURRENCY, overriding the default value set by NLS_TERRITORY. To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-8 NLS_CURRENCY Overrides NLS_TERRITORY**
  - Note the current values of NLS_TERRITORY and NLS_CURRENCY.
```
ALTER SESSION SET NLS_TERRITORY=AMERICA;
```
- If the value of NLS_TERRITORY in step 1 is not AMERICA, change it:
```
SELECT TO_CHAR(salary, 'L099G999D99') "Salary" FROM EMPLOYEES WHERE salary > 13000;
```
```
Salary
 ---------------------
$024,000.00 $017,000.00 $017,000.00 $014,000.00 $013,500.00
```
- Run this query: Result:
```
ALTER SESSION SET NLS_CURRENCY='©';
```
- Change the value of NLS_CURRENCY to '©':
```
SELECT TO_CHAR(salary, 'L099G999D99') "Salary" FROM EMPLOYEES WHERE salary > 13000;
```
```
Salary
 ---------------------
©024,000.00 ©017,000.00 ©017,000.00 ©014,000.00 ©013,500.00
```
- Run this query: Result:
  - Set NLS_TERRITORY and NLS_CURRENCY to the values that they had at step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_CURRENCY parameter
- “About Numeric and Monetary Formats”
- “Changing NLS Parameter Values”
## About the NLS_ISO_CURRENCY Parameter
This parameter specifies the ISO currency symbol (the string returned by the numeric format element C).
**Specifies:** ISO currency symbol (the character string returned by the numeric format element C).
**Acceptable Values:** Any valid currency symbol string.
**Default Value:** Set by `NLS_TERRITORY`, described in “About the NLS_TERRITORY Parameter”.
Local currency symbols can be ambiguous, but ISO currency symbols are unique.
Example 7-9 shows that the territories `AUSTRALIA` and `AMERICA` have the same local currency symbol, but different ISO currency symbols.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-9 NLS_ISO_CURRENCY**
  - Note the current values of NLS_TERRITORY and NLS_ISO_CURRENCY.
```
ALTER SESSION SET NLS_TERRITORY=AUSTRALIA;
```
- If the value of NLS_TERRITORY in step 1 is not AUSTRALIA, change it:
```
SELECT TO_CHAR(salary, 'L099G999D99') "Local", TO_CHAR(salary, 'C099G999D99') "ISO" FROM EMPLOYEES WHERE salary > 15000;
```
```
Local                 ISO
 --------------------- ------------------
$024,000.00      AUD024,000.00 $017,000.00      AUD017,000.00 $017,000.00      AUD017,000.00
```
- Run the following query: Result:
```
ALTER SESSION SET NLS_TERRITORY=AMERICA;
```
- Change the value of NLS_TERRITORY to AMERICA:
```
SELECT TO_CHAR(salary, 'L099G999D99') "Local", TO_CHAR(salary, 'C099G999D99') "ISO" FROM EMPLOYEES WHERE salary > 15000;
```
```
Local                 ISO
 --------------------- ------------------
$024,000.00      USD024,000.00 $017,000.00      USD017,000.00 $017,000.00      USD017,000.00
```
- Run the following query: Result:
  - Set NLS_TERRITORY and NLS_ISO_CURRENCY to the values that they had at step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_ISO_CURRENCY parameter
- “About Numeric and Monetary Formats”
- “Changing NLS Parameter Values”
## About the NLS_DUAL_CURRENCY Parameter
This parameter specifies the dual currency symbol (introduced to support the euro currency symbol during the euro transition period).
**Specifies:** Dual currency symbol (introduced to support the euro currency symbol during the euro transition period).
**Acceptable Values:** Any valid currency symbol string.
**Default Value:** Set by NLS_TERRITORY, described in “About the NLS_TERRITORY Parameter”.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_DUAL_CURRENCY parameter
- “About Numeric and Monetary Formats”
- “Changing NLS Parameter Values”
## About the NLS_SORT Parameter
This parameter specifies the linguistic sort order (collating sequence) for queries that have the ORDER BY clause.
**Specifies:** Linguistic sort order (collating sequence) for queries that have the ORDER BY clause.
**Acceptable Values:**
- BINARY Sort order is based on the binary sequence order of either the database character set or the national character set, depending on the data type.
**
- Any linguistic sort name that Oracle supports Sort order is based on the order of the specified linguistic sort name. The linguistic sort name is usually the same as the language name, but not always. For a list of supported linguistic sort names, see Oracle Database Globalization Support Guide.
**Default Value:** Set by NLS_LANGUAGE, described in “About the NLS_LANGUAGE Parameter”.
Example 7-10 shows how two different NLS_SORT settings affect the displayed result of the same query. The settings are `BINARY` and Traditional Spanish (`SPANISH_M`). Traditional Spanish treats ch, ll, and ñ as letters that follow c, l, and n, respectively.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Case-Insensitive and Accent-Insensitive Sorts**
Operations inside Oracle Database are sensitive to the case and the accents of the characters. To perform a case-insensitive sort, append `_CI` to the value of the NLS_SORT parameter (for example, `BINARY_CI` or `GERMAN_CI`). To perform a sort that is both case-insensitive and accent-insensitive, append `_AI` to the value of the NLS_SORT parameter (for example, `BINARY_AI` or `FRENCH_M_AI`).
**Example 7-10 NLS_SORT Affects Linguistic Sort Order**
```
CREATE TABLE temp (name VARCHAR2(15));
```
- Create a table for Spanish words:
```
INSERT INTO temp (name) VALUES ('laguna');
INSERT INTO temp (name) VALUES ('llama');
INSERT INTO temp (name) VALUES ('loco');
```
- Populate the table with some Spanish words:
  - Note the current value of NLS_SORT.
```
ALTER SESSION SET NLS_SORT=BINARY;
```
- If the value of NLS_SORT in step 3 is not BINARY, change it:
```
SELECT * FROM temp ORDER BY name;
```
```
NAME
 ---------------
laguna llama loco
```
- Run the following query: Result:
```
ALTER SESSION SET NLS_SORT=SPANISH_M;
```
- Change the value of NLS_SORT to SPANISH_M (Traditional Spanish):
```
NAME
 ---------------
laguna loco llama
```
- Repeat the query from step 5. Result:
```
DROP TABLE temp;
```
- Drop the table:
  - Set NLS_SORT to the value that it had at step 3.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_SORT parameter
**
- Oracle Database Globalization Support Guide for more information about case-insensitive and accent-insensitive sorts
- “About Linguistic Sorting and String Searching”
- “Changing NLS Parameter Values”
## About the NLS_COMP Parameter
This parameter specifies the character-comparison behavior of SQL operations.
**Specifies:** Character-comparison behavior of SQL operations.
**Acceptable Values:**
- BINARY SQL compares the binary codes of characters. One character is greater than another if it has a higher binary code.
- LINGUISTIC SQL performs a linguistic comparison based on the value of the NLS_SORT parameter, described in “About the NLS_SORT Parameter”.
- ANSI This value is provided only for backward compatibility.
**Default Value:** `BINARY`
Example 7-11 shows that the result of a query can depend on the NLS_COMP setting.
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-11 NLS_COMP Affects SQL Character Comparison**
  - Note the current values of NLS_SORT and NLS_COMP.
````
```
 ALTER SESSION SET NLS_SORT=SPANISH_M NLS_COMP=BINARY;
```
- If the values of NLS_SORT and NLS_COMP in step 1 are not SPANISH_M (Traditional Spanish) and BINARY, respectively, change them:
```
 SELECT LAST_NAME FROM EMPLOYEES
 WHERE LAST_NAME LIKE 'C%';
```
```
 LAST_NAME
 -------------------------
 Cabrio
 Cambrault
 Cambrault
 Chen
 Chung
 Colmenares
 6 rows selected
```
- Run the following query: Result:
```
 ALTER SESSION SET NLS_COMP=LINGUISTIC;
```
- Change the value of NLS_COMP to LINGUISTIC:
```
 LAST_NAME
 -------------------------
 Cabrio
 Cambrault
 Cambrault
 Colmenares
 4 rows selected
```
````
- Repeat the query from step 3. Result: This time, Chen and Chung are not returned because Traditional Spanish treats ch as a single character that follows c.
  - Set NLS_SORT and NLS_COMP to the values that they had in step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_COMP parameter
- “About Linguistic Sorting and String Searching”
- “Changing NLS Parameter Values”
## About the NLS_LENGTH_SEMANTICS Parameter
This parameter specifies the length semantics for columns of the character data types CHAR, VARCHAR2, and LONG; that is, whether these columns are specified in bytes or in characters. (Applies only to columns that are declared after the parameter is set.)
**Specifies:** Length semantics for columns of the character data types CHAR, VARCHAR2, and LONG; that is, whether these columns are specified in bytes or in characters. (Applies only to columns that are declared after the parameter is set.)
**Acceptable Values:**
- BYTE New CHAR, VARCHAR2, and LONG columns are specified in bytes.
- CHAR New CHAR, VARCHAR2, and LONG columns are specified in characters.
**Default Value:** `BYTE`
To try this example in SQL Developer, enter the statements and queries in the Worksheet. For information about the Worksheet, see “Running Queries in SQL Developer”. The results shown here are from SQL*Plus; their format is slightly different in SQL Developer.
**Example 7-12 NLS_LENGTH_SEMANTICS Affects Storage of VARCHAR2 Column**
  - Note the current values of NLS_LENGTH_SEMANTICS.
```
ALTER SESSION SET NLS_LENGTH_SEMANTICS=BYTE;
```
- If the value of NLS_LENGTH_SEMANTICS in step 1 is not BYTE, change it:
```
CREATE TABLE SEMANTICS_BYTE(SOME_DATA VARCHAR2(20));
```
- Create a table with a VARCHAR2 column:
****
- Click the Connections tab.
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, select SEMANTICS_BYTE. To the right of the Connections frame, the Columns pane shows that for Column Name SOME_DATA, the Data Type is VARCHAR2(20 BYTE).
```
ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR;
```
- Change the value of NLS_LENGTH_SEMANTICS to CHAR:
```
CREATE TABLE SEMANTICS_CHAR(SOME_DATA VARCHAR2(20));
```
- Create another table with a VARCHAR2 column:
****
- In the Connections frame, click the Refresh icon. The list of tables now includes SEMANTICS_CHAR.
****
- Select SEMANTICS_CHAR. The Columns pane shows that for Column Name SOME_DATA, the Data Type is VARCHAR2(20 CHAR).
****
- Select SEMANTICS_BYTE again. The Columns pane shows that for Column Name SOME_DATA, the Data Type is still VARCHAR2(20 BYTE).
  - Set the value of NLS_LENGTH_SEMANTICS to the value that it had in step 1.
**See Also:**
**
- Oracle Database Globalization Support Guide for more information about the NLS_LENGTH_SEMANTICS parameter
- “About Length Semantics”
- “Changing NLS Parameter Values”
