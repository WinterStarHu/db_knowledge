# PostgreSQL: Documentation: 18: 52.38. pg_policy

PostgreSQL: Documentation: 18: 52.38. pg_policy Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
52.38. pg_policy
Prev Up Chapter 52. System Catalogs Home Next
52.38. pg_policy #
The catalog pg_policy stores row-level security policies for tables. A policy includes the kind of command that it applies to (possibly all commands), the roles that it applies to, the expression to be added as a security-barrier qualification to queries that include the table, and the expression to be added as a WITH CHECK option for queries that attempt to add new records to the table.
Table 52.38. pg_policy Columns Column Type Description oid oid Row identifier polname name The name of the policy polrelid oid (references pg_class.oid) The table to which the policy applies polcmd char The command type to which the policy is applied: r for SELECT, a for INSERT, w for UPDATE, d for DELETE, or * for all polpermissive bool Is the policy permissive or restrictive?
polroles oid[] (references pg_authid.oid) The roles to which the policy is applied; zero means PUBLIC (and normally appears alone in the array) polqual pg_node_tree The expression tree to be added to the security barrier qualifications for queries that use the table polwithcheck pg_node_tree The expression tree to be added to the WITH CHECK qualifications for queries that attempt to add rows to the table Note Policies stored in pg_policy are applied only when pg_class.relrowsecurity is set for their table.
Prev Up Next
52.37. pg_partitioned_table
Home
52.39. pg_proc
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
