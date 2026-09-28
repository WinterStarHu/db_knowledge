# PostgreSQL: Documentation: 18: PostgreSQL Server Applications

PostgreSQL: Documentation: 18: PostgreSQL Server Applications Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
PostgreSQL Server Applications Prev Up Part VI. Reference Home Next PostgreSQL Server Applications This part contains reference information for PostgreSQL server applications and support utilities. These commands can only be run usefully on the host where the database server resides. Other utility programs are listed in PostgreSQL Client Applications.
Table of Contents initdb — create a new PostgreSQL database cluster pg_archivecleanup — clean up PostgreSQL WAL archive files pg_checksums — enable, disable or check data checksums in a PostgreSQL database cluster pg_controldata — display control information of a PostgreSQL database cluster pg_createsubscriber — convert a physical replica into a new logical replica pg_ctl — initialize, start, stop, or control a PostgreSQL server pg_resetwal — reset the write-ahead log and other control information of a PostgreSQL database cluster pg_rewind — synchronize a PostgreSQL data directory with another data directory that was forked from it pg_test_fsync — determine fastest wal_sync_method for PostgreSQL pg_test_timing — measure timing overhead pg_upgrade — upgrade a PostgreSQL server instance pg_waldump — display a human-readable rendering of the write-ahead log of a PostgreSQL database cluster pg_walsummary — print contents of WAL summary files postgres — PostgreSQL database server Prev Up Next vacuumdb Home initdb Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
