# JSON Object Access Expressions

A JSON object access expression is used only when querying a column of JavaScript Object Notation (JSON) data. It yields a character string that contains one or more JSON values found in that data. The syntax for this type of expression is called dot-notation syntax.
## *JSON_object_access_expr*::=
Description of the illustration json_object_access_expr.eps
## *array_step*::=
Description of the illustration array_step.eps **
- For table_alias, specify the alias for the table that contains the column of JSON data. This table alias is required and must be assigned to the table elsewhere in the SQL statement.
**``````````
- For JSON_column, specify the name of the column of JSON data. The column must be of data type VARCHAR2, CLOB, or BLOB and an IS JSON check constraint must be defined on the column.
********
- You can optionally specify one or more JSON object keys. The object keys allow you to target specific JSON values in the JSON data. The first JSON_object_key must be a case-sensitive match to the key (property) name of an object member in the top level of the JSON data. If the value of that object member is another JSON object, then you can specify a second JSON_object_key that matches the key name of a member of that object, and so on. If a JSON array is encountered during any of these iterations, and you do not specify an array_step, then the array is implicitly unwrapped and the elements of the array are evaluated using the JSON_object_key.
** **********
  - Use integer to specify the element at index integer in a JSON array. Use integer TO integer to specify the range of elements between the two index integer values, inclusive. If the specified elements exist in the JSON array being evaluated, then the array step results in a match to those elements. Otherwise, the array step does not result in a match. The first element in a JSON array has index 0.
  - Use the asterisk wildcard symbol (*) to specify all elements in a JSON array. If the JSON array being evaluated contains at least one element, then the array step results in a match to all elements in the JSON array. Otherwise, the array step does not result in a match.
A JSON object access expression yields a character string of data type `VARCHAR2(4000)`, which contains the targeted JSON value(s) as follows:
- For a single targeted value, the character string contains that value, whether it is a JSON scalar value, object, or array.
- For multiple targeted values, the character string contains a JSON array whose elements are those values.
If you omit *JSON_object_key*, then the expression yields a character string that contains the JSON data in its entirety. In this case, the character string is of the same data type as the column of JSON data being queried.
A JSON object access expression cannot return a value larger than 4K bytes. If the value surpasses this limit, then the expression returns null. To obtain the actual value, instead use the JSON_QUERY function or the JSON_VALUE function and specify an appropriate return type with the `RETURNING` clause.
The collation derivation rules for the JSON object access expression are the same as for the `JSON_QUERY` function.
**See Also:**   in *Oracle Database Globalization Support Guide* for the collation derivation rules for the `JSON_QUERY` function
## Examples
The following examples use the `j_purchaseorder` table, which is created in Creating a Table That Contains a JSON Document: Example. This table contains a column of JSON data called `po_document`. These examples return JSON values from column `po_document`.
The following statement returns the value of the property with key name `PONumber`:
```
SELECT po.po_document.PONumber
  FROM j_purchaseorder po;
PONumber
--------
1600
```
The following statement first targets the property with key name `ShippingInstructions`, whose value is a JSON object. The statement then targets the property with key name `Phone` within that object. The statement returns the value of `Phone`, which is a JSON array.
```
SELECT po.po_document.ShippingInstructions.Phone
  FROM j_purchaseorder po;
SHIPPINGINSTRUCTIONS
------------------------------------------------------------------------------------- [{"type":"Office","number":"909-555-7307"},{"type":"Mobile","number":"415-555-1234"}]
```
The following statement first targets the property with key name `LineItems`, whose value is a JSON array. The expression implicitly unwraps the array and evaluates its elements, which are JSON objects. Next, the statement targets the properties with key name `Part`, within the unwrapped objects, and finds two objects. The statement then targets the properties with key name `Description` within those two objects and finds string values. Because more than one value is returned, the values are returned as elements of a JSON array.
```
SELECT po.po_document.LineItems.Part.Description
  FROM j_purchaseorder po;
LINEITEMS
----------------------------------- [One Magic Christmas,Lethal Weapon]
```
**See Also:**   *Oracle Database JSON Developer’s Guide* for more information on querying JSON data using dot-notation syntax
