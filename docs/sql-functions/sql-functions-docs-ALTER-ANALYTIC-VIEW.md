# ALTER ANALYTIC VIEW

## Purpose
Use the `ALTER` `ANALYTIC` `VIEW` statement to rename or compile an analytic view. For other alterations, use `CREATE` `OR` `REPLACE` `ANALYTIC` `VIEW`.
## Prerequisites
To alter an analytic view in your own schema, you must have the `ALTER` `ANALYTIC` `VIEW` system privilege. To alter an analytic view in another user’s schema, you must have the `ALTER` `ANY` `ANALYTIC` `VIEW` system privilege or `ALTER` `ANY` `TABLE` granted on the analytic view.
## Syntax
## *alter_analytic_view*::=
Description of the illustration alter_analytic_view.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to alter an existing table.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema in which the analytic view exists. If you do not specify a schema, then Oracle Database looks for the analytic view in your own schema.
## *analytic_view_name*
Specify the name of the analytic view.
## RENAME TO
Specify `RENAME` `TO` to change the name of the analytic view. For *new_av_name*, specify a new name for the analytic view.
## COMPILE
Specify `COMPILE` to compile the analytic view.
## Example
The following statement changes the name of an analytic view:
```
ALTER ANALYTIC VIEW sales_av RENAME TO mysales_av;
```
