# PostgreSQL: Documentation: 18: 52.47. pg_sequence

PostgreSQL: Documentation: 18: 52.47. pg_sequence Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
52.47. pg_sequence
Prev Up Chapter 52. System Catalogs Home Next
52.47. pg_sequence #
The catalog pg_sequence contains information about sequences. Some of the information about sequences, such as the name and the schema, is in pg_class Table 52.47. pg_sequence Columns Column Type Description seqrelid oid (references pg_class.oid) The OID of the pg_class entry for this sequence seqtypid oid (references pg_type.oid) Data type of the sequence seqstart int8 Start value of the sequence seqincrement int8 Increment value of the sequence seqmax int8 Maximum value of the sequence seqmin int8 Minimum value of the sequence seqcache int8 Cache size of the sequence seqcycle bool Whether the sequence cycles Prev Up Next
52.46. pg_seclabel
Home
52.48. pg_shdepend
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
