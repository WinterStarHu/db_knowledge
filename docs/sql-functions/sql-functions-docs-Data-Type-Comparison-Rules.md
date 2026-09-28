# Data Type Comparison Rules

The script content on this page is for navigation purposes only and does not alter the content in any way.
This section describes how Oracle Database compares values of each data type.
## Numeric Values
A larger value is considered greater than a smaller one. All negative numbers are less than zero and all positive numbers. Thus, -1 is less than 100; -100 is less than -
1.
The floating-point value `NaN` (not a number) is greater than any other numeric value and is equal to itself.
**See Also:**   Numeric Precedence and Floating-Point Numbers for more information on comparison semantics
## Datetime Values
A later date or timestamp is considered greater than an earlier one. For example, the date equivalent of ‘29-MAR-2005’ is less than that of ‘05-JAN-2006’ and the timestamp equivalent of ‘05-JAN-2006 1:35pm’ is greater than that of ‘05-JAN-2005 10:09am’.
When two timestamps with time zone are compared, they are first normalized to UTC, that is, to the timezone offset ‘+00:00’. For example, the timestamp with time zone equivalent of ‘16-OCT-2016 05:59am Europe/Warsaw’ is equal to that of ‘15-OCT-2016 08:59pm US/Pacific’. Both represent the same absolute point in time, which represented in UTC is October 16th, 2016, 03:59am.
## Binary Values
A binary value of the data type `RAW` or `BLOB` is a sequence of bytes. When two binary values are compared, the corresponding, consecutive bytes of the two byte sequences are compared in turn. If the first bytes of both compared values are different, the binary value that contains the byte with the lower numeric value is considered smaller. If the first bytes are equal, second bytes are compared analogously, and so on, until either the compared bytes differ or the comparison process reaches the end of one of the values. In the latter case, the value that is shorter is considered smaller.
Binary values of the data type `BLOB` cannot be compared directly in comparison conditions. However, they can be compared with the PL/SQL function `DBMS_LOB`.`COMPARE`.
**See Also:**   *Oracle Database PL/SQL Packages and Types Reference* for more information on the `DBMS_LOB`.`COMPARE` function
## Character Values
Character values are compared on the basis of two measures:
- Binary or linguistic collation
- Blank-padded or nonpadded comparison semantics
The following subsections describe the two measures.
**Binary and Linguistic Collation** In binary collation, which is the default, Oracle compares character values like binary values. Two sequences of bytes that form the encodings of two character values in their storage character set are treated as binary values and compared as described in Binary Values. The result of this comparison is returned as the result of the binary comparison of the source character values.
**See Also:**   *Oracle Database Globalization Support Guide* for more information on character sets For many languages, the binary collation can yield a linguistically incorrect ordering of character values. For example, in most common character sets, all the uppercase Latin letters have character codes with lower values than all the lowercase Latin letters. Hence, the binary collation yields the following order:
```
MacDonald
MacIntosh
Macdonald
Macintosh
```
However, most users expect these four values to be presented in the order:
```
MacDonald
Macdonald
MacIntosh
Macintosh
```
This shows that binary collation may not be suitable even for English character values.
Oracle Database supports linguistic collations that order strings according to rules of various spoken languages. It also supports collation variants that match character values caseand accent-insensitively. Linguistic collations are more expensive but they provide superior user experience.
**See Also:**   *Oracle Database Globalization Support Guide* for more information about linguistic sorting **Restrictions for Linguistic Collations** Comparison conditions, `ORDER` `BY`, `GROUP` `BY` and `MATCH_RECOGNIZE` query clauses, `COUNT(DISTINCT)` and statistical aggregate functions, `LIKE` conditions, and `ORDER` `BY` and `PARTITION` `BY` analytic clauses generate collation keys when using linguistic collations. The collation keys are the same values that are returned by the function `NLSSORT` and are subject to the same restrictions that are described in NLSSORT.
**Blank-Padded and Nonpadded Comparison Semantics** With blank-padded semantics, if the two values have different lengths, then Oracle first adds blanks to the end of the shorter one so their lengths are equal. Oracle then compares the values character by character up to the first character that differs. The value with the greater character in the first differing position is considered greater. If two values have no differing characters, then they are considered equal. This rule means that two values are equal if they differ only in the number of trailing blanks. Oracle uses blank-padded comparison semantics only when both values in the comparison are either expressions of data type `CHAR`, `NCHAR`, text literals, or values returned by the `USER` function.
With nonpadded semantics, Oracle compares two values character by character up to the first character that differs. The value with the greater character in that position is considered greater. If two values of different length are identical up to the end of the shorter one, then the longer value is considered greater. If two values of equal length have no differing characters, then the values are considered equal. Oracle uses nonpadded comparison semantics whenever one or both values in the comparison have the data type `VARCHAR2` or `NVARCHAR2`.
The results of comparing two character values using different comparison semantics may vary. The table that follows shows the results of comparing five pairs of character values using each comparison semantic. Usually, the results of blank-padded and nonpadded comparisons are the same. The last comparison in the table illustrates the differences between the blank-padded and nonpadded comparison semantics.

