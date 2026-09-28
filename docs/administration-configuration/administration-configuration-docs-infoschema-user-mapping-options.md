# PostgreSQL: Documentation: 18: 35.61. user_mapping_options

PostgreSQL: Documentation: 18: 35.61. user_mapping_options Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.61. user_mapping_options
Prev Up Chapter 35. The Information Schema Home Next
35.61. user_mapping_options #
The view user_mapping_options contains all the options defined for user mappings in the current database. Only those user mappings are shown where the current user has access to the corresponding foreign server (by way of being the owner or having some privilege).
Table 35.59. user_mapping_options Columns Column Type Description authorization_identifier sql_identifier Name of the user being mapped, or PUBLIC if the mapping is public foreign_server_catalog sql_identifier Name of the database that the foreign server used by this mapping is defined in (always the current database) foreign_server_name sql_identifier Name of the foreign server used by this mapping option_name sql_identifier Name of an option option_value character_data Value of the option. This column will show as null unless the current user is the user being mapped, or the mapping is for PUBLIC and the current user is the server owner, or the current user is a superuser. The intent is to protect password information stored as user mapping option.
Prev Up Next
35.60. user_defined_types
Home
35.62. user_mappings
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
