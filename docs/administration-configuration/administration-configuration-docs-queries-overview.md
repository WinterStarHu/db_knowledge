# PostgreSQL: Documentation: 18: 7.1. Overview

PostgreSQL: Documentation: 18: 7.1. Overview Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
7.1. Overview
Prev Up Chapter 7. Queries Home Next
7.1. Overview #
The process of retrieving or the command to retrieve data from a database is called a query. In SQL the SELECT command is used to specify queries. The general syntax of the SELECT command is [WITH with_queries] SELECT select_list FROM table_expression [sort_specification] The following sections describe the details of the select list, the table expression, and the sort specification. WITH queries are treated last since they are an advanced feature.
A simple kind of query has the form:
SELECT * FROM table1;
Assuming that there is a table called table1, this command would retrieve all rows and all user-defined columns from table1. (The method of retrieval depends on the client application. For example, the psql program will display an ASCII-art table on the screen, while client libraries will offer functions to extract individual values from the query result.) The select list specification * means all columns that the table expression happens to provide. A select list can also select a subset of the available columns or make calculations using the columns. For example, if table1 has columns named a, b, and c (and perhaps others) you can make the following query:
SELECT a, b + c FROM table1;
(assuming that b and c are of a numerical data type). See Section 7.3 for more details.
FROM table1 is a simple kind of table expression: it reads just one table. In general, table expressions can be complex constructs of base tables, joins, and subqueries. But you can also omit the table expression entirely and use the SELECT command as a calculator:
SELECT 3 * 4;
This is more useful if the expressions in the select list return varying results. For example, you could call a function this way:
SELECT random();
Prev Up Next Chapter 7. Queries Home
7.2. Table Expressions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
