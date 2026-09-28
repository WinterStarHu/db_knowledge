# PostgreSQL: Documentation: 18: 18.1. The PostgreSQL User Account

PostgreSQL: Documentation: 18: 18.1. The PostgreSQL User Account Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
18.1. The PostgreSQL User Account
Prev Up Chapter 18. Server Setup and Operation Home Next
18.1. The PostgreSQL User Account #
As with any server daemon that is accessible to the outside world, it is advisable to run PostgreSQL under a separate user account. This user account should only own the data that is managed by the server, and should not be shared with other daemons. (For example, using the user nobody is a bad idea.) In particular, it is advisable that this user account not own the PostgreSQL executable files, to ensure that a compromised server process could not modify those executables.
Pre-packaged versions of PostgreSQL will typically create a suitable user account automatically during package installation.
To add a Unix user account to your system, look for a command useradd or adduser. The user name postgres is often used, and is assumed throughout this book, but you can use another name if you like.
Prev Up Next Chapter 18. Server Setup and Operation Home
18.2. Creating a Database Cluster
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
