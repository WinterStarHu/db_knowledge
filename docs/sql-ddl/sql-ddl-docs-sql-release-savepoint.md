# PostgreSQL: Documentation: 18: RELEASE SAVEPOINT

PostgreSQL: Documentation: 18: RELEASE SAVEPOINT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
RELEASE SAVEPOINT Prev Up SQL Commands Home Next RELEASE SAVEPOINT RELEASE SAVEPOINT — release a previously defined savepoint Synopsis RELEASE [ SAVEPOINT ] savepoint_name Description RELEASE SAVEPOINT releases the named savepoint and all active savepoints that were created after the named savepoint, and frees their resources. All changes made since the creation of the savepoint that didn't already get rolled back are merged into the transaction or savepoint that was active when the named savepoint was created. Changes made after RELEASE SAVEPOINT will also be part of this active transaction or savepoint.
Parameters savepoint_name The name of the savepoint to release.
Notes Specifying a savepoint name that was not previously defined is an error.
It is not possible to release a savepoint when the transaction is in an aborted state; to do that, use ROLLBACK TO SAVEPOINT.
If multiple savepoints have the same name, only the most recently defined unreleased one is released. Repeated commands will release progressively older savepoints.
Examples To establish and later release a savepoint:
BEGIN;
INSERT INTO table1 VALUES (3);
SAVEPOINT my_savepoint;
INSERT INTO table1 VALUES (4);
RELEASE SAVEPOINT my_savepoint;
COMMIT;
The above transaction will insert both 3 and 4.
A more complex example with multiple nested subtransactions:
BEGIN;
INSERT INTO table1 VALUES (1);
SAVEPOINT sp1;
INSERT INTO table1 VALUES (2);
SAVEPOINT sp2;
INSERT INTO table1 VALUES (3);
RELEASE SAVEPOINT sp2;
INSERT INTO table1 VALUES (4))); -- generates an error In this example, the application requests the release of the savepoint sp2, which inserted 3. This changes the insert's transaction context to sp1. When the statement attempting to insert value 4 generates an error, the insertion of 2 and 4 are lost because they are in the same, now-rolled back savepoint, and value 3 is in the same transaction context. The application can now only choose one of these two commands, since all other commands will be ignored:
ROLLBACK;
ROLLBACK TO SAVEPOINT sp1;
Choosing ROLLBACK will abort everything, including value 1, whereas ROLLBACK TO SAVEPOINT sp1 will retain value 1 and allow the transaction to continue.
Compatibility This command conforms to the SQL standard. The standard specifies that the key word SAVEPOINT is mandatory, but PostgreSQL allows it to be omitted.
See AlsoBEGIN, COMMIT, ROLLBACK, ROLLBACK TO SAVEPOINT, SAVEPOINT Prev Up Next REINDEX Home RESET Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
