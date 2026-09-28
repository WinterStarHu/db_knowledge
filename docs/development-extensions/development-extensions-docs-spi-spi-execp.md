# PostgreSQL: Documentation: 18: SPI_execp

PostgreSQL: Documentation: 18: SPI_execp Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_execp Prev Up
45.1. Interface Functions
Home Next SPI_execp SPI_execp — execute a statement in read/write mode Synopsis int SPI_execp(SPIPlanPtr plan, Datum * values, const char * nulls, long count) Description SPI_execp is the same as SPI_execute_plan, with the latter's read_only parameter always taken as false.
Arguments SPIPlanPtr plan prepared statement (returned by SPI_prepare) Datum * values An array of actual parameter values. Must have same length as the statement's number of arguments.
const char * nulls An array describing which parameters are null. Must have same length as the statement's number of arguments.
If nulls is NULL then SPI_execp assumes that no parameters are null. Otherwise, each entry of the nulls array should be ' ' if the corresponding parameter value is non-null, or 'n' if the corresponding parameter value is null. (In the latter case, the actual value in the corresponding values entry doesn't matter.) Note that nulls is not a text string, just an array: it does not need a '\0' terminator.
long count maximum number of rows to return, or 0 for no limit Return Value See SPI_execute_plan.
SPI_processed and SPI_tuptable are set as in SPI_execute if successful.
Prev Up Next SPI_execute_plan_with_paramlist Home SPI_cursor_open Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
