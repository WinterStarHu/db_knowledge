# PostgreSQL: Documentation: 18: 42.12. Tcl Procedure Names

PostgreSQL: Documentation: 18: 42.12. Tcl Procedure Names Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
42.12. Tcl Procedure Names
Prev Up Chapter 42. PL/Tcl — Tcl Procedural Language Home Next
42.12. Tcl Procedure Names #
In PostgreSQL, the same function name can be used for different function definitions if the functions are placed in different schemas, or if the number of arguments or their types differ. Tcl, however, requires all procedure names to be distinct. PL/Tcl deals with this by including the argument type names in the internal Tcl procedure name, and then appending the function's object ID (OID) to the internal Tcl procedure name if necessary to make it different from the names of all previously-loaded functions in the same Tcl interpreter. Thus, PostgreSQL functions with the same name and different argument types will be different Tcl procedures, too. This is not normally a concern for a PL/Tcl programmer, but it might be visible when debugging.
For this reason among others, a PL/Tcl function cannot call another one directly (that is, within Tcl). If you need to do that, you must go through SQL, using spi_exec or a related command.
Prev Up Next
42.11. PL/Tcl Configuration
Home Chapter 43. PL/Perl — Perl Procedural Language Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
