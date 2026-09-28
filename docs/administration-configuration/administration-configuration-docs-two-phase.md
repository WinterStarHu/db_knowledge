# PostgreSQL: Documentation: 18: 67.4. Two-Phase Transactions

PostgreSQL: Documentation: 18: 67.4. Two-Phase Transactions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 Development Versions:
19 / devel
67.4. Two-Phase Transactions
Prev Up Chapter 67. Transaction Processing Home Next
67.4. Two-Phase Transactions #
PostgreSQL supports a two-phase commit (2PC) protocol that allows multiple distributed systems to work together in a transactional manner. The commands are PREPARE TRANSACTION, COMMIT PREPARED and ROLLBACK PREPARED. Two-phase transactions are intended for use by external transaction management systems. PostgreSQL follows the features and model proposed by the X/Open XA standard, but does not implement some less often used aspects.
When the user executes PREPARE TRANSACTION, the only possible next commands are COMMIT PREPARED or ROLLBACK PREPARED. In general, this prepared state is intended to be of very short duration, but external availability issues might mean transactions stay in this state for an extended interval. Short-lived prepared transactions are stored only in shared memory and WAL. Transactions that span checkpoints are recorded in the pg_twophase directory. Transactions that are currently prepared can be inspected using pg_prepared_xacts.
Prev Up Next
67.3. Subtransactions
Home Chapter 68. System Catalog Declarations and Initial Contents Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
