# PostgreSQL: Documentation: 18: SAVEPOINT

PostgreSQL: Documentation: 18: SAVEPOINT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
SAVEPOINT Prev Up SQL Commands Home Next SAVEPOINT SAVEPOINT — define a new savepoint within the current transaction Synopsis SAVEPOINT savepoint_name Description SAVEPOINT establishes a new savepoint within the current transaction.
A savepoint is a special mark inside a transaction that allows all commands that are executed after it was established to be rolled back, restoring the transaction state to what it was at the time of the savepoint.
Parameters savepoint_name The name to give to the new savepoint. If savepoints with the same name already exist, they will be inaccessible until newer identically-named savepoints are released.
Notes Use ROLLBACK TO to rollback to a savepoint. Use RELEASE SAVEPOINT to destroy a savepoint, keeping the effects of commands executed after it was established.
Savepoints can only be established when inside a transaction block. There can be multiple savepoints defined within a transaction.
Examples To establish a savepoint and later undo the effects of all commands executed after it was established:
BEGIN;
INSERT INTO table1 VALUES (1);
SAVEPOINT my_savepoint;
INSERT INTO table1 VALUES (2);
ROLLBACK TO SAVEPOINT my_savepoint;
INSERT INTO table1 VALUES (3);
COMMIT;
The above transaction will insert the values 1 and 3, but not 2.
To establish and later destroy a savepoint:
BEGIN;
INSERT INTO table1 VALUES (3);
SAVEPOINT my_savepoint;
INSERT INTO table1 VALUES (4);
RELEASE SAVEPOINT my_savepoint;
COMMIT;
The above transaction will insert both 3 and 4.
To use a single savepoint name:
BEGIN;
INSERT INTO table1 VALUES (1);
SAVEPOINT my_savepoint;
INSERT INTO table1 VALUES (2);
SAVEPOINT my_savepoint;
INSERT INTO table1 VALUES (3);
-- rollback to the second savepoint ROLLBACK TO SAVEPOINT my_savepoint;
SELECT * FROM table1;               -- shows rows 1 and 2 -- release the second savepoint RELEASE SAVEPOINT my_savepoint;
-- rollback to the first savepoint ROLLBACK TO SAVEPOINT my_savepoint;
SELECT * FROM table1;               -- shows only row 1 COMMIT;
The above transaction shows row 3 being rolled back first, then row 2.
Compatibility SQL requires a savepoint to be destroyed automatically when another savepoint with the same name is established. In PostgreSQL, the old savepoint is kept, though only the more recent one will be used when rolling back or releasing. (Releasing the newer savepoint with RELEASE SAVEPOINT will cause the older one to again become accessible to ROLLBACK TO SAVEPOINT and RELEASE SAVEPOINT.) Otherwise, SAVEPOINT is fully SQL conforming.
See AlsoBEGIN, COMMIT, RELEASE SAVEPOINT, ROLLBACK, ROLLBACK TO SAVEPOINT Prev Up Next ROLLBACK TO SAVEPOINT Home SECURITY LABEL Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
