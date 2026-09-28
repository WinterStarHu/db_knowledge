# Setting Savepoints in Transactions

The SAVEPOINT statement marks a **savepoint** in a transaction-a point to which you can later roll back. Savepoints are optional, and a transaction can have multiple savepoints.
Example 3-9 does a transaction that includes several DML statements and several savepoints, and then rolls back the transaction to one savepoint, undoing only the changes made after that savepoint.
**Example 3-9 Rolling Back a Transaction to a Savepoint** Check REGIONS table before transaction:
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
Check countries in region 4 before transaction:
```
SELECT COUNTRY_NAME, COUNTRY_ID, REGION_ID
FROM COUNTRIES
WHERE REGION_ID = 4
ORDER BY COUNTRY_NAME;
```
Result:
```
COUNTRY_NAME                             CO  REGION_ID
---------------------------------------- -- ----------
Egypt                                    EG          4
Israel                                   IL          4
Kuwait                                   KW          4
Nigeria                                  NG          4
Zambia                                   ZM          4
Zimbabwe                                 ZW          4
6 rows selected.
```
Check countries in region 5 before transaction:
```
SELECT COUNTRY_NAME, COUNTRY_ID, REGION_ID
FROM COUNTRIES
WHERE REGION_ID = 5
ORDER BY COUNTRY_NAME;
```
Result:
```
no rows selected
```
Transaction, with several savepoints:
```
UPDATE REGIONS
SET REGION_NAME = 'Middle East'
WHERE REGION_NAME = 'Middle East and Africa';
UPDATE COUNTRIES
  SET REGION_ID = 5
  WHERE COUNTRY_ID = 'ZM';
SAVEPOINT zambia;
UPDATE COUNTRIES
  SET REGION_ID = 5
  WHERE COUNTRY_ID = 'NG';
SAVEPOINT nigeria;
UPDATE COUNTRIES
  SET REGION_ID = 5
  WHERE COUNTRY_ID = 'ZW';
SAVEPOINT zimbabwe;
UPDATE COUNTRIES
  SET REGION_ID = 5
  WHERE COUNTRY_ID = 'EG';
SAVEPOINT egypt;
```
Check REGIONS table after transaction:
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
Check countries in region 4 after transaction:
```
SELECT COUNTRY_NAME, COUNTRY_ID, REGION_ID
FROM COUNTRIES
WHERE REGION_ID = 4
ORDER BY COUNTRY_NAME;
```
Result:
```
COUNTRY_NAME                             CO  REGION_ID
---------------------------------------- -- ----------
Israel                                   IL          4
Kuwait                                   KW          4
2 rows selected.
```
Check countries in region 5 after transaction:
```
SELECT COUNTRY_NAME, COUNTRY_ID, REGION_ID
FROM COUNTRIES
WHERE REGION_ID = 5
ORDER BY COUNTRY_NAME;
```
Result:
```
COUNTRY_NAME                             CO  REGION_ID
---------------------------------------- -- ----------
Egypt                                    EG          5
Nigeria                                  NG          5
Zambia                                   ZM          5
Zimbabwe                                 ZW          5
4 rows selected.
ROLLBACK TO SAVEPOINT nigeria;
```
Check REGIONS table after rollback:
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
Check countries in region 4 after rollback:
```
SELECT COUNTRY_NAME, COUNTRY_ID, REGION_ID
FROM COUNTRIES
WHERE REGION_ID = 4
ORDER BY COUNTRY_NAME;
```
Result:
```
COUNTRY_NAME                             CO  REGION_ID
---------------------------------------- -- ----------
Egypt                                    EG          4
Israel                                   IL          4
Kuwait                                   KW          4
Zimbabwe                                 ZW          4
4 rows selected.
```
Check countries in region 5 after rollback:
```
SELECT COUNTRY_NAME, COUNTRY_ID, REGION_ID
FROM COUNTRIES
WHERE REGION_ID = 5
ORDER BY COUNTRY_NAME;
```
Result:
```
COUNTRY_NAME                             CO  REGION_ID
---------------------------------------- -- ----------
Nigeria                                  NG          5
Zambia                                   ZM          5
2 rows selected.
```
**See Also:**   *Oracle Database SQL Language Reference* for information about the SAVEPOINT statement
