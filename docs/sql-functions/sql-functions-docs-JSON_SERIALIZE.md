# JSON_SERIALIZE

## Syntax
## *json_serialize*
Description of the illustration json_serialize.gif Description of the illustration json_serialize.eps
## Purpose
The `json_serialize` function takes JSON data of any SQL data type ( `VARCHAR2`, `CLOB`, `BLOB` ) as input and returns a textual representation of it. You typically use it to transform the result of a query.
You can use `json_serialize` to convert binary JSON data to textual form (`VARCHAR2` or `CLOB`), or to transform textual JSON data by pretty-printing it or escaping non-ASCII Unicode characters in it.
## *expr*
*expr* is the input expression. Can be any one of type `VARCHAR2`, `CLOB`, or `BLOB`.
## *JSON_returning_clause*
Use the *JSON_returning_clause* to specify the return type. The return type can be one of `VARCHAR2`, `CLOB`, or `BLOB`.
The default return type is `VARCHAR2(4000)`.
If the return type is `RAW` or `BLOB`, it contains `UTF8` encoded JSON text.
## PRETTY
Specify `PRETTY` if you want the result to be formatted for human readability.
## ASCII
Specify `ASCII` if you want non-ASCII characters to be output using JSON escape sequences.
## TRUNCATE
Specify `TRUNCATE`, if you want the textual output in the result document to fit into the buffer of the specified return type.
## *JSON_on_error_clause*
Specify *JSON_on_error_clause* to control the handling of processing errors.
`ERROR ON ERROR` is the default.
`EMPTY ON ERROR` is not supported.
If you specify `TRUNCATE` with *JSON_on_error_clause*, then a value too large for the return type will be truncated to fit into the buffer instead of raising an error.
**Example**
```
SELECT JSON_SERIALIZE ('{a:[1,2,3,4]}' RETURNING VARCHAR2(3) TRUNCATE ERROR ON ERROR) from dual
--------
{"a
```
**See Also:**  Oracle SQL Function JSON_SERIALIZE
