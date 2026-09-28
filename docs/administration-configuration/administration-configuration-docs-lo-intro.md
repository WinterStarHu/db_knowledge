# PostgreSQL: Documentation: 18: 33.1. Introduction

PostgreSQL: Documentation: 18: 33.1. Introduction Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
33.1. Introduction
Prev Up Chapter 33. Large Objects Home Next
33.1. Introduction #
All large objects are stored in a single system table named pg_largeobject. Each large object also has an entry in the system table pg_largeobject_metadata. Large objects can be created, modified, and deleted using a read/write API that is similar to standard operations on files.
PostgreSQL also supports a storage system called “TOAST”, which automatically stores values larger than a single database page into a secondary storage area per table. This makes the large object facility partially obsolete. One remaining advantage of the large object facility is that it allows values up to 4 TB in size, whereas TOASTed fields can be at most 1 GB. Also, reading and updating portions of a large object can be done efficiently, while most operations on a TOASTed field will read or write the whole value as a unit.
Prev Up Next Chapter 33. Large Objects Home
33.2. Implementation Features
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
