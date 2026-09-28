# PostgreSQL: Documentation: 18: SPI_gettype

PostgreSQL: Documentation: 18: SPI_gettype Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_gettype Prev Up
45.2. Interface Support Functions
Home Next SPI_gettype SPI_gettype — return the data type name of the specified column Synopsis char * SPI_gettype(TupleDesc rowdesc, int colnumber) Description SPI_gettype returns a copy of the data type name of the specified column. (You can use pfree to release the copy of the name when you don't need it anymore.) Arguments TupleDesc rowdesc input row description int colnumber column number (count starts at 1) Return Value The data type name of the specified column, or NULL on error. SPI_result is set to SPI_ERROR_NOATTRIBUTE on error.
Prev Up Next SPI_getbinval Home SPI_gettypeid Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
