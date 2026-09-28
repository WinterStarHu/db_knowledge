# PostgreSQL: Documentation: 18: UNLISTEN

PostgreSQL: Documentation: 18: UNLISTEN Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
UNLISTEN Prev Up SQL Commands Home Next UNLISTEN UNLISTEN — stop listening for a notification Synopsis UNLISTEN { channel | * } Description UNLISTEN is used to remove an existing registration for NOTIFY events. UNLISTEN cancels any existing registration of the current PostgreSQL session as a listener on the notification channel named channel. The special wildcard * cancels all listener registrations for the current session.
NOTIFY contains a more extensive discussion of the use of LISTEN and NOTIFY.
Parameters channel Name of a notification channel (any identifier).
* All current listen registrations for this session are cleared.
Notes You can unlisten something you were not listening for; no warning or error will appear.
At the end of each session, UNLISTEN * is automatically executed.
A transaction that has executed UNLISTEN cannot be prepared for two-phase commit.
Examples To make a registration:
LISTEN virtual;
NOTIFY virtual;
Asynchronous notification "virtual" received from server process with PID 8448.
Once UNLISTEN has been executed, further NOTIFY messages will be ignored:
UNLISTEN virtual;
NOTIFY virtual;
-- no NOTIFY event is received Compatibility There is no UNLISTEN command in the SQL standard.
See AlsoLISTEN, NOTIFY Prev Up Next TRUNCATE Home UPDATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
