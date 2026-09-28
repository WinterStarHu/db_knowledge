# PostgreSQL: Documentation: 18: Chapter 53. System Views

PostgreSQL: Documentation: 18: Chapter 53. System Views Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel Chapter 53. System Views Prev Up Part VII. Internals Home Next Chapter 53. System Views Table of Contents
53.1. Overview
53.2. pg_aios
53.3. pg_available_extensions
53.4. pg_available_extension_versions
53.5. pg_backend_memory_contexts
53.6. pg_config
53.7. pg_cursors
53.8. pg_file_settings
53.9. pg_group
53.10. pg_hba_file_rules
53.11. pg_ident_file_mappings
53.12. pg_indexes
53.13. pg_locks
53.14. pg_matviews
53.15. pg_policies
53.16. pg_prepared_statements
53.17. pg_prepared_xacts
53.18. pg_publication_tables
53.19. pg_replication_origin_status
53.20. pg_replication_slots
53.21. pg_roles
53.22. pg_rules
53.23. pg_seclabels
53.24. pg_sequences
53.25. pg_settings
53.26. pg_shadow
53.27. pg_shmem_allocations
53.28. pg_shmem_allocations_numa
53.29. pg_stats
53.30. pg_stats_ext
53.31. pg_stats_ext_exprs
53.32. pg_tables
53.33. pg_timezone_abbrevs
53.34. pg_timezone_names
53.35. pg_user
53.36. pg_user_mappings
53.37. pg_views
53.38. pg_wait_events
In addition to the system catalogs, PostgreSQL provides a number of built-in views. Some system views provide convenient access to some commonly used queries on the system catalogs. Other views provide access to internal server state.
The information schema (Chapter 35) provides an alternative set of views which overlap the functionality of the system views. Since the information schema is SQL-standard whereas the views described here are PostgreSQL-specific, it's usually better to use the information schema if it provides all the information you need.
Table 53.1 lists the system views described here. More detailed documentation of each view follows below. There are some additional views that provide access to accumulated statistics; they are described in Table 27.2.
Prev Up Next
52.65. pg_user_mapping
Home
53.1. Overview
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
