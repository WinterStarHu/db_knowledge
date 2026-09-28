# PostgreSQL: Documentation: 18: Chapter 35. The Information Schema

PostgreSQL: Documentation: 18: Chapter 35. The Information Schema Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 35. The Information Schema Prev Up Part IV. Client Interfaces Home Next Chapter 35. The Information Schema Table of Contents
35.1. The Schema
35.2. Data Types
35.3. information_schema_catalog_name
35.4. administrable_role_​authorizations
35.5. applicable_roles
35.6. attributes
35.7. character_sets
35.8. check_constraint_routine_usage
35.9. check_constraints
35.10. collations
35.11. collation_character_set_​applicability
35.12. column_column_usage
35.13. column_domain_usage
35.14. column_options
35.15. column_privileges
35.16. column_udt_usage
35.17. columns
35.18. constraint_column_usage
35.19. constraint_table_usage
35.20. data_type_privileges
35.21. domain_constraints
35.22. domain_udt_usage
35.23. domains
35.24. element_types
35.25. enabled_roles
35.26. foreign_data_wrapper_options
35.27. foreign_data_wrappers
35.28. foreign_server_options
35.29. foreign_servers
35.30. foreign_table_options
35.31. foreign_tables
35.32. key_column_usage
35.33. parameters
35.34. referential_constraints
35.35. role_column_grants
35.36. role_routine_grants
35.37. role_table_grants
35.38. role_udt_grants
35.39. role_usage_grants
35.40. routine_column_usage
35.41. routine_privileges
35.42. routine_routine_usage
35.43. routine_sequence_usage
35.44. routine_table_usage
35.45. routines
35.46. schemata
35.47. sequences
35.48. sql_features
35.49. sql_implementation_info
35.50. sql_parts
35.51. sql_sizing
35.52. table_constraints
35.53. table_privileges
35.54. tables
35.55. transforms
35.56. triggered_update_columns
35.57. triggers
35.58. udt_privileges
35.59. usage_privileges
35.60. user_defined_types
35.61. user_mapping_options
35.62. user_mappings
35.63. view_column_usage
35.64. view_routine_usage
35.65. view_table_usage
35.66. views
The information schema consists of a set of views that contain information about the objects defined in the current database. The information schema is defined in the SQL standard and can therefore be expected to be portable and remain stable — unlike the system catalogs, which are specific to PostgreSQL and are modeled after implementation concerns. The information schema views do not, however, contain information about PostgreSQL-specific features; to inquire about those you need to query the system catalogs or other PostgreSQL-specific views.
Note When querying the database for constraint information, it is possible for a standard-compliant query that expects to return one row to return several. This is because the SQL standard requires constraint names to be unique within a schema, but PostgreSQL does not enforce this restriction. PostgreSQL automatically-generated constraint names avoid duplicates in the same schema, but users can specify such duplicate names.
This problem can appear when querying information schema views such as check_constraint_routine_usage, check_constraints, domain_constraints, and referential_constraints. Some other views have similar issues but contain the table name to help distinguish duplicate rows, e.g., constraint_column_usage, constraint_table_usage, table_constraints.
Prev Up Next
34.17. Internals
Home
35.1. The Schema
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
