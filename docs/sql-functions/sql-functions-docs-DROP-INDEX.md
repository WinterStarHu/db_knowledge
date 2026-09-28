# DROP INDEX

## Purpose
Use the `DROP` `INDEX` statement to remove an index or domain index from the database.
When you drop a global partitioned index, a range-partitioned index, or a hash-partitioned index, all the index partitions are also dropped. If you drop a composite-partitioned index, then all the index partitions and subpartitions are also dropped.
In addition, when you drop a domain index:
- Oracle Database invokes the appropriate routine.
**** **
  - Oracle Database Data Cartridge Developer’s Guide for information on the routines
  - CREATE INDEX and ALTER INDEX for information on creating and modifying an index
**
  - The domain_index_clause of CREATE INDEX for more information on domain indexes
  - ASSOCIATE STATISTICS and DISASSOCIATE STATISTICS for more information on statistics type associations
## Prerequisites
The index must be in your own schema or you must have the `DROP` `ANY` `INDEX` system privilege.
## Syntax
## *drop_index*::=
Description of the illustration drop_index.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to drop an existing index.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema containing the index. If you omit *schema*, then Oracle Database assumes the index is in your own schema.
## *index*
Specify the name of the index to be dropped. When the index is dropped, all data blocks allocated to the index are returned to the tablespace that contained the index.
## ONLINE
Specify `ONLINE` to indicate that DML operations on the table or partition will be allowed while dropping the index.
## FORCE
`FORCE` applies only to domain indexes. This clause drops the domain index even if the indextype routine invocation returns an error or the index is marked `IN` `PROGRESS`. Without `FORCE`, you cannot drop a domain index if its indextype routine invocation returns an error or the index is marked `IN` `PROGRESS`.
```

```
## { DEFERRED | IMMEDIATE } INVALIDATION
This clause lets you control when the database invalidates dependent cursors while dropping the index. It has the same semantics here as for the `ALTER` `INDEX` statement, with the following addition: When you drop an index with `DEFERRED` `INVALIDATION`, Oracle database will immediately invalidate any DML statement or query that references the dropped index in its plan.
See { DEFERRED | IMMEDIATE } INVALIDATION in the documentation on `ALTER` `INDEX` for the full semantics of this clause.
## Restrictions on Dropping Indexes
The following restrictions apply to dropping indexes:
- You cannot drop a domain index if the index or any of its index partitions is marked IN_PROGRESS.
- You cannot specify the ONLINE clause when dropping a domain index, a cluster index, or an index on a queue table.
## Examples
**Dropping an Index: Example** This statement drops an index named `ord_customer_ix_demo`, which was created in “Compressing an Index: Example”:
```
DROP INDEX ord_customer_ix_demo;
```
