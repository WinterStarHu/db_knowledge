# PostgreSQL: Documentation: 18: 10.6. SELECT Output Columns

PostgreSQL: Documentation: 18: 10.6. SELECT Output Columns Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
10.6. SELECT Output Columns
Prev Up Chapter 10. Type Conversion Home Next
10.6. SELECT Output Columns #
The rules given in the preceding sections will result in assignment of non-unknown data types to all expressions in an SQL query, except for unspecified-type literals that appear as simple output columns of a SELECT command. For example, in SELECT 'Hello World';
there is nothing to identify what type the string literal should be taken as. In this situation PostgreSQL will fall back to resolving the literal's type as text.
When the SELECT is one arm of a UNION (or INTERSECT or EXCEPT) construct, or when it appears within INSERT ... SELECT, this rule is not applied since rules given in preceding sections take precedence. The type of an unspecified-type literal can be taken from the other UNION arm in the first case, or from the destination column in the second case.
RETURNING lists are treated the same as SELECT output lists for this purpose.
Note Prior to PostgreSQL 10, this rule did not exist, and unspecified-type literals in a SELECT output list were left as type unknown. That had assorted bad consequences, so it's been changed.
Prev Up Next
10.5. UNION, CASE, and Related Constructs
Home Chapter 11. Indexes Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
