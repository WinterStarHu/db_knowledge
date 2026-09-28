# PostgreSQL: Documentation: 18: 9.1. Logical Operators

PostgreSQL: Documentation: 18: 9.1. Logical Operators Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
9.1. Logical Operators
Prev Up Chapter 9. Functions and Operators Home Next
9.1. Logical Operators #
The usual logical operators are available:
boolean AND boolean → boolean boolean OR boolean → boolean NOT boolean → boolean SQL uses a three-valued logic system with true, false, and null, which represents “unknown”. Observe the following truth tables:
a b a AND b a OR b TRUE TRUE TRUE TRUE TRUE FALSE FALSE TRUE TRUE NULL NULL TRUE FALSE FALSE FALSE FALSE FALSE NULL FALSE NULL NULL NULL NULL NULL a NOT a TRUE FALSE FALSE TRUE NULL NULL The operators AND and OR are commutative, that is, you can switch the left and right operands without affecting the result. (However, it is not guaranteed that the left operand is evaluated before the right operand. See Section 4.2.14 for more information about the order of evaluation of subexpressions.) Prev Up Next Chapter 9. Functions and Operators Home
9.2. Comparison Functions and Operators
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
