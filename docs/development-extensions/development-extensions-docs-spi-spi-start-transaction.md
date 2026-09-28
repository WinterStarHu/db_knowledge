# PostgreSQL: Documentation: 18: SPI_start_transaction

PostgreSQL: Documentation: 18: SPI_start_transaction Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 SPI_start_transaction Prev Up
45.4. Transaction Management
Home Next SPI_start_transaction SPI_start_transaction — obsolete function Synopsis void SPI_start_transaction(void) Description SPI_start_transaction does nothing, and exists only for code compatibility with earlier PostgreSQL releases. It used to be required after calling SPI_commit or SPI_rollback, but now those functions start a new transaction automatically.
Prev Up Next SPI_rollback Home
45.5. Visibility of Data Changes
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
