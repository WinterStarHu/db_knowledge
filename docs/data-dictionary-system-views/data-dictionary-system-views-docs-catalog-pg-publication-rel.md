# PostgreSQL: Documentation: 18: 52.42. pg_publication_rel

PostgreSQL: Documentation: 18: 52.42. pg_publication_rel Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
52.42. pg_publication_rel
Prev Up Chapter 52. System Catalogs Home Next
52.42. pg_publication_rel #
The catalog pg_publication_rel contains the mapping between relations and publications in the database. This is a many-to-many mapping. See also Section 53.18 for a more user-friendly view of this information.
Table 52.42. pg_publication_rel Columns Column Type Description oid oid Row identifier prpubid oid (references pg_publication.oid) Reference to publication prrelid oid (references pg_class.oid) Reference to relation prqual pg_node_tree Expression tree (in nodeToString() representation) for the relation's publication qualifying condition. Null if there is no publication qualifying condition.
prattrs int2vector (references pg_attribute.attnum) This is an array of values that indicates which table columns are part of the publication. For example, a value of 1 3 would mean that the first and the third table columns are published. A null value indicates that all columns are published.
Prev Up Next
52.41. pg_publication_namespace
Home
52.43. pg_range
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
