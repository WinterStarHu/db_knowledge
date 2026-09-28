# ALTER TRIGGER

## Purpose
Triggers are defined using PL/SQL. Therefore, this section provides some general information but refers to *Oracle Database PL/SQL Language Reference* for details of syntax and semantics.
Use the `ALTER` `TRIGGER` statement to enable, disable, or compile a database trigger.
**Note:**   This statement does not change the declaration or definition of an existing trigger. To redeclare or redefine a trigger, use the `CREATE` `TRIGGER` statement with the `OR` `REPLACE` keywords.
**See Also:**
- CREATE TRIGGER for information on creating a trigger
- DROP TRIGGER for information on dropping a trigger
**
- Oracle Database Concepts for general information on triggers
## Prerequisites
The trigger must be in your own schema or you must have `ALTER` `ANY` `TRIGGER` system privilege.
In addition, to alter a trigger on `DATABASE`, you must have the `ADMINISTER` `DATABASE` `TRIGGER` privilege.
**See Also:**   CREATE TRIGGER for more information on triggers based on `DATABASE` triggers
## Syntax
## *alter_trigger*::=
Description of the illustration alter_trigger.eps (*trigger_compile_clause*: See *Oracle Database PL/SQL Language Reference* for the syntax of this clause.)
## Semantics
## IF EXISTS
Specify `IF EXISTS` to alter an existing trigger.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema containing the trigger. If you omit *schema*, then Oracle Database assumes the trigger is in your own schema.
## *trigger_name*
Specify the name of the trigger to be altered.
## *trigger_compile_clause*
See *Oracle Database PL/SQL Language Reference* for the syntax and semantics of this clause and for complete information on creating and compiling triggers.
## ENABLE | DISABLE
Specify `ENABLE` to enable the trigger. You can also use the `ENABLE` `ALL` `TRIGGERS` clause of `ALTER` `TABLE` to enable all triggers associated with a table. See ALTER TABLE.
Specify `DISABLE` to disable the trigger. You can also use the `DISABLE` `ALL` `TRIGGERS` clause of `ALTER` `TABLE` to disable all triggers associated with a table.
## RENAME Clause
Specify `RENAME` `TO` *new_name* to rename the trigger. Oracle Database renames the trigger and leaves it in the same state it was in before being renamed.
When you rename a trigger, the database rebuilds the remembered source of the trigger in the `USER_SOURCE`, `ALL_SOURCE`, and `DBA_SOURCE` data dictionary views. As a result, comments and formatting may change in the `TEXT` column of those views even though the trigger source did not change.
## EDITIONABLE | NONEDITIONABLE
Use these clauses to specify whether the trigger becomes an editioned or noneditioned object if editioning is later enabled for the schema object type `TRIGGER` in *schema*. The default is `EDITIONABLE`. For information about altering editioned and noneditioned objects, see *Oracle Database Development Guide*.
**Restriction on NONEDITIONABLE** You cannot specify `NONEDITIONABLE` for a crossedition trigger.