| Blank-Padded | Nonpadded |
|---|---|
| 'ac' > 'ab' | 'ac' > 'ab' |
| 'ab' > 'a ' | 'ab' > 'a ' |
| 'ab' > 'a' | 'ab' > 'a' |
| 'ab' = 'ab' | 'ab' = 'ab' |
| 'a ' = 'a' | 'a ' > 'a' |

**Data-Bound Collation** Starting with Oracle Database 12*c* Release 2 (12.2), the collation to use when comparing or matching a given character value is associated with the value itself. It is called the **data-bound collation**. The data-bound collation can be viewed as an attribute of the data type of the value.
In previous Oracle Database releases, the session parameters `NLS_COMP` and `NLS_SORT` coarsely determined the collation for all collation-sensitive SQL operations in a database session. The data-bound collation architecture enables applications to consistently apply language-specific comparison rules to exactly the data that needs these rules.
Oracle Database 12*c* Release 2 (12.2) allows you to declare a collation for a table column. When a column is passed as an argument to a collation-sensitive SQL operation, the SQL operation uses the column’s declared collation to process the column’s values. If the SQL operation has multiple character arguments that are compared to each other, the **collation determination rules** determine the collation to use.
There are two types of data-bound collations:
- Named Collation: This collation is a particular set of collating rules specified by a collation name. Named collations are the same collations that are specified as values for the NLS_SORT parameter. A named collation can be either a binary collation or a linguistic collation.
``````**
- Pseudo-collation: This collation does not directly specify the collating rules for a SQL operation. Instead, it instructs the operation to check the values of the session parameters NLS_SORT and NLS_COMP for the actual named collation to use. Pseudo-collations are the bridge between the new declarative method of specifying collations and the old method that uses session parameters. In particular, the pseudo-collation USING_NLS_COMP directs a SQL operation to behave exactly as it used to behave before Oracle Database 12c Release 2.
When you declare a named collation for a column, you statically determine how the column values are compared. When you declare a pseudo-collation, you can dynamically control comparison behavior with the session parameter `NLS_COMP` and `NLS_SORT`. However, static objects, such as indexes and constraints, defined on a column declared with a pseudo-collation, fall back to using a binary collation. Dynamically settable collating rules cannot be used to compare values for a static object.
The collation for a character literal or bind variable that is used in an expression is derived from the default collation of the database object containing the expression, such as a view or materialized view query, a PL/SQL stored unit code, a user-defined type method code, or a standalone DML or query statement. In Oracle Database 12*c* Release 2, the default collation of PL/SQL stored units, user-defined type methods, and standalone SQL statements is always the pseudo-collation `USING_NLS_COMP`. The default collation of views and materialized views can be specified in the `DEFAULT` `COLLATION` clause of the `CREATE` `VIEW` and `CREATE` `MATERIALIZED` `VIEW` statements.
If a SQL operation returns character values, the **collation derivation rules** determine the **derived collation** for the result, so that its collation is known, when the result is passed as an argument to another collation-sensitive SQL operation in the expression tree or to a top-level consumer, such as an SQL statement clause in a `SELECT` statement. If a SQL operation operates on character argument values, then the derived collation of its character result is based on the collations of the arguments. Otherwise, the derivation rules are the same as for a character literal.
You can override the derived collation of an expression node, such as a simple expression or an operator result, by using the `COLLATE` operator.
Oracle Database allows you to declare a case-insensitive collation for a column, table or schema, so that the column or all character columns in a table or a schema can be always compared in a case-insensitive way.
```

```
## Object Values
Object values are compared using one of two comparison functions: `MAP` and `ORDER`. Both functions compare object type instances, but they are quite different from one another. These functions must be specified as part of any object type that will be compared with other object types.
**See Also:**   CREATE TYPE for a description of `MAP` and `ORDER` methods and the values they return
## Varrays and Nested Tables
Comparison of nested tables is described in Comparison Conditions.
## Data Type Precedence
Oracle uses data type precedence to determine implicit data type conversion, which is discussed in the section that follows. Oracle data types take the following precedence:
- Datetime and interval data types
- BINARY_DOUBLE
- BINARY_FLOAT
- NUMBER
- Character data types
- All other built-in data types
## Data Conversion
Generally an expression cannot contain values of different data types. For example, an expression cannot multiply 5 by 10 and then add ‘JAMES’. However, Oracle supports both implicit and explicit conversion of values from one data type to another.
### Implicit and Explicit Data Conversion
Oracle recommends that you specify explicit conversions, rather than rely on implicit or automatic conversions, for these reasons:
- SQL statements are easier to understand when you use explicit data type conversion functions.
- Implicit data type conversion can have a negative impact on performance, especially if the data type of a column value is converted to that of a constant rather than the other way around.
````
- Implicit conversion depends on the context in which it occurs and may not work the same way in every case. For example, implicit conversion from a datetime value to a VARCHAR2 value may return an unexpected year depending on the value of the NLS_DATE_FORMAT parameter.
- Algorithms for implicit conversion are subject to change across software releases and among Oracle products. Behavior of explicit conversions is more predictable.
- If implicit data type conversion occurs in an index expression, then Oracle Database might not use the index because it is defined for the pre-conversion data type. This can have a negative impact on performance.
### Implicit Data Conversion
Oracle Database automatically converts a value from one data type to another when such a conversion makes sense.
Table 2-8 is a matrix of Oracle implicit conversions. The table shows all possible conversions, without regard to the direction of the conversion or the context in which it is made.
An ‘X’ in a cell indicates implicit conversion of the data types named in the first column and header row.
Table 8 Implicit Type Conversion Matrix

