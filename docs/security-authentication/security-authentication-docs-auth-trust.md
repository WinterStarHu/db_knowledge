# PostgreSQL: Documentation: 18: 20.4. Trust Authentication

PostgreSQL: Documentation: 18: 20.4. Trust Authentication Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
20.4. Trust Authentication
Prev Up Chapter 20. Client Authentication Home Next
20.4. Trust Authentication #
When trust authentication is specified, PostgreSQL assumes that anyone who can connect to the server is authorized to access the database with whatever database user name they specify (even superuser names). Of course, restrictions made in the database and user columns still apply. This method should only be used when there is adequate operating-system-level protection on connections to the server.
trust authentication is appropriate and very convenient for local connections on a single-user workstation. It is usually not appropriate by itself on a multiuser machine. However, you might be able to use trust even on a multiuser machine, if you restrict access to the server's Unix-domain socket file using file-system permissions. To do this, set the unix_socket_permissions (and possibly unix_socket_group) configuration parameters as described in Section 19.3. Or you could set the unix_socket_directories configuration parameter to place the socket file in a suitably restricted directory.
Setting file-system permissions only helps for Unix-socket connections. Local TCP/IP connections are not restricted by file-system permissions. Therefore, if you want to use file-system permissions for local security, remove the host ... 127.0.0.1 ... line from pg_hba.conf, or change it to a non-trust authentication method.
trust authentication is only suitable for TCP/IP connections if you trust every user on every machine that is allowed to connect to the server by the pg_hba.conf lines that specify trust. It is seldom reasonable to use trust for any TCP/IP connections other than those from localhost (127.0.0.1).
Prev Up Next
20.3. Authentication Methods
Home
20.5. Password Authentication
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
