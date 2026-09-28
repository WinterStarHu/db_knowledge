# SQL For JSON Conditions

SQL for JSON conditions allow you to test JavaScript Object Notation (JSON) data as follows:
- IS JSON Condition lets you test whether an expression is syntactically correct JSON data
- JSON_EXISTS Condition lets you test whether a specified JSON value exists in JSON data
- JSON_TEXTCONTAINS Condition lets you test whether a specified character string exists in JSON property values.
- JSON_EQUAL Condition tests whether two JSON values are the same.
## *JSON_condition*::=
Description of the illustration json_condition.gif Description of the illustration json_condition.eps
## IS JSON Condition
Use this SQL/JSON condition to test whether an expression is syntactically correct, or well-formed, JSON data.
````````
- If you specify IS JSON, then this condition returns TRUE if the expression is well-formed JSON data and FALSE if the expression is not well-formed JSON data.
``````````
- If you specify IS NOT JSON, then this condition returns TRUE if the expression is not well-formed JSON data and FALSE if the expression is well-formed JSON data.
***is_JSON_condition*::=** Description of the illustration is_json_condition.gif Description of the illustration is_json_condition.eps ****``````**
- Use expr to specify the JSON data to be evaluated. Specify an expression that evaluates to a text literal. If expr is a column, then the column must be of data type VARCHAR2, CLOB, or BLOB. If expr evaluates to null or a text literal of length zero, then this condition returns UNKNOWN.
````**
- You must specify FORMAT JSON if expr is a column of data type BLOB.
``````**
- If you specify STRICT, then this condition considers only strict JSON syntax to be well-formed JSON data. If you specify LAX, then this condition also considers lax JSON syntax to be well-formed JSON data. The default is LAX. Refer to Oracle Database JSON Developer’s Guide for more information on strict and lax JSON syntax.
``````````````````````````````
- If you specify WITH UNIQUE KEYS, then this condition considers JSON data to be well-formed only if key names are unique within each object. If you specify WITHOUT UNIQUE KEYS, then this condition considers JSON data to be well-formed even if duplicate key names occur within an object. A WITHOUT UNIQUE KEYS test performs faster than a WITH UNIQUE KEYS test. The default is WITHOUT UNIQUE KEYS.
**Examples**
**Testing for STRICT or LAX JSON Syntax: Example**
The following statement creates table `t` with column `col1`:
```
CREATE TABLE t (col1 VARCHAR2(100));
```
The following statements insert values into column `col1` of table `t`:
```
INSERT INTO t VALUES ( '[ "LIT192", "CS141", "HIS160" ]' );
INSERT INTO t VALUES ( '{ "Name": "John" }' );
INSERT INTO t VALUES ( '{ "Grade Values" : { A : 4.0, B : 3.0, C : 2.0 } }');
INSERT INTO t VALUES ( '{ "isEnrolled" : true }' );
INSERT INTO t VALUES ( '{ "isMatriculated" : False }' );
INSERT INTO t VALUES (NULL);
INSERT INTO t VALUES ('This is not well-formed JSON data');
```
The following statement queries table `t` and returns `col1` values that are well-formed JSON data. Because neither the `STRICT` nor `LAX` keyword is specified, this example uses the default `LAX` setting. Therefore, this query returns values that use strict or lax JSON syntax.
```
SELECT col1 FROM t WHERE col1 IS JSON;
COL1
-------------------------------------------------- [ "LIT192", "CS141", "HIS160" ]
{ "Name": "John" } { "Grade Values" : { A : 4.0, B : 3.0, C : 2.0 } } { "isEnrolled" : true } { "isMatriculated" : False }
```
The following statement queries table `t` and returns `col1` values that are well-formed JSON data. This example specifies the `STRICT` setting. Therefore, this query returns only values that use strict JSON syntax.
```
SELECT col1 FROM t WHERE col1 IS JSON STRICT;
COL1
-------------------------------------------------- [ "LIT192", "CS141", "HIS160" ]
{ "Name": "John" } { "isEnrolled" : true }
```
The following statement queries table `t` and returns `col1` values that use lax JSON syntax, but omits `col1` values that use strict JSON syntax. Therefore, this query returns only values that contain the exceptions allowed in lax JSON syntax.
```
SELECT col1 FROM t WHERE col1 IS NOT JSON STRICT AND col1 IS JSON LAX;
COL1
--------------------------------------------------
{ "Grade Values" : { A : 4.0, B : 3.0, C : 2.0 } } { "isMatriculated" : False }
```
**Testing for Unique Keys: Example**
The following statement creates table `t` with column `col1`:
```
CREATE TABLE t (col1 VARCHAR2(100));
```
The following statements insert values into column `col1` of table `t`:
```
INSERT INTO t VALUES ('{a:100, b:200, c:300}');
INSERT INTO t VALUES ('{a:100, a:200, b:300}');
INSERT INTO t VALUES ('{a:100, b : {a:100, c:300}}');
```
The following statement queries table t and returns `col1` values that are well-formed JSON data with unique key names within each object:
```
SELECT col1 FROM t WHERE col1 IS JSON WITH UNIQUE KEYS;
COL1
---------------------------
{a:100, b:200, c:300} {a:100, b : {a:100, c:300}}
```
The second row is returned because, while the key name `a` appears twice, it is in two different objects.
The following statement queries table `t` and returns `col1` values that are well-formed JSON data, regardless of whether there are unique key names within each object:
```
SELECT col1 FROM t WHERE col1 IS JSON WITHOUT UNIQUE KEYS;
COL1
---------------------------
{a:100, b:200, c:300} {a:100, a:200, b:300} {a:100, b : {a:100, c:300}}
```
**Using IS JSON as a Check Constraint: Example**
The following statement creates table `j_purchaseorder`, which will store JSON data in column `po_document`. The statement uses the `IS` `JSON` condition as a check constraint to ensure that only well-formed JSON is stored in column `po_document`.
```
CREATE TABLE j_purchaseorder (id RAW (16) NOT NULL, date_loaded TIMESTAMP(6) WITH TIME ZONE, po_document CLOB CONSTRAINT ensure_json CHECK (po_document IS JSON));
```
## JSON_EQUAL Condition
**Syntax**
Description of the illustration json_equal_condition.eps
**Purpose**
The Oracle SQL condition `JSON_EQUAL` compares two `JSON` values and returns true if they are equal. It returns false if the two values are not equal. The input values must be valid `JSON` data.
The comparison ignores insignificant whitespace and insignificant object member order. For example, `JSON` objects are equal, if they have the same members, regardless of their order.
If either of the two compared inputs has one or more duplicate fields, then the value returned by `JSON_EQUAL` is unspecified.
`JSON_EQUAL` supports `ERROR ON ERROR`, `FALSE ON ERROR`, and `TRUE ON ERROR`. The default is `FALSE ON ERROR`. A typical example of an error is when the input expression is not valid `JSON`.
**Examples**
The following statements return TRUE:
```
JSON_EQUAL('{}', '{ }')
```
```
JSON_EQUAL('{a:1, b:2}', '{b:2 , a:1 }')
```
The following statement return FALSE:
```
JSON_EQUAL('{a:"1"}', '{a:1 }') -> FALSE
```
The following statement results in a `ORA-40441` `JSON` syntax error
```
JSON_EQUAL('[1]', '[}' ERROR ON ERROR)
```
**See Also:**
    **- Oracle Database JSON Developer’s Guide for more information.
