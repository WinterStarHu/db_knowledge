# PostgreSQL: Documentation: 18: 43.2. Data Values in PL/Perl

PostgreSQL: Documentation: 18: 43.2. Data Values in PL/Perl Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
43.2. Data Values in PL/Perl
Prev Up Chapter 43. PL/Perl — Perl Procedural Language Home Next
43.2. Data Values in PL/Perl #
The argument values supplied to a PL/Perl function's code are simply the input arguments converted to text form (just as if they had been displayed by a SELECT statement). Conversely, the return and return_next commands will accept any string that is acceptable input format for the function's declared return type.
If this behavior is inconvenient for a particular case, it can be improved by using a transform, as already illustrated for bool values. Several examples of transform modules are included in the PostgreSQL distribution.
Prev Up Next
43.1. PL/Perl Functions and Arguments
Home
43.3. Built-in Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
