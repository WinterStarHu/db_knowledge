# PostgreSQL: Documentation: 18: 35.25. enabled_roles

PostgreSQL: Documentation: 18: 35.25. enabled_roles Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.25. enabled_roles
Prev Up Chapter 35. The Information Schema Home Next
35.25. enabled_roles #
The view enabled_roles identifies the currently “enabled roles”. The enabled roles are recursively defined as the current user together with all roles that have been granted to the enabled roles with automatic inheritance. In other words, these are all roles that the current user has direct or indirect, automatically inheriting membership in.
For permission checking, the set of “applicable roles” is applied, which can be broader than the set of enabled roles. So generally, it is better to use the view applicable_roles instead of this one; See Section 35.5 for details on applicable_roles view.
Table 35.23. enabled_roles Columns Column Type Description role_name sql_identifier Name of a role Prev Up Next
35.24. element_types
Home
35.26. foreign_data_wrapper_options
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
