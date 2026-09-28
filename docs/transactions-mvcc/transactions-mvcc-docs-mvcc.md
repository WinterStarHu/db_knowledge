# PostgreSQL: Documentation: 18: Chapter 13. Concurrency Control

PostgreSQL: Documentation: 18: Chapter 13. Concurrency Control Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 13. Concurrency Control Prev Up Part II. The SQL Language Home Next Chapter 13. Concurrency Control Table of Contents
13.1. Introduction
13.2. Transaction Isolation
13.2.1. Read Committed Isolation Level
13.2.2. Repeatable Read Isolation Level
13.2.3. Serializable Isolation Level
13.3. Explicit Locking
13.3.1. Table-Level Locks
13.3.2. Row-Level Locks
13.3.3. Page-Level Locks
13.3.4. Deadlocks
13.3.5. Advisory Locks
13.4. Data Consistency Checks at the Application Level
13.4.1. Enforcing Consistency with Serializable Transactions
13.4.2. Enforcing Consistency with Explicit Blocking Locks
13.5. Serialization Failure Handling
13.6. Caveats
13.7. Locking and Indexes
This chapter describes the behavior of the PostgreSQL database system when two or more sessions try to access the same data at the same time. The goals in that situation are to allow efficient access for all sessions while maintaining strict data integrity. Every developer of database applications should be familiar with the topics covered in this chapter.
Prev Up Next
12.11. Limitations
Home
13.1. Introduction
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
