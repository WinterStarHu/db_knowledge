# PostgreSQL: Documentation: 18: Chapter 20. Client Authentication

PostgreSQL: Documentation: 18: Chapter 20. Client Authentication Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 20. Client Authentication Prev Up Part III. Server Administration Home Next Chapter 20. Client Authentication Table of Contents
20.1. The pg_hba.conf File
20.2. User Name Maps
20.3. Authentication Methods
20.4. Trust Authentication
20.5. Password Authentication
20.6. GSSAPI Authentication
20.7. SSPI Authentication
20.8. Ident Authentication
20.9. Peer Authentication
20.10. LDAP Authentication
20.11. RADIUS Authentication
20.12. Certificate Authentication
20.13. PAM Authentication
20.14. BSD Authentication
20.15. OAuth Authorization/Authentication
20.16. Authentication Problems
When a client application connects to the database server, it specifies which PostgreSQL database user name it wants to connect as, much the same way one logs into a Unix computer as a particular user. Within the SQL environment the active database user name determines access privileges to database objects — see Chapter 21 for more information. Therefore, it is essential to restrict which database users can connect.
Note As explained in Chapter 21, PostgreSQL actually does privilege management in terms of “roles”. In this chapter, we consistently use database user to mean “role with the LOGIN privilege”.
Authentication is the process by which the database server establishes the identity of the client, and by extension determines whether the client application (or the user who runs the client application) is permitted to connect with the database user name that was requested.
PostgreSQL offers a number of different client authentication methods. The method used to authenticate a particular client connection can be selected on the basis of (client) host address, database, and user.
PostgreSQL database user names are logically separate from user names of the operating system in which the server runs. If all the users of a particular server also have accounts on the server's machine, it makes sense to assign database user names that match their operating system user names. However, a server that accepts remote connections might have many database users who have no local operating system account, and in such cases there need be no connection between database user names and OS user names.
Prev Up Next
19.18. Short Options
Home
20.1. The pg_hba.conf File
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
