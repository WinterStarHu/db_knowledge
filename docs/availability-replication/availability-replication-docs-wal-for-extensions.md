# PostgreSQL: Documentation: 18: Chapter 64. Write Ahead Logging for Extensions

PostgreSQL: Documentation: 18: Chapter 64. Write Ahead Logging for Extensions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 Development Versions:
19 / devel Chapter 64. Write Ahead Logging for Extensions Prev Up Part VII. Internals Home Next Chapter 64. Write Ahead Logging for Extensions Table of Contents
64.1. Generic WAL Records
64.2. Custom WAL Resource Managers
Certain extensions, principally extensions that implement custom access methods, may need to perform write-ahead logging in order to ensure crash-safety. PostgreSQL provides two ways for extensions to achieve this goal.
First, extensions can choose to use generic WAL, a special type of WAL record which describes changes to pages in a generic way. This method is simple to implement and does not require that an extension library be loaded in order to apply the records. However, generic WAL records will be ignored when performing logical decoding.
Second, extensions can choose to use a custom resource manager. This method is more flexible, supports logical decoding, and can sometimes generate much smaller write-ahead log records than would be possible with generic WAL. However, it is more complex for an extension to implement.
Prev Up Next
63.6. Index Cost Estimation Functions
Home
64.1. Generic WAL Records
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
