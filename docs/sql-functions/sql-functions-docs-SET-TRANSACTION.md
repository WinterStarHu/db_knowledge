# SET TRANSACTION

## Purpose
Use the `SET` `TRANSACTION` statement to establish the current transaction as read-only or read/write, establish its isolation level, assign it to a specified rollback segment, or assign a name to the transaction.
A transaction implicitly begins with any operation that obtains a TX lock:
- When a statement that modifies data is issued
``````
- When a SELECT ... FOR UPDATE statement is issued
``````
- When a transaction is explicitly started with a SET TRANSACTION statement or the DBMS_TRANSACTION package
Issuing either a `COMMIT` or `ROLLBACK` statement explicitly ends the current transaction.
The operations performed by a `SET` `TRANSACTION` statement affect only your current transaction, not other users or other transactions. Your transaction ends whenever you issue a `COMMIT` or `ROLLBACK` statement. Oracle Database implicitly commits the current transaction before and after executing a data definition language (DDL) statement.
**See Also:**   COMMIT and ROLLBACK
## Prerequisites
If you use a `SET` `TRANSACTION` statement, then it must be the first statement in your transaction. However, a transaction need not have a `SET` `TRANSACTION` statement.
## Syntax
## *set_transaction*::=
Description of the illustration set_transaction.eps
## Semantics
## READ ONLY
The `READ` `ONLY` clause establishes the current transaction as a read-only transaction. This clause established **transaction-level read consistency**.
All subsequent queries in that transaction see only changes that were committed before the transaction began. Read-only transactions are useful for reports that run multiple queries against one or more tables while other users update these same tables.
This clause is not supported for the user `SYS`. Queries by `SYS` will return changes made during the transaction even if `SYS` has set the transaction to be `READ` `ONLY`.
**Restriction on Read-only Transactions** Only the following statements are permitted in a read-only transaction:
**
- Subqueries—SELECT statements without the for_update_clause
````
- LOCK TABLE
````
- SET ROLE
````
- ALTER SESSION
````
- ALTER SYSTEM
## READ WRITE
Specify `READ` `WRITE` to establish the current transaction as a read/write transaction. This clause establishes **statement-level read consistency**, which is the default.
**Restriction on Read/Write Transactions** You cannot toggle between transaction-level and statement-level read consistency in the same transaction.
## ISOLATION LEVEL Clause
- The SERIALIZABLE setting specifies serializable transaction isolation mode as defined in the SQL standard. If a serializable transaction contains data manipulation language (DML) that attempts to update any resource that may have been updated in a transaction uncommitted at the start of the serializable transaction, then the DML statement fails.
````
- The READ COMMITTED setting is the default Oracle Database transaction behavior. If the transaction contains DML that requires row locks held by another transaction, then the DML statement waits until the row locks are released.
## USE ROLLBACK SEGMENT Clause
**Note:**   This clause is relevant and valid only if you are using rollback segments for undo. Oracle strongly recommends that you use automatic undo management to handle undo space. If you follow this recommendation and run your database in automatic undo mode, then Oracle Database ignores this clause.
Specify `USE ROLLBACK SEGMENT` to assign the current transaction to the specified rollback segment. This clause also implicitly establishes the transaction as a read/write transaction.
Parallel DML requires more than one rollback segment. Therefore, if your transaction contains parallel DML operations, then the database ignores this clause.
## NAME Clause
Use the `NAME` clause to assign a name to the current transaction. This clause is especially useful in distributed database environments when you must identify and resolve in-doubt transactions. The *string* value is limited to 255 bytes.
If you specify a name for a distributed transaction, then when the transaction commits, the name becomes the commit comment, overriding any comment specified explicitly in the `COMMIT` statement.
**See Also:**   *Oracle Database Concepts* for more information about transaction naming
## Examples
**Setting Transactions: Examples**
The following statements could be run at midnight of the last day of every month to count the products and quantities on hand in the Toronto warehouse in the sample Order Entry (`oe`) schema. This report would not be affected by any other user who might be adding or removing inventory to a different warehouse.
```
COMMIT;
SET TRANSACTION READ ONLY NAME 'Toronto';
SELECT product_id, quantity_on_hand FROM inventories WHERE warehouse_id = 5 ORDER BY product_id;
COMMIT;
```
The first `COMMIT` statement ensures that `SET` `TRANSACTION` is the first statement in the transaction. The last `COMMIT` statement does not actually make permanent any changes to the database. It simply ends the read-only transaction.
