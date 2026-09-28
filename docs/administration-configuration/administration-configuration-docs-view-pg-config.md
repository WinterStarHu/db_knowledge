# PostgreSQL: Documentation: 18: 53.6. pg_config

PostgreSQL: Documentation: 18: 53.6. pg_config Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
53.6. pg_config
Prev Up Chapter 53. System Views Home Next
53.6. pg_config #
The view pg_config describes the compile-time configuration parameters of the currently installed version of PostgreSQL. It is intended, for example, to be used by software packages that want to interface to PostgreSQL to facilitate finding the required header files and libraries. It provides the same basic information as the pg_config PostgreSQL client application.
By default, the pg_config view can be read only by superusers.
Table 53.6. pg_config Columns Column Type Description name text The parameter name setting text The parameter value Prev Up Next
53.5. pg_backend_memory_contexts
Home
53.7. pg_cursors
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
