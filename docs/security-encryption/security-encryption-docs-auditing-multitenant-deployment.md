# Unified Audit Policies or AUDIT Settings in a Multitenant Environment

In a multitenant environment, you can create unified audit policies for individual PDBs and in the root.
- About Local, CDB Common, and Application Common Audit Policies An audit policy can be either a local audit policy, a CDB common audit policy, or an application common audit policy.
````
- Traditional Auditing in a Multitenant Environment In traditional auditing (not unified auditing), the AUDIT and NOAUDIT statements can audit statements and privileges in a multitenant environment.
````
- Configuring a Local Unified Audit Policy or Common Unified Audit Policy The CONTAINER clause is specific to multitenant environment use for the CREATE AUDIT POLICY statement.
- Example: Local Unified Audit Policy The CREATE AUDIT POLICY statement can create a local unified audit policy in either the root or a PDB.
- Example: CDB Common Unified Audit Policy The CREATE AUDIT POLICY statement can create a CDB common unified audit policy.
- Example: Application Common Unified Audit Policy For application container common unified audit policies, you can audit action options and system privilege options, and refer to common objects and roles.
- How Local or Common Audit Policies or Settings Appear in the Audit Trail You can query unified audit policy views from either the root or the PDB in which the action occurred.
## About Local, CDB Common, and Application Common Audit Policies
An audit policy can be either a local audit policy, a CDB common audit policy, or an application common audit policy.
This applies to both unified audit policies and policies that are created using the `AUDIT` SQL statement.
****
- Local audit policy. This type of policy can exist in either the root (CDB or application) or the PDB (CDB or application). A local audit policy that exists in the root can contain object audit options for both local and common objects. Both local and common users who have been granted the AUDIT_ADMIN role can enable local policies: local users from their PDBs and common users from the root or the PDB to which they have privileges. You can enable a local audit policy for both local and common users and roles. You can create local audit policies for application local objects and application local roles, as well as system action options and system privilege options. You cannot enforce a local audit policy for a common user across all containers, nor can you enforce a common audit policy for a local user.
****
- CDB common audit policy. This type of policy is available to all PDBs in the multitenant environment. Only common users who have been granted the AUDIT_ADMIN role can create and maintain common audit policies. You can enable common audit policies only for common users. You must create common audit policies only in the root. This type of policy can contain object audit options of only common objects, and be enabled only for common users. You can enable a common audit policy for common users and roles only. You cannot enforce a common audit policy for a local user across all containers.
****````
- Application common audit policy. Similar to CDB common audit policies, this type of policy is available to all PDBs in the multitenant environment. You can create common audit policies for application common objects and application common roles, as well as system action options and system privilege options. You can only create this type of policy in the application root container, but you can enable it on both application common users and CDB common users. If you want to audit objects, then ensure that these objects are application common objects. You can determine whether an object is an application common object by querying the SHARING column of the DBA_OBJECTS data dictionary view.
By default, audit policies are local to the current PDB, for both CDB and application scenarios.
The following table explains how audit policies apply in different multitenant environments.

| Audit Option Type | CDB Root | Application Root | Individual PDB |
|---|---|---|---|
| Common audit statement or audit policy | Applies to CDB common users | Applies to CDB common users | Applies to CDB common users |
| Application container common audit statement or audit policy | Not applicable | Applies to CDB common users and are valid for the current application container only and to application container common users | Applies to CDB common users and are valid for this application container only and to application common users |
| Local audit statement or audit policy | Local configurations not allowed | Local configurations not allowed | Applies to CDB common users and to application common users |

