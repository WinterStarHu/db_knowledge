# Rolling Back Transactions

Rolling back a transaction undoes its changes. You can roll back the entire current transaction, or you can roll it back only to a specified savepoint.
To roll back the current transaction only to a specified savepoint, you must use the ROLLBACK statement with the TO SAVEPOINT clause.
To roll back the entire current transaction, use either the ROLLBACK statement without the TO SAVEPOINT clause, or (in the SQL Developer environment) the **Rollback Changes** icon.
Rolling back the entire current transaction does the following things:
- Ends the transaction
- Reverses all of its changes
- Erases all of its savepoints
- Releases any transaction locks
Rolling back the current transaction only to the specified savepoint does the following things:
- Does not end the transaction
- Reverses only the changes made after the specified savepoint
- Erases only the savepoints set after the specified savepoint (excluding the specified savepoint itself)
- Releases all table and row locks acquired after the specified savepoint Other transactions that have requested access to rows locked after the specified savepoint must continue to wait until the transaction is either committed or rolled back. Other transactions that have not requested the rows can request and access the rows immediately.
To see the effect of a rollback in SQL Developer, you might have to click the **Refresh** icon.
As a result of Example 3-7, the `REGIONS` table has a region called ‘Middle East and Africa’ and a region called ‘Africa’. Example 3-8 corrects this problem (a very simple transaction) and checks the change, but then rolls back the transaction and checks the rollback.
**Example 3-8 Rolling Back an Entire Transaction** Before transaction:
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
Transaction (change table):
```
UPDATE REGIONS
SET REGION_NAME = 'Middle East'
WHERE REGION_NAME = 'Middle East and Africa';
```
Result:
```
1 row updated.
```
Check change:
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
         4 Middle East
         5 Africa
5 rows selected.
```
Roll back transaction:
```
ROLLBACK;
```
Result:
```
Rollback complete.
```
Check rollback:
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
**See Also:**   *Oracle Database SQL Language Reference* for information about the ROLLBACK statement
