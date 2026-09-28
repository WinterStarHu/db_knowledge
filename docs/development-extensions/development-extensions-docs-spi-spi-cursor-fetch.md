# PostgreSQL: Documentation: 18: SPI_cursor_fetch

PostgreSQL: Documentation: 18: SPI_cursor_fetch Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_cursor_fetch Prev Up
45.1. Interface Functions
Home Next SPI_cursor_fetch SPI_cursor_fetch — fetch some rows from a cursor Synopsis void SPI_cursor_fetch(Portal portal, bool forward, long count) Description SPI_cursor_fetch fetches some rows from a cursor. This is equivalent to a subset of the SQL command FETCH (see SPI_scroll_cursor_fetch for more functionality).
Arguments Portal portal portal containing the cursor bool forward true for fetch forward, false for fetch backward long count maximum number of rows to fetch Return Value SPI_processed and SPI_tuptable are set as in SPI_execute if successful.
Notes Fetching backward may fail if the cursor's plan was not created with the CURSOR_OPT_SCROLL option.
Prev Up Next SPI_cursor_find Home SPI_cursor_move Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
