# PostgreSQL: Documentation: 18: SPI_is_cursor_plan

PostgreSQL: Documentation: 18: SPI_is_cursor_plan Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_is_cursor_plan Prev Up
45.1. Interface Functions
Home Next SPI_is_cursor_plan SPI_is_cursor_plan — return true if a statement prepared by SPI_prepare can be used with SPI_cursor_open Synopsis bool SPI_is_cursor_plan(SPIPlanPtr plan) Description SPI_is_cursor_plan returns true if a statement prepared by SPI_prepare can be passed as an argument to SPI_cursor_open, or false if that is not the case. The criteria are that the plan represents one single command and that this command returns tuples to the caller; for example, SELECT is allowed unless it contains an INTO clause, and UPDATE is allowed only if it contains a RETURNING clause.
Arguments SPIPlanPtr plan prepared statement (returned by SPI_prepare) Return Value true or false to indicate if the plan can produce a cursor or not, with SPI_result set to zero. If it is not possible to determine the answer (for example, if the plan is NULL or invalid, or if called when not connected to SPI), then SPI_result is set to a suitable error code and false is returned.
Prev Up Next SPI_getargtypeid Home SPI_execute_plan Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
