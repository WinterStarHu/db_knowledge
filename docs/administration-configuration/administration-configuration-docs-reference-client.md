# PostgreSQL: Documentation: 18: PostgreSQL Client Applications

PostgreSQL: Documentation: 18: PostgreSQL Client Applications Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
PostgreSQL Client Applications Prev Up Part VI. Reference Home Next PostgreSQL Client Applications This part contains reference information for PostgreSQL client applications and utilities. Not all of these commands are of general utility; some might require special privileges. The common feature of these applications is that they can be run on any host, independent of where the database server resides.
When specified on the command line, user and database names have their case preserved — the presence of spaces or special characters might require quoting. Table names and other identifiers do not have their case preserved, except where documented, and might require quoting.
Table of Contents clusterdb — cluster a PostgreSQL database createdb — create a new PostgreSQL database createuser — define a new PostgreSQL user account dropdb — remove a PostgreSQL database dropuser — remove a PostgreSQL user account ecpg — embedded SQL C preprocessor pg_amcheck — checks for corruption in one or more PostgreSQL databases pg_basebackup — take a base backup of a PostgreSQL cluster pgbench — run a benchmark test on PostgreSQL pg_combinebackup — reconstruct a full backup from an incremental backup and dependent backups pg_config — retrieve information about the installed version of PostgreSQL pg_dump — export a PostgreSQL database as an SQL script or to other formats pg_dumpall — extract a PostgreSQL database cluster into a script file pg_isready — check the connection status of a PostgreSQL server pg_receivewal — stream write-ahead logs from a PostgreSQL server pg_recvlogical — control PostgreSQL logical decoding streams pg_restore — restore a PostgreSQL database from an archive file created by pg_dump pg_verifybackup — verify the integrity of a base backup of a PostgreSQL cluster psql — PostgreSQL interactive terminal reindexdb — reindex a PostgreSQL database vacuumdb — garbage-collect and analyze a PostgreSQL database Prev Up Next VALUES Home clusterdb Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
