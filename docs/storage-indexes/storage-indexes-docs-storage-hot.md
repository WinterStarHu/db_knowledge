# PostgreSQL: Documentation: 18: 66.7. Heap-Only Tuples (HOT)

PostgreSQL: Documentation: 18: 66.7. Heap-Only Tuples (HOT) Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
66.7. Heap-Only Tuples (HOT)
Prev Up Chapter 66. Database Physical Storage Home Next
66.7. Heap-Only Tuples (HOT) #
To allow for high concurrency, PostgreSQL uses multiversion concurrency control (MVCC) to store rows. However, MVCC has some downsides for update queries. Specifically, updates require new versions of rows to be added to tables. This can also require new index entries for each updated row, and removal of old versions of rows and their index entries can be expensive.
To help reduce the overhead of updates, PostgreSQL has an optimization called heap-only tuples (HOT). This optimization is possible when:
The update does not modify any columns referenced by the table's indexes, not including summarizing indexes. The only summarizing index method in the core PostgreSQL distribution is BRIN.
There is sufficient free space on the page containing the old row for the updated row.
In such cases, heap-only tuples provide two optimizations:
New index entries are not needed to represent updated rows, however, summary indexes may still need to be updated.
When a row is updated multiple times, row versions other than the oldest and the newest can be completely removed during normal operation, including SELECTs, instead of requiring periodic vacuum operations. (Indexes always refer to the page item identifier of the original row version. The tuple data associated with that row version is removed, and its item identifier is converted to a redirect that points to the oldest version that may still be visible to some concurrent transaction. Intermediate row versions that are no longer visible to anyone are completely removed, and the associated page item identifiers are made available for reuse.) You can increase the likelihood of sufficient page space for HOT updates by decreasing a table's fillfactor. If you don't, HOT updates will still happen because new rows will naturally migrate to new pages and existing pages with sufficient free space for new row versions. The system view pg_stat_all_tables allows monitoring of the occurrence of HOT and non-HOT updates.
Prev Up Next
66.6. Database Page Layout
Home Chapter 67. Transaction Processing Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
