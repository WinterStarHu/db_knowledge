# DROP ANALYTIC VIEW

## Purpose
Use the `DROP` `ANALYTIC` `VIEW` statement to drop an analytic view. An `ANALYTIC` `VIEW` object is a component of analytic views.
## Prerequisites
To drop an analytic view in your own schema, you must have the `DROP` `ANALYTIC` `VIEW` system privilege. To drop an analytic view in another user’s schema, you must have the `DROP` `ANY` `ANALYTIC` `VIEW` system privilege.
## Syntax
## *drop_analytic_view*::=
Description of the illustration drop_analytic_view.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to drop an existing analytic view.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema in which the analytic view exists. If you do not specify a schema, then Oracle Database looks for the analytic view in your own schema.
## *analytic_view_name*
Specify the name of the analytic view to drop.
## Example
The following statement drops the specified analytic view object:
```
DROP ANALYTIC VIEW sales_av;
```
