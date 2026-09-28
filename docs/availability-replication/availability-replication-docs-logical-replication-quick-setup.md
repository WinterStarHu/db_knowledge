# PostgreSQL: Documentation: 18: 29.14. Quick Setup

PostgreSQL: Documentation: 18: 29.14. Quick Setup Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
29.14. Quick Setup
Prev Up Chapter 29. Logical Replication Home Next
29.14. Quick Setup #
First set the configuration options in postgresql.conf:
wal_level = logical The other required settings have default values that are sufficient for a basic setup.
pg_hba.conf needs to be adjusted to allow replication (the values here depend on your actual network configuration and user you want to use for connecting):
host     all     repuser     0.0.0.0/0     scram-sha-256 Then on the publisher database:
CREATE PUBLICATION mypub FOR TABLE users, departments;
And on the subscriber database:
CREATE SUBSCRIPTION mysub CONNECTION 'dbname=foo host=bar user=repuser' PUBLICATION mypub;
The above will start the replication process, which synchronizes the initial table contents of the tables users and departments and then starts replicating incremental changes to those tables.
Prev Up Next
29.13. Upgrade
Home Chapter 30. Just-in-Time Compilation (JIT) Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
