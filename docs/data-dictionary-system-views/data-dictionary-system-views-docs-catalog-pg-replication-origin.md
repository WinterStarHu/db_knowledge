# PostgreSQL: Documentation: 18: 52.44. pg_replication_origin

PostgreSQL: Documentation: 18: 52.44. pg_replication_origin Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
52.44. pg_replication_origin
Prev Up Chapter 52. System Catalogs Home Next
52.44. pg_replication_origin #
The pg_replication_origin catalog contains all replication origins created. For more on replication origins see Chapter 48.
Unlike most system catalogs, pg_replication_origin is shared across all databases of a cluster: there is only one copy of pg_replication_origin per cluster, not one per database.
Table 52.44. pg_replication_origin Columns Column Type Description roident oid A unique, cluster-wide identifier for the replication origin. Should never leave the system.
roname text The external, user defined, name of a replication origin.
Prev Up Next
52.43. pg_range
Home
52.45. pg_rewrite
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
