# ALTER HIERARCHY

## Purpose
Use the `ALTER` `HIERARCHY` statement to rename or compile a hierarchy. For other alterations, use `CREATE` `OR` `REPLACE` `HIERARCHY`.
## Prerequisites
To alter a hierarchy in your own schema, you must have the `ALTER` `HIERARCHY` system privilege. To alter a hierarchy in another user’s schema, you must have the `ALTER` `ANY` `HIERARCHY` system privilege or have been granted `ALTER` directly on the hierarchy.
## Syntax
## *alter_hierarchy*::=
Description of the illustration alter_hierarchy.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to alter an existing hierarchy.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema in which the hierarchy exists. If you do not specify a schema, then Oracle Database looks for the hierarchy in your own schema.
## *hierarchy_name*
Specify the name of the hierarchy.
## RENAME TO
Specify `RENAME` `TO` to change the name of the hierarchy.
## COMPILE
Specify `COMPILE` to compile the hierarchy.
## *new_hier_name*
Specify a new name for the hierarchy.
## Example
The following statement changes the name of a hierarchy:
```
ALTER HIERARCHY product_hier RENAME TO myproduct_hier;
```
