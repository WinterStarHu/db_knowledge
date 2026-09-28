# PostgreSQL: Documentation: 18: pg_controldata

PostgreSQL: Documentation: 18: pg_controldata Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
pg_controldata Prev Up PostgreSQL Server Applications Home Next pg_controldata pg_controldata — display control information of a PostgreSQL database cluster Synopsis pg_controldata [option] [[ -D | --pgdata ]datadir] Description pg_controldata prints information initialized during initdb, such as the catalog version. It also shows information about write-ahead logging and checkpoint processing. This information is cluster-wide, and not specific to any one database.
This utility can only be run by the user who initialized the cluster because it requires read access to the data directory. You can specify the data directory on the command line, or use the environment variable PGDATA. This utility supports the options -V and --version, which print the pg_controldata version and exit. It also supports options -? and --help, which output the supported arguments.
Environment PGDATA Default data directory location PG_COLOR Specifies whether to use color in diagnostic messages. Possible values are always, auto and never.
Prev Up Next pg_checksums Home pg_createsubscriber Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
