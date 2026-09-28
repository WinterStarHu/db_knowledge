# ALTER SYSTEM

## Purpose
Use the `ALTER` `SYSTEM` statement to dynamically alter your Oracle Database instance. The settings stay in effect as long as the database is mounted.
When you use the `ALTER` `SYSTEM` statement in a multitenant container database (CDB), you can specify some clauses to alter the CDB as a whole and other clauses to alter a specific pluggable database (PDB).
**See Also:**   *Oracle Database Administrator’s Guide* for complete information on using the `ALTER` `SYSTEM` statement in a CDB
## Prerequisites
To specify the `RELOCATE` `CLIENT` clause, you must be authenticated `AS` `SYSASM`.
To specify all other clauses, you must have the `ALTER` `SYSTEM` system privilege.
If you are connected to a CDB:
````
- To alter the CDB as a whole, the current container must be the root and you must have the commonly granted ALTER SYSTEM privilege.
````
- To alter a PDB, the current container must be the PDB and you must have the ALTER SYSTEM privilege, either granted commonly or granted locally in the PDB.
## Syntax
## *alter_system*::=
Description of the illustration alter_system.eps (*archive_log_clause::=*, *checkpoint_clause::=*, *check_datafiles_clause::=*, *distributed_recov_clauses::=*, *end_session_clauses::=*, *quiesce_clauses::=*, *rolling_migration_clauses::=*, *rolling_patch_clauses::=*, *security_clauses::=*, *shutdown_dispatcher_clause::=*, *alter_system_set_clause::=*, *alter_system_reset_clause::=*, *cancel_sql_clause::=*)
## *archive_log_clause*::=
Description of the illustration archive_log_clause.eps
## *checkpoint_clause*::=
Description of the illustration checkpoint_clause.eps
## *check_datafiles_clause*::=
Description of the illustration check_datafiles_clause.eps
## *distributed_recov_clauses*::=
Description of the illustration distributed_recov_clauses.eps
## *end_session_clauses*::=
Description of the illustration end_session_clauses.eps
## *quiesce_clauses*::=
Description of the illustration quiesce_clauses.eps
## *rolling_migration_clauses*::=
Description of the illustration rolling_migration_clauses.eps
## *rolling_patch_clauses*::=
Description of the illustration rolling_patch_clauses.eps
## *security_clauses*::=
Description of the illustration security_clauses.eps
## *affinity_clauses*::=
Description of the illustration affinity_clauses.eps
## *set_encryption_key*::=
Description of the illustration set_encryption_key.eps
## *shutdown_dispatcher_clause*::=
Description of the illustration shutdown_dispatcher_clause.eps
## *alter_system_set_clause*::=
Description of the illustration alter_system_set_clause.eps
## *set_parameter_clause*::=
Description of the illustration set_parameter_clause.eps
## *alter_system_reset_clause*::=
Description of the illustration alter_system_reset_clause.eps
## *cancel_sql_clause*::=
Description of the illustration cancel_sql_clause.eps
## Semantics
## *archive_log_clause*
The *archive_log_clause* manually archives redo log files or enables or disables automatic archiving. To use this clause, your instance must have the database mounted. The database can be either open or closed unless otherwise noted.
**INSTANCE Clause** This clause is relevant only if you are using Oracle Real Application Clusters (Oracle RAC). Specify the name of the instance for which you want the redo log file group to be archived. The instance name is a string of up to 80 characters. Oracle Database automatically determines the thread that is mapped to the specified instance and archives the corresponding redo log file group. If no thread is mapped to the specified instance, then Oracle Database returns an error.
**SEQUENCE Clause** Specify `SEQUENCE` to manually archive the online redo log file group identified by the log sequence number *integer* in the specified thread. If you omit the `THREAD` parameter, then Oracle Database archives the specified group from the thread assigned to your instance.
**CHANGE Clause** Specify `CHANGE` to manually archive the online redo log file group containing the redo log entry with the system change number (SCN) specified by *integer* in the specified thread. If the SCN is in the current redo log file group, then Oracle Database performs a log switch. If you omit the `THREAD` parameter, then Oracle Database archives the groups containing this SCN from all enabled threads.
You can use this clause only when your instance has the database open.
**CURRENT Clause** Specify `CURRENT` to manually archive the current redo log file group of the specified thread, forcing a log switch. If you omit the `THREAD` parameter, then Oracle Database archives all redo log file groups from all enabled threads, including logs previous to current logs. You can specify `CURRENT` only when the database is open.
**NOSWITCH** Specify `NOSWITCH` if you want to manually archive the current redo log file group without forcing a log switch. This setting is used primarily with standby databases to prevent data divergence when the primary database shuts down. Divergence implies the possibility of data loss in case of primary database failure.
You can use the `NOSWITCH` clause only when your instance has the database mounted but not open. If the database is open, then this operation closes the database automatically. You must then manually shut down the database before you can reopen it.
**GROUP Clause** Specify `GROUP` to manually archive the online redo log file group with the `GROUP` value specified by *integer*. You can determine the `GROUP` value for a redo log file group by querying the dynamic performance view `V$LOG`. If you specify both the `THREAD` and `GROUP` parameters, then the specified redo log file group must be in the specified thread.
**LOGFILE Clause** Specify `LOGFILE` to manually archive the online redo log file group containing the redo log file member identified by ‘*filename*’. If you specify both the `THREAD` and `LOGFILE` parameters, then the specified redo log file group must be in the specified thread.
If the database was mounted with a backup control file, then specify `USING` `BACKUP` `CONTROLFILE` to permit archiving of all online logfiles, including the current logfile.
**Restriction on the LOGFILE clause** You must archive redo log file groups in the order in which they are filled. If you specify a redo log file group for archiving with the `LOGFILE` parameter, and earlier redo log file groups are not yet archived, then Oracle Database returns an error.
**NEXT Clause** Specify `NEXT` to manually archive the next online redo log file group from the specified thread that is full but has not yet been archived. If you omit the `THREAD` parameter, then Oracle Database archives the earliest unarchived redo log file group from any enabled thread.
**ALL Clause** Specify `ALL` to manually archive all online redo log file groups from the specified thread that are full but have not been archived. If you omit the `THREAD` parameter, then Oracle Database archives all full unarchived redo log file groups from all enabled threads.
**TO** ***location*** **Clause** Specify `TO` ‘*location*’ to indicate the primary location to which the redo log file groups are archived. The value of this parameter must be a fully specified file location following the conventions of your operating system. If you omit this parameter, then Oracle Database archives the redo log file group to the location specified by the initialization parameters `LOG_ARCHIVE_DEST` or `LOG_ARCHIVE_DEST_`*n*.
## *checkpoint_clause*
Specify `CHECKPOINT` to explicitly force Oracle Database to perform a checkpoint, ensuring that all changes made by committed transactions are written to data files on disk. You can specify this clause only when your instance has the database open. Oracle Database does not return control to you until the checkpoint is complete.
**GLOBAL** In an Oracle Real Application Clusters (Oracle RAC) environment, this setting causes Oracle Database to perform a checkpoint for all instances that have opened the database. This is the default.
**LOCAL** In an Oracle RAC environment, this setting causes Oracle Database to perform a checkpoint only for the thread of redo log file groups for the instance from which you issue the statement.
**See Also:**   “Forcing a Checkpoint: Example”
## *check_datafiles_clause*
In a distributed database system, such as an Oracle RAC environment, this clause updates an instance’s SGA from the database control file to reflect information on all online data files.
- Specify GLOBAL to perform this synchronization for all instances that have opened the database. This is the default.
- Specify LOCAL to perform this synchronization only for the local instance.
Your instance should have the database open.
## *distributed_recov_clauses*
The `DISTRIBUTED` `RECOVERY` clause lets you enable or disable distributed recovery. To use this clause, your instance must have the database open.
**ENABLE** Specify `ENABLE` to enable distributed recovery. In a single-process environment, you must use this clause to initiate distributed recovery.
You may need to issue the `ENABLE` `DISTRIBUTED` `RECOVERY` statement more than once to recover an in-doubt transaction if the remote node involved in the transaction is not accessible. In-doubt transactions appear in the data dictionary view `DBA_2PC_PENDING`.
**See Also:**   “Enabling Distributed Recovery: Example” **DISABLE** Specify `DISABLE` to disable distributed recovery.
## FLUSH SHARED_POOL Clause
The `FLUSH` `SHARED_POOL` clause lets you clear data from the shared pool in the system global area (SGA). The shared pool stores:
- Cached data dictionary information and
- Shared SQL and PL/SQL areas for SQL statements, stored procedures, functions, packages, and triggers.
This statement does not clear global application context information, nor does it clear shared SQL and PL/SQL areas for items that are currently being executed. You can use this clause regardless of whether your instance has the database dismounted or mounted, open or closed.
**See Also:**   “Clearing the Shared Pool: Example”
## FLUSH GLOBAL CONTEXT Clause
The `FLUSH` `GLOBAL` `CONTEXT` clause lets you flush all global application context information from the shared pool in the system global area (SGA). You can use this clause regardless of whether your instance has the database dismounted or mounted, open or closed.
## FLUSH BUFFER_CACHE Clause
The `FLUSH` `BUFFER_CACHE` clause lets you clear all data from the buffer cache in the system global area (SGA), including the `KEEP`, `RECYCLE`, and `DEFAULT` buffer pools.
**Note:**   This clause is intended for use only on a test database. Do not use this clause on a production database, because as a result of this statement, subsequent queries will have no hits, only misses.
This clause is useful if you need to measure the performance of rewritten queries or a suite of queries from identical starting points.
## FLUSH FLASH_CACHE Clause
Use the `FLUSH` `FLASH_CACHE` clause to flush the Database Smart Flash Cache. This clause can be useful if you need to measure the performance of rewritten queries or a suite of queries from identical starting points, or if there might be corruption in the cache.
## FLUSH REDO Clause
Use the `FLUSH` `REDO` clause to flush redo data from a primary database to a standby database and to optionally wait for the flushed redo data to be applied to a physical or logical standby database.
This clause can allow a failover to be performed on the target standby database without data loss, even if the primary database is not in a zero data loss data protection mode, provided that all redo data that has been generated by the primary database can be flushed to the standby database.
The `FLUSH` `REDO` clause must be issued on a mounted, but not open, primary database.
***target_db_name*** For *target_db_name*, specify the `DB_UNIQUE_NAME` of the standby database that is to receive the redo data flushed from the primary database.
The value of the `LOG_ARCHIVE_DEST_`*n* database initialization parameter that corresponds to the target standby database must contain the `DB_UNIQUE_NAME` attribute, and the value of that attribute must match the `DB_UNIQUE_NAME` of the target standby database.
**NO CONFIRM APPLY** If you specify this clause, then the `ALTER` `SYSTEM` statement will not complete until the standby database has received all of the flushed redo data. You must specify this clause if the target standby database is a snapshot standby database.
**CONFIRM APPLY** If you specify this clause, then the `ALTER` `SYSTEM` statement will not complete until the target standby database has received and applied all flushed redo data. This is the default behavior unless you specify `NO` `CONFIRM` `APPLY`. You cannot specify this clause if the target standby database is a snapshot standby database.
**See Also:**   *Oracle Data Guard Concepts and Administration* for more information about the `FLUSH` `REDO` clause and failovers
## *end_session_clauses*
The *end_session_clauses* give you several ways to end the current session.
**DISCONNECT SESSION Clause** Use the `DISCONNECT` `SESSION` clause to disconnect the current session by destroying the dedicated server process (or virtual circuit if the connection was made by way of a Shared Server). To use this clause, your instance must have the database open. You must identify the session with both of the following values from the `V$SESSION` view:
**
- For integer1, specify the value of the SID column.
**
- For integer2, specify the value of the SERIAL# column.
If system parameters are appropriately configured, then application failover will take effect.
``````
- The POST_TRANSACTION setting allows ongoing transactions to complete before the session is disconnected. If the session has no ongoing transactions, then this clause has the same effect described for as KILL SESSION.
````
  - If you also specify POST_TRANSACTION and the session has ongoing transactions, then the IMMEDIATE keyword is ignored.
