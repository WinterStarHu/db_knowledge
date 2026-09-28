# PostgreSQL: Documentation: 18: 35.58. udt_privileges

PostgreSQL: Documentation: 18: 35.58. udt_privileges Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.58. udt_privileges
Prev Up Chapter 35. The Information Schema Home Next
35.58. udt_privileges #
The view udt_privileges identifies USAGE privileges granted on user-defined types to a currently enabled role or by a currently enabled role. There is one row for each combination of type, grantor, and grantee. This view shows only composite types (see under Section 35.60 for why); see Section 35.59 for domain privileges.
Table 35.56. udt_privileges Columns Column Type Description grantor sql_identifier Name of the role that granted the privilege grantee sql_identifier Name of the role that the privilege was granted to udt_catalog sql_identifier Name of the database containing the type (always the current database) udt_schema sql_identifier Name of the schema containing the type udt_name sql_identifier Name of the type privilege_type character_data Always TYPE USAGE is_grantable yes_or_no YES if the privilege is grantable, NO if not Prev Up Next
35.57. triggers
Home
35.59. usage_privileges
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
