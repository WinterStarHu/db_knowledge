# JSON_TABLE

## Syntax
Description of the illustration json_table.gif Description of the illustration json_table.eps (*JSON_basic_path_expression*: See *Oracle Database JSON Developer’s Guide*, *JSON_table_on_error_clause::=*, *JSON_columns_clause::=*)
## *JSON_table_on_error_clause*::=
Description of the illustration json_table_on_error_clause.gif Description of the illustration json_table_on_error_clause.eps
## *JSON_table_on_empty_clause*::=
Description of the illustration json_table_on_empty_clause.gif Description of the illustration json_table_on_empty_clause.eps
## *JSON_columns_clause*::=
Description of the illustration json_columns_clause.gif Description of the illustration json_columns_clause.eps
## *JSON_column_definition*::=
Description of the illustration json_column_definition.gif Description of the illustration json_column_definition.eps
## *JSON_exists_column*::=
Description of the illustration json_exists_column.gif Description of the illustration json_exists_column.eps (*JSON_value_return_type::=*-part of `JSON_VALUE`, *JSON_basic_path_expression*: See *Oracle Database JSON Developer’s Guide*, *JSON_exists_on_error_clause::=*-part of `JSON_EXISTS`)
## *JSON_query_column*::=
Description of the illustration json_query_column.gif Description of the illustration json_query_column.eps (*JSON_query_return_type::=*, *JSON_query_wrapper_clause::=*, and *JSON_query_on_error_clause::=*-part of `JSON_QUERY`, *JSON_basic_path_expression*: See *Oracle Database JSON Developer’s Guide*)
## *JSON_value_column*::=
Description of the illustration json_value_column.gif Description of the illustration json_value_column.eps (*JSON_value_return_type::=* and *JSON_value_on_error_clause::=*-part of `JSON_VALUE`, *JSON_basic_path_expression*: See *Oracle Database JSON Developer’s Guide*)
## *JSON_nested_path*::=
Description of the illustration json_nested_path.gif Description of the illustration json_nested_path.eps (*JSON_basic_path_expression*: See *Oracle Database JSON Developer’s Guide*, *JSON_columns_clause::=*)
## *ordinality_column*::=
Description of the illustration ordinality_column.gif Description of the illustration ordinality_column.eps
## *JSON_path*::=
Description of the illustration json_path.eps
## *JSON_relative_object_access*::=
Description of the illustration json_relative_object_access.eps
## *nested_clause*::=
Description of the illustration nested_clause.gif Description of the illustration nested_clause.eps
## Purpose
The SQL/JSON function `JSON_TABLE` creates a relational view of JSON data. It maps the result of a JSON data evaluation into relational rows and columns. You can query the result returned by the function as a virtual relational table using SQL. The main purpose of `JSON_TABLE` is to create a row of relational data for each object inside a JSON array and output JSON values from within that object as individual SQL column values.
You must specify `JSON_TABLE` only in the `FROM` clause of a `SELECT` statement. The function first applies a path expression, called a **SQL/JSON** **row** **path** **expression**, to the supplied JSON data. The JSON value that matches the row path expression is called a **row** **source** in that it generates a row of relational data. The `COLUMNS` clause evaluates the row source, finds specific JSON values within the row source, and returns those JSON values as SQL values in individual columns of a row of relational data.
The `COLUMNS` clause enables you to search for JSON values in different ways by using the following clauses:
**``````````
- JSON_exists_column - Evaluates JSON data in the same manner as the JSON_EXISTS condition, that is, determines if a specified JSON value exists, and returns either a VARCHAR2 column of values ‘true’ or ‘false’, or a NUMBER column of values 1 or 0.
**
- JSON_query_column - Evaluates JSON data in the same manner as the JSON_QUERY function, that is, finds one or more specified JSON values, and returns a column of character strings that contain those JSON values.
**
- JSON_value_column - Evaluates JSON data in the same manner as the JSON_VALUE function, that is, finds a specified scalar JSON value, and returns a column of those JSON values as SQL values.
**
- JSON_nested_path - Allows you to flatten JSON values in a nested JSON object or JSON array into individual columns in a single row along with JSON values from the parent object or array. You can use this clause recursively to project data from multiple layers of nested objects or arrays into a single row.
**
- ordinality_column - Returns a column of generated row numbers.
The column definition clauses allow you to specify a name for each column of data that they return. You can reference these column names elsewhere in the `SELECT` statement, such as in the `SELECT` list and the `WHERE` clause.
**See Also:**   in *Oracle Database Globalization Support Guide* for the collation derivation rules, which define the collation assigned to each character data type column in the table generated by `JSON_TABLE`
## *expr*
Use this clause to specify the JSON data to be evaluated. For *expr*, specify an expression that evaluates to a text literal. If *expr* is a column, then the column must be of data type `VARCHAR2`, `CLOB`, or `BLOB`. If *expr* is null, then the function returns null.
If *expr* is not a text literal of well-formed JSON data using strict or lax syntax, then the function returns null by default. You can use the *JSON_table_on_error_clause* to override this default behavior. Refer to *JSON_table_on_error_clause*.
## FORMAT JSON
You must specify `FORMAT` `JSON` if *expr* is a column of data type `BLOB`.
## PATH
Use the `PATH` clause to delineate a portion of the row that you want to use as the column content. The absence of the `PATH` clause does not change the behavior with a path of `'$.'`, where `` is the column name. The name of the object field that is targeted is taken implicitly as the column name. See *Oracle Database JSON Developer’s Guide* for the full semantics of `PATH`.
## *JSON_basic_path_expression*
The *JSON_basic_path_expression* is a text literal. See *Oracle Database JSON Developer’s Guide* for the full semantics of this clause.
## *JSON_relative_object_access*
Specify this row path expression to enable simple dot notation. The value of `JSON_relative_object_access` is evaluated as a JSON/Path expression relative to the current row item.
For more information on the *JSON_object_key clause*, refer to JSON Object Access Expressions .
## *JSON_table_on_error_clause*
Use this clause to specify the value returned by the function when errors occur:
** ****
  - If the input is not well-formed JSONtext, no more rows will be returned as soon as the error is detected. Note that since JSON_TABLE supports streaming evaluation, rows may be returned prior to encountering the portion of the input with the error.
  - If no match is found when the row path expression is evaluated, no rows are returned.
