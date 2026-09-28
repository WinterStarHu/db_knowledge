# PostgreSQL: Documentation: 18: 52.52. pg_statistic_ext

PostgreSQL: Documentation: 18: 52.52. pg_statistic_ext Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
52.52. pg_statistic_ext
Prev Up Chapter 52. System Catalogs Home Next
52.52. pg_statistic_ext #
The catalog pg_statistic_ext holds definitions of extended planner statistics. Each row in this catalog corresponds to a statistics object created with CREATE STATISTICS.
Table 52.52. pg_statistic_ext Columns Column Type Description oid oid Row identifier stxrelid oid (references pg_class.oid) Table containing the columns described by this object stxname name Name of the statistics object stxnamespace oid (references pg_namespace.oid) The OID of the namespace that contains this statistics object stxowner oid (references pg_authid.oid) Owner of the statistics object stxkeys int2vector (references pg_attribute.attnum) An array of attribute numbers, indicating which table columns are covered by this statistics object; for example a value of 1 3 would mean that the first and the third table columns are covered stxstattarget int2 stxstattarget controls the level of detail of statistics accumulated for this statistics object by ANALYZE. A zero value indicates that no statistics should be collected. A null value says to use the maximum of the statistics targets of the referenced columns, if set, or the system default statistics target. Positive values of stxstattarget determine the target number of “most common values” to collect.
stxkind char[] An array containing codes for the enabled statistics kinds; valid values are: d for n-distinct statistics, f for functional dependency statistics, m for most common values (MCV) list statistics, and e for expression statistics stxexprs pg_node_tree Expression trees (in nodeToString() representation) for statistics object attributes that are not simple column references. This is a list with one element per expression. Null if all statistics object attributes are simple references.
The pg_statistic_ext entry is filled in completely during CREATE STATISTICS, but the actual statistical values are not computed then. Subsequent ANALYZE commands compute the desired values and populate an entry in the pg_statistic_ext_data catalog.
Prev Up Next
52.51. pg_statistic
Home
52.53. pg_statistic_ext_data
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
