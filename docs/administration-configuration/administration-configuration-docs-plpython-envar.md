# PostgreSQL: Documentation: 18: 44.11. Environment Variables

PostgreSQL: Documentation: 18: 44.11. Environment Variables Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
44.11. Environment Variables
Prev Up Chapter 44. PL/Python — Python Procedural Language Home Next
44.11. Environment Variables #
Some of the environment variables that are accepted by the Python interpreter can also be used to affect PL/Python behavior. They would need to be set in the environment of the main PostgreSQL server process, for example in a start script. The available environment variables depend on the version of Python; see the Python documentation for details. At the time of this writing, the following environment variables have an affect on PL/Python, assuming an adequate Python version:
PYTHONHOME PYTHONPATH PYTHONY2K PYTHONOPTIMIZE PYTHONDEBUG PYTHONVERBOSE PYTHONCASEOK PYTHONDONTWRITEBYTECODE PYTHONIOENCODING PYTHONUSERBASE PYTHONHASHSEED (It appears to be a Python implementation detail beyond the control of PL/Python that some of the environment variables listed on the python man page are only effective in a command-line interpreter and not an embedded Python interpreter.) Prev Up Next
44.10. Python 2 vs. Python 3
Home Chapter 45. Server Programming Interface Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
