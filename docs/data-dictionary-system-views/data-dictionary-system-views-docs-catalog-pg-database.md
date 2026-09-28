# PostgreSQL: Documentation: 18: 52.15. pg_database

PostgreSQL: Documentation: 18: 52.15. pg_database Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
52.15. pg_database
Prev Up Chapter 52. System Catalogs Home Next
52.15. pg_database #
The catalog pg_database stores information about the available databases. Databases are created with the CREATE DATABASE command. Consult Chapter 22 for details about the meaning of some of the parameters.
Unlike most system catalogs, pg_database is shared across all databases of a cluster: there is only one copy of pg_database per cluster, not one per database.
Table 52.15. pg_database Columns Column Type Description oid oid Row identifier datname name Database name datdba oid (references pg_authid.oid) Owner of the database, usually the user who created it encoding int4 Character encoding for this database (pg_encoding_to_char() can translate this number to the encoding name) datlocprovider char Locale provider for this database: b = builtin, c = libc, i = icu datistemplate bool If true, then this database can be cloned by any user with CREATEDB privileges; if false, then only superusers or the owner of the database can clone it.
datallowconn bool If false then no one can connect to this database. This is used to protect the template0 database from being altered.
dathasloginevt bool Indicates that there are login event triggers defined for this database. This flag is used to avoid extra lookups on the pg_event_trigger table during each backend startup. This flag is used internally by PostgreSQL and should not be manually altered or read for monitoring purposes.
datconnlimit int4 Sets maximum number of concurrent connections that can be made to this database. -1 means no limit, -2 indicates the database is invalid.
datfrozenxid xid All transaction IDs before this one have been replaced with a permanent (“frozen”) transaction ID in this database. This is used to track whether the database needs to be vacuumed in order to prevent transaction ID wraparound or to allow pg_xact to be shrunk. It is the minimum of the per-table pg_class.relfrozenxid values.
datminmxid xid All multixact IDs before this one have been replaced with a transaction ID in this database. This is used to track whether the database needs to be vacuumed in order to prevent multixact ID wraparound or to allow pg_multixact to be shrunk. It is the minimum of the per-table pg_class.relminmxid values.
dattablespace oid (references pg_tablespace.oid) The default tablespace for the database. Within this database, all tables for which pg_class.reltablespace is zero will be stored in this tablespace; in particular, all the non-shared system catalogs will be there.
datcollate text LC_COLLATE for this database datctype text LC_CTYPE for this database datlocale text Collation provider locale name for this database. If the provider is libc, datlocale is NULL; datcollate and datctype are used instead.
daticurules text ICU collation rules for this database datcollversion text Provider-specific version of the collation. This is recorded when the database is created and then checked when it is used, to detect changes in the collation definition that could lead to data corruption.
datacl aclitem[] Access privileges; see Section 5.8 for details Prev Up Next
52.14. pg_conversion
Home
52.16. pg_db_role_setting
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
