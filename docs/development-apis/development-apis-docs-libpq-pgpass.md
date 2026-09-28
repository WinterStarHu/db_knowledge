# PostgreSQL: Documentation: 18: 32.16. The Password File

PostgreSQL: Documentation: 18: 32.16. The Password File Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
32.16. The Password File
Prev Up Chapter 32. libpq — C Library Home Next
32.16. The Password File #
The file .pgpass in a user's home directory can contain passwords to be used if the connection requires a password (and no password has been specified otherwise). On Unix systems, the directory can be specified by the HOME environment variable, or if undefined, the home directory of the effective user. On Microsoft Windows the file is named %APPDATA%\postgresql\pgpass.conf (where %APPDATA% refers to the Application Data subdirectory in the user's profile). Alternatively, the password file to use can be specified using the connection parameter passfile or the environment variable PGPASSFILE.
This file should contain lines of the following format:
hostname:port:database:username:password (You can add a reminder comment to the file by copying the line above and preceding it with #.) Each of the first four fields can be a literal value, or *, which matches anything. The password field from the first line that matches the current connection parameters will be used. (Therefore, put more-specific entries first when you are using wildcards.) If an entry needs to contain : or \, escape this character with \. The host name field is matched to the host connection parameter if that is specified, otherwise to the hostaddr parameter if that is specified; if neither are given then the host name localhost is searched for. The host name localhost is also searched for when the connection is a Unix-domain socket connection and the host parameter matches libpq's default socket directory path. In a standby server, a database field of replication matches streaming replication connections made to the primary server. The database field is of limited usefulness otherwise, because users have the same password for all databases in the same cluster.
On Unix systems, the permissions on a password file must disallow any access to world or group; achieve this by a command such as chmod 0600 ~/.pgpass. If the permissions are less strict than this, the file will be ignored. On Microsoft Windows, it is assumed that the file is stored in a directory that is secure, so no special permissions check is made.
Prev Up Next
32.15. Environment Variables
Home
32.17. The Connection Service File
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
