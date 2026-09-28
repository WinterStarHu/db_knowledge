# PostgreSQL: Documentation: 18: SPI_commit

PostgreSQL: Documentation: 18: SPI_commit Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 SPI_commit Prev Up
45.4. Transaction Management
Home Next SPI_commit SPI_commit, SPI_commit_and_chain — commit the current transaction Synopsis void SPI_commit(void) void SPI_commit_and_chain(void) Description SPI_commit commits the current transaction. It is approximately equivalent to running the SQL command COMMIT. After the transaction is committed, a new transaction is automatically started using default transaction characteristics, so that the caller can continue using SPI facilities. If there is a failure during commit, the current transaction is instead rolled back and a new transaction is started, after which the error is thrown in the usual way.
SPI_commit_and_chain is the same, but the new transaction is started with the same transaction characteristics as the just finished one, like with the SQL command COMMIT AND CHAIN.
These functions can only be executed if the SPI connection has been set as nonatomic in the call to SPI_connect_ext.
Prev Up Next
45.4. Transaction Management
Home SPI_rollback Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
