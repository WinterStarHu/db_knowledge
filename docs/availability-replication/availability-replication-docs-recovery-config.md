# PostgreSQL: Documentation: 18: O.1. recovery.conf file merged into postgresql.conf

PostgreSQL: Documentation: 18: O.1. recovery.conf file merged into postgresql.conf Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
O.1. recovery.conf file merged into postgresql.conf Prev Up Appendix O. Obsolete or Renamed Features Home Next O.1. recovery.conf file merged into postgresql.conf # PostgreSQL 11 and below used a configuration file named recovery.conf  to manage replicas and standbys. Support for this file was removed in PostgreSQL 12. See the release notes for PostgreSQL 12 for details on this change.
On PostgreSQL 12 and above, archive recovery, streaming replication, and PITR are configured using normal server configuration parameters. These are set in postgresql.conf or via ALTER SYSTEM like any other parameter.
The server will not start if a recovery.conf exists.
PostgreSQL 15 and below had a setting promote_trigger_file, or trigger_file before 12. Use pg_ctl promote or call pg_promote() to promote a standby instead.
The standby_mode  setting has been removed. A standby.signal file in the data directory is used instead. See Standby Server Operation for details.
Prev Up Next Appendix O. Obsolete or Renamed Features Home O.2. Default Roles Renamed to Predefined Roles Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
