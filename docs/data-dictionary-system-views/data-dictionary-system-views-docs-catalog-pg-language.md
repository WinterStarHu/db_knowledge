# PostgreSQL: Documentation: 18: 52.29. pg_language

PostgreSQL: Documentation: 18: 52.29. pg_language Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.29. pg_language
Prev Up Chapter 52. System Catalogs Home Next
52.29. pg_language #
The catalog pg_language registers languages in which you can write functions or stored procedures. See CREATE LANGUAGE and Chapter 40 for more information about language handlers.
Table 52.29. pg_language Columns Column Type Description oid oid Row identifier lanname name Name of the language lanowner oid (references pg_authid.oid) Owner of the language lanispl bool This is false for internal languages (such as SQL) and true for user-defined languages. Currently, pg_dump still uses this to determine which languages need to be dumped, but this might be replaced by a different mechanism in the future.
lanpltrusted bool True if this is a trusted language, which means that it is believed not to grant access to anything outside the normal SQL execution environment. Only superusers can create functions in untrusted languages.
lanplcallfoid oid (references pg_proc.oid) For noninternal languages this references the language handler, which is a special function that is responsible for executing all functions that are written in the particular language. Zero for internal languages.
laninline oid (references pg_proc.oid) This references a function that is responsible for executing “inline” anonymous code blocks (DO blocks). Zero if inline blocks are not supported.
lanvalidator oid (references pg_proc.oid) This references a language validator function that is responsible for checking the syntax and validity of new functions when they are created. Zero if no validator is provided.
lanacl aclitem[] Access privileges; see Section 5.8 for details Prev Up Next
52.28. pg_init_privs
Home
52.30. pg_largeobject
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
