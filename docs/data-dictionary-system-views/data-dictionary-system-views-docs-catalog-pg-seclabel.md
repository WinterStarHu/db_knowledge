# PostgreSQL: Documentation: 18: 52.46. pg_seclabel

PostgreSQL: Documentation: 18: 52.46. pg_seclabel Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.46. pg_seclabel
Prev Up Chapter 52. System Catalogs Home Next
52.46. pg_seclabel #
The catalog pg_seclabel stores security labels on database objects. Security labels can be manipulated with the SECURITY LABEL command. For an easier way to view security labels, see Section 53.23.
See also pg_shseclabel, which performs a similar function for security labels of database objects that are shared across a database cluster.
Table 52.46. pg_seclabel Columns Column Type Description objoid oid (references any OID column) The OID of the object this security label pertains to classoid oid (references pg_class.oid) The OID of the system catalog this object appears in objsubid int4 For a security label on a table column, this is the column number (the objoid and classoid refer to the table itself). For all other object types, this column is zero.
provider text The label provider associated with this label.
label text The security label applied to this object.
Prev Up Next
52.45. pg_rewrite
Home
52.47. pg_sequence
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
