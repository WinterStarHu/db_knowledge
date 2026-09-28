# PostgreSQL: Documentation: 18: 52.31. pg_largeobject_metadata

PostgreSQL: Documentation: 18: 52.31. pg_largeobject_metadata Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.31. pg_largeobject_metadata
Prev Up Chapter 52. System Catalogs Home Next
52.31. pg_largeobject_metadata #
The catalog pg_largeobject_metadata holds metadata associated with large objects. The actual large object data is stored in pg_largeobject.
Table 52.31. pg_largeobject_metadata Columns Column Type Description oid oid Row identifier lomowner oid (references pg_authid.oid) Owner of the large object lomacl aclitem[] Access privileges; see Section 5.8 for details Prev Up Next
52.30. pg_largeobject
Home
52.32. pg_namespace
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
