# PostgreSQL: Documentation: 18: 28.2. Data Checksums

PostgreSQL: Documentation: 18: 28.2. Data Checksums Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel
28.2. Data Checksums
Prev Up Chapter 28. Reliability and the Write-Ahead Log Home Next
28.2. Data Checksums #
28.2.1. Off-line Enabling of Checksums
By default, data pages are protected by checksums, but this can optionally be disabled for a cluster. When enabled, each data page includes a checksum that is updated when the page is written and verified each time the page is read. Only data pages are protected by checksums; internal data structures and temporary files are not.
Checksums can be disabled when the cluster is initialized using initdb. They can also be enabled or disabled at a later time as an offline operation. Data checksums are enabled or disabled at the full cluster level, and cannot be specified individually for databases or tables.
The current state of checksums in the cluster can be verified by viewing the value of the read-only configuration variable data_checksums by issuing the command SHOW data_checksums.
When attempting to recover from page corruptions, it may be necessary to bypass the checksum protection. To do this, temporarily set the configuration parameter ignore_checksum_failure.
28.2.1. Off-line Enabling of Checksums #
The pg_checksums application can be used to enable or disable data checksums, as well as verify checksums, on an offline cluster.
Prev Up Next
28.1. Reliability
Home
28.3. Write-Ahead Logging (WAL)
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
