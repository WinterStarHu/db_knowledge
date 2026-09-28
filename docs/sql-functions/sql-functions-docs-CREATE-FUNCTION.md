# CREATE FUNCTION

## Purpose
Functions are defined using PL/SQL. Therefore, this section provides some general information but refers to *Oracle Database PL/SQL Language Reference* for details of syntax and semantics.
Use the `CREATE` `FUNCTION` statement to create a standalone stored function or a call specification.
************
- A stored function (also called a user function or user-defined function) is a set of PL/SQL statements you can call by name. Stored functions are very similar to procedures, except that a function returns a value to the environment in which it is called. User functions can be used as part of a SQL expression.
********````
- A call specification declares a Java method or a third-generation language (3GL) routine so that it can be called from PL/SQL. You can also use the CALL SQL statement to call such a method or routine. The call specification tells Oracle Database which Java method, or which named function in which shared library, to invoke when a call is made. It also tells the database what type conversions to make for the arguments and return value. Note: You can also create a function as part of a package using the CREATE PACKAGE statement.
**See Also:**
- CREATE PROCEDURE for a general discussion of procedures and functions, CREATE PACKAGE for information on creating packages, ALTER FUNCTION and DROP FUNCTION for information on modifying and dropping a function
- CREATE LIBRARY for information on shared libraries
**
- Oracle Database Development Guide for more information about registering external functions
## Prerequisites
To create or replace a function in your own schema, you must have the `CREATE` `PROCEDURE` system privilege. To create or replace a function in another user’s schema, you must have the `CREATE` `ANY` `PROCEDURE` system privilege.
## Syntax
Functions are defined using PL/SQL. Therefore, the syntax diagram in this book shows only the SQL keywords. Refer to *Oracle Database PL/SQL Language Reference* for the PL/SQL syntax, semantics, and examples.
## *create_function*::=
Description of the illustration create_function.eps (*plsql_function_source*: See *Oracle Database PL/SQL Language Reference*.)
## Semantics
## OR REPLACE
Specify `OR` `REPLACE` to re-create the function if it already exists. Use this clause to change the definition of an existing function without dropping, re-creating, and regranting object privileges previously granted on the function. If you redefine a function, then Oracle Database recompiles it.
Users who had previously been granted privileges on a redefined function can still access the function without being regranted the privileges.
If any function-based indexes depend on the function, then Oracle Database marks the indexes `DISABLED`.
**See Also:**    `ALTER` `FUNCTION` for information on recompiling functions using SQL
## [ EDITIONABLE | NONEDITIONABLE ]
Use these clauses to specify whether the function is an editioned or noneditioned object if editioning is enabled for the schema object type `FUNCTION` in *schema*. The default is `EDITIONABLE`. For information about editioned and noneditioned objects, see *Oracle Database Development Guide*.
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the function does not exist, a new one is created at the end of the statement.
- If the function exists, it is detected and a new one is not created.
You can only specify `OR REPLACE` or `IF NOT EXISTS` in a statement at a time. Using both `OR REPLACE` with `IF NOT EXISTS` in the very same statement results in an error.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## *plsql_function_source*
See *Oracle Database PL/SQL Language Reference* for the syntax and semantics of the *plsql_function_source*, including examples.
