# PostgreSQL: Documentation: 18: SPI_scroll_cursor_move

PostgreSQL: Documentation: 18: SPI_scroll_cursor_move Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_scroll_cursor_move Prev Up
45.1. Interface Functions
Home Next SPI_scroll_cursor_move SPI_scroll_cursor_move — move a cursor Synopsis void SPI_scroll_cursor_move(Portal portal, FetchDirection direction, long count) Description SPI_scroll_cursor_move skips over some number of rows in a cursor. This is equivalent to the SQL command MOVE.
Arguments Portal portal portal containing the cursor FetchDirection direction one of FETCH_FORWARD, FETCH_BACKWARD, FETCH_ABSOLUTE or FETCH_RELATIVE long count number of rows to move for FETCH_FORWARD or FETCH_BACKWARD; absolute row number to move to for FETCH_ABSOLUTE; or relative row number to move to for FETCH_RELATIVE Return Value SPI_processed is set as in SPI_execute if successful. SPI_tuptable is set to NULL, since no rows are returned by this function.
Notes See the SQL FETCH command for details of the interpretation of the direction and count parameters.
Direction values other than FETCH_FORWARD may fail if the cursor's plan was not created with the CURSOR_OPT_SCROLL option.
Prev Up Next SPI_scroll_cursor_fetch Home SPI_cursor_close Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
