# PostgreSQL: Documentation: 18: 53.28. pg_shmem_allocations_numa

PostgreSQL: Documentation: 18: 53.28. pg_shmem_allocations_numa Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) Development Versions:
19 / devel
53.28. pg_shmem_allocations_numa
Prev Up Chapter 53. System Views Home Next
53.28. pg_shmem_allocations_numa #
The pg_shmem_allocations_numa shows how shared memory allocations in the server's main shared memory segment are distributed across NUMA nodes. This includes both memory allocated by PostgreSQL itself and memory allocated by extensions using the mechanisms detailed in Section 36.10.11. This view will output multiple rows for each of the shared memory segments provided that they are spread across multiple NUMA nodes. This view should not be queried by monitoring systems as it is very slow and may end up allocating shared memory in case it was not used earlier. Current limitation for this view is that won't show anonymous shared memory allocations.
Note that this view does not include memory allocated using the dynamic shared memory infrastructure.
Warning When determining the NUMA node, the view touches all memory pages for the shared memory segment. This will force allocation of the shared memory, if it wasn't allocated already, and the memory may get allocated in a single NUMA node (depending on system configuration).
Table 53.28. pg_shmem_allocations_numa Columns Column Type Description name text The name of the shared memory allocation.
numa_node int4 ID of NUMA node size int8 Size of the allocation on this particular NUMA memory node in bytes By default, the pg_shmem_allocations_numa view can be read only by superusers or roles with privileges of the pg_read_all_stats role.
Prev Up Next
53.27. pg_shmem_allocations
Home
53.29. pg_stats
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