## Traditional Auditing in a Multitenant Environment
In traditional auditing (not unified auditing), the `AUDIT` and `NOAUDIT` statements can audit statements and privileges in a multitenant environment.
To configure the audit policy to be either a local audit policy or a common audit policy, you must include the `CONTAINER` clause, as you normally do for other SQL creation or modification statements. If you want to audit an application container, then you can audit SQL statement and system privileges performed by local and common users and roles. The audit record will be created in the container in which the action was performed.
````````
```
AUDIT DROP ANY TABLE BY SYSTEM BY ACCESS CONTAINER = CURRENT;
```
- If you want to apply the AUDIT or NOAUDIT statement to the current CDB or application PDB, then in this PDB, you must set CONTAINER to CURRENT. For example:
````````
```
AUDIT DROP ANY TABLE BY SYSTEM BY ACCESS CONTAINER = ALL;
```
- If you want to apply the AUDIT or NOAUDIT statement to the entire multitenant environment, then in the CDB root, then you must set CONTAINER to ALL. For an application container, you would set it in the application root. For example:
To find if a traditional audit option is designed for use in an application container, perform a join query with the `DBA_OBJ_AUDIT_OPTS` and `DBA_OBJECTS` data dictionary views, by using the `OWNER` and `OBJECT_NAME` columns in both views, and the `APPLICATION` column in `DBA_OBJECTS`.
## Configuring a Local Unified Audit Policy or Common Unified Audit Policy
The `CONTAINER` clause is specific to multitenant environment use for the `CREATE AUDIT POLICY` statement.
To create a local or common (CDB or application) unified audit policy in either the CDB environment or an application container environment, include the `CONTAINER` clause in the `CREATE AUDIT POLICY` statement.
```
CREATE AUDIT POLICY policy_name
 action1 [,action2 ]
 [CONTAINER = {CURRENT | ALL}];
```
- Use the following syntax to create a local or common unified audit policy:
In this specification:
- CURRENT sets the audit policy to be local to the current PDB.
- ALL makes the audit policy a common audit policy, that is, available to the entire multitenant environment.
For example, for a common unified audit policy:
```
CREATE AUDIT POLICY dict_updates
 ACTIONS UPDATE ON SYS.USER$,
  DELETE ON SYS.USER$,
  UPDATE ON SYS.LINK$,
  DELETE ON SYS.LINK$
  CONTAINER = ALL;
```
Note the following:
````````
- You can set the CONTAINER clause for the CREATE AUDIT POLICY statement but not for ALTER AUDIT POLICY or DROP AUDIT POLICY. If you want to change the scope of an existing unified audit policy to use this setting, then you must drop and re-create the policy.
````**````
- For AUDIT statements, you can set the CONTAINER clause for audit settings only if you have an Oracle database that has not been migrated to the Release 12.x and later audit features. You cannot use the CONTAINER clause in an AUDIT statement that is used to enable a unified audit policy.
````````
- If you are in a PDB, then you can only set the CONTAINER clause to CURRENT, not ALL. If you omit the setting while in the PDB, then the default is CONTAINER = CURRENT.
``````````
- If you are in the root, then you can set the CONTAINER clause to either CURRENT if you want the policy to apply to the root only, or to ALL if you want the policy to apply to the entire CDB. If you omit the CONTAINER clause, then default is CONTAINER = CURRENT.
  - Common audit policies can have common objects only and local audit policies can have both local objects and common objects.
````
  - You cannot set CONTAINER to ALL if the objects involved are local. They must be common objects.
``````
  - You can set the CONTAINER to CURRENT (or omit the CONTAINER clause) if the user accounts involved are a mixture of local and common accounts. This creates a local audit configuration that applies only to the current PDB.
````
  - You cannot set CONTAINER to ALL if the users involved are local users. They must be common users.
````````
  - If you set CONTAINER to ALL and do not specify a user list (using the BY clause in the AUDIT statement), then the configuration applies to all common users in each PDB.
  - Create a common unified audit policy in the application container root, and set this policy to CONTAINER = ALL. Alternatively, you can include this policy in the script that is described in this next step.
  - Create a custom version of the script you normally would use to install, upgrade, patch, or uninstall Oracle Database.
```
ALTER PLUGGABLE DATABASE APPLICATION BEGIN INSTALL
List SQL statements here. Separate each statement with a semi-colon.
ALTER PLUGGABLE DATABASE APPLICATION END INSTALL
```
````
  - Within this script, include the SQL statements that you want to audit within the following lines: If you include the unified audit policy in the script, then ensure that you include both the CREATE AUDIT POLICY and AUDIT POLICY statements.
