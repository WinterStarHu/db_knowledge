# PostgreSQL: Documentation: 18: DROP RULE

PostgreSQL: Documentation: 18: DROP RULE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP RULE Prev Up SQL Commands Home Next DROP RULE DROP RULE — remove a rewrite rule Synopsis DROP RULE [ IF EXISTS ] name ON table_name [ CASCADE | RESTRICT ] Description DROP RULE drops a rewrite rule.
Parameters IF EXISTS Do not throw an error if the rule does not exist. A notice is issued in this case.
name The name of the rule to drop.
table_name The name (optionally schema-qualified) of the table or view that the rule applies to.
CASCADE Automatically drop objects that depend on the rule, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the rule if any objects depend on it. This is the default.
Examples To drop the rewrite rule newrule:
DROP RULE newrule ON mytable;
Compatibility DROP RULE is a PostgreSQL language extension, as is the entire query rewrite system.
See AlsoCREATE RULE, ALTER RULE Prev Up Next DROP ROUTINE Home DROP SCHEMA Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
