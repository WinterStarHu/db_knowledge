# PostgreSQL: Documentation: 18: 53.21. pg_roles

PostgreSQL: Documentation: 18: 53.21. pg_roles Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
53.21. pg_roles
Prev Up Chapter 53. System Views Home Next
53.21. pg_roles #
The view pg_roles provides access to information about database roles. This is simply a publicly readable view of pg_authid that blanks out the password field.
Table 53.21. pg_roles Columns Column Type Description rolname name Role name rolsuper bool Role has superuser privileges rolinherit bool Role automatically inherits privileges of roles it is a member of rolcreaterole bool Role can create more roles rolcreatedb bool Role can create databases rolcanlogin bool Role can log in. That is, this role can be given as the initial session authorization identifier rolreplication bool Role is a replication role. A replication role can initiate replication connections and create and drop replication slots.
rolconnlimit int4 For roles that can log in, this sets maximum number of concurrent connections this role can make. -1 means no limit.
rolpassword text Not the password (always reads as ********) rolvaliduntil timestamptz Password expiry time (only used for password authentication); null if no expiration rolbypassrls bool Role bypasses every row-level security policy, see Section 5.9 for more information.
rolconfig text[] Role-specific defaults for run-time configuration variables oid oid (references pg_authid.oid) ID of role Prev Up Next
53.20. pg_replication_slots
Home
53.22. pg_rules
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
