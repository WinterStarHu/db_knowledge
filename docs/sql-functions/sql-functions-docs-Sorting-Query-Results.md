# Sorting Query Results

Use the `ORDER` `BY` clause to order the rows selected by a query. Sorting by position is useful in the following cases:
````
- To order by a lengthy select list expression, you can specify its position in the ORDER BY clause rather than duplicate the entire expression.
``````````````````````
- For compound queries containing set operators UNION, INTERSECT, MINUS, or UNION ALL, the ORDER BY clause must specify positions or aliases rather than explicit expressions. Also, the ORDER BY clause can appear only in the last component query. The ORDER BY clause orders all rows returned by the entire compound query.
The ordering method by which Oracle Database sorts character values for the `ORDER BY` clause, also known as the collation, is determined for each `ORDER BY` clause expression separately using the collation derivation rules.
If the determined collation of an expression is not the collation `BINARY`, then the character values are compared linguistically. In this case, they are first transformed to collation keys and then compared like `RAW` values. The collation keys are generated implicitly using the same method that the SQL function `NLSSORT` uses. Generated collation keys are subject to the same restrictions that are described in “`NLSSORT`”. As a result of these restrictions, if the initialization parameter `MAX_STRING_SIZE` is set to `STANDARD`, two values may compare as linguistically equal if they do not differ in the prefix that was used to produce the collation key, even if they differ in the rest of the value. If the parameter’s value is `EXTENDED`, then the error “`ORA-12742: unable to create the collation key`” may be reported under certain circumstances. See the links below for further information on the restrictions.
**See Also:**
- Collation Derivation
- Linguistic Sorting and Matching
- Default Values for NLS Parameters in SQL Functions
- NLSSORT
