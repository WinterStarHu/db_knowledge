# PostgreSQL: Documentation: 18: 44.4. Anonymous Code Blocks

PostgreSQL: Documentation: 18: 44.4. Anonymous Code Blocks Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
44.4. Anonymous Code Blocks
Prev Up Chapter 44. PL/Python — Python Procedural Language Home Next
44.4. Anonymous Code Blocks #
PL/Python also supports anonymous code blocks called with the DO statement:
DO $$
# PL/Python code
$$ LANGUAGE plpython3u;
An anonymous code block receives no arguments, and whatever value it might return is discarded. Otherwise it behaves just like a function.
Prev Up Next
44.3. Sharing Data
Home
44.5. Trigger Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
