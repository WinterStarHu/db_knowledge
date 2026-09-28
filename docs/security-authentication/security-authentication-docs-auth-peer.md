# PostgreSQL: Documentation: 18: 20.9. Peer Authentication

PostgreSQL: Documentation: 18: 20.9. Peer Authentication Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
20.9. Peer Authentication
Prev Up Chapter 20. Client Authentication Home Next
20.9. Peer Authentication #
The peer authentication method works by obtaining the client's operating system user name from the kernel and using it as the allowed database user name (with optional user name mapping). This method is only supported on local connections.
The following configuration options are supported for peer:
map Allows for mapping between system and database user names. See Section 20.2 for details.
Peer authentication is only available on operating systems providing the getpeereid() function, the SO_PEERCRED socket parameter, or similar mechanisms. Currently that includes Linux, most flavors of BSD including macOS, and Solaris.
Prev Up Next
20.8. Ident Authentication
Home
20.10. LDAP Authentication
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
