# PostgreSQL: Documentation: 18: 47.8. Synchronous Replication Support for Logical Decoding

PostgreSQL: Documentation: 18: 47.8. Synchronous Replication Support for Logical Decoding Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
47.8. Synchronous Replication Support for Logical Decoding
Prev Up Chapter 47. Logical Decoding Home Next
47.8. Synchronous Replication Support for Logical Decoding #
47.8.1. Overview
47.8.2. Caveats
47.8.1. Overview #
Logical decoding can be used to build synchronous replication solutions with the same user interface as synchronous replication for streaming replication. To do this, the streaming replication interface (see Section 47.3) must be used to stream out data. Clients have to send Standby status update (F) (see Section 54.4) messages, just like streaming replication clients do.
Note A synchronous replica receiving changes via logical decoding will work in the scope of a single database. Since, in contrast to that, synchronous_standby_names currently is server wide, this means this technique will not work properly if more than one database is actively used.
47.8.2. Caveats #
In synchronous replication setup, a deadlock can happen, if the transaction has locked [user] catalog tables exclusively. See Section 47.6.2 for information on user catalog tables. This is because logical decoding of transactions can lock catalog tables to access them. To avoid this users must refrain from taking an exclusive lock on [user] catalog tables. This can happen in the following ways:
Issuing an explicit LOCK on pg_class in a transaction.
Perform CLUSTER on pg_class in a transaction.
PREPARE TRANSACTION after LOCK command on pg_class and allow logical decoding of two-phase transactions.
PREPARE TRANSACTION after CLUSTER command on pg_trigger and allow logical decoding of two-phase transactions. This will lead to deadlock only when published table have a trigger.
Executing TRUNCATE on [user] catalog table in a transaction.
Note that these commands can cause deadlocks not only for the system catalog tables listed above but for other catalog tables.
Prev Up Next
47.7. Logical Decoding Output Writers
Home
47.9. Streaming of Large Transactions for Logical Decoding
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
