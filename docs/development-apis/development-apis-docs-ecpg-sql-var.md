# PostgreSQL: Documentation: 18: VAR

PostgreSQL: Documentation: 18: VAR Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
VAR Prev Up
34.14. Embedded SQL Commands
Home Next VAR VAR — define a variable Synopsis VAR varname IS ctype Description The VAR command assigns a new C data type to a host variable. The host variable must be previously declared in a declare section.
Parameters varname # A C variable name.
ctype # A C type specification.
Examples Exec sql begin declare section;
short a;
exec sql end declare section;
EXEC SQL VAR a IS int;
Compatibility The VAR command is a PostgreSQL extension.
Prev Up Next TYPE Home WHENEVER Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