| DataType | CHAR | VARCHAR2 | NCHAR | NVARCHAR2 | DATE | DATETIME/INTERVAL | NUMBER | BINARY_FLOAT | BINARY_DOUBLE | LONG | RAW | ROWID | CLOB | BLOB | NCLOB |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CHAR | – | X | X | X | X | X | X | X | X | X | X | X | X | X | X |
| VARCHAR2 | X | – | X | X | X | X | X | X | X | X | X | X | X | – | X |
| NCHAR | X | X | – | X | X | X | X | X | X | X | X | X | X | – | X |
| NVARCHAR2 | X | X | X | – | X | X | X | X | X | X | X | X | X | – | X |
| DATE | X | X | X | X | – | – | – | – | – | – | – | – | – | – | – |
| DATETIME/ INTERVAL | X | X | X | X | – | – | – | – | – | X | – | – | – | – | – |
| NUMBER | X | X | X | X | – | – | – | X | X | – | – | – | – | – | – |
| BINARY_FLOAT | X | X | X | X | – | – | X | – | X | – | – | – | – | – | – |
| BINARY_DOUBLE | X | X | X | X | – | – | X | X | – | – | – | – | – | – | – |
| LONG | X | X | X | X | – | XFoot 1 | – | – | – | – | X | – | X | – | X |
| RAW | X | X | X | X | – | – | – | – | – | X | – | – | – | X | – |
| ROWID | X | X | X | X | – | – | – | – | – | – | – | – | – | – | – |
| CLOB | X | X | X | X | – | – | – | – | – | X | – | – | – | – | X |
| BLOB | – | – | – | – | – | – | – | – | – | – | X | – | – | – | – |
| NCLOB | X | X | X | X | – | – | – | – | – | X | – | – | X | – | – |

