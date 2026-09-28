# PostgreSQL: Documentation: 18: 53.1. Overview

PostgreSQL: Documentation: 18: 53.1. Overview Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.1. Overview
Prev Up Chapter 53. System Views Home Next
53.1. Overview #
Table 53.1 lists the system views. More detailed documentation of each catalog follows below. Except where noted, all the views described here are read-only.
Table 53.1. System Views View Name Purpose pg_aios In-use asynchronous IO handles pg_available_extensions available extensions pg_available_extension_versions available versions of extensions pg_backend_memory_contexts backend memory contexts pg_config compile-time configuration parameters pg_cursors open cursors pg_file_settings summary of configuration file contents pg_group groups of database users pg_hba_file_rules summary of client authentication configuration file contents pg_ident_file_mappings summary of client user name mapping configuration file contents pg_indexes indexes pg_locks locks currently held or awaited pg_matviews materialized views pg_policies policies pg_prepared_statements prepared statements pg_prepared_xacts prepared transactions pg_publication_tables publications and information of their associated tables pg_replication_origin_status information about replication origins, including replication progress pg_replication_slots replication slot information pg_roles database roles pg_rules rules pg_seclabels security labels pg_sequences sequences pg_settings parameter settings pg_shadow database users pg_shmem_allocations shared memory allocations pg_shmem_allocations_numa NUMA node mappings for shared memory allocations pg_stats planner statistics pg_stats_ext extended planner statistics pg_stats_ext_exprs extended planner statistics for expressions pg_tables tables pg_timezone_abbrevs time zone abbreviations pg_timezone_names time zone names pg_user database users pg_user_mappings user mappings pg_views views pg_wait_events wait events Prev Up Next Chapter 53. System Views Home
53.2. pg_aios
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
