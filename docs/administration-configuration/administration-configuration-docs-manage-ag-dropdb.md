# PostgreSQL: Documentation: 18: 22.5. Destroying a Database

PostgreSQL: Documentation: 18: 22.5. Destroying a Database Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
22.5. Destroying a Database
Prev Up Chapter 22. Managing Databases Home Next
22.5. Destroying a Database #
Databases are destroyed with the command DROP DATABASE:
DROP DATABASE name;
Only the owner of the database, or a superuser, can drop a database. Dropping a database removes all objects that were contained within the database. The destruction of a database cannot be undone.
You cannot execute the DROP DATABASE command while connected to the victim database. You can, however, be connected to any other database, including the template1 database. template1 would be the only option for dropping the last user database of a given cluster.
For convenience, there is also a shell program to drop databases, dropdb:
dropdb dbname (Unlike createdb, it is not the default action to drop the database with the current user name.) Prev Up Next
22.4. Database Configuration
Home
22.6. Tablespaces
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
