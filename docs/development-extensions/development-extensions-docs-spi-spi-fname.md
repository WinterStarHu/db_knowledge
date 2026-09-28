# PostgreSQL: Documentation: 18: SPI_fname

PostgreSQL: Documentation: 18: SPI_fname Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_fname Prev Up
45.2. Interface Support Functions
Home Next SPI_fname SPI_fname — determine the column name for the specified column number Synopsis char * SPI_fname(TupleDesc rowdesc, int colnumber) Description SPI_fname returns a copy of the column name of the specified column. (You can use pfree to release the copy of the name when you don't need it anymore.) Arguments TupleDesc rowdesc input row description int colnumber column number (count starts at 1) Return Value The column name; NULL if colnumber is out of range. SPI_result set to SPI_ERROR_NOATTRIBUTE on error.
Prev Up Next
45.2. Interface Support Functions
Home SPI_fnumber Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
