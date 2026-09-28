# Changes in This Release for Oracle Database SQL Language Reference

This preface contains:
- Changes in Oracle Database Release 19.28
- Changes in Oracle Database Release 19c
## Changes in Oracle Database Release 19.28
**New Features** The following features are introduced with Release 19.28.
**IF [NOT] EXISTS** `IF [NOT] EXISTS` when used with `CREATE` statements ensures that the command does not error out, if the object already exists.
The following table shows the `CREATE` statements that support `IF [NOT] EXISTS`:
Table -1 CREATE Statements that Support IF [NOT] EXISTS

| CREATE STATEMENTS |
|---|
| ANALYTICAL VIEW |
| ATTRIBUTE DIMENSION |
| CLUSTER |
| DATABASE LINK |
| DIRECTORY |
| EDITION |
| FUNCTION |
| HIERARCHY |
| INDEX |
| INDEXTYPE |
| JAVA |
| LIBRARY |
| MATERIALIZED VIEW |
| MATERIALIZED VIEW LOG |
| MATERIALIZED VIEW ZONEMAP |
| OPERATOR |
| PACKAGE |
| PACKAGE BODY |
| PROCEDURE |
| SEQUENCE |
| SYNONYM |
| TABLE |
| TABLESPACE |
| TRIGGER |
| TYPE |
| TYPE BODY |
| USER |
| VIEW |

**IF EXISTS** `IF EXISTS` when used with `ALTER` and `DROP` statements ensures that the command does not error out, if the object does not exist.
The following table shows the `DROP` and `ALTER` statements that support `IF EXISTS`:
Table -2 ALTER and DROP Statements that Support IF EXISTS

| DROP STATEMENTS | ALTER STATEMENTS |
|---|---|
| ANALYTICAL VIEW | ANALYTICAL VIEW |
| ATTRIBUTE DIMENSION | ATTRIBUTE DIMENSION |
| CLUSTER | CLUSTER |
| DATABASE LINK | DATABASE LINK |
| DIRECTORY | No |
| EDITION | EDITION |
| EDITION | EDITION |
| HIERARCHY | HIERARCHY |
| INDEX | INDEX |
| INDEXTYPE | INDEXTYPE |
| JAVA | JAVA |
| LIBRARY | LIBRARY |
| MATERIALIZED VIEW | MATERIALIZED VIEW |
| MATERIALIZED VIEW LOG | MATERIALIZED VIEW LOG |
| MATERIALIZED VIEW ZONEMAP | MATERIALIZED VIEW ZONEMAP |
| OPERATOR | OPERATOR |
| PACKAGE | PACKAGE |
| PROCEDURE | PROCEDURE |
| SEQUENCE | SEQUENCE |
| SYNONYM | SYNONYM |
| TABLE | TABLE |
| TABLESPACE | TABLESPACE |
| TRIGGER | TRIGGER |
| TYPE | TYPE |
| No | TYPE BODY |
| USER | USER |
| VIEW | VIEW |

