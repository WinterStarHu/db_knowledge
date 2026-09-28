# B Automatic and Manual Locking Mechanisms During SQL Operations

This mechanisms that lock data either automatically or as specified by the user during SQL statements. For a general discussion of locking mechanisms in the context of data concurrency and consistency, see *Oracle Database Concepts*.
This the following sections:
- Automatic Locks in DML Operations
- Automatic Locks in DDL Operations
- Manual Data Locking
- List of Nonblocking DDLs
## List of Nonblocking DDLs
Nonblocking DDLs added at each release from 11.2 to 12.2.0.2 are listed here.
**Release 11.2** The following nonblocking DDLs are added as of Release 11.2. Some nonblocking DDLs are downgraded to blocking in the presence of supplemental logging.
**List of Nonblocking DDLs Added in 11.2**
- create index online
- alter index rebuild online
- alter index rebuild partition online
- alter index rebuild subpartition online
- alter index visible / novisible
**List of Nonblocking DDLs Added in 11.2 that Downgrade to Blocking During Supplemental Logging**
- alter table add column not null with default value
- alter table add constraint enable novalidate
- alter table modify constraint validate
- alter table add column (without any default)
**Release 12.1** The following nonblocking DDLs are added as of Release 12.1. Some nonblocking DDLs are downgraded to blocking in the presence of supplemental logging.
**List of Nonblocking DDLs Added in 12.1**
- drop index online
- alter index unusable online
- alter table move partition online
- alter table move subpartition online
**List of Nonblocking DDLs Added in 12.1 that Downgrade to Blocking During Supplemental Logging**
- alter table set unused column online
- alter table drop constraint online
- alter table modify column visible / invisible
- alter table add nullable column with default value
**Release 12.2.0.1** **List of Nonblocking DDLs Added in 12.2.0.1**
- alter table split partition [subpartition] online
- alter table move online (move of a non-partitioned table)
- alter table modify partition by .. online (to convert a non-partitioned table to partitioned state)
**Release 12.2.0.2** **List of Nonblocking DDLs Added in 12.2.0.2**
- Alter table merge partition online
- alter table modify partition by .. online (to change the partitioning schema of a table)
