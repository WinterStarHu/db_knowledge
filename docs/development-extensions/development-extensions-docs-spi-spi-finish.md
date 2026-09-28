# PostgreSQL: Documentation: 18: SPI_finish

PostgreSQL: Documentation: 18: SPI_finish Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_finish Prev Up
45.1. Interface Functions
Home Next SPI_finish SPI_finish — disconnect a C function from the SPI manager Synopsis int SPI_finish(void) Description SPI_finish closes an existing connection to the SPI manager. You must call this function after completing the SPI operations needed during your C function's current invocation. You do not need to worry about making this happen, however, if you abort the transaction via elog(ERROR). In that case SPI will clean itself up automatically.
Return Value SPI_OK_FINISH if properly disconnected SPI_ERROR_UNCONNECTED if called from an unconnected C function Prev Up Next SPI_connect Home SPI_execute Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
