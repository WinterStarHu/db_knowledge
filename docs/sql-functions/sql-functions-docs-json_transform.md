# JSON_TRANSFORM

## Syntax
Description of the illustration json_transform.gif Description of the illustration json_transform.eps
## *JSON_TRANSFORM_returning_clause*::=
Description of the illustration json_transform_returning_clause.eps
## *JSON_passing_clause*::=
For details on *JSON_passing_clause* see JSON_EXISTS Condition.
## *operation*::=
Description of the illustration operation.gif Description of the illustration operation.eps
## *removeOp*::=
Description of the illustration remove_op.gif Description of the illustration remove_op.eps
## *insertOp*::=
Description of the illustration insert_op.gif Description of the illustration insert_op.eps
## *replaceOp*::=
Description of the illustration replace_op.gif Description of the illustration replace_op.eps
## *rhsExpr*::=
Description of the illustration rhs_expr.gif Description of the illustration rhs_expr.eps
## *appendOp*::=
Description of the illustration append_op.gif Description of the illustration append_op.eps
## *setOp*::=
Description of the illustration set_op.gif Description of the illustration set_op.eps
## *renameOp*::=
Description of the illustration rename_op.gif Description of the illustration rename_op.eps
## *keepOp*::=
Description of the illustration keep_op.gif Description of the illustration keep_op.eps
## Purpose
Use *JSON_TRANSFORM* to modify JSON documents input to the function. You can change the JSON document (or pieces of the JSON document), by specifying one or more modifying operations that perform changes to the JSON data. The modified JSON document is returned as output.
You can input any SQL data type that supports JSON data. For example, the input can be a `VARCHAR2` column with or without an `IS JSON` check constraint, or a function call returning JSON data.
## Examples
**Example 1 : Update a JSON Column with a Timestamp**
```
UPDATE t SET jcol = JSON_TRANSFORM(jcol, SET '$.lastUpdated' = SYSTIMESTAMP)
```
**Example 2 : Remove a Social Security Number before Shipping JSON to a Client**
```
SELECT JSON_TRANSFORM (jcol, REMOVE '$.ssn') FROM t WHERE ...
```
## *JSON_TRANSFORM_returning_clause*
The default output data type matches the data type of the input.
For input data type `VARCHAR2` of any size, the default output data type is `VARCHAR2(4000)`.
For a fuller discussion of *JSON_TRANSFORM* with examples, see Oracle SQL Function JSON_TRANSFORM.
