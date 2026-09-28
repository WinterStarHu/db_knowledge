# PostgreSQL: Documentation: 18: 52.12. pg_collation

PostgreSQL: Documentation: 18: 52.12. pg_collation Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.12. pg_collation
Prev Up Chapter 52. System Catalogs Home Next
52.12. pg_collation #
The catalog pg_collation describes the available collations, which are essentially mappings from an SQL name to operating system locale categories. See Section 23.2 for more information.
Table 52.12. pg_collation Columns Column Type Description oid oid Row identifier collname name Collation name (unique per namespace and encoding) collnamespace oid (references pg_namespace.oid) The OID of the namespace that contains this collation collowner oid (references pg_authid.oid) Owner of the collation collprovider char Provider of the collation: d = database default, b = builtin, c = libc, i = icu collisdeterministic bool Is the collation deterministic?
collencoding int4 Encoding in which the collation is applicable, or -1 if it works for any encoding collcollate text LC_COLLATE for this collation object. If the provider is not libc, collcollate is NULL and colllocale is used instead.
collctype text LC_CTYPE for this collation object. If the provider is not libc, collctype is NULL and colllocale is used instead.
colllocale text Collation provider locale name for this collation object. If the provider is libc, colllocale is NULL; collcollate and collctype are used instead.
collicurules text ICU collation rules for this collation object collversion text Provider-specific version of the collation. This is recorded when the collation is created and then checked when it is used, to detect changes in the collation definition that could lead to data corruption.
Note that the unique key on this catalog is (collname, collencoding, collnamespace) not just (collname, collnamespace). PostgreSQL generally ignores all collations that do not have collencoding equal to either the current database's encoding or -1, and creation of new entries with the same name as an entry with collencoding = -1 is forbidden. Therefore it is sufficient to use a qualified SQL name (schema.name) to identify a collation, even though this is not unique according to the catalog definition. The reason for defining the catalog this way is that initdb fills it in at cluster initialization time with entries for all locales available on the system, so it must be able to hold entries for all encodings that might ever be used in the cluster.
In the template0 database, it could be useful to create collations whose encoding does not match the database encoding, since they could match the encodings of databases later cloned from template0. This would currently have to be done manually.
Prev Up Next
52.11. pg_class
Home
52.13. pg_constraint
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
