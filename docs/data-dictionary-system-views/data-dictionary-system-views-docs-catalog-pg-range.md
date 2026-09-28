# PostgreSQL: Documentation: 18: 52.43. pg_range

PostgreSQL: Documentation: 18: 52.43. pg_range Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.43. pg_range
Prev Up Chapter 52. System Catalogs Home Next
52.43. pg_range #
The catalog pg_range stores information about range types. This is in addition to the types' entries in pg_type.
Table 52.43. pg_range Columns Column Type Description rngtypid oid (references pg_type.oid) OID of the range type rngsubtype oid (references pg_type.oid) OID of the element type (subtype) of this range type rngmultitypid oid (references pg_type.oid) OID of the multirange type for this range type rngcollation oid (references pg_collation.oid) OID of the collation used for range comparisons, or zero if none rngsubopc oid (references pg_opclass.oid) OID of the subtype's operator class used for range comparisons rngcanonical regproc (references pg_proc.oid) OID of the function to convert a range value into canonical form, or zero if none rngsubdiff regproc (references pg_proc.oid) OID of the function to return the difference between two element values as double precision, or zero if none rngsubopc (plus rngcollation, if the element type is collatable) determines the sort ordering used by the range type. rngcanonical is used when the element type is discrete. rngsubdiff is optional but should be supplied to improve performance of GiST indexes on the range type.
Prev Up Next
52.42. pg_publication_rel
Home
52.44. pg_replication_origin
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
