# PostgreSQL: Documentation: 18: 18.12. Registering Event Log on Windows

PostgreSQL: Documentation: 18: 18.12. Registering Event Log on Windows Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
18.12. Registering Event Log on Windows
Prev Up Chapter 18. Server Setup and Operation Home Next
18.12. Registering Event Log on Windows #
To register a Windows event log library with the operating system, issue this command:
regsvr32 pgsql_library_directory/pgevent.dll This creates registry entries used by the event viewer, under the default event source named PostgreSQL.
To specify a different event source name (see event_source), use the /n and /i options:
regsvr32 /n /i:event_source_name pgsql_library_directory/pgevent.dll To unregister the event log library from the operating system, issue this command:
regsvr32 /u [/i:event_source_name] pgsql_library_directory/pgevent.dll Note To enable event logging in the database server, modify log_destination to include eventlog in postgresql.conf.
Prev Up Next
18.11. Secure TCP/IP Connections with SSH Tunnels
Home Chapter 19. Server Configuration Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
