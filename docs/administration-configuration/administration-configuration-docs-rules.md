# PostgreSQL: Documentation: 18: Chapter 39. The Rule System

PostgreSQL: Documentation: 18: Chapter 39. The Rule System Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 39. The Rule System Prev Up Part V. Server Programming Home Next Chapter 39. The Rule System Table of Contents
39.1. The Query Tree
39.2. Views and the Rule System
39.2.1. How SELECT Rules Work
39.2.2. View Rules in Non-SELECT Statements
39.2.3. The Power of Views in PostgreSQL
39.2.4. Updating a View
39.3. Materialized Views
39.4. Rules on INSERT, UPDATE, and DELETE
39.4.1. How Update Rules Work
39.4.2. Cooperation with Views
39.5. Rules and Privileges
39.6. Rules and Command Status
39.7. Rules Versus Triggers
This chapter discusses the rule system in PostgreSQL. Production rule systems are conceptually simple, but there are many subtle points involved in actually using them.
Some other database systems define active database rules, which are usually stored procedures and triggers. In PostgreSQL, these can be implemented using functions and triggers as well.
The rule system (more precisely speaking, the query rewrite rule system) is totally different from stored procedures and triggers. It modifies queries to take rules into consideration, and then passes the modified query to the query planner for planning and execution. It is very powerful, and can be used for many things such as query language procedures, views, and versions. The theoretical foundations and the power of this rule system are also discussed in [ston90b] and [ong90].
Prev Up Next
38.5. A Database Login Event Trigger Example
Home
39.1. The Query Tree
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
