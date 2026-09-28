# PostgreSQL: Documentation: 18: 29.11. Security

PostgreSQL: Documentation: 18: 29.11. Security Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
29.11. Security
Prev Up Chapter 29. Logical Replication Home Next
29.11. Security #
The role used for the replication connection must have the REPLICATION attribute (or be a superuser). If the role lacks SUPERUSER and BYPASSRLS, publisher row security policies can execute. If the role does not trust all table owners, include options=-crow_security=off in the connection string; if a table owner then adds a row security policy, that setting will cause replication to halt rather than execute the policy. Access for the role must be configured in pg_hba.conf and it must have the LOGIN attribute.
The name of the output plugin used by the replication connection must be included in the server's output_plugin_libraries. (For subscriptions, the plugin name that is used is pgoutput.) Superusers may modify the trusted list per-connection, by including options=-coutput_plugin_libraries=... in the connection string.
In order to be able to copy the initial table data, the role used for the replication connection must have the SELECT privilege on a published table (or be a superuser).
To create a publication, the user must have the CREATE privilege in the database.
To add tables to a publication, the user must have ownership rights on the table. To add all tables in schema to a publication, the user must be a superuser. To create a publication that publishes all tables or all tables in schema automatically, the user must be a superuser.
There are currently no privileges on publications. Any subscription (that is able to connect) can access any publication. Thus, if you intend to hide some information from particular subscribers, such as by using row filters or column lists, or by not adding the whole table to the publication, be aware that other publications in the same database could expose the same information. Publication privileges might be added to PostgreSQL in the future to allow for finer-grained access control.
To create a subscription, the user must have the privileges of the pg_create_subscription role, as well as CREATE privileges on the database.
The subscription apply process will, at a session level, run with the privileges of the subscription owner. However, when performing an insert, update, delete, or truncate operation on a particular table, it will switch roles to the table owner and perform the operation with the table owner's privileges. This means that the subscription owner needs to be able to SET ROLE to each role that owns a replicated table.
If the subscription has been configured with run_as_owner = true, then no user switching will occur. Instead, all operations will be performed with the permissions of the subscription owner. In this case, the subscription owner only needs privileges to SELECT, INSERT, UPDATE, and DELETE from the target table, and does not need privileges to SET ROLE to the table owner. However, this also means that any user who owns a table into which replication is happening can execute arbitrary code with the privileges of the subscription owner. For example, they could do this by simply attaching a trigger to one of the tables which they own. Because it is usually undesirable to allow one role to freely assume the privileges of another, this option should be avoided unless user security within the database is of no concern.
On the publisher, privileges are only checked once at the start of a replication connection and are not re-checked as each change record is read.
On the subscriber, the subscription owner's privileges are re-checked for each transaction when applied. If a worker is in the process of applying a transaction when the ownership of the subscription is changed by a concurrent transaction, the application of the current transaction will continue under the old owner's privileges.
Prev Up Next
29.10. Monitoring
Home
29.12. Configuration Settings
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
