# PostgreSQL: Documentation: 18: ABORT

PostgreSQL: Documentation: 18: ABORT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.1
ABORT Prev Up SQL Commands Home Next ABORT ABORT — abort the current transaction Synopsis ABORT [ WORK | TRANSACTION ] [ AND [ NO ] CHAIN ] Description ABORT rolls back the current transaction and causes all the updates made by the transaction to be discarded. This command is identical in behavior to the standard SQL command ROLLBACK, and is present only for historical reasons.
Parameters WORKTRANSACTION Optional key words. They have no effect.
AND CHAIN If AND CHAIN is specified, a new transaction is immediately started with the same transaction characteristics (see SET TRANSACTION) as the just finished one. Otherwise, no new transaction is started.
Notes Use COMMIT to successfully terminate a transaction.
Issuing ABORT outside of a transaction block emits a warning and otherwise has no effect.
Examples To abort all changes:
ABORT;
Compatibility This command is a PostgreSQL extension present for historical reasons. ROLLBACK is the equivalent standard SQL command.
See AlsoBEGIN, COMMIT, ROLLBACK Prev Up Next SQL Commands Home ALTER AGGREGATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
