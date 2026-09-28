# PostgreSQL: Documentation: 18: 29.12. Configuration Settings

PostgreSQL: Documentation: 18: 29.12. Configuration Settings Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
29.12. Configuration Settings
Prev Up Chapter 29. Logical Replication Home Next
29.12. Configuration Settings #
29.12.1. Publishers
29.12.2. Subscribers
Logical replication requires several configuration options to be set. These options are relevant only on one side of the replication.
29.12.1. Publishers #
wal_level must be set to logical.
max_replication_slots must be set to at least the number of subscriptions expected to connect, plus some reserve for table synchronization.
Logical replication slots are also affected by idle_replication_slot_timeout.
max_wal_senders should be set to at least the same as max_replication_slots, plus the number of physical replicas that are connected at the same time.
Logical replication walsender is also affected by wal_sender_timeout.
29.12.2. Subscribers #
max_active_replication_origins must be set to at least the number of subscriptions that will be added to the subscriber, plus some reserve for table synchronization.
max_logical_replication_workers must be set to at least the number of subscriptions (for leader apply workers), plus some reserve for the table synchronization workers and parallel apply workers.
max_worker_processes may need to be adjusted to accommodate for replication workers, at least (max_logical_replication_workers + 1). Note, some extensions and parallel queries also take worker slots from max_worker_processes.
max_sync_workers_per_subscription controls the amount of parallelism of the initial data copy during the subscription initialization or when new tables are added.
max_parallel_apply_workers_per_subscription controls the amount of parallelism for streaming of in-progress transactions with subscription parameter streaming = parallel.
Logical replication workers are also affected by wal_receiver_timeout, wal_receiver_status_interval and wal_retrieve_retry_interval.
Prev Up Next
29.11. Security
Home
29.13. Upgrade
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
