# ALTER DISKGROUP

**Note:**   This SQL statement is valid only if you are using Oracle ASM and you have started an Oracle ASM instance. You must issue this statement from within the Oracle ASM instance, not from a normal database instance. For information on starting an Oracle ASM instance, refer to *Oracle Automatic Storage Management Administrator’s Guide*.
## Purpose
The `ALTER` `DISKGROUP` statement lets you perform a number of operations on a disk group or on the disks in a disk group.
**See Also:**
- CREATE DISKGROUP for information on creating disk groups
**
- Oracle Automatic Storage Management Administrator’s Guide for information on Oracle ASM and using disk groups to simplify database administration
## Prerequisites
You must have an Oracle ASM instance started from which you issue this statement. The disk group to be modified must be mounted.
You can issue all `ALTER` `DISKGROUP` clauses if you have the `SYSASM` system privilege. You can issue specific clauses as follows:
``````******
- The SYSOPER privilege permits the following subset of the ALTER DISKGROUP operations: diskgroup_availability, rebalance_diskgroup_clause, check_diskgroup_clause (without the REPAIR option).
````
````````
  - ALTER DISKGROUP ... ADD DIRECTORY
````````````
  - ALTER DISKGROUP ... ADD/ALTER/DROP TEMPLATE (nonsystem templates only)
````````
  - ALTER DISKGROUP ... ADD USERGROUP
  - SELECT
````
  - SHOW PARAMETER
Table 10-1 shows additional privileges granted to users connected as `SYSDBA` under the conditions shown:
Table 1 Conditional Diskgroup Privileges for SYSDBA

| ALTER DISKGROUP Operation | Condition |
|---|---|
| DROP FILE | User must have read-write permission on the file. |
| ADD ALIAS | User must have read-write permission on the related file. |
| RENAME ALIAS | User must have read-write permission on the related file. |
| DROP ALIAS | User must have read-write permission on the related file. |
| RENAME DIRECTORY | Directory must contain only aliases and no files. User must have DROP ALIAS permissions on all aliases under the directory. |
| DROP DIRECTORY | Directory must contain only aliases and no files. User must have DROP ALIAS permissions on all aliases under the directory. |
| DROP USERGROUP | User must be the owner of the user group. |
| MODIFY FILE | User must be the owner of the file. |
| MODIFY USERGROUP ADD MEMBER | User must be the owner of the user group. |
| MODIFY USERGROUP DROP MEMBER | User must be the owner of the user group. |
| SET PERMISSION | User must be the owner of the file. |
| SET OWNER GROUP | User must be the owner of the file and a member of the user group. |

