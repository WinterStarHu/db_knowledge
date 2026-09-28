# CREATE INDEX

## Purpose
Use the `CREATE` `INDEX` statement to create an index on:
- One or more columns of a table, a partitioned table, an index-organized table, or a cluster
- One or more scalar typed object attributes of a table or a cluster
- A nested table storage table for indexing a nested table column
An **index** is a schema object that contains an entry for each value that appears in the indexed column(s) of the table or cluster and provides direct, fast access to rows. The maximum size of a single index entry is dependent on the block size of the database.
Oracle Database supports several types of index:
****
- Normal indexes. (By default, Oracle Database creates B-tree indexes.)
****
- Bitmap indexes, which store rowids associated with a key value as a bitmap.
****
- Partitioned indexes, which consist of partitions containing an entry for each value that appears in the indexed column(s) of the table.
****
- Function-based indexes, which are based on expressions. They enable you to construct queries that evaluate the value returned by an expression, which in turn may include built-in or user-defined functions.
**********
```
- [*Oracle Database Concepts*](/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/sqlrf&id=CNCPT811) for a discussion of indexes
- [*Oracle Database Reference*](/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/sqlrf&id=REFRN0043) for more information about the limits related to index size
- [ALTER INDEX](ALTER-INDEX.html#GUID-D8F648E7-8C07-4C89-BB71-862512536558) and [DROP INDEX](DROP-INDEX.html#GUID-F60F75DF-2866-4F93-BB7F-8FCE64BF67B6)
```
- Domain indexes, which are instances of an application-specific index of type indextype.
```
- A bitmap index can have a maximum of 30 columns.
```
- You cannot specify advanced index compression for index-organized tables.
```
