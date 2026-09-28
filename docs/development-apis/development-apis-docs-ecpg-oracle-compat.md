# PostgreSQL: Documentation: 18: 34.16. Oracle Compatibility Mode

PostgreSQL: Documentation: 18: 34.16. Oracle Compatibility Mode Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
34.16. Oracle Compatibility Mode
Prev Up Chapter 34. ECPG — Embedded SQL in C Home Next
34.16. Oracle Compatibility Mode #
ecpg can be run in a so-called Oracle compatibility mode. If this mode is active, it tries to behave as if it were Oracle Pro*C.
Specifically, this mode changes ecpg in three ways:
Pad character arrays receiving character string types with trailing spaces to the specified length Zero byte terminate these character arrays, and set the indicator variable if truncation occurs Set the null indicator to -1 when character arrays receive empty character string types Prev Up Next
34.15. Informix Compatibility Mode
Home
34.17. Internals
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
