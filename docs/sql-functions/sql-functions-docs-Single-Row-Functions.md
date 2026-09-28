# Single-Row Functions

Single-row functions return a single result row for every row of a queried table or view. These functions can appear in select lists, `WHERE` clauses, `START` `WITH` and `CONNECT` `BY` clauses, and `HAVING` clauses.
## Numeric Functions
Numeric functions accept numeric input and return numeric values. Most numeric functions return `NUMBER` values that are accurate to 38 decimal digits. The transcendental functions `COS`, `COSH`, `EXP`, `LN`, `LOG`, `SIN`, `SINH`, `SQRT`, `TAN`, and `TANH` are accurate to 36 decimal digits. The transcendental functions `ACOS`, `ASIN`, `ATAN`, and `ATAN2` are accurate to 30 decimal digits. The numeric functions are:
- ABS
- ACOS
- ASIN
- ATAN
- ATAN2
- BITAND
- CEIL
- COS
- COSH
- EXP
- FLOOR
- LN
- LOG
- MOD
- NANVL
- POWER
- REMAINDER
- ROUND (number)
- SIGN
- SIN
- SINH
- SQRT
- TAN
- TANH
- TRUNC (number)
- WIDTH_BUCKET
## Character Functions Returning Character Values
Character functions that return character values return values of the following data types unless otherwise documented:
``````
- If the input argument is CHAR or VARCHAR2, then the value returned is VARCHAR2.
``````
- If the input argument is NCHAR or NVARCHAR2, then the value returned is NVARCHAR2.
The length of the value returned by the function is limited by the maximum length of the data type returned.
````
- For functions that return CHAR or VARCHAR2, if the length of the return value exceeds the limit, then Oracle Database truncates it and returns the result without an error message.
- For functions that return CLOB values, if the length of the return values exceeds the limit, then Oracle raises an error and returns no data.
The character functions that return character values are:
- CHR
- CONCAT
- INITCAP
- LOWER
- LPAD
- LTRIM
- NCHR
- NLS_INITCAP
- NLS_LOWER
- NLS_UPPER
- NLSSORT
- REGEXP_REPLACE
- REGEXP_SUBSTR
- REPLACE
- RPAD
- RTRIM
- SOUNDEX
- SUBSTR
- TRANSLATE
- TRANSLATE ... USING
- TRIM
- UPPER
## Character Functions Returning Number Values
Character functions that return number values can take as their argument any character data type. The character functions that return number values are:
- ASCII
- INSTR
- LENGTH
- REGEXP_COUNT
- REGEXP_INSTR
## Character Set Functions
The character set functions return information about the character set. The character set functions are:
- NLS_CHARSET_DECL_LEN
- NLS_CHARSET_ID
- NLS_CHARSET_NAME
## Collation Functions
The collation functions return information about collation settings. The collation functions are:
- COLLATION
- NLS_COLLATION_ID
- NLS_COLLATION_NAME
## Datetime Functions
Datetime functions operate on date (`DATE`), timestamp (`TIMESTAMP`, `TIMESTAMP` `WITH` `TIME` `ZONE`, and `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`), and interval (`INTERVAL` `DAY` `TO` `SECOND`, `INTERVAL` `YEAR` `TO` `MONTH`) values.
Some of the datetime functions were designed for the Oracle `DATE` data type (`ADD_MONTHS`, `CURRENT_DATE`, `LAST_DAY`, `NEW_TIME`, and `NEXT_DAY`). If you provide a timestamp value as their argument, then Oracle Database internally converts the input type to a `DATE` value and returns a `DATE` value. The exceptions are the `MONTHS_BETWEEN` function, which returns a number, and the `ROUND` and `TRUNC` functions, which do not accept timestamp or interval values at all.
The remaining datetime functions were designed to accept any of the three types of data (date, timestamp, and interval) and to return a value of one of these types.
All of the datetime functions that return current system datetime information, such as `SYSDATE`, `SYSTIMESTAMP`, `CURRENT_TIMESTAMP`, and so forth, are evaluated once for each SQL statement, regardless how many times they are referenced in that statement.
The datetime functions are:
- ADD_MONTHS
- CURRENT_DATE
- CURRENT_TIMESTAMP
- DBTIMEZONE
- EXTRACT (datetime)
- FROM_TZ
- LAST_DAY
- LOCALTIMESTAMP
- MONTHS_BETWEEN
- NEW_TIME
- NEXT_DAY
- NUMTODSINTERVAL
- NUMTOYMINTERVAL
- ORA_DST_AFFECTED
- ORA_DST_CONVERT
- ORA_DST_ERROR
- ROUND (date)
- SESSIONTIMEZONE
- SYS_EXTRACT_UTC
- SYSDATE
- SYSTIMESTAMP
- TO_CHAR (datetime)
- TO_DSINTERVAL
- TO_TIMESTAMP
- TO_TIMESTAMP_TZ
- TO_YMINTERVAL
- TRUNC (date)
- TZ_OFFSET
## General Comparison Functions
The general comparison functions determine the greatest and or least value from a set of values. The general comparison functions are:
- GREATEST
- LEAST
## Conversion Functions
Conversion functions convert a value from one data type to another. Generally, the form of the function names follows the convention *datatype* `TO` *datatype*. The first data type is the input data type. The second data type is the output data type. The SQL conversion functions are:
- ASCIISTR
- BIN_TO_NUM
- CAST
- CHARTOROWID
- COMPOSE
- CONVERT
- DECOMPOSE
- HEXTORAW
- NUMTODSINTERVAL
- NUMTOYMINTERVAL
- RAWTOHEX
- RAWTONHEX
- ROWIDTOCHAR
- ROWIDTONCHAR
- SCN_TO_TIMESTAMP
- TIMESTAMP_TO_SCN
- TO_BINARY_DOUBLE
- TO_BINARY_FLOAT
- TO_BLOB (bfile)
- TO_BLOB (raw)
- TO_CHAR (bfile\blob)
- TO_CHAR (character)
- TO_CHAR (datetime)
- TO_CHAR (number)
- TO_CLOB (bfile\blob)
- TO_CLOB (character)
- TO_DATE
- TO_DSINTERVAL
- TO_LOB
- TO_MULTI_BYTE
- TO_NCHAR (character)
- TO_NCHAR (datetime)
- TO_NCHAR (number)
- TO_NCLOB
- TO_NUMBER
- TO_SINGLE_BYTE
- TO_TIMESTAMP
- TO_TIMESTAMP_TZ
- TO_YMINTERVAL
- TREAT
- UNISTR
- VALIDATE_CONVERSION
## Large Object Functions
The large object functions operate on LOBs. The large object functions are:
- BFILENAME
- EMPTY_BLOB, EMPTY_CLOB
## Collection Functions
The collection functions operate on nested tables and varrays. The SQL collection functions are:
- CARDINALITY
- COLLECT
- POWERMULTISET
- POWERMULTISET_BY_CARDINALITY
- SET
## Hierarchical Functions
Hierarchical functions applies hierarchical path information to a result set. The hierarchical function is:
  - SYS_CONNECT_BY_PATH
