# CAST

## Syntax
Description of the illustration cast.gif Description of the illustration cast.eps
## Purpose
`CAST` lets you convert built-in data types or collection-typed values of one type into another built-in data type or collection type. You can cast an unnamed operand (such as a date or the result set of a subquery) or a named collection (such as a varray or a nested table) into a type-compatible data type or named collection. The *type_name* must be the name of a built-in data type or collection type and the operand must be a built-in data type or must evaluate to a collection value.
For the operand, *expr* can be either a built-in data type, a collection type, or an instance of an `ANYDATA` type. If *expr* is an instance of an `ANYDATA` type, then `CAST` tries to extract the value of the `ANYDATA` instance and return it if it matches the cast target type, otherwise, null will be returned. `MULTISET` informs Oracle Database to take the result set of the subquery and return a collection value. Table 7-1 shows which built-in data types can be cast into which other built-in data types. (`CAST` does not support `LONG`, `LONG` `RAW`, or the Oracle-supplied types.) `CAST` does not directly support any of the LOB data types. When you use `CAST` to convert a `CLOB` value into a character data type or a `BLOB` value into the `RAW` data type, the database implicitly converts the LOB value to character or raw data and then explicitly casts the resulting value into the target data type. If the resulting value is larger than the target type, then the database returns an error.
When you use `CAST` … `MULTISET` to get a collection value, each select list item in the query passed to the `CAST` function is converted to the corresponding attribute type of the target collection element type.
Table 1 Casting Built-In Data Types

| Destination Data Type | from BINARY_FLOAT, BINARY_DOUBLE | from CHAR, VARCHAR2 | from NUMBER/INTEGER | from DATETIME / INTERVAL (Note 1) | from RAW | from ROWID, UROWID (Note 2) | from NCHAR, NVARCHAR2 |
|---|---|---|---|---|---|---|---|
| to BINARY_FLOAT, BINARY_DOUBLE | X (Note 3) | X (Note 3) | X (Note 3) | -- | -- | -- | X (Note 3) |
| to CHAR, VARCHAR2 | X | X | X | X | X | X | X |
| to NUMBER/INTEGER | X (Note 3) | X (Note 3) | X (Note 3) | -- | -- | -- | X (Note 3) |
| to DATETIME/INTERVAL | -- | X (Note 3) | -- | X (Note 3) | -- | -- | -- |
| to RAW | -- | X | -- | -- | X | -- | X |
| to ROWID, UROWID | -- | X | -- | -- | -- | X | -- |
| to NCHAR, NVARCHAR2 | X | -- | X | X | X | X | X |

