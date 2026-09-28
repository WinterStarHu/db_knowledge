# PostgreSQL: Documentation: 18: 42.3. Data Values in PL/Tcl

PostgreSQL: Documentation: 18: 42.3. Data Values in PL/Tcl Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
42.3. Data Values in PL/Tcl
Prev Up Chapter 42. PL/Tcl — Tcl Procedural Language Home Next
42.3. Data Values in PL/Tcl #
The argument values supplied to a PL/Tcl function's code are simply the input arguments converted to text form (just as if they had been displayed by a SELECT statement). Conversely, the return and return_next commands will accept any string that is acceptable input format for the function's declared result type, or for the specified column of a composite result type.
Prev Up Next
42.2. PL/Tcl Functions and Arguments
Home
42.4. Global Data in PL/Tcl
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