## Data Mining Functions
The data mining functions use Oracle Advanced Analytics to score data. The functions can apply a mining model schema object to the data, or they can dynamically mine the data by executing an analytic clause. The data mining functions can be applied to models built using the native algorithms of Oracle, as well as those built using R through the extensibility mechanism of Oracle Advanced Analytics.
The data mining functions are:
- CLUSTER_DETAILS
- CLUSTER_DISTANCE
- CLUSTER_ID
- CLUSTER_PROBABILITY
- CLUSTER_SET
- FEATURE_COMPARE
- FEATURE_DETAILS
- FEATURE_ID
- FEATURE_SET
- FEATURE_VALUE
- ORA_DM_PARTITION_NAME
- PREDICTION
- PREDICTION_BOUNDS
- PREDICTION_COST
- PREDICTION_DETAILS
- PREDICTION_PROBABILITY
- PREDICTION_SET
**See Also:**
**
- Oracle Data Mining Concepts to learn about Oracle Data Mining
**
- Oracle Data Mining User’s Guide for information about scoring
## XML Functions
The XML functions operate on or return XML documents or fragments. These functions use arguments that are not defined as part of the ANSI/ISO/IEC SQL Standard but are defined as part of the World Wide Web Consortium (W3C) standards. The processing and operations that the functions perform are defined by the relevant W3C standards. The table below provides a link to the appropriate section of the W3C standard for the rules and guidelines that apply to each of these XML-related arguments. A SQL statement that uses one of these XML functions, where any of the arguments does not conform to the relevant W3C syntax, will result in an error. Of special note is the fact that not every character that is allowed in the value of a database column is considered legal in XML.

