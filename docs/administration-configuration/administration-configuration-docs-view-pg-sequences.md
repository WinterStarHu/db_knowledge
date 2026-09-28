# PostgreSQL: Documentation: 18: 53.24. pg_sequences

PostgreSQL: Documentation: 18: 53.24. pg_sequences Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
53.24. pg_sequences
Prev Up Chapter 53. System Views Home Next
53.24. pg_sequences #
The view pg_sequences provides access to useful information about each sequence in the database.
Table 53.24. pg_sequences Columns Column Type Description schemaname name (references pg_namespace.nspname) Name of schema containing sequence sequencename name (references pg_class.relname) Name of sequence sequenceowner name (references pg_authid.rolname) Name of sequence's owner data_type regtype (references pg_type.oid) Data type of the sequence start_value int8 Start value of the sequence min_value int8 Minimum value of the sequence max_value int8 Maximum value of the sequence increment_by int8 Increment value of the sequence cycle bool Whether the sequence cycles cache_size int8 Cache size of the sequence last_value int8 The last sequence value written to disk. If caching is used, this value can be greater than the last value handed out from the sequence.
The last_value column will read as null if any of the following are true:
The sequence has not been read from yet.
The current user does not have USAGE or SELECT privilege on the sequence.
The sequence is unlogged and the server is a standby.
Prev Up Next
53.23. pg_seclabels
Home
53.25. pg_settings
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
