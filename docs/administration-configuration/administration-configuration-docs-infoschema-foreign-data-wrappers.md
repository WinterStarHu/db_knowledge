# PostgreSQL: Documentation: 18: 35.27. foreign_data_wrappers

PostgreSQL: Documentation: 18: 35.27. foreign_data_wrappers Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.27. foreign_data_wrappers
Prev Up Chapter 35. The Information Schema Home Next
35.27. foreign_data_wrappers #
The view foreign_data_wrappers contains all foreign-data wrappers defined in the current database. Only those foreign-data wrappers are shown that the current user has access to (by way of being the owner or having some privilege).
Table 35.25. foreign_data_wrappers Columns Column Type Description foreign_data_wrapper_catalog sql_identifier Name of the database that contains the foreign-data wrapper (always the current database) foreign_data_wrapper_name sql_identifier Name of the foreign-data wrapper authorization_identifier sql_identifier Name of the owner of the foreign server library_name character_data File name of the library that implementing this foreign-data wrapper foreign_data_wrapper_language character_data Language used to implement this foreign-data wrapper Prev Up Next
35.26. foreign_data_wrapper_options
Home
35.28. foreign_server_options
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
