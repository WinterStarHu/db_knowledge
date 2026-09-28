# PostgreSQL: Documentation: 18: 61.1. Query Handling as a Complex Optimization Problem

PostgreSQL: Documentation: 18: 61.1. Query Handling as a Complex Optimization Problem Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
61.1. Query Handling as a Complex Optimization Problem
Prev Up Chapter 61. Genetic Query Optimizer Home Next
61.1. Query Handling as a Complex Optimization Problem #
Among all relational operators the most difficult one to process and optimize is the join. The number of possible query plans grows exponentially with the number of joins in the query. Further optimization effort is caused by the support of a variety of join methods (e.g., nested loop, hash join, merge join in PostgreSQL) to process individual joins and a diversity of indexes (e.g., B-tree, hash, GiST and GIN in PostgreSQL) as access paths for relations.
The normal PostgreSQL query optimizer performs a near-exhaustive search over the space of alternative strategies. This algorithm, first introduced in IBM's System R database, produces a near-optimal join order, but can take an enormous amount of time and memory space when the number of joins in the query grows large. This makes the ordinary PostgreSQL query optimizer inappropriate for queries that join a large number of tables.
The Institute of Automatic Control at the University of Mining and Technology, in Freiberg, Germany, encountered some problems when it wanted to use PostgreSQL as the backend for a decision support knowledge based system for the maintenance of an electrical power grid. The DBMS needed to handle large join queries for the inference machine of the knowledge based system. The number of joins in these queries made using the normal query optimizer infeasible.
In the following we describe the implementation of a genetic algorithm to solve the join ordering problem in a manner that is efficient for queries involving large numbers of joins.
Prev Up Next Chapter 61. Genetic Query Optimizer Home
61.2. Genetic Algorithms
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
