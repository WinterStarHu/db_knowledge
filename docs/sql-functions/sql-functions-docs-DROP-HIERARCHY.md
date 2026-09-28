# DROP HIERARCHY

## Purpose
Use the `DROP` `HIERARCHY` statement to drop a hierarchy. A `HIERARCHY` object is a component of analytic views.
## Prerequisites
To drop a hierarchy in your own schema, you must have the `DROP` `HIERARCHY` system privilege. To drop a hierarchy in another user’s schema, you must have the `DROP` `ANY` `HIERARCHY` system privilege.
## Syntax
## *drop_hierarchy*::=
Description of the illustration drop_hierarchy.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to drop an existing hierarchy.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema in which the hierarchy exists. If you do not specify a schema, then Oracle Database looks for the hierarchy in your own schema.
## *hierarchy_name*
Specify the name of the hierarchy to drop.
## Example
The following statement drops the specified hierarchy object:
```
DROP HIERARCHY product_hier;
```
