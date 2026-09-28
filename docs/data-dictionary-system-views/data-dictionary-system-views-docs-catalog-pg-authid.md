# PostgreSQL: Documentation: 18: 52.8. pg_authid

PostgreSQL: Documentation: 18: 52.8. pg_authid Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.8. pg_authid
Prev Up Chapter 52. System Catalogs Home Next
52.8. pg_authid #
The catalog pg_authid contains information about database authorization identifiers (roles). A role subsumes the concepts of “users” and “groups”. A user is essentially just a role with the rolcanlogin flag set. Any role (with or without rolcanlogin) can have other roles as members; see pg_auth_members.
Since this catalog contains passwords, it must not be publicly readable. pg_roles is a publicly readable view on pg_authid that blanks out the password field.
Chapter 21 contains detailed information about user and privilege management.
Because user identities are cluster-wide, pg_authid is shared across all databases of a cluster: there is only one copy of pg_authid per cluster, not one per database.
Table 52.8. pg_authid Columns Column Type Description oid oid Row identifier rolname name Role name rolsuper bool Role has superuser privileges rolinherit bool Role automatically inherits privileges of roles it is a member of rolcreaterole bool Role can create more roles rolcreatedb bool Role can create databases rolcanlogin bool Role can log in. That is, this role can be given as the initial session authorization identifier.
rolreplication bool Role is a replication role. A replication role can initiate replication connections and create and drop replication slots.
rolbypassrls bool Role bypasses every row-level security policy, see Section 5.9 for more information.
rolconnlimit int4 For roles that can log in, this sets maximum number of concurrent connections this role can make. -1 means no limit.
rolpassword text Encrypted password; null if none. The format depends on the form of encryption used.
rolvaliduntil timestamptz Password expiry time (only used for password authentication); null if no expiration For an MD5 encrypted password, rolpassword column will begin with the string md5 followed by a 32-character hexadecimal MD5 hash. The MD5 hash will be of the user's password concatenated to their user name. For example, if user joe has password xyzzy, PostgreSQL will store the md5 hash of xyzzyjoe.
Warning Support for MD5-encrypted passwords is deprecated and will be removed in a future release of PostgreSQL. Refer to Section 20.5 for details about migrating to another password type.
If the password is encrypted with SCRAM-SHA-256, it has the format:
SCRAM-SHA-256$:$:
where salt, StoredKey and ServerKey are in Base64 encoded format. This format is the same as that specified by RFC 5803.
Prev Up Next
52.7. pg_attribute
Home
52.9. pg_auth_members
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
