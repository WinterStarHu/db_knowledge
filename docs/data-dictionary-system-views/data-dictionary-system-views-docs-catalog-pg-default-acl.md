# PostgreSQL: Documentation: 18: 52.17. pg_default_acl

PostgreSQL: Documentation: 18: 52.17. pg_default_acl Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.17. pg_default_acl
Prev Up Chapter 52. System Catalogs Home Next
52.17. pg_default_acl #
The catalog pg_default_acl stores initial privileges to be assigned to newly created objects.
Table 52.17. pg_default_acl Columns Column Type Description oid oid Row identifier defaclrole oid (references pg_authid.oid) The OID of the role associated with this entry defaclnamespace oid (references pg_namespace.oid) The OID of the namespace associated with this entry, or zero if none defaclobjtype char Type of object this entry is for: r = relation (table, view), S = sequence, f = function, T = type, n = schema, L = large object defaclacl aclitem[] Access privileges that this type of object should have on creation A pg_default_acl entry shows the initial privileges to be assigned to an object belonging to the indicated user. There are currently two types of entry: “global” entries with defaclnamespace = zero, and “per-schema” entries that reference a particular schema. If a global entry is present then it overrides the normal hard-wired default privileges for the object type. A per-schema entry, if present, represents privileges to be added to the global or hard-wired default privileges.
Note that when an ACL entry in another catalog is null, it is taken to represent the hard-wired default privileges for its object, not whatever might be in pg_default_acl at the moment. pg_default_acl is only consulted during object creation.
Prev Up Next
52.16. pg_db_role_setting
Home
52.18. pg_depend
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
