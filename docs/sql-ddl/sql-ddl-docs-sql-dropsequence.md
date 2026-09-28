# PostgreSQL: Documentation: 18: DROP SEQUENCE

PostgreSQL: Documentation: 18: DROP SEQUENCE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.3
/
7.2
/
7.1
DROP SEQUENCE Prev Up SQL Commands Home Next DROP SEQUENCE DROP SEQUENCE — remove a sequence Synopsis DROP SEQUENCE [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP SEQUENCE removes sequence number generators. A sequence can only be dropped by its owner or a superuser.
Parameters IF EXISTS Do not throw an error if the sequence does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of a sequence.
CASCADE Automatically drop objects that depend on the sequence, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the sequence if any objects depend on it. This is the default.
Examples To remove the sequence serial:
DROP SEQUENCE serial;
Compatibility DROP SEQUENCE conforms to the SQL standard, except that the standard only allows one sequence to be dropped per command, and apart from the IF EXISTS option, which is a PostgreSQL extension.
See AlsoCREATE SEQUENCE, ALTER SEQUENCE Prev Up Next DROP SCHEMA Home DROP SERVER Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
