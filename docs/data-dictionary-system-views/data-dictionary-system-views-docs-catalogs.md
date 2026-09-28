# PostgreSQL: Documentation: 18: Chapter 52. System Catalogs

PostgreSQL: Documentation: 18: Chapter 52. System Catalogs Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.1
Chapter 52. System Catalogs Prev Up Part VII. Internals Home Next Chapter 52. System Catalogs Table of Contents
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
The system catalogs are the place where a relational database management system stores schema metadata, such as information about tables and columns, and internal bookkeeping information. PostgreSQL's system catalogs are regular tables. You can drop and recreate the tables, add columns, insert and update values, and severely mess up your system that way. Normally, one should not change the system catalogs by hand, there are normally SQL commands to do that. (For example, CREATE DATABASE inserts a row into the pg_database catalog — and actually creates the database on disk.) There are some exceptions for particularly esoteric operations, but many of those have been made available as SQL commands over time, and so the need for direct manipulation of the system catalogs is ever decreasing.
Prev Up Next
51.6. Executor
Home
52.1. Overview
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
