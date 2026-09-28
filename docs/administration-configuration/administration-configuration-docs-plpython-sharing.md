# PostgreSQL: Documentation: 18: 44.3. Sharing Data

PostgreSQL: Documentation: 18: 44.3. Sharing Data Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
44.3. Sharing Data
Prev Up Chapter 44. PL/Python — Python Procedural Language Home Next
44.3. Sharing Data #
The global dictionary SD is available to store private data between repeated calls to the same function. The global dictionary GD is public data, that is available to all Python functions within a session; use with care.
Each function gets its own execution environment in the Python interpreter, so that global data and function arguments from myfunc are not available to myfunc2. The exception is the data in the GD dictionary, as mentioned above.
Prev Up Next
44.2. Data Values
Home
44.4. Anonymous Code Blocks
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
