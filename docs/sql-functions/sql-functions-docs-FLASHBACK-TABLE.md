# FLASHBACK TABLE

## Purpose
Use the `FLASHBACK` `TABLE` statement to restore an earlier state of a table in the event of human or application error. The time in the past to which the table can be flashed back is dependent on the amount of undo data in the system. Also, Oracle Database cannot restore a table to an earlier state across any DDL operations that change the structure of the table.
**Note:**   ****Oracle strongly recommends that you run your database in automatic undo mode by leaving the `UNDO_MANAGEMENT` initialization parameter set to `AUTO`, which is the default. In addition, set the `UNDO_RETENTION` initialization parameter to an interval large enough to include the oldest data you anticipate needing. For more information refer to the documentation on the `UNDO_MANAGEMENT` and `UNDO_RETENTION` initialization parameters.
You cannot roll back a `FLASHBACK` `TABLE` statement. However, you can issue another `FLASHBACK` `TABLE` statement and specify a time just prior to the current time. Therefore, it is advisable to record the current SCN before issuing a `FLASHBACK` `TABLE` clause.
**See Also:**
- FLASHBACK DATABASE for information on reverting the entire database to an earlier version
**
- the flashback_query_clause of SELECT for information on retrieving past data from a table
**````
- Oracle Database Backup and Recovery User’s Guide for additional information on using the FLASHBACK TABLE statement
## Prerequisites
To flash back a table to an earlier SCN or timestamp, you must have either the `FLASHBACK` object privilege on the table or the `FLASHBACK` `ANY` `TABLE` system privilege. In addition, you must have the `READ` or `SELECT` object privilege on the table, and you must have the `INSERT`, `DELETE`, and `ALTER` object privileges on the table.
Row movement must be enabled for all tables in the Flashback list unless you are flashing back the table `TO` `BEFORE` `DROP`. That operation is called a **flashback drop** operation, and it uses dropped data in the recycle bin rather than undo data. Refer to *row_movement_clause* for information on enabling row movement.
To flash back a table to a restore point, you must have the `SELECT` `ANY` `DICTIONARY` or `FLASHBACK` `ANY` `TABLE` system privilege or the `SELECT_CATALOG_ROLE` role.
To flash back a table to before a `DROP` `TABLE` operation, you need only the privileges necessary to drop the table.
## Syntax
## *flashback_table*::=
Description of the illustration flashback_table.eps
## Semantics
During an Oracle Flashback Table operation, Oracle Database acquires exclusive DML locks on all the tables specified in the Flashback list. These locks prevent any operations on the tables while they are reverting to their earlier state.
The Flashback Table operation is executed in a single transaction, regardless of the number of tables specified in the Flashback list. Either all of the tables revert to the earlier state or none of them do. If the Flashback Table operation fails on any table, then the entire statement fails.
At the completion of the Flashback Table operation, the data in *table* is consistent with *table* at the earlier time. However, `FLASHBACK` `TABLE` `TO` `SCN` or `TIMESTAMP` does not preserve rowids, and `FLASHBACK` `TABLE` `TO` `BEFORE` `DROP` does not recover referential constraints.
Oracle Database does not revert statistics associated with *table* to their earlier form. Indexes on *table* that exist currently are reverted and reflect the state of the table at the Flashback point. If the index exists now but did not yet exist at the Flashback point, then the database updates the index to reflect the state of the table at the Flashback point. However, indexes that were dropped during the interval between the Flashback point and the current time are not restored.
## *schema*
Specify the schema containing the table. If you omit *schema*, then the database assumes the table is in your own schema.
## *table*
Specify the name of one or more tables containing data you want to revert to an earlier version.
**Restrictions on Flashing Back Tables** This statement is subject to the following restrictions:
- Flashback Table operations are not valid for the following type objects: tables that are part of a cluster, materialized views, Advanced Queuing (AQ) tables, static data dictionary tables, system tables, remote tables, object tables, nested tables, or individual table partitions or subpartitions.
````````
- The following DDL operations change the structure of a table, so that you cannot subsequently use the TO SCN or TO TIMESTAMP clause to flash the table back to a time preceding the operation: upgrading, moving, or truncating a table; adding a constraint to a table, adding a table to a cluster; modifying or dropping a column; changing a column encryption key; adding, dropping, merging, splitting, coalescing, or truncating a partition or subpartition (with the exception of adding a range partition).
## TO SCN Clause
Specify the system change number (SCN) corresponding to the point in time to which you want to return the table. The *expr* must evaluate to a number representing a valid SCN.
## TO TIMESTAMP Clause
Specify a timestamp value corresponding to the point in time to which you want to return the table. The *expr* must evaluate to a valid timestamp in the past. The table will be flashed back to a time within approximately 3 seconds of the specified timestamp.
## TO RESTORE POINT Clause
Specify a restore point to which you want to flash back the table. The restore point must already have been created.
**See Also:**   CREATE RESTORE POINT for information on creating restore points
## ENABLE | DISABLE TRIGGERS
By default, Oracle Database disables all enabled triggers defined on *table* during the Flashback Table operation and then reenables them after the Flashback Table operation is complete. Specify `ENABLE` `TRIGGERS` if you want to override this default behavior and keep the triggers enabled during the Flashback process.
This clause affects only those database triggers defined on *table* that are already enabled. To enable currently disabled triggers selectively, use the `ALTER` `TABLE` … *enable_disable_clause* before you issue the `FLASHBACK` `TABLE` statement with the `ENABLE` `TRIGGERS` clause.
## TO BEFORE DROP Clause
Use this clause to retrieve from the recycle bin a table that has been dropped, along with all possible dependent objects. The table must have resided in a locally managed tablespace other than the `SYSTEM` tablespace.
**See Also:**
**
- Oracle Database Administrator’s Guide for information on the recycle bin and naming conventions for objects in the recycle bin
- PURGE for information on removing objects permanently from the recycle bin
You can specify either the original user-specified name of the table or the system-generated name Oracle Database assigned to the object when it was dropped.
````
- System-generated recycle bin object names are unique. Therefore, if you specify the system-generated name, then the database retrieves that specified object. To see the contents of your recycle bin, query the USER_RECYCLEBIN data dictionary view. You can use the RECYCLEBIN synonym instead. The following two statements return the same rows:
```
SELECT * FROM RECYCLEBIN;
SELECT * FROM USER_RECYCLEBIN;
```
  - Specify the system-generated recycle bin name of the table you want to retrieve.
