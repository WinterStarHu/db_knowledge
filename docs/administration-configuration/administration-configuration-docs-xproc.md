# PostgreSQL: Documentation: 18: 36.4. User-Defined Procedures

PostgreSQL: Documentation: 18: 36.4. User-Defined Procedures Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
36.4. User-Defined Procedures
Prev Up Chapter 36. Extending SQL Home Next
36.4. User-Defined Procedures #
A procedure is a database object similar to a function. The key differences are:
Procedures are defined with the CREATE PROCEDURE command, not CREATE FUNCTION.
Procedures do not return a function value; hence CREATE PROCEDURE lacks a RETURNS clause. However, procedures can instead return data to their callers via output parameters.
While a function is called as part of a query or DML command, a procedure is called in isolation using the CALL command.
A procedure can commit or roll back transactions during its execution (then automatically beginning a new transaction), so long as the invoking CALL command is not part of an explicit transaction block. A function cannot do that.
Certain function attributes, such as strictness, don't apply to procedures. Those attributes control how the function is used in a query, which isn't relevant to procedures.
The explanations in the following sections about how to define user-defined functions apply to procedures as well, except for the points made above.
Collectively, functions and procedures are also known as routines. There are commands such as ALTER ROUTINE and DROP ROUTINE that can operate on functions and procedures without having to know which kind it is. Note, however, that there is no CREATE ROUTINE command.
Prev Up Next
36.3. User-Defined Functions
Home
36.5. Query Language (SQL) Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
