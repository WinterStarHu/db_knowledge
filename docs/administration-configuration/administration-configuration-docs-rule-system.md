# PostgreSQL: Documentation: 18: 51.4. The PostgreSQL Rule System

PostgreSQL: Documentation: 18: 51.4. The PostgreSQL Rule System Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
51.4. The PostgreSQL Rule System
Prev Up Chapter 51. Overview of PostgreSQL Internals Home Next
51.4. The PostgreSQL Rule System #
PostgreSQL supports a powerful rule system for the specification of views and ambiguous view updates. Originally the PostgreSQL rule system consisted of two implementations:
The first one worked using row level processing and was implemented deep in the executor. The rule system was called whenever an individual row had been accessed. This implementation was removed in 1995 when the last official release of the Berkeley Postgres project was transformed into Postgres95.
The second implementation of the rule system is a technique called query rewriting. The rewrite system is a module that exists between the parser stage and the planner/optimizer. This technique is still implemented.
The query rewriter is discussed in some detail in Chapter 39, so there is no need to cover it here. We will only point out that both the input and the output of the rewriter are query trees, that is, there is no change in the representation or level of semantic detail in the trees. Rewriting can be thought of as a form of macro expansion.
Prev Up Next
51.3. The Parser Stage
Home
51.5. Planner/Optimizer
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
