# ANALYZE

## Purpose
Use the `ANALYZE` statement to collect statistics, for example, to:
- Collect or delete statistics about an index or index partition, table or table partition, index-organized table, cluster, or scalar object attribute.
- Validate the structure of an index or index partition, table or table partition, index-organized table, cluster, or object reference (REF).
- Identify migrated and chained rows of a table or cluster.
**Note:** The use of `ANALYZE` for the collection of optimizer statistics is obsolete.
If you want to collect optimizer statistics, use the `DBMS_STATS` package, which lets you collect statistics in parallel, global statistics for partitioned objects, and helps you fine tune your statistics collection in other ways. See  *Oracle Database PL/SQL Packages and Types Reference* for more information on the `DBMS_STATS` package.
Use the `ANALYZE` statement only for the following cases:
````````
- To use the VALIDATE or LIST CHAINED ROWS clauses
- To collect information on freelist blocks
## Prerequisites
The schema object to be analyzed must be local, and it must be in your own schema or you must have the `ANALYZE` `ANY` system privilege.
If you want to list chained rows of a table or cluster into a list table, then the list table must be in your own schema, or you must have `INSERT` privilege on the list table, or you must have `INSERT` `ANY` `TABLE` system privilege.
If you want to validate a partitioned table, then you must have the `INSERT` object privilege on the table into which you list analyzed rowids, or you must have the `INSERT` `ANY` `TABLE` system privilege.
## Syntax
## *analyze*::=
Description of the illustration analyze.eps
## *partition_extension_clause*::=
Description of the illustration partition_extension_clause.eps
## *validation_clauses*::=
Description of the illustration validation_clauses.eps
## *into_clause*::=
Description of the illustration into_clause.eps
## Semantics
## *schema*
Specify the schema containing the table, index, or cluster. If you omit *schema*, then Oracle Database assumes the table, index, or cluster is in your own schema.
## TABLE*table*
Specify a table to be analyzed. When you analyze a table, the database collects statistics about expressions occurring in any function-based indexes as well. Therefore, be sure to create function-based indexes on the table before analyzing the table. Refer to CREATE INDEX for more information about function-based indexes.
When analyzing a table, the database skips all domain indexes marked `LOADING` or `FAILED`.
For an index-organized table, the database also analyzes any mapping table and calculates its `PCT_ACCESSS_DIRECT` statistics. These statistics estimate the accuracy of guess data block addresses stored as part of the local rowids in the mapping table.
Oracle Database collects the following statistics for a table. Statistics marked with an asterisk are always computed exactly. Table statistics, including the status of domain indexes, appear in the data dictionary views `USER_TABLES`, `ALL_TABLES`, and `DBA_TABLES` in the columns shown in parentheses.
- Number of rows (NUM_ROWS)
    - Number of data blocks below the high water mark—the number of data blocks that have been formatted to receive data, regardless whether they currently contain data or are empty (BLOCKS)
    - Number of data blocks allocated to the table that have never been used (EMPTY_BLOCKS)
- Average available free space in each data block in bytes (AVG_SPACE)
- Number of chained rows (CHAIN_COUNT)
  - Average row length, including the row overhead, in bytes (AVG_ROW_LEN)
