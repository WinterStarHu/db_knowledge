# PostgreSQL: Documentation: 18: SPI_getargtypeid

PostgreSQL: Documentation: 18: SPI_getargtypeid Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_getargtypeid Prev Up
45.1. Interface Functions
Home Next SPI_getargtypeid SPI_getargtypeid — return the data type OID for an argument of a statement prepared by SPI_prepare Synopsis Oid SPI_getargtypeid(SPIPlanPtr plan, int argIndex) Description SPI_getargtypeid returns the OID representing the type for the argIndex'th argument of a statement prepared by SPI_prepare. First argument is at index zero.
Arguments SPIPlanPtr plan prepared statement (returned by SPI_prepare) int argIndex zero based index of the argument Return Value The type OID of the argument at the given index. If the plan is NULL or invalid, or argIndex is less than 0 or not less than the number of arguments declared for the plan, SPI_result is set to SPI_ERROR_ARGUMENT and InvalidOid is returned.
Prev Up Next SPI_getargcount Home SPI_is_cursor_plan Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
