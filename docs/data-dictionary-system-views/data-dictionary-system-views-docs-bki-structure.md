# PostgreSQL: Documentation: 18: 68.5. Structure of the Bootstrap BKI File

PostgreSQL: Documentation: 18: 68.5. Structure of the Bootstrap BKI File Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
68.5. Structure of the Bootstrap BKI File
Prev Up Chapter 68. System Catalog Declarations and Initial Contents Home Next
68.5. Structure of the Bootstrap BKI File #
The open command cannot be used until the tables it uses exist and have entries for the table that is to be opened. (These minimum tables are pg_class, pg_attribute, pg_proc, and pg_type.) To allow those tables themselves to be filled, create with the bootstrap option implicitly opens the created table for data insertion.
Also, the declare index and declare toast commands cannot be used until the system catalogs they need have been created and filled in.
Thus, the structure of the postgres.bki file has to be:
create bootstrap one of the critical tables insert data describing at least the critical tables close Repeat for the other critical tables.
create (without bootstrap) a noncritical table open insert desired data close Repeat for the other noncritical tables.
Define indexes and toast tables.
build indices There are doubtless other, undocumented ordering dependencies.
Prev Up Next
68.4. BKI Commands
Home
68.6. BKI Example
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
