# PostgreSQL: Documentation: 18: 52.56. pg_tablespace

PostgreSQL: Documentation: 18: 52.56. pg_tablespace Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.56. pg_tablespace
Prev Up Chapter 52. System Catalogs Home Next
52.56. pg_tablespace #
The catalog pg_tablespace stores information about the available tablespaces. Tables can be placed in particular tablespaces to aid administration of disk layout.
Unlike most system catalogs, pg_tablespace is shared across all databases of a cluster: there is only one copy of pg_tablespace per cluster, not one per database.
Table 52.56. pg_tablespace Columns Column Type Description oid oid Row identifier spcname name Tablespace name spcowner oid (references pg_authid.oid) Owner of the tablespace, usually the user who created it spcacl aclitem[] Access privileges; see Section 5.8 for details spcoptions text[] Tablespace-level options, as “keyword=value” strings Prev Up Next
52.55. pg_subscription_rel
Home
52.57. pg_transform
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
