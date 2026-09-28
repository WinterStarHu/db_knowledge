# PostgreSQL: Documentation: 18: 68.6. BKI Example

PostgreSQL: Documentation: 18: 68.6. BKI Example Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
68.6. BKI Example
Prev Up Chapter 68. System Catalog Declarations and Initial Contents Home Next
68.6. BKI Example #
The following sequence of commands will create the table test_table with OID 420, having three columns oid, cola and colb of type oid, int4 and text, respectively, and insert two rows into the table:
create test_table 420 (oid = oid, cola = int4, colb = text) open test_table insert ( 421 1 'value 1' ) insert ( 422 2 _null_ ) close test_table Prev Up Next
68.5. Structure of the Bootstrap BKI File
Home Chapter 69. How the Planner Uses Statistics Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
