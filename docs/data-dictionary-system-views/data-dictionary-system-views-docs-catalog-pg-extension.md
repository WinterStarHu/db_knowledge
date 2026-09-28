# PostgreSQL: Documentation: 18: 52.22. pg_extension

PostgreSQL: Documentation: 18: 52.22. pg_extension Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.22. pg_extension
Prev Up Chapter 52. System Catalogs Home Next
52.22. pg_extension #
The catalog pg_extension stores information about the installed extensions. See Section 36.17 for details about extensions.
Table 52.22. pg_extension Columns Column Type Description oid oid Row identifier extname name Name of the extension extowner oid (references pg_authid.oid) Owner of the extension extnamespace oid (references pg_namespace.oid) Schema containing the extension's exported objects extrelocatable bool True if extension can be relocated to another schema extversion text Version name for the extension extconfig oid[] (references pg_class.oid) Array of regclass OIDs for the extension's configuration table(s), or NULL if none extcondition text[] Array of WHERE-clause filter conditions for the extension's configuration table(s), or NULL if none Note that unlike most catalogs with a “namespace” column, extnamespace is not meant to imply that the extension belongs to that schema. Extension names are never schema-qualified. Rather, extnamespace indicates the schema that contains most or all of the extension's objects. If extrelocatable is true, then this schema must in fact contain all schema-qualifiable objects belonging to the extension.
Prev Up Next
52.21. pg_event_trigger
Home
52.23. pg_foreign_data_wrapper
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
