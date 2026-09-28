# PostgreSQL: Documentation: 18: 29.9. Architecture

PostgreSQL: Documentation: 18: 29.9. Architecture Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
29.9. Architecture
Prev Up Chapter 29. Logical Replication Home Next
29.9. Architecture #
29.9.1. Initial Snapshot
Logical replication is built with an architecture similar to physical streaming replication (see Section 26.2.5). It is implemented by walsender and apply processes. The walsender process starts logical decoding (described in Chapter 47) of the WAL and loads the standard logical decoding output plugin (pgoutput). The plugin transforms the changes read from WAL to the logical replication protocol (see Section 54.5) and filters the data according to the publication specification. The data is then continuously transferred using the streaming replication protocol to the apply worker, which maps the data to local tables and applies the individual changes as they are received, in correct transactional order.
The apply process on the subscriber database always runs with session_replication_role set to replica. This means that, by default, triggers and rules will not fire on a subscriber. Users can optionally choose to enable triggers and rules on a table using the ALTER TABLE command and the ENABLE TRIGGER and ENABLE RULE clauses.
The logical replication apply process currently only fires row triggers, not statement triggers. The initial table synchronization, however, is implemented like a COPY command and thus fires both row and statement triggers for INSERT.
29.9.1. Initial Snapshot #
The initial data in existing subscribed tables is snapshotted and copied in parallel instances of a special kind of apply process. These special apply processes are dedicated table synchronization workers, spawned for each table to be synchronized. Each table synchronization process will create its own replication slot and copy the existing data. As soon as the copy is finished the table contents will become visible to other backends. Once existing data is copied, the worker enters synchronization mode, which ensures that the table is brought up to a synchronized state with the main apply process by streaming any changes that happened during the initial data copy using standard logical replication. During this synchronization phase, the changes are applied and committed in the same order as they happened on the publisher. Once synchronization is done, control of the replication of the table is given back to the main apply process where replication continues as normal.
Note The publication publish parameter only affects what DML operations will be replicated. The initial data synchronization does not take this parameter into account when copying the existing table data.
Note If a table synchronization worker fails during copy, the apply worker detects the failure and respawns the table synchronization worker to continue the synchronization process. This behaviour ensures that transient errors do not permanently disrupt the replication setup. See also wal_retrieve_retry_interval.
Prev Up Next
29.8. Restrictions
Home
29.10. Monitoring
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
