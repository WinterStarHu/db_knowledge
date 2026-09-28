# PostgreSQL: Documentation: 18: 52.40. pg_publication

PostgreSQL: Documentation: 18: 52.40. pg_publication Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
52.40. pg_publication
Prev Up Chapter 52. System Catalogs Home Next
52.40. pg_publication #
The catalog pg_publication contains all publications created in the database. For more on publications see Section 29.1.
Table 52.40. pg_publication Columns Column Type Description oid oid Row identifier pubname name Name of the publication pubowner oid (references pg_authid.oid) Owner of the publication puballtables bool If true, this publication automatically includes all tables in the database, including any that will be created in the future.
pubinsert bool If true, INSERT operations are replicated for tables in the publication.
pubupdate bool If true, UPDATE operations are replicated for tables in the publication.
pubdelete bool If true, DELETE operations are replicated for tables in the publication.
pubtruncate bool If true, TRUNCATE operations are replicated for tables in the publication.
pubviaroot bool If true, operations on a leaf partition are replicated using the identity and schema of its topmost partitioned ancestor mentioned in the publication instead of its own.
pubgencols char Controls how to handle generated column replication when there is no publication column list: n = generated columns in the tables associated with the publication should not be replicated, s = stored generated columns in the tables associated with the publication should be replicated.
Prev Up Next
52.39. pg_proc
Home
52.41. pg_publication_namespace
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
