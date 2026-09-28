# Auditing System Privileges

You can use the `CREATE AUDIT POLICY` statement to audit system privileges.
``````
- About System Privilege Auditing System privilege auditing audits activities that successfully use a system privilege, such as READ ANY TABLE.
- System Privileges That Can Be Audited You can audit the use of almost any system privilege.
- System Privileges That Cannot Be Audited Several system privileges cannot be audited.
````
- Configuring a Unified Audit Policy to Capture System Privilege Use The PRIVILEGES clause in the CREATE AUDIT POLICY statement audits system privilege use.
````
- Example: Auditing a User Who Has ANY Privileges The CREATE AUDIT POLICY statement can audit users for ANY privileges.
- Example: Using a Condition to Audit a System Privilege The CREATE AUDIT POLICY statement can create an audit policy that uses a condition to audit a system privilege.
- How System Privilege Unified Audit Policies Appear in the Audit Trail The UNIFIED_AUDIT_TRAIL data dictionary view lists system privilege audit events.
## About System Privilege Auditing
System privilege auditing audits activities that successfully use a system privilege, such as `READ` `ANY` `TABLE.`
In this kind of auditing, SQL statements that require the audited privilege to succeed are recorded.
A single unified audit policy can contain both privilege and action audit options. Do not audit the privilege use of administrative users such as `SYS`. Instead, audit their object actions.
Be aware that a single query can generate multiple audit records, one for each object that is being accessed in the query and if auditing is enabled on all these objects. For example, while you query the view, multiple audit records can be generated for each of the underlying objects that is referenced by the view itself.
**Note:**   You can audit system privileges, objects, database events, and so on. However, if you must find database privilege usage (for example, which privileges that have been granted to a given role are used), and generate a report of the used and unused privileges, then you can create a privilege capture.
## System Privileges That Can Be Audited
You can audit the use of almost any system privilege.
To find a list of auditable system privileges, you can query the `SYSTEM_PRIVILEGE_MAP` table.
For example:
```
SELECT NAME FROM SYSTEM_PRIVILEGE_MAP;
NAME
-------------
ALTER ANY CUBE BUILD PROCESS SELECT ANY CUBE BUILD PROCESS ALTER ANY MEASURE FOLDER ...
```
Similar to action audit options, privilege auditing audits the use of system privileges that have been granted to database users. If you set similar audit options for both SQL statement and privilege auditing, then only a single audit record is generated. For example, if two policies exist, with one auditing `EXECUTE PROCEDURE` specifically on the `HR.PROC` procedure and the second auditing `EXECUTE PROCEDURE` in general (all procedures), then only one audit record is written.
Privilege auditing does not occur if the action is already permitted by the existing owner and object privileges. Privilege auditing is triggered only if the privileges are insufficient, that is, only if what makes the action possible is a system privilege. For example, suppose that user `SCOTT` has been granted the `SELECT ANY TABLE` privilege and `SELECT ANY TABLE` is being audited. If `SCOTT` selects his own table (for example, `SCOTT.EMP`), then the `SELECT ANY TABLE` privilege is not used. Because he performed the `SELECT` statement within his own schema, no audit record is generated. On the other hand, if `SCOTT` selects from another schema (for example, the `HR.EMPLOYEES` table), then an audit record *is* generated. Because `SCOTT` selected a table outside his own schema, he needed to use the `SELECT ANY TABLE` privilege.
## System Privileges That Cannot Be Audited
Several system privileges cannot be audited.
These privileges are:
- INHERIT ANY PRIVILEGE
- INHERIT PRIVILEGE
- TRANSLATE ANY SQL
- TRANSLATE SQL
## Configuring a Unified Audit Policy to Capture System Privilege Use
The `PRIVILEGES` clause in the `CREATE AUDIT POLICY` statement audits system privilege use.
  - Use the following syntax to create a unified audit policy that audits privileges:
```
CREATE AUDIT POLICY policy_name PRIVILEGES privilege1 [, privilege2];
```
For example:
```
CREATE AUDIT POLICY my_simple_priv_policy PRIVILEGES SELECT ANY TABLE, CREATE LIBRARY;
```
You can build more complex privilege unified audit policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing a User Who Has ANY Privileges
The `CREATE AUDIT POLICY` statement can audit users for `ANY` privileges.
Example 27-3 shows how to audit several `ANY` privileges of the user `HR_MGR`.
Example 27-3 Auditing a User Who Has ANY Privileges
```
CREATE AUDIT POLICY hr_mgr_audit_pol PRIVILEGES DROP ANY TABLE, DROP ANY CONTEXT, DROP ANY INDEX, DROP ANY LIBRARY;
AUDIT POLICY hr_mgr_audit_pol BY HR_MGR;
```
## Example: Using a Condition to Audit a System Privilege
The `CREATE AUDIT POLICY` statement can create an audit policy that uses a condition to audit a system privilege.
Example 27-4 shows how to use a condition to audit privileges that are used by two operating system users, `psmith` and `jrawlins`.
Example 27-4 Using a Condition to Audit a System Privilege
```
CREATE AUDIT POLICY os_users_priv_pol PRIVILEGES SELECT ANY TABLE, CREATE LIBRARY WHEN 'SYS_CONTEXT (''USERENV'', ''OS_USER'') IN (''psmith'', ''jrawlins'')' EVALUATE PER SESSION;
AUDIT POLICY os_users_priv_pol;
```
## How System Privilege Unified Audit Policies Appear in the Audit Trail
The `UNIFIED_AUDIT_TRAIL` data dictionary view lists system privilege audit events.
The following example, based on the unified audit policy `os_users_priv_pol` that was created in Example 27-4, shows a list of privileges used by the operating system user `psmith`.
```
SELECT SYSTEM_PRIVILEGE_USED FROM UNIFIED_AUDIT_TRAIL WHERE OS_USERNAME = 'PSMITH' AND UNIFIED_AUDIT_POLICIES = 'OS_USERS_PRIV_POL';
SYSTEM_PRIVILEGE_USED
----------------------
SELECT ANY TABLE DROP ANY TABLE
```
**Note:**   If you have created an audit policy for the `SELECT ANY TABLE` system privilege, whether the user has exercised the `READ` object privilege or the `SELECT` object privilege will affect the actions that the audit trail captures.
## Related Topics
  - Auditing Object Actions
  - Performing Privilege Analysis to Identify Privilege Use
  - Syntax for Creating a Unified Audit Policy
  - Auditing the READ ANY TABLE and SELECT ANY TABLE Privileges
