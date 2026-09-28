# PostgreSQL: Documentation: 18: DROP LANGUAGE

PostgreSQL: Documentation: 18: DROP LANGUAGE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP LANGUAGE Prev Up SQL Commands Home Next DROP LANGUAGE DROP LANGUAGE — remove a procedural language Synopsis DROP [ PROCEDURAL ] LANGUAGE [ IF EXISTS ] name [ CASCADE | RESTRICT ] Description DROP LANGUAGE removes the definition of a previously registered procedural language. You must be a superuser or the owner of the language to use DROP LANGUAGE.
Note As of PostgreSQL 9.1, most procedural languages have been made into “extensions”, and should therefore be removed with DROP EXTENSION not DROP LANGUAGE.
Parameters IF EXISTS Do not throw an error if the language does not exist. A notice is issued in this case.
name The name of an existing procedural language.
CASCADE Automatically drop objects that depend on the language (such as functions in the language), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the language if any objects depend on it. This is the default.
Examples This command removes the procedural language plsample:
DROP LANGUAGE plsample;
Compatibility There is no DROP LANGUAGE statement in the SQL standard.
See AlsoALTER LANGUAGE, CREATE LANGUAGE Prev Up Next DROP INDEX Home DROP MATERIALIZED VIEW Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
