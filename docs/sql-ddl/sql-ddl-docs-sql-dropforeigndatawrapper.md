# PostgreSQL: Documentation: 18: DROP FOREIGN DATA WRAPPER

PostgreSQL: Documentation: 18: DROP FOREIGN DATA WRAPPER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP FOREIGN DATA WRAPPER Prev Up SQL Commands Home Next DROP FOREIGN DATA WRAPPER DROP FOREIGN DATA WRAPPER — remove a foreign-data wrapper Synopsis DROP FOREIGN DATA WRAPPER [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP FOREIGN DATA WRAPPER removes an existing foreign-data wrapper. To execute this command, the current user must be the owner of the foreign-data wrapper.
Parameters IF EXISTS Do not throw an error if the foreign-data wrapper does not exist. A notice is issued in this case.
name The name of an existing foreign-data wrapper.
CASCADE Automatically drop objects that depend on the foreign-data wrapper (such as foreign tables and servers), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the foreign-data wrapper if any objects depend on it. This is the default.
Examples Drop the foreign-data wrapper dbi:
DROP FOREIGN DATA WRAPPER dbi;
Compatibility DROP FOREIGN DATA WRAPPER conforms to ISO/IEC 9075-9 (SQL/MED). The IF EXISTS clause is a PostgreSQL extension.
See AlsoCREATE FOREIGN DATA WRAPPER, ALTER FOREIGN DATA WRAPPER Prev Up Next DROP EXTENSION Home DROP FOREIGN TABLE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
