# PostgreSQL: Documentation: 18: 53.15. pg_policies

PostgreSQL: Documentation: 18: 53.15. pg_policies Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
53.15. pg_policies
Prev Up Chapter 53. System Views Home Next
53.15. pg_policies #
The view pg_policies provides access to useful information about each row-level security policy in the database.
Table 53.15. pg_policies Columns Column Type Description schemaname name (references pg_namespace.nspname) Name of schema containing table policy is on tablename name (references pg_class.relname) Name of table policy is on policyname name (references pg_policy.polname) Name of policy permissive text Is the policy permissive or restrictive?
roles name[] The roles to which this policy applies cmd text The command type to which the policy is applied qual text The expression added to the security barrier qualifications for queries that this policy applies to with_check text The expression added to the WITH CHECK qualifications for queries that attempt to add rows to this table Prev Up Next
53.14. pg_matviews
Home
53.16. pg_prepared_statements
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
