# PostgreSQL: Documentation: 18: 52.63. pg_ts_template

PostgreSQL: Documentation: 18: 52.63. pg_ts_template Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.63. pg_ts_template
Prev Up Chapter 52. System Catalogs Home Next
52.63. pg_ts_template #
The pg_ts_template catalog contains entries defining text search templates. A template is the implementation skeleton for a class of text search dictionaries. Since a template must be implemented by C-language-level functions, creation of new templates is restricted to database superusers.
PostgreSQL's text search features are described at length in Chapter 12.
Table 52.63. pg_ts_template Columns Column Type Description oid oid Row identifier tmplname name Text search template name tmplnamespace oid (references pg_namespace.oid) The OID of the namespace that contains this template tmplinit regproc (references pg_proc.oid) OID of the template's initialization function (zero if none) tmpllexize regproc (references pg_proc.oid) OID of the template's lexize function Prev Up Next
52.62. pg_ts_parser
Home
52.64. pg_type
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
