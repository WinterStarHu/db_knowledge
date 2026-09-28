# About Transaction Control Statements

A **transaction** is a sequence of one or more SQL statements that Oracle Database treats as a unit: either all of the statements are performed, or none of them are. You need transactions to model business processes that require that several operations be performed as a unit.
For example, when a manager leaves the company, a row must be inserted into the JOB_HISTORY table to show when the manager left, and for every employee who reports to that manager, the value of MANAGER_ID must be updated in the EMPLOYEES table. To model this process in an application, you must group the INSERT and UPDATE statements into a single transaction.
The basic **transaction control statements** are SAVEPOINT, COMMIT, and ROLLBACK:
****
- SAVEPOINT marks a savepoint in a transaction—a point to which you can later roll back. Savepoints are optional, and a transaction can have multiple savepoints.
- COMMIT ends the current transaction, makes its changes permanent, erases its savepoints, and releases its locks.
- ROLLBACK rolls back (undoes) either the entire current transaction or only the changes made after the specified savepoint.
In the SQL*Plus environment, you can enter a transaction control statement after the SQL> prompt.
In the SQL Developer environment, you can enter a transaction control statement in the Worksheet. SQL Developer also has Commit Changes and Rollback Changes icons, which are explained in “Committing Transactions” and “Rolling Back Transactions”.
**Caution:** If you do not explicitly commit a transaction, and the program terminates abnormally, then the database automatically rolls back the last uncommitted transaction.
Because of this behavior, explicitly end transactions in application programs by either committing them or rolling them back.
**See Also:** **
- Oracle Database Concepts for more information about transaction management
**
- Oracle Database SQL Language Reference for more information about transaction control statements
