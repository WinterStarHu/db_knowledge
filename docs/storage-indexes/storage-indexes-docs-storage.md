# PostgreSQL: Documentation: 18: Chapter 66. Database Physical Storage

PostgreSQL: Documentation: 18: Chapter 66. Database Physical Storage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
7.2
/
7.1
Chapter 66. Database Physical Storage Prev Up Part VII. Internals Home Next Chapter 66. Database Physical Storage Table of Contents
66.1. Database File Layout
66.2. TOAST
66.2.1. Out-of-Line, On-Disk TOAST Storage
66.2.2. Out-of-Line, In-Memory TOAST Storage
66.3. Free Space Map
66.4. Visibility Map
66.5. The Initialization Fork
66.6. Database Page Layout
66.6.1. Table Row Layout
66.7. Heap-Only Tuples (HOT)
This chapter provides an overview of the physical storage format used by PostgreSQL databases.
Prev Up Next
65.6. Hash Indexes
Home
66.1. Database File Layout
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