``````````
****
  - If you do not specify POST_TRANSACTION, or you specify POST_TRANSACTION but the session has no ongoing transactions, then this clause has the same effect as described for KILL SESSION IMMEDIATE. See Also: “Disconnecting a Session: Example”
**KILL SESSION Clause**
The `KILL` `SESSION` clause lets you mark a session as terminated, roll back ongoing transactions, release all session locks, and partially recover session resources. To use this clause, your instance must have the database open. Your session and the session to be terminated must be on the same instance unless you specify *integer3*.You must identify the session with the following values from the `V$SESSION` view:
**
- For integer1, specify the value of the SID column.
**
- For integer2, specify the value of the SERIAL# column.
**
- For the optional integer3, specify the ID of the instance where the target session to be killed exists. You can find the instance ID by querying the GV$ tables.
If the session is performing some activity that must be completed, such as waiting for a reply from a remote database or rolling back a transaction, then Oracle Database waits for this activity to complete, marks the session as terminated, and then returns control to you. If the waiting lasts a minute, then Oracle Database marks the session to be terminated and returns control to you with a message that the session is marked to be terminated. The `PMON` background process then marks the session as terminated when the activity is complete.
Whether or not the session has an ongoing transaction, Oracle Database does not recover the entire session state until the session user issues a request to the session and receives a message that the session has been terminated.
**See Also:**   “Terminating a Session: Example”
**IMMEDIATE**
Specify `IMMEDIATE` to instruct Oracle Database to roll back ongoing transactions, release all session locks, recover the entire session state, and return control to you immediately.
**NOREPLAY**
This clause is valid if you are using Application Continuity. When connected to a service with Application Continuity enabled (that is, `FAILOVER_TYPE` `=` `TRANSACTION`), the session is recovered after the session fails or is killed. If you do not want to recover a session after it is terminated, then specify `NOREPLAY`.
## SWITCH LOGFILE Clause
The `SWITCH` `LOGFILE` clause lets you explicitly force Oracle Database to begin writing to a new redo log file group, regardless of whether the files in the current redo log file group are full. When you force a log switch, Oracle Database begins to perform a checkpoint but returns control to you immediately rather than when the checkpoint is complete. To use this clause, your instance must have the database open.
**See Also:**   “Forcing a Log Switch: Example”
## SUSPEND | RESUME
The `SUSPEND` clause lets you suspend all I/O (data file, control file, and file header) as well as queries, in all instances, enabling you to make copies of the database without having to handle ongoing transactions.
**Restrictions on SUSPEND and RESUME**
`SUSPEND` and `RESUME` are subject to the following restrictions:
- Do not use this clause unless you have put the database tablespaces in hot backup mode.
````````
- Do not terminate the session that issued the ALTER SYSTEM SUSPEND statement. An attempt to reconnect while the system is suspended may fail because of recursive SQL that is running during the SYS login.
- If you start a new instance while the system is suspended, then that new instance will not be suspended.
The `RESUME` clause lets you make the database available once again for queries and I/O.
## *quiesce_clauses*
Use the `QUIESCE` `RESTRICTED` and `UNQUIESCE` clauses to put the database in and take it out of the **quiesced state**. This state enables database administrators to perform administrative operations that cannot be safely performed in the presence of concurrent transactions, queries, or PL/SQL operations.
**Note:**   The `QUIESCE` `RESTRICTED` clause is valid only if the Database Resource Manager is installed and only if the Resource Manager has been on continuously since database startup in any instances that have opened the database.
If multiple `QUIESCE` `RESTRICTED` or `UNQUIESCE` statements issue at the same time from different sessions or instances, then all but one will receive an error.
**QUIESCE RESTRICTED** Specify `QUIESCE` `RESTRICTED` to put the database in the quiesced state. For all instances with the database open, this clause has the following effect:
````````
- Oracle Database instructs the Database Resource Manager in all instances to prevent all inactive sessions (other than SYS and SYSTEM) from becoming active. No user other than SYS and SYSTEM can start a new transaction, a new query, a new fetch, or a new PL/SQL operation.
````````````````
- Oracle Database waits for all existing transactions in all instances that were initiated by a user other than SYS or SYSTEM to finish (either commit or abort). Oracle Database also waits for all running queries, fetches, and PL/SQL procedures in all instances that were initiated by users other than SYS or SYSTEM and that are not inside transactions to finish. If a query is carried out by multiple successive OCI fetches, then Oracle Database does not wait for all fetches to finish. It waits for the current fetch to finish and then blocks the next fetch. Oracle Database also waits for all sessions (other than those of SYS or SYSTEM) that hold any shared resources (such as enqueues) to release those resources. After all these operations finish, Oracle Database places the database into quiesced state and finishes executing the QUIESCE RESTRICTED statement.
````
- If an instance is running in shared server mode, then Oracle Database instructs the Database Resource Manager to block logins (other than SYS or SYSTEM) on that instance. If an instance is running in non-shared-server mode, then Oracle Database does not impose any restrictions on user logins in that instance.
During the quiesced state, you cannot change the Resource Manager plan in any instance.
**UNQUIESCE**
Specify `UNQUIESCE` to take the database out of quiesced state. Doing so permits transactions, queries, fetches, and PL/SQL procedures that were initiated by users other than `SYS` or `SYSTEM` to be undertaken once again. The `UNQUIESCE` statement does not have to originate in the same session that issued the `QUIESCE` `RESTRICTED` statement.
## *rolling_migration_clauses*
Use these clauses in a clustered Oracle Automatic Storage Management (Oracle ASM) environment to migrate one node at a time to a different Oracle ASM version without affecting the overall availability of the Oracle ASM cluster or the database clusters using Oracle ASM for storage.
**START ROLLING MIGRATION**
When starting rolling upgrade, for *ASM_version*, you must specify the following string:
```
', , ,,'
```
*ASM_version* must be equal to or greater than
11.1.0.0.0. The surrounding single quotation marks are required. Oracle ASM first verifies that the current release is compatible for migration to the specified release, and then goes into limited functionality mode. Oracle ASM then determines whether any rebalance operations are under way anywhere in the cluster. If there are any such operations, then the statement fails and must be reissued after the rebalance operations are complete.
Rolling upgrade mode is a cluster-wide In-Memory persistent state. The cluster continues to be in this state until there is at least one Oracle ASM instance running in the cluster. Any new instance joining the cluster switches to migration mode immediately upon startup. If all the instances in the cluster terminate, then subsequent startup of any Oracle ASM instance will not be in rolling upgrade mode until you reissue this statement to restart rolling upgrade of the Oracle ASM instances.
**STOP ROLLING MIGRATION**
Use this clause to stop rolling upgrade and bring the cluster back into normal operation. Specify this clause only after all instances in the cluster have migrated to the same software version. The statement will fail if the cluster is not in rolling upgrade mode.
When you specify this clause, the Oracle ASM instance validates that all the members of the cluster are at the same software version, takes the instance out of rolling upgrade mode, and returns to full functionality of the Oracle ASM cluster. If any rebalance operations are pending because disks have gone offline, then those operations are restarted if the `ASM_POWER_LIMIT` parameter would not be violated by such a restart.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for more information about rolling upgrade
## *rolling_patch_clauses*
Use these clauses in a clustered Oracle Automatic Storage Management (Oracle ASM) environment to update one node at a time to the latest patch level without affecting the overall availability of the Oracle ASM cluster or the database clusters using Oracle ASM for storage.
**START ROLLING PATCH**
Use this clause to start the rolling patch operation. Oracle ASM first verifies that all live nodes in the cluster are at the same version, and then goes into rolling patch mode, which is a cluster-wide In-Memory persistent state. The cluster continues to be in this state until all live nodes have been patched to the latest patch level.
Any nodes that are down during this operation are not patched. This does not affect the success of the rolling patch operation. However, you must patch these nodes before they are started. Otherwise, they will not be allowed to join the cluster.
**STOP ROLLING PATCH**
use this clause to stop the rolling patch operation and bring the cluster back into normal operation. Specify this clause only after all live nodes in the cluster have been patched to the latest patch level. The statement will fail if the cluster is not in rolling patch mode.
When you specify this clause, the Oracle ASM instance validates that all members of the cluster are at the same patch level, takes the instance out of rolling patch mode, and returns full functionality of the Oracle ASM cluster. If any members of the cluster are not at the latest patch level, then this operation fails and the cluster goes into limited functionality mode.
The following queries display information about rolling patches. In order to run these queries, you must be connected to the Oracle ASM instance in the Grid home, and the Grid Infrastructure home must be configured with the Oracle Clusterware option for an Oracle RAC environment.
  - You can determine whether a cluster is in rolling patch mode with the following query:
