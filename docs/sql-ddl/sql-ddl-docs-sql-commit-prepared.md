# PostgreSQL: Documentation: 18: COMMIT PREPARED

PostgreSQL: Documentation: 18: COMMIT PREPARED Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
COMMIT PREPARED Prev Up SQL Commands Home Next COMMIT PREPARED COMMIT PREPARED — commit a transaction that was earlier prepared for two-phase commit Synopsis COMMIT PREPARED transaction_id Description COMMIT PREPARED commits a transaction that is in prepared state.
Parameters transaction_id The transaction identifier of the transaction that is to be committed.
Notes To commit a prepared transaction, you must be either the same user that executed the transaction originally, or a superuser. But you do not have to be in the same session that executed the transaction.
This command cannot be executed inside a transaction block. The prepared transaction is committed immediately.
All currently available prepared transactions are listed in the pg_prepared_xacts system view.
Examples Commit the transaction identified by the transaction identifier foobar:
COMMIT PREPARED 'foobar';
Compatibility COMMIT PREPARED is a PostgreSQL extension. It is intended for use by external transaction management systems, some of which are covered by standards (such as X/Open XA), but the SQL side of those systems is not standardized.
See AlsoPREPARE TRANSACTION, ROLLBACK PREPARED Prev Up Next COMMIT Home COPY Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
