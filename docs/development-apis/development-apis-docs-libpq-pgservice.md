# PostgreSQL: Documentation: 18: 32.17. The Connection Service File

PostgreSQL: Documentation: 18: 32.17. The Connection Service File Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
32.17. The Connection Service File
Prev Up Chapter 32. libpq — C Library Home Next
32.17. The Connection Service File #
The connection service file allows libpq connection parameters to be associated with a single service name. That service name can then be specified using the service key word in a libpq connection string, and the associated settings will be used. This allows connection parameters to be modified without requiring a recompile of the libpq-using application. The service name can also be specified using the PGSERVICE environment variable.
Service names can be defined in either a per-user service file or a system-wide file. If the same service name exists in both the user and the system file, the user file takes precedence. By default, the per-user service file is named ~/.pg_service.conf. On Microsoft Windows, it is named %APPDATA%\postgresql\.pg_service.conf (where %APPDATA% refers to the Application Data subdirectory in the user's profile). A different file name can be specified by setting the environment variable PGSERVICEFILE. The system-wide file is named pg_service.conf. By default it is sought in the etc directory of the PostgreSQL installation (use pg_config --sysconfdir to identify this directory precisely). Another directory, but not a different file name, can be specified by setting the environment variable PGSYSCONFDIR.
Either service file uses an “INI file” format where the section name is the service name and the parameters are connection parameters; see Section 32.1.2 for a list. For example:
# comment
[mydb] host=somehost port=5433 user=admin An example file is provided in the PostgreSQL installation at share/pg_service.conf.sample.
Connection parameters obtained from a service file are combined with parameters obtained from other sources. A service file setting overrides the corresponding environment variable, and in turn can be overridden by a value given directly in the connection string. For example, using the above service file, a connection string service=mydb port=5434 will use host somehost, port 5434, user admin, and other parameters as set by environment variables or built-in defaults.
Prev Up Next
32.16. The Password File
Home
32.18. LDAP Lookup of Connection Parameters
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
