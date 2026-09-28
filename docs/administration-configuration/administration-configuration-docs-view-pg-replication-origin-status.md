# PostgreSQL: Documentation: 18: 53.19. pg_replication_origin_status

PostgreSQL: Documentation: 18: 53.19. pg_replication_origin_status Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
53.19. pg_replication_origin_status
Prev Up Chapter 53. System Views Home Next
53.19. pg_replication_origin_status #
The pg_replication_origin_status view contains information about how far replay for a certain origin has progressed. For more on replication origins see Chapter 48.
Table 53.19. pg_replication_origin_status Columns Column Type Description local_id oid (references pg_replication_origin.roident) internal node identifier external_id text (references pg_replication_origin.roname) external node identifier remote_lsn pg_lsn The origin node's LSN up to which data has been replicated.
local_lsn pg_lsn This node's LSN at which remote_lsn has been replicated. Used to flush commit records before persisting data to disk when using asynchronous commits.
Prev Up Next
53.18. pg_publication_tables
Home
53.20. pg_replication_slots
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
