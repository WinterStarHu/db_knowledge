# PostgreSQL: Documentation: 18: LOAD

PostgreSQL: Documentation: 18: LOAD Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
LOAD Prev Up SQL Commands Home Next LOAD LOAD — load a shared library file Synopsis LOAD 'filename' Description This command loads a shared library file into the PostgreSQL server's address space. If the file has been loaded already, the command does nothing. Shared library files that contain C functions are automatically loaded whenever one of their functions is called. Therefore, an explicit LOAD is usually only needed to load a library that modifies the server's behavior through “hooks” rather than providing a set of functions.
The library file name is typically given as just a bare file name, which is sought in the server's library search path (set by dynamic_library_path). Alternatively it can be given as a full path name. In either case the platform's standard shared library file name extension may be omitted. See Section 36.10.1 for more information on this topic.
Non-superusers can only apply LOAD to library files located in $libdir/plugins/ — the specified filename must begin with exactly that string. (It is the database administrator's responsibility to ensure that only “safe” libraries are installed there.) Compatibility LOAD is a PostgreSQL extension.
See Also CREATE FUNCTION Prev Up Next LISTEN Home LOCK Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
