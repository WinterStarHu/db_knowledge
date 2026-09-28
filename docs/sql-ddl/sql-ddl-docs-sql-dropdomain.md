# PostgreSQL: Documentation: 18: DROP DOMAIN

PostgreSQL: Documentation: 18: DROP DOMAIN Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP DOMAIN Prev Up SQL Commands Home Next DROP DOMAIN DROP DOMAIN — remove a domain Synopsis DROP DOMAIN [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP DOMAIN removes a domain. Only the owner of a domain can remove it.
Parameters IF EXISTS Do not throw an error if the domain does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of an existing domain.
CASCADE Automatically drop objects that depend on the domain (such as table columns), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the domain if any objects depend on it. This is the default.
Examples To remove the domain box:
DROP DOMAIN box;
Compatibility This command conforms to the SQL standard, except for the IF EXISTS option, which is a PostgreSQL extension.
See AlsoCREATE DOMAIN, ALTER DOMAIN Prev Up Next DROP DATABASE Home DROP EVENT TRIGGER Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
