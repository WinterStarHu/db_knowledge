# ALTER ATTRIBUTE DIMENSION

## Purpose
Use the `ALTER` `ATTRIBUTE` `DIMENSION` statement to rename or compile an attribute dimension. For other alterations, use `CREATE` `OR` `REPLACE` `ATTRIBUTE` `DIMENSION`.
## Prerequisites
To alter an attribute dimension in your own schema, you must have the `ALTER` `ATTRIBUTE` `DIMENSION` system privilege. To alter an attribute dimension in another user’s schema, you must have the `ALTER` `ANY` `ATTRIBUTE` `DIMENSION` system privilege or have been granted `ALTER` on the attribute dimension directly.
## Syntax
## *alter_attribute_dimension*::=
Description of the illustration alter_attribute_dimension.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to alter an existing attribute dimension.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema in which the attribute dimension exists. If you do not specify a schema, then Oracle Database looks for the attribute dimension in your own schema.
## *attr_dim_name*
Specify the name of the attribute dimension.
## RENAME TO
Specify `RENAME` `TO` to change the name of the attribute dimension. For *new_attr_dim_name*, specify a new name for the attribute dimension.
## COMPILE
Specify `COMPILE` to compile the attribute dimension.
## Example
The following statement changes the name of an attribute dimension:
```
ALTER ATTRIBUTE DIMENSION product_attr_dim RENAME TO my_product_attr_dim;
```
