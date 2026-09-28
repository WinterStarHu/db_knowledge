# PostgreSQL: Documentation: 18: 11.6. Unique Indexes

PostgreSQL: Documentation: 18: 11.6. Unique Indexes Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
11.6. Unique Indexes
Prev Up Chapter 11. Indexes Home Next
11.6. Unique Indexes #
Indexes can also be used to enforce uniqueness of a column's value, or the uniqueness of the combined values of more than one column.
CREATE UNIQUE INDEX name ON table (column [, ...]) [ NULLS [ NOT ] DISTINCT ];
Currently, only B-tree indexes can be declared unique.
When an index is declared unique, multiple table rows with equal indexed values are not allowed. By default, null values in a unique column are not considered equal, allowing multiple nulls in the column. The NULLS NOT DISTINCT option modifies this and causes the index to treat nulls as equal. A multicolumn unique index will only reject cases where all indexed columns are equal in multiple rows.
PostgreSQL automatically creates a unique index when a unique constraint or primary key is defined for a table. The index covers the columns that make up the primary key or unique constraint (a multicolumn index, if appropriate), and is the mechanism that enforces the constraint.
Note There's no need to manually create indexes on unique columns; doing so would just duplicate the automatically-created index.
Prev Up Next
11.5. Combining Multiple Indexes
Home
11.7. Indexes on Expressions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