**Restrictions on Analyzing Tables**
Analyzing tables is subject to the following restrictions:
- You cannot use ANALYZE to collect statistics on data dictionary tables.
````
- You cannot use ANALYZE to collect statistics on an external table. Instead, you must use the DBMS_STATS package.
````
- You cannot use ANALYZE to collect default statistics on a temporary table. However, if you have already created an association between one or more columns of a temporary table and a user-defined statistics type, then you can use ANALYZE to collect the user-defined statistics on the temporary table.
````
- You cannot compute or estimate statistics for the following column types: REF column types, varrays, nested tables, LOB column types (LOB column types are not analyzed, they are skipped), LONG column types, or object types. However, if a statistics type is associated with such a column, then Oracle Database collects user-defined statistics.
**See Also:**
- ASSOCIATE STATISTICS
**
- Oracle Database Reference for information on the data dictionary views
## *partition_extension_clause*
*partition_extension_clause* Specify the partition or subpartition, or the partition or subpartition value, on which you want statistics to be gathered. You cannot use this clause when analyzing clusters.
If you specify `PARTITION` and *table* is composite-partitioned, then Oracle Database analyzes all the subpartitions within the specified partition.
## INDEX*index*
Specify an index to be analyzed.
Oracle Database collects the following statistics for an index. Statistics marked with an asterisk are always computed exactly. For conventional indexes, when you compute or estimate statistics, the statistics appear in the data dictionary views `USER_INDEXES`, `ALL_INDEXES`, and `DBA_INDEXES` in the columns shown in parentheses.
  - Depth of the index from its root block to its leaf blocks (BLEVEL)
- Number of leaf blocks (LEAF_BLOCKS)
- Number of distinct index values (DISTINCT_KEYS)
- Average number of leaf blocks for each index value (AVG_LEAF_BLOCKS_PER_KEY)
- Average number of data blocks for each index value (for an index on a table) (AVG_DATA_BLOCKS_PER_KEY)
  - Clustering factor (how well ordered the rows are about the indexed values) (CLUSTERING_FACTOR)
