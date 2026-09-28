# PostgreSQL: Documentation: 18: Chapter 51. Overview of PostgreSQL Internals

PostgreSQL: Documentation: 18: Chapter 51. Overview of PostgreSQL Internals Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 51. Overview of PostgreSQL Internals Prev Up Part VII. Internals Home Next Chapter 51. Overview of PostgreSQL Internals Table of Contents
51.1. The Path of a Query
51.2. How Connections Are Established
51.3. The Parser Stage
51.3.1. Parser
51.3.2. Transformation Process
51.4. The PostgreSQL Rule System
51.5. Planner/Optimizer
51.5.1. Generating Possible Plans
51.6. Executor
Author This chapter originated as part of [sim98] Stefan Simkovics' Master's Thesis prepared at Vienna University of Technology under the direction of O.Univ.Prof.Dr. Georg Gottlob and Univ.Ass. Mag. Katrin Seyr.
This chapter gives an overview of the internal structure of the backend of PostgreSQL. After having read the following sections you should have an idea of how a query is processed. This chapter is intended to help the reader understand the general sequence of operations that occur within the backend from the point at which a query is received, to the point at which the results are returned to the client.
Prev Up Next Part VII. Internals Home
51.1. The Path of a Query
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
