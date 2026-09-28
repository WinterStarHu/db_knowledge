# OBJECT_VALUE Pseudocolumn

The `OBJECT_VALUE` pseudocolumn returns system-generated names for the columns of an object table, `XMLType` table, object view, or `XMLType` view. This pseudocolumn is useful for identifying the value of a substitutable row in an object table and for creating object views with the `WITH` `OBJECT` `IDENTIFIER` clause.
**Note:**   In earlier releases, this pseudocolumn was called `SYS_NC_ROWINFO$`. That name is still supported for backward compatibility. However, Oracle recommends that you use the more intuitive name `OBJECT_VALUE`.
**See Also:** ****
- object_table and object_view_clause for more information on the use of this pseudocolumn
**
- Oracle Database Object-Relational Developer’s Guide for examples of the use of this pseudocolumn
