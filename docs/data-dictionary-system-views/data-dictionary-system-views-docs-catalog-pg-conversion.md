# PostgreSQL: Documentation: 18: 52.14. pg_conversion

PostgreSQL: Documentation: 18: 52.14. pg_conversion Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.3
52.14. pg_conversion
Prev Up Chapter 52. System Catalogs Home Next
52.14. pg_conversion #
The catalog pg_conversion describes encoding conversion functions. See CREATE CONVERSION for more information.
Table 52.14. pg_conversion Columns Column Type Description oid oid Row identifier conname name Conversion name (unique within a namespace) connamespace oid (references pg_namespace.oid) The OID of the namespace that contains this conversion conowner oid (references pg_authid.oid) Owner of the conversion conforencoding int4 Source encoding ID (pg_encoding_to_char() can translate this number to the encoding name) contoencoding int4 Destination encoding ID (pg_encoding_to_char() can translate this number to the encoding name) conproc regproc (references pg_proc.oid) Conversion function condefault bool True if this is the default conversion Prev Up Next
52.13. pg_constraint
Home
52.15. pg_database
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
