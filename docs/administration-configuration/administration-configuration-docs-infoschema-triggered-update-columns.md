# PostgreSQL: Documentation: 18: 35.56. triggered_update_columns

PostgreSQL: Documentation: 18: 35.56. triggered_update_columns Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.56. triggered_update_columns
Prev Up Chapter 35. The Information Schema Home Next
35.56. triggered_update_columns #
For triggers in the current database that specify a column list (like UPDATE OF column1, column2), the view triggered_update_columns identifies these columns. Triggers that do not specify a column list are not included in this view. Only those columns are shown that the current user owns or has some privilege other than SELECT on.
Table 35.54. triggered_update_columns Columns Column Type Description trigger_catalog sql_identifier Name of the database that contains the trigger (always the current database) trigger_schema sql_identifier Name of the schema that contains the trigger trigger_name sql_identifier Name of the trigger event_object_catalog sql_identifier Name of the database that contains the table that the trigger is defined on (always the current database) event_object_schema sql_identifier Name of the schema that contains the table that the trigger is defined on event_object_table sql_identifier Name of the table that the trigger is defined on event_object_column sql_identifier Name of the column that the trigger is defined on Prev Up Next
35.55. transforms
Home
35.57. triggers
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
