# PostgreSQL: Documentation: 18: 53.5. pg_backend_memory_contexts

PostgreSQL: Documentation: 18: 53.5. pg_backend_memory_contexts Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel
53.5. pg_backend_memory_contexts
Prev Up Chapter 53. System Views Home Next
53.5. pg_backend_memory_contexts #
The view pg_backend_memory_contexts displays all the memory contexts of the server process attached to the current session.
pg_backend_memory_contexts contains one row for each memory context.
Table 53.5. pg_backend_memory_contexts Columns Column Type Description name text Name of the memory context ident text Identification information of the memory context. This field is truncated at 1024 bytes type text Type of the memory context level int4 The 1-based level of the context in the memory context hierarchy. The level of a context also shows the position of that context in the path column.
path int4[] Array of transient numerical identifiers to describe the memory context hierarchy. The first element is for TopMemoryContext, subsequent elements contain intermediate parents and the final element contains the identifier for the current context.
total_bytes int8 Total bytes allocated for this memory context total_nblocks int8 Total number of blocks allocated for this memory context free_bytes int8 Free space in bytes free_chunks int8 Total number of free chunks used_bytes int8 Used space in bytes By default, the pg_backend_memory_contexts view can be read only by superusers or roles with the privileges of the pg_read_all_stats role.
Since memory contexts are created and destroyed during the running of a query, the identifiers stored in the path column can be unstable between multiple invocations of the view in the same query. The example below demonstrates an effective usage of this column and calculates the total number of bytes used by CacheMemoryContext and all of its children:
WITH memory_contexts AS ( SELECT * FROM pg_backend_memory_contexts ) SELECT sum(c1.total_bytes) FROM memory_contexts c1, memory_contexts c2 WHERE c2.name = 'CacheMemoryContext' AND c1.path[c2.level] = c2.path[c2.level];
The Common Table Expression is used to ensure the context IDs in the path column match between both evaluations of the view.
Prev Up Next
53.4. pg_available_extension_versions
Home
53.6. pg_config
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