## Syntax
## *alter_diskgroup*::=
Description of the illustration alter_diskgroup.eps (*add_disk_clause::=*, *drop_disk_clause::=*, *resize_disk_clause::=*, *replace_disk_clause::=*, *rename_disk_clause::=*, *disk_online_clause::=*, *disk_offline_clause::=*, *rebalance_diskgroup_clause::=*, *check_diskgroup_clause::=*, *diskgroup_template_clauses::=*, *diskgroup_directory_clauses::=*, *diskgroup_alias_clauses::=*, *diskgroup_volume_clauses::=*, *diskgroup_attributes::=*, *modify_diskgroup_file::=*, *drop_diskgroup_file_clause::=*, *convert_redundancy_clause::=*, *usergroup_clauses::=*, *user_clauses::=*, *file_permissions_clause::=*, *file_owner_clause::=*, *scrub_clause::=*, *quotagroup_clauses::=*, *filegroup_clauses::=*, *undrop_disk_clause::=*, *diskgroup_availability::=*, *enable_disable_volume::=*)
## *add_disk_clause*::=
Description of the illustration add_disk_clause.eps (*qualified_disk_clause::=*)
## *qualified_disk_clause*::=
Description of the illustration qualified_disk_clause.eps (*size_clause::=*)
## *drop_disk_clause*::=
Description of the illustration drop_disk_clause.eps
## *resize_disk_clause*::=
Description of the illustration resize_disk_clause.eps (*size_clause::=*)
## *replace_disk_clause*::=
Description of the illustration replace_disk_clause.eps
## *rename_disk_clause*::=
Description of the illustration rename_disk_clause.eps
## *disk_online_clause*::=
Description of the illustration disk_online_clause.eps
## *disk_offline_clause*::=
Description of the illustration disk_offline_clause.eps
## *timeout_clause*::=
Description of the illustration timeout_clause.eps
## *rebalance_diskgroup_clause*::=
Description of the illustration rebalance_diskgroup_clause.eps
## *check_diskgroup_clause*::=
Description of the illustration check_diskgroup_clause.eps
## *diskgroup_template_clauses*::=
Description of the illustration diskgroup_template_clauses.eps (*qualified_template_clause::=*)
## *qualified_template_clause*::=
Description of the illustration qualified_template_clause.eps
## *redundancy_clause*::=
Description of the illustration redundancy_clause.eps
## *striping_clause*::=
Description of the illustration striping_clause.eps
## *disk_region_clause*::=
Description of the illustration disk_region_clause.eps
## *diskgroup_directory_clauses*::=
Description of the illustration diskgroup_directory_clauses.eps
## *diskgroup_alias_clauses*::=
Description of the illustration diskgroup_alias_clauses.eps
## *diskgroup_volume_clauses*::=
Description of the illustration diskgroup_volume_clauses.eps (*add_volume_clause::=*, *modify_volume_clause::=*
## *add_volume_clause*::=
Description of the illustration add_volume_clause.eps (*size_clause::=*, *redundancy_clause::=*, *disk_region_clause::=*)
## *size_clause*::=
Description of the illustration size_clause.eps
## *modify_volume_clause*::=
Description of the illustration modify_volume_clause.eps (*disk_region_clause::=*)
## *diskgroup_attributes*::=
Description of the illustration diskgroup_attributes.eps
## *modify_diskgroup_file*::=
Description of the illustration modify_diskgroup_file.eps
## *drop_diskgroup_file_clause*::=
Description of the illustration drop_diskgroup_file_clause.eps
## *convert_redundancy_clause*::=
Description of the illustration convert_redundancy_clause.eps
## *usergroup_clauses*::=
Description of the illustration usergroup_clauses.eps
## *user_clauses*::=
Description of the illustration user_clauses.eps
## *file_permissions_clause*::=
Description of the illustration file_permissions_clause.eps
## *file_owner_clause*::=
Description of the illustration file_owner_clause.eps
## *scrub_clause*::=
Description of the illustration scrub_clause.eps
## *quotagroup_clauses*::=
Description of the illustration quotagroup_clauses.eps
## *filegroup_clauses*::=
Description of the illustration filegroup_clauses.eps (*add_filegroup_clause::=*, *modify_filegroup_clause::=*, *move_to_filegroup_clause::=*, *drop_filegroup_clause::=*)
## *add_filegroup_clause*::=
Description of the illustration add_filegroup_clause.eps
## *modify_filegroup_clause*::=
Description of the illustration modify_filegroup_clause.eps
## *move_to_filegroup_clause*::=
Description of the illustration move_to_filegroup_clause.eps
## *drop_filegroup_clause*::=
Description of the illustration drop_filegroup_clause.eps
## *undrop_disk_clause*::=
Description of the illustration undrop_disk_clause.eps
## *diskgroup_availability*::=
Description of the illustration diskgroup_availability.eps
## *enable_disable_volume*::=
Description of the illustration enable_disable_volume.eps
## Semantics
## *diskgroup_name*
Specify the name of the disk group you want to modify. To determine the names of existing disk groups, query the `V$ASM_DISKGROUP` dynamic performance view.
## *add_disk_clause*
Use this clause to add one or more disks to the disk group and specify attributes for the newly added disk. Oracle ASM automatically rebalances the disk group as part of this operation.
You cannot use this clause to change the failure group of a disk. Instead you must drop the disk from the disk group and then add the disk back into the disk group as part of the new failure group.
To determine the names of the disks already in this disk group, query the `V$ASM_DISK` dynamic performance view.
**QUORUM | REGULAR** The semantics of these keyword are the same as the semantics in a `CREATE` `DISKGROUP` statement. See QUORUM | REGULAR for more information on these keywords.
You cannot change this qualifier for an existing disk or disk group. Therefore, you cannot specify in this clause a keyword different from the keyword that was specified when the disk group was created.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for more information about the use of these keywords **FAILGROUP Clause** Use this clause to assign the newly added disk to a failure group. If you omit this clause and you are adding the disk to a normal or high redundancy disk group, then Oracle Database automatically adds the newly added disk to its own failure group. The implicit name of the failure group is the same as the operating system independent disk name (see “NAME Clause”).
You cannot specify this clause if you are creating an external redundancy disk group.
## *qualified_disk_clause*
This clause has the same semantics in `CREATE` `DISKGROUP` and `ALTER` `DISKGROUP` statements. For complete information on this clause, refer to *qualified_disk_clause* in the documentation on `CREATE` `DISKGROUP`.
## *drop_disk_clause*
Use this clause to drop one or more disks from the disk group.
**DROP DISK** The `DROP` `DISK` clause lets you drop one or more disks from the disk group and automatically rebalance the disk group. When you drop a disk, Oracle ASM relocates all the data from the disk and clears the disk header so that it no longer is part of the disk group. The disk header is not cleared if you specify the `FORCE` keyword.
Specify *disk_name* as shown in the `NAME` column of the `V$ASM_DISK` dynamic performance view.
If a disk to be dropped is a quorum disk or belongs to a quorum failure group, then you must specify `QUORUM` in order to drop the disk. See QUORUM | REGULAR.
**DROP DISKS IN FAILGROUP** The `DROP` `DISKS` `IN` `FAILGROUP` clause lets you drop all the disks in the specified failure group. The behavior is otherwise the same as that for the `DROP` `DISK` clause.
If the specified failure group is a quorum failure group, then you must specify the `QUORUM` keyword in order to drop the disks. See QUORUM | REGULAR.
**FORCE | NOFORCE** These keywords let you specify when the disk is considered to be no longer part of the disk group. The default and recommended setting is `NOFORCE`.
****``````````````````````**``````
- When you specify NOFORCE, Oracle ASM reallocates all of the extents of the disk to other disks and then expels the disk from the disk group and rebalances the disk group. Note: DROP DISK … NOFORCE returns control to the user before the disk can be safely reused or removed from the system. To ensure that the drop disk operation has completed, query the V$ASM_DISK view to verify that HEADER_STATUS has the value FORMER. Do not attempt to remove or reuse a disk if STATE has the value DROPPING. Query the V$ASM_OPERATION view for approximate information on how long it will take to complete the rebalance resulting from dropping the disk.If you also specify REBALANCE … WAIT (see rebalance_diskgroup_clause), then the statement will not return until the rebalance operation is complete and the disk has been cleared. However, you should always verify that the HEADER_STATUS column of V$ASM_DISK is FORMER, because of the unlikely event the rebalance operations fails.
``````
- When you specify FORCE, Oracle Database expels the disk from the disk group immediately. It then reconstructs the data from the redundant copies on other disks, reallocates the data to other disks, and rebalances the disk group. The FORCE clause can be useful, for example, if Oracle ASM can no longer read the disk to be dropped. However, it is more time consuming than a NOFORCE drop, and it can leave portions of a file with reduced protection. You cannot specify FORCE for an external redundancy disk group at all, because in the absence of redundant data on the disk, Oracle ASM must read the data from the disk before it can be dropped.
The rebalance operation invoked when a disk is dropped is time consuming, whether or not you specify `FORCE` or `NOFORCE`. You can monitor the progress by querying the `V$ASM_OPERATION` dynamic performance view. Refer to *rebalance_diskgroup_clause* for more information on rebalance operations.
## *resize_disk_clause*
Use this clause to specify a new size for every disk in a disk group. This clause lets you override the size returned by the operating system or the size you specified previously for the disks.
**SIZE**
Specify the new size in kilobytes, megabytes, gigabytes, or terabytes. You cannot specify a size greater than the capacity of the disk. If you specify a size smaller than the disk capacity, then you limit the amount of disk space Oracle ASM will use. If you omit this clause, then Oracle ASM attempts programatically to determine the size of the disks.
## *replace_disk_clause*
Use this clause to replace one or more disks in the disk group. This clause allows you to replace disks with a single operation, which is more efficient than dropping and adding each disk.
For *disk_name*, specify the name of the disk you want to replace. This name is assigned to the replacement disk. You can view disk names by querying the `NAME` column of the `V$ASM_DISK` dynamic performance view.
For *path_name*, specify the full path name for the replacement disk.
**FORCE**
Specify `FORCE` if you want Oracle ASM to add the replacement disk to the disk group even if the replacement disk is already a member of a disk group.
**Note:**   Using `FORCE` in this way may destroy existing disk groups.
**NOFORCE**
Specify `NOFORCE` if you want Oracle ASM to return an error if the replacement disk is already a member of a disk group. `NOFORCE` is the default.
**POWER**
The `POWER` clause has the same semantics here as for a manual rebalancing of a disk group, except that the power value cannot be set to
  - See POWER.
**WAIT | NOWAIT**
The `WAIT` and `NOWAIT` keywords have the same semantics here as for a manual rebalancing of a disk group. See WAIT | NOWAIT.
## *rename_disk_clause*
Use this clause to rename one or more disks in the disk group. The disk group must be in the `MOUNT` `RESTRICTED` state and all disks in the disk group must be online.
**RENAME DISK**
Specify this clause to rename one or more disks. For each disk, specify the *old_disk_name* and *new_disk_name*. If *new_disk_name* already exists, then this operation fails.
**RENAME DISKS ALL**
Specify this clause to rename all disks in the disk group to a name of the form *diskgroupname_####*, where *####* is the disk number. Disk names that are already in the *diskgroupname_####* format are not changed.
## *disk_online_clause*
Use this clause to bring one or more disks online and rebalance the disk group.
**ONLINE DISK**
The `ONLINE` `DISK` clause lets you bring one or more specified disks online and rebalance the disk group.
Specify *disk_name* as shown in the `NAME` column of the `V$ASM_DISK` dynamic performance view.
The `QUORUM` and `REGULAR` keywords have the same semantics here as they have when adding a disk to a disk group. See QUORUM | REGULAR.
**ONLINE DISKS IN FAILGROUP**
The `ONLINE` `DISKS` `IN` `FAILGROUP` clause lets you bring all disks in the specified failure group online and rebalance the disk group.
If the specified failure group is a quorum failure group, then you must specify the `QUORUM` keyword in order to bring the disks online. See QUORUM | REGULAR.
**ALL**
The `ALL` clause lets you bring all disks in the disk group online and rebalance the disk group.
**POWER**
The `POWER` clause has the same semantics here as for a manual rebalancing of a disk group. See POWER
**WAIT | NOWAIT**
The `WAIT` and `NOWAIT` keywords have the same semantics here as for a manual rebalancing of a disk group. See WAIT | NOWAIT.
## *disk_offline_clause*
Use the *disk_offline_clause* to take one or more disks offline. This clause fails if the redundancy level of the disk group would be violated by taking the specified disks offline.
**OFFLINE DISK**
The `OFFLINE` `DISK` clause lets you take one or more specified disks offline.
Specify *disk_name* as shown in the `NAME` column of the `V$ASM_DISK` dynamic performance view.
The `QUORUM` and `REGULAR` keywords have the same semantics here as they have when adding a disk to a disk group. See QUORUM | REGULAR.
**OFFLINE DISKS IN FAILGROUP**
The `OFFLINE` `DISKS` `IN` `FAILGROUP` clause lets you take all disks in the specified failure group offline.
If the specified failure group is a quorum failure group, then you must specify the `QUORUM` keyword in order to take the disks offline. See QUORUM | REGULAR.
***timeout_clause***
By default, Oracle ASM drops a disk shortly after it is taken offline. You can delay this operation by specifying the *timeout_clause*, which gives you the opportunity to repair the disk and bring it back online. You can specify the timeout value in units of minute or hour. If you omit the unit, then the default is hour.
You can change the timeout period by specifying this clause multiple times. Each time you specify it, Oracle ASM measures the time from the most recent previous *disk_offline_clause* while the disk group is mounted. To learn how much time remains before Oracle ASM will drop an offline disk, query the `REPAIR_TIMER` column of `V$ASM_DISK`.
This clause overrides any previous setting of the `disk_repair_time` attribute. Refer to Table 13-2 for more information about disk group attributes.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for more information about taking Oracle ASM disks online and offline
## *rebalance_diskgroup_clause*
Use this clause to manually rebalance the disk group. During a rebalance operation, Oracle ASM redistributes data files evenly across all drives. This clause is rarely necessary, because Oracle ASM allocates files evenly and automatically rebalances disk groups when the storage configuration changes. However, it is useful if you want to perform a controlled rebalance operation. It allows you to include or exclude certain phases of a rebalance operation, pause and restart a rebalance operation, and adjust the power of a rebalance operation.
**WITH | WITHOUT**
A rebalance operation consists of the following phases: `RESTORE` (includes the `RESYNC`, `RESILVER`, or `REBUILD` phases), `BALANCE`, `PREPARE`, and `COMPACT`.
You can use the `WITH` or `WITHOUT` clause to instruct Oracle ASM to include or exclude specific phases of a rebalance operation. For example, if you have time constraints, you can include only the `RESTORE` phase. Or, if you are using flash storage disk groups or disk groups with flash cache, you can exclude the `COMPACT` phase, which is not beneficial for such disk groups.
``````````````
- Use the WITH clause to include only the specified phases of a rebalance operation. You can specify any of phases RESTORE, BALANCE, PREPARE, and COMPACT. It is acceptable, but not necessary, to specify RESTORE, because the RESTORE phase always occurs.
````````````
- Use the WITHOUT clause to exclude the specified phases of a rebalance operation. You can specify any of the phases BALANCE, PREPARE, and COMPACT. You cannot specify RESTORE, because the RESTORE phase must always occur.
The order in which you specify multiple phases in the `WITH` or `WITHOUT` clause does not matter. Oracle ASM will perform the phases of the rebalance operation in the proper order. You cannot specify the `RESYNC`, `RESILVER`, or `REBUILD` phases; they are part of the `RESTORE` phase.
If you omit the `WITH` and `WITHOUT` clauses, then Oracle ASM performs all phases of the rebalance operation.
You can monitor the progress of the rebalance operation by querying the `V$ASM_OPERATION` dynamic performance view.
See *Oracle Automatic Storage Management Administrator’s Guide* for more information on the phases of a rebalance operation.
**POWER**
This clause lets you specify the power, or speed, of the rebalance operation. It also lets you stop the rebalance operation.
For *integer*, specify a value from `0` to `1024`:
````````
- A value of 1 through 1024 specifies the power at which Oracle ASM is to perform the rebalance operation, with 1 representing the lowest possible power and 1024 representing the highest possible power.
````````
- A value of 0 stops an active rebalance operation. No further rebalancing will occur until the start of another manual or automatic rebalance operation on the disk group, and at that time the rebalance operation will start from the beginning. If you would like to have the option of later resuming the rebalance operation from where it left off, then instead stop the rebalance operation by specifying MODIFY POWER 0. See the clause MODIFY POWER for more information.
If you omit the `POWER` clause, then the default power is determined as follows:
``````
- For flex disk groups, Oracle ASM rebalances each file group according the value of its POWER_LIMIT property. If the POWER_LIMIT property is not set for a file group, then Oracle ASM uses the value of the ASM_POWER_LIMIT initialization parameter for the file group.
````
- For all other types of disk groups, if you omit the POWER clause, then Oracle ASM rebalances the disk group according to the value of the ASM_POWER_LIMIT initialization parameter.
**WAIT | NOWAIT**
Use this clause to specify when, in the course of the rebalance operation, control should be returned to the user.
````
- Specify WAIT if you want control returned to the user after the rebalance operation has finished. You can explicitly terminate a rebalance operation running in WAIT mode, although doing so does not undo any completed disk add, drop, or resize operations in the same statement.
- Specify NOWAIT if you want control returned to the user immediately after the statement is issued. This is the default.
**MODIFY POWER** Use this clause to pause, resume, or change the power of an active rebalance operation.
You can specify *integer* as follows:
``````````
- Specify 0 to pause the rebalance operation. When you pause a rebalance operation in this manner, you can subsequently resume the operation from the phase where it left off by issuing an ALTER DISKGROUP ... MODIFY POWER ... statement. If you subsequently start a manual rebalance operation on the disk group using the clause POWER, or an automatic rebalance operation for the disk group occurs, then the rebalance operation will start at the beginning.
``````````````
- Specify 1 through 1024 to specify the power of the rebalance operation, with 1 representing the lowest possible power and 1024 representing the highest possible power. If a rebalance operation is running, then Oracle ASM changes the power without interrupting the operation. If a rebalance operation was previously paused with the MODIFY POWER 0 clause, then the rebalance operation resumes at the specified power.
**``````
```
**See Also:**
- *Oracle Database Reference* for more information on the [ASM_POWER_LIMIT](/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/sqlrf&id=REFRN10246) initialization parameter and the [V$ASM_OPERATION](/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/sqlrf&id=REFRN30173) dynamic performance view
- [Rebalancing a Disk Group: Example](ALTER-DISKGROUP.html#GUID-22D73AB6-7063-4627-A2ED-18D521ED2557__BGEJBJJJ)
```
- Omit integer to specify the default power. If a rebalance operation is running, then Oracle ASM changes the power to the default power without interrupting the operation. If a rebalance operation was previously paused with the MODIFY POWER 0 clause, then the rebalance operation resumes at the default power. Refer to the clause POWER for information on how the default power is determined.
```
## *drop_diskgroup_file_clause*
Use this clause to drop a file from the disk group. Oracle ASM also drops all aliases associated with the file being dropped. You must use one of the reference forms of the filename. Most Oracle ASM files do not need to be manually deleted because, as Oracle Managed Files, they are removed automatically when they are no longer needed. Refer to *ASM_filename* for information on the reference forms of Oracle ASM filenames.
You cannot drop a disk group file it if is the spfile that was used to start up the current instance or any instance in the Oracle ASM cluster.
## *convert_redundancy_clause*
You can use this clause to convert a `NORMAL` `REDUNDANCY` or `HIGH` `REDUNDANCY` disk group to a `FLEX` `REDUNDANCY` disk group. The disk group must have at least three failure groups before you start the conversion.
## *usergroup_clauses*
Use these clauses to add a user group to the disk group, remove a user group from the disk group, or to add a member to or drop a member from an existing user group.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for detailed information about user groups and members, including examples
**ADD USERGROUP**
Use this clause to add a user group to the disk group. You must have `SYSASM` or `SYSDBA` privilege to create a user group. The maximum length of a user group name is 63 bytes. If you specify the user name, then it must be in the OS password file and its length cannot exceed 32 characters.
**MODIFY USERGROUP**
Use these clauses to add a member to or drop a member from an existing user group. You must be an Oracle ASM administrator (with SYSASM privilege) or the creator (with SYSDBA privilege) of the user group to use these clauses. The user name must be an existing user in the OS password file.
**DROP USERGROUP**
Use this clause to drop an existing user group from the disk group. You must be an Oracle ASM administrator (with SYSASM privilege) or the creator (with SYSDBA privilege) of the user group to use this clause. Dropping a user group may leave a disk group file without a valid user group. In this case, you can update the disk group file manually to add a new, valid group using the *file_permissions_clause*.
## *user_clauses*
Use these clauses to add a user to, drop a user from, or replace a user in a disk group.
  **Note:**   When administering users with SQL*Plus, the users must be existing operating system users and their user names must have corresponding operating system user IDs. However, only users in the same cluster as the Oracle ASM instance can be validated.
**ADD USER**
Use this clause to add one or more operating system (OS) users to an Oracle ASM disk group and give those users access privileges on the disk group. A user name must be an existing user in the OS password file and its length cannot exceed 32 characters. If a specified user already exists in the disk group, as shown by `V$ASM_USER`, then the command records an error and continues to add other users, if any have been specified. This command is seldom needed, because the OS user running the database instance is added to a disk group automatically when the instance accesses the disk group. However, this clause is useful when adding users that are not associated with a particular database instance.
**DROP USER**
Use this clause to drop one or more users from the disk group. If a specified user is not in the disk group, then this clause records an error and continues to drop other users, if any are specified. If the user owns any files, then you must specify the `CASCADE` keyword, which drops the user and all the user’s files. If any files owned by the user are open, then `DROP` `USER` `CASCADE` fails with an error.
To delete a user without deleting the files owned by that user, change the owner of each of these files to another user and then issue an `ALTER` `DISKGROUP` … `DROP` `USER` statement on the user. Alternatively, you can issue an `ALTER` `DISKGROUP` … `REPLACE` `USER` statement to replace the user you want to drop with a user that currently does not exist in the disk group. This operation has the side effect of making the new user the owner of files that were previously owned by the dropped user.
**REPLACE USER**
Use this clause to replace *old_user* with *new_user* in the disk group. All files that are currently owned by *old_user* will become owned by *new_user*, and *old_user* will be dropped from the disk group. *old_user* must exist in the disk group and *new_user* must not exist in the disk group.
## *file_permissions_clause*
Use this clause to change the permission settings of a disk group file. The three classes of permissions are owner, user group, and other. You must be the file owner or the Oracle ASM administrator to use this clause.
If you change the permission settings of an open file, then the operation currently running on the file will complete using the old permission settings. The new permission settings will take effect when re-authentication is required.
## *file_owner_clause*
Use this clause to set the owner or user group for a specified file. You must be the Oracle ASM administrator to change the owner of the file. You must be the owner of the file or the Oracle ASM administrator to change the user group of a file. In addition, to change the associated user group of a file, the specified user group must already exist in the disk group, and the owner of the file must be a member of that user group.
If you use this clause on an open file, then the following conditions apply:
- If you change the owner or user group of an open file, then the operation currently running on the file will complete using the old owner or user group. The new owner or user group will take effect when re-authentication is required.
- If you change the owner of an open file, then the new owner of the file cannot be dropped from the disk group until the instance has been restarted. In an Oracle ASM cluster, the new owner of the file cannot be dropped until all instances in the cluster have been restarted.
- If you change the owner of an open file, then the old owner cannot be dropped while the file is still open, even after the ownership of the file has changed.
## *scrub_clause*
Use this clause to scrub a disk group. The scrub operation checks for logical data corruptions and repairs the corruptions automatically in normal and high redundancy disks groups.
****
- Use the FILE clause to scrub the specified Oracle ASM file in the disk group. You must use one of the reference forms of the ASM_filename. Refer to ASM_filename for information on the reference forms of Oracle ASM filenames.
- Use the DISK clause to scrub the specified disk in the disk group.
````
- If you do not specify FILE or DISK, then all files and disks in the disk group are scrubbed.
**REPAIR | NOREPAIR** Specify `REPAIR` to attempt to repair any errors found during the logical data corruption check. Specify `NOREPAIR` to be alerted of any corruptions; Oracle ASM will not take any action to resolve them. The default is `NOREPAIR`.
**POWER** Use the `POWER` clause to specify the power level of the scrub operation. Valid values are `AUTO`, `LOW`, `HIGH`, and `MAX`. If you omit this clause, then the power level defaults to `AUTO` and the power adjusts to the optimum level for the system.
**WAIT | NOWAIT** Specify `WAIT` to allow the scrub operation to complete before returning control to the user. Specify `NOWAIT` to add the operation to the scrubbing queue and return control to the user immediately. The default is `NOWAIT`.
**FORCE | NOFORCE** Specify `FORCE` to process the command even if the system I/O load is high or scrubbing has been disabled at the system level. Specify `NOFORCE` to process the command normally. The default is `NOFORCE`.
**STOP** Specify `STOP` if you want to stop an ongoing scrub operation.
You can monitor the progress of the scrub operation by querying the `V$ASM_ OPERATION` dynamic performance view.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for more information on scrubbing disk groups and “Scrubbing a Disk Group: Example”
## *quotagroup_clauses*
Use these clauses to add a quota group to the disk group, modify a quota group, move a file group into a quota group, or drop a quota group.
A quota group is a collection of file groups. A file group is a container for all files of a database within one disk group. A quota group has a specified quota limit, which is the maximum amount of storage space that its file groups can collectively use. Therefore, a quota group enables you to define the quota limit for a group of databases within a disk group. The sum of the quota limits for all quota groups in a disk group can exceed the storage capacity of the disk group.
Each disk group contains a default quota group named `GENERIC`. If you create a file group and do not specify its quota group, then the file group belongs to the `GENERIC` quota group. Oracle ASM automatically creates the `GENERIC` quota group when you create a disk group with the `compatible`.`asm` attribute set to `12`.`2` or higher, or when you set `compatible`.`asm` to `12`.`2` or higher for an existing disk group. Initially, the quota limit for `GENERIC` is `UNLIMITED`. You can subsequently modify this quota limit with the `MODIFY` `QUOTAGROUP` clause.
**ADD QUOTAGROUP** Use this clause to create a quota group and add it to the disk group. For *quotagroup_name*, specify the name of the new quota group.
The `SET` clause allows you to set the quota limit for the quota group.
**
- For property_name, specify QUOTA.
** **
  - Specify size_clause to set a number of bytes for the quota limit. The minimum value you can specify is 1 byte. You can specify a value that is greater than the storage size of the disk group. In this case, storage use is limited by the current size of the disk group. However, if you subsequently increase the storage space for the disk group to a size that exceeds the quota limit, then the quota limit will be enforced. Refer to size_clause for the syntax and semantics of this clause. Note that specifying 0 bytes is equivalent to specifying UNLIMITED.
  - Specify UNLIMITED if you do not want to set a quota limit. In this case, storage use is limited by the storage size of the disk group.
If you omit the `SET` clause, then the default is `SET QUOTA=UNLIMITED`.
**MODIFY QUOTAGROUP** Use this clause to modify the quota limit for a quota group. For *quotagroup_name*, specify the name of the quota group you want to modify. You can modify the quota limit for any quota group, including the `GENERIC` quota group. The `SET` clause has the same semantics here as for the `ADD` `QUOTAGROUP` clause. The quota limit can be set below the amount of space currently used by the quota group. This action prevents any additional space from being allocated for files described by file groups associated with this quota group.
**MOVE FILEGROUP** Use this clause to move a file group from one quota group to another. For *filegroup_name*, specify the file group you want to move. For *quotagroup_name*, specify the name of the destination quota group. If the move operation causes the amount of used storage space in the destination quota group to exceed the quota limit, then the operation succeeds, but no new storage allocations can take place in the file groups within the quota group. This capability enables you to stop any files described by a specific file group from allocating additional space.
**DROP QUOTAGROUP** Use this clause to drop a quota group from the disk group. For *quotagroup_name*, specify the quota group you want to drop. The quota group must not contain any file groups. You cannot drop the quota group `GENERIC`.
**See Also:**   *Automatic Storage Management Administrator’s Guide* for more information on quota groups
## *filegroup_clauses*
The *filegroup_clauses* are valid only for flex disk groups. Use these clauses to create a file group, modify a file group, move a file into a file group, or drop a file group. A file group is a container for all files of a database within one disk group. A file group must belong to a quota group.
Each disk group has a default file group with `FILEGROUP_NUMBER` `=` `0`.
## *add_filegroup_clause*
Use this clause to create a file group.
For *filegroup_name*, specify the name of the new file group. The maximum length of a file group name is 127 characters. The name must satisfy the requirements listed in “Database Object Naming Rules”, with the following addition: File group names are not case sensitive, even if you specify them with quotation marks. They are always stored internally as uppercase. File group names must be unique within a disk group.
- Use the DATABASE clause to specify the database (non-CDB, CDB, or PDB) with which the file group is associated.
- Use the CLUSTER clause to specify the cluster with which the file group is associated.
- Use the VOLUME clause to specify the volume with which the file group is associated.
You cannot associate more than one file group in the same disk group with the same database, cluster, or volume. If the database, cluster, or volume does not exist at the time of file group creation, then the file group will be automatically associated with it when it is subsequently created. Database, cluster, and volume names must satisfy the requirements listed in “Database Object Naming Rules”.
The `SET` clause allows you to set properties for the file group. If you do not specify the `SET` clause for a property, then the default value is assigned. You can specify the *file_type* for any property for which a file type applies. If you do not specify *file_type* for such a property, then the property applies to all file types. For complete information on file group properties and their default values, see *Oracle Automatic Storage Management Administrator’s Guide*.
## *modify_filegroup_clause*
Use this clause to modify file group properties. For *filegroup_name*, specify the name of the file group you want to modify. You can modify properties for any file group, including the default file group. Any that you do not specify with this clause remain unchanged. The `SET` clause has the same semantics here as for the *add_filegroup_clause*.
## *move_to_filegroup_clause*
Use this clause to move a file to a file group. If the file is currently associated with a different file group, then it is disassociated from that file group. The target file group must have enough space available to contain the file. You must be the owner of the file and the target file group.
## *drop_filegroup_clause*
Use this clause to drop an empty file group. For *filegroup_name*, specify the name of the file group you want to drop.
**CASCADE** Use the keyword `CASCADE` to drop a file group that is not empty. When a file group is dropped with the keyword `CASCADE`, every file associated with the file group is automatically dropped.
**FOR DATABASE Clause** ****
- If the file group being dropped is associated with a pluggable database, then the FOR PLUGGABLE DATABASE clause names the pluggable database in pdb_name. You must then specify the FOR DATABASE clause naming the container database that contains the pluggable database in db_unique_name.
**
- If the file group being dropped is associated with a non-CDB database, then the FOR DATABASE clause names the non-CDB database in db_unique_name.
``````
````******
- You can specify the CASCADE clause with FOR PLUGGABLE DATABASE and FOR DATABASE. Use the CASCADE option to delete every file associated with the file group as part of the file group drop. When a file group of type DATABASE is dropped using the CASCADE option, ASM checks the OMF (Oracle Managed File) file name of the files being deleted to verify that they belong to the database or pluggable database that is associated with the file group being dropped. See Also: Automatic Storage Management Administrator’s Guide for more information on file groups
## *undrop_disk_clause*
Use this clause to cancel the drop of disks from the disk group. You can cancel the pending drop of all the disks in one or more disk groups (by specifying *diskgroup_name*) or of all the disks in all disk groups (by specifying `ALL`).
This clause is not relevant for disks that have already been completely dropped from the disk group or for disk groups that have been completely dropped. This clause results in a long-running operation. You can see the status of the operation by querying the `V$ASM_OPERATION` dynamic performance view.
**See Also:**   `V$ASM_OPERATION` for more information on the details of long-running Oracle ASM operations
## *diskgroup_availability*
Use this clause to make one or more disk groups available or unavailable to the database instances running on the same node as the Oracle ASM instance. This clause does not affect the status of the disk group on other nodes in a cluster.
**MOUNT** Specify `MOUNT` to mount the disk groups in the local Oracle ASM instance. Specify `ALL` `MOUNT` to mount all disk groups specified in the `ASM_DISKGROUPS` initialization parameter. File operations can only be performed when a disk group is mounted. If Oracle ASM is running in a cluster or a standalone server managed by Oracle Grid Infrastructure for a standalone server, then the `MOUNT` clause automatically brings the corresponding resource online.
**RESTRICTED | NORMAL** Use these clauses to determine the manner in which the disk groups are mounted.
- In the RESTRICTED mode, the disk group is mounted in single-instance exclusive mode. No other Oracle ASM instance in the same cluster can mount that disk group. In this mode the disk group is not usable by any Oracle ASM client.
- In the NORMAL mode, the disk group is mounted in shared mode, so that other Oracle ASM instances and clients can access the disk group. This is the default.
**FORCE | NOFORCE** Use these clauses to determine the circumstances under which the disk groups are mounted.
``````
**``````````
````````
- In the FORCE mode, Oracle ASM attempts to mount the disk group even if it cannot discover all of the devices that belong to the disk group. This setting is useful if some of the disks in a normal or high redundancy disk group became unavailable while the disk group was dismounted. When MOUNT FORCE succeeds, Oracle ASM takes the missing disks offline. If Oracle ASM discovers all of the disks in the disk group, then MOUNT FORCE fails. Therefore, use the MOUNT FORCE setting only if some disks are unavailable. Otherwise, use NOFORCE. In normaland high-redundancy disk groups, disks from one failure group can be unavailable and MOUNT FORCE will succeed. Also in high-redundancy disk groups, two disks in two different failure groups can be unavailable and MOUNT FORCE will succeed. Any other combination of unavailable disks causes the operation to fail, because Oracle ASM cannot guarantee that a valid copy of all user data or metadata exists on the available disks.
****
- In the NOFORCE mode, Oracle ASM does not attempt to mount the disk group unless it can discover all the member disks. This is the default. See Also: ASM_DISKGROUPS for more information about adding disk group names to the initialization parameter file
**DISMOUNT** Specify `DISMOUNT` to dismount the specified disk groups. Oracle ASM returns an error if any file in the disk group is open unless you also specify `FORCE`. Specify `ALL` `DISMOUNT` to dismount all currently mounted disk groups. File operations can only be performed when a disk group is mounted. If Oracle ASM is running in a cluster or a standalone server managed by Oracle Grid Infrastructure for a standalone server, then the `DISMOUNT` clause automatically takes the corresponding resource offline.
**FORCE** Specify `FORCE` if you want Oracle ASM to dismount the disk groups even if some files in the disk group are open.
## *enable_disable_volume*
Use this clause to enable or disable one or more volumes in the disk group.
- For each volume you enable, Oracle ASM creates a volume device file on the local node that can be used to create or mount the file system.
- For each volume you disable, Oracle ASM deletes the device file on the local node. If the volume file is open on the local node, then the DISABLE clause returns an error.
Use the `ALL` keyword to enable or disable all volumes in the disk group. If you specify `ALTER` `DISKGROUP` `ALL` `...`, then you must use the `ALL` keyword in this clause as well.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for more information about disk group volumes
## Examples
The following examples require a disk group called `dgroup_01`. They assume that `ASM_DISKSTRING` is set to `/devices/disks/*`. In addition, they assume the Oracle user has read/write permission to `/devices/disks/d100`. Refer to “Creating a Diskgroup: Example” to create `dgroup_01`.
**Adding a Disk to a Disk Group: Example** To add a disk, `d100`, to a disk group, `dgroup_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  ADD DISK '/devices/disks/d100';
```
**Dropping a Disk from a Disk Group: Example** To drop a disk, `dgroup_01_0000`, from a disk group, `dgroup_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  DROP DISK dgroup_01_0000;
```
**Undropping a Disk from a Disk Group: Example** To cancel the drop of disks from a disk group, `dgroup_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  UNDROP DISKS;
```
**Resizing a Disk Group: Example** To resize every disk in a disk group, `dgroup_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  RESIZE ALL
  SIZE 36G;
```
**Rebalancing a Disk Group: Example** To manually rebalance a disk group, `dgroup_01`, and permit Oracle ASM to execute the rebalance as fast as possible, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  REBALANCE POWER 11 WAIT;
```
The `WAIT` keyword causes the database to wait for the disk group to be rebalanced before returning control to the user.
**Verifying the Internal Consistency of Disk Group Metadata: Example** To verify the internal consistency of Oracle ASM disk group metadata and instruct Oracle ASM to repair any errors found, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  CHECK ALL
  REPAIR;
```
**Adding a Named Template to a Disk Group: Example** To add a named template, `template_01` to a disk group, `dgroup_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  ADD TEMPLATE template_01
    ATTRIBUTES (UNPROTECTED COARSE);
```
**Changing the Attributes of a Disk Group Template: Example** To modify the attributes of a system default or user-defined disk group template, `template_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  MODIFY TEMPLATE template_01
    ATTRIBUTES (FINE);
```
**Dropping a User-Defined Template from a Disk Group: Example** To drop a user-defined template, `template_01`, from a disk group, `dgroup_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  DROP TEMPLATE template_01;
```
**Creating a Directory Path for Hierarchically Named Aliases: Example** To specify the directory structure in which alias names will reside, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  ADD DIRECTORY '+dgroup_01/alias_dir';
```
**Creating an Alias Name for an Oracle ASM Filename: Example** To create a user alias by specifying the numeric Oracle ASM filename, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  ADD ALIAS '+dgroup_01/alias_dir/datafile.dbf'
    FOR '+dgroup_01.261.1';
```
**Scrubbing a Disk Group: Example** To scrub a disk group, `dgroup_01`, issue the following statement. This statement attempts to repair any errors found during the logical data corruption check and allows the scrub operation to complete before returning control to the user.
```
ALTER DISKGROUP dgroup_01
  SCRUB REPAIR WAIT;
```
**Dismounting a Disk Group: Example** To dismount a disk group, `dgroup_01`, issue the following statement. This statement dismounts the disk group even if one or more files are active:
```
ALTER DISKGROUP dgroup_01
  DISMOUNT FORCE;
```
**Mounting a Disk Group: Example** To mount a disk group, `dgroup_01`, issue the following statement:
```
ALTER DISKGROUP dgroup_01
  MOUNT;
```
