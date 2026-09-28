# PostgreSQL: Documentation: 18: 53.22. pg_rules

PostgreSQL: Documentation: 18: 53.22. pg_rules Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.22. pg_rules
Prev Up Chapter 53. System Views Home Next
53.22. pg_rules #
The view pg_rules provides access to useful information about query rewrite rules.
Table 53.22. pg_rules Columns Column Type Description schemaname name (references pg_namespace.nspname) Name of schema containing table tablename name (references pg_class.relname) Name of table the rule is for rulename name (references pg_rewrite.rulename) Name of rule definition text Rule definition (a reconstructed creation command) The pg_rules view excludes the ON SELECT rules of views and materialized views; those can be seen in pg_views and pg_matviews.
Prev Up Next
53.21. pg_roles
Home
53.23. pg_seclabels
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