**
  - Sets the default error behavior for all column expressions to NULL ON ERROR
** **
  - If the input is not well-formed JSON text, an error will be raised.
  - If no match is found when the row path expression is evaluated, an error will be raised
**
  - Sets the default error behavior for all column expressions to ERROR ON ERROR
## *JSON_table_on_empty_clause*
Use this clause to specify the value returned by this function if no match is found when the JSON data is evaluated using the SQL/JSON path expression. This clause allows you to specify a different outcome for this type of error than the outcome specified with the *JSON_table_on_error_clause.* You can specify the following clauses:
``````
- NULL ON EMPTY - Returns null when no match is found.
``````
- ERROR ON EMPTY - Returns the appropriate Oracle error when no match is found.
**````****
- DEFAULT literal ON EMPTY - Returns literal when no match is found. The data type of literal must match the data type of the value returned by this function.
If you omit this clause, then the *JSON_table_on_error_clause* determines the value returned when no match is found.
## *JSON_columns_clause*
Use the `COLUMNS` clause to define the columns in the virtual relational table returned by the `JSON_TABLE` function.
Specify `TRUNCATE` if the column has `JSON_VALUE` semantics.
## *JSON_exists_column*
This clause evaluates JSON data in the same manner as the `JSON_EXISTS` condition, that is, it determines if a specified JSON value exists. It returns either a `VARCHAR2` column of values ‘`true`’ or ‘`false`’, or a `NUMBER` column of values 1 or 0.
A value of ‘`true`’ or 1 indicates that the JSON value exists and a value of ‘`false`’ or 0 indicates that the JSON value does not exist.
You can use the *JSON_value_return_type* clause to control the data type of the returned column. If you omit this clause, then the data type is `VARCHAR2(4000)`. Use *column_name* to specify the name of the returned column. The rest of the clauses of *JSON_exists_column* have the same semantics here as they have for the `JSON_EXISTS` condition. For full information on these clauses, refer to “JSON_EXISTS Condition”. Also see “Using JSON_exists_column: Examples” for an example.
## *JSON_query_column*
This clause evaluates JSON data in the same manner as the `JSON_QUERY` function, that is, it finds one or more specified JSON values, and returns a column of character strings that contain those JSON values.
Use *column_name* to specify the name of the returned column. The rest of the clauses of *JSON_query_column* have the same semantics here as they have for the `JSON_QUERY` function. For full information on these clauses, refer to JSON_QUERY. Also see “Using JSON_query_column: Examples” for an example.
## *JSON_value_column*
This clause evaluates JSON data in the same manner as the `JSON_VALUE` function, that is, it finds a specified scalar JSON value, and returns a column of those JSON values as SQL values.
Use *column_name* to specify the name of the returned column. The rest of the clauses of *JSON_value_column* have the same semantics here as they have for the `JSON_VALUE` function. For full information on these clauses, refer to JSON_VALUE. Also see “Using JSON_value_column: Examples” for an example.
## *JSON_nested_path*
Use this clause to flatten JSON values in a nested JSON object or JSON array into individual columns in a single row along with JSON values from the parent object or array. You can use this clause recursively to project data from multiple layers of nested objects or arrays into a single row.
Specify the *JSON_basic_path_expression* clause to match the nested object or array. This path expression is relative to the SQL/JSON row path expression specified in the `JSON_TABLE` function.
Use the `COLUMNS` clause to define the columns of the nested object or array to be returned. This clause is recursive-you can specify the *JSON_nested_path* clause within another *JSON_nested_path* clause. Also see “Using JSON_nested_path: Examples” for an example.
## *ordinality_column*
This clause returns a column of generated row numbers of data type `NUMBER`. You can specify at most one *ordinality_column*. Also see “Using JSON_value_column: Examples” for an example of using the *ordinality_column* clause.
## *nested_clause*
Use the `nested_clause` as a short-hand syntax for mapping JSON values to relational columns. It reuses the syntax of the `JSON_TABLE` columns clause and is essentially equivalent to a left-outer ANSI join with `JSON_TABLE`.
Example 1 using the nested_clause is equivalent to Example 2 using the left-outer join with `JSON_TABLE` .
**Example 1 Nested_Clause**
```
SELECT t.*
FROM j_purchaseOrder
NESTED po_document COLUMNS(PONumber, Reference, Requestor) t;
PONUMBER REFERENCE REQUESTOR
--------------- ------------------------------ -----------------------------
1600 ABULL-20140421 Alexis Bull
```
**Example 2 Left-Outer Join With JSON_TABLE**
```
SELECT t.*
FROM j_purchaseOrder LEFT OUTER JOIN
JSON_TABLE(po_document COLUMNS(PONumber, Reference, Requestor)) t ON 1=1;
```
When using the `nested_clause`, the JSON column name following the `NESTED` keyword will not be included in `SELECT *` expansion. For example:
```
SELECT *
FROM j_purchaseOrder
NESTED po_document.LineItems[*]
COLUMNS(ItemNumber, Quantity NUMBER);
ID DATE_LOADED ITEMN QUANTITY
------------------------ ---------------------------------------- ------- -----------
6C5589E9A9156... 16-MAY-18 08.40.30.397688 AM -07:00 1 9
6C5589E9A9156... 16-MAY-18 08.40.30.397688 AM -07:00 2 5
```
The result does not include the JSON column name `po_document` as one of the columns in the result.
When unnesting JSON column data, the recommendation is to use `LEFT OUTER JOIN` semantics, so that JSON columns that produce no rows will not filter other non-JSON data from the result. For example,a ` j_purchaseOrder` row with a NULL `po_document` column will not filter the possibly non-null relational `columns id` and `date_loaded` from the result.
The columns clause supports all the same features defined for `JSON_TABLE` including nested columns. For example:
```
SELECT t.*
FROM j_purchaseorder
NESTED po_document COLUMNS(PONumber, Reference,
NESTED LineItems[*] COLUMNS(ItemNumber, Quantity)
) t
PONUMBER REFERENCE ITEMN QUANTITY
--------------- ------------------------------ ----- ------------
1600 ABULL-20140421 1 9
1600 ABULL-20140421 2 5
```
## Examples
## Creating a Table That Contains a JSON Document: Example
This example shows how to create and populate table `j_purchaseorder`, which is used in the rest of the `JSON_TABLE` examples in this section.
The following statement creates table `j_purchaseorder`. Column `po_document` is for storing JSON data and, therefore, has an `IS` `JSON` check constraint to ensure that only well-formed JSON is stored in the column.
```
CREATE TABLE j_purchaseorder
  (id RAW (16) NOT NULL,
   date_loaded TIMESTAMP(6) WITH TIME ZONE,
   po_document CLOB CONSTRAINT ensure_json CHECK (po_document IS JSON));
```
The following statement inserts one row, or one JSON document, into table `j_purchaseorder`:
```
INSERT INTO j_purchaseorder
  VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"PONumber"              : 1600,
      "Reference"             : "ABULL-20140421",
       "Requestor"            : "Alexis Bull",
       "User"                 : "ABULL",
       "CostCenter"           : "A50",
       "ShippingInstructions" : {"name"   : "Alexis Bull",
                                 "Address": {"street"   : "200 Sporting Green",
                                              "city"    : "South San Francisco",
                                              "state"   : "CA",
                                              "zipCode" : 99236,
                                              "country" : "United States of America"},
                                 "Phone" : [{"type" : "Office", "number" : "909-555-7307"},
                                            {"type" : "Mobile", "number" : "415-555-1234"}]},
       "Special Instructions" : null,
       "AllowPartialShipment" : true,
       "LineItems" : [{"ItemNumber" : 1,
                       "Part" : {"Description" : "One Magic Christmas",
                                 "UnitPrice"   : 19.95,
                                 "UPCCode"     : 13131092899},
                       "Quantity" : 9.0},
                      {"ItemNumber" : 2,
                       "Part" : {"Description" : "Lethal Weapon",
                                 "UnitPrice"   : 19.95,
                                 "UPCCode"     : 85391628927},
                       "Quantity" : 5.0}]}');
```
## Using*JSON_query_column*: Examples
The statement in this example queries JSON data for a specific JSON property using the *JSON_query_column* clause, and returns the property value in a column.
The statement first applies a SQL/JSON row path expression to column `po_document`, which results in a match to the `ShippingInstructions` property. The `COLUMNS` clause then uses the *JSON_query_column* clause to return the `Phone` property value in a `VARCHAR2(100)` column.
```
SELECT jt.phones
FROM j_purchaseorder,
JSON_TABLE(po_document, '$.ShippingInstructions'
COLUMNS
  (phones VARCHAR2(100) FORMAT JSON PATH '$.Phone')) AS jt;
```
```
PHONES
------------------------------------------------------------------------------------- [{"type":"Office","number":"909-555-7307"},{"type":"Mobile","number":"415-555-1234"}]
```
## Using*JSON_value_column*: Examples
The statement in this example refines the statement in the previous example by querying JSON data for specific JSON values using the *JSON_value_column* clause, and returns the JSON values as SQL values in relational rows and columns.
The statement first applies a SQL/JSON row path expression to column `po_document`, which results in a match to the elements in the JSON array `Phone`. These elements are JSON objects that contain two members named `type` and `number`. The statement uses the `COLUMNS` clause to return the `type` value for each object in a `VARCHAR2(10)` column called `phone_type`, and the `number` value for each object in a `VARCHAR2(20)` column called `phone_num`. The statement also returns an ordinal column named `row_number`.
```
SELECT jt.*
FROM j_purchaseorder,
JSON_TABLE(po_document, '$.ShippingInstructions.Phone[*]'
COLUMNS (row_number FOR ORDINALITY,
         phone_type VARCHAR2(10) PATH '$.type',
         phone_num VARCHAR2(20) PATH '$.number'))
AS jt;
ROW_NUMBER PHONE_TYPE PHONE_NUM
---------- ---------- --------------------
         1 Office     909-555-7307
         2 Mobile     415-555-1234
```
## Using*JSON_exists_column*: Examples
The statements in this example test whether a JSON value exists in JSON data using the *JSON_exists_column* clause. The first example returns the result of the test as a ‘`true`’ or ‘`false`’ value in a column. The second example uses the result of the test in the `WHERE` clause.
The following statement first applies a SQL/JSON row path expression to column `po_document`, which results in a match to the entire context item, or JSON document. It then uses the `COLUMNS` clause to return the requestor’s name and a string value of ‘`true`’ or ‘`false`’ indicating whether the JSON data for that requestor contains a zip code. The `COLUMNS` clause first uses the *JSON_value_column* clause to return the `Requestor` value in a `VARCHAR2(32)` column called `requestor`. It then uses the *JSON_exists_column* clause to determine if the `zipCode` object exists and returns the result in a `VARCHAR2(5)` column called `has_zip`.
```
SELECT requestor, has_zip
FROM j_purchaseorder,
JSON_TABLE(po_document, '$'
COLUMNS
  (requestor VARCHAR2(32) PATH '$.Requestor',
   has_zip VARCHAR2(5) EXISTS PATH '$.ShippingInstructions.Address.zipCode'));
REQUESTOR                        HAS_ZIP
-------------------------------- -------
Alexis Bull                      true
```
The following statement is similar to the previous statement, except that it uses the value of `has_zip` in the `WHERE` clause to determine whether to return the `Requestor` value:
```
SELECT requestor
FROM j_purchaseorder,
JSON_TABLE(po_document, '$'
COLUMNS
  (requestor VARCHAR2(32) PATH '$.Requestor',
   has_zip VARCHAR2(5) EXISTS PATH '$.ShippingInstructions.Address.zipCode'))
WHERE (has_zip = 'true');
REQUESTOR
--------------------------------
Alexis Bull
```
## Using*JSON_nested_path*: Examples
The following two simple statements demonstrate the functionality of the *JSON_nested_path* clause. They operate on a simple JSON array that contains three elements. The first two elements are numbers. The third element is a nested JSON array that contains two string value elements.
The following statement does not use the *JSON_nested_path* clause. It returns the three elements in the array in a single row. The nested array is returned in its entirety.
```
SELECT *
FROM JSON_TABLE('[1,2,["a","b"]]', '$'
COLUMNS (outer_value_0 NUMBER PATH '$[0]',
         outer_value_1 NUMBER PATH '$[1]',
         outer_value_2 VARCHAR2(20) FORMAT JSON PATH '$[2]'));
OUTER_VALUE_0 OUTER_VALUE_1 OUTER_VALUE_2
------------- ------------- --------------------
            1             2 ["a","b"]
```
The following statement is different from the previous statement because it uses the *JSON_nested_path* clause to return the individual elements of the nested array in individual columns in a single row along with the parent array elements.
```
SELECT *
FROM JSON_TABLE('[1,2,["a","b"]]', '$'
COLUMNS (outer_value_0 NUMBER PATH '$[0]',
         outer_value_1 NUMBER PATH '$[1]',
         NESTED PATH '$[2]'
         COLUMNS (nested_value_0 VARCHAR2(1) PATH '$[0]',
                  nested_value_1 VARCHAR2(1) PATH '$[1]')));
OUTER_VALUE_0 OUTER_VALUE_1 NESTED_VALUE_0 NESTED_VALUE_1
------------- ------------- -------------- --------------
            1             2 a              b
```
The previous example shows how to use *JSON_nested_path* with a nested JSON array. The following example shows how to use the *JSON_nested_path* clause with a nested JSON object by returning the individual elements of the nested object in individual columns in a single row along with the parent object elements.
```
SELECT *
FROM JSON_TABLE('{a:100, b:200, c:{d:300, e:400}}', '$'
COLUMNS (outer_value_0 NUMBER PATH '$.a',
         outer_value_1 NUMBER PATH '$.b',
         NESTED PATH '$.c'
         COLUMNS (nested_value_0 NUMBER PATH '$.d',
                  nested_value_1 NUMBER PATH '$.e')));
OUTER_VALUE_0 OUTER_VALUE_1 NESTED_VALUE_0 NESTED_VALUE_1
------------- ------------- -------------- --------------
          100           200            300            400
```
The following statement uses the *JSON_nested_path* clause when querying the `j_purchaseorder` table. It first applies a row path expression to column `po_document`, which results in a match to the entire context item, or JSON document. It then uses the `COLUMNS` clause to return the `Requestor` value in a `VARCHAR2(32)` column called `requestor`. It then uses the *JSON_nested_path* clause to return the property values of the individual objects in each member of the nested `Phone` array. Note that a row is generated for each member of the nested array, and each row contains the corresponding `Requestor` value.
```
SELECT jt.*
FROM j_purchaseorder,
JSON_TABLE(po_document, '$'
COLUMNS
  (requestor VARCHAR2(32) PATH '$.Requestor',
   NESTED PATH '$.ShippingInstructions.Phone[*]'
     COLUMNS (phone_type VARCHAR2(32) PATH '$.type',
              phone_num VARCHAR2(20) PATH '$.number')))
AS jt;
REQUESTOR            PHONE_TYPE           PHONE_NUM
-------------------- -------------------- ---------------
Alexis Bull          Office               909-555-7307
Alexis Bull          Mobile               415-555-1234
```
The following example shows the use of simple dot-notation in `JSON_nested_path` and its equivalent without dot notation.
```
SELECT c.*
FROM customer t,
JSON_TABLE(t.json COLUMNS(
id, name, phone, address,
NESTED orders[*] COLUMNS(
updated, status,
NESTED lineitems[*] COLUMNS(
description, quantity NUMBER, price NUMBER
)
)
)) c;
```
The above statement in dot notation is equivalent to the following one without dot notation:
```
SELECT c.*
FROM customer t,
JSON_TABLE(t.json, '$' COLUMNS(
id PATH '$.id',
name PATH '$.name',
phone PATH '$.phone',
address PATH '$.address',
NESTED PATH '$.orders[*]' COLUMNS(
updated PATH '$.updated',
status PATH '$.status',
NESTED PATH '$.lineitems[*]' COLUMNS(
description PATH '$.description',
quantity NUMBER PATH '$.quantity',
price NUMBER PATH '$.price'
)
)
)) c;
```
