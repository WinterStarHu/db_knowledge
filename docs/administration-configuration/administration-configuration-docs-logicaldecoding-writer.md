# PostgreSQL: Documentation: 18: 47.7. Logical Decoding Output Writers

PostgreSQL: Documentation: 18: 47.7. Logical Decoding Output Writers Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
47.7. Logical Decoding Output Writers
Prev Up Chapter 47. Logical Decoding Home Next
47.7. Logical Decoding Output Writers #
It is possible to add more output methods for logical decoding. For details, see src/backend/replication/logical/logicalfuncs.c. Essentially, three functions need to be provided: one to read WAL, one to prepare writing output, and one to write the output (see Section 47.6.5).
Prev Up Next
47.6. Logical Decoding Output Plugins
Home
47.8. Synchronous Replication Support for Logical Decoding
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
