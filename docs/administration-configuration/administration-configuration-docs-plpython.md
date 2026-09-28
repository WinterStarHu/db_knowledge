# PostgreSQL: Documentation: 18: Chapter 44. PL/Python — Python Procedural Language

PostgreSQL: Documentation: 18: Chapter 44. PL/Python — Python Procedural Language Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 44. PL/Python — Python Procedural Language Prev Up Part V. Server Programming Home Next Chapter 44. PL/Python — Python Procedural Language Table of Contents
44.1. PL/Python Functions
44.2. Data Values
44.2.1. Data Type Mapping
44.2.2. Null, None
44.2.3. Arrays, Lists
44.2.4. Composite Types
44.2.5. Set-Returning Functions
44.3. Sharing Data
44.4. Anonymous Code Blocks
44.5. Trigger Functions
44.6. Database Access
44.6.1. Database Access Functions
44.6.2. Trapping Errors
44.7. Explicit Subtransactions
44.7.1. Subtransaction Context Managers
44.8. Transaction Management
44.9. Utility Functions
44.10. Python 2 vs. Python 3
44.11. Environment Variables
The PL/Python procedural language allows PostgreSQL functions and procedures to be written in the Python language.
To install PL/Python in a particular database, use CREATE EXTENSION plpython3u.
Tip If a language is installed into template1, all subsequently created databases will have the language installed automatically.
PL/Python is only available as an “untrusted” language, meaning it does not offer any way of restricting what users can do in it and is therefore named plpython3u. A trusted variant plpython might become available in the future if a secure execution mechanism is developed in Python. The writer of a function in untrusted PL/Python must take care that the function cannot be used to do anything unwanted, since it will be able to do anything that could be done by a user logged in as the database administrator. Only superusers can create functions in untrusted languages such as plpython3u.
Note Users of source packages must specially enable the build of PL/Python during the installation process. (Refer to the installation instructions for more information.) Users of binary packages might find PL/Python in a separate subpackage.
Prev Up Next
43.8. PL/Perl Under the Hood
Home
44.1. PL/Python Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
