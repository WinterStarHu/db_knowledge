# PostgreSQL: Documentation: 18: 52.49. pg_shdescription

PostgreSQL: Documentation: 18: 52.49. pg_shdescription Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.49. pg_shdescription
Prev Up Chapter 52. System Catalogs Home Next
52.49. pg_shdescription #
The catalog pg_shdescription stores optional descriptions (comments) for shared database objects. Descriptions can be manipulated with the COMMENT command and viewed with psql's \d commands.
See also pg_description, which performs a similar function for descriptions involving objects within a single database.
Unlike most system catalogs, pg_shdescription is shared across all databases of a cluster: there is only one copy of pg_shdescription per cluster, not one per database.
Table 52.49. pg_shdescription Columns Column Type Description objoid oid (references any OID column) The OID of the object this description pertains to classoid oid (references pg_class.oid) The OID of the system catalog this object appears in
description text
Arbitrary text that serves as the description of this object Prev Up Next
52.48. pg_shdepend
Home
52.50. pg_shseclabel
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
