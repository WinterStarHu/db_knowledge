# PostgreSQL: Documentation: 18: SPI_execute_plan

PostgreSQL: Documentation: 18: SPI_execute_plan Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_execute_plan Prev Up
45.1. Interface Functions
Home Next SPI_execute_plan SPI_execute_plan — execute a statement prepared by SPI_prepare Synopsis int SPI_execute_plan(SPIPlanPtr plan, Datum * values, const char * nulls, bool read_only, long count) Description SPI_execute_plan executes a statement prepared by SPI_prepare or one of its siblings. read_only and count have the same interpretation as in SPI_execute.
Arguments SPIPlanPtr plan prepared statement (returned by SPI_prepare) Datum * values An array of actual parameter values. Must have same length as the statement's number of arguments.
const char * nulls An array describing which parameters are null. Must have same length as the statement's number of arguments.
If nulls is NULL then SPI_execute_plan assumes that no parameters are null. Otherwise, each entry of the nulls array should be ' ' if the corresponding parameter value is non-null, or 'n' if the corresponding parameter value is null. (In the latter case, the actual value in the corresponding values entry doesn't matter.) Note that nulls is not a text string, just an array: it does not need a '\0' terminator.
bool read_only true for read-only execution long count maximum number of rows to return, or 0 for no limit Return Value The return value is the same as for SPI_execute, with the following additional possible error (negative) results:
SPI_ERROR_ARGUMENT if plan is NULL or invalid, or count is less than 0 SPI_ERROR_PARAM if values is NULL and plan was prepared with some parameters SPI_processed and SPI_tuptable are set as in SPI_execute if successful.
Prev Up Next SPI_is_cursor_plan Home SPI_execute_plan_extended Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
