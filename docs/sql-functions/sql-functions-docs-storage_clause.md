# storage_clause                  document.write(''); document.write('body > .noscript, body > .noscript ~ * { opacity: 0; }'); document.write('');    if (window.require === undefined) { document.write(''); document.write(''); }

# *storage_clause*
## Purpose
The *storage_clause* lets you specify how Oracle Database should store a permanent database object. Storage parameters for temporary segments always use the default storage parameters for the associated tablespace. Storage parameters affect both how long it takes to access data stored in the database and how efficiently space in the database is used.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for a discussion of the effects of the storage parameters When you create a cluster, index, materialized view, materialized view log, rollback segment, table, LOB, varray, nested table, or partition, you can specify values for the storage parameters for the segments allocated to these objects. If you omit any storage parameter, then Oracle uses the value of that parameter specified for the tablespace in which the object resides. If no value was specified for the tablespace, then the database uses default values.
**Note:**   The specification of storage parameters for objects in locally managed tablespaces is supported for backward compatibility. If you are using locally managed tablespaces, then you can omit these storage parameter when creating objects in those tablespaces.
When you alter a cluster, index, materialized view, materialized view log, rollback segment, table, varray, nested table, or partition, you can change the values of storage parameters. The new values affect only future extent allocations.
The *storage_clause* is part of the *physical_attributes_clause*, so you can specify this clause in any of the statements where you can specify the physical attributes clause (see *physical_attributes_clause*). In addition, you can specify the *storage_clause* in the following statements:
````````****
- CREATE CLUSTER and ALTER CLUSTER: to set or change the storage characteristics of the cluster and all tables in the cluster (see CREATE CLUSTER and ALTER CLUSTER).
````````********
- CREATE INDEX and ALTER INDEX: to set or change the storage characteristics of an index segment created for a table index or index partition or an index segment created for an index used to enforce a primary key or unique constraint (see CREATE INDEX and ALTER INDEX).
``````````````****
- The ENABLE ... USING INDEX clause of CREATE TABLE or ALTER TABLE: to set or change the storage characteristics of an index created by the system to enforce a primary key or unique constraint.
````````````****
- CREATE MATERIALIZED VIEW and ALTER MATERIALIZED VIEW: to set or change the storage characteristics of a materialized view, one of its partitions, or the index Oracle generates to maintain the materialized view (see CREATE MATERIALIZED VIEW and ALTER MATERIALIZED VIEW).
````````````````****
- CREATE MATERIALIZED VIEW LOG and ALTER MATERIALIZED VIEW LOG: to set or change the storage characteristics of the materialized view log (see CREATE MATERIALIZED VIEW LOG and ALTER MATERIALIZED VIEW LOG).
````****
- CREATE ROLLBACK SEGMENT and ALTER ROLLBACK SEGMENT: to set or change the storage characteristics of a rollback segment (see CREATE ROLLBACK SEGMENT and ALTER ROLLBACK SEGMENT).
````````********
- CREATE TABLE and ALTER TABLE: to set the storage characteristics of a LOB or varray data segment of the nonclustered table or one of its partitions or subpartitions, or the storage table of a nested table (see CREATE TABLE and ALTER TABLE).
````````****
- CREATE TABLESPACE and ALTER TABLESPACE: to set or change the default storage characteristics for objects created in the tablespace (see CREATE TABLESPACE and ALTER TABLESPACE). Changes to tablespace storage parameters affect only new objects created in the tablespace or new extents allocated for a segment.
********
- constraint: to specify storage for the index (and its partitions, if it is a partitioned index) used to enforce the constraint (see constraint).
## Prerequisites
To change the value of a `STORAGE` parameter, you must have the privileges necessary to use the appropriate `CREATE` or `ALTER` statement.
## Syntax
## *storage_clause*::=
Description of the illustration storage_clause.eps (*size_clause::=*)
## *maxsize_clause*::=
Description of the illustration maxsize_clause.eps (*size_clause::=*)
## Semantics
This section describes the parameters of the *storage_clause*. For additional information, refer to the SQL statement in which you set or reset these storage parameters for a particular database object.
**Note:**   The *storage_clause* is interpreted differently for locally managed tablespaces. For locally managed tablespaces, Oracle Database uses `INITIAL`, `NEXT`, `PCTINCREASE`, and `MINEXTENTS` to compute how many extents are allocated when the object is first created. After object creation, these parameters are ignored. For more information, see CREATE TABLESPACE.
**See Also:**   “Specifying Table Storage Attributes: Example” **INITIAL** Specify the size of the first extent of the object. Oracle allocates space for this extent when you create the schema object. Refer to *size_clause* for information on that clause.
In locally managed tablespaces, Oracle uses the value of `INITIAL`, in conjunction with the type of local management-`AUTOALLOCATE` or `UNIFORM`-and the values of `MINEXTENTS`, `NEXT` and `PCTINCREASE`, to determine the initial size of the segment.
``````````
- With AUTOALLOCATE extent management, Oracle uses the INITIAL setting to optimize the number of extents allocated. Extents of 64K, 1M, 8M, and 64M can be allocated. During segment creation, the system chooses the greatest of these four sizes that is equal to or smaller than INITIAL, and allocates as many extents of that size as are needed to reach the INITIAL setting. For example, if you set INITIAL to 4M, then the database creates four 1M extents.
````
``````````
- For UNIFORM extent management, the number of extents is determined from initial segment size and the uniform extent size specified at tablespace creation time. For example, in a uniform locally managed tablespace with 1M extents, if you specify an INITIAL value of 5M, then Oracle creates five 1M extents. Consider this comparison: With AUTOALLOCATE, if you set INITAL to 72K, then the initial segment size will be 128K (greater than INITIAL). The database cannot allocate an extent smaller than 64K, so it must allocate two 64K extents. If you set INITIAL to 72K with a UNIFORM extent size of 24K, then the database will allocate three 24K extents to equal 72K.
In dictionary managed tablespaces, the default initial extent size is 5 blocks, and all subsequent extents are rounded to 5 blocks. If `MINIMUM` `EXTENT` was specified at tablespace creation time, then the extent sizes are rounded to the value of `MINIMUM` `EXTENT`.
**Restriction on INITIAL**
You cannot specify `INITIAL` in an `ALTER` statement.
**NEXT**
Specify in bytes the size of the next extent to be allocated to the object. Refer to *size_clause* for information on that clause.
In locally managed tablespaces, any user-supplied value for `NEXT` is ignored and the size of `NEXT` is determined by Oracle if the tablespace is set for autoallocate extent management. In `UNIFORM` tablespaces, the size of `NEXT` is the uniform extent size specified at tablespace creation time.
In dictionary-managed tablespaces, the default value is the size of 5 data blocks. The minimum value is the size of 1 data block. The maximum value depends on your operating system. Oracle rounds values up to the next multiple of the data block size for values less than 5 data blocks. For values greater than 5 data blocks, Oracle rounds up to a value that minimizes fragmentation.
**See Also:**   *Oracle Database Concepts* for information on how Oracle minimizes fragmentation
**PCTINCREASE**
In locally managed tablespaces, Oracle Database uses the value of `PCTINCREASE` during segment creation to determine the initial segment size and ignores this parameter during subsequent space allocation.
In dictionary-managed tablespaces, specify the percent by which the third and subsequent extents grow over the preceding extent. The default value is 50, meaning that each subsequent extent is 50% larger than the preceding extent. The minimum value is 0, meaning all extents after the first are the same size. The maximum value depends on your operating system. Oracle rounds the calculated size of each new extent to the nearest multiple of the data block size. If you change the value of the `PCTINCREASE` parameter by specifying it in an `ALTER` statement, then Oracle calculates the size of the next extent using this new value and the size of the most recently allocated extent.
**Restriction on PCTINCREASE**
You cannot specify `PCTINCREASE` for rollback segments. Rollback segments always have a `PCTINCREASE` value of
0.
**MINEXTENTS**
In locally managed tablespaces, Oracle Database uses the value of `MINEXTENTS` in conjunction with `PCTINCREASE`, `INITIAL` and `NEXT` to determine the initial segment size.
In dictionary-managed tablespaces, specify the total number of extents to allocate when the object is created. The default and minimum value is 1, meaning that Oracle allocates only the initial extent, except for rollback segments, for which the default and minimum value is 2. The maximum value depends on your operating system.
````````
- In a locally managed tablespace, MINEXTENTS is used to compute the initial amount of space allocated, which is equal to INITIAL * MINEXTENTS. Thereafter this value is set to 1, which is reflected in the DBA_SEGMENTS view.
- In a dictionary-managed tablespace, MINEXTENTS is simply the minimum number of extents that must be allocated to the segment.
If the `MINEXTENTS` value is greater than 1, then Oracle calculates the size of subsequent extents based on the values of the `INITIAL`, `NEXT`, and `PCTINCREASE` storage parameters.
When changing the value of `MINEXTENTS` by specifying it in an `ALTER` statement, you can reduce the value from its current value, but you cannot increase it. Resetting `MINEXTENTS` to a smaller value might be useful, for example, before a `TRUNCATE` … `DROP` `STORAGE` statement, if you want to ensure that the segment will maintain a minimum number of extents after the `TRUNCATE` operation.
**Restrictions on MINEXTENTS** The `MINEXTENTS` storage parameter is subject to the following restrictions:
- MINEXTENTS is not applicable at the tablespace level.
````
- You cannot change the value of MINEXTENTS in an ALTER statement or for an object that resides in a locally managed tablespace.
**MAXEXTENTS**
This storage parameter is valid only for objects in dictionary-managed tablespaces. Specify the total number of extents, including the first, that Oracle can allocate for the object. The minimum value is 1 except for rollback segments, which always have a minimum of 2. The default value depends on your data block size.
**Restriction on MAXEXTENTS**
`MAXEXTENTS` is ignored for objects residing in a locally managed tablespace, unless the value of `ALLOCATION_TYPE` is `USER` for the tablespace in the `DBA_TABLESPACES` data dictionary view.
**See Also:**   *Oracle Database Reference* for more information on the `DBA_TABLESPACES` data dictionary view
**UNLIMITED**
Specify `UNLIMITED` if you want extents to be allocated automatically as needed. Oracle recommends this setting as a way to minimize fragmentation.
Do not use this clause for rollback segments. Doing so allows the possibility that long-running rogue DML transactions will continue to create new extents until a disk is full.
  **Note:**   A rollback segment that you create without specifying the *storage_clause* has the same storage parameters as the tablespace in which the rollback segment is created. Thus, if you create a tablespace with `MAXEXTENTS UNLIMITED`, then the rollback segment will have this same default.