``````````
  - Issue additional FLASHBACK TABLE ... TO BEFORE DROP statements until you retrieve the table you want.
Oracle Database attempts to preserve the original table name. If a new table of the same name has been created in the same schema since the original table was dropped, then the database returns an error unless you also specify the `RENAME` `TO` clause.
## RENAME TO Clause
Use this clause to specify a new name for the table being retrieved from the recycle bin.
**Notes on Flashing Back Dropped Tables**
The following notes apply to flashing back dropped tables:
````
- Oracle Database retrieves all indexes defined on the table retrieved from the recycle bin except for bitmap join indexes and domain indexes. (Bitmap join indexes and domain indexes are not put in the recycle bin during a DROP TABLE operation, so cannot be retrieved.)
````````````
- The database also retrieves all triggers and constraints defined on the table except for referential integrity constraints that reference other tables. The retrieved indexes, triggers, and constraints have recycle bin names. Therefore it is advisable to query the USER_RECYCLEBIN view before issuing a FLASHBACK TABLE ... TO BEFORE DROP statement so that you can rename the retrieved triggers and constraints to more usable names.
- When you drop a table, all materialized view logs defined on the table are also dropped but are not placed in the recycle bin. Therefore, the materialized view logs cannot be flashed back along with the table.
- When you drop a table, any indexes on the table are dropped and put into the recycle bin along with the table. If subsequent space pressures arise, then the database reclaims space from the recycle bin by first purging indexes. In this case, when you flash back the table, you may not get back all of the indexes that were defined on the table.
- You cannot flash back a table if it has been purged, either by a user or by Oracle Database as a result of some space reclamation operation.
## Examples
**Restoring a Table to an Earlier State: Examples**
The examples below create a new table, `employees_test`, with row movement enabled, update values within the new table, and issue the `FLASHBACK` `TABLE` statement.
Create table `employees_test`, with row movement enabled, from table `employees` of the sample `hr` schema:
```
CREATE TABLE employees_test AS SELECT * FROM employees;
```
As a benchmark, list those salaries less than 2500:
```
SELECT salary FROM employees_test WHERE salary < 2500;
SALARY
----------
2400 2200 2100 2400 2200
```
**Note:**   To allow time for the SCN to propagate to the mapping table used by the `FLASHBACK` `TABLE` statement, wait a minimum of 5 minutes prior to issuing the following statement. This wait would not be necessary if a previously existing table were being used in this example.
Enable row movement for the table:
```
ALTER TABLE employees_test ENABLE ROW MOVEMENT;
```
Issue a 10% salary increase to those employees earning less than 2500:
```
UPDATE employees_test SET salary = salary * 1.1 WHERE salary < 2500;
5 rows updated.
COMMIT;
```
As a second benchmark, list those salaries that remain less than 2500 following the 10% increase:
```
SELECT salary FROM employees_test WHERE salary < 2500;
SALARY
----------
2420 2310 2420
```
Restore the table `employees_test` to its state prior to the current system time. The unrealistic duration of 1 minute is used so that you can test this series of examples quickly. Under normal circumstances a much greater interval would have elapsed.
```
FLASHBACK TABLE employees_test TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '1' minute);
```
List those salaries less than 2500. After the `FLASHBACK` `TABLE` statement issued above, this list should match the list in the first benchmark.
```
SELECT salary FROM employees_test WHERE salary < 2500;
SALARY
----------
2400 2200 2100 2400 2200
```
**Retrieving a Dropped Table: Example**
If you accidentally drop the `pm.print_media` table and want to retrieve it, then issue the following statement:
```
FLASHBACK TABLE print_media TO BEFORE DROP;
```
If another `print_media` table has been created in the `pm` schema, then use the `RENAME` `TO` clause to rename the retrieved table:
```
FLASHBACK TABLE print_media TO BEFORE DROP RENAME TO print_media_old;
```
If you know that the employees table has been dropped multiple times, and you want to retrieve the oldest version, then query the `USER_RECYLEBIN` table to determine the system-generated name, and then use that name in the `FLASHBACK` `TABLE` statement. (System-generated names in your database will differ from those shown here.)
```
SELECT object_name, droptime FROM user_recyclebin WHERE original_name = 'PRINT_MEDIA';
OBJECT_NAME                    DROPTIME
------------------------------ -------------------
RB$$45703$TABLE$0              2003-06-03:15:26:39 RB$$45704$TABLE$0              2003-06-12:12:27:27 RB$$45705$TABLE$0              2003-07-08:09:28:01
```
