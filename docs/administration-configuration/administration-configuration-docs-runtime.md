# PostgreSQL: Documentation: 18: Chapter 18. Server Setup and Operation

PostgreSQL: Documentation: 18: Chapter 18. Server Setup and Operation Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 18. Server Setup and Operation Prev Up Part III. Server Administration Home Next Chapter 18. Server Setup and Operation Table of Contents
18.1. The PostgreSQL User Account
18.2. Creating a Database Cluster
18.2.1. Use of Secondary File Systems
18.2.2. File Systems
18.3. Starting the Database Server
18.3.1. Server Start-up Failures
18.3.2. Client Connection Problems
18.4. Managing Kernel Resources
18.4.1. Shared Memory and Semaphores
18.4.2. systemd RemoveIPC
18.4.3. Resource Limits
18.4.4. Linux Memory Overcommit
18.4.5. Linux Huge Pages
18.5. Shutting Down the Server
18.6. Upgrading a PostgreSQL Cluster
18.6.1. Upgrading Data via pg_dumpall
18.6.2. Upgrading Data via pg_upgrade
18.6.3. Upgrading Data via Replication
18.7. Preventing Server Spoofing
18.8. Encryption Options
18.9. Secure TCP/IP Connections with SSL
18.9.1. Basic Setup
18.9.2. OpenSSL Configuration
18.9.3. Using Client Certificates
18.9.4. SSL Server File Usage
18.9.5. Creating Certificates
18.10. Secure TCP/IP Connections with GSSAPI Encryption
18.10.1. Basic Setup
18.11. Secure TCP/IP Connections with SSH Tunnels
18.12. Registering Event Log on Windows
This chapter discusses how to set up and run the database server, and its interactions with the operating system.
The directions in this chapter assume that you are working with plain PostgreSQL without any additional infrastructure, for example a copy that you built from source according to the directions in the preceding chapters. If you are working with a pre-packaged or vendor-supplied version of PostgreSQL, it is likely that the packager has made special provisions for installing and starting the database server according to your system's conventions. Consult the package-level documentation for details.
Prev Up Next
17.7. Platform-Specific Notes
Home
18.1. The PostgreSQL User Account
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