**Schema Annotations** Annotations provide a mechanism to store application metadata centrally in the database, so that they can be shared across applications, modules and microservices.
To create annotations you must specify the *annotations_clause* in the `CREATE` statement.
The following statements support the *annotations_clause*:
````
- CREATE INDEX, ALTER INDEX
````
- CREATE MATERIALIZED VIEW, ALTER MATERIALIZED VIEW
````
- CREATE TABLE, ALTER TABLE
````
- CREATE VIEW, ALTER VIEW
See annotations_clause.
## Changes in Oracle Database Release 19c
The following are changes in *Oracle Database SQL Language Reference* for Oracle Database 19c.
### New Features
The following features are new in Release 19c:
**Mapping Oracle Database Schemas and Roles to a Microsoft Azure AD User** You can exclusively map an Oracle Database schema to a Microsoft Azure AD user using the expanded `GLOBALLY` clause of `CREATE USER`.
You can map a shared Oracle schema or an Oracle Database Global Role to an Azure AD Application Role using the expanded `GLOBALLY` clause of `CREATE ROLE`.
**SQL Macros** You can create SQL macros (SQM) to factor out common SQL expressions and statements into reusable, parameterized constructs that can be used in other SQL statements.
Starting with Oracle Database release 19c, version 19.7, SQL table macros are supported. SQL table macros are expressions, typically used in a `FROM` clause, to act as a sort of polymorphic (parameterized) views.
SQL table macros increase developer productivity, simplify collaborative development, and improve code quality.
**Finer Granularity Supplemental Logging** Fine-grained supplemental logging provides a way for partial database replication users to disable supplemental logging for uninteresting tables even when supplemental logging is enabled at the database or schema level.
Use this feature in cases where where only some of the tables in the database require supplemental logging and thereby significantly reduce overhead of resource usage and redo generation.
To use this feature configure the new *supplemental_subset_replication_clause* added to the *supplemental_db_logging* clause of the `ALTER DATABASE` and `ALTER PLUGGABLE DATABASE` statements.
**Signature-based security for LOB locators** Starting with this release, you can configure signature-based security for large object (LOB) locators. LOB signature keys can be in both multitenant PDBs or in standalone, non-multitenant databases.
You can enable the encryption of the LOB signature key credentials by executing the `ALTER DATABASE DICTIONARY ENCRYPT CREDENTIALS` SQL statement. Otherwise, the credentials are stored in obfuscated format. If you choose to store the LOB signature key in encrypted format, then the database or PDB must have an open TDE keystore.
**Cloud Object Store Support Using REST APIs** Oracle Data Pump can import data from files located in a supported object store.
You can specify database credentials on the command line and store default credentials in the database using the new *property_clause* of the `ALTER DATABASE` statement.
**Multiple Table Family Support for System-Managed Sharding** This feature applies to system-managed sharded databases only. You can host different applications accessing different table families on one sharded database with the `CREATE SHARDED TABLE` statement.
You can create more than one table family with system sharding, but only one table family is supported for user-defined and composite sharding.
**Generation of Unique Sequence Numbers Across Shards** You can generate globally unique sequence numbers across shards for non-primary key columns with unique constraints without having to manage them yourself. The sharded database manages these sequence numbers for you.
Use the `SHARD` clause of the `CREATE SEQUENCE` statement or the `ALTER SEQUENCE` statement to generate unique sequence numbers across shards.
**Big Data and Performance Enhancements for In-Memory External Tables** The *inmemory_clause* of the `CREATE TABLE` and `ALTER TABLE` statement supports supports specification of the `ORACLE_HIVE` and `ORACLE_BIGDATA` driver types.
You can specify `INMEMORY` in the *inmemory_clause* clause on non-partitioned tables to support these driver types.
**Bitmap Based Count Dictinct SQL Functions** You can use five new bitvector functions for speeding up COUNT DISTINCT operations within a SQL query:
- BITMAP_BUCKET_NUMBER
- BITMAP_BIT_POSITION
- BITMAP_CONSTRUCT_AGG
- BITMAP_OR_AGG
- BITMAP_COUNT
**Memoptimized Rowstore - Fast Ingest** Use the *memoptimize_write_clause* of `CREATE TABLE` or `ALTER TABLE`to enable fast ingest. Fast ingest optimizes the memory processing of high frequency single row data inserts from Internet of Things (IoT) applications by using a large buffering pool to store the inserts before writing them to disk.
**JSON-Object Mapping** This feature enables the mapping of JSON data to and from user-defined SQL object types and collections.
You can convert JSON data to an instance of a SQL object type using SQL/JSON function `json_value`. In the opposite direction, you can generate JSON data from an instance of a SQL object type using SQL/JSON function `json_object` or `json_array`.
**JSON_MERGEPATCH Function** You can now update a JSON document declaratively, using new SQL function `json_mergepatch`. You can apply one or more changes to multiple documents using a single statement.
This feature improves the flexibility of JSON update operations.
**JSON Syntax Simplifications** Syntax simplifications are offered for SQL/JSON path expressions and SQL/JSON generation with function` json_object`. A new SQL query clause, `NESTED`, provides a simple alternative to using `json_table` with `LEFT OUTER JOIN`.
**JSON_SERIALIZE and JSON Data Guide Support for GeoJSON Data** You can use new SQL function `json_serialize` to serialize JSON data to text or to UTF-encoded `BLOB` data.
SQL aggregate function `json_dataguide` can now detect GeoJSON geographic data in your documents. You can use it to create a view that projects such data as SQL data type `SDO_GEOMETRY`.
**Hybrid Partitioned Tables** You can create hybrid partitioned tables where some partitions reside in Oracle database segments and some partitions reside in external files and sources. Internal and external partitions can be integrated into a single partitioned table as needed.
Specify `INTERNAL` or `EXTERNAL` in the *table_partition_description* clause of `CREATE TABLE` or `ALTER TABLE`.
**Parity Protected Files** You can configure single parity for write-once files, such as archive logs and backup sets that do not require a high level of redundancy and save space.
Specify `PARITY` in the *redundancy_clause* of the `ALTER DISKGROUP` statement.
**DISTINCT Option for LISTAGG Aggregate** The `LISTAGG` aggregate function now supports duplicate elimination by using the new `DISTINCT` keyword.
**Unified Auditing Top Level Statements** Specify the `ONLY TOPLEVEL` clause in the `CREATE AUDIT POLICY` statement (Unified Auditing) when you want to audit the SQL statements issued directly by a user.
You can now use the *by_users_with_roles_clause* to enable policy for users who have been directly or indirectly granted the specified roles.
**Transparent Online Conversion Support for Auto-Renaming in Non-OMF Mode** If `FILE_NAME_CONVERT` is omitted in the `ALTER TABLESPACE ENCRYPTION` statement, Oracle will internally select a name for the auxiliary file, and later rename it back to the original name.
**ALTER SYSTEM clause FLUSH PASSWORDFILE_METADATA_CACHE** The command `ALTER SYSTEM FLUSH PASSWORDFILE_METADATA_CACHE` flushes the password file metadata cache stored in the SGA and informs the database that a change has occurred.
### Deprecated Features
The following features are deprecated in this release, and may be desupported in a future release:
The `SQLNET.ENCRYPTION_WALLET_LOCATION` parameter is being deprecated.
### Desupported Features
The following features are desupported in Oracle Database Release 19c:
Oracle Multimedia is desupported.
Oracle Steams is desupported .
For a full list of desupported features for Release 19c, please see the *Oracle Database Upgrade Guide*.
