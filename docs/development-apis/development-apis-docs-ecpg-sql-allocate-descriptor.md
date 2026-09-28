# PostgreSQL: Documentation: 18: ALLOCATE DESCRIPTOR

PostgreSQL: Documentation: 18: ALLOCATE DESCRIPTOR Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALLOCATE DESCRIPTOR Prev Up
34.14. Embedded SQL Commands
Home Next ALLOCATE DESCRIPTOR ALLOCATE DESCRIPTOR — allocate an SQL descriptor area Synopsis ALLOCATE DESCRIPTOR name Description ALLOCATE DESCRIPTOR allocates a new named SQL descriptor area, which can be used to exchange data between the PostgreSQL server and the host program.
Descriptor areas should be freed after use using the DEALLOCATE DESCRIPTOR command.
Parameters name # A name of SQL descriptor, case sensitive. This can be an SQL identifier or a host variable.
Examples EXEC SQL ALLOCATE DESCRIPTOR mydesc;
Compatibility ALLOCATE DESCRIPTOR is specified in the SQL standard.
See AlsoDEALLOCATE DESCRIPTOR, GET DESCRIPTOR, SET DESCRIPTOR Prev Up Next
34.14. Embedded SQL Commands
Home CONNECT Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