Footnote 1 You cannot convert `LONG` to `INTERVAL` directly, but you can convert `LONG` to `VARCHAR2` using `TO_CHAR`(*interval*), and then convert the resulting `VARCHAR2` value to `INTERVAL`.
**Implicit Data Type Conversion Rules**
````
- During INSERT and UPDATE operations, Oracle converts the value to the data type of the affected column.
````
- During SELECT FROM operations, Oracle converts the data from the column to the type of the target variable.
- When manipulating numeric values, Oracle usually adjusts precision and scale to allow for maximum capacity. In such cases, the numeric data type resulting from such operations can differ from the numeric data type found in the underlying tables.
- When comparing a character value with a numeric value, Oracle converts the character data to a numeric value.
````
- Conversions between character values or NUMBER values and floating-point number values can be inexact, because the character types and NUMBER use decimal precision to represent the numeric value, and the floating-point numbers use binary precision.
````````
- When converting a CLOB value into a character data type such as VARCHAR2, or converting BLOB to RAW data, if the data to be converted is larger than the target data type, then the database returns an error.
- During conversion from a timestamp value to a DATE value, the fractional seconds portion of the timestamp value is truncated. This behavior differs from earlier releases of Oracle Database, when the fractional seconds portion of the timestamp value was rounded.
````
- Conversions from BINARY_FLOAT to BINARY_DOUBLE are exact.
````````
- Conversions from BINARY_DOUBLE to BINARY_FLOAT are inexact if the BINARY_DOUBLE value uses more bits of precision that supported by the BINARY_FLOAT.
````
- When comparing a character value with a DATE value, Oracle converts the character data to DATE.
- When you use a SQL function or operator with an argument of a data type other than the one it accepts, Oracle converts the argument to the accepted data type.
- When making assignments, Oracle converts the value on the right side of the equal sign (=) to the data type of the target of the assignment on the left side.
````
- During concatenation operations, Oracle converts from noncharacter data types to CHAR or NCHAR.
``````````
- During arithmetic operations on and comparisons between character and noncharacter data types, Oracle converts from any character data type to a numeric, date, or rowid, as appropriate. In arithmetic operations between CHAR/VARCHAR2 and NCHAR/NVARCHAR2, Oracle converts to a NUMBER.
``````````````````
- Most SQL character functions are enabled to accept CLOBs as parameters, and Oracle performs implicit conversions between CLOB and character types. Therefore, functions that are not yet enabled for CLOBs can accept CLOBs through implicit conversion. In such cases, Oracle converts the CLOBs to CHAR or VARCHAR2 before the function is invoked. If the CLOB is larger than 4000 bytes, then Oracle converts only the first 4000 bytes to CHAR.
````````
- When converting RAW or LONG RAW data to or from character data, the binary data is represented in hexadecimal form, with one hexadecimal character representing every four bits of RAW data. Refer to “RAW and LONG RAW Data Types” for more information.
````````
- Comparisons between CHAR and VARCHAR2 and between NCHAR and NVARCHAR2 types may entail different character sets. The default direction of conversion in such cases is from the database character set to the national character set. Table 2-9 shows the direction of implicit conversions between different character types.
Table 9 Conversion Direction of Different Character Types

| SourceData Type | to CHAR | to VARCHAR2 | to NCHAR | to NVARCHAR2 |
|---|---|---|---|---|
| from CHAR | – | VARCHAR2 | NCHAR | NVARCHAR2 |
| from VARCHAR2 | VARCHAR2 | – | NVARCHAR2 | NVARCHAR2 |
| from NCHAR | NCHAR | NCHAR | – | NVARCHAR2 |
| from NVARCHAR2 | NVARCHAR2 | NVARCHAR2 | NVARCHAR2 | – |

User-defined types such as collections cannot be implicitly converted, but must be explicitly converted using `CAST` … `MULTISET`.
### Implicit Data Conversion Examples
**Text Literal Example** The text literal ‘10’ has data type `CHAR`. Oracle implicitly converts it to the `NUMBER` data type if it appears in a numeric expression as in the following statement:
```
SELECT salary + '10'
  FROM employees;
```
**Character and Number Values Example** When a condition compares a character value and a `NUMBER` value, Oracle implicitly converts the character value to a `NUMBER` value, rather than converting the `NUMBER` value to a character value. In the following statement, Oracle implicitly converts ‘200’ to 200:
```
SELECT last_name
  FROM employees
  WHERE employee_id = '200';
```
**Date Example** In the following statement, Oracle implicitly converts ‘`24-JUN-06`’ to a `DATE` value using the default date format ‘`DD-MON-YY`’:
```
SELECT last_name
  FROM employees
  WHERE hire_date = '24-JUN-06';
```
### Explicit Data Conversion
You can explicitly specify data type conversions using SQL conversion functions. Table 2-10 shows SQL functions that explicitly convert a value from one data type to another.
You cannot specify `LONG` and `LONG` `RAW` values in cases in which Oracle can perform implicit data type conversion. For example, `LONG` and `LONG` `RAW` values cannot appear in expressions with functions or operators. Refer to LONG Data Type for information on the limitations on `LONG` and `LONG` `RAW` data types.
Table 10 Explicit Type Conversions

