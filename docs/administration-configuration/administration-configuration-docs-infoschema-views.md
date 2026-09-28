# PostgreSQL: Documentation: 18: 35.66. views

PostgreSQL: Documentation: 18: 35.66. views Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.66. views
Prev Up Chapter 35. The Information Schema Home Next
35.66. views #
The view views contains all views defined in the current database. Only those views are shown that the current user has access to (by way of being the owner or having some privilege).
Table 35.64. views Columns Column Type Description table_catalog sql_identifier Name of the database that contains the view (always the current database) table_schema sql_identifier Name of the schema that contains the view table_name sql_identifier Name of the view view_definition character_data Query expression defining the view (null if the view is not owned by a currently enabled role) check_option character_data CASCADED or LOCAL if the view has a CHECK OPTION defined on it, NONE if not is_updatable yes_or_no YES if the view is updatable (allows UPDATE and DELETE), NO if not is_insertable_into yes_or_no YES if the view is insertable into (allows INSERT), NO if not is_trigger_updatable yes_or_no YES if the view has an INSTEAD OF UPDATE trigger defined on it, NO if not is_trigger_deletable yes_or_no YES if the view has an INSTEAD OF DELETE trigger defined on it, NO if not is_trigger_insertable_into yes_or_no YES if the view has an INSTEAD OF INSERT trigger defined on it, NO if not Prev Up Next
35.65. view_table_usage
Home Part V. Server Programming Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
