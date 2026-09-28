# PostgreSQL: Documentation: 18: Part VII. Internals

PostgreSQL: Documentation: 18: Part VII. Internals Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Part VII. Internals Prev Up PostgreSQL 18.6 Documentation Home Next Part VII. Internals This part contains assorted information that might be of use to PostgreSQL developers.
Table of Contents
51. Overview of PostgreSQL Internals
51.1. The Path of a Query
51.2. How Connections Are Established
51.3. The Parser Stage
51.4. The PostgreSQL Rule System
51.5. Planner/Optimizer
51.6. Executor
52. System Catalogs
52.1. Overview
52.2. pg_aggregate
52.3. pg_am
52.4. pg_amop
52.5. pg_amproc
52.6. pg_attrdef
52.7. pg_attribute
52.8. pg_authid
52.9. pg_auth_members
52.10. pg_cast
52.11. pg_class
52.12. pg_collation
52.13. pg_constraint
52.14. pg_conversion
52.15. pg_database
52.16. pg_db_role_setting
52.17. pg_default_acl
52.18. pg_depend
52.19. pg_description
52.20. pg_enum
52.21. pg_event_trigger
52.22. pg_extension
52.23. pg_foreign_data_wrapper
52.24. pg_foreign_server
52.25. pg_foreign_table
52.26. pg_index
52.27. pg_inherits
52.28. pg_init_privs
52.29. pg_language
52.30. pg_largeobject
52.31. pg_largeobject_metadata
52.32. pg_namespace
52.33. pg_opclass
52.34. pg_operator
52.35. pg_opfamily
52.36. pg_parameter_acl
52.37. pg_partitioned_table
52.38. pg_policy
52.39. pg_proc
52.40. pg_publication
52.41. pg_publication_namespace
52.42. pg_publication_rel
52.43. pg_range
52.44. pg_replication_origin
52.45. pg_rewrite
52.46. pg_seclabel
52.47. pg_sequence
52.48. pg_shdepend
52.49. pg_shdescription
52.50. pg_shseclabel
52.51. pg_statistic
52.52. pg_statistic_ext
52.53. pg_statistic_ext_data
52.54. pg_subscription
52.55. pg_subscription_rel
52.56. pg_tablespace
52.57. pg_transform
52.58. pg_trigger
52.59. pg_ts_config
52.60. pg_ts_config_map
52.61. pg_ts_dict
52.62. pg_ts_parser
52.63. pg_ts_template
52.64. pg_type
52.65. pg_user_mapping
53. System Views
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
54. Frontend/Backend Protocol
54.1. Overview
54.2. Message Flow
54.3. SASL Authentication
54.4. Streaming Replication Protocol
54.5. Logical Streaming Replication Protocol
54.6. Message Data Types
54.7. Message Formats
54.8. Error and Notice Message Fields
54.9. Logical Replication Message Formats
54.10. Summary of Changes since Protocol 2.0
55. PostgreSQL Coding Conventions
55.1. Formatting
55.2. Reporting Errors Within the Server
55.3. Error Message Style Guide
55.4. Miscellaneous Coding Conventions
56. Native Language Support
56.1. For the Translator
56.2. For the Programmer
57. Writing a Procedural Language Handler
58. Writing a Foreign Data Wrapper
58.1. Foreign Data Wrapper Functions
58.2. Foreign Data Wrapper Callback Routines
58.3. Foreign Data Wrapper Helper Functions
58.4. Foreign Data Wrapper Query Planning
58.5. Row Locking in Foreign Data Wrappers
59. Writing a Table Sampling Method
59.1. Sampling Method Support Functions
60. Writing a Custom Scan Provider
60.1. Creating Custom Scan Paths
60.2. Creating Custom Scan Plans
60.3. Executing Custom Scans
61. Genetic Query Optimizer
61.1. Query Handling as a Complex Optimization Problem
61.2. Genetic Algorithms
61.3. Genetic Query Optimization (GEQO) in PostgreSQL
61.4. Further Reading
62. Table Access Method Interface Definition
63. Index Access Method Interface Definition
63.1. Basic API Structure for Indexes
63.2. Index Access Method Functions
63.3. Index Scanning
63.4. Index Locking Considerations
63.5. Index Uniqueness Checks
63.6. Index Cost Estimation Functions
64. Write Ahead Logging for Extensions
64.1. Generic WAL Records
64.2. Custom WAL Resource Managers
65. Built-in Index Access Methods
65.1. B-Tree Indexes
65.2. GiST Indexes
65.3. SP-GiST Indexes
65.4. GIN Indexes
65.5. BRIN Indexes
65.6. Hash Indexes
66. Database Physical Storage
66.1. Database File Layout
66.2. TOAST
66.3. Free Space Map
66.4. Visibility Map
66.5. The Initialization Fork
66.6. Database Page Layout
66.7. Heap-Only Tuples (HOT)
67. Transaction Processing
67.1. Transactions and Identifiers
67.2. Transactions and Locking
67.3. Subtransactions
67.4. Two-Phase Transactions
68. System Catalog Declarations and Initial Contents
68.1. System Catalog Declaration Rules
68.2. System Catalog Initial Data
68.3. BKI File Format
68.4. BKI Commands
68.5. Structure of the Bootstrap BKI File
68.6. BKI Example
69. How the Planner Uses Statistics
69.1. Row Estimation Examples
69.2. Multivariate Statistics Examples
69.3. Planner Statistics and Security
70. Backup Manifest Format
70.1. Backup Manifest Top-level Object
70.2. Backup Manifest File Object
70.3. Backup Manifest WAL Range Object
Prev Up Next postgres Home Chapter 51. Overview of PostgreSQL Internals Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
