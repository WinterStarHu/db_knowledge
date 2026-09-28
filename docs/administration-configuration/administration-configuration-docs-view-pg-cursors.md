# PostgreSQL: Documentation: 18: 53.7. pg_cursors

PostgreSQL: Documentation: 18: 53.7. pg_cursors Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.7. pg_cursors
Prev Up Chapter 53. System Views Home Next
53.7. pg_cursors #
The pg_cursors view lists the cursors that are currently available. Cursors can be defined in several ways:
via the DECLARE statement in SQL via the Bind message in the frontend/backend protocol, as described in Section 54.2.3 via the Server Programming Interface (SPI), as described in Section 45.1 The pg_cursors view displays cursors created by any of these means. Cursors only exist for the duration of the transaction that defines them, unless they have been declared WITH HOLD. Therefore non-holdable cursors are only present in the view until the end of their creating transaction.
Note Cursors are used internally to implement some of the components of PostgreSQL, such as procedural languages. Therefore, the pg_cursors view might include cursors that have not been explicitly created by the user.
Table 53.7. pg_cursors Columns Column Type Description name text The name of the cursor statement text The verbatim query string submitted to declare this cursor is_holdable bool true if the cursor is holdable (that is, it can be accessed after the transaction that declared the cursor has committed); false otherwise is_binary bool true if the cursor was declared BINARY; false otherwise is_scrollable bool true if the cursor is scrollable (that is, it allows rows to be retrieved in a nonsequential manner); false otherwise creation_time timestamptz The time at which the cursor was declared The pg_cursors view is read-only.
Prev Up Next
53.6. pg_config
Home
53.8. pg_file_settings
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
