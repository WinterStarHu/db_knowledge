# ALTER FUNCTION

## Purpose
Functions are defined using PL/SQL. Therefore, this section provides some general information but refers to *Oracle Database PL/SQL Language Reference* for details of syntax and semantics.
Use the `ALTER` `FUNCTION` statement to recompile an invalid standalone stored function. Explicit recompilation eliminates the need for implicit run-time recompilation and prevents associated run-time compilation errors and performance overhead.
This statement does not change the declaration or definition of an existing function. To redeclare or redefine a function, use the `CREATE` `FUNCTION` statement with the `OR` `REPLACE` clause. See CREATE FUNCTION.
## Prerequisites
The function must be in your own schema or you must have `ALTER` `ANY` `PROCEDURE` system privilege.
## Syntax
## *alter_function*::=
Description of the illustration alter_function.eps (*function_compile_clause*: See *Oracle Database PL/SQL Language Reference* for the syntax of this clause.)
## Semantics
## IF EXISTS
Specify `IF EXISTS` to alter an existing function.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema containing the function. If you omit *schema*, then Oracle Database assumes the function is in your own schema.
## *function_name*
Specify the name of the function to be recompiled.
## *function_compile_clause*
See *Oracle Database PL/SQL Language Reference* for the syntax and semantics of this clause and for complete information on creating and compiling functions.
## EDITIONABLE | NONEDITIONABLE
Use these clauses to specify whether the function becomes an editioned or noneditioned object if editioning is later enabled for the schema object type `FUNCTION` in *schema*. The default is `EDITIONABLE`. For information about altering editioned and noneditioned objects, see *Oracle Database Development Guide*.
