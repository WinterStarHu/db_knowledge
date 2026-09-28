# PostgreSQL: Documentation: 18: 36.9. Internal Functions

PostgreSQL: Documentation: 18: 36.9. Internal Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
36.9. Internal Functions
Prev Up Chapter 36. Extending SQL Home Next
36.9. Internal Functions #
Internal functions are functions written in C that have been statically linked into the PostgreSQL server. The “body” of the function definition specifies the C-language name of the function, which need not be the same as the name being declared for SQL use. (For reasons of backward compatibility, an empty body is accepted as meaning that the C-language function name is the same as the SQL name.) Normally, all internal functions present in the server are declared during the initialization of the database cluster (see Section 18.2), but a user could use CREATE FUNCTION to create additional alias names for an internal function. Internal functions are declared in CREATE FUNCTION with language name internal. For instance, to create an alias for the sqrt function:
CREATE FUNCTION square_root(double precision) RETURNS double precision AS 'dsqrt' LANGUAGE internal STRICT;
(Most internal functions expect to be declared “strict”.) Note Not all “predefined” functions are “internal” in the above sense. Some predefined functions are written in SQL.
Prev Up Next
36.8. Procedural Language Functions
Home
36.10. C-Language Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