| Syntax Element | W3C Standard URL |
|---|---|
| value_expr | http://www.w3.org/TR/2006/REC-xml-20060816 |
| Xpath_string | http://www.w3.org/TR/1999/REC-xpath-19991116 |
| XQuery_string | http://www.w3.org/TR/2007/REC-xquery-semantics-20070123/http://www.w3.org/TR/xquery-update-10/ |
| namespace_string | http://www.w3.org/TR/2006/REC-xml-names-20060816/ |
| identifier | http://www.w3.org/TR/2006/REC-xml-20060816/#NT-Nmtoken |

For more information about selecting and querying XML data using these functions, including information on formatting output, refer to *Oracle XML DB Developer’s Guide*
The SQL XML functions are:
- DEPTH
- EXISTSNODE
- EXTRACT (XML)
- EXTRACTVALUE
- PATH
- SYS_DBURIGEN
- SYS_XMLAGG
- SYS_XMLGEN
- XMLAGG
- XMLCAST
- XMLCDATA
- XMLCOLATTVAL
- XMLCOMMENT
- XMLCONCAT
- XMLDIFF
- XMLELEMENT
- XMLEXISTS
- XMLFOREST
- XMLISVALID
- XMLPARSE
- XMLPATCH
- XMLPI
- XMLQUERY
- XMLROOT
- XMLSEQUENCE
- XMLSERIALIZE
- XMLTABLE
- XMLTRANSFORM
## JSON Functions
JavaScript Object Notation (JSON) functions allow you to query and generate JSON data.
The following SQL/JSON functions allow you to query JSON data:
- JSON_QUERY
- JSON_TABLE
- JSON_VALUE
The following SQL/JSON functions allow you to generate JSON data:
- JSON_ARRAY
- JSON_ARRAYAGG
- JSON_OBJECT
- JSON_OBJECTAGG
The following Oracle SQL function creates a JSON data guide:
  - JSON_DATAGUIDE
## Encoding and Decoding Functions
The encoding and decoding functions let you inspect and decode data in the database. The encoding and decoding functions are:
- DECODE
- DUMP
- ORA_HASH
- STANDARD_HASH
- VSIZE
## NULL-Related Functions
The `NULL`-related functions facilitate null handling. The `NULL`-related functions are:
- COALESCE
- LNNVL
- NANVL
- NULLIF
- NVL
- NVL2
## Environment and Identifier Functions
The environment and identifier functions provide information about the instance and session. The environment and identifier functions are:
- CON_DBID_TO_ID
- CON_GUID_TO_ID
- CON_NAME_TO_ID
- CON_UID_TO_ID
- ORA_INVOKING_USER
- ORA_INVOKING_USERID
- SYS_CONTEXT
- SYS_GUID
- SYS_TYPEID
- UID
- USER
- USERENV
