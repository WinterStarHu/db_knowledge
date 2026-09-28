# PostgreSQL: Documentation: 18: 52.32. pg_namespace

PostgreSQL: Documentation: 18: 52.32. pg_namespace Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.32. pg_namespace
Prev Up Chapter 52. System Catalogs Home Next
52.32. pg_namespace #
The catalog pg_namespace stores namespaces. A namespace is the structure underlying SQL schemas: each namespace can have a separate collection of relations, types, etc. without name conflicts.
Table 52.32. pg_namespace Columns Column Type Description oid oid Row identifier nspname name Name of the namespace nspowner oid (references pg_authid.oid) Owner of the namespace nspacl aclitem[] Access privileges; see Section 5.8 for details Prev Up Next
52.31. pg_largeobject_metadata
Home
52.33. pg_opclass
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
