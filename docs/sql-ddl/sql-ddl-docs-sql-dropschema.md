# PostgreSQL: Documentation: 18: DROP SCHEMA

PostgreSQL: Documentation: 18: DROP SCHEMA Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP SCHEMA Prev Up SQL Commands Home Next DROP SCHEMA DROP SCHEMA — remove a schema Synopsis DROP SCHEMA [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP SCHEMA removes schemas from the database.
A schema can only be dropped by its owner or a superuser. Note that the owner can drop the schema (and thereby all contained objects) even if they do not own some of the objects within the schema.
Parameters IF EXISTS Do not throw an error if the schema does not exist. A notice is issued in this case.
name The name of a schema.
CASCADE Automatically drop objects (tables, functions, etc.) that are contained in the schema, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the schema if it contains any objects. This is the default.
Notes Using the CASCADE option might make the command remove objects in other schemas besides the one(s) named.
Examples To remove schema mystuff from the database, along with everything it contains:
DROP SCHEMA mystuff CASCADE;
Compatibility DROP SCHEMA is fully conforming with the SQL standard, except that the standard only allows one schema to be dropped per command, and apart from the IF EXISTS option, which is a PostgreSQL extension.
See AlsoALTER SCHEMA, CREATE SCHEMA Prev Up Next DROP RULE Home DROP SEQUENCE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
