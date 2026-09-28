# PostgreSQL: Documentation: 18: Chapter 61. Genetic Query Optimizer

PostgreSQL: Documentation: 18: Chapter 61. Genetic Query Optimizer Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 61. Genetic Query Optimizer Prev Up Part VII. Internals Home Next Chapter 61. Genetic Query Optimizer Table of Contents
61.1. Query Handling as a Complex Optimization Problem
61.2. Genetic Algorithms
61.3. Genetic Query Optimization (GEQO) in PostgreSQL
61.3.1. Generating Possible Plans with GEQO
61.3.2. Future Implementation Tasks for PostgreSQL GEQO
61.4. Further Reading
Author Written by Martin Utesch () for the Institute of Automatic Control at the University of Mining and Technology in Freiberg, Germany.
Prev Up Next
60.3. Executing Custom Scans
Home
61.1. Query Handling as a Complex Optimization Problem
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