**MAXSIZE**
The `MAXSIZE` clause lets you specify the maximum size of the storage element. For LOB storage, `MAXSIZE` has the following effects
````**
- If you specify RETENTION MAX in LOB_parameters, then the LOB segment increases to the specified size before any space can be reclaimed from undo space.
````````**
- If you specify RETENTION AUTO, MIN, or NONE in LOB_parameters, then the specified size is a hard limit on the LOB segment size and has no bearing on undo retention.
**UNLIMITED**
Use the `UNLIMITED` clause if you do not want to limit the disk space of the storage element. This clause is not compatible with a specification of `RETENTION` `MAX` in *LOB_parameters*. If you specify both, then the database uses `RETENTION` `AUTO` and `MAXSIZE` `UNLIMITED`.
**FREELISTS**
In tablespaces with manual segment-space management, Oracle Database uses the `FREELISTS` storage parameter to improve performance of space management in OLTP systems by increasing the number of insert points in the segment. In tablespaces with automatic segment-space management, this parameter is ignored, because the database adapts to varying workload.
In tablespaces with manual segment-space management, for objects other than tablespaces and rollback segments, specify the number of free lists for each of the free list groups for the table, partition, cluster, or index. The default and minimum value for this parameter is 1, meaning that each free list group contains one free list. The maximum value of this parameter depends on the data block size. If you specify a `FREELISTS` value that is too large, then Oracle returns an error indicating the maximum value.
This clause is not valid or useful if you have specified the `SECUREFILE` parameter of *LOB_parameters*. If you specify both the `SECUREFILE` parameter and `FREELISTS`, then the database silently ignores the `FREELISTS` specification.
**Restriction on FREELISTS**
You can specify `FREELISTS` in the *storage_clause* of any statement except when creating or altering a tablespace or rollback segment.
**FREELIST GROUPS**
In tablespaces with manual segment-space management, Oracle Database uses the value of this storage parameter to statically partition the segment free space in an Oracle Real Application Clusters environment. This partitioning improves the performance of space allocation and deallocation by avoiding inter instance transfer of segment metadata. In tablespaces with automatic segment-space management, this parameter is ignored, because Oracle dynamically adapts to inter instance workload.
In tablespaces with manual segment-space management, specify the number of groups of free lists for the database object you are creating. The default and minimum value for this parameter is
  - Oracle uses the instance number of Oracle Real Application Clusters (Oracle RAC) instances to map each instance to one free list group.
