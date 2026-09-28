# PostgreSQL: Documentation: 18: SPI_fnumber

PostgreSQL: Documentation: 18: SPI_fnumber Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_fnumber Prev Up
45.2. Interface Support Functions
Home Next SPI_fnumber SPI_fnumber — determine the column number for the specified column name Synopsis int SPI_fnumber(TupleDesc rowdesc, const char * colname) Description SPI_fnumber returns the column number for the column with the specified name.
If colname refers to a system column (e.g., ctid) then the appropriate negative column number will be returned. The caller should be careful to test the return value for exact equality to SPI_ERROR_NOATTRIBUTE to detect an error; testing the result for less than or equal to 0 is not correct unless system columns should be rejected.
Arguments TupleDesc rowdesc input row description const char * colname column name Return Value Column number (count starts at 1 for user-defined columns), or SPI_ERROR_NOATTRIBUTE if the named column was not found.
Prev Up Next SPI_fname Home SPI_getvalue Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