**Note 1:** Datetime/interval includes `DATE`, `TIMESTAMP`, `TIMESTAMP` `WITH` `TIMEZONE`, `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`, `INTERVAL` `DAY` `TO` `SECOND`, and `INTERVAL` `YEAR` `TO` `MONTH`.
**Note 2:** You cannot cast a `UROWID` to a `ROWID` if the `UROWID` contains the value of a `ROWID` of an index-organized table.
**Note 3:** You can specify the `DEFAULT` *return_value* `ON` `CONVERSION` `ERROR` clause for this type of conversion. You can specify the *fmt* and *nlsparam* clauses for this type of conversion with the following exceptions: you cannot specify fmt when converting to `INTERVAL` `DAY` `TO` `SECOND`, and you cannot specify *fmt* or *nlsparam* when converting to `INTERVAL` `YEAR` `TO` `MONTH`.
If you want to cast a named collection type into another named collection type, then the elements of both collections must be of the same type.
**See Also:**
- Implicit Data Conversion for information on how Oracle Database implicitly converts collection type data into character data and Security Considerations for Data Conversion
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the return value of CAST when it is a character value
**MULTISET** If the result set of *subquery* can evaluate to multiple rows, then you must specify the `MULTISET` keyword. The rows resulting from the subquery form the elements of the collection value into which they are cast. Without the `MULTISET` keyword, the subquery is treated as a scalar subquery.
**Restriction on MULTISET** If you specify the `MULTISET` keyword, then you cannot specify the `DEFAULT` *return_value* `ON` `CONVERSION` `ERROR`, *fmt*, or *nlsparam* clauses.
**DEFAULT *return_value* ON CONVERSION ERROR** This clause allows you to specify the value returned by this function if an error occurs while converting *expr* to *type_name*. This clause has no effect if an error occurs while evaluating *expr*.
This clause is valid if *expr* evaluates to a character string of type `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`, and *type_name* is `BINARY_DOUBLE`, `BINARY_FLOAT`, `DATE`, `INTERVAL` `DAY` `TO` `SECOND`, `INTERVAL` `YEAR` `TO` `MONTH`, `NUMBER`, `TIMESTAMP`, `TIMESTAMP` `WITH` `TIME` `ZONE`, or `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`.
The *return_value* can be a string literal, null, constant expression, or a bind variable, and must evaluate to null or a character string of type `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. If *return_value* cannot be converted to *type_name*, then the function returns an error.
***fmt* and *nlsparam*** The *fmt* argument lets you specify a format model and the *nlsparam* argument lets you specify NLS parameters. If you specify these arguments, then they are applied when converting *expr* and *return_value*, if specified, to *type_name*.
You can specify *fmt* and *nlsparam* if *type_name* is one of the following data types:
****
- BINARY_DOUBLE If you specify BINARY_DOUBLE, then the optional fmt and nlsparam arguments serve the same purpose as for the TO_BINARY_DOUBLE function. Refer to TO_BINARY_DOUBLE for more information.
****
- BINARY_FLOAT If you specify BINARY_FLOAT, then the optional fmt and nlsparam arguments serve the same purpose as for the TO_BINARY_FLOAT function. Refer to TO_BINARY_FLOAT for more information.
****
- DATE If you specify DATE, then the optional fmt and nlsparam arguments serve the same purpose as for the TO_DATE function. Refer to TO_DATE for more information.
****
- NUMBER If you specify NUMBER, then the optional fmt and nlsparam arguments serve the same purpose as for the TO_NUMBER function. Refer to TO_NUMBER for more information.
********``````
- TIMESTAMP If you specify TIMESTAMP, then the optional fmt and nlsparam arguments serve the same purpose as for the TO_TIMESTAMP function. If you omit fmt, then expr must be in the default format of the TIMESTAMP data type, which is determined explicitly by the NLS_TIMESTAMP_FORMAT parameter or implicitly by the NLS_TERRITORY parameter. Refer to TO_TIMESTAMP for more information.
````````
````````********````````````
- TIMESTAMP WITH TIME ZONE If you specify TIMESTAMP WITH TIME ZONE, then the optional fmt and nlsparam arguments serve the same purpose as for the TO_TIMESTAMP_TZ function. If you omit fmt, then expr must be in the default format of the TIMESTAMP WITH TIME ZONE data type, which is determined explicitly by the NLS_TIMESTAMP_TZ_FORMAT parameter or implicitly by the NLS_TERRITORY parameter. Refer to TO_TIMESTAMP_TZ for more information.
``````````
``````````********``````
- TIMESTAMP WITH LOCAL TIME ZONE If you specify TIMESTAMP WITH LOCAL TIME ZONE then the optional fmt and nlsparam arguments serve the same purpose as for the TO_TIMESTAMP function. If you omit fmt, then expr must be in the default format of the TIMESTAMP data type, , which is determined explicitly by the NLS_TIMESTAMP_FORMAT parameter or implicitly by the NLS_TERRITORY parameter. Refer to TO_TIMESTAMP for more information.
## Built-In Data Type Examples
The following examples use the `CAST` function with scalar data types. The first example converts text to a timestamp value by applying the format model provided in the session parameter `NLS_TIMESTAMP_FORMAT`. If you want to avoid dependency on this NLS parameter, then you can use the `TO_DATE` as shown in the second example.
```
SELECT CAST('22-OCT-1997'
       AS TIMESTAMP WITH LOCAL TIME ZONE)
  FROM DUAL;
