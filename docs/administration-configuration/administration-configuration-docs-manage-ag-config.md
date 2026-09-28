# PostgreSQL: Documentation: 18: 22.4. Database Configuration

PostgreSQL: Documentation: 18: 22.4. Database Configuration Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
22.4. Database Configuration
Prev Up Chapter 22. Managing Databases Home Next
22.4. Database Configuration #
Recall from Chapter 19 that the PostgreSQL server provides a large number of run-time configuration variables. You can set database-specific default values for many of these settings.
For example, if for some reason you want to disable the GEQO optimizer for a given database, you'd ordinarily have to either disable it for all databases or make sure that every connecting client is careful to issue SET geqo TO off. To make this setting the default within a particular database, you can execute the command:
ALTER DATABASE mydb SET geqo TO off;
This will save the setting (but not set it immediately). In subsequent connections to this database it will appear as though SET geqo TO off; had been executed just before the session started. Note that users can still alter this setting during their sessions; it will only be the default. To undo any such setting, use ALTER DATABASE dbname RESET varname.
Prev Up Next
22.3. Template Databases
Home
22.5. Destroying a Database
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
