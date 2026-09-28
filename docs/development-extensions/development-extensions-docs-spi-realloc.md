# PostgreSQL: Documentation: 18: SPI_repalloc

PostgreSQL: Documentation: 18: SPI_repalloc Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_repalloc Prev Up
45.3. Memory Management
Home Next SPI_repalloc SPI_repalloc — reallocate memory in the upper executor context Synopsis void * SPI_repalloc(void * pointer, Size size) Description SPI_repalloc changes the size of a memory segment previously allocated using SPI_palloc.
This function is no longer different from plain repalloc. It's kept just for backward compatibility of existing code.
Arguments void * pointer pointer to existing storage to change Size size size in bytes of storage to allocate Return Value pointer to new storage space of specified size with the contents copied from the existing area Prev Up Next SPI_palloc Home SPI_pfree Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