After the audit policy is created and enabled, all user access to the application common objects is audited irrespective of whether the audit policy is defined in the database or from the script.
```
ALTER PLUGGABLE DATABASE APPLICATION application_name SYNC;
```
- To audit application install, upgrade, patch, and uninstall operations locally in an application root or an application PDB, follow a procedure similar to the preceding procedure for common unified audit policies, but synchronize the application PDB afterward. For example:
## Example: Local Unified Audit Policy
The CREATE AUDIT POLICY statement can create a local unified audit policy in either the root or a PDB.
When you create a local unified audit policy in the root, it only applies to the root and not across the multitenant environment.
The following example shows a local unified audit policy that has been created by the common user `c##sec_admin` from a PDB and applied to common user `c##hr_admin`.
Example 27-36 Local Unified Audit Policy
```
CONNECT c##sec_admin@hrpdb Enter password: password Connected.
CREATE AUDIT POLICY table_privs PRIVILEGES CREATE ANY TABLE, DROP ANY TABLE CONTAINER = CURRENT;
AUDIT POLICY table_privs BY c##hr_admin;
```
## Example: CDB Common Unified Audit Policy
The CREATE AUDIT POLICY statement can create a CDB common unified audit policy.
Example 27-37 shows a common unified audit policy that has been created by the common user `c##sec_admin` from the root and applied to common user `c##hr_admin`.
Example 27-37 Common Unified Audit Policy
```
CONNECT c##sec_admin Enter password: password Connected.
CREATE AUDIT POLICY admin_pol ACTIONS CREATE TABLE, ALTER TABLE, DROP TABLE ROLES c##hr_mgr, c##hr_sup CONTAINER = ALL;
AUDIT POLICY admin_pol BY c##hr_admin;
```
## Example: Application Common Unified Audit Policy
For application container common unified audit policies, you can audit action options and system privilege options, and refer to common objects and roles.
You can create the application common audit policy only from the application root, and enable the policy for both application common users and CDB common users.
The following example shows how to create a policy that audits the application common user `SYSTEM` for the application container `app_pdb`. The audit policy audits `SELECT` actions on the `SYSTEM.utils_tab` table and on `DROP TABLE` actions on any of the PDBs in the container database, including the CDB root. The policy also audits the use of the `SELECT ANY TABLE` system privilege across all containers.
Example 27-38 Application Common Unified Audit Policy
```
CONNECT c##sec_admin@app_pdb Enter password: password Connected.
CREATE AUDIT POLICY app_pdb_admin_pol ACTIONS SELECT ON hr_app_cdb.utils_tab, DROP TABLE PRIVILEGES SELECT ANY TABLE CONTAINER = ALL;
AUDIT POLICY app_pdb_admin_pol by SYSTEM, c##hr_admin;
```
In the preceding example, setting `CONTAINER` to `ALL` applies the policy only to all the relevant object accesses in the application root and on all the application PDBs that belong to the application root. It does not apply the policy outside this scope.
## How Local or Common Audit Policies or Settings Appear in the Audit Trail
You can query unified audit policy views from either the root or the PDB in which the action occurred.
You can perform the following types of queries:
****``````````
- Audit records from all PDBs. The audit trail reflects audited actions that have been performed in the PDBs. For example, if user lbrown in PDB1 performs an action that has been audited by either a common or a local audit policy, then the audit trail will capture this action. The DBID column in the UNIFIED_AUDIT_TRAIL data dictionary view indicates the PDB in which the audited action takes place and to which the policy applies. If you want to see audit records from all PDBs, you should query the CDB_UNIFIED_AUDIT_TRAIL data dictionary view from the root.
****``````````
``````
- Audit records from common audit policies. This location is where the common audit policy results in an audit record. The audit record can be generated anywhere in the multitenant environment—the root or the PDBs, depending on where the action really occurred. For example, the common audit policy fga_pol audits the EXECUTE privilege on the DBMS_FGA PL/SQL package, and if this action occurs in PDB1, then the audit record is generated in PDB1 and not in the root. Hence, the audit record can be seen in PDB1. You can query the UNIFIED_AUDIT_TRAIL data dictionary view for the policy from either the root or a PDB if you include a WHERE clause for the policy name (for example, WHERE UNIFIED_AUDIT_POLICIES = 'FGA_POL').
The following example shows how to find the results of a common unified audit policy:
```
CONNECT c##sec_admin
Enter password: password
Connected.
SELECT DBID, ACTION_NAME, OBJECT_SCHEMA, OBJECT_NAME FROM CDB_UNIFIED_AUDIT_TRAIL WHERE DBUSERNAME = 'c##hr_admin';
46892-1
DBID        ACTION_NAME  OBJECT_SCHEMA  OBJECT_NAME
----------- -----------  -------------  -----------
653916017   UPDATE       HR             EMPLOYEES
653916018   UPDATE       HR             JOB_HISTORY
653916017   UPDATE       HR             JOBS
```
## Related Topics
**````- Oracle Database SQL Language Reference for more information about the traditional AUDIT and NOAUDIT SQL statements **- Oracle Multitenant Administrator’s Guide
