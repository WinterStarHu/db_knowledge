# PostgreSQL: Documentation: 18: Chapter 49. Archive Modules

PostgreSQL: Documentation: 18: Chapter 49. Archive Modules Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel Chapter 49. Archive Modules Prev Up Part V. Server Programming Home Next Chapter 49. Archive Modules Table of Contents
49.1. Initialization Functions
49.2. Archive Module Callbacks
49.2.1. Startup Callback
49.2.2. Check Callback
49.2.3. Archive Callback
49.2.4. Shutdown Callback
PostgreSQL provides infrastructure to create custom modules for continuous archiving (see Section 25.3). While archiving via a shell command (i.e., archive_command) is much simpler, a custom archive module will often be considerably more robust and performant.
When a custom archive_library is configured, PostgreSQL will submit completed WAL files to the module, and the server will avoid recycling or removing these WAL files until the module indicates that the files were successfully archived. It is ultimately up to the module to decide what to do with each WAL file, but many recommendations are listed at Section 25.3.1.
Archiving modules must at least consist of an initialization function (see Section 49.1) and the required callbacks (see Section 49.2). However, archive modules are also permitted to do much more (e.g., declare GUCs and register background workers).
The contrib/basic_archive module contains a working example, which demonstrates some useful techniques.
Prev Up Next Chapter 48. Replication Progress Tracking Home
49.1. Initialization Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
