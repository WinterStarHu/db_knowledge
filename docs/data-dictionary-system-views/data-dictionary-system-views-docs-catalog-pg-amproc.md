# PostgreSQL: Documentation: 18: 52.5. pg_amproc

PostgreSQL: Documentation: 18: 52.5. pg_amproc Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.5. pg_amproc
Prev Up Chapter 52. System Catalogs Home Next
52.5. pg_amproc #
The catalog pg_amproc stores information about support functions associated with access method operator families. There is one row for each support function belonging to an operator family.
Table 52.5. pg_amproc Columns Column Type Description oid oid Row identifier amprocfamily oid (references pg_opfamily.oid) The operator family this entry is for amproclefttype oid (references pg_type.oid) Left-hand input data type of associated operator amprocrighttype oid (references pg_type.oid) Right-hand input data type of associated operator amprocnum int2 Support function number amproc regproc (references pg_proc.oid) OID of the function The usual interpretation of the amproclefttype and amprocrighttype fields is that they identify the left and right input types of the operator(s) that a particular support function supports. For some access methods these match the input data type(s) of the support function itself, for others not. There is a notion of “default” support functions for an index, which are those with amproclefttype and amprocrighttype both equal to the index operator class's opcintype.
Prev Up Next
52.4. pg_amop
Home
52.6. pg_attrdef
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
