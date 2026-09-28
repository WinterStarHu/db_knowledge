# PostgreSQL: Documentation: 18: 52.57. pg_transform

PostgreSQL: Documentation: 18: 52.57. pg_transform Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
52.57. pg_transform
Prev Up Chapter 52. System Catalogs Home Next
52.57. pg_transform #
The catalog pg_transform stores information about transforms, which are a mechanism to adapt data types to procedural languages. See CREATE TRANSFORM for more information.
Table 52.57. pg_transform Columns Column Type Description oid oid Row identifier trftype oid (references pg_type.oid) OID of the data type this transform is for trflang oid (references pg_language.oid) OID of the language this transform is for trffromsql regproc (references pg_proc.oid) The OID of the function to use when converting the data type for input to the procedural language (e.g., function parameters). Zero is stored if the default behavior should be used.
trftosql regproc (references pg_proc.oid) The OID of the function to use when converting output from the procedural language (e.g., return values) to the data type. Zero is stored if the default behavior should be used.
Prev Up Next
52.56. pg_tablespace
Home
52.58. pg_trigger
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