| SourceData Type | to CHAR,VARCHAR2,NCHAR,NVARCHAR2 | to NUMBER | to Datetime/Interval | to RAW | to ROWID | to LONG,LONG RAW | to CLOB, NCLOB,BLOB | to BINARY_FLOAT | to BINARY_DOUBLE |
|---|---|---|---|---|---|---|---|---|---|
| from CHAR, VARCHAR2, NCHAR, NVARCHAR2 | TO_CHAR (char.)TO_NCHAR (char.) | TO_NUMBER | TO_DATETO_TIMESTAMPTO_TIMESTAMP_TZTO_YMINTERVALTO_DSINTERVAL | HEXTORAW | CHARTO­=ROWID | -- | TO_CLOBTO_NCLOB | TO_BINARY_FLOAT | TO_BINARY_DOUBLE |
| from NUMBER | TO_CHAR (number)TO_NCHAR (number) | -- | TO_DATENUMTOYM- INTERVALNUMTODS- INTERVAL | -- | -- | -- | -- | TO_BINARY_FLOAT | TO_BINARY_DOUBLE |
| from Datetime/ Interval | TO_CHAR (date)TO_NCHAR (datetime) | -- | -- | -- | -- | -- | -- | -- | -- |
| from RAW | RAWTOHEXRAWTONHEX | -- | -- | -- | -- | -- | TO_BLOB | -- | -- |
| from ROWID | ROWIDTOCHAR | -- | -- | -- | -- | -- | -- | -- | -- |
| from LONG / LONG RAW | -- | -- | -- | -- | -- | -- | TO_LOB | -- | -- |
| from CLOB, NCLOB, BLOB | TO_CHARTO_NCHAR | -- | -- | -- | -- | -- | TO_CLOBTO_NCLOB | -- | -- |
| from CLOB, NCLOB, BLOB | TO_CHARTO_NCHAR | -- | -- | -- | -- | -- | TO_CLOBTO_NCLOB | -- | -- |
| from BINARY_FLOAT | TO_CHAR (char.)TO_NCHAR (char.) | TO_NUMBER | -- | -- | -- | -- | -- | TO_BINARY_FLOAT | TO_BINARY_DOUBLE |
| from BINARY_DOUBLE | TO_CHAR (char.)TO_NCHAR (char.) | TO_NUMBER | -- | -- | -- | -- | -- | TO_BINARY_FLOAT | TO_BINARY_DOUBLE |

**See Also:**   Conversion Functions for details on all of the explicit conversion functions
## Security Considerations for Data Conversion
When a datetime value is converted to text, either by implicit conversion or by explicit conversion that does not specify a format model, the format model is defined by one of the globalization session parameters. Depending on the source data type, the parameter name is `NLS_DATE_FORMAT`, `NLS_TIMESTAMP_FORMAT`, or `NLS_TIMESTAMP_TZ_FORMAT`. The values of these parameters can be specified in the client environment or in an `ALTER` `SESSION` statement.
The dependency of format models on session parameters can have a negative impact on database security when conversion without an explicit format model is applied to a datetime value that is being concatenated to text of a dynamic SQL statement. Dynamic SQL statements are those statements whose text is concatenated from fragments before being passed to a database for execution. Dynamic SQL is frequently associated with the built-in PL/SQL package `DBMS_SQL` or with the PL/SQL statement `EXECUTE` `IMMEDIATE`, but these are not the only places where dynamically constructed SQL text may be passed as argument. For example:
```
EXECUTE IMMEDIATE
'SELECT last_name FROM employees WHERE hire_date > ''' || start_date || '''';
```
where *start_date* has the data type `DATE`.
In the above example, the value of *start_date* is converted to text using a format model specified in the session parameter `NLS_DATE_FORMAT`. The result is concatenated into SQL text. A datetime format model can consist simply of literal text enclosed in double quotation marks. Therefore, any user who can explicitly set globalization parameters for a session can decide what text is produced by the above conversion. If the SQL statement is executed by a PL/SQL procedure, the procedure becomes vulnerable to SQL injection through the session parameter. If the procedure runs with definer’s rights, with higher privileges than the session itself, the user can gain unauthorized access to sensitive data.
**See Also:**   *Oracle Database PL/SQL Language Reference* for further examples and for recommendations on avoiding this security risk **Note:**   This security risk also applies to middle-tier applications that construct SQL text from datetime values converted to text by the database or by OCI datetime functions. Those applications are vulnerable if session globalization parameters are obtained from a user preference.
Implicit and explicit conversion for numeric values may also suffer from the analogous problem, as the conversion result may depend on the session parameter `NLS_NUMERIC_CHARACTERS`. This parameter defines the decimal and group separator characters. If the decimal separator is defined to be the quotation mark or the double quotation mark, some potential for SQL injection emerges.
**See Also:** **
- Oracle Database Globalization Support Guide for detailed descriptions of the session globalization parameters
- Format Models for information on the format models
