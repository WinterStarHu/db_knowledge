# PostgreSQL: Documentation: 18: SPI_getargcount

PostgreSQL: Documentation: 18: SPI_getargcount Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_getargcount Prev Up
45.1. Interface Functions
Home Next SPI_getargcount SPI_getargcount — return the number of arguments needed by a statement prepared by SPI_prepare Synopsis int SPI_getargcount(SPIPlanPtr plan) Description SPI_getargcount returns the number of arguments needed to execute a statement prepared by SPI_prepare.
Arguments SPIPlanPtr plan prepared statement (returned by SPI_prepare) Return Value The count of expected arguments for the plan. If the plan is NULL or invalid, SPI_result is set to SPI_ERROR_ARGUMENT and -1 is returned.
Prev Up Next SPI_prepare_params Home SPI_getargtypeid Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
