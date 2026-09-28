# ALTER SESSION

## Purpose
Use the `ALTER` `SESSION` statement to set or modify any of the conditions or parameters that affect your connection to the database. The statement stays in effect until you disconnect from the database.
## Prerequisites
To enable and disable the SQL trace facility, you must have `ALTER` `SESSION` system privilege.
To enable or disable resumable space allocation, you must have the `RESUMABLE` system privilege.
You do not need any privileges to perform the other operations of this statement unless otherwise indicated.
## Syntax
## *alter_session*::=
Description of the illustration alter_session.eps
## *alter_session_set_clause*::=
Description of the illustration alter_session_set_clause.eps
## Semantics
## ADVISE Clause
The `ADVISE` clause sends advice to a remote database to force a distributed transaction. The advice appears in the `ADVICE` column of the `DBA_2PC_PENDING` view on the remote database (the values are ‘`C`’ for `COMMIT`, ‘`R`’ for `ROLLBACK`, and ‘ ‘ for `NOTHING`). If the transaction becomes in doubt, then the administrator of that database can use this advice to decide whether to commit or roll back the transaction.
You can send different advice to different remote databases by issuing multiple `ALTER` `SESSION` statements with the `ADVISE` clause in a single transaction. Each such statement sends advice to the databases referenced in the following statements in the transaction until another such statement is issued.
**See Also:**   “Forcing a Distributed Transaction: Example”
## CLOSE DATABASE LINK Clause
Specify `CLOSE` `DATABASE` `LINK` to close the database link *dblink*. When you issue a statement that uses a database link, Oracle Database creates a session for you on the remote database using that link. The connection remains open until you end your local session or until the number of database links for your session exceeds the value of the initialization parameter `OPEN_LINKS`. If you want to reduce the network overhead associated with keeping the link open, then use this clause to close the link explicitly if you do not plan to use it again in your session.
**See Also:**   Closing a Database Link: Example
## ENABLE | DISABLE COMMIT IN PROCEDURE
Procedures and stored functions written in PL/SQL can issue `COMMIT` and `ROLLBACK` statements. If your application would be disrupted by a `COMMIT` or `ROLLBACK` statement not issued directly by the application itself, then specify `DISABLE` `COMMIT` `IN` `PROCEDURE` clause to prevent procedures and stored functions called during your session from issuing these statements.
You can subsequently allow procedures and stored functions to issue `COMMIT` and `ROLLBACK` statements in your session by issuing the `ENABLE` `COMMIT` `IN` `PROCEDURE`.
Some applications automatically prohibit `COMMIT` and `ROLLBACK` statements in procedures and stored functions. Refer to your application documentation for more information.
## ENABLE | DISABLE GUARD
The *security_clause* of `ALTER` `DATABASE` lets you prevent anyone other than the `SYS` user from making any changes to data or database objects on the primary or standby database. This clause lets you override that setting for the current session.
**See Also:**   *security_clause* for more information on the `GUARD` setting
## PARALLEL DML | DDL | QUERY
The `PARALLEL` parameter determines whether all subsequent DML, DDL, or query statements in the session will be considered for parallel execution. This clause enables you to override the degree of parallelism of tables during the current session without changing the tables themselves. Uncommitted transactions must either be committed or rolled back prior to executing this clause for DML.
**See Also:**   “Enabling Parallel DML: Example” **ENABLE Clause** Specify `ENABLE` to execute subsequent statements in the session in parallel. This is the default for DDL and query statements.
- DML: DML statements are executed in parallel mode if a parallel hint or a parallel clause is specified.
- DDL: DDL statements are executed in parallel mode if a parallel clause is specified.
- QUERY: Queries are executed in parallel mode if a parallel hint or a parallel clause is specified.
**Restriction on the ENABLE clause** You cannot specify the optional `PARALLEL` *integer* with `ENABLE`.
**DISABLE Clause** Specify `DISABLE` to execute subsequent statements in the session serially. This is the default for DML statements.
- DML: DML statements are executed serially.
- DDL: DDL statements are executed serially.
- QUERY: Queries are executed serially.
**Restriction on the DISABLE clause** You cannot specify the optional `PARALLEL` *integer* with `DISABLE`.
**FORCE Clause** `FORCE` forces parallel execution of subsequent statements in the session. If no parallel clause or hint is specified, then a default degree of parallelism is used. This clause overrides any *parallel_clause* specified in subsequent statements in the session but is overridden by a parallel hint.
- DML: Provided no parallel DML restrictions are violated, subsequent DML statements in the session are executed with the default degree of parallelism, unless a degree is specified in this clause.
````**````
- DDL: Subsequent DDL statements in the session are executed with the default degree of parallelism, unless a degree is specified in this clause. Resulting database objects will have associated with them the prevailing degree of parallelism. Specifying FORCE DDL automatically causes all tables created in this session to be created with a default level of parallelism. The effect is the same as if you had specified the parallel_clause (with the default degree) in the CREATE TABLE statement.
- QUERY: Subsequent queries are executed with the default degree of parallelism, unless a degree is specified in this clause.
**PARALLEL** *integer*
Specify an integer to explicitly specify a degree of parallelism:
````
- For FORCE DDL, the degree overrides any parallel clause in subsequent DDL statements.
``````
- For FORCE DML and QUERY, the degree overrides the degree currently stored for the table in the data dictionary.
- A degree specified in a statement through a hint will override the degree being forced.
The following types of DML operations are not parallelized regardless of this clause:
- Operations on cluster tables
- Operations with embedded functions that either write or read database or package states
- Operations on tables with triggers that could fire
- Operations on tables or schema objects containing object types, or LONG or LOB data types
## RESUMABLE Clauses
These clauses let you enable and disable resumable space allocation. This feature allows an operation to be suspended in the event of an out-of-space error condition and to resume automatically from the point of interruption when the error condition is fixed.
**Note:**   Resumable space allocation is fully supported for operations on locally managed tablespaces. Some restrictions apply if you are using dictionary-managed tablespaces. For information on these restrictions, refer to *Oracle Database Administrator’s Guide*.
**ENABLE RESUMABLE**
This clause enables resumable space allocation for the session.
**TIMEOUT**
`TIMEOUT` lets you specify (in seconds) the time during which an operation can remain suspended while waiting for the error condition to be fixed. If the error condition is not fixed within the `TIMEOUT` period, then Oracle Database aborts the suspended operation.
**NAME**
`NAME` lets you specify a user-defined text string to help users identify the statements issued during the session while the session is in resumable mode. Oracle Database inserts the text string into the `USER_RESUMABLE` and `DBA_RESUMABLE` data dictionary views. If you do not specify `NAME`, then Oracle Database inserts the default string ‘`User` *username*(*userid*), `Session` *sessionid*, `Instance` *instanceid*’.
**See Also:**   *Oracle Database Reference* for information on the data dictionary views
**DISABLE RESUMABLE**
This clause disables resumable space allocation for the session.
## SHARD DDL Clauses
These clauses are valid only if you are connected to a sharded database. They let you control whether DDLs issued in the session are issued against the shard catalog database and all shards, or against only the shard catalog database.
``````
- If you specify ENABLE SHARD DDL, then DDLs issued in the session are issued against the shard catalog database and all shards. This mode is the default for the SDB user—a user that exists in the shard catalog database and in all shards.
``````******
- If you specify DISABLE SHARD DDL, then DDLs issued in the session are issued against only the shard catalog database. This mode is the default for a local user—a user that exists only in the shard catalog database. See Also: Using Oracle Sharding
## SYNC WITH PRIMARY
Use this clause to synchronize redo apply on a physical standby database with the primary database. An `ALTER` `SESSION` statement with this clause blocks until redo apply has applied all redo data received by the standby at the time the statement is issued. This clause returns an error, and synchronization does not occur, if the redo transport state for the standby database is not `SYNCHRONIZED` or if redo apply is not active.
**See Also:**   *Oracle Data Guard Concepts and Administration* for more information on this session parameter
## *alter_session_set_clause*
Use the *alter_session_set_clause* to set initialization parameter values or to set an edition for the current session.
**Initialization Parameters**
You can set two types of parameters using this clause:
````
- Initialization parameters that are dynamic in the scope of the ALTER SESSION statement (listed in “Initialization Parameters and ALTER SESSION”)
- Session parameters (listed in “Session Parameters and ALTER SESSION”)
You can set values for multiple parameters in the same *alter_session_set_clause*.
## EDITION
Specify `EDITION` = *edition* to set the specified edition as the edition in the database session. You must have the `USE` object privilege on *edition*, *edition* must already have been created, and it must be `USABLE`.
When this statement is successful, the database discards PL/SQL package state corresponding to editionable packages but retains package state corresponding to packages that are not editionable.
You can also set the edition for the current session at startup with the `EDITION` parameter of the SQL*Plus `CONNECT` command. However, you cannot specify an `ALTER` `SESSION` `SET` `EDITION` statement in a recursive SQL or PL/SQL block.
You can determine the edition in use by the current session with the following query:
```
SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') FROM DUAL;
```
**See Also:**   CREATE EDITION for more information on editions and *Oracle Database PL/SQL Language Reference* for information on how editions are designated as `USABLE`
## CONTAINER
Use this clause in a multitenant container database (CDB) to switch to the container specified by *container_name*.
To use this clause, you must be a common user with the `SET` `CONTAINER` privilege, either granted commonly or granted locally in *container_name*.
For *container_name*, specify one of the following:
- CDB$ROOT to switch to the root
- PDB$SEED to switch to the seed
- A pluggable database (PDB) name to switch to that PDB. You can view the names of the PDBs in a CDB by querying the DBA_PDBS view.
You can determine the container to which the current session is connected by using the SQL*Plus `SHOW` `CON_NAME` command or with the following SQL query:
```
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM DUAL;
```
**SERVICE** By default, when you switch to a container, the session uses the default service for the container. Specify the `SERVICE` clause to use a different service for the container. For *service_name*, specify the name of the service you want to use.
**See Also:**   *Oracle Database Administrator’s Guide* for more information on switching to a container
## ROW ARCHIVAL VISIBILITY
Use this clause to configure row archival visibility for the session. This clause lets you implement In-Database Archiving, which allows you to designate table rows as active or archived. You can then perform queries on only the active rows within the table.
- If you specify ACTIVE, then the database will consider only active rows when performing queries on tables that are enabled for row archival. This is the default.
- If you specify ALL, then the database will consider all rows when performing queries on tables that are enabled for row archival.
This clause has no effect on queries on tables that are not enabled for row archival.
```

```
## DEFAULT_COLLATION
Use this clause to set the default collation for the session.
****
- Use collation_name to specify the default collation for the session. You can specify the name of any valid named collation or pseudo-collation. This collation becomes the effective schema default collation. This collation is assigned to tables, views, and materialized views that are subsequently created in any schema for the duration of the session. The default collation for the session does not get propagated to any remote sessions connected to the current session using DB links.
**
- If you specify NONE, then there is no default collation for the session. In this case, the default collation for a particular schema becomes the effective schema default collation for that schema. That default collation is assigned to tables, views, and materialized views that are subsequently created in the schema for the duration of the session.
In either of the preceding cases, you can override the effective schema default collation and assign a default collation to a particular table, materialized view, or view by specifying the `DEFAULT` `COLLATION` clause of the `CREATE` or `ALTER` statement for the table, materialized view, or view.
The effective schema default collation also affects the DDL statements `CREATE` `FUNCTION`, `CREATE` `PACKAGE`, `CREATE` `PROCEDURE`, `CREATE` `TRIGGER`, and `CREATE` `TYPE`. Refer to *Oracle Database PL/SQL Language Reference* for more details on these statements.
You can query the default collation for a session with the following statement:
```
SELECT SYS_CONTEXT('USERENV', 'SESSION_DEFAULT_COLLATION') FROM DUAL;
```
You can specify the `SET` `DEFAULT_COLLATION` clause only if the `COMPATIBLE` initialization parameter is set to `12.2` or greater, and the `MAX_STRING_SIZE` initialization parameter is set to `EXTENDED`.
**See Also:**   The DEFAULT COLLATION Clause clause of `CREATE` `USER` for more information on the default collation of a schema **Note:**   The effective schema default collation for a session should not be confused with the session parameter `NLS_SORT`. The effective schema default collation is used by DDL statements to decide the default data-bound collation of tables, views, and materialized views when they are created. The session parameter `NLS_SORT` points to a named collation that is used when Oracle executes a query, a DML statement, or PL/SQL code containing a SQL operation whose determined collation is a pseudo-collation, such as `USING_NLS_COMP` or `USING_NLS_SORT`. Refer to *Oracle Database Globalization Support Guide* for more information.
## Initialization Parameters and ALTER SESSION
Some initialization parameter are dynamic in the scope of `ALTER` `SESSION`. When you set these parameters using `ALTER` `SESSION`, the value you set persists only for the duration of the current session.To determine whether a parameter can be altered using an `ALTER` `SESSION` statement, query the `ISSES_MODIFIABLE` column of the `V$PARAMETER` dynamic performance view.
**Note:**   Before changing the values of initialization parameters, refer to their full description in *Oracle Database Reference*.
A number of parameters that can be set using `ALTER` `SESSION` are not initialization parameters. You can set them only with `ALTER` `SESSION`, not in an initialization parameter file. Those session parameters are described in “Session Parameters and ALTER SESSION”.
## Session Parameters and ALTER SESSION
The following parameters are session parameters only, not initialization parameters:
**CONSTRAINT[S]** **Syntax:**
```
CONSTRAINT[S] = { IMMEDIATE | DEFERRED | DEFAULT }
```
The `CONSTRAINT[S]` parameter determines when conditions specified by a deferrable constraint are enforced.
``````````
- IMMEDIATE indicates that the conditions specified by the deferrable constraint are checked immediately after each DML statement. This setting is equivalent to issuing the SET CONSTRAINTS ALL IMMEDIATE statement at the beginning of each transaction in your session.
``````````
- DEFERRED indicates that the conditions specified by the deferrable constraint are checked when the transaction is committed. This setting is equivalent to issuing the SET CONSTRAINTS ALL DEFERRED statement at the beginning of each transaction in your session.
``````
- DEFAULT restores all constraints at the beginning of each transaction to their initial state of DEFERRED or IMMEDIATE.
**CURRENT_SCHEMA**
**Syntax:**
```
CURRENT_SCHEMA = schema
```
The `CURRENT_SCHEMA` parameter changes the current schema of the session to the specified schema. Subsequent unqualified references to schema objects during the session will resolve to objects in the specified schema. The setting persists for the duration of the session or until you issue another `ALTER` `SESSION` `SET` `CURRENT_SCHEMA` statement.
This setting offers a convenient way to perform operations on objects in a schema other than that of the current user without having to qualify the objects with the schema name. This setting changes the current schema, but it does not change the session user or the current user, nor does it give the session user any additional system or object privileges for the session.
**ERROR_ON_OVERLAP_TIME**
**Syntax:**
```
ERROR_ON_OVERLAP_TIME = {TRUE | FALSE}
```
The `ERROR_ON_OVERLAP_TIME` parameter determines how Oracle Database should handle an ambiguous boundary datetime value-a case in which it is not clear whether the datetime is in standard or daylight saving time.
- Specify TRUE to return an error for the ambiguous overlap timestamp.
- Specify FALSE to default the ambiguous overlap timestamp to the standard time. This is the default.
Refer to “Support for Daylight Saving Times” for more information on boundary datetime values.
**FLAGGER**
**Syntax:**
```
FLAGGER = { ENTRY | OFF }
```
The `FLAGGER` parameter specifies FIPS flagging (as specified in Federal Information Processing Standard 127-2), which causes an error message to be generated when a SQL statement issued is an extension of the Entry Level of SQL-92 (officially, ANSI X
3.135-1992, a standard that is now superseded by SQL:2016). `FLAGGER` is a session parameter only, not an initialization parameter.
After flagging is set in a session, a subsequent `ALTER` `SESSION` `SET` `FLAGGER` statement will work, but generates the message, ORA-00097. This allows FIPS flagging to be altered without disconnecting the session. `OFF` turns off flagging.
**See Also:**   Oracle and Standard SQL, for more information about Oracle compliance with current ANSI SQL standards
**INSTANCE**
**Syntax:**
```
INSTANCE = integer
```
Setting the `INSTANCE` parameter lets you access another instance as if you were connected to your own instance. `INSTANCE` is a session parameter only, not an initialization parameter. In an Oracle Real Application Clusters (Oracle RAC) environment, each Oracle RAC instance retains static or dynamic ownership of disk space for optimal DML performance based on the setting of this parameter.
**ISOLATION_LEVEL**
**Syntax:**
```
ISOLATION_LEVEL = {SERIALIZABLE | READ COMMITTED}
```
The `ISOLATION_LEVEL` parameter specifies how transactions containing database modifications are handled. `ISOLATION_LEVEL` is a session parameter only, not an initialization parameter.
- SERIALIZABLE indicates that transactions in the session use the serializable transaction isolation mode as specified in the SQL standard. If a serializable transaction attempts to execute a DML statement that updates rows currently being updated by another uncommitted transaction at the start of the serializable transaction, then the DML statement fails. A serializable transaction can see its own updates.
````****
- READ COMMITTED indicates that transactions in the session will use the default Oracle Database transaction behavior. If the transaction contains DML that requires row locks held by another transaction, then the DML statement will wait until the row locks are released. Note: Serializable transactions do not work with deferred segment creation or interval partitioning. Trying to insert data into an empty table with no segment created, or into a partition of an interval partitioned table that does not yet have a segment, causes an error.
**STANDBY_MAX_DATA_DELAY** **Syntax:**
```
STANDBY_MAX_DATA_DELAY =  { integer | NONE }
```
In an Active Data Guard environment, this session parameter can be used to specify a session-specific apply lag tolerance, measured in seconds, for queries issued by non-administrative users to a physical standby database that is in real-time query mode. This capability allows queries to be safely offloaded from the primary database to a physical standby database, because it is possible to detect if the standby database has become unacceptably stale.
If `STANDBY_MAX_DATA_DELAY` is set to the default value of `NONE`, queries issued to a physical standby database will be executed regardless of the apply lag on that database.
If `STANDBY_MAX_DATA_DELAY` is set to a nonzero value, a query issued to a physical standby database will be executed only if the apply lag is less than or equal to `STANDBY_MAX_DATA_DELAY`. Otherwise, an `ORA-3172` error is returned to alert the client that the apply lag is too large.
If `STANDBY_MAX_DATA_DELAY` is set to `0`, a query issued to a physical standby database is guaranteed to return the exact same result as if the query were issued on the primary database, unless the standby database is lagging behind the primary database, in which case an `ORA-3172` error is returned.
**See Also:**   *Oracle Data Guard Concepts and Administration* for more information on Active Data Guard and using this session parameter **TIME_ZONE** **Syntax:**
```
TIME_ZONE =  '[+ | -] hh:mi'

             | LOCAL
             | DBTIMEZONE
             | 'time_zone_region'

```
The `TIME_ZONE` parameter specifies the default local time zone offset or region name for the current SQL session. `TIME_ZONE` is a session parameter only, not an initialization parameter. To determine the time zone of the current session, query the built-in function `SESSIONTIMEZONE` (see SESSIONTIMEZONE).
******
- Specify a format mask ('[+|-]hh:mi') indicating the hours and minutes before or after UTC (Coordinated Universal Time—formerly Greenwich Mean Time). The valid range for hh:mi is -12:00 to +14: 00.
- Specify LOCAL to set the default local time zone offset of the current SQL session to the original default local time zone offset that was established when the current SQL session was started.
````
- Specify DBTIMEZONE to set the current session time zone to match the value set for the database time zone. If you specify this setting, then the DBTIMEZONE function will return the database time zone as a UTC offset or a time zone region, depending on how the database time zone has been set.
**``````
- Specify a valid time_zone_region. To see a listing of valid time zone region names, query the TZNAME column of the V$TIMEZONE_NAMES dynamic performance view. If you specify this setting, then the SESSIONTIMEZONE function will return the region name.
**Note:**    Time zone region names are needed by the daylight saving feature. These names are stored in two types of time zone files: one large and one small. One of these files is the default file, depending on your environment and the release of Oracle Database you are using. For more information regarding time zone files and names, see *Oracle Database Globalization Support Guide*.
**See Also:**   *Oracle Database Globalization Support Guide* for a complete listing of the time zone region names in both files
**Note:**   You can also set the default client session time zone using the `ORA_SDTZ` environment variable. Refer to *Oracle Database Globalization Support Guide* for more information on this variable.
**USE_PRIVATE_OUTLINES**
**Syntax:**
```
USE_PRIVATE_OUTLINES = { TRUE | FALSE | category_name }
```
The `USE_PRIVATE_OUTLINES` parameter lets you control the use of private outlines. When this parameter is enabled and an outlined SQL statement is issued, the optimizer retrieves the outline from the session private area rather than the public area used when `USE_STORED_OUTLINES` is enabled. If no outline exists in the session private area, then the optimizer will not use an outline to compile the statement. `USE_PRIVATE_OUTLINES` is not an initialization parameter.
````
- TRUE causes the optimizer to use private outlines stored in the DEFAULT category when compiling requests.
````
- FALSE specifies that the optimizer should not use stored private outlines. This is the default. If USE_STORED_OUTLINES is enabled, then the optimizer will use stored public outlines.
****
- category_name causes the optimizer to use outlines stored in the category_name category when compiling requests.
**Restriction on USE_PRIVATE_OUTLINES**
You cannot enable this parameter if `USE_STORED_OUTLINES` is enabled.
**USE_STORED_OUTLINES**
**Note:**   Stored outlines are deprecated. They are still supported for backward compatibility. However, Oracle recommends that you use SQL plan management instead. Refer to *Oracle Database SQL Tuning Guide* for more information about SQL plan management.
**Syntax:**
```
USE_STORED_OUTLINES = { TRUE | FALSE | category_name }
```
The `USE_STORED_OUTLINES` parameter determines whether the optimizer will use stored public outlines to generate execution plans. `USE_STORED_OUTLINES` is not an initialization parameter.
````
- TRUE causes the optimizer to use outlines stored in the DEFAULT category when compiling requests.
- FALSE specifies that the optimizer should not use stored outlines. This is the default.
****
- category_name causes the optimizer to use outlines stored in the category_name category when compiling requests.
**Restriction on USED_STORED_OUTLINES** You cannot enable this parameter if `USE_PRIVATE_OUTLINES` is enabled.
**Examples** **Enabling Parallel DML: Example** Issue the following statement to enable parallel DML mode for the current session:
```
ALTER SESSION ENABLE PARALLEL DML;
```
**Forcing a Distributed Transaction: Example** The following transaction inserts an employee record into the `employees` table on the database identified by the database link `remote` and deletes an employee record from the `employees` table on the database identified by `local`:
```
ALTER SESSION
   ADVISE COMMIT;
INSERT INTO employees@remote
   VALUES (8002, 'Juan', 'Fernandez', 'juanf@example.com', NULL,
   TO_DATE('04-OCT-1992', 'DD-MON-YYYY'), 'SA_CLERK', 3000,
   NULL, 121, 20);
ALTER SESSION
   ADVISE ROLLBACK;
DELETE FROM employees@local
   WHERE employee_id = 8002;
COMMIT;
```
This transaction has two `ALTER` `SESSION` statements with the `ADVISE` clause. If the transaction becomes in doubt, then `remote` is sent the advice ‘`COMMIT`’ by virtue of the first `ALTER` `SESSION` statement and `local` is sent the advice ‘`ROLLBACK`’ by virtue of the second statement.
**Closing a Database Link: Example** This statement updates the `jobs` table on the `local` database using a database link, commits the transaction, and explicitly closes the database link:
```
UPDATE jobs@local SET min_salary = 3000
   WHERE job_id = 'SH_CLERK';
COMMIT;
ALTER SESSION
   CLOSE DATABASE LINK local;
```
**Changing the Date Format Dynamically: Example** The following statement dynamically changes the default date format for your session to `'YYYY MM DD-HH24:MI:SS'`:
```
ALTER SESSION
   SET NLS_DATE_FORMAT = 'YYYY MM DD HH24:MI:SS';
```
Oracle Database uses the new default date format:
```
SELECT TO_CHAR(SYSDATE) Today
   FROM DUAL;
TODAY
-------------------
2001 04 12 12:30:38
```
**Changing the Date Language Dynamically: Example** The following statement changes the language for date format elements to French:
```
ALTER SESSION
   SET NLS_DATE_LANGUAGE = French;
SELECT TO_CHAR(SYSDATE, 'Day DD Month YYYY') Today
   FROM DUAL;
TODAY
---------------------------
Jeudi    12 Avril     2001
```
**Changing the ISO Currency: Example** The following statement dynamically changes the ISO currency symbol to the ISO currency symbol for the territory America:
```
ALTER SESSION
   SET NLS_ISO_CURRENCY = America;
SELECT TO_CHAR( SUM(salary), 'C999G999D99') Total
   FROM employees;
TOTAL
------------------
     USD694,900.00
```
**Changing the Decimal Character and Group Separator: Example** The following statement dynamically changes the decimal character to comma (,) and the group separator to period (.):
```
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.' ;
```
Oracle Database returns these new characters when you use their number format elements:
```
ALTER SESSION SET NLS_CURRENCY = 'FF';
SELECT TO_CHAR( SUM(salary), 'L999G999D99') Total FROM employees;
TOTAL
---------------------
         FF694.900,00
```
**Changing the NLS Currency: Example** The following statement dynamically changes the local currency symbol to ‘`DM`’:
```
ALTER SESSION
   SET NLS_CURRENCY = 'DM';
SELECT TO_CHAR( SUM(salary), 'L999G999D99') Total
   FROM employees;
TOTAL
---------------------
         DM694.900,00
```
**Changing the NLS Language: Example** The following statement dynamically changes to French the language in which error messages are displayed:
```
ALTER SESSION
   SET NLS_LANGUAGE = FRENCH;
Session modifiee.
SELECT * FROM DMP;
ORA-00942: Table ou vue inexistante
```
**Changing the Linguistic Sort Sequence: Example** The following statement dynamically changes the linguistic sort sequence to Spanish:
```
ALTER SESSION
   SET NLS_SORT = XSpanish;
```
Oracle Database sorts character values based on their position in the Spanish linguistic sort sequence.
**Enabling Query Rewrite: Example** This statement enables query rewrite in the current session for all materialized views that have not been explicitly disabled:
```
ALTER SESSION
  SET QUERY_REWRITE_ENABLED = TRUE;
```
