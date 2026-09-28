# PostgreSQL: Documentation: 18: DROP ROUTINE

PostgreSQL: Documentation: 18: DROP ROUTINE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 DROP ROUTINE Prev Up SQL Commands Home Next DROP ROUTINE DROP ROUTINE — remove a routine Synopsis DROP ROUTINE [ IF EXISTS ] name [ ( [ [ argmode ] [ argname ] argtype [, ...] ] ) ] [, ...] [ CASCADE | RESTRICT ] Description DROP ROUTINE removes the definition of one or more existing routines. The term “routine” includes aggregate functions, normal functions, and procedures. See under DROP AGGREGATE, DROP FUNCTION, and DROP PROCEDURE for the description of the parameters, more examples, and further details.
Notes The lookup rules used by DROP ROUTINE are fundamentally the same as for DROP PROCEDURE; in particular, DROP ROUTINE shares that command's behavior of considering an argument list that has no argmode markers to be possibly using the SQL standard's definition that OUT arguments are included in the list. (DROP AGGREGATE and DROP FUNCTION do not do that.) In some cases where the same name is shared by routines of different kinds, it is possible for DROP ROUTINE to fail with an ambiguity error when a more specific command (DROP FUNCTION, etc.) would work. Specifying the argument type list more carefully will also resolve such problems.
These lookup rules are also used by other commands that act on existing routines, such as ALTER ROUTINE and COMMENT ON ROUTINE.
Examples To drop the routine foo for type integer:
DROP ROUTINE foo(integer);
This command will work independent of whether foo is an aggregate, function, or procedure.
Compatibility This command conforms to the SQL standard, with these PostgreSQL extensions:
The standard only allows one routine to be dropped per command.
The IF EXISTS option is an extension.
The ability to specify argument modes and names is an extension, and the lookup rules differ when modes are given.
User-definable aggregate functions are an extension.
See AlsoDROP AGGREGATE, DROP FUNCTION, DROP PROCEDURE, ALTER ROUTINE Note that there is no CREATE ROUTINE command.
Prev Up Next DROP ROLE Home DROP RULE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
