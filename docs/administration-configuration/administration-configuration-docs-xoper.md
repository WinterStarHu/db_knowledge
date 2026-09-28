# PostgreSQL: Documentation: 18: 36.14. User-Defined Operators

PostgreSQL: Documentation: 18: 36.14. User-Defined Operators Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
36.14. User-Defined Operators
Prev Up Chapter 36. Extending SQL Home Next
36.14. User-Defined Operators #
Every operator is “syntactic sugar” for a call to an underlying function that does the real work; so you must first create the underlying function before you can create the operator. However, an operator is not merely syntactic sugar, because it carries additional information that helps the query planner optimize queries that use the operator. The next section will be devoted to explaining that additional information.
PostgreSQL supports prefix and infix operators. Operators can be overloaded; that is, the same operator name can be used for different operators that have different numbers and types of operands. When a query is executed, the system determines the operator to call from the number and types of the provided operands.
Here is an example of creating an operator for adding two complex numbers. We assume we've already created the definition of type complex (see Section 36.13). First we need a function that does the work, then we can define the operator:
CREATE FUNCTION complex_add(complex, complex) RETURNS complex AS 'filename', 'complex_add' LANGUAGE C IMMUTABLE STRICT;
CREATE OPERATOR + ( leftarg = complex, rightarg = complex, function = complex_add, commutator = + );
Now we could execute a query like this:
SELECT (a + b) AS c FROM test_complex;
c
-----------------
(5.2,6.05) (133.42,144.95) We've shown how to create a binary operator here. To create a prefix operator, just omit the leftarg. The function clause and the argument clauses are the only required items in CREATE OPERATOR. The commutator clause shown in the example is an optional hint to the query optimizer. Further details about commutator and other optimizer hints appear in the next section.
Prev Up Next
36.13. User-Defined Types
Home
36.15. Operator Optimization Information
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
