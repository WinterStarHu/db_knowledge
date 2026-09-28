# PostgreSQL: Documentation: 18: 47.5. System Catalogs Related to Logical Decoding

PostgreSQL: Documentation: 18: 47.5. System Catalogs Related to Logical Decoding Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
47.5. System Catalogs Related to Logical Decoding
Prev Up Chapter 47. Logical Decoding Home Next
47.5. System Catalogs Related to Logical Decoding #
The pg_replication_slots view and the pg_stat_replication view provide information about the current state of replication slots and streaming replication connections respectively. These views apply to both physical and logical replication. The pg_stat_replication_slots view provides statistics information about the logical replication slots.
Prev Up Next
47.4. Logical Decoding SQL Interface
Home
47.6. Logical Decoding Output Plugins
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
