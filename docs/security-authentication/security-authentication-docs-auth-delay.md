# PostgreSQL: Documentation: 18: F.2. auth_delay — pause on authentication failure

PostgreSQL: Documentation: 18: F.2. auth_delay — pause on authentication failure Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
F.2. auth_delay — pause on authentication failure Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.2. auth_delay — pause on authentication failure # F.2.1. Configuration Parameters F.2.2. Author auth_delay causes the server to pause briefly before reporting authentication failure, to make brute-force attacks on database passwords more difficult. Note that it does nothing to prevent denial-of-service attacks, and may even exacerbate them, since processes that are waiting before reporting authentication failure will still consume connection slots.
In order to function, this module must be loaded via shared_preload_libraries in postgresql.conf.
F.2.1. Configuration Parameters # auth_delay.milliseconds (integer) The number of milliseconds to wait before reporting an authentication failure. The default is 0.
These parameters must be set in postgresql.conf. Typical usage might be:
# postgresql.conf
shared_preload_libraries = 'auth_delay' auth_delay.milliseconds = '500' F.2.2. Author # KaiGai Kohei Prev Up Next F.1. amcheck — tools to verify table and index consistency Home F.3. auto_explain — log execution plans of slow queries Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
