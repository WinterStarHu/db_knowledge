# PostgreSQL: Documentation: 18: 52.19. pg_description

PostgreSQL: Documentation: 18: 52.19. pg_description Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.19. pg_description
Prev Up Chapter 52. System Catalogs Home Next
52.19. pg_description #
The catalog pg_description stores optional descriptions (comments) for each database object. Descriptions can be manipulated with the COMMENT command and viewed with psql's \d commands. Descriptions of many built-in system objects are provided in the initial contents of pg_description.
See also pg_shdescription, which performs a similar function for descriptions involving objects that are shared across a database cluster.
Table 52.19. pg_description Columns Column Type Description objoid oid (references any OID column) The OID of the object this description pertains to classoid oid (references pg_class.oid) The OID of the system catalog this object appears in objsubid int4 For a comment on a table column, this is the column number (the objoid and classoid refer to the table itself). For all other object types, this column is zero.
description text
Arbitrary text that serves as the description of this object Prev Up Next
52.18. pg_depend
Home
52.20. pg_enum
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
