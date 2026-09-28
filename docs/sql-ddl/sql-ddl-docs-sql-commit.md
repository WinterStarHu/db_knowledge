# PostgreSQL: Documentation: 18: COMMIT

PostgreSQL: Documentation: 18: COMMIT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
COMMIT Prev Up SQL Commands Home Next COMMIT COMMIT — commit the current transaction Synopsis COMMIT [ WORK | TRANSACTION ] [ AND [ NO ] CHAIN ] Description COMMIT commits the current transaction. All changes made by the transaction become visible to others and are guaranteed to be durable if a crash occurs.
Parameters WORKTRANSACTION # Optional key words. They have no effect.
AND CHAIN # If AND CHAIN is specified, a new transaction is immediately started with the same transaction characteristics (see SET TRANSACTION) as the just finished one. Otherwise, no new transaction is started.
Notes Use ROLLBACK to abort a transaction.
Issuing COMMIT when not inside a transaction does no harm, but it will provoke a warning message. COMMIT AND CHAIN when not inside a transaction is an error.
Examples To commit the current transaction and make all changes permanent:
COMMIT;
Compatibility The command COMMIT conforms to the SQL standard. The form COMMIT TRANSACTION is a PostgreSQL extension.
See AlsoBEGIN, ROLLBACK Prev Up Next COMMENT Home COMMIT PREPARED Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
