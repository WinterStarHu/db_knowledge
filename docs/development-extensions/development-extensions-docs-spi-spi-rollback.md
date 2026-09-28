# PostgreSQL: Documentation: 18: SPI_rollback

PostgreSQL: Documentation: 18: SPI_rollback Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 SPI_rollback Prev Up
45.4. Transaction Management
Home Next SPI_rollback SPI_rollback, SPI_rollback_and_chain — abort the current transaction Synopsis void SPI_rollback(void) void SPI_rollback_and_chain(void) Description SPI_rollback rolls back the current transaction. It is approximately equivalent to running the SQL command ROLLBACK. After the transaction is rolled back, a new transaction is automatically started using default transaction characteristics, so that the caller can continue using SPI facilities.
SPI_rollback_and_chain is the same, but the new transaction is started with the same transaction characteristics as the just finished one, like with the SQL command ROLLBACK AND CHAIN.
These functions can only be executed if the SPI connection has been set as nonatomic in the call to SPI_connect_ext.
Prev Up Next SPI_commit Home SPI_start_transaction Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
