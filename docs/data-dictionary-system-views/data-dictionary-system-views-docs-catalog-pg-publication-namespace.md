# PostgreSQL: Documentation: 18: 52.41. pg_publication_namespace

PostgreSQL: Documentation: 18: 52.41. pg_publication_namespace Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel
52.41. pg_publication_namespace
Prev Up Chapter 52. System Catalogs Home Next
52.41. pg_publication_namespace #
The catalog pg_publication_namespace contains the mapping between schemas and publications in the database. This is a many-to-many mapping.
Table 52.41. pg_publication_namespace Columns Column Type Description oid oid Row identifier pnpubid oid (references pg_publication.oid) Reference to publication pnnspid oid (references pg_namespace.oid) Reference to schema Prev Up Next
52.40. pg_publication
Home
52.42. pg_publication_rel
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