```
SELECT SYS_CONTEXT('SYS_CLUSTER_PROPERTIES', 'CLUSTER_STATE') FROM DUAL;
```
  - You can determine the patch level of a cluster with the following query:
```
SELECT SYS_CONTEXT('SYS_CLUSTER_PROPERTIES', 'CURRENT_PATCHLVL') FROM DUAL;
```
  ********- You can display a list of patches applied on the Oracle ASM instance, by querying the V$PATCHES dynamic performance view. Refer to Oracle Database Reference for more information. See Also: Oracle Automatic Storage Management Administrator’s Guide for more information about rolling patches
## *security_clauses*
The *security_clauses* let you control access to the instance. They also allow you to enable or disable access to the encrypted data in the instance.
**RESTRICTED SESSION**
The `RESTRICTED` `SESSION` clause lets you restrict logon to Oracle Database. You can use this clause regardless of whether your instance has the database dismounted or mounted, open or closed.
``````
````
- Specify ENABLE to allow only users with RESTRICTED SESSION system privilege to log on to Oracle Database. Existing sessions are not terminated. This clause applies only to the current instance. Therefore, in an Oracle RAC environment, authorized users without the RESTRICTED SESSION system privilege can still access the database by way of other instances.
````````````****
- Specify DISABLE to reverse the effect of the ENABLE RESTRICTED SESSION clause, allowing all users with CREATE SESSION system privilege to log on to Oracle Database. This is the default. See Also: “Restricting Sessions: Example”
## *affinity_clauses*
Use the affinity clauses to enable data-dependent routing to provide cache affinity on a `RAC` database. The affinity logically partitions data across `RAC` instances so that a distinct subset of data is assigned to each instance. When data is accessed with a sharding key, the request will be routed to the instance that holds the corresponding subset of data. The benefits of affinity are:
- Sharded access for shard-aware applications and transparency for non-sharded applications
- Better cache utilization and reduced block pings
## *shutdown_dispatcher_clause*
The `SHUTDOWN` clause is relevant only if your system is using the shared server architecture of Oracle Database. It shuts down a dispatcher identified by *dispatcher_name*.
**Note:**   Do not confuse this clause with the SQL*Plus command `SHUTDOWN`, which is used to shut down the entire database.
The *dispatcher_name* must be a string of the form ‘`D`*xxx*’, where *xxx* indicates the number of the dispatcher. For a listing of dispatcher names, query the `NAME` column of the `V$DISPATCHER` dynamic performance view.
- If you specify IMMEDIATE, then the dispatcher stops accepting new connections immediately and Oracle Database terminates all existing connections through that dispatcher. After all sessions are cleaned up, the dispatcher process shuts down.
- If you do not specify IMMEDIATE, then the dispatcher stops accepting new connections immediately but waits for all its users to disconnect and for all its database links to terminate. Then it shuts down.
## REGISTER Clause
Specify `REGISTER` to instruct the `PMON` background process to register the instance with the listeners immediately. If you do not specify this clause, then registration of the instance does not occur until the next time `PMON` executes the discovery routine. As a result, clients may not be able to access the services for as long as 60 seconds after the listener is started.
**See Also:**   *Oracle Database Concepts* and *Oracle Database Net Services Administrator’s Guide* for information on the `PMON` background process and listeners
## *alter_system_set_clause*
This clause allows you to change parameter values. The *set_parameter_clause* allows you to change the value of a specified initialization parameter. The `USE_STORED_OUTLINES` and `GLOBAL_TOPIC_ENABLED` clauses allow you to change the value of those system parameters.
***set_parameter_clause*** You can change the value of many initialization parameters for the current instance, whether you have started the database with a traditional plain-text parameter file (pfile) or with a server parameter file (spfile). *Oracle Database Reference* indicates these parameters in the “Modifiable” category of each parameter description. If you are using a pfile, then the change will persist only for the duration of the instance. However, if you have started the database with an spfile, then you can change the value of the parameter in the spfile itself, so that the new value will occur in subsequent instances.
Oracle Database Reference documents all initialization parameters in full. The parameters fall into three categories:
****
- Basic parameters: Database administrators should be familiar with and consider the setting for all of the basic parameters.
****
- Functional categories: Oracle Database Reference also lists the initialization parameters by their functional category.
******
- Alphabetical listing: The Table of Contents of Oracle Database Reference contains all initialization parameters in alphabetical order.
The ability to change initialization parameter values depends on whether you have started up the database with a traditional plain-text initialization parameter file (pfile) or with a server parameter file (spfile). To determine whether you can change the value of a particular parameter, query the `ISSYS_MODIFIABLE` column of the `V$PARAMETER` dynamic performance view.
When setting a parameter value, you can specify additional settings as follows:
**COMMENT** The `COMMENT` clause lets you associate a comment string with this change in the value of the parameter. The comment string cannot contain control characters or a line break. If you also specify `SPFILE`, then this comment will appear in the parameter file to indicate the most recent change made to this parameter.
**DEFERRED** The `DEFERRED` keyword sets or modifies the value of the parameter for future sessions that connect to the database. Current sessions retain the old value.
You must specify `DEFERRED` if the value of the `ISSYS_MODIFIABLE` column of `V$PARAMETER` for this parameter is `DEFERRED`. If the value of that column is `IMMEDIATE`, then the `DEFERRED` keyword in this clause is optional. If the value of that column is `FALSE`, then you cannot specify `DEFERRED` in this `ALTER` `SYSTEM` statement.
**See Also:**   *Oracle Database Reference* for information on the `V$PARAMETER` dynamic performance view **CONTAINER** You can specify the `CONTAINER` clause when you set a parameter value in a CDB. A CDB uses an inheritance model for initialization parameters in which PDBs inherit initialization parameter values from the root. In this case, inheritance means that the value of a particular parameter in the root applies to a particular PDB.
A PDB can override the root’s setting for some parameters, which means that a PDB has an inheritance property for each initialization parameter that is either true or false. The inheritance property is true for a parameter when the PDB inherits the root’s value for the parameter. The inheritance property is false for a parameter when the PDB does not inherit the root’s value for the parameter.
The inheritance property for some parameters must be true. For other parameters, you can change the inheritance property by running the `ALTER` `SYSTEM` `SET` statement to set the parameter when the current container is the PDB. If `ISPDB_MODIFIABLE` is `TRUE` for an initialization parameter in the `V$SYSTEM_PARAMETER` view, then the inheritance property can be false for the parameter.
``````
- If you specify CONTAINER = ALL, then the parameter setting applies to all containers in the CDB, including the root and all of the PDBs. The current container must be the root. Specifying ALL sets the inheritance property to true for the parameter in all PDBs.
``````
- If you specify CONTAINER = CURRENT, then the parameter setting applies only to the current container. When the current container is the root, the parameter setting applies to the root and to any PDB with an inheritance property of true for the parameter.
If you omit this clause, then `CONTAINER` `=` `CURRENT` is the default.
**See Also:**   *Oracle Database Administrator’s Guide* for more information on modifying parameters in a CDB **SCOPE** The `SCOPE` clause lets you specify when the change takes effect. The behavior of this clause depends on whether you are connected to a non-CDB, a CDB root, or a PDB.
**When you issue the ALTER SYSTEM statement while connected to a non-CDB or a CDB root**, the scope depends on whether you started up the database using a traditional plain-text parameter file (pfile) or server parameter file (spfile).
- MEMORY indicates that the change is made in memory, takes effect immediately, and persists until the database is shut down. If you started up the database using a parameter file (pfile), then this is the only scope you can specify. Note that MEMORY makes changes in memory of all the instances and overwrites values set individually on the instance.
````**
- SPFILE indicates that the change is made in the server parameter file. The new setting takes effect when the database is next shut down and started up again. You must specify SPFILE when changing the value of a static parameter that is described as not modifiable in Oracle Database Reference. Note that SPFILE makes no changes in memory, which means that the instance parameter set individually on the instance takes precedence over global.
- BOTH indicates that the change is made in memory and in the server parameter file. The new setting takes effect immediately and persists after the database is shut down and started up again. Note that BOTH makes changes in memory of all the instances and overwrites values set individually on the instance, until the instance is restarted. When the instance is restarted, the spfile is read and then the instance parameter takes precedence.
If a server parameter file was used to start up the database, then `BOTH` is the default. If a parameter file was used to start up the database, then `MEMORY` is the default, as well as the only scope you can specify.
**When you issue the ALTER SYSTEM statement while connected to a PDB**, you can modify only initialization parameters for which the `ISPDB_MODIFIABLE` column is `TRUE` in the `V$SYSTEM_PARAMETER` view. The initialization parameter value takes effect only for the PDB. For any initialization parameter that is not set explicitly for a PDB, the PDB inherits the CDB root’s parameter value.
````````````````
  - An ALTER SYSTEM SET statement sets the value of the parameter in the root with SCOPE equal to BOTH or MEMORY, and the PDB is closed and reopened. The parameter value in the PDB is not changed if SCOPE is equal to SPFILE, and the PDB is closed and reopened.
  - The PDB is closed and reopened.
  - The CDB is shut down and reopened.
  - The PDB is closed and reopened.
  - The CDB is shut down and reopened.
