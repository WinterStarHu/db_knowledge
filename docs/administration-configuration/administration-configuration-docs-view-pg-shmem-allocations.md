# PostgreSQL: Documentation: 18: 53.27. pg_shmem_allocations

PostgreSQL: Documentation: 18: 53.27. pg_shmem_allocations Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13
53.27. pg_shmem_allocations
Prev Up Chapter 53. System Views Home Next
53.27. pg_shmem_allocations #
The pg_shmem_allocations view shows allocations made from the server's main shared memory segment. This includes both memory allocated by PostgreSQL itself and memory allocated by extensions using the mechanisms detailed in Section 36.10.11.
Note that this view does not include memory allocated using the dynamic shared memory infrastructure.
Table 53.27. pg_shmem_allocations Columns Column Type Description name text The name of the shared memory allocation. NULL for unused memory and  for anonymous allocations.
off int8 The offset at which the allocation starts. NULL for anonymous allocations, since details related to them are not known.
size int8 Size of the allocation in bytes allocated_size int8 Size of the allocation in bytes including padding. For anonymous allocations, no information about padding is available, so the size and allocated_size columns will always be equal. Padding is not meaningful for free memory, so the columns will be equal in that case also.
Anonymous allocations are allocations that have been made with ShmemAlloc() directly, rather than via ShmemInitStruct() or ShmemInitHash().
By default, the pg_shmem_allocations view can be read only by superusers or roles with privileges of the pg_read_all_stats role.
Prev Up Next
53.26. pg_shadow
Home
53.28. pg_shmem_allocations_numa
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
