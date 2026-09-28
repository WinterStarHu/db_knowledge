# PostgreSQL: Documentation: 18: 52.6. pg_attrdef

PostgreSQL: Documentation: 18: 52.6. pg_attrdef Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.6. pg_attrdef
Prev Up Chapter 52. System Catalogs Home Next
52.6. pg_attrdef #
The catalog pg_attrdef stores column default expressions and generation expressions. The main information about columns is stored in pg_attribute. Only columns for which a default expression or generation expression has been explicitly set will have an entry here.
Table 52.6. pg_attrdef Columns Column Type Description oid oid Row identifier adrelid oid (references pg_class.oid) The table this column belongs to adnum int2 (references pg_attribute.attnum) The number of the column adbin pg_node_tree The column default or generation expression, in nodeToString() representation. Use pg_get_expr(adbin, adrelid) to convert it to an SQL expression.
Prev Up Next
52.5. pg_amproc
Home
52.7. pg_attribute
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
