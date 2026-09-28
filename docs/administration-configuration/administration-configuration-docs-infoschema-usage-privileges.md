# PostgreSQL: Documentation: 18: 35.59. usage_privileges

PostgreSQL: Documentation: 18: 35.59. usage_privileges Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.59. usage_privileges
Prev Up Chapter 35. The Information Schema Home Next
35.59. usage_privileges #
The view usage_privileges identifies USAGE privileges granted on various kinds of objects to a currently enabled role or by a currently enabled role. In PostgreSQL, this currently applies to collations, domains, foreign-data wrappers, foreign servers, and sequences. There is one row for each combination of object, grantor, and grantee.
Since collations do not have real privileges in PostgreSQL, this view shows implicit non-grantable USAGE privileges granted by the owner to PUBLIC for all collations. The other object types, however, show real privileges.
In PostgreSQL, sequences also support SELECT and UPDATE privileges in addition to the USAGE privilege. These are nonstandard and therefore not visible in the information schema.
Table 35.57. usage_privileges Columns Column Type Description grantor sql_identifier Name of the role that granted the privilege grantee sql_identifier Name of the role that the privilege was granted to object_catalog sql_identifier Name of the database containing the object (always the current database) object_schema sql_identifier Name of the schema containing the object, if applicable, else an empty string object_name sql_identifier Name of the object object_type character_data COLLATION or DOMAIN or FOREIGN DATA WRAPPER or FOREIGN SERVER or SEQUENCE privilege_type character_data Always USAGE is_grantable yes_or_no YES if the privilege is grantable, NO if not Prev Up Next
35.58. udt_privileges
Home
35.60. user_defined_types
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