## JSON_EXISTS Condition
Use the SQL/JSON condition `JSON_EXISTS` to test whether a specified JSON value exists in JSON data. This condition returns `TRUE` if the JSON value exists and `FALSE` if the JSON value does not exist.
***JSON_exists_condition*::=**
Description of the illustration json_exists_condition.gif
Description of the illustration json_exists_condition.eps
(*JSON_basic_path_expression*: See *Oracle Database JSON Developer’s Guide*)
***JSON_passing_clause*::=**
Description of the illustration json_passing_clause.eps
***JSON_exists_on_error_clause*::=**
Description of the illustration json_exists_on_error_clause.gif
Description of the illustration json_exists_on_error_clause.eps
***JSON_exists_on_empty_clause*::=**
Description of the illustration json_exists_on_empty_clause.gif
Description of the illustration json_exists_on_empty_clause.eps
***expr***
Use this clause to specify the JSON data to be evaluated. For *expr*, specify an expression that evaluates to a text literal. If *expr* is a column, then the column must be of data type `VARCHAR2`, `CLOB`, or `BLOB`. If *expr* evaluates to null or a text literal of length zero, then the condition returns `UNKNOWN`.
If *expr* is not a text literal of well-formed JSON data using strict or lax syntax, then the condition returns `FALSE` by default. You can use the *JSON_exists_on_error_clause* to override this default behavior. Refer to the *JSON_exists_on_error_clause*.
**FORMAT JSON**
You must specify `FORMAT` `JSON` if *expr* is a column of data type `BLOB`.
***JSON_basic_path_expression***
Use this clause to specify a SQL/JSON path expression. The condition uses the path expression to evaluate *expr* and determine if a JSON value that matches, or satisfies, the path expression exists. The path expression must be a text literal, but it can contain variables whose values are passed to the path expression by the *JSON_passing_clause*. See *Oracle Database JSON Developer’s Guide* for the full semantics of *JSON_basic_path_expression*.
***JSON_passing_clause***
Use this clause to pass values to the path expression. For *expr*, specify a value of data type `VARCHAR2`, `NUMBER`, `BINARY_DOUBLE`, `DATE`, `TIMESTAMP`, or `TIMESTAMP` `WITH` `TIME` `ZONE`. The result of evaluating *expr* is bound to the corresponding identifier in the *JSON_basic_path_expression*.
***JSON_exists_on_error_clause***
Use this clause to specify the value returned by this condition when *expr* is not well-formed JSON data.
You can specify the following clauses:
``````**
- ERROR ON ERROR - Returns the appropriate Oracle error when expr is not well-formed JSON data.
````````**
- TRUE ON ERROR - Returns TRUE when expr is not well-formed JSON data.
````````**
- FALSE ON ERROR - Returns FALSE when expr is not well-formed JSON data. This is the default.
***JSON_exists_on_empty_clause*** Use this clause to specify the value returned by this function if no match is found when the JSON data is evaluated using the SQL/JSON path expression. This clause allows you to specify a different outcome for this type of error than the outcome specified with the *JSON_exists_on_error_clause.* You can specify the following clauses:
``````
- NULL ON EMPTY - Returns null when no match is found.
``````
- ERROR ON EMPTY - Returns the appropriate Oracle error when no match is found.
**````****
- DEFAULT literal ON EMPTY - Returns literal when no match is found. The data type of literal must match the data type of the value returned by this function.
If you omit this clause, then the *JSON_exists_on_error_clause* determines the value returned when no match is found.
**Examples** The following statement creates table `t` with column `name`:
```
CREATE TABLE t (name VARCHAR2(100));
```
The following statements insert values into column `name` of table `t`:
```
INSERT INTO t VALUES ('[{first:"John"}, {middle:"Mark"}, {last:"Smith"}]');
INSERT INTO t VALUES ('[{first:"Mary"}, {last:"Jones"}]');
INSERT INTO t VALUES ('[{first:"Jeff"}, {last:"Williams"}]');
INSERT INTO t VALUES ('[{first:"Jean"}, {middle:"Anne"}, {last:"Brown"}]');
INSERT INTO t VALUES (NULL);
INSERT INTO t VALUES ('This is not well-formed JSON data');
```
The following statement queries column `name` in table `t` and returns JSON data that consists of an array whose first element is an object with property name `first`. The `ON` `ERROR` clause is not specified. Therefore, the `JSON_EXISTS` condition returns `FALSE` for values that are not well-formed JSON data.
```
SELECT name FROM t
  WHERE JSON_EXISTS(name, '$[0].first');
NAME
-------------------------------------------------- [{first:"John"}, {middle:"Mark"}, {last:"Smith"}]
[{first:"Mary"}, {last:"Jones"}]
[{first:"Jeff"}, {last:"Williams"}]
[{first:"Jean"}, {middle:"Anne"}, {last:"Brown"}]
```
The following statement queries column `name` in table `t` and returns JSON data that consists of an array whose second element is an object with property name `middle`. The `ON` `ERROR` clause is not specified. Therefore, the `JSON_EXISTS` condition returns `FALSE` for values that are not well-formed JSON data.
```
SELECT name FROM t
  WHERE JSON_EXISTS(name, '$[1].middle');
NAME
-------------------------------------------------------------------------------- [{first:"John"}, {middle:"Mark"}, {last:"Smith"}]
[{first:"Jean"}, {middle:"Anne"}, {last:"Brown"}]
```
The following statement is similar to the previous statement, except that the `TRUE` `ON` `ERROR` clause is specified. Therefore, the `JSON_EXISTS` condition returns `TRUE` for values that are not well-formed JSON data.
```
SELECT name FROM t
  WHERE JSON_EXISTS(name, '$[1].middle' TRUE ON ERROR);
NAME
-------------------------------------------------------------------------------- [{first:"John"}, {middle:"Mark"}, {last:"Smith"}]
[{first:"Jean"}, {middle:"Anne"}, {last:"Brown"}]
This is not well-formed JSON data
```
The following statement queries column `name` in table `t` and returns JSON data that consists of an array that contains an element that is an object with property name `last`. The wildcard symbol (`*`) is specified for the array index. Therefore, the query returns arrays that contain such an object, regardless of its index number in the array.
```
SELECT name FROM t
  WHERE JSON_EXISTS(name, '$[*].last');
NAME
-------------------------------------------------- [{first:"John"}, {middle:"Mark"}, {last:"Smith"}]
[{first:"Mary"}, {last:"Jones"}]
[{first:"Jeff"}, {last:"Williams"}]
[{first:"Jean"}, {middle:"Anne"}, {last:"Brown"}]
```
The following statement performs a filter expression using the passing clause. The SQL/JSON variable *$var1* in the comparison predicate `(@.middle == $var1) ` gets its value from the bind variable *var1* of the `PASSING` clause.
Using bind variables for value comparisons avoids query re-compilation.
```
SELECT name FROM t
  WHERE JSON_EXISTS(name, '$[1]?(@.middle == $var1)' PASSING 'Anne' as "var1");
NAME
--------------------------------------------------------------------------------
[{first:"Jean"}, {middle:"Anne"}, {last:"Brown"}]
```
**See Also:**   Condition JSON_EXISTS
## JSON_TEXTCONTAINS Condition
Use the SQL/JSON condition `JSON_TEXTCONTAINS` to test whether a specified character string exists in JSON property values. You can use this condition to filter JSON data on a specific word or number.
This condition takes the following arguments:
********
- A table or view column that contains JSON data. A JSON search index, which is an Oracle Text index designed specifically for use with JSON data, must be defined on the column. Each row of JSON data in the column is referred to as a JSON document.
- A SQL/JSON path expression. The path expression is applied to each JSON document in an attempt to match a specific JSON object within the document. The path expression can contain only JSON object steps; it cannot contain JSON array steps.
- A character string. The condition searches for the character string in all of the string and numeric property values in the matched JSON object, including array values. The string must exist as a separate word in the property value. For example, if you search for ‘beth’, then a match will be found for string property value “beth smith”, but not for “elizabeth smith”. If you search for ‘10’, then a match will be found for numeric property value 10 or string property value “10 main street”, but a match will not be found for numeric property value 110 or string property value “102 main street”.
This condition returns `TRUE` if a match is found, and `FALSE` if a match is not found.
**See Also:**   JSON Full text search queries ***JSON_textcontains_condition*::=** Description of the illustration json_textcontains_condition.gif Description of the illustration json_textcontains_condition.eps (*JSON_basic_path_expression*: See *Oracle Database JSON Developer’s Guide*) ***column*** Specify the name of the table or view column containing the JSON data to be tested. The column must be of data type `VARCHAR2`, `CLOB`, or `BLOB`. A JSON search index, which is an Oracle Text index designed specifically for use with JSON data, must be defined on the column. If a column value is a null or a text literal of length zero, then the condition returns `UNKNOWN`.
If a column value is not a text literal of well-formed JSON data using strict or lax syntax, then the condition returns `FALSE`.
***JSON_basic_path_expression*** Use this clause to specify a SQL/JSON path expression. The condition uses the path expression to evaluate *column* and determine if a JSON value that matches, or satisfies, the path expression exists. The path expression must be a text literal. See *Oracle Database JSON Developer’s Guide* for the full semantics of *JSON_basic_path_expression*.
***string*** The condition searches for the character string specified by *string*. The string must be enclosed in single quotation marks.
**Examples** The following statement creates table `families` with column `family_doc`:
```
CREATE TABLE families (family_doc VARCHAR2(200));
```
The following statement creates a JSON search index on column `family_doc`:
```
CREATE INDEX ix
  ON families(family_doc)
  INDEXTYPE IS CTXSYS.CONTEXT
  PARAMETERS ('SECTION GROUP CTXSYS.JSON_SECTION_GROUP SYNC (ON COMMIT)');
```
The following statements insert JSON documents that describe families into column `family_doc`:
```
INSERT INTO families
VALUES ('{family : {id:10, ages:[40,38,12], address : {street : "10 Main Street"}}}');
INSERT INTO families
VALUES ('{family : {id:11, ages:[42,40,10,5], address : {street : "200 East Street", apt : 20}}}');
INSERT INTO families
VALUES ('{family : {id:12, ages:[25,23], address : {street : "300 Oak Street", apt : 10}}}');
```
The following statement commits the transaction:
```
COMMIT;
```
The following query returns the JSON documents that contain `10` in any property value in the document:
```
SELECT family_doc FROM families
  WHERE JSON_TEXTCONTAINS(family_doc, '$', '10');
FAMILY_DOC
--------------------------------------------------------------------------------
{family : {id:10, ages:[40,38,12], address : {street : "10 Main Street"}}}
{family : {id:11, ages:[42,40,10,5], address : {street : "200 East Street", apt : 20}}}
{family : {id:12, ages:[25,23], address : {street : "300 Oak Street", apt : 10}}}
```
The following query returns the JSON documents that contain 10 in the `id` property value:
```
SELECT family_doc FROM families
  where json_textcontains(family_doc, '$.family.id', '10');
FAMILY_DOC
--------------------------------------------------------------------------------
{family : {id:10, ages:[40,38,12], address : {street : "10 Main Street"}}}
```
The following query returns the JSON documents that have a 10 in the array of values for the `ages` property:
```
SELECT family_doc FROM families
  WHERE JSON_TEXTCONTAINS(family_doc, '$.family.ages', '10');
FAMILY_DOC
--------------------------------------------------------------------------------
{family : {id:11, ages:[42,40,10,5], address : {street : "200 East Street", apt : 20}}}
```
The following query returns the JSON documents that have a 10 in the `address` property value:
```
SELECT family_doc FROM families
  WHERE JSON_TEXTCONTAINS(family_doc, '$.family.address', '10');
FAMILY_DOC
--------------------------------------------------------------------------------
{family : {id:10, ages:[40,38,12], address : {street : "10 Main Street"}}}
{family : {id:12, ages:[25,23], address : {street : "300 Oak Street", apt : 10}}}
```
The following query returns the JSON documents that have a 10 in the `apt` property value:
```
SELECT family_doc FROM families
  WHERE JSON_TEXTCONTAINS(family_doc, '$.family.address.apt', '10');
FAMILY_DOC
--------------------------------------------------------------------------------
{family : {id:12, ages:[25,23], address : {street : "300 Oak Street", apt : 10}}}
```
