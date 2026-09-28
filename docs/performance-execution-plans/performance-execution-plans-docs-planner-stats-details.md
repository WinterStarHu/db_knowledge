# PostgreSQL: Documentation: 18: Chapter 69. How the Planner Uses Statistics

PostgreSQL: Documentation: 18: Chapter 69. How the Planner Uses Statistics Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 69. How the Planner Uses Statistics Prev Up Part VII. Internals Home Next Chapter 69. How the Planner Uses Statistics Table of Contents
69.1. Row Estimation Examples
69.2. Multivariate Statistics Examples
69.2.1. Functional Dependencies
69.2.2. Multivariate N-Distinct Counts
69.2.3. MCV Lists
69.3. Planner Statistics and Security
This chapter builds on the material covered in Section 14.1 and Section 14.2 to show some additional details about how the planner uses the system statistics to estimate the number of rows each part of a query might return. This is a significant part of the planning process, providing much of the raw material for cost calculation.
The intent of this chapter is not to document the code in detail, but to present an overview of how it works. This will perhaps ease the learning curve for someone who subsequently wishes to read the code.
Prev Up Next
68.6. BKI Example
Home
69.1. Row Estimation Examples
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