SELECT CAST(TO_DATE('22-Oct-1997', 'DD-Mon-YYYY')
       AS TIMESTAMP WITH LOCAL TIME ZONE)
  FROM DUAL;
```
In the preceding example, `TO_DATE` converts from text to `DATE`, and `CAST` converts from `DATE` to `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`, interpreting the date in the session time zone (`SESSIONTIMEZONE`).
```
SELECT product_id, CAST(ad_sourcetext AS VARCHAR2(30)) text
  FROM print_media
  ORDER BY product_id;
```
The following examples return a default value if an error occurs while converting the specified value to the specified data type. In these examples, the conversions occurs without error.
```
SELECT CAST(200
       AS NUMBER
       DEFAULT 0 ON CONVERSION ERROR)
  FROM DUAL;
```
```
SELECT CAST('January 15, 1989, 11:00 A.M.'
       AS DATE
       DEFAULT NULL ON CONVERSION ERROR,
       'Month dd, YYYY, HH:MI A.M.')
  FROM DUAL;
```
```
SELECT CAST('1999-12-01 11:00:00 -8:00'
       AS TIMESTAMP WITH TIME ZONE
       DEFAULT '2000-01-01 01:00:00 -8:00' ON CONVERSION ERROR,
       'YYYY-MM-DD HH:MI:SS TZH:TZM',
       'NLS_DATE_LANGUAGE = American')
  FROM DUAL;
```
In the following example, an error occurs while converting `'N/A'` to a `NUMBER` value. Therefore, the `CAST` function returns the default value of `0`.
```
SELECT CAST('N/A'
       AS NUMBER
       DEFAULT '0' ON CONVERSION ERROR)
  FROM DUAL;
```
## Collection Examples
The `CAST` examples that follow build on the `cust_address_typ` found in the sample order entry schema, `oe`.
```
CREATE TYPE address_book_t AS TABLE OF cust_address_typ;
/
CREATE TYPE address_array_t AS VARRAY(3) OF cust_address_typ;
/
CREATE TABLE cust_address (
  custno            NUMBER,
  street_address    VARCHAR2(40),
  postal_code       VARCHAR2(10),
  city              VARCHAR2(30),
  state_province    VARCHAR2(10),
  country_id        CHAR(2));
CREATE TABLE cust_short (custno NUMBER, name VARCHAR2(31));
CREATE TABLE states (state_id NUMBER, addresses address_array_t);
```
This example casts a subquery:
```
SELECT s.custno, s.name,
       CAST(MULTISET(SELECT ca.street_address,
                            ca.postal_code,
                            ca.city,
                            ca.state_province,
                            ca.country_id
                       FROM cust_address ca
                       WHERE s.custno = ca.custno)
       AS address_book_t)
  FROM cust_short s
  ORDER BY s.custno;
```
`CAST` converts a varray type column into a nested table:
```
SELECT CAST(s.addresses AS address_book_t)
  FROM states s
  WHERE s.state_id = 111;
```
The following objects create the basis of the example that follows:
```
CREATE TABLE projects
  (employee_id NUMBER, project_name VARCHAR2(10));
CREATE TABLE emps_short
  (employee_id NUMBER, last_name VARCHAR2(10));
CREATE TYPE project_table_typ AS TABLE OF VARCHAR2(10);
/
```
The following example of a `MULTISET` expression uses these objects:
```
SELECT e.last_name,
       CAST(MULTISET(SELECT p.project_name
                       FROM projects p
                       WHERE p.employee_id = e.employee_id
                       ORDER BY p.project_name)
       AS project_table_typ)
  FROM emps_short e
  ORDER BY e.last_name;
```
