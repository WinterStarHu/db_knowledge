# PostgreSQL: Documentation: 18: 41.4. Expressions

PostgreSQL: Documentation: 18: 41.4. Expressions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
41.4. Expressions
Prev Up Chapter 41. PL/pgSQL — SQL Procedural Language Home Next
41.4. Expressions #
All expressions used in PL/pgSQL statements are processed using the server's main SQL executor. For example, when you write a PL/pgSQL statement like IF expression THEN ...
PL/pgSQL will evaluate the expression by feeding a query like SELECT expression to the main SQL engine. While forming the SELECT command, any occurrences of PL/pgSQL variable names are replaced by query parameters, as discussed in detail in Section 41.11.1. This allows the query plan for the SELECT to be prepared just once and then reused for subsequent evaluations with different values of the variables. Thus, what really happens on first use of an expression is essentially a PREPARE command. For example, if we have declared two integer variables x and y, and we write IF x < y THEN ...
what happens behind the scenes is equivalent to PREPARE statement_name(integer, integer) AS SELECT $1 < $2;
and then this prepared statement is EXECUTEd for each execution of the IF statement, with the current values of the PL/pgSQL variables supplied as parameter values. Normally these details are not important to a PL/pgSQL user, but they are useful to know when trying to diagnose a problem. More information appears in Section 41.11.2.
Since an expression is converted to a SELECT command, it can contain the same clauses that an ordinary SELECT would, except that it cannot include a top-level UNION, INTERSECT, or EXCEPT clause. Thus for example one could test whether a table is non-empty with IF count(*) > 0 FROM my_table THEN ...
since the expression between IF and THEN is parsed as though it were SELECT count(*) > 0 FROM my_table. The SELECT must produce a single column, and not more than one row. (If it produces no rows, the result is taken as NULL.) Prev Up Next
41.3. Declarations
Home
41.5. Basic Statements
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
