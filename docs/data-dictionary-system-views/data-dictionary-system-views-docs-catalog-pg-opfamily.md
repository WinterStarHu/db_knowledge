# PostgreSQL: Documentation: 18: 52.35. pg_opfamily

PostgreSQL: Documentation: 18: 52.35. pg_opfamily Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.35. pg_opfamily
Prev Up Chapter 52. System Catalogs Home Next
52.35. pg_opfamily #
The catalog pg_opfamily defines operator families. Each operator family is a collection of operators and associated support routines that implement the semantics specified for a particular index access method. Furthermore, the operators in a family are all “compatible”, in a way that is specified by the access method. The operator family concept allows cross-data-type operators to be used with indexes and to be reasoned about using knowledge of access method semantics.
Operator families are described at length in Section 36.16.
Table 52.35. pg_opfamily Columns Column Type Description oid oid Row identifier opfmethod oid (references pg_am.oid) Index access method operator family is for opfname name Name of this operator family opfnamespace oid (references pg_namespace.oid) Namespace of this operator family opfowner oid (references pg_authid.oid) Owner of the operator family The majority of the information defining an operator family is not in its pg_opfamily row, but in the associated rows in pg_amop, pg_amproc, and pg_opclass.
Prev Up Next
52.34. pg_operator
Home
52.36. pg_parameter_acl
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
