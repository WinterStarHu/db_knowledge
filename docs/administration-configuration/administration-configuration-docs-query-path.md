# PostgreSQL: Documentation: 18: 51.1. The Path of a Query

PostgreSQL: Documentation: 18: 51.1. The Path of a Query Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
51.1. The Path of a Query
Prev Up Chapter 51. Overview of PostgreSQL Internals Home Next
51.1. The Path of a Query #
Here we give a short overview of the stages a query has to pass to obtain a result.
A connection from an application program to the PostgreSQL server has to be established. The application program transmits a query to the server and waits to receive the results sent back by the server.
The parser stage checks the query transmitted by the application program for correct syntax and creates a query tree.
The rewrite system takes the query tree created by the parser stage and looks for any rules (stored in the system catalogs) to apply to the query tree. It performs the transformations given in the rule bodies.
One application of the rewrite system is in the realization of views. Whenever a query against a view (i.e., a virtual table) is made, the rewrite system rewrites the user's query to a query that accesses the base tables given in the view definition instead.
The planner/optimizer takes the (rewritten) query tree and creates a query plan that will be the input to the executor.
It does so by first creating all possible paths leading to the same result. For example if there is an index on a relation to be scanned, there are two paths for the scan. One possibility is a simple sequential scan and the other possibility is to use the index. Next the cost for the execution of each path is estimated and the cheapest path is chosen. The cheapest path is expanded into a complete plan that the executor can use.
The executor recursively steps through the plan tree and retrieves rows in the way represented by the plan. The executor makes use of the storage system while scanning relations, performs sorts and joins, evaluates qualifications and finally hands back the rows derived.
In the following sections we will cover each of the above listed items in more detail to give a better understanding of PostgreSQL's internal control and data structures.
Prev Up Next Chapter 51. Overview of PostgreSQL Internals Home
51.2. How Connections Are Established
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
