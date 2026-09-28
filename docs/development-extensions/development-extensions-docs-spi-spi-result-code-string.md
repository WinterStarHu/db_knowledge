# PostgreSQL: Documentation: 18: SPI_result_code_string

PostgreSQL: Documentation: 18: SPI_result_code_string Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 SPI_result_code_string Prev Up
45.2. Interface Support Functions
Home Next SPI_result_code_string SPI_result_code_string — return error code as string Synopsis const char * SPI_result_code_string(int code);
Description SPI_result_code_string returns a string representation of the result code returned by various SPI functions or stored in SPI_result.
Arguments int code result code Return Value A string representation of the result code.
Prev Up Next SPI_getnspname Home
45.3. Memory Management
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
