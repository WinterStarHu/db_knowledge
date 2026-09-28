# PostgreSQL: Documentation: 18: 52.27. pg_inherits

PostgreSQL: Documentation: 18: 52.27. pg_inherits Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.2
/
7.1
52.27. pg_inherits
Prev Up Chapter 52. System Catalogs Home Next
52.27. pg_inherits #
The catalog pg_inherits records information about table and index inheritance hierarchies. There is one entry for each direct parent-child table or index relationship in the database. (Indirect inheritance can be determined by following chains of entries.) Table 52.27. pg_inherits Columns Column Type Description inhrelid oid (references pg_class.oid) The OID of the child table or index inhparent oid (references pg_class.oid) The OID of the parent table or index inhseqno int4 If there is more than one direct parent for a child table (multiple inheritance), this number tells the order in which the inherited columns are to be arranged. The count starts at 1.
Indexes cannot have multiple inheritance, since they can only inherit when using declarative partitioning.
inhdetachpending bool true for a partition that is in the process of being detached; false otherwise.
Prev Up Next
52.26. pg_index
Home
52.28. pg_init_privs
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
