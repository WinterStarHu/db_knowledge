# PostgreSQL: Documentation: 18: Part VIII. Appendixes

PostgreSQL: Documentation: 18: Part VIII. Appendixes Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Part VIII. Appendixes Prev Up PostgreSQL 18.6 Documentation Home Next Part VIII. Appendixes Table of Contents A. PostgreSQL Error Codes B. Date/Time Support B.1. Date/Time Input Interpretation B.2. Handling of Invalid or Ambiguous Timestamps B.3. Date/Time Key Words B.4. Date/Time Configuration Files B.5. POSIX Time Zone Specifications B.6. History of Units B.7. Julian Dates C. SQL Key Words D. SQL Conformance D.1. Supported Features D.2. Unsupported Features D.3. XML Limits and Conformance to SQL/XML E. Release Notes E.1. Release 18.6 E.2. Release 18.4 E.3. Release 18.3 E.4. Release 18.2 E.5. Release 18.1 E.6. Release 18 E.7. Prior Releases F. Additional Supplied Modules and Extensions F.1. amcheck — tools to verify table and index consistency F.2. auth_delay — pause on authentication failure F.3. auto_explain — log execution plans of slow queries F.4. basebackup_to_shell — example "shell" pg_basebackup module F.5. basic_archive — an example WAL archive module F.6. bloom — bloom filter index access method F.7. btree_gin — GIN operator classes with B-tree behavior F.8. btree_gist — GiST operator classes with B-tree behavior F.9. citext — a case-insensitive character string type F.10. cube — a multi-dimensional cube data type F.11. dblink — connect to other PostgreSQL databases F.12. dict_int — example full-text search dictionary for integers F.13. dict_xsyn — example synonym full-text search dictionary F.14. earthdistance — calculate great-circle distances F.15. file_fdw — access data files in the server's file system F.16. fuzzystrmatch — determine string similarities and distance F.17. hstore — hstore key/value datatype F.18. intagg — integer aggregator and enumerator F.19. intarray — manipulate arrays of integers F.20. isn — data types for international standard numbers (ISBN, EAN, UPC, etc.) F.21. lo — manage large objects F.22. ltree — hierarchical tree-like data type F.23. pageinspect — low-level inspection of database pages F.24. passwordcheck — verify password strength F.25. pg_buffercache — inspect PostgreSQL buffer cache state F.26. pgcrypto — cryptographic functions F.27. pg_freespacemap — examine the free space map F.28. pg_logicalinspect — logical decoding components inspection F.29. pg_overexplain — allow EXPLAIN to dump even more details F.30. pg_prewarm — preload relation data into buffer caches F.31. pgrowlocks — show a table's row locking information F.32. pg_stat_statements — track statistics of SQL planning and execution F.33. pgstattuple — obtain tuple-level statistics F.34. pg_surgery — perform low-level surgery on relation data F.35. pg_trgm — support for similarity of text using trigram matching F.36. pg_visibility — visibility map information and utilities F.37. pg_walinspect — low-level WAL inspection F.38. postgres_fdw — access data stored in external PostgreSQL servers F.39. seg — a datatype for line segments or floating point intervals F.40. sepgsql — SELinux-, label-based mandatory access control (MAC) security module F.41. spi — Server Programming Interface features/examples F.42. sslinfo — obtain client SSL information F.43. tablefunc — functions that return tables (crosstab and others) F.44. tcn — a trigger function to notify listeners of changes to table content F.45. test_decoding — SQL-based test/example module for WAL logical decoding F.46. tsm_system_rows — the SYSTEM_ROWS sampling method for TABLESAMPLE F.47. tsm_system_time — the SYSTEM_TIME sampling method for TABLESAMPLE F.48. unaccent — a text search dictionary which removes diacritics F.49. uuid-ossp — a UUID generator F.50. xml2 — XPath querying and XSLT functionality G. Additional Supplied Programs G.1. Client Applications G.2. Server Applications H. External Projects H.1. Client Interfaces H.2. Administration Tools H.3. Procedural Languages H.4. Extensions I. The Source Code Repository I.1. Getting the Source via Git J. Documentation J.1. DocBook J.2. Tool Sets J.3. Building the Documentation with Make J.4. Building the Documentation with Meson J.5. Documentation Authoring J.6. Style Guide K. PostgreSQL Limits L. Acronyms M. Glossary N. Color Support N.1. When Color is Used N.2. Configuring the Colors O. Obsolete or Renamed Features O.1. recovery.conf file merged into postgresql.conf O.2. Default Roles Renamed to Predefined Roles O.3. pg_xlogdump renamed to pg_waldump O.4. pg_resetxlog renamed to pg_resetwal O.5. pg_receivexlog renamed to pg_receivewal Prev Up Next
70.3. Backup Manifest WAL Range Object
Home Appendix A. PostgreSQL Error Codes Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
