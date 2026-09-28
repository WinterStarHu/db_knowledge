# PostgreSQL: Documentation: 18: START TRANSACTION

PostgreSQL: Documentation: 18: START TRANSACTION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
START TRANSACTION Prev Up SQL Commands Home Next START TRANSACTION START TRANSACTION — start a transaction block Synopsis START TRANSACTION [ transaction_mode [, ...] ] where transaction_mode is one of:
ISOLATION LEVEL { SERIALIZABLE | REPEATABLE READ | READ COMMITTED | READ UNCOMMITTED } READ WRITE | READ ONLY [ NOT ] DEFERRABLE Description This command begins a new transaction block. If the isolation level, read/write mode, or deferrable mode is specified, the new transaction has those characteristics, as if SET TRANSACTION was executed. This is the same as the BEGIN command.
Parameters Refer to SET TRANSACTION for information on the meaning of the parameters to this statement.
Compatibility In the standard, it is not necessary to issue START TRANSACTION to start a transaction block: any SQL command implicitly begins a block. PostgreSQL's behavior can be seen as implicitly issuing a COMMIT after each command that does not follow START TRANSACTION (or BEGIN), and it is therefore often called “autocommit”. Other relational database systems might offer an autocommit feature as a convenience.
The DEFERRABLE transaction_mode is a PostgreSQL language extension.
The SQL standard requires commas between successive transaction_modes, but for historical reasons PostgreSQL allows the commas to be omitted.
See also the compatibility section of SET TRANSACTION.
See AlsoBEGIN, COMMIT, ROLLBACK, SAVEPOINT, SET TRANSACTION Prev Up Next SHOW Home TRUNCATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
