# PostgreSQL: Documentation: 18: SPI_copytuple

PostgreSQL: Documentation: 18: SPI_copytuple Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_copytuple Prev Up
45.3. Memory Management
Home Next SPI_copytuple SPI_copytuple — make a copy of a row in the upper executor context Synopsis HeapTuple SPI_copytuple(HeapTuple row) Description SPI_copytuple makes a copy of a row in the upper executor context. This is normally used to return a modified row from a trigger. In a function declared to return a composite type, use SPI_returntuple instead.
This function can only be used while connected to SPI. Otherwise, it returns NULL and sets SPI_result to SPI_ERROR_UNCONNECTED.
Arguments HeapTuple row row to be copied Return Value the copied row, or NULL on error (see SPI_result for an error indication) Prev Up Next SPI_pfree Home SPI_returntuple Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
