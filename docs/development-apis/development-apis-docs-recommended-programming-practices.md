# Programming Practices

Use the following programming practices.
## Use Instrumentation Packages
Oracle Database supplies instrumentation packages whose subprograms let your application generate trace information whenever necessary. Using this trace information, you can debug your application without a debugger and identify code that performs badly.
Instrumentation provides your application with considerable functionality; therefore, it is not overhead. Overhead is something that you can remove without losing much benefit.
The following instrumentation packages are supplied by Oracle Database:
**
- DBMS_APPLICATION_INFO enables a system administrator to track the performance of your application by module. For more information about DBMS_APPLICATION_INFO, see Oracle Database PL/SQL Packages and Types Reference.
**
- DBMS_SESSION enables your application to access session information and set preferences and security levels For more information about DBMS_SESSION, see Oracle Database PL/SQL Packages and Types Reference.
**
- UTL_FILE enables your application to read and write operating system text files For more information about UTL_FILE, see Oracle Database PL/SQL Packages and Types Reference.
**See Also:**   *Oracle Database PL/SQL Packages and Types Reference* for a summary of PL/SQL packages that Oracle Database supplies
## Statistics Gathering and Application Tracing
Database statistics provide information about the type of load on the database and the internal and external resources used by the database. To accurately diagnose performance problems with the database using ADDM, statistics must be available.
For information about statistics gathering, see *Oracle Database 2 Day + Performance Tuning Guide*.
**Note:**   If Oracle Enterprise Manager is unavailable, then you can gather statistics using DBMS_MONITOR subprograms, described in *Oracle Database PL/SQL Packages and Types Reference*.
Oracle Database provides several tracing tools that can help you monitor and analyze Oracle Database applications. For details, see *Oracle Database SQL Tuning Guide*.
## Use Existing Functionality
An application that uses existing functionality is easier to develop and maintain than one that does not, and it also runs faster.
When developing your application, use the existing functionality of your programming language, your operating system, Oracle Database, and the PL/SQL packages and types that Oracle Database supplies as much as possible.
Examples of existing functionality that many developers reinvent include the following functions:
****
- Constraints For introductory information about constraints, see “Ensuring Data Integrity in Tables.”
**** **
- SQL functions (functions that are “built into” SQL) For information about SQL functions, see Oracle Database SQL Language Reference.
****
- Sequences (which can generate unique sequential values) See “Creating and Managing Sequences”.
**** **
- Auditing (the monitoring and recording of selected user database actions) For introductory information about auditing, see Oracle Database Security Guide.
****
- Replication (the process of copying and maintaining database objects, such as tables, in multiple databases that comprise a distributed database system) For information about replication, see the Oracle GoldenGate documentation..
**** **
- Message queuing (how web-based business applications communicate with each other) For introductory information about Oracle Database Advanced Queuing (AQ), see Oracle Database Advanced Queuing User’s Guide.
**** **
- Maintaining a history of record changes For introductory information about Workspace Manager, see Oracle Database Workspace Manager Developer’s Guide.
In Example 8-4, two concurrent transactions dequeue messages stored in a table (that is, each transaction finds and locks the next unprocessed row of the table). Rather than simply invoking the DBMS_AQ.DEQUEUE procedure (described in *Oracle Database PL/SQL Packages and Types Reference*), the example creates a function-based index on the table and then uses that function in each transaction to retrieve the rows and display the messages.
The code in Example 8-4 implements a feature similar to a DBMS_AQ.DEQUEUE invocation but with fewer capabilities. The development time saved by using existing functionality (in this case, function-based indexes) can be large.
**Example 8-4 Concurrent Dequeuing Transactions** Create table:
```
DROP TABLE t;
CREATE TABLE t
  ( id             NUMBER PRIMARY KEY,
    processed_flag VARCHAR2(1),
    payload        VARCHAR2(20)
  );
```
**Create index on table:**
```
CREATE INDEX t_idx ON
  t( DECODE( processed_flag, 'N', 'N' ) );
```
Populate table:
```
INSERT INTO t
  SELECT r,
         CASE WHEN MOD(r,2) = 0 THEN 'N' ELSE 'Y' END,
         'payload ' || r
  FROM (SELECT LEVEL r FROM DUAL CONNECT BY LEVEL <= 5);
```
Show table:
```
SELECT * FROM t;
```
Result:
```
ID P PAYLOAD
---------- - --------------------
         1 Y payload 1
         2 N payload 2
         3 Y payload 3
         4 N payload 4
         5 Y payload 5
5 rows selected.
```
**First transaction:**
```
DECLARE
  l_rec t%ROWTYPE;
  CURSOR c IS
    SELECT *
    FROM t
    WHERE DECODE(processed_flag,'N','N') = 'N'
    FOR UPDATE
    SKIP LOCKED;
BEGIN
  OPEN c;
  FETCH c INTO l_rec;
  IF ( c%FOUND ) THEN
    DBMS_OUTPUT.PUT_LINE( 'Got row ' || l_rec.id || ', ' || l_rec.payload );
  END IF;
  CLOSE c;
END;
/
```
Result:
```
Got row 2, payload 2
```
**Concurrent transaction:**
```
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  l_rec t%ROWTYPE;
  CURSOR c IS
    SELECT *
    FROM t
    WHERE DECODE(processed_flag,'N','N') = 'N'
    FOR UPDATE
    SKIP LOCKED;
BEGIN
  OPEN c;
  FETCH c INTO l_rec;
  IF ( c%FOUND ) THEN
    DBMS_OUTPUT.PUT_LINE( 'Got row ' || l_rec.id || ', ' || l_rec.payload );
  END IF;
  CLOSE c;
  COMMIT;
END;
/
```
Result:
```
Got row 4, payload 4
```
**See Also:** **
- Oracle Database New Features Guide (with each release)
**
- Oracle Database Concepts (with each release)
## Cover Database Tables with Editioning Views
If your application uses database tables, cover each one with an editioning view so that you can use edition-based redefinition (EBR) to upgrade the database component of your application while it is in use, thereby minimizing or eliminating down time.
For information about edition-based redefinition, see *Oracle Database Development Guide*.