- BOTH indicates that the change is made in memory, made for the PDB, and stored persistently. The new setting takes effect immediately in the PDB and persists after the PDB is closed and reopened or the CDB is shut down and reopened. The new setting affects only the PDB.
When a PDB is unplugged from a CDB, the values of the initialization parameters that were specified for the PDB with `SCOPE=BOTH` or `SCOPE=SPFILE` are added to the PDB’s XML metadata file. These values are restored for the PDB when it is plugged in to a CDB.
**Note:**   Oracle may internally adjust the parameter value passed in `ALTER SYSTEM SET` before it is set in memory or the spfile. For example, if you input a non-prime number when the paramenter value should be a prime number, Oracle will adjust the value to the next prime number. You can query the parameter value from parameter views `V$PARAMETER`, `V$SYSTEM_PARAMETER`, and `V$SPPARAMETER`.
**SID** The `SID` clause lets you specify the SID of the instance where the value will take effect.
````
- Specify SID = '*' if you want Oracle Database to change the value of the parameter for all instances that do not already have an explicit setting for this parameter.
****``````````
- Specify SID = ‘sid’ if you want Oracle Database to change the value of the parameter only for the instance sid. This setting takes precedence over previous and subsequent ALTER SYSTEM SET statements that specify SID = '*'.
If you do not specify this clause, then:
- If the instance was started up with a pfile (traditional plain-text initialization parameter file), then Oracle Database assumes the SID of the current instance.
``````
- If the instance was started up with an spfile (server parameter file), then Oracle Database assumes SID = '*'.
If you specify an instance other than the current instance, then Oracle Database sends a message to that instance to change the parameter value in the memory of that instance.
**USE_STORED_OUTLINES Clause** **Note:**   Stored outlines are deprecated. They are still supported for backward compatibility. However, Oracle recommends that you use SQL plan management instead. Refer to *Oracle Database SQL Tuning Guide* for more information about SQL plan management.
`USE_STORED_OUTLINES` is a system parameter, not an initialization parameter. You cannot set it in a pfile or spfile, but you can set it with an `ALTER` `SYSTEM` statement. This parameter determines whether the optimizer will use stored public outlines to generate execution plans.
````
- TRUE causes the optimizer to use outlines stored in the DEFAULT category when compiling requests.
- FALSE specifies that the optimizer should not use stored outlines. This is the default.
****
- category_name causes the optimizer to use outlines stored in the category_name category when compiling requests.
**GLOBAL_TOPIC_ENABLED**
`GLOBAL_TOPIC_ENABLED` is a system parameter, not an initialization parameter. You cannot set it in a pfile or spfile, but you can set it with an `ALTER` `SYSTEM` statement. If `GLOBAL_TOPIC_ENABLED` = `TRUE` when a queue table is created, altered, or dropped, then the corresponding Lightweight Directory Access Protocol (LDAP) entry is also created, altered or dropped.
The parameter works the same way for the Java Message Service (JMS). If a database has been configured to use LDAP and the `GLOBAL_TOPIC_ENABLED` parameter has been set to `TRUE`, then all JMS queues and topics are automatically registered with the LDAP server when they are created. The administrator can also create aliases to the queues and topics registered in LDAP. Queues and topics that are registered in LDAP can be looked up through JNDI using the name or alias of the queue or topic.
**Shared Server Parameters**
When you start your instance, Oracle Database creates shared server processes and dispatcher processes for the shared server architecture based on the values of the `SHARED_SERVERS` and `DISPATCHERS` initialization parameters. You can also set the `SHARED_SERVERS` and `DISPATCHERS` parameters with `ALTER` `SYSTEM` to perform one of the following operations while the instance is running:
- Create additional shared server processes by increasing the minimum number of shared server processes.
- Terminate existing shared server processes after their current calls finish processing.
- Create more dispatcher processes for a specific protocol, up to a maximum across all protocols specified by the initialization parameter MAX_DISPATCHERS.
```
**See Also:**
- [*Oracle Real Application Clusters Administration and Deployment Guide*](/pls/topic/lookup?ctx=en/database/oracle/oracle-database/19/sqlrf&id=RACAD020) for information on setting parameter values for an individual instance in an Oracle Real Application Clusters environment
- The following examples of using the `ALTER` `SYSTEM` statement: "[Changing Licensing Parameters: Examples](ALTER-SYSTEM.html#GUID-2C638517-D73A-41CA-9D8E-A62D1A0B7ADB\_\_I2198540)", "[Enabling Query Rewrite: Example](ALTER-SYSTEM.html#GUID-2C638517-D73A-41CA-9D8E-A62D1A0B7ADB\_\_I2198388)", "[Enabling Resource Limits: Example](ALTER-SYSTEM.html#GUID-2C638517-D73A-41CA-9D8E-A62D1A0B7ADB\_\_I2198497)", "[Shared Server Parameters](ALTER-SYSTEM.html#GUID-2C638517-D73A-41CA-9D8E-A62D1A0B7ADB\_\_BABJBBBB)", and "[Changing Shared Server Settings: Examples](ALTER-SYSTEM.html#GUID-2C638517-D73A-41CA-9D8E-A62D1A0B7ADB\_\_I2198517)"
```
- Terminate existing dispatcher processes for a specific protocol after their current user processes disconnect from the instance.
## *alter_system_reset_clause*
This clause lets you reset an initialization parameter.
The semantics of this clause are similar to the *set_parameter_clause*, except instead of changing the value of an initialization parameter, this clause removes the setting of an initialization parameter. Refer to the *set_parameter_clause* to learn about the parameters you can reset, and for the full semantics of the `SCOPE` and `SID` clauses.
## RELOCATE CLIENT
This clause is valid only if you are using Oracle Flex ASM. You must issue this clause from within an Oracle ASM instance, not from a normal database instance.
Use this clause to relocate the specified client to the least loaded Oracle ASM instance. When you issue this clause, the connection to the client is terminated and the client fails over to the least loaded instance. If the client is currently connected to the least loaded instance, then the connection to the client is terminated and the client fails over to that same instance.
For *client_id*, specify a string of the following form enclosed in single quotation marks:
```
instance_name:db_name
```
where *instance_name* is the identifier for the client and *db_name* is the database name for the client. You can find these values by querying the `INSTANCE_NAME` and `DB_NAME` columns of the `V$ASM_CLIENT` dynamic performance view.
**See Also:**
**
- Oracle Automatic Storage Management Administrator’s Guide for more information on managing Oracle Flex ASM
**
- Oracle Database Reference for more information on the V$ASM_CLIENT dynamic performance view
## *cancel_sql_clause*
Use this clause to terminate a SQL operation that is consuming excessive resources, including parallel servers. You must provide the session id and the session serial number of the session whose active SQL statement you want to cancel. If the session is idle (no actively running SQL statement), the next SQL statement will be canceled. To avoid the next SQL statement from getting canceled, specify the `sql_id` in the arguments to identify the SQL statement to be canceled.
- session_id is required and stands for the session identifier.
- serial_number is required and stands for the serial number of the session.
- instance_id is optional. If this argument is omitted, the instance id of the current session is used.
``````
- sql_id is optional. If this argument is specified, the sql_id will be matched with the actively-running SQL statement in the session before terminating the SQL. If the session is executing a SQL statement other than the one specified in the sql_id argument, an error is raised.
## FLUSH PASSWORDFILE_METADATA_CACHE
If the location or the name of the password file changes, you must notify the database that a change has occurred. The command `ALTER SYSTEM FLUSH PASSWORDFILE_METADATA_CACHE` flushes the password file metadata cache stored in the SGA and informs the database that a change has occurred.
The command also flushes the cache from all the RAC instances if it is run in a cluster environment. Note the delay in propagating the change across all instances. Until the flush is fully propagated, some instances might continue to use the old password file.
## Examples
**Archiving Redo Logs Manually: Examples** The following statement manually archives the redo log file group containing the redo log entry with the SCN 9356083:
```
ALTER SYSTEM ARCHIVE LOG CHANGE 9356083;
```
The following statement manually archives the redo log file group containing a member named ‘`diskl:log6.log`’ to an archived redo log file in the location ‘`diska:[arch$`]’:
```
ALTER SYSTEM ARCHIVE LOG
    LOGFILE 'diskl:log6.log'
    TO 'diska:[arch$]';
```
**Enabling Query Rewrite: Example** This statement enables query rewrite in all sessions for all materialized views for which query rewrite has not been explicitly disabled:
```
ALTER SYSTEM SET QUERY_REWRITE_ENABLED = TRUE;
```
**Restricting Sessions: Example** You might want to restrict sessions if you are performing application maintenance and you want only application developers with `RESTRICTED` `SESSION` system privilege to log on. To restrict sessions, issue the following statement:
```
ALTER SYSTEM
   ENABLE RESTRICTED SESSION;
```
You can then terminate any existing sessions using the `KILL` `SESSION` clause of the `ALTER` `SYSTEM` statement.
After performing maintenance on your application, issue the following statement to allow any user with `CREATE` `SESSION` system privilege to log on:
```
ALTER SYSTEM
   DISABLE RESTRICTED SESSION;
```
**Establishing a Wallet and Encryption Key: Examples** The following statements load information from the server wallet into memory and set the Transparent Data Encryption master key:
```
ALTER SYSTEM SET ENCRYPTION WALLET OPEN IDENTIFIED BY "password";
ALTER SYSTEM SET ENCRYPTION KEY IDENTIFIED BY "password";
```
These statements assume that you have initialized the security module and created a wallet with *password*.
**Closing a Wallet: Examples** The following statement removes password-based wallet information from memory:
```
ALTER SYSTEM SET ENCRYPTION WALLET CLOSE IDENTIFIED BY "password";
```
The following statement removes password-based wallet information and auto-login information, if present, from memory:
```
ALTER SYSTEM SET ENCRYPTION WALLET CLOSE;
```
**Clearing the Shared Pool: Example** You might want to clear the shared pool before beginning performance analysis. To clear the shared pool, issue the following statement:
```
ALTER SYSTEM FLUSH SHARED_POOL;
```
**Forcing a Checkpoint: Example** The following statement forces a checkpoint:
```
ALTER SYSTEM CHECKPOINT;
```
**Enabling Resource Limits: Example** This `ALTER` `SYSTEM` statement dynamically enables resource limits:
```
ALTER SYSTEM SET RESOURCE_LIMIT = TRUE;
```
**Changing Shared Server Settings: Examples** The following statement changes the minimum number of shared server processes to 25:
```
ALTER SYSTEM SET SHARED_SERVERS = 25;
```
If there are currently fewer than 25 shared server processes, then Oracle Database creates more. If there are currently more than 25, then Oracle Database terminates some of them when they are finished processing their current calls if the load could be managed by the remaining 25.
The following statement dynamically changes the number of dispatcher processes for the TCP/IP protocol to 5 and the number of dispatcher processes for the ipc protocol to 10:
```
ALTER SYSTEM
   SET DISPATCHERS =
      '(INDEX=0)(PROTOCOL=TCP)(DISPATCHERS=5)',
      '(INDEX=1)(PROTOCOL=ipc)(DISPATCHERS=10)';
```
If there are currently fewer than 5 dispatcher processes for TCP, then Oracle Database creates new ones. If there are currently more than 5, then Oracle Database terminates some of them after the connected users disconnect.
If there are currently fewer than 10 dispatcher processes for ipc, then Oracle Database creates new ones. If there are currently more than 10, then Oracle Database terminates some of them after the connected users disconnect.
If there are currently existing dispatchers for another protocol, then the preceding statement does not affect the number of dispatchers for that protocol.
**Changing Licensing Parameters: Examples** The following statement dynamically changes the limit on sessions for your instance to 64 and the warning threshold for sessions on your instance to 54:
```
ALTER SYSTEM
   SET LICENSE_MAX_SESSIONS = 64
   LICENSE_SESSIONS_WARNING = 54;
```
If the number of sessions reaches 54, then Oracle Database writes a warning message to the `ALERT` file for each subsequent session. Also, users with `RESTRICTED` `SESSION` system privilege receive warning messages when they begin subsequent sessions.
If the number of sessions reaches 64, then only users with `RESTRICTED` `SESSION` system privilege can begin new sessions until the number of sessions falls below 64 again.
The following statement dynamically disables the limit for sessions on your instance. After you issue this statement, Oracle Database no longer limits the number of sessions on your instance.
```
ALTER SYSTEM SET LICENSE_MAX_SESSIONS = 0;
```
The following statement dynamically changes the limit on the number of users in the database to 200. After you issue the preceding statement, Oracle Database prevents the number of users in the database from exceeding 200.
```
ALTER SYSTEM SET LICENSE_MAX_USERS = 200;
```
**Forcing a Log Switch: Example** You might want to force a log switch to drop or rename the current redo log file group or one of its members, because you cannot drop or rename a file while Oracle Database is writing to it. The forced log switch affects only the redo log thread of your instance. The following statement forces a log switch:
```
ALTER SYSTEM SWITCH LOGFILE;
```
**Enabling Distributed Recovery: Example** The following statement enables distributed recovery:
```
ALTER SYSTEM ENABLE DISTRIBUTED RECOVERY;
```
You might want to disable distributed recovery for demonstration or testing purposes. You can disable distributed recovery in both single-process and multiprocess mode with the following statement:
```
ALTER SYSTEM DISABLE DISTRIBUTED RECOVERY;
```
When your demonstration or testing is complete, you can then enable distributed recovery again by issuing an `ALTER` `SYSTEM` statement with the `ENABLE` `DISTRIBUTED` `RECOVERY` clause.
**Terminating a Session: Example** You might want to terminate the session of a user that is holding resources needed by other users. The user receives an error message indicating that the session has been terminated. That user can no longer make calls to the database without beginning a new session. Consider this data from the `V$SESSION` dynamic performance table, when the users `SYS` and `oe` both have open sessions:
```
SELECT sid, serial#, username
   FROM V$SESSION;
       SID    SERIAL# USERNAME
---------- ---------- ------------------------------
        29         85 SYS
        33          1
        35          8
        39         23 OE
        40          1
. . .
```
The following statement terminates the session of the user `scott` using the `SID` and `SERIAL#` values from `V$SESSION`:
```
ALTER SYSTEM KILL SESSION '39, 23';
```
**Disconnecting a Session: Example** The following statement disconnects user `scott`’s session, using the `SID` and `SERIAL#` values from `V$SESSION`:
```
ALTER SYSTEM DISCONNECT SESSION '13, 8' POST_TRANSACTION;
```
