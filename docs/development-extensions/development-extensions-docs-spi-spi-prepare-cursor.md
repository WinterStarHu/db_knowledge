# PostgreSQL: Documentation: 18: SPI_prepare_cursor

PostgreSQL: Documentation: 18: SPI_prepare_cursor Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_prepare_cursor Prev Up
45.1. Interface Functions
Home Next SPI_prepare_cursor SPI_prepare_cursor — prepare a statement, without executing it yet Synopsis SPIPlanPtr SPI_prepare_cursor(const char * command, int nargs, Oid * argtypes, int cursorOptions) Description SPI_prepare_cursor is identical to SPI_prepare, except that it also allows specification of the planner's “cursor options” parameter. This is a bit mask having the values shown in nodes/parsenodes.h for the options field of DeclareCursorStmt. SPI_prepare always takes the cursor options as zero.
This function is now deprecated in favor of SPI_prepare_extended.
Arguments const char * command command string int nargs number of input parameters ($1, $2, etc.) Oid * argtypes pointer to an array containing the OIDs of the data types of the parameters int cursorOptions integer bit mask of cursor options; zero produces default behavior Return Value SPI_prepare_cursor has the same return conventions as SPI_prepare.
Notes Useful bits to set in cursorOptions include CURSOR_OPT_SCROLL, CURSOR_OPT_NO_SCROLL, CURSOR_OPT_FAST_PLAN, CURSOR_OPT_GENERIC_PLAN, and CURSOR_OPT_CUSTOM_PLAN. Note in particular that CURSOR_OPT_HOLD is ignored.
Prev Up Next SPI_prepare Home SPI_prepare_extended Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
