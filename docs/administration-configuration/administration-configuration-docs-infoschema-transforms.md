# PostgreSQL: Documentation: 18: 35.55. transforms

PostgreSQL: Documentation: 18: 35.55. transforms Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
35.55. transforms
Prev Up Chapter 35. The Information Schema Home Next
35.55. transforms #
The view transforms contains information about the transforms defined in the current database. More precisely, it contains a row for each function contained in a transform (the “from SQL” or “to SQL” function).
Table 35.53. transforms Columns Column Type Description udt_catalog sql_identifier Name of the database that contains the type the transform is for (always the current database) udt_schema sql_identifier Name of the schema that contains the type the transform is for udt_name sql_identifier Name of the type the transform is for specific_catalog sql_identifier Name of the database containing the function (always the current database) specific_schema sql_identifier Name of the schema containing the function specific_name sql_identifier The “specific name” of the function. See Section 35.45 for more information.
group_name sql_identifier The SQL standard allows defining transforms in “groups”, and selecting a group at run time. PostgreSQL does not support this. Instead, transforms are specific to a language. As a compromise, this field contains the language the transform is for.
transform_type character_data FROM SQL or TO SQL Prev Up Next
35.54. tables
Home
35.56. triggered_update_columns
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
