# PostgreSQL: Documentation: 18: 52.54. pg_subscription

PostgreSQL: Documentation: 18: 52.54. pg_subscription Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
52.54. pg_subscription
Prev Up Chapter 52. System Catalogs Home Next
52.54. pg_subscription #
The catalog pg_subscription contains all existing logical replication subscriptions. For more information about logical replication see Chapter 29.
Unlike most system catalogs, pg_subscription is shared across all databases of a cluster: there is only one copy of pg_subscription per cluster, not one per database.
Access to the column subconninfo is revoked from normal users, because it could contain plain-text passwords.
Table 52.54. pg_subscription Columns Column Type Description oid oid Row identifier subdbid oid (references pg_database.oid) OID of the database that the subscription resides in subskiplsn pg_lsn Finish LSN of the transaction whose changes are to be skipped, if a valid LSN; otherwise 0/0.
subname name Name of the subscription subowner oid (references pg_authid.oid) Owner of the subscription subenabled bool If true, the subscription is enabled and should be replicating subbinary bool If true, the subscription will request that the publisher send data in binary format substream char Controls how to handle the streaming of in-progress transactions: f = disallow streaming of in-progress transactions, t = spill the changes of in-progress transactions to disk and apply at once after the transaction is committed on the publisher and received by the subscriber, p = apply changes directly using a parallel apply worker if available (same as t if no worker is available) subtwophasestate char State codes for two-phase mode: d = disabled, p = pending enablement, e = enabled subdisableonerr bool If true, the subscription will be disabled if one of its workers detects an error subpasswordrequired bool If true, the subscription will be required to specify a password for authentication subrunasowner bool If true, the subscription will be run with the permissions of the subscription owner subfailover bool If true, the associated replication slots (i.e. the main slot and the table synchronization slots) in the upstream database are enabled to be synchronized to the standbys subconninfo text Connection string to the upstream database subslotname name Name of the replication slot in the upstream database (also used for the local replication origin name); null represents NONE subsynccommit text The synchronous_commit setting for the subscription's workers to use subpublications text[] Array of subscribed publication names. These reference publications defined in the upstream database. For more on publications see Section 29.1.
suborigin text The origin value must be either none or any. The default is any. If none, the subscription will request the publisher to only send changes that don't have an origin. If any, the publisher sends changes regardless of their origin.
Prev Up Next
52.53. pg_statistic_ext_data
Home
52.55. pg_subscription_rel
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
