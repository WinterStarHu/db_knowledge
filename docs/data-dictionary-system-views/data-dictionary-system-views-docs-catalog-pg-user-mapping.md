# PostgreSQL: Documentation: 18: 52.65. pg_user_mapping

PostgreSQL: Documentation: 18: 52.65. pg_user_mapping Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.65. pg_user_mapping
Prev Up Chapter 52. System Catalogs Home Next
52.65. pg_user_mapping #
The catalog pg_user_mapping stores the mappings from local user to remote. Access to this catalog is restricted from normal users, use the view pg_user_mappings instead.
Table 52.66. pg_user_mapping Columns Column Type Description oid oid Row identifier umuser oid (references pg_authid.oid) OID of the local role being mapped, or zero if the user mapping is public umserver oid (references pg_foreign_server.oid) The OID of the foreign server that contains this mapping umoptions text[] User mapping specific options, as “keyword=value” strings Prev Up Next
52.64. pg_type
Home Chapter 53. System Views Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
