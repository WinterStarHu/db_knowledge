# PostgreSQL: Documentation: 18: 53.9. pg_group

PostgreSQL: Documentation: 18: 53.9. pg_group Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.9. pg_group
Prev Up Chapter 53. System Views Home Next
53.9. pg_group #
The view pg_group exists for backwards compatibility: it emulates a catalog that existed in PostgreSQL before version 8.1. It shows the names and members of all roles that are marked as not rolcanlogin, which is an approximation to the set of roles that are being used as groups.
Table 53.9. pg_group Columns Column Type Description groname name (references pg_authid.rolname) Name of the group grosysid oid (references pg_authid.oid) ID of this group grolist oid[] (references pg_authid.oid) An array containing the IDs of the roles in this group Prev Up Next
53.8. pg_file_settings
Home
53.10. pg_hba_file_rules
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
