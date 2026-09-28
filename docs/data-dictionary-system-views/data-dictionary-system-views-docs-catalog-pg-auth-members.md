# PostgreSQL: Documentation: 18: 52.9. pg_auth_members

PostgreSQL: Documentation: 18: 52.9. pg_auth_members Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.9. pg_auth_members
Prev Up Chapter 52. System Catalogs Home Next
52.9. pg_auth_members #
The catalog pg_auth_members shows the membership relations between roles. Any non-circular set of relationships is allowed.
Because user identities are cluster-wide, pg_auth_members is shared across all databases of a cluster: there is only one copy of pg_auth_members per cluster, not one per database.
Table 52.9. pg_auth_members Columns Column Type Description oid oid Row identifier roleid oid (references pg_authid.oid) ID of a role that has a member member oid (references pg_authid.oid) ID of a role that is a member of roleid grantor oid (references pg_authid.oid) ID of the role that granted this membership admin_option bool True if member can grant membership in roleid to others inherit_option bool True if the member automatically inherits the privileges of the granted role set_option bool True if the member can SET ROLE to the granted role Prev Up Next
52.8. pg_authid
Home
52.10. pg_cast
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
