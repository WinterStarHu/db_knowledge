# PostgreSQL: Documentation: 18: DROP ACCESS METHOD

PostgreSQL: Documentation: 18: DROP ACCESS METHOD Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
DROP ACCESS METHOD Prev Up SQL Commands Home Next DROP ACCESS METHOD DROP ACCESS METHOD — remove an access method Synopsis DROP ACCESS METHOD [ IF EXISTS ] name [ CASCADE | RESTRICT ] Description DROP ACCESS METHOD removes an existing access method. Only superusers can drop access methods.
Parameters IF EXISTS Do not throw an error if the access method does not exist. A notice is issued in this case.
name The name of an existing access method.
CASCADE Automatically drop objects that depend on the access method (such as operator classes, operator families, and indexes), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the access method if any objects depend on it. This is the default.
Examples Drop the access method heptree:
DROP ACCESS METHOD heptree;
Compatibility DROP ACCESS METHOD is a PostgreSQL extension.
See AlsoCREATE ACCESS METHOD Prev Up Next DO Home DROP AGGREGATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
