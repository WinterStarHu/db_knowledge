# PostgreSQL: Documentation: 18: Chapter 43. PL/Perl — Perl Procedural Language

PostgreSQL: Documentation: 18: Chapter 43. PL/Perl — Perl Procedural Language Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 43. PL/Perl — Perl Procedural Language Prev Up Part V. Server Programming Home Next Chapter 43. PL/Perl — Perl Procedural Language Table of Contents
43.1. PL/Perl Functions and Arguments
43.2. Data Values in PL/Perl
43.3. Built-in Functions
43.3.1. Database Access from PL/Perl
43.3.2. Utility Functions in PL/Perl
43.4. Global Values in PL/Perl
43.5. Trusted and Untrusted PL/Perl
43.6. PL/Perl Triggers
43.7. PL/Perl Event Triggers
43.8. PL/Perl Under the Hood
43.8.1. Configuration
43.8.2. Limitations and Missing Features
PL/Perl is a loadable procedural language that enables you to write PostgreSQL functions and procedures in the Perl programming language.
The main advantage to using PL/Perl is that this allows use, within stored functions and procedures, of the manyfold “string munging” operators and functions available for Perl. Parsing complex strings might be easier using Perl than it is with the string functions and control structures provided in PL/pgSQL.
To install PL/Perl in a particular database, use CREATE EXTENSION plperl.
Tip If a language is installed into template1, all subsequently created databases will have the language installed automatically.
Note Users of source packages must specially enable the build of PL/Perl during the installation process. (Refer to Chapter 17 for more information.) Users of binary packages might find PL/Perl in a separate subpackage.
Prev Up Next
42.12. Tcl Procedure Names
Home
43.1. PL/Perl Functions and Arguments
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
