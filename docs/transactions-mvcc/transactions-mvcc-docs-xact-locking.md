# PostgreSQL: Documentation: 18: 67.2. Transactions and Locking

PostgreSQL: Documentation: 18: 67.2. Transactions and Locking Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 Development Versions:
19 / devel
67.2. Transactions and Locking
Prev Up Chapter 67. Transaction Processing Home Next
67.2. Transactions and Locking #
The transaction IDs of currently executing transactions are shown in pg_locks in columns virtualxid and transactionid. Read-only transactions will have virtualxids but NULL transactionids, while both columns will be set in read-write transactions.
Some lock types wait on virtualxid, while other types wait on transactionid. Row-level read and write locks are recorded directly in the locked rows and can be inspected using the pgrowlocks extension. Row-level read locks might also require the assignment of multixact IDs (mxid; see Section 24.1.5.1).
Prev Up Next
67.1. Transactions and Identifiers
Home
67.3. Subtransactions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
