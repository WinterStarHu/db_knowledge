# PostgreSQL: Documentation: 18: F.31. pgrowlocks — show a table&#x27;s row locking information

PostgreSQL: Documentation: 18: F.31. pgrowlocks — show a table's row locking information Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
F.31. pgrowlocks — show a table's row locking information Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.31. pgrowlocks — show a table's row locking information # F.31.1. Overview F.31.2. Sample Output F.31.3. Author The pgrowlocks module provides a function to show row locking information for a specified table.
By default use is restricted to superusers, roles with privileges of the pg_stat_scan_tables role, and users with SELECT permissions on the table.
F.31.1. Overview # pgrowlocks(text) returns setof record The parameter is the name of a table. The result is a set of records, with one row for each locked row within the table. The output columns are shown in Table F.21.
Table F.21. pgrowlocks Output Columns Name Type Description locked_row tid Tuple ID (TID) of locked row locker xid Transaction ID of locker, or multixact ID if multitransaction; see Section 67.1 multi boolean True if locker is a multitransaction xids xid[] Transaction IDs of lockers (more than one if multitransaction) modes text[] Lock mode of lockers (more than one if multitransaction), an array of For Key Share, For Share, For No Key Update, No Key Update, For Update, Update.
pids integer[] Process IDs of locking backends (more than one if multitransaction) pgrowlocks takes AccessShareLock for the target table and reads each row one by one to collect the row locking information. This is not very speedy for a large table. Note that:
If an ACCESS EXCLUSIVE lock is taken on the table, pgrowlocks will be blocked.
pgrowlocks is not guaranteed to produce a self-consistent snapshot. It is possible that a new row lock is taken, or an old lock is freed, during its execution.
pgrowlocks does not show the contents of locked rows. If you want to take a look at the row contents at the same time, you could do something like this:
SELECT * FROM accounts AS a, pgrowlocks('accounts') AS p WHERE p.locked_row = a.ctid;
Be aware however that such a query will be very inefficient.
F.31.2. Sample Output # =# SELECT * FROM pgrowlocks('t1');
locked_row | locker | multi | xids  |     modes      |  pids
------------+--------+-------+-------+----------------+--------
(0,1)      |    609 | f     | {609} | {"For Share"}  | {3161} (0,2)      |    609 | f     | {609} | {"For Share"}  | {3161} (0,3)      |    607 | f     | {607} | {"For Update"} | {3107} (0,4)      |    607 | f     | {607} | {"For Update"} | {3107} (4 rows) F.31.3. Author # Tatsuo Ishii Prev Up Next F.30. pg_prewarm — preload relation data into buffer caches Home F.32. pg_stat_statements — track statistics of SQL planning and execution Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
