# PostgreSQL: Documentation: 18: 52.4. pg_amop

PostgreSQL: Documentation: 18: 52.4. pg_amop Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.4. pg_amop
Prev Up Chapter 52. System Catalogs Home Next
52.4. pg_amop #
The catalog pg_amop stores information about operators associated with access method operator families. There is one row for each operator that is a member of an operator family. A family member can be either a search operator or an ordering operator. An operator can appear in more than one family, but cannot appear in more than one search position nor more than one ordering position within a family. (It is allowed, though unlikely, for an operator to be used for both search and ordering purposes.) Table 52.4. pg_amop Columns Column Type Description oid oid Row identifier amopfamily oid (references pg_opfamily.oid) The operator family this entry is for amoplefttype oid (references pg_type.oid) Left-hand input data type of operator amoprighttype oid (references pg_type.oid) Right-hand input data type of operator amopstrategy int2 Operator strategy number amoppurpose char Operator purpose, either s for search or o for ordering amopopr oid (references pg_operator.oid) OID of the operator amopmethod oid (references pg_am.oid) Index access method operator family is for amopsortfamily oid (references pg_opfamily.oid) The B-tree operator family this entry sorts according to, if an ordering operator; zero if a search operator A “search” operator entry indicates that an index of this operator family can be searched to find all rows satisfying WHERE indexed_column operator constant. Obviously, such an operator must return boolean, and its left-hand input type must match the index's column data type.
An “ordering” operator entry indicates that an index of this operator family can be scanned to return rows in the order represented by ORDER BY indexed_column operator constant. Such an operator could return any sortable data type, though again its left-hand input type must match the index's column data type. The exact semantics of the ORDER BY are specified by the amopsortfamily column, which must reference a B-tree operator family for the operator's result type.
Note At present, it's assumed that the sort order for an ordering operator is the default for the referenced operator family, i.e., ASC NULLS LAST. This might someday be relaxed by adding additional columns to specify sort options explicitly.
An entry's amopmethod must match the opfmethod of its containing operator family (including amopmethod here is an intentional denormalization of the catalog structure for performance reasons). Also, amoplefttype and amoprighttype must match the oprleft and oprright fields of the referenced pg_operator entry.
Prev Up Next
52.3. pg_am
Home
52.5. pg_amproc
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
