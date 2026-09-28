# PostgreSQL: Documentation: 18: 35.5. applicable_roles

PostgreSQL: Documentation: 18: 35.5. applicable_roles Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.5. applicable_roles
Prev Up Chapter 35. The Information Schema Home Next
35.5. applicable_roles #
The view applicable_roles identifies all roles whose privileges the current user can use. This means there is some chain of role grants from the current user to the role in question. The current user itself is also an applicable role. The set of applicable roles is generally used for permission checking.
Table 35.3. applicable_roles Columns Column Type Description grantee sql_identifier Name of the role to which this role membership was granted (can be the current user, or a different role in case of nested role memberships) role_name sql_identifier Name of a role is_grantable yes_or_no YES if the grantee has the admin option on the role, NO if not Prev Up Next
35.4. administrable_role_​authorizations
Home
35.6. attributes
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
