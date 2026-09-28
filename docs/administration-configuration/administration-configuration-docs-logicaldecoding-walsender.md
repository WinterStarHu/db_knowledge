# PostgreSQL: Documentation: 18: 47.3. Streaming Replication Protocol Interface

PostgreSQL: Documentation: 18: 47.3. Streaming Replication Protocol Interface Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
47.3. Streaming Replication Protocol Interface
Prev Up Chapter 47. Logical Decoding Home Next
47.3. Streaming Replication Protocol Interface #
The commands CREATE_REPLICATION_SLOT slot_name LOGICAL output_plugin DROP_REPLICATION_SLOT slot_name [ WAIT ] START_REPLICATION SLOT slot_name LOGICAL ...
are used to create, drop, and stream changes from a replication slot, respectively. These commands are only available over a replication connection; they cannot be used via SQL. See Section 54.4 for details on these commands.
The command pg_recvlogical can be used to control logical decoding over a streaming replication connection. (It uses these commands internally.) Prev Up Next
47.2. Logical Decoding Concepts
Home
47.4. Logical Decoding SQL Interface
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
