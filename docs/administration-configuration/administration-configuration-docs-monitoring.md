# PostgreSQL: Documentation: 18: Chapter 27. Monitoring Database Activity

PostgreSQL: Documentation: 18: Chapter 27. Monitoring Database Activity Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 27. Monitoring Database Activity Prev Up Part III. Server Administration Home Next Chapter 27. Monitoring Database Activity Table of Contents
27.1. Standard Unix Tools
27.2. The Cumulative Statistics System
27.2.1. Statistics Collection Configuration
27.2.2. Viewing Statistics
27.2.3. pg_stat_activity
27.2.4. pg_stat_replication
27.2.5. pg_stat_replication_slots
27.2.6. pg_stat_wal_receiver
27.2.7. pg_stat_recovery_prefetch
27.2.8. pg_stat_subscription
27.2.9. pg_stat_subscription_stats
27.2.10. pg_stat_ssl
27.2.11. pg_stat_gssapi
27.2.12. pg_stat_archiver
27.2.13. pg_stat_io
27.2.14. pg_stat_bgwriter
27.2.15. pg_stat_checkpointer
27.2.16. pg_stat_wal
27.2.17. pg_stat_database
27.2.18. pg_stat_database_conflicts
27.2.19. pg_stat_all_tables
27.2.20. pg_stat_all_indexes
27.2.21. pg_statio_all_tables
27.2.22. pg_statio_all_indexes
27.2.23. pg_statio_all_sequences
27.2.24. pg_stat_user_functions
27.2.25. pg_stat_slru
27.2.26. Statistics Functions
27.3. Viewing Locks
27.4. Progress Reporting
27.4.1. ANALYZE Progress Reporting
27.4.2. CLUSTER Progress Reporting
27.4.3. COPY Progress Reporting
27.4.4. CREATE INDEX Progress Reporting
27.4.5. VACUUM Progress Reporting
27.4.6. Base Backup Progress Reporting
27.5. Dynamic Tracing
27.5.1. Compiling for Dynamic Tracing
27.5.2. Built-in Probes
27.5.3. Using Probes
27.5.4. Defining New Probes
27.6. Monitoring Disk Usage
27.6.1. Determining Disk Usage
27.6.2. Disk Full Failure
A database administrator frequently wonders, “What is the system doing right now?” This chapter discusses how to find that out.
Several tools are available for monitoring database activity and analyzing performance. Most of this chapter is devoted to describing PostgreSQL's cumulative statistics system, but one should not neglect regular Unix monitoring programs such as ps, top, iostat, and vmstat. Also, once one has identified a poorly-performing query, further investigation might be needed using PostgreSQL's EXPLAIN command. Section 14.1 discusses EXPLAIN and other methods for understanding the behavior of an individual query.
Prev Up Next
26.4. Hot Standby
Home
27.1. Standard Unix Tools
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
