# PostgreSQL: Documentation: 18: SPI_keepplan

PostgreSQL: Documentation: 18: SPI_keepplan Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_keepplan Prev Up
45.1. Interface Functions
Home Next SPI_keepplan SPI_keepplan — save a prepared statement Synopsis int SPI_keepplan(SPIPlanPtr plan) Description SPI_keepplan saves a passed statement (prepared by SPI_prepare) so that it will not be freed by SPI_finish nor by the transaction manager. This gives you the ability to reuse prepared statements in the subsequent invocations of your C function in the current session.
Arguments SPIPlanPtr plan the prepared statement to be saved Return Value 0 on success; SPI_ERROR_ARGUMENT if plan is NULL or invalid Notes The passed-in statement is relocated to permanent storage by means of pointer adjustment (no data copying is required). If you later wish to delete it, use SPI_freeplan on it.
Prev Up Next SPI_cursor_close Home SPI_saveplan Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
