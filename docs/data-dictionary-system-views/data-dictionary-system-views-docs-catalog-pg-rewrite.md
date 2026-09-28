# PostgreSQL: Documentation: 18: 52.45. pg_rewrite

PostgreSQL: Documentation: 18: 52.45. pg_rewrite Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.45. pg_rewrite
Prev Up Chapter 52. System Catalogs Home Next
52.45. pg_rewrite #
The catalog pg_rewrite stores rewrite rules for tables and views.
Table 52.45. pg_rewrite Columns Column Type Description oid oid Row identifier rulename name Rule name ev_class oid (references pg_class.oid) The table this rule is for ev_type char Event type that the rule is for: 1 = SELECT, 2 = UPDATE, 3 = INSERT, 4 = DELETE ev_enabled char Controls in which session_replication_role modes the rule fires. O = rule fires in “origin” and “local” modes, D = rule is disabled, R = rule fires in “replica” mode, A = rule fires always.
is_instead bool True if the rule is an INSTEAD rule ev_qual pg_node_tree Expression tree (in the form of a nodeToString() representation) for the rule's qualifying condition ev_action pg_node_tree Query tree (in the form of a nodeToString() representation) for the rule's action Note pg_class.relhasrules must be true if a table has any rules in this catalog.
Prev Up Next
52.44. pg_replication_origin
Home
52.46. pg_seclabel
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
