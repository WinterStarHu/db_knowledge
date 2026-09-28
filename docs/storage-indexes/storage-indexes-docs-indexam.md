# PostgreSQL: Documentation: 18: Chapter 63. Index Access Method Interface Definition

PostgreSQL: Documentation: 18: Chapter 63. Index Access Method Interface Definition Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 63. Index Access Method Interface Definition Prev Up Part VII. Internals Home Next Chapter 63. Index Access Method Interface Definition Table of Contents
63.1. Basic API Structure for Indexes
63.2. Index Access Method Functions
63.3. Index Scanning
63.4. Index Locking Considerations
63.5. Index Uniqueness Checks
63.6. Index Cost Estimation Functions
This chapter defines the interface between the core PostgreSQL system and index access methods, which manage individual index types. The core system knows nothing about indexes beyond what is specified here, so it is possible to develop entirely new index types by writing add-on code.
All indexes in PostgreSQL are what are known technically as secondary indexes; that is, the index is physically separate from the table file that it describes. Each index is stored as its own physical relation and so is described by an entry in the pg_class catalog. The contents of an index are entirely under the control of its index access method. In practice, all index access methods divide indexes into standard-size pages so that they can use the regular storage manager and buffer manager to access the index contents. (All the existing index access methods furthermore use the standard page layout described in Section 66.6, and most use the same format for index tuple headers; but these decisions are not forced on an access method.) An index is effectively a mapping from some data key values to tuple identifiers, or TIDs, of row versions (tuples) in the index's parent table. A TID consists of a block number and an item number within that block (see Section 66.6). This is sufficient information to fetch a particular row version from the table. Indexes are not directly aware that under MVCC, there might be multiple extant versions of the same logical row; to an index, each tuple is an independent object that needs its own index entry. Thus, an update of a row always creates all-new index entries for the row, even if the key values did not change. (HOT tuples are an exception to this statement; but indexes do not deal with those, either.) Index entries for dead tuples are reclaimed (by vacuuming) when the dead tuples themselves are reclaimed.
Prev Up Next Chapter 62. Table Access Method Interface Definition Home
63.1. Basic API Structure for Indexes
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
