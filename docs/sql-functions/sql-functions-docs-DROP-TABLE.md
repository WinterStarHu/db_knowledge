# DROP TABLE

## Purpose
Use the `DROP` `TABLE` statement to move a table or object table to the recycle bin or to remove the table and all its data from the database entirely.
**Note:**   Unless you specify the `PURGE` clause, the `DROP` `TABLE` statement does not result in space being released back to the tablespace for use by other objects, and the space continues to count toward the user’s space quota.
For an external table, this statement removes only the table metadata in the database. It has no affect on the actual data, which resides outside of the database.
When you drop a table that is part of a cluster, the table is moved to the recycle bin. However, if you subsequently drop the cluster, then the table is purged from the recycle bin and can no longer be recovered with a `FLASHBACK` `TABLE` operation.
Dropping a table invalidates dependent objects and removes object privileges on the table. If you want to re-create the table, then you must regrant object privileges on the table, re-create the indexes, integrity constraints, and triggers for the table, and respecify its storage parameters. Truncating has none of these effects. Therefore, removing rows with the `TRUNCATE` statement can be more efficient than dropping and re-creating a table.
**See Also:**
- CREATE TABLE and ALTER TABLE for information on creating and modifying tables
- TRUNCATE TABLE and DELETE for information on removing data from a table
- FLASHBACK TABLE for information on retrieving a dropped table from the recycle bin
## Prerequisites
The table must be in your own schema or you must have the `DROP` `ANY` `TABLE` system privilege.
You can perform DDL operations (such as `ALTER` `TABLE`, `DROP` `TABLE`, `CREATE` `INDEX`) on a temporary table only when no session is bound to it. A session becomes bound to a temporary table by performing an `INSERT` operation on the table. A session becomes unbound to the temporary table by issuing a `TRUNCATE` statement or at session termination, or, for a transaction-specific temporary table, by issuing a `COMMIT` or `ROLLBACK` statement.
**Dropping Private Temporary Tables** You can drop a private temporary table using the existing `DROP` `TABLE` command. Dropping a private temporary table will not commit an existing transaction. This applies to both transaction-specific and session-specific private temporary tables. Note that a dropped private temporary table will not go into the `RECYCLEBIN`.
**Dropping Immutable Tables** Use the `DROP TABLE` statement to drop an immutable table. It is recommended that you include the `PURGE` option while dropping an immutable table. Dropping an immutable table removes its definition from the data dictionary, deletes all its rows, and deletes any indexes and triggers defined on the table.
The immutable table must be contained in your schema, or you must have the `DROP ANY TABLE` system privilege.
An immutable table can be dropped only after it has not been modified for a period of time that is defined by its retention period.
An empty immutable table can be dropped regardless of its retention period.
## Syntax
## *drop_table*::=
Description of the illustration drop_table.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to drop an existing table.
## *schema*
Specify the schema containing the table. If you omit *schema*, then Oracle Database assumes the table is in your own schema.
## *table*
Specify the name of the table to be dropped. Oracle Database automatically performs the following operations:
- All rows from the table are dropped.
**
- All table indexes and domain indexes are dropped, as well as any triggers defined on the table, regardless of who created them or whose schema contains them. If table is partitioned, then any corresponding local index partitions are also dropped.
**
- All the storage tables of nested tables and LOBs of table are dropped.
- When you drop a range-, hash-, or list-partitioned table, then the database drops all the table partitions. If you drop a composite-partitioned table, then all the partitions and subpartitions are also dropped.
``````````````
````````````
******
- When you drop a partitioned table with the PURGE keyword, the statement executes as a series of subtransactions, each of which drops a subset of partitions or subpartitions and their metadata. This division of the drop operation into subtransactions optimizes the processing of internal system resource consumption (for example, the library cache), especially for the dropping of very large partitioned tables. As soon as the first subtransaction commits, the table is marked UNUSABLE. If any of the subtransactions fails, then the only operation allowed on the table is another DROP TABLE ... PURGE statement. Such a statement will resume work from where the previous DROP TABLE statement failed, assuming that you have corrected any errors that the previous operation encountered. You can list the tables marked UNUSABLE by such a drop operation by querying the status column of the *_TABLES, *_PART_TABLES, *_ALL_TABLES, or *_OBJECT_TABLES data dictionary views, as appropriate. See Also: Oracle Database VLDB and Partitioning Guide for more information on dropping partitioned tables.
- For an index-organized table, any mapping tables defined on the index-organized table are dropped.
**
- For a domain index, the appropriate drop routines are invoked. Refer to Oracle Database Data Cartridge Developer’s Guide for more information on these routines.
****
- If any statistics types are associated with the table, then the database disassociates the statistics types with the FORCE clause and removes any user-defined statistics collected with the statistics type. See Also: ASSOCIATE STATISTICS and DISASSOCIATE STATISTICS for more information on statistics type associations
````````
- If the table is not part of a cluster, then the database returns all data blocks allocated to the table and its indexes to the tablespaces containing the table and its indexes. To drop a cluster and all its the tables, use the DROP CLUSTER statement with the INCLUDING TABLES clause to avoid dropping each table individually. See DROP CLUSTER.
- If the table is a base table for a view, a container or master table of a materialized view, or if it is referenced in a stored procedure, function, or package, then the database invalidates these dependent objects but does not drop them. You cannot use these objects unless you re-create the table or drop and re-create the objects so that they no longer depend on the table. If you choose to re-create the table, then it must contain all the columns selected by the subqueries originally used to define the materialized views and all the columns referenced in the stored procedures, functions, or packages. Any users previously granted object privileges on the views, stored procedures, functions, or packages need not be regranted these privileges. If the table is a master table for a materialized view, then the materialized view can still be queried, but it cannot be refreshed unless the table is re-created so that it contains all the columns selected by the defining query of the materialized view. If the table has a materialized view log, then the database drops this log and any other direct-path INSERT refresh information associated with the table.
**Restrictions on Dropping Tables**
````````
- You cannot directly drop the storage table of a nested table. Instead, you must drop the nested table column using the ALTER TABLE ... DROP COLUMN clause.
- You cannot drop the parent table of a reference-partitioned table. You must first drop all reference-partitioned child tables.
- You cannot drop a table that uses a flashback data archive for historical tracking. You must first disable the table’s use of the flashback archive.
## CASCADE CONSTRAINTS
Specify `CASCADE` `CONSTRAINTS` to drop all referential integrity constraints that refer to primary and unique keys in the dropped table. If you omit this clause, and such referential integrity constraints exist, then the database returns an error and does not drop the table.
## PURGE
Specify `PURGE` if you want to drop the table and release the space associated with it in a single step. If you specify `PURGE`, then the database does not place the table and its dependent objects into the recycle bin.
**Note:**   You cannot roll back a `DROP` `TABLE` statement with the `PURGE` clause, nor can you recover the table if you have dropped it with the `PURGE` clause.
Using this clause is equivalent to first dropping the table and then purging it from the recycle bin. This clause lets you save one step in the process. It also provides enhanced security if you want to prevent sensitive material from appearing in the recycle bin.
**See Also:**   *Oracle Database Administrator’s Guide* for information on the recycle bin and naming conventions for objects in the recycle bin
## Examples
**Dropping a Table: Example** The following statement drops the `oe.list_customers` table created in “List Partitioning Example”.
```
DROP TABLE list_customers PURGE;
```