Each free list group uses one database block. Therefore:
````
- If you do not specify a large enough value for INITIAL to cover the minimum value plus one data block for each free list group, then Oracle increases the value of INITIAL the necessary amount.
- If you are creating an object in a uniform locally managed tablespace, and the extent size is not large enough to accommodate the number of freelist groups, then the create operation will fail.
This clause is not valid or useful if you have specified the `SECUREFILE` parameter of *LOB_parameters*. If you specify both the `SECUREFILE` parameter and `FREELIST` `GROUPS`, then the database silently ignores the `FREELIST` `GROUPS` specification.
**Restriction on FREELIST GROUPS** You can specify the `FREELIST` `GROUPS` parameter only in `CREATE` `TABLE`, `CREATE` `CLUSTER`, `CREATE` `MATERIALIZED` `VIEW`, `CREATE` `MATERIALIZED` `VIEW` `LOG`, and `CREATE` `INDEX` statements.
**OPTIMAL** The `OPTIMAL` keyword is relevant only to rollback segments. It specifies an optimal size in bytes for a rollback segment. Refer to *size_clause* for information on that clause.
Oracle tries to maintain this size for the rollback segment by dynamically deallocating extents when their data is no longer needed for active transactions. Oracle deallocates as many extents as possible without reducing the total size of the rollback segment below the `OPTIMAL` value.
The value of `OPTIMAL` cannot be less than the space initially allocated by the `MINEXTENTS`, `INITIAL`, `NEXT`, and `PCTINCREASE` parameters. The maximum value depends on your operating system. Oracle rounds values up to the next multiple of the data block size.
**NULL** Specify `NULL` for no optimal size for the rollback segment, meaning that Oracle never deallocates the extents of the rollback segment. This is the default behavior.
**BUFFER_POOL** The `BUFFER_POOL` clause lets you specify a default buffer pool or cache for a schema object. All blocks for the object are stored in the specified cache.
- If you define a buffer pool for a partitioned table or index, then the partitions inherit the buffer pool from the table or index definition unless overridden by a partition-level definition.
- For an index-organized table, you can specify a buffer pool separately for the index segment and the overflow segment.
**Restrictions on the BUFFER_POOL Parameter** `BUFFER_POOL` is subject to the following restrictions:
- You cannot specify this clause for a cluster table. However, you can specify it for a cluster.
- You cannot specify this clause for a tablespace or a rollback segment.
**KEEP** Specify `KEEP` to put blocks from the segment into the `KEEP` buffer pool. Maintaining an appropriately sized `KEEP` buffer pool lets Oracle retain the schema object in memory to avoid I/O operations. `KEEP` takes precedence over any `NOCACHE` clause you specify for a table, cluster, materialized view, or materialized view log.
**RECYCLE** Specify `RECYCLE` to put blocks from the segment into the `RECYCLE` pool. An appropriately sized `RECYCLE` pool reduces the number of objects whose default pool is the `RECYCLE` pool from taking up unnecessary cache space.
**DEFAULT** Specify `DEFAULT` to indicate the default buffer pool. This is the default for objects not assigned to `KEEP` or `RECYCLE`.
**See Also:**   *Oracle Database Performance Tuning Guide* for more information about using multiple buffer pools
## FLASH_CACHE
The `FLASH_CACHE` clause lets you override the automatic buffer cache policy and specify how specific schema objects are cached in flash memory. To use this clause, Database Smart Flash Cache (flash cache) must be configured on your system. The flash cache is an extension of the database buffer cache that is stored on a flash disk, a storage device that uses flash memory. Because flash memory is faster than magnetic disks, the database can improve performance by caching buffers in the flash cache instead of reading from magnetic disk.
## KEEP
Specify `KEEP` if you want the schema object buffers to remain cached in the flash cache as long as the flash cache is large enough.
## NONE
Specify `NONE` to ensure that the schema object buffers are never cached in the flash cache. This allows you to reserve the flash cache space for more frequently accessed objects.
## DEFAULT
Specify `DEFAULT` if you want the schema object buffers to be written to the flash cache when they are aged out of main memory, and then be aged out of the flash cache with the standard buffer cache replacement algorithm. This is the default if flash cache is configured and you do not specify `KEEP` or `NONE`.
**Note:**   Database Smart Flash Cache is available only in Solaris and Oracle Linux.
```

```
## ENCRYPT
This clause is valid only when you are creating a tablespace. Specify `ENCRYPT` to encrypt the entire tablespace. You must also specify the `ENCRYPTION` clause in the `CREATE` `TABLESPACE` statement.
**Note:**   The `ENCRYPT` clause is supported for backward compatibility. However, beginning with Oracle Database 12*c* Release 2 (12.2), you can instead specify `ENCRYPT` in the *tablespace_encryption_clause*. Refer to the *tablespace_encryption_clause* of `CREATE` `TABLESPACE` for more information.
## Example
**Specifying Table Storage Attributes: Example** The following statement creates a table and provides storage parameter values:
```
CREATE TABLE divisions
    (div_no     NUMBER(2),
     div_name   VARCHAR2(14),
     location   VARCHAR2(13) )
     STORAGE  ( INITIAL 8M MAXSIZE 1G );
```
The following statement queries the table for the size of the first extent:
```
SELECT INITIAL_EXTENT FROM USER_TABLES WHERE TABLE_NAME='DIVISIONS';
INITIAL_EXTENT
--------------
       8388608
```
Oracle allocates space for the table based on the `STORAGE` parameter values as follows:
- The INITIAL value is 8M, so the size of the first extent is 8 megabytes.
- The MAXSIZE value is 1G, so the maximum size of the storage element is 1 gigabyte.
