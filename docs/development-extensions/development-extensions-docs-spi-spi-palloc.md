# PostgreSQL: Documentation: 18: SPI_palloc

PostgreSQL: Documentation: 18: SPI_palloc Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_palloc Prev Up
45.3. Memory Management
Home Next SPI_palloc SPI_palloc — allocate memory in the upper executor context Synopsis void * SPI_palloc(Size size) Description SPI_palloc allocates memory in the upper executor context.
This function can only be used while connected to SPI. Otherwise, it throws an error.
Arguments Size size size in bytes of storage to allocate Return Value pointer to new storage space of the specified size Prev Up Next
45.3. Memory Management
Home SPI_repalloc Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
