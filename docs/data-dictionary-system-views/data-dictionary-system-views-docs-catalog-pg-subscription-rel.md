# PostgreSQL: Documentation: 18: 52.55. pg_subscription_rel

PostgreSQL: Documentation: 18: 52.55. pg_subscription_rel Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
52.55. pg_subscription_rel
Prev Up Chapter 52. System Catalogs Home Next
52.55. pg_subscription_rel #
The catalog pg_subscription_rel contains the state for each replicated relation in each subscription. This is a many-to-many mapping.
This catalog only contains tables known to the subscription after running either CREATE SUBSCRIPTION or ALTER SUBSCRIPTION ... REFRESH PUBLICATION.
Table 52.55. pg_subscription_rel Columns Column Type Description srsubid oid (references pg_subscription.oid) Reference to subscription srrelid oid (references pg_class.oid) Reference to relation srsubstate char State code: i = initialize, d = data is being copied, f = finished table copy, s = synchronized, r = ready (normal replication) srsublsn pg_lsn Remote LSN of the state change used for synchronization coordination when in s or r states, otherwise null Prev Up Next
52.54. pg_subscription
Home
52.56. pg_tablespace
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
