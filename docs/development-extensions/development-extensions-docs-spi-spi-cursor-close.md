# PostgreSQL: Documentation: 18: SPI_cursor_close

PostgreSQL: Documentation: 18: SPI_cursor_close Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_cursor_close Prev Up
45.1. Interface Functions
Home Next SPI_cursor_close SPI_cursor_close — close a cursor Synopsis void SPI_cursor_close(Portal portal) Description SPI_cursor_close closes a previously created cursor and releases its portal storage.
All open cursors are closed automatically at the end of a transaction. SPI_cursor_close need only be invoked if it is desirable to release resources sooner.
Arguments Portal portal portal containing the cursor Prev Up Next SPI_scroll_cursor_move Home SPI_keepplan Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
