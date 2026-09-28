# PostgreSQL: Documentation: 18: Chapter 41. PL/pgSQL — SQL Procedural Language

PostgreSQL: Documentation: 18: Chapter 41. PL/pgSQL — SQL Procedural Language Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 41. PL/pgSQL — SQL Procedural Language Prev Up Part V. Server Programming Home Next Chapter 41. PL/pgSQL — SQL Procedural Language Table of Contents
41.1. Overview
41.1.1. Advantages of Using PL/pgSQL
41.1.2. Supported Argument and Result Data Types
41.2. Structure of PL/pgSQL
41.3. Declarations
41.3.1. Declaring Function Parameters
41.3.2. ALIAS
41.3.3. Copying Types
41.3.4. Row Types
41.3.5. Record Types
41.3.6. Collation of PL/pgSQL Variables
41.4. Expressions
41.5. Basic Statements
41.5.1. Assignment
41.5.2. Executing SQL Commands
41.5.3. Executing a Command with a Single-Row Result
41.5.4. Executing Dynamic Commands
41.5.5. Obtaining the Result Status
41.5.6. Doing Nothing At All
41.6. Control Structures
41.6.1. Returning from a Function
41.6.2. Returning from a Procedure
41.6.3. Calling a Procedure
41.6.4. Conditionals
41.6.5. Simple Loops
41.6.6. Looping through Query Results
41.6.7. Looping through Arrays
41.6.8. Trapping Errors
41.6.9. Obtaining Execution Location Information
41.7. Cursors
41.7.1. Declaring Cursor Variables
41.7.2. Opening Cursors
41.7.3. Using Cursors
41.7.4. Looping through a Cursor's Result
41.8. Transaction Management
41.9. Errors and Messages
41.9.1. Reporting Errors and Messages
41.9.2. Checking Assertions
41.10. Trigger Functions
41.10.1. Triggers on Data Changes
41.10.2. Triggers on Events
41.11. PL/pgSQL under the Hood
41.11.1. Variable Substitution
41.11.2. Plan Caching
41.12. Tips for Developing in PL/pgSQL
41.12.1. Handling of Quotation Marks
41.12.2. Additional Compile-Time and Run-Time Checks
41.13. Porting from Oracle PL/SQL
41.13.1. Porting Examples
41.13.2. Other Things to Watch For
41.13.3. Appendix
Prev Up Next
40.1. Installing Procedural Languages
Home
41.1. Overview
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
