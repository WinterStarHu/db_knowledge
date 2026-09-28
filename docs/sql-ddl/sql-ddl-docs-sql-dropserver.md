# PostgreSQL: Documentation: 18: DROP SERVER

PostgreSQL: Documentation: 18: DROP SERVER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP SERVER Prev Up SQL Commands Home Next DROP SERVER DROP SERVER — remove a foreign server descriptor Synopsis DROP SERVER [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP SERVER removes an existing foreign server descriptor. To execute this command, the current user must be the owner of the server.
Parameters IF EXISTS Do not throw an error if the server does not exist. A notice is issued in this case.
name The name of an existing server.
CASCADE Automatically drop objects that depend on the server (such as user mappings), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the server if any objects depend on it. This is the default.
Examples Drop a server foo if it exists:
DROP SERVER IF EXISTS foo;
Compatibility DROP SERVER conforms to ISO/IEC 9075-9 (SQL/MED). The IF EXISTS clause is a PostgreSQL extension.
See AlsoCREATE SERVER, ALTER SERVER Prev Up Next DROP SEQUENCE Home DROP STATISTICS Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
