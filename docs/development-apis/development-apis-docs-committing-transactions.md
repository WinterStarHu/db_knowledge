# Committing Transactions

Committing a transaction makes its changes permanent, erases its savepoints, and releases its locks.
To explicitly commit a transaction, use either the COMMIT statement or (in the SQL Developer environment) the **Commit Changes** icon.
**Note:**   Oracle Database issues an implicit COMMIT statement before and after any data definition language (DDL) statement. For information about DDL statements, see “About Data Definition Language (DDL) Statements”.
Before you commit a transaction:
- Your changes are visible to you, but not to other users of the database instance.
- Your changes are not final—you can undo them with a ROLLBACK statement.
After you commit a transaction:
- Your changes are visible to other users, and to their statements that run after you commit your transaction.
- Your changes are final—you cannot undo them with a ROLLBACK statement.
Example 3-7 adds one row to the REGIONS table (a very simple transaction), checks the result, and then commits the transaction.
**Example 3-7 Committing a Transaction** Before transaction:
```
SELECT * FROM REGIONS
ORDER BY REGION_ID;
```
Result:
```
REGION_ID REGION_NAME
---------- -------------------------
         1 Europe
         2 Americas
         3 Asia
         4 Middle East and Africa
4 rows selected.
```
Transaction (add row to table):
```
INSERT INTO regions (region_id, region_name) VALUES (5, 'Africa');
```
Result:
```
1 row created.
```
Check that row was added:
```
SELECT * FROM REGIONS
ORDER BY REGION_ID;
```
Result:
```
REGION_ID REGION_NAME
---------- -------------------------
         1 Europe
         2 Americas
         3 Asia
         4 Middle East and Africa
         5 Africa
5 rows selected.
```
Commit transaction:
```
COMMIT;
```
Result:
```
Commit complete.
```
**See Also:**   *Oracle Database SQL Language Reference* for information about the COMMIT statement
