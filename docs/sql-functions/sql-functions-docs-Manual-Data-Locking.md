# Manual Data Locking

Oracle Database always performs locking automatically to ensure data concurrency, data integrity, and statement-level read consistency. However, you can override the Oracle default locking mechanisms. This can be useful in situations such as the following:
- When your application requires consistent data for the duration of the transaction, not reflecting changes by other transactions, you can achieve transaction-level read consistency by using explicit locking, read-only transactions, serializable transactions, or by overriding default locking.
- When your application requires that a transaction have exclusive access to a resource so that the transaction does not have to wait for other transactions to complete, you can explicitly lock the data for the duration of the transaction.
You can override automatic locking at two levels:
****
````````
  - SET TRANSACTION ISOLATION LEVEL
````
  - LOCK TABLE
``````
  - SELECT ... FOR UPDATE
Locks acquired by these statements are released after the transaction commits or rolls back.
****``````````******
- Session. A session can set the required transaction isolate level with an ALTER SESSION SET ISOLATION LEVEL statement. Note: When overriding Oracle default locking, the database administrator or application developer should ensure that data integrity is guaranteed, data concurrency is acceptable, and deadlocks are not possible or, if possible, are appropriately handled. For more information on these criteria, see Oracle Database Concepts.
