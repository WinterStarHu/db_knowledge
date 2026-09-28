# Auditing Only Top-Level Statements

You can audit top-level SQL or PL/SQL statements to limit the volume of audit records.
- About Auditing Only Top-Level SQL Statements A top-level statement is a statement that is executed directly by a user, not a statement that is run from within a PL/SQL procedure.
````
- Configuring a Unified Audit Policy to Capture Only Top-Level Statements The ONLY TOPLEVEL clause in the CREATE AUDIT POLICY statement enables you to audit only the SQL statements that are directly issued by an end user by honoring the audit configuration in the audit policy.
- Example: Auditing Top-Level Statements The CREATE AUDIT POLICY statement can include or exclude top-level statement audit records in the unified audit trail for any user.
- Example: Comparison of Top-Level SQL Statement Audits You can generate top-level SQL statement audit records from SQL statements that are run directly in SQL or from within a PL/SQL procedure.
- How the Unified Audit Trail Captures Top-Level SQL Statements The ONLY TOPLEVEL clause has no impact on the output for an individual unified audit trail record.
## About Auditing Only Top-Level SQL Statements
A top-level statement is a statement that is executed directly by a user, not a statement that is run from within a PL/SQL procedure.
Consider auditing top-level statements from all users, including user `SYS` to reduce the volume of audit. The feature audits all the user-initiated actions and ignores the recursive SQL statements. For example, auditing the `DBMS_STATS.GATHER_DATABASE_STATS` SQL statement can generate over 200,000 individual audit records and by adding top-level this reduces to a single audit record.
## Configuring a Unified Audit Policy to Capture Only Top-Level Statements
The `ONLY TOPLEVEL` clause in the `CREATE AUDIT POLICY` statement enables you to audit only the SQL statements that are directly issued by an end user by honoring the audit configuration in the audit policy.
To find policies that include the `ONLY TOPLEVEL` clause, query the `AUDIT_ONLY_TOPLEVEL` column of the `AUDIT_UNIFIED_POLICIES` data dictionary view.
Use the following syntax to create a unified audit policy that audits only top-level SQL statements.
```
CREATE AUDIT POLICY policy_name all_existing_options ONLY TOPLEVEL;
```
For example, to limit the audit trail to top-level instances of the `SELECT` statement on the `HR.EMPLOYEES` table:
```
CREATE AUDIT POLICY actions_on_hr_emp_pol ACTIONS SELECT ON HR.EMPLOYEES ONLY TOPLEVEL;
```
## Example: Auditing Top-Level Statements
The `CREATE AUDIT POLICY` statement can include or exclude top-level statement audit records in the unified audit trail for any user.
The following example shows an audit policy that will capture all top level statements executed by user `SYS`.
Example 27-35 Example: Auditing Top-Level Statements Executed by User SYS
```
CREATE AUDIT POLICY actions_all_pol ACTIONS ALL ONLY TOPLEVEL;
AUDIT POLICY actions_all_pol BY SYS;
```
## Example: Comparison of Top-Level SQL Statement Audits
You can generate top-level SQL statement audit records from SQL statements that are run directly in SQL or from within a PL/SQL procedure.
This example shows how generating audit records differs when you access a view outside a PL/SQL procedure as opposed to accessing the view inside the PL/SQL procedure. The output illustrates the difference in volume in audit records that are generated from the two different audit policies.
````
``````
- Log in to the database instance as user SYS with the SYSDBA administrative privilege. In a multitenant environment, log in to the PDB. To find the available PDBs in a CDB, log in to the CDB root container and then query the PDB_NAME column of the DBA_PDBS data dictionary view. To check the current container, run the show con_name command.
```
CREATE OR REPLACE PROCEDURE proc1 AS cnt number;
BEGIN SELECT COUNT(*) INTO CNT FROM SYS.DBA_USERS WHERE USER_ID=9999;
END;
/
```
- Create the following procedure:
```
CREATE AUDIT POLICY toplevel_pol ACTIONS ALL ONLY TOPLEVEL;
AUDIT POLICY toplevel_pol;
```
- Create the and enable following audit policy to capture top-level actions:
````
```
SELECT /* TOPLEVEL */ COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=0000;
```
```
  COUNT(*)
----------
         1
```
- Execute the following query to generate an audit record and to access the SYS.DBA_USERS view outside of the proc1 procedure that you just created: The output should be as follows:
````
```
EXEC proc1;
```
- Execute the proc1 procedure that you created earlier, to access the SYS.DBA_USERS view again, but from within a procedure.
```
SELECT ACTION_NAME, OBJECT_SCHEMA,OBJECT_NAME,STATEMENT_ID,ENTRY_ID, UNIFIED_AUDIT_POLICIES,SQL_TEXT FROM UNIFIED_AUDIT_TRAIL ORDER BY EVENT_TIMESTAMP;
```
```
ACTION_NAME          OBJECT_SCHEMA
-------------------- ------------------------------
OBJECT_NAME                    STATEMENT_ID   ENTRY_ID
------------------------------ ------------ ----------
UNIFIED_AUDIT_POLICIES
------------------------------
SQL_TEXT
------------------------------------------------------------
LOGON 1          1 TOPLEVEL_POL COMMIT 3          2 TOPLEVEL_POL COMMIT 4          3 TOPLEVEL_POL SELECT               SYS USER$                                     5          4 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS RESOURCE_GROUP_MAPPING$                   5          5 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS TS$                                       5          6 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS TS$                                       5          7 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS TS$                                       5          8 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS PROFNAME$                                 5          9 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS USER_ASTATUS_MAP                          5         10 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS PROFILE$                                  5         11 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS PROFILE$                                  5         12 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS DBA_USERS                                 5         13 TOPLEVEL_POL select /* toplevel */ count(*) from sys.dba_users where user _id=0000 EXECUTE              SYS PROC1                                     7         14 TOPLEVEL_POL BEGIN proc1; END;
14 rows selected.
```
- Query the UNIFIED_AUDIT_TRAIL data dictionary view as follows: Output similar to the following appears:
```
NOAUDIT POLICY toplevel_pol;
DROP AUDIT POLICY toplevel_pol;
```
- Disable and then drop the toplevel_pol audit policy.
```
CREATE AUDIT POLICY recursive_pol ACTIONS ALL;
AUDIT POLICY recursive_pol;
```
- Create and enable a new audit policy to capture all actions.
```
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,FALSE);
```
- Clean up the audit trail.
````
```
SELECT /* TOPLEVEL */ COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=0000;
```
```
  COUNT(*)
----------
         1
```
- Execute the following query to generate an audit record and to access the SYS.DBA_USERS view outside of the proc1 procedure: The output should be as follows:
``````
```
EXEC proc1;
```
- Execute the proc1 procedure to access the SYS.DBA_USERS again, but from within the proc1 procedure.
```
SELECT ACTION_NAME, OBJECT_SCHEMA,OBJECT_NAME,STATEMENT_ID,ENTRY_ID, UNIFIED_AUDIT_POLICIES,SQL_TEXT FROM UNIFIED_AUDIT_TRAIL ORDER BY EVENT_TIMESTAMP;
```
```
ACTION_NAME          OBJECT_SCHEMA
-------------------- ------------------------------
OBJECT_NAME                    UNIFIED_AUDIT_POLICIES         STATEMENT_ID
------------------------------ ------------------------------ ------------
ENTRY_ID SQL_TEXT
---------- ------------------------------------------------------------
LOGON RECURSIVE_POL                             1 1 ALTER SESSION RECURSIVE_POL                             1 2 ALTER SESSION SET TIME_ZONE='-07:00' COMMIT RECURSIVE_POL                             3 3 COMMIT RECURSIVE_POL                             4 4 SELECT               SYS USER$                          RECURSIVE_POL                             5 5 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS RESOURCE_GROUP_MAPPING$        RECURSIVE_POL                             5 6 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS TS$                            RECURSIVE_POL                             5 7 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS TS$                            RECURSIVE_POL                             5 8 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS TS$                            RECURSIVE_POL                             5 9 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS PROFNAME$                      RECURSIVE_POL                             5 10 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS USER_ASTATUS_MAP               RECURSIVE_POL                             5 11 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS PROFILE$                       RECURSIVE_POL                             5 12 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS PROFILE$                       RECURSIVE_POL                             5 13 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS DBA_USERS                      RECURSIVE_POL                             5 14 select /* toplevel */ count(*) from sys.dba_users where user _id=0000 SELECT               SYS USER$                          RECURSIVE_POL                             7 15 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS RESOURCE_GROUP_MAPPING$        RECURSIVE_POL                             7 16 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS TS$                            RECURSIVE_POL                             7 17 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS TS$                            RECURSIVE_POL                             7 18 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS TS$                            RECURSIVE_POL                             7 19 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS PROFNAME$                      RECURSIVE_POL                             7 20 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS USER_ASTATUS_MAP               RECURSIVE_POL                             7 21 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS PROFILE$                       RECURSIVE_POL                             7 22 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS PROFILE$                       RECURSIVE_POL                             7 23 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 SELECT               SYS DBA_USERS                      RECURSIVE_POL                             7 24 SELECT COUNT(*) FROM SYS.DBA_USERS WHERE USER_ID=9999 EXECUTE              SYS PROC1                          RECURSIVE_POL                             7 25 BEGIN proc1; END;
25 rows selected.
```
- Query the UNIFIED_AUDIT_TRAIL data dictionary view as follows: Output similar to the following should appear: The output in this query generates 25 records, as opposed to the 14 that were generated earlier.
```
NOAUDIT POLICY recursive_pol;
DROP AUDIT POLICY recursive_pol;
```
- Disable and remove the recursive_pol policy.
## How the Unified Audit Trail Captures Top-Level SQL Statements
The `ONLY TOPLEVEL` clause has no impact on the output for an individual unified audit trail record.
The only effect that `ONLY TOPLEVEL` has on a policy is to limit the number of records generated for the given unified audit policy.
