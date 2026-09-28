# CREATE TABLE

## Purpose
Use the `CREATE` `TABLE` statement to create one of the following types of tables:
****
- A relational table, which is the basic structure to hold user data.
****
- An object table, which is a table that uses an object type for a column definition. An object table is explicitly defined to hold object instances of a particular type.
You can also create an object type and then use it in a column when creating a relational table.
Tables are created with no data unless a subquery is specified. You can add rows to a table with the `INSERT` statement. After creating a table, you can define additional columns, partitions, and integrity constraints with the `ADD` clause of the `ALTER` `TABLE` statement. You can change the definition of an existing column or partition with the `MODIFY` clause of the `ALTER` `TABLE` statement.
**See Also:** **
- Oracle Database Administrator’s Guide and CREATE TYPE for more information about creating objects
- ALTER TABLE and DROP TABLE for information on modifying and dropping tables
## Prerequisites
To create a **relational table** in your own schema, you must have the `CREATE` `TABLE` system privilege. To create a table in another user’s schema, you must have the `CREATE` `ANY` `TABLE` system privilege. Also, the owner of the schema to contain the table must have either space quota on the tablespace to contain the table or the `UNLIMITED` `TABLESPACE` system privilege.
In addition to these table privileges, to create an object table or a relational table with an object type column, the owner of the table must have the `EXECUTE` object privilege in order to access all types referenced by the table, or you must have the `EXECUTE` `ANY` `TYPE` system privilege. These privileges must be granted explicitly and not acquired through a role.
Additionally, if the table owner intends to grant access to the table to other users, then the owner must have been granted the `EXECUTE` object privilege on the referenced types `WITH` `GRANT` `OPTION`, or have the `EXECUTE` `ANY` `TYPE` system privilege `WITH` `ADMIN` `OPTION`. Without these privileges, the table owner has insufficient privileges to grant access to the table to other users.
To enable a unique or primary key constraint, you must have the privileges necessary to create an index on the table. You need these privileges because Oracle Database creates an index on the columns of the unique or primary key in the schema containing the table.
To specify an edition in the *evaluation_edition_clause* or the *unusable_editions_clause*, you must have the `USE` privilege on the edition.
To specify the *zonemap_clause*, you must have the permissions necessary to create a zone map. Refer to the “Prerequisites” section in the documentation on `CREATE` `MATERIALIZED` `ZONEMAP`.
To create an **external table**, you must have the required read and write operating system privileges on the appropriate operating system directories. You must have the `READ` object privilege on the database directory object corresponding to the operating system directory in which the external data resides. You must also have the `WRITE` object privilege on the database directory in which the files will reside if you specify a log file or bad file in the *opaque_format_spec* or if you unload data into an external table from a database table by specifying the `AS` *subquery* clause.
To create an **XMLType table** in a different database schema from your own, you must have not only privilege `CREATE` `ANY` `TABLE` but also privilege `CREATE` `ANY` `INDEX`. This is because a unique index is created on column `OBJECT_ID` when you create the table. Column `OBJECT_ID` stores a system-generated object identifier.
**See Also:**
- CREATE INDEX
**
- Oracle Database Administrator’s Guide for more information about the privileges required to create tables using types
## Syntax
## *create_table*::=
Description of the illustration create_table.eps (*relational_table::=*, *object_table::=*, *XMLType_table::=*)
## *relational_table*::=
Description of the illustration relational_table.eps **Note:**   Each of the clauses following the table name is optional for any given relational table. However, for every table you must at least specify either column names and data types using the *relational_properties* clause or an `AS` *subquery* clause using the *table_properties* clause.
(*relational_properties::=*, **, *blockchain_table_clauses ::=*,*physical_properties::=*, *table_properties::=*)
## *object_table*::=
Description of the illustration object_table.eps (*object_table_substitution::=*, *object_properties::=*, *oid_clause::=*, *oid_index_clause::=*, *physical_properties::=*, *table_properties::=*)
## *XMLType_table*::=
Description of the illustration xmltype_table.eps (*XMLType_storage::=*, *XMLSchema_spec::=*, *XMLType_virtual_columns::=*, *oid_clause::=*, *oid_index_clause::=*, *physical_properties::=*, *table_properties::=*)
## *relational_properties*::=
Description of the illustration relational_properties.eps **Note:**   You can specify these clauses in any order with the following exception: You must specify at least one *column_definition* or *virtual_column_definition* before you specify *period_definition*. You can specify *period_definition* only once.
(*column_definition::=*, *virtual_column_definition::=*, *period_definition::=*, *constraint::=*, *supplemental_logging_props::=*)
## *column_definition*::=
Description of the illustration column_definition.eps (*identity_clause::=*, *encryption_spec::=*, *constraint::=*, *annotations_clause*)
## *identity_clause*::=
Description of the illustration identity_clause.eps
## *identity_options*::=
Description of the illustration identity_options.eps
## *virtual_column_definition*::=
Description of the illustration virtual_column_definition.eps (*evaluation_edition_clause::=*, *unusable_editions_clause::=*, *constraint::=*)
## *evaluation_edition_clause*::=
Description of the illustration evaluation_edition_clause.eps
## *unusable_editions_clause*::=
Description of the illustration unusable_editions_clause.eps
## *period_definition*::=
Description of the illustration period_definition.eps
## *encryption_spec*::=
Description of the illustration encryption_spec.eps
## *object_table_substitution*::=
Description of the illustration object_table_substitution.eps
## *object_properties*::=
Description of the illustration object_properties.eps (*constraint::=*, *supplemental_logging_props::=*)
## *oid_clause*::=
Description of the illustration oid_clause.eps
## *oid_index_clause*::=
Description of the illustration oid_index_clause.eps (*physical_attributes_clause::=*)
## *physical_properties*::=
Description of the illustration physical_properties.eps (*deferred_segment_creation::=*, *segment_attributes_clause::=*, *table_compression::=*, *inmemory_table_clause::=*, *ilm_clause::=*, *heap_org_table_clause::=*, *index_org_table_clause::=*, *external_table_clause::=*)
## *deferred_segment_creation*::=
Description of the illustration deferred_segment_creation.eps
## *segment_attributes_clause*::=
Description of the illustration segment_attributes_clause.eps (*physical_attributes_clause::=*, *logging_clause::=*)
## *physical_attributes_clause*::=
Description of the illustration physical_attributes_clause.eps (*storage_clause::=*)
## *table_compression*::=
Description of the illustration table_compression.eps
## *inmemory_table_clause*::=
Description of the illustration inmemory_table_clause.eps (*inmemory_attributes::=*, *inmemory_column_clause::=*)
## *inmemory_attributes*::=
Description of the illustration inmemory_attributes.eps (*inmemory_memcompress::=*, *inmemory_priority::=*, *inmemory_distribute::=*, *inmemory_duplicate::=*)
## *inmemory_memcompress*::=
Description of the illustration inmemory_memcompress.eps
## *inmemory_priority*::=
Description of the illustration inmemory_priority.eps
## *inmemory_distribute*::=
Description of the illustration inmemory_distribute.eps
## *inmemory_duplicate*::=
Description of the illustration inmemory_duplicate.eps
## *inmemory_column_clause*::=
Description of the illustration inmemory_column_clause.eps (*inmemory_memcompress::=*)
## *ilm_clause*::=
Description of the illustration ilm_clause.eps
## *ilm_policy_clause*::=
Description of the illustration ilm_policy_clause.eps (*ilm_compression_policy::=*, *ilm_tiering_policy::=*, *ilm_inmemory_policy::=*)
## *ilm_compression_policy*::=
Description of the illustration ilm_compression_policy.eps (*table_compression::=*, *ilm_time_period::=*)
## *ilm_tiering_policy*::=
Description of the illustration ilm_tiering_policy.eps (*ilm_time_period::=*)
## *ilm_inmemory_policy*::=
Description of the illustration ilm_inmemory_policy.eps
## *ilm_time_period*::=
Description of the illustration ilm_time_period.eps
## *table_properties*::=
Description of the illustration table_properties.eps (*column_properties::=*, *read_only_clause::=*, *indexing_clause::=*, *table_partitioning_clauses::=*, *attribute_clustering_clause::=*, *parallel_clause::=*, *enable_disable_clause::=*, *row_movement_clause::=*, *flashback_archive_clause::=*, *subquery::=*)
## *column_properties*::=
Description of the illustration column_properties.eps (*object_type_col_properties::=*, *nested_table_col_properties::=*, *varray_col_properties::=*, *LOB_storage_clause::=*, *LOB_partition_storage::=*, *XMLType_column_properties::=*)
## *object_type_col_properties*::=
Description of the illustration object_type_col_properties.eps
## *substitutable_column_clause*::=
Description of the illustration substitutable_column_clause.eps
## *nested_table_col_properties*::=
Description of the illustration nested_table_col_properties.eps (*substitutable_column_clause::=*, *object_properties::=*, *physical_properties::=*, *column_properties::=*)
## *varray_col_properties*::=
Description of the illustration varray_col_properties.eps (*substitutable_column_clause::=*, *varray_storage_clause::=*)
## *varray_storage_clause*::=
Description of the illustration varray_storage_clause.eps (*LOB_parameters::=*)
## *LOB_storage_clause*::=
Description of the illustration lob_storage_clause.eps (*LOB_storage_parameters::=*)
## *LOB_storage_parameters*::=
Description of the illustration lob_storage_parameters.eps (*LOB_parameters::=*, *storage_clause::=*)
## *LOB_parameters*::=
Description of the illustration lob_parameters.eps (*LOB_deduplicate_clause::=*, *LOB_compression_clause::=*, *encryption_spec::=*, *logging_clause::=*) **Note:**   Several of the LOB parameters are no longer needed if you are using SecureFiles for LOB storage. Refer to *LOB_storage_parameters* for more information.
## *LOB_retention_clause*::=
Description of the illustration lob_retention_clause.eps
## *LOB_deduplicate_clause*::=
Description of the illustration lob_deduplicate_clause.eps
## *LOB_compression_clause*::=
Description of the illustration lob_compression_clause.eps
## *logging_clause*::=
Description of the illustration logging_clause.eps
## *LOB_partition_storage*::=
Description of the illustration lob_partition_storage.eps (*LOB_storage_clause::=*, *varray_col_properties::=*, *LOB_partitioning_storage::=*)
## *LOB_partitioning_storage*::=
Description of the illustration lob_partitioning_storage.eps
## *XMLType_column_properties*::=
Description of the illustration xmltype_column_properties.eps (*XMLType_storage::=*, *XMLSchema_spec::=*)
## *XMLType_storage*::=
Description of the illustration xmltype_storage.eps (*LOB_parameters::=*)
## *XMLSchema_spec*::=
Description of the illustration xmlschema_spec.eps
## *XMLType_virtual_columns*::=
Description of the illustration xmltype_virtual_columns.eps
## *row_movement_clause*::=
Description of the illustration row_movement_clause.eps
## *logical_replication_clause*::=
Description of the illustration logical_replication_clause.eps
## *flashback_archive_clause*::=
Description of the illustration flashback_archive_clause.eps
## *heap_org_table_clause*::=
Description of the illustration heap_org_table_clause.eps (*table_compression::=*, *inmemory_table_clause::=*, *ilm_clause::=*)
## *index_org_table_clause*::=
Description of the illustration index_org_table_clause.eps (*mapping_table_clauses::=*, *prefix_compression::=*, *index_org_overflow_clause::=*)
## *mapping_table_clauses*::=
Description of the illustration mapping_table_clauses.eps
## *index_compression*::=
Description of the illustration index_compression.eps
## *prefix_compression*::=
Description of the illustration prefix_compression.eps
## *advanced_index_compression*::=
Description of the illustration advanced_index_compression.eps
## *index_org_overflow_clause*::=
Description of the illustration index_org_overflow_clause.eps (*segment_attributes_clause::=*)
## *supplemental_logging_props*::=
Description of the illustration supplemental_logging_props.eps
## *supplemental_log_grp_clause*::=
Description of the illustration supplemental_log_grp_clause.eps
## *supplemental_id_key_clause*::=
Description of the illustration supplemental_id_key_clause.eps
## *immutable_table_clauses*::=
Description of the illustration immutable_table_clauses.eps
## *immutable_table_no_drop_clause*::=
Description of the illustration immutable_table_no_drop_clause.eps
## *immutable_table_no_delete_clause*::=
Description of the illustration immutable_table_no_delete_clause.eps
## *blockchain_table_clauses*::=
Description of the illustration blockchain_table_clauses.eps
## *blockchain_drop_table_clause*::=
Description of the illustration blockchain_drop_table_clause.eps
## *blockchain_row_retention_clause*::=
Description of the illustration blockchain_row_retention_clause.eps
## *blockchain_hash_and_data_format_clause*::=
Description of the illustration blockchain_hash_and_data_format_clause.eps
## *external_table_clause*::=
Description of the illustration external_table_clause.eps (*external_table_data_props::=*)
## *external_table_data_props*::=
Description of the illustration external_table_data_props.eps (*opaque_format_spec*: This clause specifies all access parameters for the `ORACLE_LOADER`, `ORACLE_DATAPUMP`, `ORACLE_HDFS`, and `ORACLE_HIVE` access drivers. See *Oracle Database Utilities* for descriptions of these parameters.)
## *read_only_clause*::=
Description of the illustration read_only_clause.eps
## *indexing_clause*::=
Description of the illustration indexing_clause.eps
## *table_partitioning_clauses*::=
Description of the illustration table_partitioning_clauses.eps (*range_partitions::=*, *list_partitions::=*, *hash_partitions::=*, *composite_range_partitions::=*, *composite_list_partitions::=* *composite_hash_partitions::=*, *reference_partitioning::=*, *system_partitioning::=*, *consistent_hash_partitions::=*, *consistent_hash_with_subpartitions::=*, *partitionset_clauses::=*)
## *range_partitions*::=
Description of the illustration range_partitions.eps (*range_values_clause::=*, *table_partition_description::=*, *external_part_subpart_data_props::=*)
## *external_part_subpart_data_props*::=
Description of the illustration external_part_subpart_data_props.eps
## *hash_partitions*::=
Description of the illustration hash_partitions.eps (*individual_hash_partitions::=*, *hash_partitions_by_quantity::=*)
## *individual_hash_partitions*::=
Description of the illustration individual_hash_partitions.eps (*read_only_clause::=*, *indexing_clause::=*, *partitioning_storage_clause::=*)
## *hash_partitions_by_quantity*::=
Description of the illustration hash_partitions_by_quantity.eps (*table_compression::=*, *index_compression::=*)
## *list_partitions*::=
Description of the illustration list_partitions.eps (*list_values_clause::=*, *table_partition_description::=*, *external_part_subpart_data_props::=*)
## *composite_range_partitions*::=
Description of the illustration composite_range_partitions.eps (*subpartition_by_range::=*. *subpartition_by_list::=*, *subpartition_by_hash::=*, *range_partition_desc::=*)
## *composite_hash_partitions*::=
Description of the illustration composite_hash_partitions.eps (*subpartition_by_range::=*, *subpartition_by_list::=*, *subpartition_by_hash::=*, *individual_hash_partitions::=*, *hash_partitions_by_quantity::=*)
## *composite_list_partitions*::=
Description of the illustration composite_list_partitions.eps (*subpartition_by_range::=*. *subpartition_by_list::=*, *subpartition_by_hash::=*, *list_partition_desc::=*)
## *reference_partitioning*::=
Description of the illustration reference_partitioning.eps (*constraint::=*, *reference_partition_desc::=*)
## *reference_partition_desc*::=
Description of the illustration reference_partition_desc.eps (*table_partition_description::=*)
## *system_partitioning*::=
Description of the illustration system_partitioning.eps (*reference_partition_desc::=*)
## *consistent_hash_partitions*::=
Description of the illustration consistent_hash_partitions.eps
## *consistent_hash_with_subpartitions*::=
Description of the illustration consistent_hash_with_subpartitions.eps
## *partitionset_clauses*::=
Description of the illustration partitionset_clauses.eps (*range_partitionset_clause::=*, *list_partitionset_clause::=*
## *range_partitionset_clause*::=
Description of the illustration range_partitionset_clause.eps
## *range_partitionset_desc*::=
Description of the illustration range_partitionset_desc.gif Description of the illustration range_partitionset_desc.eps
## *list_partitionset_clause*::=
Description of the illustration list_partitionset_clause.eps
## *list_partitionset_desc*::=
Description of the illustration list_partitionset_desc.eps
## *range_partition_desc*::=
Description of the illustration range_partition_desc.eps (*range_values_clause::=*, *table_partition_description::=*, *range_subpartition_desc::=*, *list_subpartition_desc::=*, *individual_hash_subparts::=*, *hash_subparts_by_quantity::=*)
## *list_partition_desc*::=
Description of the illustration list_partition_desc.eps (*list_values_clause::=*, *table_partition_description::=*, *range_subpartition_desc::=*, *list_subpartition_desc::=*, *individual_hash_subparts::=*, *hash_subparts_by_quantity::=*)
## *subpartition_template*::=
Description of the illustration subpartition_template.eps (*range_subpartition_desc::=*, *list_subpartition_desc::=*, *individual_hash_subparts::=*)
## *subpartition_by_range*::=
Description of the illustration subpartition_by_range.eps (*subpartition_template::=*)
## *subpartition_by_list*::=
Description of the illustration subpartition_by_list.eps (*subpartition_template::=*)
## *subpartition_by_hash*::=
Description of the illustration subpartition_by_hash.eps (*subpartition_template::=*)
## *range_subpartition_desc*::=
Description of the illustration range_subpartition_desc.eps (*range_values_clause::=*, *read_only_clause::=*, *indexing_clause::=*, *partitioning_storage_clause::=*, *external_part_subpart_data_props::=*)
## *list_subpartition_desc*::=
Description of the illustration list_subpartition_desc.eps (*list_values_clause::=*, *read_only_clause::=*, *indexing_clause::=*, *partitioning_storage_clause::=*, *external_part_subpart_data_props::=*)
## *individual_hash_subparts*::=
Description of the illustration individual_hash_subparts.eps (*read_only_clause::=*, *indexing_clause::=*, *partitioning_storage_clause::=*)
## *hash_subparts_by_quantity*::=
Description of the illustration hash_subparts_by_quantity.eps
## *range_values_clause*::=
Description of the illustration range_values_clause.eps
## *list_values_clause*::=
Description of the illustration list_values_clause.eps (*list_values::=*)
## *list_values*::=
Description of the illustration list_values.eps
## *table_partition_description*::=
Description of the illustration table_partition_description.eps (*deferred_segment_creation::=*, *read_only_clause::=*, *indexing_clause::=*, *segment_attributes_clause::=*, *table_compression::=*, *prefix_compression::=*, *inmemory_clause::=*, *segment_attributes_clause::=*, *LOB_storage_clause::=*, *varray_col_properties::=*, *nested_table_col_properties::=*)
## *partitioning_storage_clause*::=
Description of the illustration partitioning_storage_clause.eps (*table_compression::=*, *index_compression::=*, *inmemory_clause::=*, *LOB_partitioning_storage::=*)
## *inmemory_clause*::=
Description of the illustration inmemory_clause.eps (*inmemory_memcompress::=*, *inmemory_attributes::=*)
## *attribute_clustering_clause*::=
Description of the illustration attribute_clustering_clause.eps (*clustering_join::=*, *cluster_clause::=*, *clustering_when::=*, *zonemap_clause::=*)
## *clustering_join*::=
Description of the illustration clustering_join.eps
## *cluster_clause*::=
Description of the illustration cluster_clause.eps
## *clustering_columns*::=
Description of the illustration clustering_columns.eps
## *clustering_column_group*::=
Description of the illustration clustering_column_group.eps
## *clustering_when*::=
Description of the illustration clustering_when.eps
## *zonemap_clause*::=
Description of the illustration zonemap_clause.eps
## *parallel_clause*::=
Description of the illustration parallel_clause.eps
## *enable_disable_clause*::=
Description of the illustration enable_disable_clause.eps (*using_index_clause::=*, *exceptions_clause* not supported in `CREATE` `TABLE` statements)
## *using_index_clause*::=
Description of the illustration using_index_clause.eps (*create_index::=*, *index_properties::=*)
## *index_properties*::=
Description of the illustration index_properties.eps (*global_partitioned_index::=*, *local_partitioned_index::=*-part of `CREATE` `INDEX`, *index_attributes::=*, *domain_index_clause* and *XMLIndex_clause*: not supported in *using_index_clause*)
## *index_attributes*::=
Description of the illustration index_attributes.eps (*physical_attributes_clause::=*, *logging_clause::=*, *index_compression::=*, *partial_index_clause* and *parallel_clause*: not supported in *using_index_clause*)
## *memoptimize_write_clause*
Description of the illustration memoptimize_write_clause.eps
## Semantics
## GLOBAL TEMPORARY
Specify `GLOBAL TEMPORARY` to create a temporary table, whose **definition** is visible to all sessions with appropriate privileges. The **data** in a temporary table is visible only to the session that inserts the data into the table.
When you first create a temporary table, its metadata is stored in the data dictionary, but no space is allocated for table data. Space is allocated for the table segment at the time of the first DML operation on the table. The temporary table definition persists in the same way as the definitions of regular tables, but the table segment and any data the table contains are either **session-specific** or **transaction-specific** data. You specify whether the table segment and data are sessionor transaction-specific with the ON COMMIT clause.
You can perform DDL operations (such as `ALTER` `TABLE`, `DROP` `TABLE`, `CREATE` `INDEX`) on a temporary table only when no session is bound to it. A session becomes bound to a temporary table with an `INSERT` operation on the table. A session becomes unbound to a temporary table with a `TRUNCATE` statement or at session termination, or, for a transaction-specific temporary table, by issuing a `COMMIT` or `ROLLBACK` statement.
## PRIVATE TEMPORARY
Specify `PRIVATE TEMPORARY` to create a private temporary table.
A private temporary table differs from a temporary table in that its **definition** and **data** are visible *only* within the session that created it. Use the `ON COMMIT` clause to define the scope of a private temporary table: either **transaction** or **session**. The `ON COMMIT` clause used with the keywords `DROP DEFINITION` creates a transaction-specific table whose data **and** definition are dropped when the transaction commits. This is the default behavior. The `ON COMMIT` clause used with keywords `PRESERVE DEFINITION` creates a session-specific table whose definition is preserved when the transaction commits. See here for usage details of theON COMMIT clause.
Three DDL statements are supported for private temporary tables: `CREATE`, `DROP`, and `TRUNCATE`.
**Restrictions** You must be a user other than `SYS` to create private temporary tables.
**See Also:**   *Oracle Database Concepts* for information on temporary tables and “Creating a Table: Temporary Table Example” **Restrictions on Temporary Tables** Temporary tables are subject to the following restrictions:
- Temporary tables cannot be partitioned, clustered, or index organized.
- You cannot specify any foreign key constraints on temporary tables.
- Temporary tables cannot contain columns of nested table.
******
- You cannot specify the following clauses of the LOB_storage_clause: TABLESPACE, storage_clause, or logging_clause.
``````
- Parallel UPDATE, DELETE and MERGE are not supported for temporary tables.
**
- The only part of the segment_attributes_clause you can specify for a temporary table is TABLESPACE, which allows you to specify a single temporary tablespace.
- Distributed transactions are not supported for temporary tables.
- A temporary table cannot contain INVISIBLE columns.
**Restrictions on Private Temporary Tables**
In addition to the general limitations of temporary tables, private temporary tables are subject to the following restrictions:
**``````
- The name of private temporary tables must always be prefixed with whatever is defined with the init.ora parameter PRIVATE_TEMP_TABLE_PREFIX. The default is ORA$PTT_.
- You cannot create indexes, materialized views, or zone maps on private temporary tables.
- You cannot define column with default values.
- You cannot reference private temporary tables in any permanent object, e.g. views or triggers.
- Private temporary tables are not visible through database links.
## SHARDED
Specify `SHARDED` to create a sharded table.
This clause is valid only if you are using Oracle Sharding, which is a data tier architecture in which data is horizontally partitioned across independent databases. Each database in such configuration is called a shard. All of the shards together make up a single logical database, which is referred to as a sharded database (SDB). Horizontal partitioning involves splitting a table across shards so that each shard contains the table with the same columns but a different subset of rows. A table split up in this manner is called a sharded table.
When you create a sharded table, you must specify a tablespace set in which to create the table. There is no default tablespace set for sharded tables. See CREATE TABLESPACE SET for more information.
Oracle Sharding is based on the Oracle Partitioning feature. Therefore, a sharded table must be a partitioned or composite-partitioned table. When creating a sharded table, you must specify one of the *table_partitioning_clauses*. See table_partitioning_clauses for the full semantics of these clauses.
**Restrictions on Sharded Tables**
The following restrictions apply to sharded tables:
````````
- In system-managed sharding you can create multiple root tables (and therefore table families) without throwing ORA-02530 , when the CREATE SHARDED TABLE statement does not contain a PARTITION BY REFERENCE or PARENT clause and there is already a root table in existence.
Even though you can create more than one table family with system sharding, only one table family is supported for user-defined and composite sharding.
- A sharded table cannot be a temporary table or an index-organized table.
- A sharded table cannot contain a nested table column or an identity column.
- You cannot specify a tablespace for a sharded system or composite sharded table with the TABLESPACEclause, because user-defined sharded tables require sharded tablespaces and not tablespace sets.
- You cannot create tablespace sets in a user-defined sharding environment.
- A sharded tablespace is required for sharded tables. Normal tablespaces are not supported.
- You cannot specify the same tablespace for multiple partitions of the sharded table. This rule applies to subpartitions also. The same tablespace cannot be specified for subpartitions belonging to different partitions of a sharded table.
- You must specify a tablespace per partition of non-reference partitioned sharded tables.
- For user defined sharding the partition method must be range or list. Autolist and Interval partitioning is not supported.
- The list partition method can only have one partitioning column.
- Default partitions are not supported in list partitioned tables.
- NULL partitions are not supported in list partitioned tables.
- A primary key constraint defined on a sharded table must contain the sharding columns. A foreign key constraint on a column of a sharded table referencing a duplicated table column is not supported.
- System partitioning and interval-range partitioning are not supported for sharded tables.
````````
```

```
- You cannot specify a virtual column in a sharded table in the PARTITION BY or PARTITIONSET BY clauses.
## DUPLICATED
This clause is valid only if you are using Oracle Sharding. Specify `DUPLICATED` to create a duplicated table, which is duplicated on all shards. It can be a nonpartitioned table or partitioned table.
Duplicated tables are not tied to any table family.
**Restrictions on Duplicated Tables**
The following restrictions apply to duplicated tables:
- A duplicated table cannot contain a LONG column.
- The maximum number of non-primary key columns in a duplicated table is 999.
- An XMLType column in a duplicated table can be used only in an Automatic Segment Space Management (ASSM) tablespace.
- A duplicated table cannot be a temporary table.
- A duplicated table cannot be a reference-partitioned table or a system-partitioned table.
````
- You cannot specify NOLOGGING or PARALLEL for a duplicated table.
- You cannot enable a duplicated table for the In-Memory Column Store.
## IMMUTABLE
Specify the `IMMUTABLE` keyword to create a read-only table that protects data from unauthorized modification by insiders.
You can create a blockchain table that is also immutable by using the keywords `IMMUTABLE BLOCKCHAIN` in `CREATE TABLE`.
You must specify the mandatory *immutable_table_clauses* when you create an immutable table using the `CREATE IMMUTABLE TABLE` statement.
Immutable tables support VPD policies, distributed transactions, and XA transactions.
**Prerequistes**
- The COMPATIBLE initialization parameter must be set to 19.11.0.0 or higher.
````
- The CREATE TABLE system privilege is required to create immutable tables in your own schema. The CREATE ANY TABLE system privilege is required to create immutable tables in another user’s schema.
````****
- The NO DROP and NO DELETE clauses are mandatory. See Also: Managing Tables
## BLOCKCHAIN
Specify the `BLOCKCHAIN` keyword to create a blockchain table.
You must specify the mandatory *blockchain_table_clauses* when you create a blockchain table using the `CREATE BLOCKCHAIN TABLE` statement.
When you create a blockchain table, an entry is created in the dictionary table `blockchain_table$` owned by `SYS`.
**RESTRICTIONS** The following `CREATE TABLE` clauses are disallowed with the creation of blockchain tables:
- ORGANIZATION INDEX
- ORGANIZATION EXTERNAL
****
- NESTED TABLE See Also: Managing Blockchain Tables
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the table does not exist, a new one is created at the end of the statement.
- If the table exists, it is detected and a new one is not created.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## *schema*
Specify the schema to contain the table. If you omit *schema*, then the database creates the table in your own schema.
## *table*
Specify the name of the table or object table to be created. The name must satisfy the requirements listed in “Database Object Naming Rules”.
**See Also:**   *Oracle Database Administrator’s Guide* for more on sharded tables.
## SHARING
This clause applies only when creating a table in an application root. This type of table is called an application common object and its data can be shared with the application PDBs that belong to the application root. To determine how the table data is shared, specify one of the following sharing attributes:
****
- METADATA - A metadata link shares the table’s metadata, but its data is unique to each container. This type of table is referred to as a metadata-linked application common object.
****
- DATA - A data link shares the table, and its data is the same for all containers in the application container. Its data is stored only in the application root. This type of table is referred to as a data-linked application common object.
````****
- EXTENDED DATA - An extended data link shares the table, and its data in the application root is the same for all containers in the application container. However, each application PDB in the application container can store data that is unique to the application PDB. For this type of table, data is stored in the application root and, optionally, in each application PDB. This type of table is referred to as an extended data-linked application common object.
- NONE - The table is not shared.
If you omit this clause, then the database uses the value of the `DEFAULT_SHARING` initialization parameter to determine the sharing attribute of the table. If the `DEFAULT_SHARING` initialization parameter does not have a value, then the default is `METADATA`.
When creating a relational table, you can specify `METADATA`, `DATA`, `EXTENDED` `DATA`, or `NONE`.
When creating an object table or an `XMLTYPE` table, you can specify only `METADATA` or `NONE`.
You cannot change the sharing attribute of a table after it is created.
```

```
## *relational_table*
This clause lets you create a relational table.
## *relational_properties*
The relational properties describe the components of a relational table.
## *column_definition*
The *column_definition* lets you define the characteristics of the column.
**Specifying** ***column_definition*** **with AS** ***subquery***
If you specify the `AS` *subquery* clause, and each column returned by *subquery* has a column name or is an expression with a specified column alias, then you can omit the *column_definition* clause. In this case, the names of the columns of table are the same as the names of the columns returned by *subquery*. The exception is creating an index-organized table, for which you must specify the *column_definition* clause, because you must designate a primary key column. Regardless of the table type, if you specify the *column_definition* clause and the `AS` *subquery* clause, then you must omit *datatype* from the *column_definition* clause.
***column***
Specify the name of a column of the table. The name must satisfy the requirements listed in “Database Object Naming Rules”.
If you also specify `AS` *subquery*, then you can omit *column* and *datatype* unless you are creating an index-organized table. If you specify `AS` *subquery* when creating an index-organized table, then you must specify *column*, and you must omit *datatype*.
The absolute maximum number of columns in a table is 1000. When you create an object table or a relational table with columns of object, nested table, varray, or REF type, Oracle Database maps the columns of the user-defined types to relational columns, in effect creating hidden columns that count toward the 1000-column limit. A relational column that stores a user-defined type attribute inherits the collation property of the attribute. In Oracle Database 12*c* Release 2 (12.2), user-defined types are created using the pseudo-collation property `USING_NLS_COMP` and their corresponding relational columns inherit this property.
## *datatype*
Specify the data type of a column.
In general, you must specify *datatype*. However, the following exceptions apply:
****
- You must omit datatype if you specify the AS subquery clause.
**
- You can also omit datatype if the statement designates the column as part of a foreign key in a referential integrity constraint. Oracle Database automatically assigns to the column the data type of the corresponding column of the referenced key of the referential integrity constraint.
**Restrictions on Table Column Data Types**
``````````
- Do not create a table with LONG columns. Use LOB columns (CLOB, NCLOB, BLOB) instead. LONG columns are supported only for backward compatibility.
****
- You can specify a column of type ROWID, but Oracle Database does not guarantee that the values in such columns are valid rowids. See Also: “Data Types” for information on LONG columns and on Oracle-supplied data types
You can specify a user-defined datatype as non-persistable when creating or altering the datatype. Instances of non-persistable types cannot persist on disk. See CREATE TYPE for more on user-defined datatypes declared as non-persistable types.
## COLLATE
The `COLLATE` clause lets you specify a data-bound collation for the column.
For *column_collation_name*, specify a valid named collation or pseudo-collation. For columns of data type `CLOB` or `NCLOB`, the only allowed value for *column_collation_name* is the pseudo-collation `USING_NLS_COMP`.
If you omit this clause, then the column is assigned:
``````
- the pseudo-collation USING_NLS_COMP, if the column has the data type CLOB or NCLOB, or
- the collation of the corresponding parent key column, if the column belongs to a foreign key, or
- the default collation for the table as it stands at the time the column is created.
Refer to the DEFAULT COLLATION clause for more information on the default collation for a table.
You can specify the `COLLATE` clause only if the `COMPATIBLE` initialization parameter is set to `12.2` or greater, and the `MAX_STRING_SIZE` initialization parameter is set to `EXTENDED`.
## SORT
The `SORT` keyword is valid only if you are creating this table as part of a hash cluster and only for columns that are also cluster columns.
Table rows are hashed into buckets on cluster key columns without SORT, and then sorted in each bucket on the columns with this clause. This may improve response time during subsequent operations on the clustered data.
**See Also:**
- “CLUSTER Clause” for information on creating a cluster table
**
- Managing Hash Clusters
## VISIBLE | INVISIBLE
Use this clause to specify whether *column* is `VISIBLE` or `INVISIBLE`. The default is `VISIBLE`.
`INVISIBLE` columns are user-specified hidden columns. To display or assign a value to an `INVISIBLE` column, you must specify its name explicitly. For example:
``````````
- The SELECT * syntax will not display an INVISIBLE column. However, if you include an INVISIBLE column in the select list of a SELECT statement, then the column will be displayed.
````````
- You cannot implicitly specify a value for an INVISIBLE column in the VALUES clause of an INSERT statement. You must specify the INVISIBLE column in the column list.
- You must explicitly specify an INVISIBLE column in Oracle Call Interface (OCI) describes.
````**
- You can configure SQL*Plus to allow INVISIBLE column information to be viewed with the DESCRIBE command. Refer to SQLPlus User’s Guide and Reference* for more information.
**Notes on VISIBLE and INVISIBLE Columns** The following notes apply to `VISIBLE` and `INVISIBLE` columns:
``````
- An INVISIBLE column can be used as a partitioning key when specified as part of CREATE TABLE.
**
- You can specify INVISIBLE columns in a column_expression.
- A virtual column can be an INVISIBLE column.
````
- PL/SQL %ROWTYPE attributes do not show INVISIBLE columns.
````````````````````````
- The COLUMN_ID column of the ALL_, DBA_, and USER_TAB_COLUMNS data dictionary views determines the order in which a SELECT * query returns columns for a table, view, or materialized view. The value of COLUMN_ID is NULL for INVISIBLE columns. When you make an invisible column visible, it will be assigned the next highest available COLUMN_ID value. When you make a visible column invisible, its COLUMN_ID value is set to NULL and COLUMN_ID is decremented by 1 for any columns with a higher COLUMN_ID.
**Restrictions on VISIBLE and INVISIBLE Columns**
The following restrictions apply to `VISIBLE` and `INVISIBLE` columns:
- INVISIBLE columns are not supported in external tables, cluster tables, or temporary tables.
****``````````**
- You cannot make a system-generated hidden column visible. Note: To determine whether a column is a system-generated hidden column, query the HIDDEN_COLUMN and USER_GENERATED columns of the ALL_, DBA_, and USER_TAB_COLS data dictionary views. Refer to Oracle Database Reference for more information.
## DEFAULT
The `DEFAULT` clause lets you specify a value to be assigned to the column if a subsequent `INSERT` statement omits a value for the column. The data type of the expression must match the data type specified for the column. The column must also be large enough to hold this expression.
The `DEFAULT` expression can include any SQL function as long as the function does not return a literal argument, a column reference, or a nested function invocation.
The `DEFAULT` expression can include the sequence pseudocolumns `CURRVAL` and `NEXTVAL`, as long as the sequence exists and you have the privileges necessary to access it. Users who perform subsequent inserts that use the `DEFAULT` expression must have the `INSERT` privilege on the table and the `SELECT` privilege on the sequence. If the sequence is later dropped, then subsequent `INSERT` statements where the `DEFAULT` expression is used will result in an error. If you do not fully qualify the sequence by specifying the sequence owner, for example, `SCOTT`.`SEQ1`, then Oracle Database will default the sequence owner to be the user who issues the `CREATE` `TABLE` statement. For example, if user `MARY` creates `SCOTT`.`TABLE` and refers to a sequence that is not fully qualified, such as `SEQ2`, then the column will use sequence `MARY`.`SEQ2`. Synonyms on sequences undergo a full name resolution and are stored as the fully qualified sequence in the data dictionary; this is true for public and private synonyms. For example, if user `BETH` adds a column referring to public or private synonym `SYN1` and the synonym refers to `PETER`.`SEQ7`, then the column will store `PETER`.`SEQ7` as the default.
**Restrictions on Default Column Values**
Default column values are subject to the following restrictions:
````````
- A DEFAULT expression cannot contain references to PL/SQL functions or to other columns, the pseudocolumns LEVEL, PRIOR, and ROWNUM, or date constants that are not fully specified.
******
- The expression can be of any form except a scalar subquery expression. See Also: “About SQL Expressions” for the syntax of expr
## ON NULL
If you specify the `ON` `NULL` clause, then Oracle Database assigns the `DEFAULT` column value when a subsequent `INSERT` statement attempts to assign a value that evaluates to NULL.
When you specify `ON` `NULL`, the `NOT` `NULL` constraint and `NOT` `DEFERRABLE` constraint state are implicitly specified. If you specify an inline constraint that conflicts with `NOT` `NULL` and `NOT` `DEFERRABLE`, then an error is raised.
**Restriction on the ON NULL Clause** You cannot specify this clause for an object type column or a REF column.
**See Also:**   “Creating a Table with a DEFAULT ON NULL Column Value: Example”
## *identity_clause*
Use this clause to specify an identity column. The identity column will be assigned an increasing or decreasing integer value from a sequence generator for each subsequent `INSERT` statement. You can use the *identity_options* clause to configure the sequence generator.
**ALWAYS** If you specify `ALWAYS`, then Oracle Database always uses the sequence generator to assign a value to the column. If you attempt to explicitly assign a value to the column using `INSERT` or `UPDATE`, then an error will be returned. This is the default.
**BY DEFAULT** If you specify `BY` `DEFAULT`, then Oracle Database uses the sequence generator to assign a value to the column by default, but you can also explicitly assign a specified value to the column. If you specify `ON` `NULL`, then Oracle Database uses the sequence generator to assign a value to the column when a subsequent `INSERT` statement attempts to assign a value that evaluates to NULL.
***identity_options*** Use the *identity_options* clause to configure the sequence generator. The *identity_options* clause has the same parameters as the `CREATE` `SEQUENCE` statement. Refer to CREATE SEQUENCE for a full description of these parameters and characteristics. The exception is `START` `WITH` `LIMIT VALUE`, which is specific to *identity_options* and can only be used with `ALTER` `TABLE` `MODIFY`. Refer to *identity_options* for more information.
**Note:**   When you create an identity column, Oracle recommends that you specify the `CACHE` clause with a value higher than the default of 20 to enhance performance.
**Restrictions on Identity Columns** Identity columns are subject to the following restrictions:
- You can specify only one identity column per table.
******
- If you specify identity_clause, then you must specify a numeric data type for datatype in the column_definition clause. You cannot specify a user-defined data type.
****
- If you specify identity_clause, then you cannot specify the DEFAULT clause in the column_definition clause.
**````````````````
- When you specify identity_clause, the NOT NULL constraint and NOT DEFERRABLE constraint state are implicitly specified. If you specify an inline constraint that conflicts with NOT NULL and NOT DEFERRABLE, then an error is raised.
- If an identity column is encrypted, then the encryption algorithm may be inferred. Oracle recommends that you use a strong encryption algorithm on identity columns.
````````****
- CREATE TABLE AS SELECT will not inherit the identity property on a column. See Also: “Creating a Table with an Identity Column: Examples”
## *encryption_spec*
The `ENCRYPT` clause lets you use the Transparent Data Encryption (TDE) feature to encrypt the column you are defining. You can encrypt columns of type `CHAR`, `NCHAR`, `VARCHAR2`, `NVARCHAR2`, `NUMBER`, `DATE`, LOB, and `RAW`. The data does not appear in its encrypted form to authorized users, such as the user who encrypts the column.
**Note:**   Column encryption requires that a system administrator with appropriate privileges has initialized the security module, opened a keystore, and set an encryption key. Refer to *Oracle Database Advanced Security Guide* for general information about column encryption and to *security_clauses* for related `ALTER` `SYSTEM` statements.
**USING ‘*****encrypt_algorithm*****‘**
Use this clause to specify the name of the algorithm to be used. Valid algorithms are `AES256`, `AES192`, `AES128` and `3DES168`. If the `COMPATIBLE` initialization parameter is set to `12`.`2` or higher, then the following algorithms are also valid: `ARIA128`, `ARIA192`, `ARIA256`, `GOST256`, and `SEED128`. If you omit this clause, then the database uses `AES192`. If you encrypt more than one column in the same table, and if you specify the `USING` clause for one of the columns, then you must specify the same encryption algorithm for all the encrypted columns.
**IDENTIFIED BY** ***password***
If you specify this clause, then the database derives the column key from the specified password.
‘***integrity_algorithm***’
Use this clause to specify the integrity algorithm to be used. Valid integrity algorithms are `SHA-1` and `NOMAC`.
- If you specify SHA-1, then TDE uses the Secure Hash Algorithm (SHA-1) and adds a 20-byte Message Authentication Code (MAC) to each encrypted value for integrity checking. This is the default.
**
- If you specify NOMAC, then TDE does not add a MAC and does not perform the integrity check. This saves 20 bytes of disk space per encrypted value. Refer to Oracle Database Advanced Security Guide for more information on using NOMAC to save disk space and improve performance.
All encrypted columns in a table must use the same integrity algorithm. If you already have a table column using the `SHA-1` algorithm, then you cannot use the `NOMAC` parameter to encrypt another column in the same table. Refer to the REKEY encryption_spec clause of `ALTER` `TABLE` to learn how to change the integrity algorithm used by all encrypted columns in a table.
**SALT | NO SALT**
Specify `SALT` to instruct the database to append a random string, called “salt,” to the clear text of the column before encrypting it. This is the default.
Specify `NO` `SALT` to prevent the database from appending salt to the clear text of the column before encrypting it.
The following considerations apply when specifying `SALT` or `NO` `SALT` for encrypted columns:
````**
- If you want to use the column as an index key, then you must specify NO SALT. Refer to Oracle Database Advanced Security Guide for a description of “salt” in this context.
- If you specify table compression for the table, then the database does not compress the data in encrypted columns with SALT.
You cannot specify `SALT` or `NO` `SALT` for LOB encryption.
**Restrictions on** ***encryption_spec*** The following restrictions apply to column encryption:
- Transparent Data Encryption is not supported by the traditional import and export utilities or by transportable-tablespace-based export. Use the Data Pump import and export utilities with encrypted columns instead.
- To encrypt a column in an external table, the table must use ORACLE_DATAPUMP as its access type.
- You cannot encrypt a column in tables owned by SYS.
******
- You cannot encrypt a foreign key column. See Also: Oracle Database Advanced Security Guide for more information about Transparent Data Encryption
## *annotations_clause*
For the full semantics of the annotations clause see *annotations_clause*.
## *virtual_column_definition*
The *virtual_column_definition* clause lets you create a virtual column. A virtual column is not stored on disk. Rather, the database derives the values in a virtual column on demand by computing a set of expressions or functions. Virtual columns can be used in queries, DML, and DDL statements. They can be indexed, and you can collect statistics on them. Thus, they can be treated much as other columns. Exceptions and restrictions are listed below in “Notes on Virtual Columns” and “Restrictions on Virtual Columns”.
***column*** For *column*, specify the name of the virtual column.
***datatype*** You can optionally specify the data type of the virtual column. If you omit *datatype*, then the database determines the data type of the column based on the data type of the underlying expressions. All Oracle scalar data types and `XMLType` are supported.
**COLLATE** The `COLLATE` clause lets you specify a data-bound collation for the virtual column. For *column_collation_name*, specify a valid named collation or pseudo-collation. If you omit this clause, then the column is assigned the default collation for the table as it stands at the time the column is created, unless the column belongs to a foreign key, in which case it inherits the collation from the corresponding column of the parent key. Refer to the DEFAULT COLLATION clause for more information on the default collation for a table.
You can specify the `COLLATE` clause only if the `COMPATIBLE` initialization parameter is set to `12.2` or greater, and the `MAX_STRING_SIZE` initialization parameter is set to `EXTENDED`.
**VISIBLE | INVISIBLE** Use this clause to specify whether virtual column is `VISIBLE` or `INVISIBLE`. The default is `VISIBLE`. For complete information, refer to “VISIBLE | INVISIBLE”.
**GENERATED ALWAYS** The optional keywords `GENERATED` `ALWAYS` are provided for semantic clarity. They indicate that the column is not stored on disk, but is evaluated on demand.
***column_expression*** The `AS` *column_expression* clause determines the content of the column. Refer to “Column Expressions” for more information on *column_expression*.
**VIRTUAL** The optional keyword `VIRTUAL` is provided for semantic clarity.
***evaluation_edition_clause*** You must specify this clause if *column_expression* refers to an editioned PL/SQL function. Use this clause to specify the edition that is searched during name resolution of the editioned PL/SQL function-the evaluation edition.
````
- Specify CURRENT EDITION to search the edition in which this DDL statement is executed.
****
- Specify EDITION edition to search edition.
````**
- Specifying NULL EDITION is equivalent to omitting the evaluation_edition_clause.
If you omit the *evaluation_edition_clause*, then editioned objects are invisible during name resolution and an error will result. If the evaluation edition is dropped, then a subsequent query on the virtual column will result in an error.
The database does not maintain dependencies on the functions referenced by a virtual column. Therefore, if a virtual column refers to a noneditioned function, and the function becomes editioned, then the following operations may raise an error:
- Querying the virtual column
- Updating a row that includes the virtual column
******
- Firing a trigger that accesses the virtual column See Also: Oracle Database Development Guide for more information on specifying the evaluation edition for a virtual column
***unusable_editions_clause*** This clause lets you specify that the virtual column expression is unusable for evaluating queries in one or more editions. The remaining editions form a range of editions in which it is safe for the optimizer to use the virtual column expression to evaluate queries.
For example, suppose you define a function-based index on the virtual column. The optimizer can use the function-based index to evaluate queries that contain the virtual column expression in their `WHERE` clause. If a query is compiled in an edition that is in the usable range of editions for the virtual column, then the optimizer will consider using the index to evaluate the query. If a query is compiled in an edition outside the usable range of editions for the virtual column, then the optimizer will not consider using the index.
**See Also:**   *Oracle Database Concepts* for more information on optimization with function-based indexes **UNUSABLE BEFORE Clause** This clause lets you specify that the virtual column expression is unusable for evaluating queries in the ancestors of an edition.
````
- If you specify CURRENT EDITION, then the virtual column expression is unusable in the ancestors of the edition in which this DDL statement is executed.
****
- If you specify EDITION edition, then the virtual column expression is unusable in the ancestors of the specified edition.
**UNUSABLE BEGINNING WITH Clause**
This clause lets you specify that the virtual column expression is unusable for evaluating queries in an edition and its descendants.
````
- If you specify CURRENT EDITION, then the virtual column expression is unusable in the edition in which this DDL statement is executed and its descendants.
****
- If you specify EDITION edition, then the virtual column expression is unusable in the specified edition and its descendants.
``````````
- Specifying NULL EDITION is equivalent to omitting the UNUSABLE BEGINNING WITH clause.
If an edition specified in this clause is subsequently dropped, there is no effect on the virtual column.
**Notes on Virtual Columns**
**
- If column_expression refers to a column on which column-level security is implemented, then the virtual column does not inherit the security rules of the base column. In such a case, you must ensure that data in the virtual column is protected, either by duplicating a column-level security policy on the virtual column or by applying a function that implicitly masks the data. For example, it is common for credit card numbers to be protected by a column-level security policy, while still allowing call center employees to view the last four digits of the credit card number for validation purposes. In such a case, you could define the virtual column to take a substring of the last four digits of the credit card number.
- A table index defined on a virtual column is equivalent to a function-based index on the table.
````````````
- You cannot directly update a virtual column. Thus, you cannot specify a virtual column in the SET clause of an UPDATE statement. However, you can specify a virtual column in the WHERE clause of an UPDATE statement. Likewise, you can specify a virtual column in the WHERE clause of a DELETE statement to delete rows from a table based on the derived value of the virtual column.
- A query that specifies in its FROM clause a table containing a virtual column is eligible for result caching. Refer to “RESULT_CACHE Hint” for more information on result caching.
**
  - Disable and re-enable any constraints on the virtual column.
  - Rebuild any indexes on the virtual column.
  - Fully refresh materialized views accessing the virtual column.
  - Flush the result cache if cached queries have accessed the virtual column.
  - Regather statistics on the table.
**
- A virtual column can be an INVISIBLE column. The column_expression can contain INVISIBLE columns.
**Restrictions on Virtual Columns**
- You can create virtual columns only in relational heap tables. Virtual columns are not supported for index-organized, external, object, cluster, or temporary tables.
**
  - It cannot refer to another virtual column by name.
**
  - Any columns referenced in column_expression must be defined on the same table.
  - It can refer to a deterministic user-defined function, but if it does, then you cannot use the virtual column as a partitioning key column.
**
  - The output of column_expression must be a scalar value.
**See Also:**   “Column Expressions” for additional information and restrictions on *column_expression*
````
- The virtual column cannot be an Oracle supplied data type, a user-defined type, or LOB or LONG RAW.
******
- You cannot specify a call to a PL/SQL function in the defining expression for a virtual column that you want to use as a partitioning column. See Also: “Adding a Virtual Table Column: Example” and Oracle Database Administrator’s Guide for examples of creating tables with virtual columns
## *period_definition*
Use the *period_definition* clause to create a valid time dimension for *table*.
This clause implements Temporal Validity support for *table*. If you specify this clause, then one column in *table*, the start time column, contains a start date or timestamp, and another column in *table*, the end time column, contains an end date or timestamp. These two columns define a valid time dimension for *table*-that is, a period of time for which each row is considered valid. You can use Oracle Flashback Query to retrieve rows from *table* based on whether they are considered valid as of a specified time, before a specified time, or during a specified time period.
You can specify at most one valid time dimension when you create a table. You can subsequently add additional valid time dimensions to a table with the *add_period_clause* of `ALTER` `TABLE`.
***valid_time_column***
Specify the name of the valid time dimension. The name must satisfy the requirements listed in “Database Object Naming Rules”. Oracle Database creates an `INVISIBLE` virtual column with this name of data type `NUMBER` in *table*.
***start_time_column*** **and** ***end_time_column***
You can optionally specify these clauses as follows:
**
- Use start_time_column to specify the name of the start time column, which contains the start date or timestamp.
**
- Use end_time_column to specify the name of the end time column, which contains the end date or timestamp.
The names you specify for *start_time_column* and *end_time_column* must satisfy the requirements listed in “Database Object Naming Rules”.
If you specify these clauses, then you must define *start_time_column* and *end_time_column* in the *column_definition* clause of `CREATE` `TABLE`. Each column must be of a datetime data type (`DATE`, `TIMESTAMP`, `TIMESTAMP` `WITH` `TIME` `ZONE`, or `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`) and can be `VISIBLE` or `INVISIBLE`.
If you do not specify these clauses, then Oracle Database creates a start time column named *valid_time_column*`_START`, and an end time column named *valid_time_column*`_END`. These columns are of data type `TIMESTAMP` `WITH` `TIME` `ZONE` and are `INVISIBLE`.
You can insert and update values in the start time column and end time column as you would any column, with the following considerations:
- If the value of the start time column is NULL, then the row is considered valid for all time values that occur before, but not including, the value of the end time column.
- If the value of the end time column is NULL, then the row is considered valid for all time values that occur on or after the value of the start time column.
- If the value of neither column is NULL, then the value of the start time column must be earlier than the value of the end time column. The row is considered valid for all time values that occur on or after the value of the start time column, and up to, but not including, the value of the end time column.
- If the value of both columns is NULL, then the row is considered valid for all time values.
**Restrictions on Valid Time Dimension Columns**
The following restrictions apply to valid time dimension columns:
****````
- The valid_time_column is for internal use only. You cannot perform DDL or DML operations on it with one exception: You can drop the column by using the drop_period_clause of ALTER TABLE.
**````
- You can drop the start time column and end time column only by using the drop_period_clause of ALTER TABLE.
````
```
**See Also:**
- [*Oracle Database Development Guide*](/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/sqlrf&id=ADFNS967) for more information on Temporal Validity
- `SELECT` *[flashback_query_clause](SELECT.html#GUID-CFA006CA-6FF1-4972-821E-6996142A51C6\_\_I2112818)* for more information on Oracle Flashback Query
- `ALTER` `TABLE` *[add_period_clause](ALTER-TABLE.html#GUID-552E7373-BF93-477D-9DA3-B2C9386F2877\_\_CJAEGCFI)* and *[drop_period_clause](ALTER-TABLE.html#GUID-552E7373-BF93-477D-9DA3-B2C9386F2877\_\_CJAJHJEJ)* for information how to add and drop a valid time dimension
```
- If the start time column and end time column are automatically created by Oracle Database, then they are INVISIBLE and you cannot subsequently make them VISIBLE.
```
Because external tables have no data in the database, you define them with a small subset of the clauses normally available when creating tables.
**********``````******
- Within the relational_properties clause, you can specify only column, datatype, ENCRYPT, inline_constraint, and out_of_line_constraint. You can specify the ENCRYPT clause only when you specify the ORACLE_DATAPUMP access driver and the AS subquery clause to load data into the external table. Within the inline_constraint and out_of_line_constraint clauses, you can specify all subclauses except CHECK.
**````**
- Within the physical_properties_clause, you can specify only the organization of the table (ORGANIZATION EXTERNAL external_table_clause).
******
**********
**
  - range_partitions - specify this clause to create a range-partitioned or interval-partitioned external table
**
  - list_partitions - specify this clause to create a list-partitioned external table. Within this clause, you cannot specify the AUTOMATIC clause; an automatic list-partitioned table cannot be an external table.
**
  - composite_range_partitions - specify this clause to create a range-range, range-list, interval-range, or interval-list composite-partitioned external table
**
  - composite_list_partitions - specify this clause to create a list-range or list-list composite-partitioned external table. Within this clause, you cannot specify the AUTOMATIC clause; an automatic composite-partitioned table cannot be an external table.
**
- You can populate the external table at create time by using the AS subquery clause.
No other clauses are permitted in the same `CREATE` `TABLE` statement.
**See Also:**
- “External Table Example”
- ALTER TABLE ... “PROJECT COLUMN Clause” for information on the effect of changing the default property of the column projection
******
- Oracle Database Data Warehousing Guide, Oracle Database Administrator’s Guide, and Oracle Database Utilities for information on the uses for external tables
**Restrictions on External Tables**
External tables are subject to the following restrictions:
- An external table cannot be a temporary table.
``````````````````
- You can specify only the following types of constraints on an external table: NOT NULL constraints, unique constraints, primary key constraints, and foreign key constraints. When you specify unique constraints, primary key constraints, or foreign key constraints, you must also specify RELY DISABLE. These constraints are declarative and are not enforced. They can increase query performance and reduce resource consumption because more optimizer transformations can be taken into account. In order for the optimizer to utilize these RELY DISABLE constraints, the QUERY_REWRITE_INTEGRITY initialization parameter must be set to either trusted or stale_tolerated.
- You cannot create an index on an external table.
- An external table cannot contain INVISIBLE columns.
````
- An external table cannot have object type, varray, or LONG columns. However, you can populate LOB columns of an external table with varray or LONG data from an internal database table.
````
- Only ORACLE_LOADER and ORACLE_DATAPUMP access types are permitted for external tables that can be populated into the inmemory column store.
**TYPE** `TYPE` *access_driver_type* indicates the **access driver** of the external table. The access driver is the API that interprets the external data for the database. Oracle Database provides the following access drivers: `ORACLE_LOADER`, `ORACLE_DATAPUMP`, `ORACLE_HDFS`, and `ORACLE_HIVE`. If you do not specify `TYPE`, then the database uses `ORACLE_LOADER` as the default access driver. You must specify the `ORACLE_DATAPUMP` access driver if you specify the `AS` *subquery* clause to unload data from one Oracle Database and reload it into the same or a different Oracle Database.
**See Also:**   *Oracle Database Utilities* for information about the `ORACLE_LOADER`, `ORACLE_DATAPUMP`, `ORACLE_HDFS`, and `ORACLE_HIVE` access drivers **DEFAULT DIRECTORY** `DEFAULT` `DIRECTORY` lets you specify a default directory object corresponding to a directory on the file system where the external data sources may reside. The default directory can also be used by the access driver to store auxiliary files such as error logs.
**ACCESS PARAMETERS** The optional `ACCESS` `PARAMETERS` clause lets you assign values to the parameters of the specific access driver for this external table.
**````````**```````` ****
- The opaque_format_spec specifies all access parameters for the ORACLE_LOADER, ORACLE_DATAPUMP, ORACLE_HDFS, and ORACLE_HIVE access drivers. See Oracle Database Utilities for descriptions of the ORACLE_LOADER, ORACLE_DATAPUMP, ORACLE_HDFS, and ORACLE_HIVE access parameters. Field names specified in the opaque_format_spec must match columns in the table definition. Oracle Database ignores any field in the opaque_format_spec that is not matched by a column in the table definition.
````**``````
- USING CLOB subquery lets you derive the parameters and their values through a subquery. The subquery cannot contain any set operators or an ORDER BY clause. It must return one row containing a single item of data type CLOB.
Whether you specify the parameters in an *opaque_format_spec* or derive them using a subquery, the database does not interpret anything in this clause. It is up to the access driver to interpret this information in the context of the external data.
For inline external tables and external modify query statements you must use *opaque_format_spec* within single quotes. For DDL statements you must use *opaque_format_spec* without single quotes.
**LOCATION**
The `LOCATION` clause lets you specify one or more external data sources. Usually the *location_specifier* is a file, but it need not be. Oracle Database does not interpret this clause. It is up to the access driver to interpret this information in the context of the external data.
You must specify the `LOCATION` clause as follows:
**
- When creating a nonpartitioned external table, you must specify the LOCATION clause at the table level in the external_table_data_props clause.
**
- When creating a partitioned external table, you must specify the LOCATION clause at the partition level in the external_part_subpart_data_props clause.
**
- When creating a composite-partitioned external table, you must specify the LOCATION clause at the subpartition level in the external_part_subpart_data_props clause.
**REJECT LIMIT**
The `REJECT` `LIMIT` clause lets you specify how many conversion errors can occur during a query of the external data before an Oracle Database error is returned and the query is aborted. The default value is 0.
## CLUSTER Clause
The `CLUSTER` clause indicates that the table is to be part of *cluster*. The columns listed in this clause are the table columns that correspond to the cluster columns. Generally, the cluster columns of a table are the column or columns that make up its primary key or a portion of its primary key. Refer to CREATE CLUSTER for more information.
Specify one column from the table for each column in the cluster key. The columns are matched by position, not by name.
A cluster table uses the space allocation of the cluster. Therefore, do not use the `PCTFREE`, `PCTUSED`, or `INITRANS` parameters, the `TABLESPACE` clause, or the *storage_clause* with the `CLUSTER` clause.
**Restrictions on Cluster Tables**
Cluster tables are subject to the following restrictions:
- Object tables and tables containing LOB columns or columns of the Any* Oracle-supplied types cannot be part of a cluster.
**````
- You cannot specify the parallel_clause or CACHE or NOCACHE for a table that is part of a cluster.
``````````
- You cannot specify CLUSTER with either ROWDEPENDENCIES or NOROWDEPENDENCIES unless the cluster has been created with the same ROWDEPENDENCIES or NOROWDEPENDENCIES setting.
- A cluster table cannot contain INVISIBLE columns.
## *table_properties*
The *table_properties* further define the characteristics of the table.
## *column_properties*
Use the *column_properties* clauses to specify the storage attributes of a column.
***object_type_col_properties*** The *object_type_col_properties* determine storage characteristics of an object column or attribute or of an element of a collection column or attribute.
***column*** For *column*, specify an object column or attribute.
***substitutable_column_clause*** The *substitutable_column_clause* indicates whether object columns or attributes in the same hierarchy are substitutable for each other. You can specify that a column is of a particular type, or whether it can contain instances of its subtypes, or both.
- If you specify ELEMENT, then you constrain the element type of a collection column or attribute to a subtype of its declared type.
````````**
- The IS OF [TYPE] (ONLY type) clause constrains the type of the object column to a subtype of its declared type.
``````````````````
- NOT SUBSTITUTABLE AT ALL LEVELS indicates that the object column cannot hold instances corresponding to any of its subtypes. Also, substitution is disabled for any embedded object attributes and elements of embedded nested tables and varrays. The default is SUBSTITUTABLE AT ALL LEVELS.
**Restrictions on the*****substitutable_column_clause*** This clause is subject to the following restrictions:
- You cannot specify this clause for an attribute of an object column. However, you can specify this clause for a object type column of a relational table and for an object column of an object table if the substitutability of the object table itself has not been set.
``````````
- For a collection type column, the only part of this clause you can specify is [NOT] SUBSTITUTABLE AT ALL LEVELS.
## *LOB_storage_clause*
The *LOB_storage_clause* lets you specify the storage attributes of LOB data segments. You must specify at least one clause after the `STORE` `AS` keywords. If you specify more than one clause, then you must specify them in the order shown in the syntax diagram, from top to bottom.
For a nonpartitioned table, this clause specifies the storage attributes of LOB data segments of the table.
For a partitioned table, Oracle Database implements this clause depending on where it is specified:
****
- For a partitioned table specified at the table level—when specified in the physical_properties clause along with one of the partitioning clauses—this clause specifies the default storage attributes for LOB data segments associated with each partition or subpartition. These storage attributes apply to all partitions or subpartitions unless overridden by a LOB_storage_clause at the partition or subpartition level.
******
- For an individual partition of a partitioned table—when specified as part of a table_partition_description—this clause specifies the storage attributes of the data segments of the partition or the default storage attributes of any subpartitions of the partition. A partition-level LOB_storage_clause overrides a table-level LOB_storage_clause.
********
- For an individual subpartition of a partitioned table—when specified as part of subpartition_by_hash or subpartition_by_list—this clause specifies the storage attributes of the data segments of the subpartition. A subpartition-level LOB_storage_clause overrides both partition-level and table-level LOB_storage_clauses.
**Restriction on the** ***LOB_storage_clause*****:**
Only the `TABLESPACE` clause is allowed when specifying the *LOB_storage_clause* in a subpartition.
**See Also:**
**
- Oracle Database SecureFiles and Large Objects Developer’s Guide for detailed information about LOBs, including guidelines for creating gigabyte LOBs
- “Creating a Table: LOB Column Example”
***LOB_item***
Specify the LOB column name or LOB object attribute for which you are explicitly defining tablespace and storage characteristics that are different from those of the table. Oracle Database automatically creates a system-managed index for each *LOB_item* you create.
**SECUREFILE | BASICFILE**
Use this clause to specify the type of LOB storage, either high-performance LOB (SecureFiles), or the traditional LOB (BasicFiles).
**See Also:**   *Oracle Database SecureFiles and Large Objects Developer’s Guide* for more information about SecureFiles LOBs
**Note:**   You cannot convert a LOB from one type of storage to the other. Instead you must migrate to SecureFiles or BasicFiles by using online redefinition or partition exchange.
***LOB_segname***
Specify the name of the LOB data segment. You cannot use *LOB_segname* if you specify more than one *LOB_item*.
## *LOB_storage_parameters*
The *LOB_storage_parameters* clause lets you specify various elements of LOB storage.
**TABLESPACE Clause**
Use this clause to specify the tablespace in which LOB data is to be stored.
**TABLESPACE SET Clause**
This clause is valid only when creating a sharded table by specifying the `SHARDED` keyword of `CREATE` `TABLE`. Use this clause to specify the tablespace set in which LOB data is to be stored.
***storage_clause***
Use the *storage_clause* to specify various aspects of LOB segment storage. Of particular interest in the context of LOB storage is the `MAXSIZE` clause of the *storage_clause*, which can be used in combination with the *LOB_retention_clause* of *LOB_parameters*. Refer to *storage_clause* for more information.
## *LOB_parameters*
Several of the *LOB_parameters* are no longer needed if you are using SecureFiles for LOB storage. The `PCTVERSION` and `FREEPOOLS` parameters are valid and useful only if you are using BasicFiles LOB storage.
**ENABLE STORAGE IN ROW**
If you enable storage in row, then the LOB value is stored in the row (inline) if its length is less than approximately 4000 bytes minus system control information. This is the default.
**Restriction on Enabling Storage in Row**
For an index-organized table, you cannot specify this parameter unless you have specified an `OVERFLOW` segment in the *index_org_table_clause*.
**DISABLE STORAGE IN ROW**
If you disable storage in row, then the LOB value is stored outside of the row out of line regardless of the length of the LOB value.
The LOB locator is always stored inline regardless of where the LOB value is stored. You cannot change the value of `STORAGE` `IN` `ROW` once it is set except by moving the table. See the *move_table_clause* in the `ALTER` `TABLE` documentation for more information.
**CHUNK** ***integer***
Specify the number of bytes to be allocated for LOB manipulation. If *integer* is not a multiple of the database block size, then the database rounds up in bytes to the next multiple. For example, if the database block size is 2048 and *integer* is 2050, then the database allocates 4096 bytes (2 blocks). The maximum value is 32768 (32K), which is the largest Oracle Database block size allowed. The default `CHUNK` size is one Oracle Database block.
The value of `CHUNK` must be less than or equal to the value of `NEXT`, either the default value or that specified in the *storage_clause*. If `CHUNK` exceeds the value of `NEXT`, then the database returns an error. You cannot change the value of `CHUNK` once it is set.
**PCTVERSION** ***integer***
Specify the maximum percentage of overall LOB storage space used for maintaining old versions of the LOB. If the database is running in manual undo mode, then the default value is 10, meaning that older versions of the LOB data are not overwritten until they consume 10% of the overall LOB storage space.
You can specify the `PCTVERSION` parameter whether the database is running in manual or automatic undo mode. `PCTVERSION` is the default in manual undo mode. `RETENTION` is the default in automatic undo mode. You cannot specify both `PCTVERSION` and `RETENTION`.
This clause is not valid if you have specified `SECUREFILE`. If you specify both `SECUREFILE` and `PCTVERSION`, then the database silently ignores the `PCTVERSION` parameter.
***LOB_retention_clause***
Use this clause to specify whether you want the LOB segment retained for flashback purposes, consistent-read purposes, both, or neither.
You can specify the `RETENTION` parameter only if the database is running in automatic undo mode. Oracle Database uses the value of the `UNDO_RETENTION` initialization parameter to determine the amount of committed undo data to retain in the database. In automatic undo mode, `RETENTION` is the default value unless you specify `PCTVERSION`. You cannot specify both `PCTVERSION` and `RETENTION`.
You can specify the optional settings after `RETENTION` only if you are using SecureFiles. The `SECUREFILE` parameter of the *LOB_storage_clause* indicates that the database will use SecureFiles to manage storage dynamically, taking into account factors such as the undo mode of the database.
````````**
- Specify MAX to signify that the undo should be retained until the LOB segment has reached MAXSIZE. If you specify MAX, then you must also specify the MAXSIZE clause in the storage_clause.
******
- Specify MIN if the database is in flashback mode to limit the undo retention duration for the specific LOB segment to n seconds.
- Specify AUTO if you want to retain undo sufficient for consistent read purposes only.
- Specify NONE if no undo is required for either consistent read or flashback purposes.
If you do not specify the `RETENTION` parameter, or you specify `RETENTION` with no optional settings, then `RETENTION` is set to `DEFAULT`, which is functionally equivalent to `AUTO`.
**See Also:**
````**
- CREATE TABLE clause LOB_storage_parameters for more information on simplified LOB storage using SecureFiles
**
- Oracle Database SecureFiles and Large Objects Developer’s Guide for more information on using SecureFiles
**````
- flashback_mode_clause of ALTER DATABASE for information on putting a database in flashback mode
- “Creating an Undo Tablespace: Example”
**FREEPOOLS** ***integer***
Specify the number of groups of free lists for the LOB segment. Normally *integer* will be the number of instances in an Oracle Real Application Clusters environment or 1 for a single-instance database.
You can specify this parameter only if the database is running in automatic undo mode. In this mode, `FREEPOOLS` is the default unless you specify the `FREELIST` `GROUPS` parameter of the *storage_clause*. If you specify neither `FREEPOOLS` nor `FREELIST` `GROUPS`, then the database uses a default of `FREEPOOLS` `1` if the database is in automatic undo management mode and a default of `FREELIST` `GROUPS` `1` if the database is in manual undo management mode.
This clause is not valid if you have specified `SECUREFILE`. If you specify both `SECUREFILE` and `FREEPOOLS`, then the database silently ignores the `FREEPOOLS` parameter.
**Restriction on FREEPOOLS**
You cannot specify both `FREEPOOLS` and the `FREELIST` `GROUPS` parameter of the *storage_clause*.
***LOB_deduplicate_clause***
This clause is valid only for SecureFiles LOBs. Use the *LOB_deduplicate_clause* to enable or disable LOB deduplication, which is the elimination of duplicate LOB data.
The `DEDUPLICATE` keyword instructs the database to eliminate duplicate copies of LOBs. Using a secure hash index to detect duplication, the database coalesces LOBs with identical content into a single copy, reducing storage consumption and simplifying storage management.
If you omit this clause, then LOB deduplication is disabled by default.
This clause implements LOB deduplication for the entire LOB segment. To enable or disable deduplication for an individual LOB, use the `DBMS_LOB.SETOPTIONS` procedure.
**See Also:**   *Oracle Database SecureFiles and Large Objects Developer’s Guide* for more information about LOB deduplication and *Oracle Database PL/SQL Packages and Types Reference* for information about about the `DBMS_LOB` package
***LOB_compression_clause***
This clause is valid only for SecureFiles LOBs, not for BasicFiles LOBs. Use the *LOB_compression_clause* to instruct the database to enable or disable server-side LOB compression. Random read/write access is possible on server-side compressed LOB segments. LOB compression is independent from table compression or index compression. If you omit this clause, then the default is `NOCOMPRESS`.
You can specify `HIGH`, `MEDIUM`, or `LOW` to vary the degree of compression. The `HIGH` degree of compression incurs higher latency than `MEDIUM` but provides better compression. The `LOW` degree results in significantly higher decompression and compression speeds, at the cost of slightly lower compression ratio than either `HIGH` or `MEDIUM`. If you omit this optional parameter, then the default is `MEDIUM`.
This clause implements server-side LOB compression for the entire LOB segment. To enable or disable compression on an individual LOB, use the `DBMS_LOB.SETOPTIONS` procedure.
**See Also:**   *Oracle Database SecureFiles and Large Objects Developer’s Guide* for more information on server-side LOB storage and *Oracle Database PL/SQL Packages and Types Reference* for information about client-side LOB compression using the `UTL_COMPRESS` supplied package and for information about the `DBMS_LOB` package
**ENCRYPT | DECRYPT**
These clauses are valid only for LOBs that are using SecureFiles for LOB storage. Specify `ENCRYPT` to encrypt all LOBs in the column. Specify `DECRYPT` to keep the LOB in cleartext. If you omit this clause, then `DECRYPT` is the default.
Refer to *encryption_spec* for general information on that clause. When applied to a LOB column, *encryption_spec* is specific to the individual LOB column, so the encryption algorithm can differ from that of other LOB columns and other non-LOB columns. Use the *encryption_spec* as part of the *column_definition* to encrypt the entire LOB column. Use the *encryption_spec* as part of the *LOB_storage_clause* in the *table_partition_description* to encrypt a LOB partition.
**Restriction on** ***encryption_spec*** **for LOBs**
You cannot specify the `SALT` or `NO` `SALT` clauses of *encryption_spec* for LOB encryption.
**See Also:**   *Oracle Database SecureFiles and Large Objects Developer’s Guide* for more information on LOB encryption and *Oracle Database PL/SQL Packages and Types Reference* for information the `DBMS_LOB` package
**CACHE | NOCACHE | CACHE READS**
Refer to CACHE | NOCACHE | CACHE READS for information on these clauses.
***LOB_partition_storage***
The *LOB_partition_storage* clause lets you specify a separate *LOB_storage_clause* or *varray_col_properties* clause for each partition. You must specify the partitions in the order of partition position. You can find the order of the partitions by querying the `PARTITION_NAME` and `PARTITION_POSITION` columns of the `USER_IND_PARTITIONS` view.
If you do not specify a *LOB_storage_clause* or *varray_col_properties* clause for a particular partition, then the storage characteristics are those specified for the LOB item at the table level. If you also did not specify any storage characteristics for the LOB item at the table level, then Oracle Database stores the LOB data partition in the same tablespace as the table partition to which it corresponds.
**Restrictions on *LOB_partition_storage***
*LOB_partition_storage* is subject to the following restrictions:
******
- In the LOB_parameters of the LOB_storage_clause, you cannot specify encryption_spec, because it is invalid to specify an encryption algorithm for partitions and subpartitions.
- You can only specify the TABLESPACE clause for hash partitions and all types of subpartitions.
## *varray_col_properties*
The *varray_col_properties* let you specify separate storage characteristics for the LOB in which a varray will be stored. If *varray_item* is a multilevel collection, then the database stores all collection items nested within *varray_item* in the same LOB in which *varray_item* is stored.
**
- For a nonpartitioned table—when specified in the physical_properties clause without any of the partitioning clauses—this clause specifies the storage attributes of the LOB data segments of the varray.
**
- For a partitioned table specified at the table level—when specified in the physical_properties clause along with one of the partitioning clauses—this clause specifies the default storage attributes for the varray LOB data segments associated with each partition (or its subpartitions, if any).
******
- For an individual partition of a partitioned table—when specified as part of a table_partition_description—this clause specifies the storage attributes of the varray LOB data segments of that partition or the default storage attributes of the varray LOB data segments of any subpartitions of this partition. A partition-level varray_col_properties overrides a table-level varray_col_properties.
********
- For an individual subpartition of a partitioned table—when specified as part of subpartition_by_hash or subpartition_by_list—this clause specifies the storage attributes of the varray data segments of this subpartition. A subpartition-level varray_col_properties overrides both partition-level and table-level varray_col_properties.
**STORE AS [SECUREFILE | BASICFILE] LOB Clause**
If you specify `STORE` `AS` `LOB`, then:
- If the maximum varray size is less than approximately 4000 bytes, then the database stores the varray as an inline LOB unless you have disabled storage in row.
- If the maximum varray size is greater than approximately 4000 bytes or if you have disabled storage in row, then the database stores in the varray as an out-of-line LOB.
If you do not specify `STORE` `AS` `LOB`, then storage is based on the maximum possible size of the varray rather than on the actual size of a varray column. The maximum size of the varray is the number of elements times the element size, plus a small amount for system control information. If you omit this clause, then:
- If the maximum size of the varray is less than approximately 4000 bytes, then the database does not store the varray as a LOB, but as inline data.
  - If the actual size is less than approximately 4000 bytes, then it is stored as an inline LOB
  - If the actual size is greater than approximately 4000 bytes, then it is stored as an out-of-line LOB, as is true for other LOB columns.
***substitutable_column_clause***
The *substitutable_column_clause* has the same behavior as described for *object_type_col_properties*.
**See Also:**   “Substitutable Table and Column Examples”
**Restriction on Varray Column Properties**
You cannot specify this clause on an interval partitioned table.
## *nested_table_col_properties*
The *nested_table_col_properties* let you specify separate storage characteristics for a nested table, which in turn enables you to define the nested table as an index-organized table. Unless you explicitly specify otherwise in this clause:
- For a nonpartitioned table, the storage table is created in the same schema and the same tablespace as the parent table.
- For a partitioned table, the storage table is created in the default tablespace of the schema. By default, nested tables are equipartitioned with the partitioned base table.
- In either case, the storage table uses default storage characteristics, and stores the nested table values of the column for which it was created.
You must include this clause when creating a table with columns or column attributes whose type is a nested table. Clauses within *nested_table_col_properties* that function the same way they function for the parent table are not repeated here.
***nested_item***
Specify the name of a column, or of a top-level attribute of the object type of the tables, whose type is a nested table.
**COLUMN_VALUE**
If the nested table is a multilevel collection, then the inner nested table or varray may not have a name. In this case, specify `COLUMN_VALUE` in place of the *nested_item* name.
**See Also:**   “Creating a Table: Multilevel Collection Example” for examples using *nested_item* and `COLUMN_VALUE`
**LOCAL | GLOBAL**
Specify `LOCAL` to equipartition the nested table with the base table. This is the default. Oracle Database automatically creates a local partitioned index for the partitioned nested table.
Specify `GLOBAL` to indicate that the nested table is a nonpartitioned nested table of a partitioned base table.
***storage_table***
Specify the name of the table where the rows of *nested_item* reside.
You cannot query or perform DML statements on *storage_table* directly, but you can modify its storage characteristics by specifying its name in an `ALTER` `TABLE` statement.
**See Also:**   ALTER TABLE for information about modifying nested table column storage characteristics
**RETURN [AS]**
Specify what Oracle Database returns as the result of a query.
- VALUE returns a copy of the nested table itself.
- LOCATOR returns a collection locator to the copy of the nested table. The locator is scoped to the session and cannot be used across sessions. Unlike a LOB locator, the collection locator cannot be used to modify the collection instance.
If you do not specify the *segment_attributes_clause* or the *LOB_storage_clause*, then the nested table is heap organized and is created with default storage characteristics.
**Restrictions on Nested Table Column Properties**
Nested table column properties are subject to the following restrictions:
- You cannot specify this clause for a temporary table.
- You cannot specify this clause on an interval partitioned table.
**
- You cannot specify the oid_clause.
******
- At create time, you cannot use object_properties to specify an out_of_line_ref_constraint, inline_ref_constraint, or foreign key constraint for the attributes of a nested table.
**See Also:**
- ALTER TABLE for information about modifying nested table column storage characteristics
- “Nested Table Example” and “Creating a Table: Multilevel Collection Example”
## *XMLType_column_properties*
The *XMLType_column_properties* let you specify storage attributes for an `XMLTYPE` column.
## *XMLType_storage*
`XMLType` data can be stored in binary XML, `CLOB`, or object-relational columns.
````
**``````
  - The tablespace for the XMLType table does not use automatic segment space management.
``````**
  - A setting in file init.ora prevents SecureFiles LOB storage. For example, see parameter DB_SECUREFILE in Oracle Database Reference.
````````
****
``````****``````````
- Specify CLOB if you want the database to store the XMLType data in a CLOB column. Storing data in a CLOB column preserves the original content and enhances retrieval time. If you specify LOB storage, then you can specify either LOB parameters or the XMLSchema_spec clause, but not both. Specify the XMLSchema_spec clause if you want to restrict the table or column to particular schema-based XML instances. If you do not specify BASICFILE or SECUREFILE with this clause, then the CLOB column is stored in a BasicFiles LOB. Note: Oracle recommends against storing XMLType data in a CLOB column. CLOB storage of XMLType is deprecated. Use binary XML storage of XMLType instead.
``````
**
- Specify OBJECT RELATIONAL if you want the database to store the XMLType data in object-relational columns. Storing data objects relationally lets you define indexes on the relational columns and enhances query performance. If you specify object-relational storage, then you must also specify the XMLSchema_spec clause.
Use the `ALL` `VARRAYS` `AS` clause if you want the database to store all varrays in an `XMLType` column.
In earlier releases, `XMLType` data is stored in a `CLOB` column in a BasicFiles LOB by default. Beginning with Oracle Database 11*g* Release 2 (
11.2.0.2), if the `COMPATIBLE` initialization parameter is 11.2 or higher and you do not specify the *XMLType_storage* clause, then `XMLType` data is stored in a binary XML column in a SecureFiles LOB. If SecureFiles LOB storage is not possible, then it is stored in a binary XML column in a BasicFiles LOB.
**See Also:**   *Oracle Database SecureFiles and Large Objects Developer’s Guide* for more information on SecureFiles LOBs
## *XMLSchema_spec*
Refer to the *XMLSchema_spec* for the full semantics of this clause.
```

```
## *XMLType_virtual_columns*
This clause is valid only for `XMLType` tables with binary XML storage, which you designate in the *XMLType_storage* clause. Specify the `VIRTUAL` `COLUMNS` clause to define virtual columns, which can be used as in a function-based index or in the definition of a constraint. You cannot define a constraint on such a virtual column during creation of the table, but you can use a subsequent `ALTER` `TABLE` statement to add a constraint to the column.
**See Also:**   *Oracle XML DB Developer’s Guide* for examples of how to use this clause in an XML environment
## *read_only_clause*
This clause lets you specify whether to create a table, partition, or subpartition in read-only or read/write mode.
``````````**
- Use READ ONLY to specify read-only mode. When an object is in read-only mode, you cannot issue any DML statements that affect the object or any SELECT ... FOR UPDATE ... statements on the object. You can issue DDL statements as long as they do not modify any table data. See Oracle Database Administrator’s Guide for the complete list of operations that are allowed and disallowed on read-only objects.
````
- Use READ WRITE to specify read/write mode. This is the default.
When you specify this clause for a partitioned table, you specify the default read-only or read/write mode for the table. This mode is assigned to all partitions in the table at creation time, as well as any partitions that are subsequently added to the table, unless you override this behavior by specifying the mode at the partition level.
When you specify this clause for a composite-partitioned table, you specify the default read-only or read/write mode for all partitions in the table. You can override this behavior by specifying this clause for a particular partition. The default mode of a partition is assigned to all subpartitions in the partition at creation time, as well as any subpartitions that are subsequently added to the partition, unless you override this behavior by specifying the mode at the subpartition level.
## *indexing_clause*
The *indexing_clause* is valid only for partitioned tables. Use this clause to set the **indexing** **property** for a table, table partition, or table subpartition.
``````
- Specify INDEXING ON to set the indexing property to ON. This is the default.
``````
- Specify INDEXING OFF to set the indexing property to OFF.
The indexing property determines whether table partitions and subpartitions are included in partial indexes on the table.
````
- For simple partitioned tables, partitions with an indexing property of ON are included in partial indexes on the table. Partitions with an indexing property of OFF are excluded.
````
- For composite-partitioned tables, subpartitions with an indexing property of ON are included in partial indexes on the table. Subpartitions with an indexing property of OFF are excluded.
You can specify the *indexing_clause* at the table, partition, or subpartition level. When you specify the *indexing_clause* at the table level, in the *table_properties* clause, you set the default indexing property for the table. Interval partitions, which are automatically created by the database, always inherit the default indexing property for the table. Other types of partitions and subpartitions inherit the default indexing property as follows:
** ****
  - For a range partition, in the table_partition_description of the range_partitions clause
****
  - For a hash partition, in the individual_hash_partitions clause of the hash_partitions clause
****
  - For a list partition, in the table_partition_description of the list_partitions clause
******
  - For a reference partition, in the table_partition_description of the reference_partition_desc clause of the reference_partitioning clause
******
  - For a system partition, in the table_partition_description of the reference_partition_desc clause of the system_partitioning clause
** ** ****
  - For composite range partitions, in the table_partition_description of the composite_range_partitions clause
****
  - For composite list partitions, in the table_partition_description of the composite_list_partitions clause
****
  - For composite hash partitions, in the individual_hash_partitions clause of the composite_hash_partitions clause
You can set the indexing property of a subpartition by specifying the *indexing_clause* for the subpartition:
****
  - For range subpartitions, in the range_subpartition_desc clause of the composite_range_partitions clause
****
  - For list subpartitions, in the list_subpartition_desc clause of the composite_list_partitions clause
****
  - For hash subpartitions, in the individual_hash_subparts clause of the composite_hash_partitions clause
**See Also:** *Oracle Database Reference* for information on viewing the indexing property of a table, table partition, or table subpartition.
````
- To view the default indexing property of a table, query the DEF_INDEXING column of the *_PART_TABLES views.
````
- To view the indexing property of a table partition, query the INDEXING column of the *_TAB_PARTITIONS views.
````
- To view the indexing property of a table subpartition, query the INDEXING column of the *_TAB_SUBPARTITIONS views.
**Restrictions on the** ***indexing_clause***
The *indexing_clause* is subject to the following restrictions:
**
- You cannot specify the indexing_clause for nonpartitioned tables.
********````
- You cannot specify the indexing_clause for index-organized tables. See Also: The partial_index_clause of CREATE INDEX for more information on partial indexes
## *table_partitioning_clauses*
Use the *table_partitioning_clauses* to create a partitioned table.
**Notes on Partitioning in General**
The following notes pertain to all types of partitioning:
- You can specify up to a total of 1024K-1 partitions and subpartitions.
- You can create a partitioned table with just one partition. A table with one partition is different from a nonpartitioned table. For example, you cannot add a partition to a nonpartitioned table.
******
  - If you omit a partition name, then the database generates a name of the form SYS_Pn. System-generated names for LOB data and LOB index partitions take the form SYS_LOB_Pn and SYS_IL_Pn, respectively.
**``````
  - If you specify a subpartition name in subpartition_template, then for each subpartition created with that template, the database generates a name by concatenating the partition name with the template subpartition name. For LOB subpartitions, the generated LOB subpartition name is a concatenation of the partition name and the template LOB segment name. If the COMPATIBLE initialization parameter is set to 12.2 or higher, then the maximum length of the concatenation is 128 bytes; otherwise, the maximum length is 30 bytes. If the concatenation exceeds the maximum length, then the database returns an error and the statement fails.
********
  - If you omit a subpartition name when specifying an individual subpartition, and you have not specified subpartition_template, then the database generates a name of the form SYS_SUBPn. The corresponding system-generated names for LOB data and index subpartitions are SYS_LOB_SUBPn and SYS_IL_SUBPn, respectively.
````
**
  - Tablespace storage specified at the individual table subpartition or LOB subpartition level has the highest priority, followed by storage specified for the partition or LOB in the subpartition_template.
**
  - Tablespace storage specified at the individual table partition or LOB partition level. Storage parameters specified here take precedence over the subpartition_template.
  - Tablespace storage specified for the table
  - Default tablespace storage specified for the user
- By default, nested tables are equipartitioned with the partitioned base table.
**Restrictions on Partitioning in General** All partitioning is subject to the following restrictions:
- You cannot partition a table that is part of a cluster.
- You cannot partition a nested table or varray that is defined as an index-organized table.
``````
- You cannot partition a table containing any LONG or LONG RAW columns.
**Restrictions on Hybrid Partitioned Tables**
Hybrid partitioned tables are subject to the following restrictions:
- Restrictions that apply to external tables also apply to hybrid partitioned tables unless explicitly noted.
````
- No support for REFERENCE and SYSTEM partitioning methods.
````
- Only single level LIST and RANGE partitioning are supported.
- No unique indexes or global unique indexes. Only partial indexes are allowed and unique indexes cannot be partial.
- Only single level list partitioning is supported for HIVE.
- Attribute clustering (CLUSTERING clause) is not allowed.
- DML operations only on internal partitions of a hybrid partitioned table (external partitions are treated as read-only partitions).
- In-memory defined on the table level only has an effect on internal partitions of the hybrid partitioned table.
- No column default value is allowed.
- Invisible columns are not allowed.
- The CELLMEMORY clause is not allowed.
``````
- SPLIT, MERGE, and MOVE maintenance operations are not allowed on external partitions.
The storage of partitioned database entities in tablespaces of different block sizes is subject to several restrictions. Refer to *Oracle Database VLDB and Partitioning Guide* for a discussion of these restrictions.
**See Also:**   “Partitioning Examples”
## *range_partitions*
Use the *range_partitions* clause to partition the table on ranges of values from the column list. For an index-organized table, the column list must be a subset of the primary key columns of the table.
**Restrictions on Range Partitioning** Range partitioning is subject to the restrictions listed in “Restrictions on Partitioning in General”. The following additional restrictions apply:
- You cannot specify more than 16 partitioning key columns.
````````````````````````````
- Partitioning key columns must be of type CHAR, NCHAR, VARCHAR2, NVARCHAR2, VARCHAR, NUMBER, FLOAT, DATE, TIMESTAMP, TIMESTAMP WITH LOCAL TIMEZONE, or RAW.
``````````````
- Each range partitioning key column with a character data type that belongs to an XMLType table or a table with an XMLType column, or that is used as a sharding key column must have one of the following declared collations: BINARY, USING_NLS_COMP, USING_NLS_SORT, or USING_NLS_SORT_CS. For all these collations, partition bounds are checked using the collation BINARY.
- You cannot specify NULL in the VALUES clause.
***column*** Specify an ordered list of columns used to determine into which partition a row belongs. These columns are the **partitioning key**. You can specify virtual columns and `INVISIBLE` columns as partitioning key columns.
**INTERVAL Clause** Use this clause to establish **interval partitioning** for the table. Interval partitions are partitions based on a numeric range or datetime interval. They extend range partitioning by instructing the database to create partitions of the specified range or interval automatically when data inserted into the table exceeds all of the range partitions. For each automatically created partition, the database generates a name of the form `SYS_P`*n*. The database guarantees that automatically generated partition names are unique and do not violate namespace rules.
**
- For expr, specify a valid number or interval expression.
````
- The optional STORE IN clause lets you specify one or more tablespaces into which the database will store interval partition data.
******
- You must also specify at least one range partition using the PARTITION clause of range_partitions. The range partition key value determines the high value of the range partitions, which is called the transition point, and the database creates interval partitions for data beyond that transition point.
**Restrictions on Interval Partitioning**
The `INTERVAL` clause is subject to the restrictions listed in “Restrictions on Partitioning in General” and “Restrictions on Range Partitioning”. The following additional restrictions apply:
````````
- You can specify only one partitioning key column, and it must be of type NUMBER, DATE, FLOAT, or TIMESTAMP.
- This clause is not supported for index-organized tables.
- This clause is not supported for tables containing varray columns.
- You cannot create an interval-partitioned table with equipartitioned nested tables. If you create an interval-partitioned table using nested tables or XML object-relational data types, then the nested tables will be created as nonpartitioned tables.
- This clause is supported for tables containing XMLType columns only if the XML data is stored as binary XML.
- Interval partitioning is not supported at the subpartition level.
- Serializable transactions do not work with interval partitioning. Trying to insert data into a partition of an interval partitioned table that does not yet have a segment causes an error.
  - You cannot specify MAXVALUE (an infinite upper bound), because doing so would defeat the purpose of the automatic addition of partitions as needed.
******
  - You cannot specify NULL values for the partitioning key column. See Also: Oracle Database VLDB and Partitioning Guide for more information on interval partitioning
## PARTITION*partition*
If you specify a partition name, then the name *partition* must conform to the rules for naming schema objects and their part as described in “Database Object Naming Rules”. If you omit *partition*, then the database generates a name as described in “Notes on Partitioning in General”.
## *range_values_clause*
Specify the noninclusive upper bound for the current partition. The value list is an ordered list of literal values corresponding to the column list in the *range_partitions* clause. You can substitute the keyword `MAXVALUE` for any literal in the value list. `MAXVALUE` specifies a maximum value that will always sort higher than any other value, including null.
Specifying a value other than `MAXVALUE` for the highest partition bound imposes an implicit integrity constraint on the table.
**Note:**   If *table* is partitioned on a `DATE` column, and if the date format does not specify the first two digits of the year, then you must use the `TO_DATE` function with the `YYYY` 4-character format mask for the year. The `RRRR` format mask is not supported in this clause. The date format is determined implicitly by `NLS_TERRITORY` or explicitly by `NLS_DATE_FORMAT`. Refer to *Oracle Database Globalization Support Guide* for more information on these initialization parameters.
**See Also:**   *Oracle Database Concepts* for more information about partition bounds and “Range Partitioning Example”
## *table_partition_description*
Use the *table_partition_description* to define the physical and storage characteristics of the table.
The clauses *deferred_segment_creation*, *segment_attributes_clause*, *table_compression*, *inmemory_clause*, and *ilm_clause* have the same function as described for the *physical_properties* of the table as a whole.
Use the *indexing_clause* to set the indexing property for a range, list, system, or reference table partition. Refer to the *indexing_clause* for more information.
The *prefix_compression* clause and `OVERFLOW` clause, have the same function as described for the *index_org_table_clause*.
***LOB_storage_clause*** The *LOB_storage_clause* lets you specify LOB storage characteristics for one or more LOB items in this partition or in any range or list subpartitions of this partition. If you do not specify the *LOB_storage_clause* for a LOB item, then the database generates a name for each LOB data partition as described in “Notes on Partitioning in General”.
***varray_col_properties*** The *varray_col_properties* let you specify storage characteristics for one or more varray items in this partition or in any range or list subpartitions of this partition.
***nested_table_col_properties*** The *nested_table_col_properties* let you specify storage characteristics for one or more nested table storage table items in this partition or in any range or list subpartitions of this partition. Storage characteristics specified in this clause override any storage attributes specified at the table level.
## *partitioning_storage_clause*
Use the *partitioning_storage_clause* to specify storage characteristics for hash partitions and for range, hash, and list subpartitions.
**Restrictions on** ***partitioning_storage_clause*** This clause is subject to the following restrictions:
``````````
- The TABLESPACE SET clause is valid only when creating a sharded table by specifying the SHARDED keyword of CREATE TABLE. Use this clause to specify the tablespace set in which table partition data is to be stored.
**
- The OVERFLOW clause is relevant only for index-organized partitioned tables and is valid only within the individual_hash_partitions clause. It is not valid for range or hash partitions or for subpartitions of any type.
****
- You cannot specify the advanced_index_compression clause of the index_compression clause.
****````**
- You can specify the prefix_compression clause of the indexing_clause only for partitions of index-organized tables and you can specify COMPRESS or NOCOMPRESS, but you cannot specify the prefix length with integer.
## *list_partitions*
Use the *list_partitions* clause to partition the table on a list of literal values for each column in the *column* list. List partitioning is useful for controlling how individual rows map to specific partitions.
**Restrictions on List Partitioning**
List partitioning is subject to the restrictions listed in “Restrictions on Partitioning in General”. The following additional restrictions apply:
- You cannot specify more than 16 partitioning key columns.
- You cannot specify more than one partitioning key column when partitioning an index-organized table.
````````````````````````````
- The partitioning key columns must be of type CHAR, NCHAR, VARCHAR2, NVARCHAR2, VARCHAR, NUMBER, FLOAT, DATE, TIMESTAMP, TIMESTAMP WITH LOCAL TIMEZONE, or RAW.
``````````````
- Each list partitioning key column with a character data type that belongs to an XMLType table or a table with an XMLType column, or that is used as a sharding key column must have one of the BINARY following declared collations: BINARY , USING_NLS_COMP, USING_NLS_SORT, or USING_NLS_SORT_CS . For all these collations, partitions are matched using the collation BINARY.
## AUTOMATIC
Specify `AUTOMATIC` to create an automatic list-partitioned table. This type of table enables the database to create additional partitions on demand.
When you create an automatic list-partitioned table, you specify partitions and partitioning key values just as you would when creating a regular list-partitioned table. However, you do not specify a `DEFAULT` partition. As data is loaded into the table, the database automatically creates a new partition when the loaded partitioning key values do not correspond to any of the existing partitions. If list partitioning is defined with a single partitioning key value, then the database creates a new partition for each new partitioning key value. If list partitioning is defined with multiple partitioning key columns, then the database creates a new partition for each new and unique set of partitioning key values. For each automatically created partition, the database generates a name of the form `SYS_P`*n*. The database guarantees that automatically generated partition names are unique and do not violate namespace rules.
You can specify the `AUTOMATIC` keyword for list-partitioned tables, and list-range, list-list, list-hash, and list-interval composite-partitioned tables. For composite-partitioned tables, each automatically created list partition will have one subpartition, unless a subpartition template is defined for the table.
If a local partitioned index is defined on an automatic list-partitioned table, then local index partitions will be created when the corresponding table partitions are created.
**Restrictions on Automatic List Partitioning**
Automatic list partitioning is subject to the restrictions listed in “Restrictions on List Partitioning”. The following additional restrictions apply:
- An automatic list-partitioned table must have at least one partition when created. Because new partitions are automatically created for new, and unknown, partitioning key values, an automatic list-partitioned table cannot have a DEFAULT partition.
- Automatic list partitioning is not supported for index-organized tables or external tables.
- Automatic list partitioning is not supported for tables containing varray columns.
- You cannot create a local domain index on an automatic list-partitioned table. You can create a global domain index on an automatic list-partitioned table.
- An automatic list-partitioned table cannot be a child table or a parent table for reference partitioning.
- Automatic list partitioning is not supported at the subpartition level.
## STORE IN
The optional `STORE` `IN` clause lets you specify one or more tablespaces into which the database will store data for the automatically created list partitions.
**Note:**   You can change an automatic list-partitioned table to a regular list-partitioned table, and vice versa. You can also change the tablespaces into which the database will store data for automatically created list partitions. See the clause *alter_automatic_partitioning* of `ALTER` `TABLE` for more information.
## *list_values_clause*
The *list_values_clause* of each partition must have at least one value. If the table is partitioned on one key column, then use the upper branch of the *list_values* syntax to specify a list of values for that column. In this case, no value, including NULL, can appear in more than one partition. If the table is partitioned on multiple key columns, then use the lower branch of the *list_values* syntax to specify a list of value lists. Each value list is enclosed in parentheses and represents a list of values for the key columns. In this case, individual key column values can appear in more than one partition; however, no complete value list can appear in more than one partition. List partitions are not ordered.
If you specify the literal `NULL` for a partition value in the `VALUES` clause, then to access data in that partition in subsequent queries, you must use an `IS` `NULL` condition in the `WHERE` clause, rather than a comparison condition.
The `DEFAULT` keyword creates a partition into which the database will insert any row that does not map to another partition. Therefore, you can specify `DEFAULT` for only one partition, and you cannot specify any other values for that partition. Further, the default partition must be the last partition you define. The use of `DEFAULT` is similar to the use of `MAXVALUE` for range partitions.
The string comprising the list of values for each partition can be up to 4K bytes. The total number of values for all partitions cannot exceed 64K-
1.
The partitioning key column for a list partition can be an extended data type column, which has a maximum size of 32767 bytes. In this case, the list of values that you want to specify for a partition may exceed the 4K byte limit. You can work around this limitation by using one of the following methods:
- Use the DEFAULT partition for values that exceed the 4K byte limit.
- Use a hash function, such as STANDARD_HASH, in the partition key column to create unique identifiers of lengths less than 4K bytes. See STANDARD_HASH for more information.
**Restriction on the** *list_values_clause*
You cannot specify a `DEFAULT` partition for an automatic list-partitioned table.
**See Also:**   “Extended Data Types” for more information on extended data types
## *table_partition_description*
The subclauses of the *table_partition_description* have the same behavior as described for range partitions in *table_partition_description*.
## *hash_partitions*
Use the *hash_partitions* clause to specify that the table is to be partitioned using the hash method. Oracle Database assigns rows to partitions using a hash function on values found in columns designated as the partitioning key. You can specify individual hash partitions, or you can specify how many hash partitions the database should create.
**Restrictions on Hash Partitioning**
Hash partitioning is subject to the restrictions listed in “Restrictions on Partitioning in General”. The following additional restrictions apply:
- You cannot specify more than 16 partitioning key columns.
````````````````````````````
- Partitioning key columns must be of type CHAR, NCHAR, VARCHAR2, NVARCHAR2, VARCHAR, NUMBER, FLOAT, DATE, TIMESTAMP, TIMESTAMP WITH LOCAL TIMEZONE, or RAW.
````````````
- Each hash partitioning key column with a character data type that belongs to an XMLType table or a table with an XMLType column, or that is used as a sharding key column must have one of the following declared collations: BINARY, USING_NLS_COMP, USING_NLS_SORT, or USING_NLS_SORT_CS.
***column***
Specify an ordered list of columns used to determine into which partition a row belongs (the partitioning key).
## *individual_hash_partitions*
Use this clause to specify individual partitions by name.
Use the *indexing_clause* to set the indexing property for a hash partition. Refer to the *indexing_clause* for more information.
**Restriction on Specifying Individual Hash Partitions**
The only clauses you can specify in the *partitioning_storage_clause* are the `TABLESPACE` clause and table compression.
 **Note:**   If your enterprise has or will have databases using different character sets, then use caution when partitioning on character columns. The sort sequence of characters is not identical in all character sets. Refer to *Oracle Database Globalization Support Guide* for more information on character set support.
## *hash_partitions_by_quantity*
An alternative to defining individual partitions is to specify the number of hash partitions. In this case, the database assigns partition names of the form `SYS_P`*n*. The `STORE` `IN` clause lets you specify one or more tablespaces where the hash partition data is to be stored. The number of tablespaces need not equal the number of partitions. If the number of partitions is greater than the number of tablespaces, then the database cycles through the names of the tablespaces.
For both methods of hash partitioning, for optimal load balancing you should specify a number of partitions that is a power of
  **- When you specify individual hash partitions, you can specify both TABLESPACE and table compression in the partitioning_storage_clause. When you specify hash partitions by quantity, you can specify only TABLESPACE. Hash partitions inherit all other attributes from table-level defaults.
The *table_compression* clause has the same function as described for the *table_properties* of the table as a whole.
The *prefix_compression* clause and the `OVERFLOW` clause have the same function as described for the *index_org_table_clause*.
Tablespace storage specified at the table level is overridden by tablespace storage specified at the partition level, which in turn is overridden by tablespace storage specified at the subpartition level.
In the *individual_hash_partitions* clause, the `TABLESPACE` clause of the *partitioning_storage_clause* determines tablespace storage only for the individual partition being created. In the *hash_partitions_by_quantity* clause, the `STORE` `IN` clause determines placement of partitions as the table is being created and the default storage location for subsequently added partitions.
**Restriction on Specifying Hash Partitions by Quantity**
You cannot specify the *advanced_index_compression* clause of the *index_compression* clause.
**See Also:**   *Oracle Database VLDB and Partitioning Guide* for more information on hash partitioning
## *composite_range_partitions*
Use the *composite_range_partitions* clause to first partition *table* by range, and then partition the partitions further into range, hash, or list subpartitions.
The `INTERVAL` clause has the same semantics for composite range partitioning that it has for range partitioning. Refer to “INTERVAL Clause” for more information.
Specify *subpartition_by_range*, *subpartition_by_hash* or *subpartition_by_list* to indicate the type of subpartitioning you want for each composite range partition. Within these clauses you can specify a subpartition template, which establishes default subpartition characteristics for subpartitions created as part of this statement or subsequently created subpartitions.
After establishing the type of subpartitioning you want for the table, and optionally a subpartition template, you must define at least one range partition.
**
- You must specify the range_values_clause, which has the same requirements as for noncomposite range partitions.
**
- Use the table_partition_description to define the physical and storage characteristics of the each partition.
************
- In the range_partition_desc, use range_subpartition_desc, list_subpartition_desc, individual_hash_subparts, or hash_subparts_by_quantity to specify characteristics for the individual subpartitions of the partition. The values you specify in these clauses supersede for these subpartitions any values you have specified in the subpartition_template.
**
- The only characteristics you can specify for a hash or list subpartition or any LOB subpartition are TABLESPACE and table_compression.
**Restrictions on Composite Range Partitioning**
Regardless of the type of subpartitioning, composite range partitioning is subject to the following restrictions:
- The only physical attributes you can specify at the subpartition level are TABLESPACE and table compression.
**
- You cannot specify composite partitioning for an index-organized table. Therefore, the OVERFLOW clause of the table_partition_description is not valid for composite-partitioned tables.
- You cannot specify composite partitioning for tables containing XMLType columns.
````````````******
- Each range, list, or hash subpartitioning key column with a character data type that belongs to an XMLType table or a table with an XMLType column must have one of the following declared collations: BINARY, USING_NLS_COMP, USING_NLS_SORT, or USING_NLS_SORT_CS. See Also: “Composite-Partitioned Table Examples” for examples of composite range partitioning and Oracle Database VLDB and Partitioning Guide for examples of composite list partitioning
## *composite_list_partitions*
Use the *composite_list_partitions* clause to first partition *table* by list, and then partition the partitions further into range, hash, or list subpartitions.
Specify *subpartition_by_range*, *subpartition_by_hash* or *subpartition_by_list* to indicate the type of subpartitioning you want for each composite list partition. Within these clauses you can specify a subpartition template, which establishes default subpartition characteristics for subpartitions created as part of this statement and for subsequently created subpartitions.
After establishing the type of subpartitioning you want for each composite partition, and optionally defining a subpartition template, you must define at least one list partition.
****
- In the list_partition_desc, you must specify the list_values_clause, which has the same requirements as for noncomposite list partitions.
**
- Use the table_partition_description to define the physical and storage characteristics of the each partition.
************
- In the list_partition_desc, use range_subpartition_desc, list_subpartition_desc, individual_hash_subparts, or hash_subparts_by_quantity to specify characteristics for the individual subpartitions of the partition. The values you specify in these clauses supersede the for these subpartitions any values you have specified in the subpartition_template.
Specify `AUTOMATIC` to create an automatic list-range, list-list, list-hash, or list-interval composite-partitioned table. This type of table enables the database to create additional partitions on demand. The optional `STORE` `IN` clause lets you specify one or more tablespaces into which the database will store data for the automatically created partitions. The `AUTOMATIC` and `STORE` `IN` clauses have the same semantics here as they have for noncomposite list partitions. Refer to AUTOMATIC and STORE IN in the documentation on *list_partitions* for the full semantics of these clauses. Automatic composite-partitioned tables are subject to the restrictions listed in Restrictions on Composite List Partitioning and Restrictions on Automatic List Partitioning.
**Restrictions on Composite List Partitioning** Composite list partitioning is subject to the same restrictions as described in “Restrictions on Composite Range Partitioning”.
## *composite_hash_partitions*
Use the *composite_hash_partitions* clause to first partition *table* using the hash method, and then partition the partitions further into range, hash, or list subpartitions.
Specify *subpartition_by_range*, *subpartition_by_hash* or *subpartition_by_list* to indicate the type of subpartitioning you want for each composite range partition. Within these clauses you can specify a subpartition template, which establishes default subpartition characteristics for subpartitions created as part of this statement or subsequently created subpartitions.
After establishing the type of subpartitioning you want for the table, you must specify *individual_hash_partitions* or *hash_partitions_by_quantity*.
**Restrictions on Composite Hash Partitioning** Composite hash partitioning is subject to the same restrictions as described in “Restrictions on Composite Range Partitioning”.
## *subpartition_template*
The *subpartition_template* is an optional element of range, list, and hash subpartitioning. The template lets you define default subpartitions for each table partition. Oracle Database will create these default subpartition characteristics in any partition for which you do not explicitly define subpartitions. This clause is useful for creating symmetric partitions. You can override this clause by explicitly defining subpartitions at the partition level, in the *range_subpartition_desc*, *list_subpartition_desc*, *individual_hash_subparts*, or *hash_subparts_by_quantity* clause.
When defining subpartitions with a template, you can explicitly define range, list, or hash subpartitions, or you can define a quantity of hash subpartitions.
************
- To explicitly define subpartitions, use range_subpartition_desc, list_subpartition_desc, or individual_hash_subparts. You must specify a name for each subpartition. If you specify the LOB_partitioning_clause of the partitioning_storage_clause, then you must specify LOB_segname.
****
```

```
- To define a quantity of hash subpartitions, specify a positive integer for hash_subpartition_quantity. The database creates that number of subpartitions in each partition and assigns subpartition names of the form SYS_SUBPn.
**Restrictions on Subpartition Templates** Subpartition templates are subject to the following restrictions:
````
- If you specify TABLESPACE for one LOB subpartition, then you must specify TABLESPACE for all of the LOB subpartitions of that LOB column. You can specify the same tablespace for more than one LOB subpartition.
******
- If you specify separate LOB storage for list subpartitions using the partitioning_storage_clause, either in the subpartition_template or when defining individual subpartitions, then you must specify LOB_segname for both LOB and varray columns.
## *subpartition_by_range*
Use the *subpartition_by_range* clause to indicate that the database should subpartition by range each partition in *table*. The subpartitioning column list is unrelated to the partitioning key but is subject to the same restrictions (see *column*).
You can use the *subpartition_template* to specify default subpartition characteristic values. See *subpartition_template*. The database uses these values for any subpartition in this partition for which you do not explicitly specify the characteristic.
You can also define range subpartitions individually for each partition using the *range_subpartition_desc* of *range_partition_desc* or *list_partition_desc*. If you omit both *subpartition_template* and the *range_subpartition_desc*, then the database creates a single `MAXVALUE` subpartition.
## *subpartition_by_list*
Use the *subpartition_by_list* clause to indicate that the database should subpartition each partition in the table on lists of literal values from the *column* list. You can specify a maximum of 16 list subpartitioning key columns.
You can use the *subpartition_template* to specify default subpartition characteristic values. See *subpartition_template*. The database uses these values for any subpartition in this partition for which you do not explicitly specify the characteristic.
You can also define list subpartitions individually for each partition using the *list_subpartition_desc* of *range_partition_desc* or *list_partition_desc*. If you omit both *subpartition_template* and the *list_subpartition_desc*, then the database creates a single `DEFAULT` subpartition.
**Restrictions on List Subpartitioning**
List subpartitioning is subject to the same restrictions as described in *Restrictions on Composite Range Partitioning*.
## *subpartition_by_hash*
Use the *subpartition_by_hash* clause to indicate that the database should subpartition by hash each partition in *table*. The subpartitioning column list is unrelated to the partitioning key but is subject to the same restrictions (see *column*).
You can define the subpartitions using the *subpartition_template* or the `SUBPARTITIONS` *integer* clause. See *subpartition_template*. In either case, for optimal load balancing you should specify a number of partitions that is a power of 2.
If you specify `SUBPARTITIONS` *integer*, then you determine the default number of subpartitions in each partition of *table*, and optionally one or more tablespaces in which they are to be stored. The default value is 1. If you omit both this clause and *subpartition_template*, then the database will create each partition with one hash subpartition.
## Notes on Composite Partitions
The following notes apply to composite partitions:
********
- For all subpartitions, you can use the range_subpartition_desc, list_subpartition_desc, individual_hash_subparts, or hash_subparts_by_quantity to specify individual subpartitions by name, and optionally some other characteristics.
  - You can specify the number of subpartitions and optionally one or more tablespaces where they are to be stored. In this case, Oracle Database assigns subpartition names of the form SYS_SUBPn.
  - If you omit the subpartition description and if you have created a subpartition template, then the database uses the template to create subpartitions. If you have not created a subpartition template, then the database creates one hash subpartition or one DEFAULT list subpartition.
******
  - If you have specified a subpartition template and you have specified partition names, then the database generates subpartition names of the form partition_name underscore (_) subpartition_name (for example, P1_SUB1).
****
  - If you have not specified a subpartition template or if you have specified a subpartition template but did not specify partition names, then the database generates subpartition names of the form SYS_SUBPn.
## *reference_partitioning*
Use this clause to partition the table by reference. Partitioning by reference is a method of equipartitioning the table being created (the **child table**) by a referential constraint to an existing partitioned table (the **parent table**). When you partition a table by reference, partition maintenance operations subsequently performed on the parent table automatically cascade to the child table. Therefore, you cannot perform partition maintenance operations on a reference-partitioned table directly.
If the parent table is an interval-partitioned table, then partitions in the reference-partitioned child table that correspond to interval partitions in the parent table will be created during inserts into the child table. When an interval partition in a child table is created, the partition name is inherited from the associated parent table partition. If the child table has a table-level default tablespace, then it will be used as the tablespace for the new interval partition. Otherwise, the tablespace will be inherited from the parent table partition. Refer to *Oracle Database VLDB and Partitioning Guide* for more information on referencing an interval-partitioned table.
***constraint***
The partitioning referential constraint must meet the following conditions:
````````
- You must specify a referential integrity constraint defined on the table being created, which must refer to a primary key or unique constraint on the parent table. The constraint must be in ENABLE VALIDATE NOT DEFERRABLE state, which is the default when you specify a referential integrity constraint during table creation.
````
- All foreign key columns referenced in the constraint must be NOT NULL.
````````**
- When you specify the constraint, you cannot specify the ON DELETE SET NULL clause of the references_clause.
- The parent table referenced in the constraint must be an existing partitioned table. It can be partitioned by any method.
- The foreign and parent keys cannot contain any virtual columns that reference PL/SQL functions or LOB columns.
***reference_partition_desc*** Use this optional clause to specify partition names and to define the physical and storage characteristics of the partition. The subclauses of the *table_partition_description* have the same behavior as described for range partitions in *table_partition_description*.
If you specify this clause when creating a reference-partitioned child table whose parent is an interval-partitioned table, then the partition descriptors are used for the child table’s non-interval partitions. Partition descriptors cannot be specified for interval partitions.
**Restrictions on Reference Partitioning** Reference partitioning is subject to the restrictions listed in Restrictions on Partitioning in General. The following additional restrictions apply:
- Restrictions for reference partitioning are derived from the partitioning strategy of the parent table.
- Neither the parent table nor the child table can be an automatic list-partitioned table.
- You cannot specify this clause for an index-organized table, an external table, or a domain index storage table.
**
- The parent table can be partitioned by reference, but constraint cannot be self-referential. The table being created cannot be partitioned based on a reference to itself.
````******
- If ROW MOVEMENT is enabled for the parent table, it must also be enabled for the child table. See Also: Oracle Database VLDB and Partitioning Guide for more information on partitioning by reference and “Reference Partitioning Example”
## *system_partitioning*
Use this clause to create system partitions. System partitioning does not entail any partitioning key columns, nor do system partitions have any range or list bounds or hash algorithms. Rather, they provide a way to equipartition dependent tables such as nested table or domain index storage tables with partitioned base tables.
````````**
- If you specify only PARTITION BY SYSTEM, then the database creates one partition with a system-generated name of the form SYS_Pn.
````````****
- If you specify PARTITION BY SYSTEM PARTITIONS integer, then the database creates as many partitions as you specify in integer, which can range from 1 to 1024K- 1.
******
- The description of the partition takes the same syntax as reference partitions, so they share the reference_partition_desc. You can specify additional partition attributes with the reference_partition_desc syntax. However, within the table_partition_description, you cannot specify the OVERFLOW clause.
**Restrictions on System Partitioning**
System partitioning is subject to the following restrictions:
- You cannot system partition an index-organized table or a table that is part of a cluster.
- Composite partitioning is not supported with system partitioning.
- You cannot split a system partition.
````````
- You cannot specify system partitioning in a CREATE TABLE ... AS SELECT statement.
``````********
- To insert data into a system-partitioned table using an INSERT INTO ... AS subquery statement, you must use partition-extended syntax to specify the partition into which the values returned by the subquery will be inserted. See Also: Refer to Oracle Database Data Cartridge Developer’s Guide for information on the uses for system partitioning and “References to Partitioned Tables and Indexes”
## *consistent_hash_partitions*
This clause is valid only for sharded tables. Use this clause to create consistent hash partitions.
Each sharding key column with a character data type must have one of the following declared collations: `BINARY`, `USING_NLS_COMP`, `USING_NLS_SORT`, or `USING_NLS_SORT_CS`.
## *consistent_hash_with_subpartitions*
This clause is valid only for sharded tables. Use this clause to create consistent hash with subpartitions.
Each sharding key column with a character data type must have one of the following declared collations: `BINARY`, `USING_NLS_COMP`, `USING_NLS_SORT`, or `USING_NLS_SORT_CS`.
## *range_partitionset_clause*
Use this clause to create a range partition set.
In the `SUBPARTITION` `BY` clause, within the *subpartition_template* clause, you cannot specify a tablespace for a subpartition. That is, for range, list, and individual hash subpartitions, you cannot specify the `TABLESPACE` clause of the *partitioning_storage_clause*, and in the *hash_subpartitions_by_quantity* clause, you cannot specify the `STORE` `IN` `(`*tablespace*`)` clause.
In the `PARTITIONS` `AUTO` clause, within the *subpartition_template* clause of the *range_partitionset_desc* clause, you *can* specify a tablespace for a subpartition.
Each super sharding or sharding key column with a character data type must have one of the following declared collations: `BINARY`, `USING_NLS_COMP`, `USING_NLS_SORT`, or `USING_NLS_SORT_CS`.
## *list_partitionset_clause*
Use this clause to create a list partition set.
In the `SUBPARTITION` `BY` clause, within the *subpartition_template* clause, you cannot specify a tablespace for a subpartition. That is, for range, list, and individual hash subpartitions, you cannot specify the `TABLESPACE` clause of the *partitioning_storage_clause*, and in the *hash_subpartitions_by_quantity* clause, you cannot specify the `STORE` `IN` `(`*tablespace*`)` clause.
In the `PARTITIONS` `AUTO` clause, within the *subpartition_template* clause of the *list_partitionset_desc* clause, you *can* specify a tablespace for a subpartition.
Each super sharding or sharding key column with a character data type must have one of the following declared collations: `BINARY`, `USING_NLS_COMP`, `USING_NLS_SORT`, or `USING_NLS_SORT_CS`.
## *attribute_clustering_clause*
Use this clause to enable the table for attribute clustering. Attribute clustering lets you cluster data in close physical proximity based on the content of specified columns.
Attribute clustering can be based only on columns in *table* or on joined values from other tables. The latter is called join attribute clustering.
**See Also:**   *Oracle Database Data Warehousing Guide* for more information on attribute clustering
***clustering_join***
Use this clause to specify join attribute clustering. Use the `JOIN` clause to specify the joined values from other tables on which to base the attribute clustering. You can specify a maximum of four `JOIN` clauses.
***cluster_clause***
Use this clause to specify the type of ordering to use for the table: linear ordering or interleaved ordering. If you do not specify the `LINEAR` or `INTERLEAVED` keyword, then the default is `LINEAR`.
**BY LINEAR ORDER**
Use this clause to specify linear ordering. This type of ordering stores data according to the order of the specified columns. If you specify this clause, then you can specify only one clustering column group, which can contain at most 10 columns.
**BY INTERLEAVED ORDER**
Use this clause to specify interleaved ordering. This type of ordering uses a special multidimensional clustering technique, similar to z-ordering, that permits multicolumn clustering. If you specify this clause, then you can specify at most four clustering column groups, with a maximum of 40 columns across all groups.
***clustering_columns***
Use this clause to specify one or more clustering column groups.
***clustering_column_group***
Use this clause to specify one or more columns to be included in the clustering column group.
**Restriction on Attribute Clustering Columns**
Each character column in the clustering column group must have one of the following declared collations: `BINARY` or `USING_NLS_COMP`.
***clustering_when***
Use these clauses to allow or disallow attribute clustering during direct-path insert operations and data movement operations.
**ON LOAD**
Specify `YES` `ON` `LOAD` to allow, or `NO` `ON` `LOAD` to disallow, attribute clustering during direct-path inserts (serial or parallel) resulting either from an `INSERT` or a `MERGE` operation.
The default is `YES` `ON` `LOAD`.
**ON DATA MOVEMENT**
Specify `YES` `ON` `DATA` `MOVEMENT` to allow, or `NO` `ON` `DATA` `MOVEMENT` to disallow, attribute clustering for data movement that occurs during the following operations:
- Data redefinition using the DBMS_REDEFINITION package
````********
- Table partition maintenance operations that are specified by the following clauses of ALTER TABLE: coalesce_table, merge_table_partitions, move_table_partition, and split_table_partition
The default is `YES` `ON` `DATA` `MOVEMENT`.
***zonemap_clause*** Use this clause to create a zone map on the table. The zone map tracks the columns specified in the *clustering_columns* clause.
``````******
- Specify WITH MATERIALIZED ZONEMAP to create a zone map. For zonemap_name, specify the name of the zone map to be created. If you omit zonemap_name, then the name of the zone map is ZMAP$_table.
``````
- Specify WITHOUT MATERIALIZED ZONEMAP to not create a zone map. This is the default.
If you subsequently drop the table or use the `ALTER` `TABLE` statement to `DROP` `CLUSTERING` or `MODIFY` `CLUSTERING` … `WITHOUT` `MATERIALIZED` `ZONEMAP`, then the zone map will be dropped.
**See Also:**   CREATE MATERIALIZED ZONEMAP for more information on zone maps **Restrictions on Attribute Clustering** The following restrictions apply to attribute clustering:
- Attribute clustering is not supported for temporary tables or external tables.
**
- The table being created must be a heap-organized table. However, tables specified in the clustering_join clause can be heap-organized or index-organized tables.
- Clustering columns must be of a scalar data type and cannot be encrypted.
``````
- If you specify BY LINEAR ORDER, then you can specify only one clustering column group, which can contain at most 10 columns.
``````
- If you specify BY INTERLEAVED ORDER, then you can specify at most four clustering column groups, with a maximum of 40 columns across all groups.
  - The number of dimension tables cannot exceed four.
  - The join to the table or tables providing the attribute clustering columns must be on a unique key or primary key column to avoid row duplication.
- Attribute clustering will not order rows that are inserted using MERGE statements or multitable insert operations.
## CACHE | NOCACHE | CACHE READS
Use these clauses to indicate how Oracle Database should store blocks in the buffer cache. For LOB storage, you can specify `CACHE`, `NOCACHE`, or `CACHE` `READS`. For other types of storage, you can specify only `CACHE` or `NOCACHE`.
If you omit these clauses, then:
``````
- In a CREATE TABLE statement, NOCACHE is the default.
````
- In an ALTER TABLE statement, the existing value is not changed.
The behavior of `CACHE` and `NOCACHE` described in this section does not apply when Oracle Database chooses to use direct reads or to perform table scans using parallel query.
**CACHE** For data that is accessed frequently, this clause indicates that the blocks retrieved for this table are placed at the most recently used end of the least recently used (LRU) list in the buffer cache when a full table scan is performed. This attribute is useful for small lookup tables.
**See Also:**   *Oracle Database Concepts* for more information on how the database maintains the least recently used (LRU) list As a parameter in the *LOB_storage_clause*, `CACHE` specifies that the database places LOB data values in the buffer cache for faster access. The database evaluates this parameter in conjunction with the *logging_clause*. If you omit this clause, then the default value for both BasicFiles and SecureFiles LOBs is `NOCACHE` `LOGGING`.
**Restriction on CACHE** You cannot specify `CACHE` for an index-organized table. However, index-organized tables implicitly provide `CACHE` behavior.
**NOCACHE** For data that is not accessed frequently, this clause indicates that the blocks retrieved for this table are placed at the least recently used end of the LRU list in the buffer cache when a full table scan is performed. `NOCACHE` is the default for LOB storage.
As a parameter in the *LOB_storage_clause*, `NOCACHE` specifies that the LOB values are not brought into the buffer cache. `NOCACHE` is the default for LOB storage.
**Restriction on NOCACHE** You cannot specify `NOCACHE` for an index-organized table.
**CACHE READS** `CACHE` `READS` applies only to LOB storage. It specifies that LOB values are brought into the buffer cache only during read operations but not during write operations.
***logging_clause*** Use this clause to indicate whether the storage of data blocks should be logged or not.
**See Also:**   *logging_clause* for a description of the *logging_clause* when specified as part of *LOB_parameters*
## RESULT_CACHE Clause
Use this clause to determine whether the results of statements or query blocks that name this table are considered for storage in the result cache. Two modes of result caching are available:
``````````
- DEFAULT: Result caching is not determined at the table level. The query is considered for result caching if the RESULT_CACHE_MODE initialization parameter is set to FORCE, or if that parameter is set to MANUAL and the RESULT_CACHE hint is specified in the query. This is the default if you omit this clause.
````````
- FORCE: If all tables names in the query have this setting, then the query is always considered for caching unless the NO_RESULT_CACHE hint is specified for the query. If one or more tables named in the query are set to DEFAULT, then the effective table annotation for that query is considered to be DEFAULT, with the semantics described above.
You can query the `RESULT_CACHE` column of the `DBA_`, `ALL_`, and `USER_TABLES` data dictionary views to learn the result cache mode of the table.
The `RESULT_CACHE` and `NO_RESULT_CACHE` SQL hints take precedence over these result cache table annotations and the `RESULT_CACHE_MODE` initialization parameter. The `RESULT_CACHE_MODE` setting of `FORCE` in turn takes precedence over this table annotation clause.
**Note:**   The `RESULT_CACHE_MODE` setting of `FORCE` is not recommended, as it can cause significant performance and latching overhead, as database and clients will try to cache all queries.
```

```
## *parallel_clause*
The *parallel_clause* lets you parallelize creation of the table and set the default degree of parallelism for queries and the DML `INSERT`, `UPDATE`, `DELETE`, and `MERGE` after table creation.
**Note:**   The syntax of the *parallel_clause* supersedes syntax appearing in earlier releases of Oracle. The superseded syntax is still supported for backward compatibility, but may result in slightly different behavior from that documented.
**NOPARALLEL** Specify `NOPARALLEL` for serial execution. This is the default.
**PARALLEL** Specify `PARALLEL` if you want Oracle to select a degree of parallelism equal to the number of CPUs available on all participating instances times the value of the `PARALLEL_THREADS_PER_CPU` initialization parameter.
**PARALLEL** ***integer*** Specification of *integer* indicates the **degree of parallelism**, which is the number of parallel threads used in the parallel operation. Each parallel thread may use one or two parallel execution servers. Normally Oracle calculates the optimum degree of parallelism, so it is not necessary for you to specify *integer*.
**See Also:**   *parallel_clause* for more information on this clause
## NOROWDEPENDENCIES | ROWDEPENDENCIES
This clause lets you specify whether *table* will use **row-level dependency tracking**. With this feature, each row in the table has a system change number (SCN) that represents a time greater than or equal to the commit time of the last transaction that modified the row. You cannot change this setting after *table* is created.
**ROWDEPENDENCIES** Specify `ROWDEPENDENCIES` if you want to enable row-level dependency tracking. This setting is useful primarily to allow for parallel propagation in replication environments. It increases the size of each row by 6 bytes.
**Restriction on the ROWDEPENDENCIES Clause** Oracle does not support table compression for tables that use row-level dependency tracking. If you specify both the `ROWDEPENDENCIES` clause and the *table_compression* clause, then the *table_compression* clause is ignored. To remove the `ROWDEPENDENCIES` attribute, you must redefine the table using the `DBMS_REDEFINITION` package or recreate the table.
**NOROWDEPENDENCIES** Specify `NOROWDEPENDENCIES` if you do not want *table* to use the row-level dependency tracking feature. This is the default.
## *enable_disable_clause*
The *enable_disable_clause* lets you specify whether Oracle Database should apply a constraint. By default, constraints are created in `ENABLE` `VALIDATE` state.
**Restrictions on Enabling and Disabling Constraints** Enabling and disabling constraints are subject to the following restrictions:
- To enable or disable any integrity constraint, you must have defined the constraint in this or a previous statement.
- You cannot enable a foreign key constraint unless the referenced unique or primary key constraint is already enabled.
****````******
- In the index_properties clause of the using_index_clause, the INDEXTYPE IS ... clause is not valid in the definition of a constraint. See Also: constraint for more information on constraints and “Creating a Table: ENABLE/DISABLE Examples”
**ENABLE Clause** Use this clause if you want the constraint to be applied to the data in the table. This clause is described fully in “ENABLE Clause” in the documentation on constraints.
**DISABLE Clause** Use this clause if you want to disable the integrity constraint. This clause is described fully in “DISABLE Clause” in the documentation on constraints.
**UNIQUE** The `UNIQUE` clause lets you enable or disable the unique constraint defined on the specified column or combination of columns.
**PRIMARY KEY** The `PRIMARY` `KEY` clause lets you enable or disable the primary key constraint defined on the table.
**CONSTRAINT** The `CONSTRAINT` clause lets you enable or disable the integrity constraint named *constraint_name*.
**KEEP | DROP INDEX** This clause lets you either preserve or drop the index Oracle Database has been using to enforce a unique or primary key constraint.
**Restriction on Preserving and Dropping Indexes** You can specify this clause only when disabling a unique or primary key constraint.
## *using_index_clause*
The *using_index_clause* lets you specify an index for Oracle Database to use to enforce a unique or primary key constraint, or lets you instruct the database to create the index used to enforce the constraint.
**See Also:** ********
- CREATE INDEX for a description of index_attributes, the global_partitioned_index and local_partitioned_index clauses, NOSORT, and the logging_clause in relation to indexes
****``````
- constraint for information on the using_index_clause and on PRIMARY KEY and UNIQUE constraints
- “Explicit Index Control Example” for an example of using an index to enforce a constraint
## CASCADE
Specify `CASCADE` to disable any integrity constraints that depend on the specified integrity constraint. To disable a primary or unique key that is part of a referential integrity constraint, you must specify this clause.
**Restriction on CASCADE** You can specify `CASCADE` only if you have specified `DISABLE`.
## *row_movement_clause*
The *row_movement_clause* lets you specify whether the database can move a table row. It is possible for a row to move, for example, during table compression or an update operation on partitioned data.
**Note:**   If you need static rowids for data access, then do not enable row movement. For a normal (heap-organized) table, moving a row changes the rowid of the row. For a moved row in an index-organized table, the logical rowid remains valid, although the physical guess component of the logical rowid becomes inaccurate.
- Specify ENABLE to allow the database to move a row, thus changing the rowid.
- Specify DISABLE if you want to prevent the database from moving a row, thus preventing a change of rowid.
If you omit this clause, then the database disables row movement.
**Restriction on Row Movement** You cannot specify this clause for a nonpartitioned index-organized table.
## *flashback_archive_clause*
You must have the `FLASHBACK` `ARCHIVE` object privilege on the specified flashback archive to specify this clause. Use this clause to enable or disable historical tracking for the table.
````**
****
- Specify FLASHBACK ARCHIVE to enable tracking for the table. You can specify flashback_archive to designate a particular flashback archive for this table. The flashback archive you specify must already exist. If you omit flashback_archive, then the database uses the default flashback archive designated for the system. If no default flashback archive has been designated for the system, then you must specify flashback_archive.
``````
- Specify NO FLASHBACK ARCHIVE to disable tracking for the table. This is the default.
**Restrictions on** ***flashback_archive_clause*** Flashback data archives are subject to the following restrictions:
- You cannot specify this clause for a nested table, clustered table, temporary table, remote table, or external table.
- You cannot specify this clause for a table compressed with Hybrid Columnar Compression.
- The table for which you are specifying this clause cannot contain any LONG or nested table columns.
```
**See Also:**
- [*Oracle Database Development Guide*](/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/sqlrf&id=ADFNS01011) for general information on using Flashback Time Travel
- [ALTER FLASHBACK ARCHIVE](ALTER-FLASHBACK-ARCHIVE.html#GUID-285814C9-06ED-4BDB-BB19-E2BA6505C850) for information on changing the quota and retention attributes of the flashback archive, as well as adding or changing tablespace storage for the flashback archive
```
- If you specify this clause and subsequently copy the table to a different database—using the export and import utilities or the transportable tablespace feature—then the copied table will not be enabled for tracking and the archived data for the original table will not be available for the copied table.
## ROW ARCHIVAL
Specify this clause to enable *table* for row archival. This clause lets you implement In-Database Archiving, which allows you to designate table rows as active or archived. You can then perform queries on only the active rows within the table.
When you specify this clause, a hidden column `ORA_ARCHIVE_STATE` is created in the table. The column is of data type `VARCHAR2`. You can specify a value of `0` or `1` for this column to indicate whether a row is active (`0`) or archived (`1`). If you do not specify a value for `ORA_ARCHIVE_STATE` when inserting data into the table, then the value is set to `0`.
``````````
- If ROW ARCHIVE VISIBILITY = ACTIVE for the session, then the database will consider only active rows when performing queries on the table.
``````````
- If ROW ARCHIVE VISIBILITY = ALL for the session, then the database will consider all rows when performing queries on the table.
**See Also:**
````
- The ALTER SESSION Semantics clause to learn how to configure row archival visibility for a session
````
- The ALTER TABLE [NO] ROW ARCHIVAL clause to learn how to enable or disable an existing table for row archival
**
- Oracle Database VLDB and Partitioning Guide for more information on In-Database Archiving
## FOR EXCHANGE WITH TABLE
This clause lets you create a table that matches the structure of an existing partitioned table. The two tables are then eligible for exchanging partitions and subpartitions. For *table*, specify an existing partitioned table. For *schema*, specify the schema that contains the existing partitioned table. If you omit *schema*, then the database assumes the table is in your own schema.
This operation creates a metadata clone, without data, of the partitioned table. The clone has the same column ordering and column properties of the original table. Column properties copied to the clone during this operation include unusable columns, invisible columns, virtual expression columns, functional index expression columns, and other internal settings and attributes. Indexes on the existing partitioned table are not created on the clone table.
You can subsequently use the *exchange_partition_subpart* clause of `ALTER` `TABLE` to exchange partitions or subpartitions between the two tables. Refer to exchange_partition_subpart in the documentation on `ALTER` `TABLE` for more information.
**Restrictions on FOR EXCHANGE WITH TABLE** Each super sharding or sharding key column with a character data type must have one of the following declared collations: `BINARY`, `USING_NLS_COMP`, `USING_NLS_SORT`, or `USING_NLS_SORT_CS`.
The following restrictions apply to the `FOR` `EXCHANGE` `WITH` `TABLE` clause:
**
- If you specify this clause, then you cannot specify the relational_properties clause.
****
- If you specify this clause, then within the table_properties clause, you can specify only the table_partitioning_clause.
````````
- Within the table_partitioning_clause each key column with a character data type must have one of the following declared collations: BINARY, USING_NLS_COMP, USING_NLS_SORT, or USING_NLS_SORT_CS.
**
- When you create a clone for a partition of a composite-partitioned table, you must explicitly specifying the appropriate table_partitioning_clause that matches exactly the subpartitioning of the partition you want to exchange.
- You cannot create a clone of a partitioned index-organized table.
**
- Oracle does not clone the statistics setup of the partitioned table. For example, if you plan to perform an exchange with a partitioned table for which incremental statistics are enabled, you must manually enable the creation of a table synopsis on the clone table. See Oracle Database SQL Tuning Guide for more information on maintaining incremental statistics on partitioned tables.
You cannot use this clause if you have VPD policies enabled on the target table.
## AS*subquery*
Specify a subquery to determine the contents of the table. The rows returned by the subquery are inserted into the table upon its creation.
For object tables, *subquery* can contain either one expression corresponding to the table type, or the number of top-level attributes of the table type. Refer to SELECT for more information.
If *subquery* returns the equivalent of part or all of an existing materialized view, then the database may rewrite the query to use the materialized view in place of one or more tables specified in *subquery*.
**See Also:**   *Oracle Database Data Warehousing Guide* for more information on materialized views and query rewrite
Oracle Database derives data types and lengths from the subquery. Oracle Database follows the following rules for integrity constraints and other column and table attributes:
``````````
- Oracle Database automatically defines on columns in the new table any NOT NULL constraints that have a state of NOT DEFERRABLE and VALIDATE, and were explicitly created on the corresponding columns of the selected table if the subquery selects the column rather than an expression containing the column. If any rows violate the constraint, then the database does not create the table and returns an error.
````
- NOT NULL constraints that were implicitly created by Oracle Database on columns of the selected table (for example, for primary keys) are not carried over to the new table.
- In addition, primary keys, unique keys, foreign keys, check constraints, partitioning criteria, indexes, and column default values are not carried over to the new table.
``````**
- If the selected table is partitioned, then you can choose whether the new table will be partitioned the same way, partitioned differently, or not partitioned. Partitioning is not carried over to the new table. Specify any desired partitioning as part of the CREATE TABLE statement before the AS subquery clause.
****
- A column that is encrypted using Transparent Data Encryption in the selected table will not be encrypted in the new table unless you define the column in the new table as encrypted at create time. Note: Oracle recommends that you encrypt sensitive columns before populating them with data. This will avoid creating clear text copies of sensitive data.
If each column returned by *subquery* has a column name or is an expression with a specified column alias, then you can omit the columns from the table definition entirely. In this case, the names of the columns of *table* are the same as the columns in *subquery*. The exception is creating an index-organized table, for which you must specify the columns in the table definition because you must specify a primary key column.
You can use *subquery* in combination with the `TO_LOB` function to convert the values in a `LONG` column in another table to LOB values in a column of the table you are creating.
**See Also:** **
- Oracle Database SecureFiles and Large Objects Developer’s Guide for a discussion of why and when to copy LONG data to a LOB
- “Conversion Functions” for a description of how to use the TO_LOB function
**
- SELECT for more information on the order_by_clause
****
- Oracle Database SQL Tuning Guide for information on statistics gathering when using the AS subquery clause
***parallel_clause*** If you specify the *parallel_clause* in this statement, then the database will ignore any value you specify for the `INITIAL` storage parameter and will instead use the value of the `NEXT` parameter.
**See Also:**   *storage_clause* for information on these parameters **ORDER BY** The `ORDER` `BY` clause lets you order rows returned by the subquery.
When specified with `CREATE` `TABLE`, this clause does not necessarily order data across the entire table. For example, it does not order across partitions. Specify this clause if you intend to create an index on the same key as the `ORDER` `BY` key column. Oracle Database will cluster data on the `ORDER` `BY` key so that it corresponds to the index key.
**Restrictions on the Defining Query of a Table** The table query is subject to the following restrictions:
- The number of columns in the table must equal the number of expressions in the subquery.
- The column definitions can specify only column names, default values, and integrity constraints, not data types.
``````**````
- You cannot define a foreign key constraint in a CREATE TABLE statement that contains AS subquery unless the table is reference partitioned and the constraint is the table’s partitioning referential constraint. In all other cases, you must create the table without the constraint and then add it later with an ALTER TABLE statement.
## *object_table*
The `OF` clause lets you explicitly create an **object table** of type *object_type*. The columns of an object table correspond to the top-level attributes of type *object_type*. Each row will contain an object instance, and each instance will be assigned a unique, system-generated object identifier when a row is inserted. If you omit *schema*, then the database creates the object table in your own schema.
Object tables, as well as `XMLType` tables, object views, and `XMLType` views, do not have any column names specified for them. Therefore, Oracle defines a system-generated pseudocolumn `OBJECT_ID`. You can use this column name in queries and to create object views with the `WITH` `OBJECT` `IDENTIFIER` clause.
**See Also:**   “Object Column and Table Examples”
***object_table_substitution***
Use the *object_table_substitution* clause to specify whether row objects corresponding to subtypes can be inserted into this object table.
**NOT SUBSTITUTABLE AT ALL LEVELS**
`NOT` `SUBSTITUTABLE` `AT` `ALL` `LEVELS` indicates that the object table being created is not substitutable. In addition, substitution is disabled for all embedded object attributes and elements of embedded nested tables and arrays. The default is `SUBSTITUTABLE` `AT` `ALL` `LEVELS`.
**See Also:**
- CREATE TYPE for more information about creating object types
**
- ”\ User-Defined Types”, “About User-Defined Functions”, “About SQL Expressions”, CREATE TYPE, and Oracle Database Object-Relational Developer’s Guide for more information about using REF types
***object_properties***
The properties of object tables are essentially the same as those of relational tables. However, instead of specifying columns, you specify attributes of the object.
For *attribute*, specify the qualified column name of an item in an object.
***oid_clause***
The *oid_clause* lets you specify whether the object identifier of the object table should be system generated or should be based on the primary key of the table. The default is `SYSTEM` `GENERATED`.
**Restrictions on the** ***oid_clause***
This clause is subject to the following restrictions:
``````````````
- You cannot specify OBJECT IDENTIFIER IS PRIMARY KEY unless you have already specified a PRIMARY KEY constraint for the table.
****
- You cannot specify this clause for a nested table. Note: A primary key object identifier is locally unique but not necessarily globally unique. If you require a globally unique identifier, then you must ensure that the primary key is globally unique.
***oid_index_clause*** This clause is relevant only if you have specified the *oid_clause* as `SYSTEM` `GENERATED`. It specifies an index, and optionally its storage characteristics, on the hidden object identifier column.
For *index*, specify the name of the index on the hidden system-generated object identifier column. If you omit *index*, then the database generates a name.
***physical_properties*** **and** ***table_properties*** The semantics of these clauses are documented in the corresponding sections under relational tables. See *physical_properties* and *table_properties*.
## *XMLType_table*
Use the *XMLType_table* syntax to create a table of data type `XMLType`. Most of the clauses used to create an `XMLType` table have the same semantics that exist for object tables. The clauses specific to `XMLType` tables are described in this section.
Object tables, as well as `XMLType` tables, object views, and `XMLType` views, do not have any column names specified for them. Therefore, Oracle defines a system-generated pseudocolumn `OBJECT_ID`. You can use this column name in queries and to create object views with the `WITH` `OBJECT` `IDENTIFIER` clause.
***XMLSchema_spec*** This clause lets you specify the URL of a registered XMLSchema, either in the `XMLSCHEMA` clause or as part of the `ELEMENT` clause, and an XML element name.
You must specify an element, although the XMLSchema URL is optional. If you do specify an XMLSchema URL, then you must already have registered the XMLSchema using the `DBMS_XMLSCHEMA` package.
The optional `STORE` `ALL` `VARRAYS` `AS` clause lets you specify how all varrays in the `XMLType` table or column are to be stored.
``````````
- STORE ALL VARRAYS AS LOBS indicates that all varrays are to be stored as LOBs.
``````````
- STORE ALL VARRAYS AS TABLES indicates that all varrays are to be stored as tables.
The optional `ALLOW` | `DISALLOW` clauses are valid only if you have specified `BINARY` `XML` storage.
``````
- ALLOW NONSCHEMA indicates that non-schema-based documents can be stored in the XMLType column.
``````
- DISALLOW NONSCHEMA indicates that non-schema-based documents cannot be stored in the XMLType column. This is the default.
``````
- ALLOW ANYSCHEMA indicates that any schema-based document can be stored in the XMLType column.
``````
- DISALLOW ANYSCHEMA indicates that any schema-based document cannot be stored in the XMLType column. This is the default.
**See Also:** **
- Oracle Database PL/SQL Packages and Types Reference for information on the DBMS_XMLSCHEMA package
**
- Oracle XML DB Developer’s Guide for information on creating and working with XML data
- “XMLType Table Examples”
## MEMOPTIMIZE FOR READ
Use this clause to enable fast lookup. Fast lookup improves the performance high frequency data query operations. The `MEMOPTIMIZE_POOL_SIZE` initialization parameter controls the size of the memoptimize pool. Note that the feature uses additional memory from the SGA.
- You must specify this clause as a top-level attribute of the table, it cannot be specified at the partition or subpartition level.
- You must explicitly enable the table for MEMOPTIMIZE FOR READ before you can read data from the table.
## MEMOPTIMIZE FOR WRITE
Use this clause to enable fast ingest. Fast ingest optimizes memory processing of high frequency single row data inserts from Internet of Things (IoT) applications.
- MEMOPTIMZE FOR WRITE is a top-level attribute and cannot be used at the partition or subpartition level.
- A table must be enabled for MEMOPTIMIZE FOR WRITE before data for that table can be written to the IGA.
**Restrictions** Blockchain and immutable tables do not support `MEMOPTIMZE FOR WRITE`.
Columns of `BFILE` datatype do not support `MEMOPTIMZE FOR WRITE`.
## PARENT
You can use this clause to create a child table in a sharded table family.
A sharded table family is a set of tables that are sharded in the same way. Corresponding partitions of all tables in a table family are stored in the same shard. This enables you to minimize the number of multishard joins when querying data in the table family.
There are two methods for creating a sharded table family. The recommended method involves using reference partitioning. However, if it is impossible or undesirable to create the primary and foreign key constraints that are required for reference partitioning, then you can use the `PARENT` clause to create a sharded table family.
The rules for creating a sharded table family differ depending on which method you use. When you create a sharded table family by using the `PARENT` clause, the following rules apply:
- The sharded table family can contain only two levels of tables: a parent table, and one or more child tables.
- All tables in the family must be explicitly partitioned using the same partitioning scheme. Each table can use a different subpartitioning scheme, or none at all.
- You must first create the parent table, and it must be a sharded table.
````````******
- You can then use the CREATE SHARDED TABLE ... PARENT ... statement to create each child table. For table, specify the name of the parent table. For schema, specify the schema that contains the parent table. If you omit schema, then the database assumes the parent table is in your own schema.
You can create multiple sharded table families with system sharding but at most one with composite or user-defined sharding.
**See Also:**   *Using Oracle Sharding*
## Examples
**Creating Tables: General Examples**
This statement shows how the `employees` table owned by the sample human resources (`hr`) schema was created. A hypothetical name is given to the table and constraints so that you can duplicate this example in your test database:
```
CREATE TABLE employees_demo ( employee_id    NUMBER(6) , first_name     VARCHAR2(20) , last_name      VARCHAR2(25) CONSTRAINT emp_last_name_nn_demo NOT NULL , email          VARCHAR2(25) CONSTRAINT emp_email_nn_demo     NOT NULL , phone_number   VARCHAR2(20) , hire_date      DATE  DEFAULT SYSDATE CONSTRAINT emp_hire_date_nn_demo  NOT NULL , job_id         VARCHAR2(10) CONSTRAINT     emp_job_nn_demo  NOT NULL , salary         NUMBER(8,2) CONSTRAINT     emp_salary_nn_demo  NOT NULL , commission_pct NUMBER(2,2) , manager_id     NUMBER(6) , department_id  NUMBER(4) , dn             VARCHAR2(300) , CONSTRAINT     emp_salary_min_demo CHECK (salary > 0) , CONSTRAINT     emp_email_uk_demo UNIQUE (email) ) ;
```
This table contains twelve columns. The `employee_id` column is of data type `NUMBER`. The `hire_date` column is of data type `DATE` and has a default value of `SYSDATE`. The `last_name` column is of type `VARCHAR2` and has a `NOT` `NULL` constraint, and so on.
**Creating a Table: Storage Example**
To define the same `employees_demo` table in the `example` tablespace with a small storage capacity, issue the following statement:
```
CREATE TABLE employees_demo ( employee_id    NUMBER(6) , first_name     VARCHAR2(20) , last_name      VARCHAR2(25) CONSTRAINT emp_last_name_nn_demo NOT NULL , email          VARCHAR2(25) CONSTRAINT emp_email_nn_demo     NOT NULL , phone_number   VARCHAR2(20) , hire_date      DATE  DEFAULT SYSDATE CONSTRAINT emp_hire_date_nn_demo  NOT NULL , job_id         VARCHAR2(10) CONSTRAINT     emp_job_nn_demo  NOT NULL , salary         NUMBER(8,2) CONSTRAINT     emp_salary_nn_demo  NOT NULL , commission_pct NUMBER(2,2) , manager_id     NUMBER(6) , department_id  NUMBER(4) , dn             VARCHAR2(300) , CONSTRAINT     emp_salary_min_demo CHECK (salary > 0) , CONSTRAINT     emp_email_uk_demo UNIQUE (email) ) TABLESPACE example STORAGE (INITIAL 8M);
```
**Creating a Table with a DEFAULT ON NULL Column Value: Example**
The following statement creates a table `myemp`, which can be used to store employee data. The `department_id` column is defined with a `DEFAULT` `ON` `NULL` column value of 50. Therefore, if a subsequent `INSERT` statement attempts to assign a NULL value to `department_id`, then the value of 50 will be assigned instead.
```
CREATE TABLE myemp (employee_id number, last_name varchar2(25), department_id NUMBER DEFAULT ON NULL 50 NOT NULL);
```
In the `employees` table, `employee_id` 178 has a NULL value for `department_id`:
```
SELECT employee_id, last_name, department_id FROM employees WHERE department_id IS NULL;
EMPLOYEE_ID LAST_NAME                 DEPARTMENT_ID
----------- ------------------------- -------------
178 Grant
```
Populate the `myemp` table with the `employee_id`, `last_name`, and `department_id` column data from the `employees` table:
```
INSERT INTO myemp (employee_id, last_name, department_id) (SELECT employee_id, last_name, department_id from employees);
```
In the `myemp` table, `employee_id` 178 has a value of 50 for `department_id`:
```
SELECT employee_id, last_name, department_id FROM myemp WHERE employee_id = 178;
EMPLOYEE_ID LAST_NAME                 DEPARTMENT_ID
----------- ------------------------- -------------
178 Grant                                50
```
**Creating a Table with an Identity Column: Examples**
The following statement creates a table `t1` with an identity column `id`. The sequence generator will always assign increasing integer values to `id`, starting with `1`.
```
CREATE TABLE t1 (id NUMBER GENERATED AS IDENTITY);
```
The following statement creates a table `t2` with an identity column `id`. The sequence generator will, by default, assign increasing integer values to `id` in increments of 10 starting with 100.
```
CREATE TABLE t2 (id NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 100 INCREMENT BY 10));
```
**Creating a Table: Temporary Table Example**
The following statement creates a temporary table `today_sales` for use by sales representatives in the sample database. Each sales representative session can store its own sales data for the day in the table. The temporary data is deleted at the end of the session.
```
CREATE GLOBAL TEMPORARY TABLE today_sales ON COMMIT PRESERVE ROWS AS SELECT * FROM orders WHERE order_date = SYSDATE;
```
**Creating a Table with Deferred Segment Creation: Example**
The following statement creates a table with deferred segment creation. Oracle Database will not create a segment for the data of this table until data is inserted into the table:
```
CREATE TABLE later (col1 NUMBER, col2 VARCHAR2(20))    SEGMENT CREATION DEFERRED;
```
**Substitutable Table and Column Examples**
The following statements create a type hierarchy, which can be used to create a substitutable table. Type `employee_t` inherits the `name` and `ssn` attributes from type `person_t` and in addition has `department_id` and `salary` attributes. Type `part_time_emp_t` inherits all of the attributes from `employee_t` and, through `employee_t`, those of `person_t` and in addition has a `num_hrs` attribute. Type `part_time_emp_t` is final by default, so no further subtypes can be created under it.
```
CREATE TYPE person_t AS OBJECT (name VARCHAR2(100), ssn NUMBER) NOT FINAL;
/ CREATE TYPE employee_t UNDER person_t (department_id NUMBER, salary NUMBER) NOT FINAL;
/ CREATE TYPE part_time_emp_t UNDER employee_t (num_hrs NUMBER);
/
```
The following statement creates a substitutable table from the `person_t` type:
```
CREATE TABLE persons OF person_t;
```
The following statement creates a table with a substitutable column of type `person_t`:
```
CREATE TABLE books (title VARCHAR2(100), author person_t);
```
When you insert into `persons` or `books`, you can specify values for the attributes of `person_t` or any of its subtypes. Examples of insert statements appear in “Inserting into a Substitutable Tables and Columns: Examples”.
You can extract data from such tables using built-in functions and conditions. For examples, see the functions TREAT and SYS_TYPEID, and the “IS OF type Condition” condition.
**Creating a Table: Parallelism Examples**
The following statement creates a table using an optimum number of parallel execution servers to scan `employees` and to populate `dept_80`:
```
CREATE TABLE dept_80 PARALLEL AS SELECT * FROM employees WHERE department_id = 80;
```
Using parallelism speeds up the creation of the table, because the database uses parallel execution servers to create the table. After the table is created, querying the table is also faster, because the same degree of parallelism is used to access the table.
The following statement creates the same table serially. Subsequent DML and queries on the table will also be serially executed.
```
CREATE TABLE dept_80 AS SELECT * FROM employees WHERE department_id = 80;
```
**Creating a Table: ENABLE/DISABLE Examples**
The following statement shows how the sample table `departments` was created. The example defines a `NOT` `NULL` constraint, and places it in `ENABLE` `VALIDATE` state. A hypothetical name is given to the table so that you can duplicate this example in your test database:
```
CREATE TABLE departments_demo ( department_id    NUMBER(4) , department_name  VARCHAR2(30) CONSTRAINT  dept_name_nn  NOT NULL , manager_id       NUMBER(6) , location_id      NUMBER(4) , dn               VARCHAR2(300) ) ;
```
The following statement creates the same `departments_demo` table but also defines a disabled primary key constraint:
```
CREATE TABLE departments_demo ( department_id    NUMBER(4)   PRIMARY KEY DISABLE , department_name  VARCHAR2(30) CONSTRAINT  dept_name_nn  NOT NULL , manager_id       NUMBER(6) , location_id      NUMBER(4) , dn               VARCHAR2(300) ) ;
```
**Nested Table Example**
The following statement shows how the sample table `pm.print_media` was created with a nested table column `ad_textdocs_ntab`:
```
CREATE TABLE print_media ( product_id        NUMBER(6) , ad_id             NUMBER(6) , ad_composite      BLOB , ad_sourcetext     CLOB , ad_finaltext      CLOB , ad_fltextn        NCLOB , ad_textdocs_ntab  textdoc_tab , ad_photo          BLOB , ad_graphic        BFILE , ad_header         adheader_typ ) NESTED TABLE ad_textdocs_ntab STORE AS textdocs_nestedtab;
```
**Creating a Table: Multilevel Collection Example**
The following example shows how an account manager might create a table of customers using two levels of nested tables:
```
CREATE TYPE phone AS OBJECT (telephone NUMBER);
/ CREATE TYPE phone_list AS TABLE OF phone;
/ CREATE TYPE my_customers AS OBJECT ( cust_name VARCHAR2(25), phones phone_list);
/ CREATE TYPE customer_list AS TABLE OF my_customers;
/ CREATE TABLE business_contacts ( company_name VARCHAR2(25), company_reps customer_list) NESTED TABLE company_reps STORE AS outer_ntab (NESTED TABLE phones STORE AS inner_ntab);
```
The following variation of this example shows how to use the `COLUMN_VALUE` keyword if the inner nested table has no column or attribute name:
```
CREATE TYPE phone AS TABLE OF NUMBER;
/ CREATE TYPE phone_list AS TABLE OF phone;
/ CREATE TABLE my_customers ( name VARCHAR2(25), phone_numbers phone_list) NESTED TABLE phone_numbers STORE AS outer_ntab (NESTED TABLE COLUMN_VALUE STORE AS inner_ntab);
```
**Creating a Table: LOB Column Example**
The following statement is a variation of the statement that created the `pm.print_media` table with some added LOB storage characteristics:
```
CREATE TABLE print_media_new ( product_id        NUMBER(6) , ad_id             NUMBER(6) , ad_composite      BLOB , ad_sourcetext     CLOB , ad_finaltext      CLOB , ad_fltextn        NCLOB , ad_textdocs_ntab  textdoc_tab , ad_photo          BLOB , ad_graphic        BFILE , ad_header         adheader_typ ) NESTED TABLE ad_textdocs_ntab STORE AS textdocs_nestedtab_new LOB (ad_sourcetext, ad_finaltext) STORE AS (TABLESPACE example STORAGE (INITIAL 6144) CHUNK 4000 NOCACHE LOGGING);
```
In the example, the database rounds the value of `CHUNK` up to 4096 (the nearest multiple of the block size of 2048).
**Index-Organized Table Example**
The following statement is a variation of the sample table `hr.countries`, which is index organized:
```
CREATE TABLE countries_demo ( country_id      CHAR(2) CONSTRAINT country_id_nn_demo NOT NULL , country_name    VARCHAR2(40) , currency_name   VARCHAR2(25) , currency_symbol VARCHAR2(3) , region          VARCHAR2(15) , CONSTRAINT    country_c_id_pk_demo PRIMARY KEY (country_id ) ) ORGANIZATION INDEX INCLUDING   country_name PCTTHRESHOLD 2 STORAGE ( INITIAL  4K ) OVERFLOW STORAGE ( INITIAL  4K );
```
**External Table Example**
The following statement creates an external table that represents a subset of the sample table `hr`.`departments`. The `TYPE` clause specifies that the access driver type for the table is `ORACLE_LOADER`. The `ACCESS` `PARAMETERS()` clause specifies parameter values for the `ORACLE_LOADER` access driver. These parameters are shown in italics and form the *opaque_format_spec*. The syntax for *opaque_format_spec* depends on the access driver type and is outside the scope of this document. Refer to *Oracle Database Utilities* for details on the `ORACLE_LOADER` access driver and the *opaque_format_spec* syntax.
```
CREATE TABLE dept_external ( deptno     NUMBER(6), dname      VARCHAR2(20), loc        VARCHAR2(25) ) ORGANIZATION EXTERNAL (TYPE oracle_loader DEFAULT DIRECTORY admin ACCESS PARAMETERS ( RECORDS DELIMITED BY newline BADFILE 'ulcase1.bad' DISCARDFILE 'ulcase1.dis' LOGFILE 'ulcase1.log' SKIP 20 FIELDS TERMINATED BY ","  OPTIONALLY ENCLOSED BY '"' ( deptno     INTEGER EXTERNAL(6), dname      CHAR(20), loc        CHAR(25) ) ) LOCATION ('ulcase1.ctl') ) REJECT LIMIT UNLIMITED;
```
**See Also:**   “Creating a Directory: Examples” to see how the `admin` directory was created
**XMLType Examples**
This section contains brief examples of creating an `XMLType` table or `XMLType` column. For a more expanded version of these examples, refer to “Using XML in SQL Statements”.
**XMLType Table Examples**
The following example creates a very simple `XMLType` table with one implicit binary XML column:
```
CREATE TABLE xwarehouses OF XMLTYPE;
```
The following example creates an XMLSchema-based table. The XMLSchema must already have been created (see “Using XML in SQL Statements” for more information):
```
CREATE TABLE xwarehouses OF XMLTYPE XMLSCHEMA "http://www.example.com/xwarehouses.xsd" ELEMENT "Warehouse";
```
You can define constraints on an XMLSchema-based table, and you can also create indexes on XMLSchema-based tables, which greatly enhance subsequent queries. You can create object-relational views on `XMLType` tables, and you can create `XMLType` views on object-relational tables.
**See Also:**
- “Using XML in SQL Statements” for an example of adding a constraint
- “Creating an Index on an XMLType Table: Example” for an example of creating an index
- “Creating an XMLType View: Example” for an example of creating an XMLType view
**XMLType Column Examples**
The following example creates a table with an `XMLType` column stored as a `CLOB`. This table does not require an XMLSchema, so the content structure is not predetermined:
```
CREATE TABLE xwarehouses ( warehouse_id        NUMBER, warehouse_spec      XMLTYPE) XMLTYPE warehouse_spec STORE AS CLOB (TABLESPACE example STORAGE (INITIAL 6144) CHUNK 4000 NOCACHE LOGGING);
```
The following example creates a similar table, but stores `XMLType` data in an object relational `XMLType` column whose structure is determined by the specified schema:
```
CREATE TABLE xwarehouses ( warehouse_id    NUMBER, warehouse_spec  XMLTYPE) XMLTYPE warehouse_spec STORE AS OBJECT RELATIONAL XMLSCHEMA "http://www.example.com/xwarehouses.xsd" ELEMENT "Warehouse";
```
The following example creates another similar table with an `XMLType` column stored as a SecureFiles `CLOB`. This table does not require an XMLSchema, so the content structure is not predetermined. SecureFiles LOBs require a tablespace with automatic segment-space management, so the example uses the tablespace created in “Specifying Segment Space Management for a Tablespace: Example”.
```
CREATE TABLE xwarehouses ( warehouse_id   NUMBER, warehouse_spec XMLTYPE) XMLTYPE        warehouse_spec STORE AS SECUREFILE CLOB (TABLESPACE auto_seg_ts STORAGE (INITIAL 6144) CACHE);
```
**Partitioning Examples**
**Range Partitioning Example**
The `sales` table in the sample schema `sh` is partitioned by range. The following example shows an abbreviated variation of the `sales` table. Constraints and storage elements have been omitted from the example.
```
CREATE TABLE range_sales ( prod_id        NUMBER(6) , cust_id        NUMBER , time_id        DATE , channel_id     CHAR(1) , promo_id       NUMBER(6) , quantity_sold  NUMBER(3) , amount_sold         NUMBER(10,2) ) PARTITION BY RANGE (time_id) (PARTITION SALES_Q1_1998 VALUES LESS THAN (TO_DATE('01-APR-1998','DD-MON-YYYY')), PARTITION SALES_Q2_1998 VALUES LESS THAN (TO_DATE('01-JUL-1998','DD-MON-YYYY')), PARTITION SALES_Q3_1998 VALUES LESS THAN (TO_DATE('01-OCT-1998','DD-MON-YYYY')), PARTITION SALES_Q4_1998 VALUES LESS THAN (TO_DATE('01-JAN-1999','DD-MON-YYYY')), PARTITION SALES_Q1_1999 VALUES LESS THAN (TO_DATE('01-APR-1999','DD-MON-YYYY')), PARTITION SALES_Q2_1999 VALUES LESS THAN (TO_DATE('01-JUL-1999','DD-MON-YYYY')), PARTITION SALES_Q3_1999 VALUES LESS THAN (TO_DATE('01-OCT-1999','DD-MON-YYYY')), PARTITION SALES_Q4_1999 VALUES LESS THAN (TO_DATE('01-JAN-2000','DD-MON-YYYY')), PARTITION SALES_Q1_2000 VALUES LESS THAN (TO_DATE('01-APR-2000','DD-MON-YYYY')), PARTITION SALES_Q2_2000 VALUES LESS THAN (TO_DATE('01-JUL-2000','DD-MON-YYYY')), PARTITION SALES_Q3_2000 VALUES LESS THAN (TO_DATE('01-OCT-2000','DD-MON-YYYY')), PARTITION SALES_Q4_2000 VALUES LESS THAN (MAXVALUE)) ;
```
For information about partitioned table maintenance operations, see *Oracle Database VLDB and Partitioning Guide*.
**Range Partitioning Live SQL Example**
The following statement creates a table partitioned by range:
```
CREATE TABLE empl_h ( employee_id  NUMBER(6) PRIMARY KEY, first_name   VARCHAR2(20), last_name    VARCHAR2(25), email        VARCHAR2(25), phone_number VARCHAR2(20), hire_date    DATE DEFAULT SYSDATE, job_id       VARCHAR2(10), salary       NUMBER(8, 2), part_name    VARCHAR2(25) ) PARTITION BY RANGE (hire_date) ( PARTITION hire_q1 VALUES less than(to_date('01-APR-2014', 'DD-MON-YYYY')), PARTITION hire_q2 VALUES less than(to_date('01-JUL-2014', 'DD-MON-YYYY')), PARTITION hire_q3 VALUES less than(to_date('01-OCT-2014', 'DD-MON-YYYY')), PARTITION hire_q4 VALUES less than(to_date('01-JAN-2015', 'DD-MON-YYYY')) );
```
The following statements insert rows into the partitions:
```
INSERT INTO empl_h (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, Part_name) VALUES (1, 'Jane', 'Doe', 'example.com', '415.555.0100', '10-Feb-2014', '1001', 5001,'HIRE_Q1');
INSERT INTO empl_h (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, Part_name) VALUES (2, 'John', 'Doe', 'example.net', '415.555.0101', '10-Apr-2014', '1002', 7001,'HIRE_Q2');
INSERT INTO empl_h (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, Part_name) VALUES (3, 'Isabelle', 'Owl', 'example.org', '415.555.0102', '10-Sep-2014', '1003', 10001,'HIRE_Q3');
INSERT INTO empl_h (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, Part_name) VALUES (4, 'Smith', 'Jones', 'example.in', '415.555.0103', '10-Dec-2014', '1004', 12001,'HIRE_Q4');
```
The following statements display the partition names using data dictionary tables:
```
SELECT PARTITION_NAME FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = 'EMPL_H';
PARTITION_NAME
----------------
HIRE_Q1 HIRE_Q2 HIRE_Q3 HIRE_Q4 SELECT TABLE_NAME, PARTITIONING_TYPE, STATUS FROM USER_PART_TABLES WHERE TABLE_NAME = 'EMPL_H';
TABLE_NAME	PARTITIONING_TYPE	STATUS
----------	-----------------	------
EMPL_H		RANGE			VALID
```
The following statement creates a table named `parts` by selecting a particular column from the data dictionary table `user_tab_partitions`:
```
CREATE TABLE parts (p_name) AS SELECT PARTITION_NAME FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = 'EMPL_H';
```
The following statement displays the table data:
```
select * from parts;
P_NAME
-----------
HIRE_Q1 HIRE_Q2 HIRE_Q3 HIRE_Q4
```
The following statement compares the columns from the two tables and displays the information based on the comparison:
```
select E.HIRE_DATE,E.JOB_ID,P.p_name from empl_h E, parts P where E.Part_name = P.p_name;
HIRE_DATE JOB_ID     P_NAME
--------- ---------- ------------
10-FEB-14 1001	     HIRE_Q1 10-APR-14 1002	     HIRE_Q2 10-SEP-14 1003	     HIRE_Q3 10-DEC-14 1004	     HIRE_Q4
```
**Interval Partitioning Example**
The following example creates a variation of the `oe.customers` table that is partitioned by interval on the `credit_limit` column. One range partition is created to establish the transition point. All of the original data in the table is within the bounds of the range partition. Then data is added that exceeds the range partition, and the database creates a new interval partition.
```
CREATE TABLE customers_demo ( customer_id number(6), cust_first_name varchar2(20), cust_last_name varchar2(20), credit_limit number(9,2)) PARTITION BY RANGE (credit_limit) INTERVAL (1000) (PARTITION p1 VALUES LESS THAN (5001));
INSERT INTO customers_demo (customer_id, cust_first_name, cust_last_name, credit_limit) (select customer_id, cust_first_name, cust_last_name, credit_limit from customers);
```
Query the `USER_TAB_PARTITIONS` data dictionary view before the database creates the interval partition:
```
SELECT partition_name, high_value FROM user_tab_partitions  WHERE table_name = 'CUSTOMERS_DEMO';
PARTITION_NAME                 HIGH_VALUE
------------------------------ ---------------
P1                             5001
```
Insert data into the table that exceeds the high value of the range partition:
```
INSERT INTO customers_demo VALUES (699, 'Fred', 'Flintstone', 5500);
```
Query the `USER_TAB_PARTITIONS` view again after the insert to learn the system-generated name of the interval partition created to accommodate the inserted data. (The system-generated name will vary for each session.)
```
SELECT partition_name, high_value FROM user_tab_partitions WHERE table_name = 'CUSTOMERS_DEMO' ORDER BY partition_name;
PARTITION_NAME                 HIGH_VALUE
------------------------------ ---------------
P1                             5001 SYS_P44                        6001
```
**List Partitioning Example**
The following statement shows how the sample table `oe.customers` might have been created as a list-partitioned table. Some columns and all constraints of the sample table have been omitted in this example.
```
CREATE TABLE list_customers ( customer_id             NUMBER(6) , cust_first_name         VARCHAR2(20) , cust_last_name          VARCHAR2(20) , cust_address            CUST_ADDRESS_TYP , nls_territory           VARCHAR2(30) , cust_email              VARCHAR2(40)) PARTITION BY LIST (nls_territory) ( PARTITION asia VALUES ('CHINA', 'THAILAND'), PARTITION europe VALUES ('GERMANY', 'ITALY', 'SWITZERLAND'), PARTITION west VALUES ('AMERICA'), PARTITION east VALUES ('INDIA'), PARTITION rest VALUES (DEFAULT));
```
**Partitioned Table with LOB Columns Example**
This statement creates a partitioned table `print_media_demo` with two partitions `p1` and `p2`, and a number of LOB columns. The statement uses the sample table `pm.print_media`.
```
CREATE TABLE print_media_demo ( product_id NUMBER(6) , ad_id NUMBER(6) , ad_composite BLOB , ad_sourcetext CLOB , ad_finaltext CLOB , ad_fltextn NCLOB , ad_textdocs_ntab textdoc_tab , ad_photo BLOB , ad_graphic BFILE , ad_header adheader_typ ) NESTED TABLE ad_textdocs_ntab STORE AS textdocs_nestedtab_demo LOB (ad_composite, ad_photo, ad_finaltext) STORE AS(STORAGE (INITIAL 20M)) PARTITION BY RANGE (product_id) (PARTITION p1 VALUES LESS THAN (3000) TABLESPACE tbs_01 LOB (ad_composite, ad_photo) STORE AS (TABLESPACE tbs_02 STORAGE (INITIAL 10M)) NESTED TABLE ad_textdocs_ntab STORE AS nt_p1 (TABLESPACE example), PARTITION P2 VALUES LESS THAN (MAXVALUE) LOB (ad_composite, ad_finaltext) STORE AS SECUREFILE (TABLESPACE auto_seg_ts) NESTED TABLE ad_textdocs_ntab STORE AS nt_p2 ) TABLESPACE tbs_03;
```
Partition `p1` will be in tablespace `tbs_01`. The LOB data partitions for `ad_composite` and `ad_photo` will be in tablespace `tbs_02`. The LOB data partition for the remaining LOB columns will be in tablespace `tbs_01`. The storage attribute `INITIAL` is specified for LOB columns `ad_composite` and `ad_photo`. Other attributes will be inherited from the default table-level specification. The default LOB storage attributes not specified at the table level will be inherited from the tablespace `tbs_02` for columns `ad_composite` and `ad_photo` and from tablespace `tbs_01` for the remaining LOB columns. LOB index partitions will be in the same tablespaces as the corresponding LOB data partitions. Other storage attributes will be based on values of the corresponding attributes of the LOB data partitions and default attributes of the tablespace where the index partitions reside. The nested table partition for ad_textdocs_ntab will be stored as `nt_p1` in tablespace `example`.
Partition `p2` will be in the default tablespace `tbs_03`. The LOB data for `ad_composite` and `ad_finaltext` will be in tablespace `auto_seg_ts` as SecureFiles LOBs. The LOB data for the remaining LOB columns will be in tablespace `tbs_03`. The LOB index for columns `ad_composite` and `ad_finaltext` will be in tablespace `auto_seg_ts`. The LOB index for the remaining LOB columns will be in tablespace `tbs_03`. The nested table partition for `ad_textdocs_ntab` will be stored as `nt_p2` in the default tablespace `tbs_03`.
**Hash Partitioning Example**
The sample table `oe.product_information` is not partitioned. However, you might want to partition such a large table by hash for performance reasons, as shown in this example. The tablespace names are hypothetical in this example.
```
CREATE TABLE hash_products ( product_id          NUMBER(6)   PRIMARY KEY , product_name        VARCHAR2(50) , product_description VARCHAR2(2000) , category_id         NUMBER(2) , weight_class        NUMBER(1) , warranty_period     INTERVAL YEAR TO MONTH , supplier_id         NUMBER(6) , product_status      VARCHAR2(20) , list_price          NUMBER(8,2) , min_price           NUMBER(8,2) , catalog_url         VARCHAR2(50) , CONSTRAINT          product_status_lov_demo CHECK (product_status in ('orderable' ,'planned' ,'under development' ,'obsolete') ) ) PARTITION BY HASH (product_id) PARTITIONS 4 STORE IN (tbs_01, tbs_02, tbs_03, tbs_04);
```
**Reference Partitioning Example**
The next statement uses the `hash_products` partitioned table created in the preceding example. It creates a variation of the `oe.order_items` table that is partitioned by reference to the hash partitioning on the product id of `hash_products`. The resulting child table will be created with five partitions. For each row of the child table `part_order_items`, the database evaluates the foreign key value (`product_id`) to determine the partition number of the parent table `hash_products` to which the referenced key belongs. The `part_order_items` row is placed in its corresponding partition.
```
CREATE TABLE part_order_items ( order_id        NUMBER(12) PRIMARY KEY, line_item_id    NUMBER(3), product_id      NUMBER(6) NOT NULL, unit_price      NUMBER(8,2), quantity        NUMBER(8), CONSTRAINT product_id_fk FOREIGN KEY (product_id) REFERENCES hash_products(product_id)) PARTITION BY REFERENCE (product_id_fk);
```
**Composite-Partitioned Table Examples**
The table created in the “Range Partitioning Example” divides data by time of sale. If you plan to access recent data according to distribution channel as well as time, then composite partitioning might be more appropriate. The following example creates a copy of that `range_sales` table but specifies range-hash composite partitioning. The partitions with the most recent data are subpartitioned with both system-generated and user-defined subpartition names. Constraints and storage attributes have been omitted from the example.
```
CREATE TABLE composite_sales ( prod_id        NUMBER(6) , cust_id        NUMBER , time_id        DATE , channel_id     CHAR(1) , promo_id       NUMBER(6) , quantity_sold  NUMBER(3) , amount_sold         NUMBER(10,2) ) PARTITION BY RANGE (time_id) SUBPARTITION BY HASH (channel_id) (PARTITION SALES_Q1_1998 VALUES LESS THAN (TO_DATE('01-APR-1998','DD-MON-YYYY')), PARTITION SALES_Q2_1998 VALUES LESS THAN (TO_DATE('01-JUL-1998','DD-MON-YYYY')), PARTITION SALES_Q3_1998 VALUES LESS THAN (TO_DATE('01-OCT-1998','DD-MON-YYYY')), PARTITION SALES_Q4_1998 VALUES LESS THAN (TO_DATE('01-JAN-1999','DD-MON-YYYY')), PARTITION SALES_Q1_1999 VALUES LESS THAN (TO_DATE('01-APR-1999','DD-MON-YYYY')), PARTITION SALES_Q2_1999 VALUES LESS THAN (TO_DATE('01-JUL-1999','DD-MON-YYYY')), PARTITION SALES_Q3_1999 VALUES LESS THAN (TO_DATE('01-OCT-1999','DD-MON-YYYY')), PARTITION SALES_Q4_1999 VALUES LESS THAN (TO_DATE('01-JAN-2000','DD-MON-YYYY')), PARTITION SALES_Q1_2000 VALUES LESS THAN (TO_DATE('01-APR-2000','DD-MON-YYYY')), PARTITION SALES_Q2_2000 VALUES LESS THAN (TO_DATE('01-JUL-2000','DD-MON-YYYY')) SUBPARTITIONS 8, PARTITION SALES_Q3_2000 VALUES LESS THAN (TO_DATE('01-OCT-2000','DD-MON-YYYY')) (SUBPARTITION ch_c, SUBPARTITION ch_i, SUBPARTITION ch_p, SUBPARTITION ch_s, SUBPARTITION ch_t), PARTITION SALES_Q4_2000 VALUES LESS THAN (MAXVALUE) SUBPARTITIONS 4) ;
```
The following examples creates a partitioned table of customers based on the sample table `oe.customers`. In this example, the table is partitioned on the `credit_limit` column and list subpartitioned on the `nls_territory` column. The subpartition template determines the subpartitioning of any subsequently added partitions, unless you override the template by defining individual subpartitions. This composite partitioning makes it possible to query the table based on a credit limit range within a specified region:
```
CREATE TABLE customers_part ( customer_id        NUMBER(6), cust_first_name    VARCHAR2(20), cust_last_name     VARCHAR2(20), nls_territory      VARCHAR2(30), credit_limit       NUMBER(9,2)) PARTITION BY RANGE (credit_limit) SUBPARTITION BY LIST (nls_territory) SUBPARTITION TEMPLATE (SUBPARTITION east  VALUES ('CHINA', 'JAPAN', 'INDIA', 'THAILAND'), SUBPARTITION west VALUES ('AMERICA', 'GERMANY', 'ITALY', 'SWITZERLAND'), SUBPARTITION other VALUES (DEFAULT)) (PARTITION p1 VALUES LESS THAN (1000), PARTITION p2 VALUES LESS THAN (2500), PARTITION p3 VALUES LESS THAN (MAXVALUE));
```
**Object Column and Table Examples**
**Creating Object Tables: Examples**
Consider object type `department_typ`:
```
CREATE TYPE department_typ AS OBJECT ( d_name   VARCHAR2(100), d_address VARCHAR2(200) );
/
```
Object table `departments_obj_t` holds department objects of type `department_typ`:
```
CREATE TABLE departments_obj_t OF department_typ;
```
The following statement creates object table `salesreps` with a user-defined object type, `salesrep_typ`:
```
CREATE OR REPLACE TYPE salesrep_typ AS OBJECT ( repId NUMBER, repName VARCHAR2(64));
CREATE TABLE salesreps OF salesrep_typ;
```
**Creating a Table with a User-Defined Object Identifier: Example**
This example creates an object type and a corresponding object table whose object identifier is primary key based:
```
CREATE TYPE employees_typ AS OBJECT (e_no NUMBER, e_address CHAR(30));
/ CREATE TABLE employees_obj_t OF employees_typ (e_no PRIMARY KEY) OBJECT IDENTIFIER IS PRIMARY KEY;
```
You can subsequently reference the `employees_obj_t` object table using either *inline_ref_constraint* or *out_of_line_ref_constraint* syntax:
```
CREATE TABLE departments_t (d_no    NUMBER, mgr_ref REF employees_typ SCOPE IS employees_obj_t);
CREATE TABLE departments_t ( d_no NUMBER, mgr_ref REF employees_typ CONSTRAINT mgr_in_emp REFERENCES employees_obj_t);
```
**Specifying Constraints on Type Columns: Example**
The following example shows how to define constraints on attributes of an object type column:
```
CREATE TYPE address_t AS OBJECT ( hno    NUMBER, street VARCHAR2(40), city   VARCHAR2(20), zip    VARCHAR2(5), phone  VARCHAR2(10) );
/ CREATE TYPE person AS OBJECT ( name        VARCHAR2(40), dateofbirth DATE, homeaddress address_t, manager     REF person );
/ CREATE TABLE persons OF person ( homeaddress NOT NULL, UNIQUE (homeaddress.phone), CHECK (homeaddress.zip IS NOT NULL), CHECK (homeaddress.city <> 'San Francisco') );
```
