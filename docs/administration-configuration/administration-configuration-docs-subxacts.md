# PostgreSQL: Documentation: 18: 67.3. Subtransactions

PostgreSQL: Documentation: 18: 67.3. Subtransactions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 Development Versions:
19 / devel
67.3. Subtransactions
Prev Up Chapter 67. Transaction Processing Home Next
67.3. Subtransactions #
Subtransactions are started inside transactions, allowing large transactions to be broken into smaller units. Subtransactions can commit or abort without affecting their parent transactions, allowing parent transactions to continue. This allows errors to be handled more easily, which is a common application development pattern. The word subtransaction is often abbreviated as subxact.
Subtransactions can be started explicitly using the SAVEPOINT command, but can also be started in other ways, such as PL/pgSQL's EXCEPTION clause. PL/Python and PL/Tcl also support explicit subtransactions. Subtransactions can also be started from other subtransactions. The top-level transaction and its child subtransactions form a hierarchy or tree, which is why we refer to the main transaction as the top-level transaction.
If a subtransaction is assigned a non-virtual transaction ID, its transaction ID is referred to as a “subxid”. Read-only subtransactions are not assigned subxids, but once they attempt to write, they will be assigned one. This also causes all of a subxid's parents, up to and including the top-level transaction, to be assigned non-virtual transaction ids. We ensure that a parent xid is always lower than any of its child subxids.
The immediate parent xid of each subxid is recorded in the pg_subtrans directory. No entry is made for top-level xids since they do not have a parent, nor is an entry made for read-only subtransactions.
When a subtransaction commits, all of its committed child subtransactions with subxids will also be considered subcommitted in that transaction. When a subtransaction aborts, all of its child subtransactions will also be considered aborted.
When a top-level transaction with an xid commits, all of its subcommitted child subtransactions are also persistently recorded as committed in the pg_xact subdirectory. If the top-level transaction aborts, all its subtransactions are also aborted, even if they were subcommitted.
The more subtransactions each transaction keeps open (not rolled back or released), the greater the transaction management overhead. Up to 64 open subxids are cached in shared memory for each backend; after that point, the storage I/O overhead increases significantly due to additional lookups of subxid entries in pg_subtrans.
Prev Up Next
67.2. Transactions and Locking
Home
67.4. Two-Phase Transactions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
