# PostgreSQL: Documentation: 18: Chapter 58. Writing a Foreign Data Wrapper

PostgreSQL: Documentation: 18: Chapter 58. Writing a Foreign Data Wrapper Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 58. Writing a Foreign Data Wrapper Prev Up Part VII. Internals Home Next Chapter 58. Writing a Foreign Data Wrapper Table of Contents
58.1. Foreign Data Wrapper Functions
58.2. Foreign Data Wrapper Callback Routines
58.2.1. FDW Routines for Scanning Foreign Tables
58.2.2. FDW Routines for Scanning Foreign Joins
58.2.3. FDW Routines for Planning Post-Scan/Join Processing
58.2.4. FDW Routines for Updating Foreign Tables
58.2.5. FDW Routines for TRUNCATE
58.2.6. FDW Routines for Row Locking
58.2.7. FDW Routines for EXPLAIN
58.2.8. FDW Routines for ANALYZE
58.2.9. FDW Routines for IMPORT FOREIGN SCHEMA
58.2.10. FDW Routines for Parallel Execution
58.2.11. FDW Routines for Asynchronous Execution
58.2.12. FDW Routines for Reparameterization of Paths
58.3. Foreign Data Wrapper Helper Functions
58.4. Foreign Data Wrapper Query Planning
58.5. Row Locking in Foreign Data Wrappers
All operations on a foreign table are handled through its foreign data wrapper, which consists of a set of functions that the core server calls. The foreign data wrapper is responsible for fetching data from the remote data source and returning it to the PostgreSQL executor. If updating foreign tables is to be supported, the wrapper must handle that, too. This chapter outlines how to write a new foreign data wrapper.
The foreign data wrappers included in the standard distribution are good references when trying to write your own. Look into the contrib subdirectory of the source tree. The CREATE FOREIGN DATA WRAPPER reference page also has some useful details.
Note The SQL standard specifies an interface for writing foreign data wrappers. However, PostgreSQL does not implement that API, because the effort to accommodate it into PostgreSQL would be large, and the standard API hasn't gained wide adoption anyway.
Prev Up Next Chapter 57. Writing a Procedural Language Handler Home
58.1. Foreign Data Wrapper Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
