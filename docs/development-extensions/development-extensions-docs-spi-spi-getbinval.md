# PostgreSQL: Documentation: 18: SPI_getbinval

PostgreSQL: Documentation: 18: SPI_getbinval Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_getbinval Prev Up
45.2. Interface Support Functions
Home Next SPI_getbinval SPI_getbinval — return the binary value of the specified column Synopsis Datum SPI_getbinval(HeapTuple row, TupleDesc rowdesc, int colnumber, bool * isnull) Description SPI_getbinval returns the value of the specified column in the internal form (as type Datum).
This function does not allocate new space for the datum. In the case of a pass-by-reference data type, the return value will be a pointer into the passed row.
Arguments HeapTuple row input row to be examined TupleDesc rowdesc input row description int colnumber column number (count starts at 1) bool * isnull flag for a null value in the column Return Value The binary value of the column is returned. The variable pointed to by isnull is set to true if the column is null, else to false.
SPI_result is set to SPI_ERROR_NOATTRIBUTE on error.
Prev Up Next SPI_getvalue Home SPI_gettype Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
