# PostgreSQL: Documentation: 18: DROP FOREIGN TABLE

PostgreSQL: Documentation: 18: DROP FOREIGN TABLE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP FOREIGN TABLE Prev Up SQL Commands Home Next DROP FOREIGN TABLE DROP FOREIGN TABLE — remove a foreign table Synopsis DROP FOREIGN TABLE [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP FOREIGN TABLE removes a foreign table. Only the owner of a foreign table can remove it.
Parameters IF EXISTS Do not throw an error if the foreign table does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of the foreign table to drop.
CASCADE Automatically drop objects that depend on the foreign table (such as views), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the foreign table if any objects depend on it. This is the default.
Examples To destroy two foreign tables, films and distributors:
DROP FOREIGN TABLE films, distributors;
Compatibility This command conforms to ISO/IEC 9075-9 (SQL/MED), except that the standard only allows one foreign table to be dropped per command, and apart from the IF EXISTS option, which is a PostgreSQL extension.
See AlsoALTER FOREIGN TABLE, CREATE FOREIGN TABLE Prev Up Next DROP FOREIGN DATA WRAPPER Home DROP FUNCTION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
