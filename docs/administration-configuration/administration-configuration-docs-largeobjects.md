# PostgreSQL: Documentation: 18: Chapter 33. Large Objects

PostgreSQL: Documentation: 18: Chapter 33. Large Objects Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 33. Large Objects Prev Up Part IV. Client Interfaces Home Next Chapter 33. Large Objects Table of Contents
33.1. Introduction
33.2. Implementation Features
33.3. Client Interfaces
33.3.1. Creating a Large Object
33.3.2. Importing a Large Object
33.3.3. Exporting a Large Object
33.3.4. Opening an Existing Large Object
33.3.5. Writing Data to a Large Object
33.3.6. Reading Data from a Large Object
33.3.7. Seeking in a Large Object
33.3.8. Obtaining the Seek Position of a Large Object
33.3.9. Truncating a Large Object
33.3.10. Closing a Large Object Descriptor
33.3.11. Removing a Large Object
33.4. Server-Side Functions
33.5. Example Program
PostgreSQL has a large object facility, which provides stream-style access to user data that is stored in a special large-object structure. Streaming access is useful when working with data values that are too large to manipulate conveniently as a whole.
This chapter describes the implementation and the programming and query language interfaces to PostgreSQL large object data. We use the libpq C library for the examples in this chapter, but most programming interfaces native to PostgreSQL support equivalent functionality. Other interfaces might use the large object interface internally to provide generic support for large values. This is not described here.
Prev Up Next
32.23. Example Programs
Home
33.1. Introduction
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
