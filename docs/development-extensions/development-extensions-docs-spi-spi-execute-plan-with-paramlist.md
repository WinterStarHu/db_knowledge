# PostgreSQL: Documentation: 18: SPI_execute_plan_with_paramlist

PostgreSQL: Documentation: 18: SPI_execute_plan_with_paramlist Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_execute_plan_with_paramlist Prev Up
45.1. Interface Functions
Home Next SPI_execute_plan_with_paramlist SPI_execute_plan_with_paramlist — execute a statement prepared by SPI_prepare Synopsis int SPI_execute_plan_with_paramlist(SPIPlanPtr plan, ParamListInfo params, bool read_only, long count) Description SPI_execute_plan_with_paramlist executes a statement prepared by SPI_prepare. This function is equivalent to SPI_execute_plan except that information about the parameter values to be passed to the query is presented differently. The ParamListInfo representation can be convenient for passing down values that are already available in that format. It also supports use of dynamic parameter sets via hook functions specified in ParamListInfo.
This function is now deprecated in favor of SPI_execute_plan_extended.
Arguments SPIPlanPtr plan prepared statement (returned by SPI_prepare) ParamListInfo params data structure containing parameter types and values; NULL if none bool read_only true for read-only execution long count maximum number of rows to return, or 0 for no limit Return Value The return value is the same as for SPI_execute_plan.
SPI_processed and SPI_tuptable are set as in SPI_execute_plan if successful.
Prev Up Next SPI_execute_plan_extended Home SPI_execp Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
