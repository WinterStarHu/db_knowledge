# PostgreSQL: Documentation: 18: 35.60. user_defined_types

PostgreSQL: Documentation: 18: 35.60. user_defined_types Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.60. user_defined_types
Prev Up Chapter 35. The Information Schema Home Next
35.60. user_defined_types #
The view user_defined_types currently contains all composite types defined in the current database. Only those types are shown that the current user has access to (by way of being the owner or having some privilege).
SQL knows about two kinds of user-defined types: structured types (also known as composite types in PostgreSQL) and distinct types (not implemented in PostgreSQL). To be future-proof, use the column user_defined_type_category to differentiate between these. Other user-defined types such as base types and enums, which are PostgreSQL extensions, are not shown here. For domains, see Section 35.23 instead.
Table 35.58. user_defined_types Columns Column Type Description user_defined_type_catalog sql_identifier Name of the database that contains the type (always the current database) user_defined_type_schema sql_identifier Name of the schema that contains the type user_defined_type_name sql_identifier Name of the type user_defined_type_category character_data Currently always STRUCTURED is_instantiable yes_or_no Applies to a feature not available in PostgreSQL is_final yes_or_no Applies to a feature not available in PostgreSQL ordering_form character_data Applies to a feature not available in PostgreSQL ordering_category character_data Applies to a feature not available in PostgreSQL ordering_routine_catalog sql_identifier Applies to a feature not available in PostgreSQL ordering_routine_schema sql_identifier Applies to a feature not available in PostgreSQL ordering_routine_name sql_identifier Applies to a feature not available in PostgreSQL reference_type character_data Applies to a feature not available in PostgreSQL data_type character_data Applies to a feature not available in PostgreSQL character_maximum_length cardinal_number Applies to a feature not available in PostgreSQL character_octet_length cardinal_number Applies to a feature not available in PostgreSQL character_set_catalog sql_identifier Applies to a feature not available in PostgreSQL character_set_schema sql_identifier Applies to a feature not available in PostgreSQL character_set_name sql_identifier Applies to a feature not available in PostgreSQL collation_catalog sql_identifier Applies to a feature not available in PostgreSQL collation_schema sql_identifier Applies to a feature not available in PostgreSQL collation_name sql_identifier Applies to a feature not available in PostgreSQL numeric_precision cardinal_number Applies to a feature not available in PostgreSQL numeric_precision_radix cardinal_number Applies to a feature not available in PostgreSQL numeric_scale cardinal_number Applies to a feature not available in PostgreSQL datetime_precision cardinal_number Applies to a feature not available in PostgreSQL interval_type character_data Applies to a feature not available in PostgreSQL interval_precision cardinal_number Applies to a feature not available in PostgreSQL source_dtd_identifier sql_identifier Applies to a feature not available in PostgreSQL ref_dtd_identifier sql_identifier Applies to a feature not available in PostgreSQL Prev Up Next
35.59. usage_privileges
Home
35.61. user_mapping_options
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
