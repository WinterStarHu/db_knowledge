# PostgreSQL: Documentation: 18: 52.16. pg_db_role_setting

PostgreSQL: Documentation: 18: 52.16. pg_db_role_setting Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.16. pg_db_role_setting
Prev Up Chapter 52. System Catalogs Home Next
52.16. pg_db_role_setting #
The catalog pg_db_role_setting records the default values that have been set for run-time configuration variables, for each role and database combination.
Unlike most system catalogs, pg_db_role_setting is shared across all databases of a cluster: there is only one copy of pg_db_role_setting per cluster, not one per database.
Table 52.16. pg_db_role_setting Columns Column Type Description setdatabase oid (references pg_database.oid) The OID of the database the setting is applicable to, or zero if not database-specific setrole oid (references pg_authid.oid) The OID of the role the setting is applicable to, or zero if not role-specific setconfig text[] Defaults for run-time configuration variables Prev Up Next
52.15. pg_database
Home
52.17. pg_default_acl
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
