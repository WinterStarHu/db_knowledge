# PostgreSQL: Documentation: 18: 53.18. pg_publication_tables

PostgreSQL: Documentation: 18: 53.18. pg_publication_tables Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
53.18. pg_publication_tables
Prev Up Chapter 53. System Views Home Next
53.18. pg_publication_tables #
The view pg_publication_tables provides information about the mapping between publications and information of tables they contain. Unlike the underlying catalog pg_publication_rel, this view expands publications defined as FOR ALL TABLES and FOR TABLES IN SCHEMA, so for such publications there will be a row for each eligible table.
Table 53.18. pg_publication_tables Columns Column Type Description pubname name (references pg_publication.pubname) Name of publication schemaname name (references pg_namespace.nspname) Name of schema containing table tablename name (references pg_class.relname) Name of table attnames name[] (references pg_attribute.attname) Names of table columns included in the publication. This contains all the columns of the table when the user didn't specify the column list for the table.
rowfilter text Expression for the table's publication qualifying condition Prev Up Next
53.17. pg_prepared_xacts
Home
53.19. pg_replication_origin_status
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
