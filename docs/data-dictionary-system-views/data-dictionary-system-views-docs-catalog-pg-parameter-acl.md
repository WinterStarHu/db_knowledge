# PostgreSQL: Documentation: 18: 52.36. pg_parameter_acl

PostgreSQL: Documentation: 18: 52.36. pg_parameter_acl Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel
52.36. pg_parameter_acl
Prev Up Chapter 52. System Catalogs Home Next
52.36. pg_parameter_acl #
The catalog pg_parameter_acl records configuration parameters for which privileges have been granted to one or more roles. No entry is made for parameters that have default privileges.
Unlike most system catalogs, pg_parameter_acl is shared across all databases of a cluster: there is only one copy of pg_parameter_acl per cluster, not one per database.
Table 52.36. pg_parameter_acl Columns Column Type Description oid oid Row identifier parname text The name of a configuration parameter for which privileges are granted paracl aclitem[] Access privileges; see Section 5.8 for details Prev Up Next
52.35. pg_opfamily
Home
52.37. pg_partitioned_table
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
