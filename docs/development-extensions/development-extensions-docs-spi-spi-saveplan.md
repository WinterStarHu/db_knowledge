# PostgreSQL: Documentation: 18: SPI_saveplan

PostgreSQL: Documentation: 18: SPI_saveplan Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_saveplan Prev Up
45.1. Interface Functions
Home Next SPI_saveplan SPI_saveplan — save a prepared statement Synopsis SPIPlanPtr SPI_saveplan(SPIPlanPtr plan) Description SPI_saveplan copies a passed statement (prepared by SPI_prepare) into memory that will not be freed by SPI_finish nor by the transaction manager, and returns a pointer to the copied statement. This gives you the ability to reuse prepared statements in the subsequent invocations of your C function in the current session.
Arguments SPIPlanPtr plan the prepared statement to be saved Return Value Pointer to the copied statement; or NULL if unsuccessful. On error, SPI_result is set thus:
SPI_ERROR_ARGUMENT if plan is NULL or invalid SPI_ERROR_UNCONNECTED if called from an unconnected C function Notes The originally passed-in statement is not freed, so you might wish to do SPI_freeplan on it to avoid leaking memory until SPI_finish.
In most cases, SPI_keepplan is preferred to this function, since it accomplishes largely the same result without needing to physically copy the prepared statement's data structures.
Prev Up Next SPI_keepplan Home SPI_register_relation Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
