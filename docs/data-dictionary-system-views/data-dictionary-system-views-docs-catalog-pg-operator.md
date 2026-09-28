# PostgreSQL: Documentation: 18: 52.34. pg_operator

PostgreSQL: Documentation: 18: 52.34. pg_operator Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.34. pg_operator
Prev Up Chapter 52. System Catalogs Home Next
52.34. pg_operator #
The catalog pg_operator stores information about operators. See CREATE OPERATOR and Section 36.14 for more information.
Table 52.34. pg_operator Columns Column Type Description oid oid Row identifier oprname name Name of the operator oprnamespace oid (references pg_namespace.oid) The OID of the namespace that contains this operator oprowner oid (references pg_authid.oid) Owner of the operator oprkind char b = infix operator (“both”), or l = prefix operator (“left”) oprcanmerge bool This operator supports merge joins oprcanhash bool This operator supports hash joins oprleft oid (references pg_type.oid) Type of the left operand (zero for a prefix operator) oprright oid (references pg_type.oid) Type of the right operand oprresult oid (references pg_type.oid) Type of the result (zero for a not-yet-defined “shell” operator) oprcom oid (references pg_operator.oid) Commutator of this operator (zero if none) oprnegate oid (references pg_operator.oid) Negator of this operator (zero if none) oprcode regproc (references pg_proc.oid) Function that implements this operator (zero for a not-yet-defined “shell” operator) oprrest regproc (references pg_proc.oid) Restriction selectivity estimation function for this operator (zero if none) oprjoin regproc (references pg_proc.oid) Join selectivity estimation function for this operator (zero if none) Prev Up Next
52.33. pg_opclass
Home
52.35. pg_opfamily
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
