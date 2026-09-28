# PostgreSQL: Documentation: 18: 29.10. Monitoring

PostgreSQL: Documentation: 18: 29.10. Monitoring Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
29.10. Monitoring
Prev Up Chapter 29. Logical Replication Home Next
29.10. Monitoring #
Because logical replication is based on a similar architecture as physical streaming replication, the monitoring on a publication node is similar to monitoring of a physical replication primary (see Section 26.2.5.2).
The monitoring information about subscription is visible in pg_stat_subscription. This view contains one row for every subscription worker. A subscription can have zero or more active subscription workers depending on its state.
Normally, there is a single apply process running for an enabled subscription. A disabled subscription or a crashed subscription will have zero rows in this view. If the initial data synchronization of any table is in progress, there will be additional workers for the tables being synchronized. Moreover, if the streaming transaction is applied in parallel, there may be additional parallel apply workers.
Prev Up Next
29.9. Architecture
Home
29.11. Security
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
