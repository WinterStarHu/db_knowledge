# PostgreSQL: Documentation: 18: 52.50. pg_shseclabel

PostgreSQL: Documentation: 18: 52.50. pg_shseclabel Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.50. pg_shseclabel
Prev Up Chapter 52. System Catalogs Home Next
52.50. pg_shseclabel #
The catalog pg_shseclabel stores security labels on shared database objects. Security labels can be manipulated with the SECURITY LABEL command. For an easier way to view security labels, see Section 53.23.
See also pg_seclabel, which performs a similar function for security labels involving objects within a single database.
Unlike most system catalogs, pg_shseclabel is shared across all databases of a cluster: there is only one copy of pg_shseclabel per cluster, not one per database.
Table 52.50. pg_shseclabel Columns Column Type Description objoid oid (references any OID column) The OID of the object this security label pertains to classoid oid (references pg_class.oid) The OID of the system catalog this object appears in provider text The label provider associated with this label.
label text The security label applied to this object.
Prev Up Next
52.49. pg_shdescription
Home
52.51. pg_statistic
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
