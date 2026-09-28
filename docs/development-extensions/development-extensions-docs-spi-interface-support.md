# PostgreSQL: Documentation: 18: 45.2. Interface Support Functions

PostgreSQL: Documentation: 18: 45.2. Interface Support Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.3
/
7.2
/
7.1
45.2. Interface Support Functions
Prev Up Chapter 45. Server Programming Interface Home Next
45.2. Interface Support Functions #
SPI_fname — determine the column name for the specified column number SPI_fnumber — determine the column number for the specified column name SPI_getvalue — return the string value of the specified column SPI_getbinval — return the binary value of the specified column SPI_gettype — return the data type name of the specified column SPI_gettypeid — return the data type OID of the specified column SPI_getrelname — return the name of the specified relation SPI_getnspname — return the namespace of the specified relation SPI_result_code_string — return error code as string The functions described here provide an interface for extracting information from result sets returned by SPI_execute and other SPI functions.
All functions described in this section can be used by both connected and unconnected C functions.
Prev Up Next SPI_register_trigger_data Home SPI_fname Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
