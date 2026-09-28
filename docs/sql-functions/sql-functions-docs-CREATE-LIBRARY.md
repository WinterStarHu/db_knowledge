# CREATE LIBRARY

## Purpose
Use the `CREATE` `LIBRARY` statement to create a schema object associated with an operating-system shared library. The name of this schema object can then be used in the *call_spec* of `CREATE` `FUNCTION` or `CREATE` `PROCEDURE` statements, or when declaring a function or procedure in a package or type, so that SQL and PL/SQL can call to third-generation-language (3GL) functions and procedures.
**See Also:**   CREATE FUNCTION and *Oracle Database PL/SQL Language Reference* for more information on functions and procedures
## Prerequisites
The `CREATE` `LIBRARY` statement is valid only on platforms that support shared libraries and dynamic linking.
To create a library in your own schema, you must have the `CREATE` `LIBRARY` system privilege. To create a library in another user’s schema, you must have the `CREATE` `ANY` `LIBRARY` system privilege.
To use the library in the *call_spec* of a `CREATE` `FUNCTION` statement, or when declaring a function in a package or type, you must have the `EXECUTE` object privilege on the library and the `CREATE` `FUNCTION` system privilege. Refer to *Oracle Database PL/SQL Language Reference* for information on the *call_spec* of a `CREATE` `FUNCTION` statement.
To use the library in the *call_spec* of a `CREATE` `PROCEDURE` statement, or when declaring a procedure in a package or type, you must have the `EXECUTE` object privilege on the library and the `CREATE` `PROCEDURE` system privilege. Refer to *Oracle Database PL/SQL Language Reference* for information on the *call_spec* of a `CREATE` `PROCEDURE` statement.
To execute a procedure or function defined with the *call_spec* (including a procedure or function defined within a package or type), you must have the `EXECUTE` object privilege on the procedure or function (but you do not need the `EXECUTE` object privilege on the library).
## Syntax
Libraries are defined using PL/SQL. Therefore, the syntax diagram in this book shows only the SQL keywords. Refer to *Oracle Database PL/SQL Language Reference* for the PL/SQL syntax, semantics, and examples.
## *create_library*::=
Description of the illustration create_library.eps (*plsql_library_source*: See *Oracle Database PL/SQL Language Reference*.)
## Semantics
## OR REPLACE
Specify `OR` `REPLACE` to re-create the library if it already exists. Use this clause to change the definition of an existing library without dropping, re-creating, and regranting object privileges granted on it.
Users who had previously been granted privileges on a redefined library can still access the library without being regranted the privileges.
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the library does not exist, a new one is created at the end of the statement.
- If the library view exists, it is detected and a new one is not created.
You can only specify `OR REPLACE` or `IF NOT EXISTS` in a statement at a time. Using both `OR REPLACE` with `IF NOT EXISTS` in the very same statement results in an error.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## [ EDITIONABLE | NONEDITIONABLE ]
Use these clauses to specify whether the library is an editioned or noneditioned object if editioning is enabled for the schema object type `LIBRARY` in *schema*. The default is `EDITIONABLE`. For information about editioned and noneditioned objects, see *Oracle Database Development Guide*.
## *plsql_library_source*
See *Oracle Database PL/SQL Language Reference* for the syntax and semantics of the *plsql_library_source*.
