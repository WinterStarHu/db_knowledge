# PostgreSQL: Documentation: 18: 53.4. pg_available_extension_versions

PostgreSQL: Documentation: 18: 53.4. pg_available_extension_versions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.4. pg_available_extension_versions
Prev Up Chapter 53. System Views Home Next
53.4. pg_available_extension_versions #
The pg_available_extension_versions view lists the specific extension versions that are available for installation. See also the pg_extension catalog, which shows the extensions currently installed.
Table 53.4. pg_available_extension_versions Columns Column Type Description name name Extension name version text Version name installed bool True if this version of this extension is currently installed superuser bool True if only superusers are allowed to install this extension (but see trusted) trusted bool True if the extension can be installed by non-superusers with appropriate privileges relocatable bool True if extension can be relocated to another schema schema name Name of the schema that the extension must be installed into, or NULL if partially or fully relocatable requires name[] Names of prerequisite extensions, or NULL if none comment text Comment string from the extension's control file The pg_available_extension_versions view is read-only.
Prev Up Next
53.3. pg_available_extensions
Home
53.5. pg_backend_memory_contexts
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
