# PostgreSQL: Documentation: 18: Chapter 42. PL/Tcl — Tcl Procedural Language

PostgreSQL: Documentation: 18: Chapter 42. PL/Tcl — Tcl Procedural Language Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 42. PL/Tcl — Tcl Procedural Language Prev Up Part V. Server Programming Home Next Chapter 42. PL/Tcl — Tcl Procedural Language Table of Contents
42.1. Overview
42.2. PL/Tcl Functions and Arguments
42.3. Data Values in PL/Tcl
42.4. Global Data in PL/Tcl
42.5. Database Access from PL/Tcl
42.6. Trigger Functions in PL/Tcl
42.7. Event Trigger Functions in PL/Tcl
42.8. Error Handling in PL/Tcl
42.9. Explicit Subtransactions in PL/Tcl
42.10. Transaction Management
42.11. PL/Tcl Configuration
42.12. Tcl Procedure Names
PL/Tcl is a loadable procedural language for the PostgreSQL database system that enables the Tcl language to be used to write PostgreSQL functions and procedures.
Prev Up Next
41.13. Porting from Oracle PL/SQL
Home
42.1. Overview
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
