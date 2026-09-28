# Tutorial: Auditing Nondatabase Users

This tutorial shows how to create a unified audit policy that uses a client identifier to audit a nondatabase user’s actions.
- Step 1: Create the User Accounts and Ensure the User OE Is Active You must first create users and ensure that the user OE is active.
- Step 2: Create the Unified Audit Policy Next, you are ready to create the unified audit policy.
````
- Step 3: Test the Policy To test the policy, use OE must try to select from the OE.ORDERS table.
- Step 4: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
## Step 1: Create the User Accounts and Ensure the User OE Is Active
You must first create users and ensure that the user `OE` is active.
  ````- Log on as user SYS with the SYSDBA administrative privilege.
```
sqlplus sys as sysdba
Enter password: password
```
- In a multitenant environment, connect to the appropriate PDB. For example:
```
CONNECT SYS@hrpdb AS SYSDBA
Enter password: password
```
```
To find the available PDBs, run the `show pdbs` command. To check the current PDB, run the `show con_name` command.
```
  - Create the local user policy_admin, who will create the fine-grained audit policy.
```
CREATE USER policy_admin IDENTIFIED BY password;
GRANT CREATE SESSION, AUDIT_ADMIN TO policy_admin;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
```
  - Create the local user account auditor, who will check the audit trail for this policy.
```
CREATE USER policy_auditor IDENTIFIED BY password;
GRANT CREATE SESSION, AUDIT_VIEWER TO policy_auditor;
```
  ``````- The sample user OE will also be used in this tutorial, so query the DBA_USERS data dictionary view to ensure that OE is not locked or expired.
```
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS WHERE USERNAME = 'OE';
```
```
The account status should be `OPEN`. If the `DBA_USERS` view lists user `OE` as locked and expired, log in as user `SYSTEM` and then enter the following statement to unlock the `OE` account and create a new password:
```
```
ALTER USER OE ACCOUNT UNLOCK IDENTIFIED BY password;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure. For greater security, do **not** give the `OE` account the same password from previous releases of Oracle Database.
```
## Step 2: Create the Unified Audit Policy
Next, you are ready to create the unified audit policy.
  - Connect to SQL*Plus as user policy_admin.
```
CONNECT policy_admin -- Or, CONNECT policy_admin@hrpdb Enter password: password
```
  - Create the following policy:
```
CREATE AUDIT POLICY orders_unified_audpol ACTIONS INSERT ON OE.ORDERS, UPDATE ON OE.ORDERS, DELETE ON OE.ORDERS, SELECT ON OE.ORDERS WHEN 'SYS_CONTEXT(''USERENV'', ''CLIENT_IDENTIFIER'') = ''robert''' EVALUATE PER STATEMENT;
AUDIT POLICY orders_unified_audpol;
```
```
In this example, the `AUDIT_CONDITION` parameter assumes that the nondatabase user is named `robert`. The policy will monitor any `INSERT`, `UPDATE`, `DELETE`, and `SELECT` statements that `robert` will attempt. Remember that the user's `CLIENT_IDENTITIFER` setting that you enter in the policy is case sensitive and that the policy only recognizes the case used for the identity that you specify here. In other words, later on, if the user session is set to `Robert` or `ROBERT`, the policy's condition will not be satisfied.
```
## Step 3: Test the Policy
To test the policy, use `OE` must try to select from the `OE.ORDERS` table.
A unified auditing policy takes effect in the next user session for the users who are being audited. So, before their audit records can be captured, the users must connect to the database *after* the policy has been created.
  ````- Connect as user OE and select from the OE.ORDERS table.
```
CONNECT OE -- Or, CONNECT OE@hrpdb
Enter password: password
SELECT COUNT(*) FROM ORDERS;
```
```
The following output appears:
```
```
  COUNT(*)
----------
       105
```
  - Connect as user policy_auditor and then check if any audit records were generated.
```
CONNECT policy_auditor -- Or, CONNECT policy_auditor@hrpdb
Enter password: password
col dbusername format a10
col client_identifier format a20
col sql_text format a29
SELECT DBUSERNAME, CLIENT_IDENTIFIER, SQL_TEXT FROM UNIFIED_AUDIT_TRAIL
 WHERE SQL_TEXT LIKE '%FROM ORDERS%';
```
```
The following output appears:
```
```
no rows selected
```
  ``````- Reconnect as user OE, set the client identifier to robert, and then reselect from the OE.ORDERS table.
```
CONNECT OE -- Or, CONNECT OE@hrpdb Enter password: password EXEC DBMS_SESSION.SET_IDENTIFIER('robert');
SELECT COUNT(*) FROM ORDERS;
```
```
The following output should appear:
```
```
COUNT(*)
----------
105
```
  - Reconnect as user auditor and then check the audit trail again.
```
CONNECT policy_auditor -- Or, CONNECT policy_auditor@hrpdb Enter password: password SELECT DBUSERNAME, CLIENT_IDENTIFIER, SQL_TEXT FROM UNIFIED_AUDIT_TRAIL WHERE SQL_TEXT LIKE '%FROM ORDERS%';
```
```
This time, because `robert` has made his appearance and queried the `OE.ORDERS` table, the audit trail captures his actions:
```
```
DBUSERNAME CLIENT_IDENTIFIER SQL_TEXT
---------- ----------------- ----------------------------
OE         robert            SELECT COUNT(*) FROM ORDERS;
```
## Step 4: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  ````- Connect to SQL*Plus as user policy_admin, and then manually disable and drop the orders_unified_audpol policy.
```
CONNECT policy_admin -- Or, CONNECT policy_admin@hrpdb
Enter password: password
NOAUDIT POLICY orders_unified_audpol;
DROP AUDIT policy orders_unified_audpol;
```
```
(Unified audit policies reside in the `SYS` schema, not the schema of the user who created them.)
```
  - Connect to SQL*Plus as user SYSTEM.
```
CONNECT SYSTEM -- Or, CONNECT SYSTEM@hrpdb
Enter password: password
```
  ````- Drop users policy_admin and policy_auditor.
```
DROP USER policy_admin;
DROP USER policy_auditor;
```
  - If you want, lock and expire OE, unless other users want to use this account:
```
ALTER USER OE PASSWORD EXPIRE ACCOUNT LOCK;
```
