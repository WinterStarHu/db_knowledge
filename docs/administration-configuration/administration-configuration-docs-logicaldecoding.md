# PostgreSQL: Documentation: 18: Chapter 47. Logical Decoding

PostgreSQL: Documentation: 18: Chapter 47. Logical Decoding Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
Chapter 47. Logical Decoding Prev Up Part V. Server Programming Home Next Chapter 47. Logical Decoding Table of Contents
47.1. Logical Decoding Examples
47.2. Logical Decoding Concepts
47.2.1. Logical Decoding
47.2.2. Replication Slots
47.2.3. Replication Slot Synchronization
47.2.4. Output Plugins
47.2.5. Exported Snapshots
47.3. Streaming Replication Protocol Interface
47.4. Logical Decoding SQL Interface
47.5. System Catalogs Related to Logical Decoding
47.6. Logical Decoding Output Plugins
47.6.1. Initialization Function
47.6.2. Capabilities
47.6.3. Output Modes
47.6.4. Output Plugin Callbacks
47.6.5. Functions for Producing Output
47.7. Logical Decoding Output Writers
47.8. Synchronous Replication Support for Logical Decoding
47.8.1. Overview
47.8.2. Caveats
47.9. Streaming of Large Transactions for Logical Decoding
47.10. Two-phase Commit Support for Logical Decoding
PostgreSQL provides infrastructure to stream the modifications performed via SQL to external consumers. This functionality can be used for a variety of purposes, including replication solutions and auditing.
Changes are sent out in streams identified by logical replication slots.
The format in which those changes are streamed is determined by the output plugin used. An example plugin is provided in the PostgreSQL distribution. Additional plugins can be written to extend the choice of available formats without modifying any core code. Every output plugin has access to each individual new row produced by INSERT and the new row version created by UPDATE. Availability of old row versions for UPDATE and DELETE depends on the configured replica identity (see REPLICA IDENTITY).
Changes can be consumed either using the streaming replication protocol (see Section 54.4 and Section 47.3), or by calling functions via SQL (see Section 47.4). It is also possible to write additional methods of consuming the output of a replication slot without modifying core code (see Section 47.7).
Prev Up Next Chapter 46. Background Worker Processes Home
47.1. Logical Decoding Examples
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
