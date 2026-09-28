# PostgreSQL: Documentation: 18: SPI_exec

PostgreSQL: Documentation: 18: SPI_exec Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_exec Prev Up
45.1. Interface Functions
Home Next SPI_exec SPI_exec — execute a read/write command Synopsis int SPI_exec(const char * command, long count) Description SPI_exec is the same as SPI_execute, with the latter's read_only parameter always taken as false.
Arguments const char * command string containing command to execute long count maximum number of rows to return, or 0 for no limit Return Value See SPI_execute.
Prev Up Next SPI_execute Home SPI_execute_extended Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