For domain indexes, this statement invokes the user-defined statistics collection function specified in the statistics type associated with the index (see ASSOCIATE STATISTICS). If no statistics type is associated with the domain index, then the statistics type associated with its indextype is used. If no statistics type exists for either the index or its indextype, then no user-defined statistics are collected. User-defined index statistics appear in the `STATISTICS` column of the data dictionary views `USER_USTATS`, `ALL_USTATS`, and `DBA_USTATS`.
**Note:**
````
- When you analyze an index from which a substantial number of rows has been deleted, Oracle Database sometimes executes a COMPUTE statistics operation (which can entail a full table scan) even if you request an ESTIMATE statistics operation. Such an operation can be quite time consuming.
````**
- In some cases, analyzing an index with the ANALYZE statement takes an inordinate amount of time to complete. In these cases, you can use a SQL query to validate the index. If the query determines that there is an inconsistency between a table and the index, then you can use the ANALYZE statement for a thorough analysis of the index. Refer to Oracle Database Administrator’s Guide for more information.
**Restriction on Analyzing Indexes** You cannot analyze a domain index that is marked `IN_PROGRESS` or `FAILED`.
**See Also:**
- CREATE INDEX for more information on domain indexes
**
- Oracle Database Reference for information on the data dictionary views
- “Analyzing an Index: Example”
## CLUSTER*cluster*
Specify a cluster to be analyzed. When you collect statistics for a cluster, Oracle Database also automatically collects the statistics for all the tables in the cluster and all their indexes, including the cluster index.
For both indexed and hash clusters, the database collects the average number of data blocks taken up by a single cluster key (`AVG_BLOCKS_PER_KEY`). These statistics appear in the data dictionary views `ALL_CLUSTERS`, `USER_CLUSTERS`, and `DBA_CLUSTERS`.
**See Also:**   *Oracle Database Reference* for information on the data dictionary views and “Analyzing a Cluster: Example”
## *validation_clauses*
The validation clauses let you validate `REF` values and the structure of the analyzed object.
**See Also:**   *Oracle Database Administrator’s Guide* for more information about validating tables, indexes, clusters, and materialized views **VALIDATE REF UPDATE Clause** Specify `VALIDATE` `REF` `UPDATE` to validate the `REF` values in the specified table, check the rowid portion in each `REF`, compare it with the true rowid, and correct it, if necessary. You can use this clause only when analyzing a table.
If the owner of the table does not have the `READ` or `SELECT` object privilege on the referenced objects, then Oracle Database will consider them invalid and set them to null. Subsequently these `REF` values will not be available in a query, even if it is issued by a user with appropriate privileges on the objects.
**SET DANGLING TO NULL** `SET` `DANGLING` `TO` `NULL` sets to null any `REF` values (whether or not scoped) in the specified table that are found to point to an invalid or nonexistent object.
**VALIDATE STRUCTURE** Specify `VALIDATE` `STRUCTURE` to validate the structure of the analyzed object. The statistics collected by this clause are not used by the Oracle Database optimizer.
**See Also:**   “Validating a Table: Example”
- For a table, Oracle Database verifies the integrity of each of the data blocks and rows. For an index-organized table, the database also generates compression statistics (optimal prefix compression count) for the primary key index on the table.
- For a cluster, Oracle Database automatically validates the structure of the cluster tables.
- For a partitioned table, Oracle Database also verifies that each row belongs to the correct partition. If a row does not collate correctly, then its rowid is inserted into the INVALID_ROWS table.
- For a temporary table, Oracle Database validates the structure of the table and its indexes during the current session.
````
******
- For an index, Oracle Database verifies the integrity of each data block in the index and checks for block corruption. This clause does not confirm that each row in the table has an index entry or that each index entry points to a row in the table. You can perform these operations by validating the structure of the table with the CASCADE clause. Oracle Database also computes compression statistics (optimal prefix compression count) for all normal indexes. Oracle Database stores statistics about the index in the data dictionary views INDEX_STATS and INDEX_HISTOGRAM. See Also: Oracle Database Reference for information on these views
If Oracle Database encounters corruption in the structure of the object, then an error message is returned. In this case, drop and re-create the object.
**CASCADE**
Specify `CASCADE` if you want Oracle Database to validate the structure of the indexes associated with the table or cluster. If you use this clause when validating a table, then the database also validates the indexes defined on the table. If you use this clause when validating a cluster, then the database also validates all the cluster tables indexes, including the cluster index.
By default, `CASCADE` performs a `COMPLETE` validation, which can be resource intensive. Specify `FAST` if you want the database to check for the existence of corruptions without reporting details about the corruption. If the `FAST` check finds a corruption, you can then use the `CASCADE` option without the `FAST` clause to locate and learn details about it.
If you use this clause to validate an enabled (but previously disabled) function-based index, then validation errors may result. In this case, you must rebuild the index.
**ONLINE | OFFLINE**
Specify `ONLINE` to enable Oracle Database to run the validation while DML operations are ongoing within the object. The database reduces the amount of validation performed to allow for concurrency.
**Note:**   When you validate the structure of an object `ONLINE`, Oracle Database does not collect any statistics, as it does when you validate the structure of the object `OFFLINE`.
Specify `OFFLINE`, to maximize the amount of validation performed. This setting prevents `INSERT`, `UPDATE`, and `DELETE` statements from concurrently accessing the object during validation but allows queries. This is the default.
**Restriction on ONLINE**
You cannot specify `ONLINE` when analyzing a cluster.
**INTO**
The `INTO` clause of `VALIDATE` `STRUCTURE` is valid only for partitioned tables. Specify a table into which Oracle Database lists the rowids of the partitions whose rows do not collate correctly. If you omit *schema*, then the database assumes the list is in your own schema. If you omit this clause altogether, then the database assumes that the table is named `INVALID_ROWS`. The SQL script used to create this table is `UTLVALID.SQL`.
## LIST CHAINED ROWS
`LIST` `CHAINED` `ROWS` lets you identify migrated and chained rows of the analyzed table or cluster. You cannot use this clause when analyzing an index.
In the `INTO` clause, specify a table into which Oracle Database lists the migrated and chained rows. If you omit *schema*, then the database assumes the chained-rows table is in your own schema. If you omit this clause altogether, then the database assumes that the table is named `CHAINED_ROWS`. The chained-rows table must be on your local database.
You can create the `CHAINED_ROWS` table using one of these scripts:
- UTLCHAIN.SQL uses physical rowids. Therefore it can accommodate rows from conventional tables but not from index-organized tables. (See the Note that follows.)
- UTLCHN1.SQL uses universal rowids, so it can accommodate rows from both conventional and index-organized tables.
If you create your own chained-rows table, then it must follow the format prescribed by one of these two scripts.
If you are analyzing index-organized tables based on primary keys (rather than universal rowids), then you must create a separate chained-rows table for each index-organized table to accommodate its primary-key storage. Use the SQL scripts `DBMSIOTC.SQL` and `PRVTIOTC.PLB` to define the `BUILD_CHAIN_ROWS_TABLE` procedure, and then execute this procedure to create an `IOT_CHAINED_ROWS` table for each such index-organized table.
**See Also:**
**
- The DBMS_IOT package in Oracle Database PL/SQL Packages and Types Reference for information on the packaged SQL scripts
- “Listing Chained Rows: Example”
## DELETE STATISTICS
Specify `DELETE` `STATISTICS` to delete any statistics about the analyzed object that are currently stored in the data dictionary. Use this statement when you no longer want Oracle Database to use the statistics.
When you use this clause on a table, the database also automatically removes statistics for all the indexes defined on the table. When you use this clause on a cluster, the database also automatically removes statistics for all the cluster tables and all their indexes, including the cluster index.
Specify `SYSTEM` if you want Oracle Database to delete only system (not user-defined) statistics. If you omit `SYSTEM`, and if user-defined column or index statistics were collected for an object, then the database also removes the user-defined statistics by invoking the statistics deletion function specified in the statistics type that was used to collect the statistics.
**See Also:**   “Deleting Statistics: Example”
## Examples
**Deleting Statistics: Example**
The following statement deletes statistics about the sample table `oe.orders` and all its indexes from the data dictionary:
```
ANALYZE TABLE orders DELETE STATISTICS;
```
**Analyzing an Index: Example**
The following statement validates the structure of the sample index `oe.inv_product_ix`:
```
ANALYZE INDEX inv_product_ix VALIDATE STRUCTURE;
```
**Validating a Table: Example**
The following statement analyzes the sample table `hr.employees` and all of its indexes:
```
ANALYZE TABLE employees VALIDATE STRUCTURE CASCADE;
```
For a table, the `VALIDATE` `REF` `UPDATE` clause verifies the `REF` values in the specified table, checks the rowid portion of each `REF`, and then compares it with the true rowid. If the result is an incorrect rowid, then the `REF` is updated so that the rowid portion is correct.
The following statement validates the `REF` values in the sample table `oe.customers`:
```
ANALYZE TABLE customers VALIDATE REF UPDATE;
```
The following statement validates the structure of the sample table `oe.customers` while allowing simultaneous DML:
```
ANALYZE TABLE customers VALIDATE STRUCTURE ONLINE;
```
**Analyzing a Cluster: Example**
The following statement analyzes the `personnel` cluster (created in “Creating a Cluster: Example”), all of its tables, and all of their indexes, including the cluster index:
```
ANALYZE CLUSTER personnel VALIDATE STRUCTURE CASCADE;
```
**Listing Chained Rows: Example**
The following statement collects information about all the chained rows in the table `orders`:
```
ANALYZE TABLE orders LIST CHAINED ROWS INTO chained_rows;
```
The preceding statement places the information into the table `chained_rows`. You can then examine the rows with this query (no rows will be returned if the table contains no chained rows):
```
SELECT owner_name, table_name, head_rowid, analyze_timestamp FROM chained_rows ORDER BY owner_name, table_name, head_rowid, analyze_timestamp;
OWNER_NAME  TABLE_NAME  HEAD_ROWID         ANALYZE_TIMESTAMP
----------  ----------  ------------------ -----------------
OE          ORDERS      AAAAZzAABAAABrXAAA 25-SEP-2000
```
