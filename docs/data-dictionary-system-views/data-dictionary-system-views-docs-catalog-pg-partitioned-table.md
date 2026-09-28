# PostgreSQL: Documentation: 18: 52.37. pg_partitioned_table

PostgreSQL: Documentation: 18: 52.37. pg_partitioned_table Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
52.37. pg_partitioned_table
Prev Up Chapter 52. System Catalogs Home Next
52.37. pg_partitioned_table #
The catalog pg_partitioned_table stores information about how tables are partitioned.
Table 52.37. pg_partitioned_table Columns Column Type Description partrelid oid (references pg_class.oid) The OID of the pg_class entry for this partitioned table partstrat char Partitioning strategy; h = hash partitioned table, l = list partitioned table, r = range partitioned table partnatts int2 The number of columns in the partition key partdefid oid (references pg_class.oid) The OID of the pg_class entry for the default partition of this partitioned table, or zero if this partitioned table does not have a default partition partattrs int2vector (references pg_attribute.attnum) This is an array of partnatts values that indicate which table columns are part of the partition key. For example, a value of 1 3 would mean that the first and the third table columns make up the partition key. A zero in this array indicates that the corresponding partition key column is an expression, rather than a simple column reference.
partclass oidvector (references pg_opclass.oid) For each column in the partition key, this contains the OID of the operator class to use. See pg_opclass for details.
partcollation oidvector (references pg_collation.oid) For each column in the partition key, this contains the OID of the collation to use for partitioning, or zero if the column is not of a collatable data type.
partexprs pg_node_tree Expression trees (in nodeToString() representation) for partition key columns that are not simple column references. This is a list with one element for each zero entry in partattrs. Null if all partition key columns are simple references.
Prev Up Next
52.36. pg_parameter_acl
Home
52.38. pg_policy
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
