# PostgreSQL: Documentation: 18: 53.3. pg_available_extensions

PostgreSQL: Documentation: 18: 53.3. pg_available_extensions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.3. pg_available_extensions
Prev Up Chapter 53. System Views Home Next
53.3. pg_available_extensions #
The pg_available_extensions view lists the extensions that are available for installation. See also the pg_extension catalog, which shows the extensions currently installed.
Table 53.3. pg_available_extensions Columns Column Type Description name name Extension name default_version text Name of default version, or NULL if none is specified installed_version text Currently installed version of the extension, or NULL if not installed comment text Comment string from the extension's control file The pg_available_extensions view is read-only.
Prev Up Next
53.2. pg_aios
Home
53.4. pg_available_extension_versions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
