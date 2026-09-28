# PostgreSQL: Documentation: 18: 29.13. Upgrade

PostgreSQL: Documentation: 18: 29.13. Upgrade Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) Development Versions:
19 / devel
29.13. Upgrade
Prev Up Chapter 29. Logical Replication Home Next
29.13. Upgrade #
29.13.1. Prepare for Publisher Upgrades
29.13.2. Prepare for Subscriber Upgrades
29.13.3. Upgrading Logical Replication Clusters
Migration of logical replication clusters is possible only when all the members of the old logical replication clusters are version 17.0 or later.
29.13.1. Prepare for Publisher Upgrades #
pg_upgrade attempts to migrate logical slots. This helps avoid the need for manually defining the same logical slots on the new publisher. Migration of logical slots is only supported when the old cluster is version 17.0 or later. Logical slots on clusters before version 17.0 will silently be ignored.
Before you start upgrading the publisher cluster, ensure that the subscription is temporarily disabled, by executing ALTER SUBSCRIPTION ... DISABLE. Re-enable the subscription after the upgrade.
There are some prerequisites for pg_upgrade to be able to upgrade the logical slots. If these are not met an error will be reported.
The new cluster must have wal_level as logical.
The new cluster must have max_replication_slots configured to a value greater than or equal to the number of slots present in the old cluster.
The output plugins referenced by the slots in the old cluster must be installed in the new PostgreSQL executable directory. They must also be included in the new cluster's output_plugin_libraries; see that parameter's documentation for safety information.
The old cluster has replicated all the transactions and logical decoding messages to subscribers.
All slots on the old cluster must be usable, i.e., there are no slots whose pg_replication_slots.conflicting is not true.
The new cluster must not have permanent logical slots, i.e., there must be no slots where pg_replication_slots.temporary is false.
29.13.2. Prepare for Subscriber Upgrades #
Setup the subscriber configurations in the new subscriber. pg_upgrade attempts to migrate subscription dependencies which includes the subscription's table information present in pg_subscription_rel system catalog and also the subscription's replication origin. This allows logical replication on the new subscriber to continue from where the old subscriber was up to. Migration of subscription dependencies is only supported when the old cluster is version 17.0 or later. Subscription dependencies on clusters before version 17.0 will silently be ignored.
There are some prerequisites for pg_upgrade to be able to upgrade the subscriptions. If these are not met an error will be reported.
All the subscription tables in the old subscriber should be in state i (initialize) or r (ready). This can be verified by checking pg_subscription_rel.srsubstate.
The replication origin entry corresponding to each of the subscriptions should exist in the old cluster. This can be found by checking pg_subscription and pg_replication_origin system tables.
The new cluster must have max_active_replication_origins configured to a value greater than or equal to the number of subscriptions present in the old cluster.
29.13.3. Upgrading Logical Replication Clusters #
While upgrading a subscriber, write operations can be performed in the publisher. These changes will be replicated to the subscriber once the subscriber upgrade is completed.
Note The logical replication restrictions apply to logical replication cluster upgrades also. See Section 29.8 for details.
The prerequisites of publisher upgrade apply to logical replication cluster upgrades also. See Section 29.13.1 for details.
The prerequisites of subscriber upgrade apply to logical replication cluster upgrades also. See Section 29.13.2 for details.
Warning Upgrading logical replication cluster requires multiple steps to be performed on various nodes. Because not all operations are transactional, the user is advised to take backups as described in Section 25.3.2.
The steps to upgrade the following logical replication clusters are detailed below:
Follow the steps specified in Section 29.13.3.1 to upgrade a two-node logical replication cluster.
Follow the steps specified in Section 29.13.3.2 to upgrade a cascaded logical replication cluster.
Follow the steps specified in Section 29.13.3.3 to upgrade a two-node circular logical replication cluster.
29.13.3.1. Steps to Upgrade a Two-node Logical Replication Cluster #
Let's say publisher is in node1 and subscriber is in node2. The subscriber node2 has a subscription sub1_node1_node2 which is subscribing the changes from node1.
Disable all the subscriptions on node2 that are subscribing the changes from node1 by using ALTER SUBSCRIPTION ... DISABLE, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 DISABLE;
Stop the publisher server in node1, e.g.:
pg_ctl -D /opt/PostgreSQL/data1 stop Initialize data1_upgraded instance by using the required newer version.
Upgrade the publisher node1's server to the required newer version, e.g.:
pg_upgrade --old-datadir "/opt/PostgreSQL/postgres/17/data1" --new-datadir "/opt/PostgreSQL/postgres/18/data1_upgraded" --old-bindir "/opt/PostgreSQL/postgres/17/bin" --new-bindir "/opt/PostgreSQL/postgres/18/bin" Start the upgraded publisher server in node1, e.g.:
pg_ctl -D /opt/PostgreSQL/data1_upgraded start -l logfile Stop the subscriber server in node2, e.g.:
pg_ctl -D /opt/PostgreSQL/data2 stop Initialize data2_upgraded instance by using the required newer version.
Upgrade the subscriber node2's server to the required new version, e.g.:
pg_upgrade --old-datadir "/opt/PostgreSQL/postgres/17/data2" --new-datadir "/opt/PostgreSQL/postgres/18/data2_upgraded" --old-bindir "/opt/PostgreSQL/postgres/17/bin" --new-bindir "/opt/PostgreSQL/postgres/18/bin" Start the upgraded subscriber server in node2, e.g.:
pg_ctl -D /opt/PostgreSQL/data2_upgraded start -l logfile On node2, create any tables that were created in the upgraded publisher node1 server between Step 1 and now, e.g.:
/* node2 # */ CREATE TABLE distributors (did integer PRIMARY KEY, name varchar(40));
Enable all the subscriptions on node2 that are subscribing the changes from node1 by using ALTER SUBSCRIPTION ... ENABLE, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 ENABLE;
Refresh the node2 subscription's publications using ALTER SUBSCRIPTION ... REFRESH PUBLICATION, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 REFRESH PUBLICATION;
Note In the steps described above, the publisher is upgraded first, followed by the subscriber. Alternatively, the user can use similar steps to upgrade the subscriber first, followed by the publisher.
29.13.3.2. Steps to Upgrade a Cascaded Logical Replication Cluster #
Let's say we have a cascaded logical replication setup node1->node2->node3. Here node2 is subscribing the changes from node1 and node3 is subscribing the changes from node2. The node2 has a subscription sub1_node1_node2 which is subscribing the changes from node1. The node3 has a subscription sub1_node2_node3 which is subscribing the changes from node2.
Disable all the subscriptions on node2 that are subscribing the changes from node1 by using ALTER SUBSCRIPTION ... DISABLE, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 DISABLE;
Stop the server in node1, e.g.:
pg_ctl -D /opt/PostgreSQL/data1 stop Initialize data1_upgraded instance by using the required newer version.
Upgrade the node1's server to the required newer version, e.g.:
pg_upgrade --old-datadir "/opt/PostgreSQL/postgres/17/data1" --new-datadir "/opt/PostgreSQL/postgres/18/data1_upgraded" --old-bindir "/opt/PostgreSQL/postgres/17/bin" --new-bindir "/opt/PostgreSQL/postgres/18/bin" Start the upgraded server in node1, e.g.:
pg_ctl -D /opt/PostgreSQL/data1_upgraded start -l logfile Disable all the subscriptions on node3 that are subscribing the changes from node2 by using ALTER SUBSCRIPTION ... DISABLE, e.g.:
/* node3 # */ ALTER SUBSCRIPTION sub1_node2_node3 DISABLE;
Stop the server in node2, e.g.:
pg_ctl -D /opt/PostgreSQL/data2 stop Initialize data2_upgraded instance by using the required newer version.
Upgrade the node2's server to the required new version, e.g.:
pg_upgrade --old-datadir "/opt/PostgreSQL/postgres/17/data2" --new-datadir "/opt/PostgreSQL/postgres/18/data2_upgraded" --old-bindir "/opt/PostgreSQL/postgres/17/bin" --new-bindir "/opt/PostgreSQL/postgres/18/bin" Start the upgraded server in node2, e.g.:
pg_ctl -D /opt/PostgreSQL/data2_upgraded start -l logfile On node2, create any tables that were created in the upgraded publisher node1 server between Step 1 and now, e.g.:
/* node2 # */ CREATE TABLE distributors (did integer PRIMARY KEY, name varchar(40));
Enable all the subscriptions on node2 that are subscribing the changes from node1 by using ALTER SUBSCRIPTION ... ENABLE, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 ENABLE;
Refresh the node2 subscription's publications using ALTER SUBSCRIPTION ... REFRESH PUBLICATION, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 REFRESH PUBLICATION;
Stop the server in node3, e.g.:
pg_ctl -D /opt/PostgreSQL/data3 stop Initialize data3_upgraded instance by using the required newer version.
Upgrade the node3's server to the required new version, e.g.:
pg_upgrade --old-datadir "/opt/PostgreSQL/postgres/17/data3" --new-datadir "/opt/PostgreSQL/postgres/18/data3_upgraded" --old-bindir "/opt/PostgreSQL/postgres/17/bin" --new-bindir "/opt/PostgreSQL/postgres/18/bin" Start the upgraded server in node3, e.g.:
pg_ctl -D /opt/PostgreSQL/data3_upgraded start -l logfile On node3, create any tables that were created in the upgraded node2 between Step 6 and now, e.g.:
/* node3 # */ CREATE TABLE distributors (did integer PRIMARY KEY, name varchar(40));
Enable all the subscriptions on node3 that are subscribing the changes from node2 by using ALTER SUBSCRIPTION ... ENABLE, e.g.:
/* node3 # */ ALTER SUBSCRIPTION sub1_node2_node3 ENABLE;
Refresh the node3 subscription's publications using ALTER SUBSCRIPTION ... REFRESH PUBLICATION, e.g.:
/* node3 # */ ALTER SUBSCRIPTION sub1_node2_node3 REFRESH PUBLICATION;
29.13.3.3. Steps to Upgrade a Two-node Circular Logical Replication Cluster #
Let's say we have a circular logical replication setup node1->node2 and node2->node1. Here node2 is subscribing the changes from node1 and node1 is subscribing the changes from node2. The node1 has a subscription sub1_node2_node1 which is subscribing the changes from node2. The node2 has a subscription sub1_node1_node2 which is subscribing the changes from node1.
Disable all the subscriptions on node2 that are subscribing the changes from node1 by using ALTER SUBSCRIPTION ... DISABLE, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 DISABLE;
Stop the server in node1, e.g.:
pg_ctl -D /opt/PostgreSQL/data1 stop Initialize data1_upgraded instance by using the required newer version.
Upgrade the node1's server to the required newer version, e.g.:
pg_upgrade --old-datadir "/opt/PostgreSQL/postgres/17/data1" --new-datadir "/opt/PostgreSQL/postgres/18/data1_upgraded" --old-bindir "/opt/PostgreSQL/postgres/17/bin" --new-bindir "/opt/PostgreSQL/postgres/18/bin" Start the upgraded server in node1, e.g.:
pg_ctl -D /opt/PostgreSQL/data1_upgraded start -l logfile Enable all the subscriptions on node2 that are subscribing the changes from node1 by using ALTER SUBSCRIPTION ... ENABLE, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 ENABLE;
On node1, create any tables that were created in node2 between Step 1 and now, e.g.:
/* node1 # */ CREATE TABLE distributors (did integer PRIMARY KEY, name varchar(40));
Refresh the node1 subscription's publications to copy initial table data from node2 using ALTER SUBSCRIPTION ... REFRESH PUBLICATION, e.g.:
/* node1 # */ ALTER SUBSCRIPTION sub1_node2_node1 REFRESH PUBLICATION;
Disable all the subscriptions on node1 that are subscribing the changes from node2 by using ALTER SUBSCRIPTION ... DISABLE, e.g.:
/* node1 # */ ALTER SUBSCRIPTION sub1_node2_node1 DISABLE;
Stop the server in node2, e.g.:
pg_ctl -D /opt/PostgreSQL/data2 stop Initialize data2_upgraded instance by using the required newer version.
Upgrade the node2's server to the required new version, e.g.:
pg_upgrade --old-datadir "/opt/PostgreSQL/postgres/17/data2" --new-datadir "/opt/PostgreSQL/postgres/18/data2_upgraded" --old-bindir "/opt/PostgreSQL/postgres/17/bin" --new-bindir "/opt/PostgreSQL/postgres/18/bin" Start the upgraded server in node2, e.g.:
pg_ctl -D /opt/PostgreSQL/data2_upgraded start -l logfile Enable all the subscriptions on node1 that are subscribing the changes from node2 by using ALTER SUBSCRIPTION ... ENABLE, e.g.:
/* node1 # */ ALTER SUBSCRIPTION sub1_node2_node1 ENABLE;
On node2, create any tables that were created in the upgraded node1 between Step 9 and now, e.g.:
/* node2 # */ CREATE TABLE distributors (did integer PRIMARY KEY, name varchar(40));
Refresh the node2 subscription's publications to copy initial table data from node1 using ALTER SUBSCRIPTION ... REFRESH PUBLICATION, e.g.:
/* node2 # */ ALTER SUBSCRIPTION sub1_node1_node2 REFRESH PUBLICATION;
Prev Up Next
29.12. Configuration Settings
Home
29.14. Quick Setup
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
