# PostgreSQL: Documentation: 18: 8.6. Boolean Type

PostgreSQL: Documentation: 18: 8.6. Boolean Type Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
8.6. Boolean Type
Prev Up Chapter 8. Data Types Home Next
8.6. Boolean Type #
PostgreSQL provides the standard SQL type boolean; see Table 8.19. The boolean type can have several states: “true”, “false”, and a third state, “unknown”, which is represented by the SQL null value.
Table 8.19. Boolean Data Type Name Storage Size Description boolean 1 byte state of true or false Boolean constants can be represented in SQL queries by the SQL key words TRUE, FALSE, and NULL.
The datatype input function for type boolean accepts these string representations for the “true” state:
true yes on 1 and these representations for the “false” state:
false no off 0 Unique prefixes of these strings are also accepted, for example t or n. Leading or trailing whitespace is ignored, and case does not matter.
The datatype output function for type boolean always emits either t or f, as shown in Example 8.2.
Example 8.2. Using the boolean Type CREATE TABLE test1 (a boolean, b text);
INSERT INTO test1 VALUES (TRUE, 'sic est');
INSERT INTO test1 VALUES (FALSE, 'non est');
SELECT * FROM test1;
a |    b
---+---------
t | sic est f | non est SELECT * FROM test1 WHERE a;
a |    b
---+---------
t | sic est The key words TRUE and FALSE are the preferred (SQL-compliant) method for writing Boolean constants in SQL queries. But you can also use the string representations by following the generic string-literal constant syntax described in Section 4.1.2.7, for example 'yes'::boolean.
Note that the parser automatically understands that TRUE and FALSE are of type boolean, but this is not so for NULL because that can have any type. So in some contexts you might have to cast NULL to boolean explicitly, for example NULL::boolean. Conversely, the cast can be omitted from a string-literal Boolean value in contexts where the parser can deduce that the literal must be of type boolean.
Prev Up Next
8.5. Date/Time Types
Home
8.7. Enumerated Types
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
