# PostgreSQL: Documentation: 18: ALTER RULE

PostgreSQL: Documentation: 18: ALTER RULE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER RULE Prev Up SQL Commands Home Next ALTER RULE ALTER RULE — change the definition of a rule Synopsis ALTER RULE name ON table_name RENAME TO new_name Description ALTER RULE changes properties of an existing rule. Currently, the only available action is to change the rule's name.
To use ALTER RULE, you must own the table or view that the rule applies to.
Parameters name The name of an existing rule to alter.
table_name The name (optionally schema-qualified) of the table or view that the rule applies to.
new_name The new name for the rule.
Examples To rename an existing rule:
ALTER RULE notify_all ON emp RENAME TO notify_me;
Compatibility ALTER RULE is a PostgreSQL language extension, as is the entire query rewrite system.
See AlsoCREATE RULE, DROP RULE Prev Up Next ALTER ROUTINE Home ALTER SCHEMA Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
