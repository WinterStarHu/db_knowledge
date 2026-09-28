# PostgreSQL: Documentation: 18: 53.35. pg_user

PostgreSQL: Documentation: 18: 53.35. pg_user Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.35. pg_user
Prev Up Chapter 53. System Views Home Next
53.35. pg_user #
The view pg_user provides access to information about database users. This is simply a publicly readable view of pg_shadow that blanks out the password field.
Table 53.35. pg_user Columns Column Type Description usename name User name usesysid oid ID of this user usecreatedb bool User can create databases usesuper bool User is a superuser userepl bool User can initiate streaming replication and put the system in and out of backup mode.
usebypassrls bool User bypasses every row-level security policy, see Section 5.9 for more information.
passwd text Not the password (always reads as ********) valuntil timestamptz Password expiry time (only used for password authentication) useconfig text[] Session defaults for run-time configuration variables Prev Up Next
53.34. pg_timezone_names
Home
53.36. pg_user_mappings
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
