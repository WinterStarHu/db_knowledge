# PostgreSQL: Documentation: 18: SPI_connect

PostgreSQL: Documentation: 18: SPI_connect Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_connect Prev Up
45.1. Interface Functions
Home Next SPI_connect SPI_connect, SPI_connect_ext — connect a C function to the SPI manager Synopsis int SPI_connect(void) int SPI_connect_ext(int options) Description SPI_connect opens a connection from a C function invocation to the SPI manager. You must call this function if you want to execute commands through SPI. Some utility SPI functions can be called from unconnected C functions.
SPI_connect_ext does the same but has an argument that allows passing option flags. Currently, the following option values are available:
SPI_OPT_NONATOMIC Sets the SPI connection to be nonatomic, which means that transaction control calls (SPI_commit, SPI_rollback) are allowed. Otherwise, calling those functions will result in an immediate error.
SPI_connect() is equivalent to SPI_connect_ext(0).
Return Value SPI_OK_CONNECT on success The fact that these functions return int not void is historical. All failure cases are reported via ereport or elog. (In versions before PostgreSQL v10, some but not all failures would be reported with a result value of SPI_ERROR_CONNECT.) Prev Up Next
45.1. Interface Functions
Home SPI_finish Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
