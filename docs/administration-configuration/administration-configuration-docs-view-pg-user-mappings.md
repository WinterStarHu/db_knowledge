# PostgreSQL: Documentation: 18: 53.36. pg_user_mappings

PostgreSQL: Documentation: 18: 53.36. pg_user_mappings Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.36. pg_user_mappings
Prev Up Chapter 53. System Views Home Next
53.36. pg_user_mappings #
The view pg_user_mappings provides access to information about user mappings. This is essentially a publicly readable view of pg_user_mapping that leaves out the options field if the user has no rights to use it.
Table 53.36. pg_user_mappings Columns Column Type Description umid oid (references pg_user_mapping.oid) OID of the user mapping srvid oid (references pg_foreign_server.oid) The OID of the foreign server that contains this mapping srvname name (references pg_foreign_server.srvname) Name of the foreign server umuser oid (references pg_authid.oid) OID of the local role being mapped, or zero if the user mapping is public usename name Name of the local user to be mapped umoptions text[] User mapping specific options, as “keyword=value” strings To protect password information stored as a user mapping option, the umoptions column will read as null unless one of the following applies:
current user is the user being mapped, and owns the server or holds USAGE privilege on it current user is the server owner and mapping is for PUBLIC current user is a superuser Prev Up Next
53.35. pg_user
Home
53.37. pg_views
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
