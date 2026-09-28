# PostgreSQL: Documentation: 18: SPI_gettypeid

PostgreSQL: Documentation: 18: SPI_gettypeid Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_gettypeid Prev Up
45.2. Interface Support Functions
Home Next SPI_gettypeid SPI_gettypeid — return the data type OID of the specified column Synopsis Oid SPI_gettypeid(TupleDesc rowdesc, int colnumber) Description SPI_gettypeid returns the OID of the data type of the specified column.
Arguments TupleDesc rowdesc input row description int colnumber column number (count starts at 1) Return Value The OID of the data type of the specified column or InvalidOid on error. On error, SPI_result is set to SPI_ERROR_NOATTRIBUTE.
Prev Up Next SPI_gettype Home SPI_getrelname Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
