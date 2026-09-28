# PostgreSQL: Documentation: 18: 8.20. pg_lsn Type

PostgreSQL: Documentation: 18: 8.20. pg_lsn Type Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
8.20. pg_lsn Type
Prev Up Chapter 8. Data Types Home Next
8.20. pg_lsn Type #
The pg_lsn data type can be used to store LSN (Log Sequence Number) data which is a pointer to a location in the WAL. This type is a representation of XLogRecPtr and an internal system type of PostgreSQL.
Internally, an LSN is a 64-bit integer, representing a byte position in the write-ahead log stream. It is printed as two hexadecimal numbers of up to 8 digits each, separated by a slash; for example, 16/B374D848. The pg_lsn type supports the standard comparison operators, like = and >. Two LSNs can be subtracted using the - operator; the result is the number of bytes separating those write-ahead log locations. Also the number of bytes can be added into and subtracted from LSN using the +(pg_lsn,numeric) and -(pg_lsn,numeric) operators, respectively. Note that the calculated LSN should be in the range of pg_lsn type, i.e., between 0/0 and FFFFFFFF/FFFFFFFF.
Prev Up Next
8.19. Object Identifier Types
Home
8.21. Pseudo-Types
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
