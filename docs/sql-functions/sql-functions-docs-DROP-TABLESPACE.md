# DROP TABLESPACE

## Purpose
Use the `DROP` `TABLESPACE` statement to remove a tablespace from the database.
When you drop a tablespace, Oracle Database does not place it in the recycle bin. Therefore, you cannot subsequently either purge or undrop the tablespace.
**See Also:**   CREATE TABLESPACE and ALTER TABLESPACE for information on creating and modifying a tablespace
## Prerequisites
You must have the `DROP` `TABLESPACE` system privilege. You cannot drop a tablespace if it contains any rollback segments holding active transactions.
## Syntax
## *drop_tablespace*::=
Description of the illustration drop_tablespace.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to drop an existing tablespace.
## *tablespace*
Specify the name of the tablespace to be dropped, including those of shadow tablespaces, that store lost write protection updates.
You can drop a tablespace regardless of whether it is online or offline. Oracle recommends that you take the tablespace offline before dropping it to ensure that no SQL statements in currently running transactions access any of the objects in the tablespace.
You cannot drop the `SYSTEM` tablespace. You can drop the `SYSAUX` tablespace only if you have the `SYSDBA` system privilege and you have started the database in `UPGRADE` mode.
You may want to alert any users who have been assigned the tablespace as either a default or temporary tablespace. After the tablespace has been dropped, these users cannot allocate space for objects or sort areas in the tablespace. You can reassign users new default and temporary tablespaces with the `ALTER` `USER` statement.
Any objects that were previously dropped from the tablespace and moved to the recycle bin are purged from the recycle bin. Oracle Database removes from the data dictionary all metadata about the tablespace and all data files and temp files in the tablespace. The database also automatically drops from the operating system any Oracle-managed data files and temp files in the tablespace. Other data files and temp files are not removed from the operating system unless you specify `INCLUDING` `CONTENTS` `AND` `DATAFILES`.
You cannot use this statement to drop a tablespace group. However, if *tablespace* is the only tablespace in a tablespace group, then Oracle Database removes the tablespace group from the data dictionary as well.
**Restrictions on Dropping Tablespaces** Dropping tablespaces is subject to the following restrictions:
- You cannot drop a tablespace that contains a domain index or any objects created by a domain index.
- You cannot drop an undo tablespace if it is being used by any instance or if it contains any undo data needed to roll back uncommitted transactions.
- You cannot drop a tablespace that has been designated as the default tablespace for the database. You must first reassign another tablespace as the default tablespace and then drop the old default tablespace.
- You cannot drop a temporary tablespace if it is part of the database default temporary tablespace group. You must first remove the tablespace from the database default temporary tablespace group and then drop it.
- You cannot drop a temporary tablespace if it contains segments that are in use by existing sessions. In this case, no error is raised. The database waits until there are no segments in use by existing sessions and then drops the tablespace.
````````********
- You cannot drop a tablespace, even with the INCLUDING CONTENTS and CASCADE CONSTRAINTS clauses, if doing so would disable a primary key or unique constraint in another tablespace. For example, if the tablespace being dropped contains a primary key index, but the primary key column itself is in a different tablespace, then you cannot drop the tablespace until you have manually disabled the primary key constraint in the other tablespace. See Also: Oracle Database Data Cartridge Developer’s Guide and Oracle Database Concepts for more information on domain indexes
## { DROP | KEEP } QUOTA
Specify `DROP` `QUOTA` to drop all user quotas for the tablespace. Specify `KEEP` `QUOTA` to retain all user quotas for the tablespace. The default is `KEEP` `QUOTA`.
You can view all user quotas for a tablespace by querying the `DBA_TS_QUOTAS` data dictionary view.
## INCLUDING CONTENTS
Specify `INCLUDING` `CONTENTS` to drop all the contents of the tablespace, including those of shadow tablespaces that store lost write protection updates. You must specify this clause to drop a tablespace that contains any database objects. If you omit this clause, and the tablespace is not empty, then the database returns an error and does not drop the tablespace.
`DROP` `TABLESPACE` fails, even if you specify `INCLUDING` `CONTENTS`, if the tablespace contains some, but not all, of the partitions or subpartitions of a single table. If all the partitions or subpartitions of a partitioned table reside in *tablespace*, then `DROP` `TABLESPACE` … `INCLUDING` `CONTENTS` drops *tablespace*, as well as any associated index segments, LOB data and index segments, and nested table data and index segments of *table* in other tablespace(s).
For a partitioned index-organized table, if all the primary key index segments are in this tablespace, then this clause will also drop any overflow segments that exist in other tablespaces, as well as any associated mapping table in other tablespaces. If some of the primary key index segments are *not* in this tablespace, then the statement will fail. In that case, before you can drop the tablespace, you must use `ALTER` `TABLE` … `MOVE` `PARTITION` to move those primary key index segments into this tablespace, drop the partitions whose overflow data segments are not in this tablespace, and drop the partitioned index-organized table.
If the tablespace contains a master table of a materialized view, then the database invalidates the materialized view.
If the tablespace contains a materialized view log, then the database drops the log and any other direct-path `INSERT` refresh information associated with the table.
**AND DATAFILES**
When you specify `INCLUDING` `CONTENTS`, the `AND` `DATAFILES` clause lets you instruct the database to delete the associated operating system files as well. Oracle Database writes a message to the alert log for each operating system file deleted. This clause is not needed for Oracle Managed Files, because they are removed from the system even if you do not specify `AND` `DATAFILES`.
**KEEP DATAFILES**
When you specify `INCLUDING` `CONTENTS`, the `KEEP` `DATAFILES` clause lets you instruct the database to leave untouched the associated operating system files, including Oracle Managed Files. You must specify this clause if you are using Oracle Managed Files and you do not want the associated operating system files removed by the `INCLUDING` `CONTENTS` clause.
**CASCADE CONSTRAINTS**
Specify `CASCADE` `CONSTRAINTS` to drop all referential integrity constraints from tables outside *tablespace* that refer to primary and unique keys of tables inside *tablespace*. If you omit this clause and such referential integrity constraints exist, then Oracle Database returns an error and does not drop the tablespace.
## Examples
**Dropping a Tablespace: Example**
The following statement drops the `tbs_01` tablespace and drops all referential integrity constraints that refer to primary and unique keys inside `tbs_01`:
```
DROP TABLESPACE tbs_01 INCLUDING CONTENTS CASCADE CONSTRAINTS;
```
**Dropping a Shadow Tablespace: Example**
The following statement tries to move the tracked data in the shadow tablespace to another shadow tablespace. This only works if there are shadow tablespaces in the PDB with enough free space.
```
DROP TABLESPACE
```
The following statement drops the shadow tablespace and all its contents. All the tracking data is lost.
**Dropping Shadow Tablespace Including Contents: Example**
```
DROP TABLESPACE INCLUDING CONTENTS
```
**Deleting Operating System Files: Example**
The following example drops the `tbs_02` tablespace and deletes all associated operating system data files:
```
DROP TABLESPACE tbs_02 INCLUDING CONTENTS AND DATAFILES;
```
