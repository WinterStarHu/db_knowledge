# Auditing Oracle Label Security Events

In an Oracle Label Security environment, the `CREATE AUDIT POLICY` statement can audit Oracle Label Security activities.
- About Auditing Oracle Label Security Events As with all unified auditing, you must have the AUDIT_ADMIN role before you can audit Oracle Label Security (OLS) events.
- Oracle Label Security Unified Audit Trail Events The unified audit trail can capture Oracle Label Security audit events.
- Oracle Label Security Auditable User Session Labels The ORA_OLS_SESSION_LABELS application context can capture user session label usage for each Oracle Database event.
``````
- Configuring a Unified Audit Policy for Oracle Label Security The ACTIONS and ACTIONS COMPONENT clauses in the CREATE AUDIT POLICY statement can be used to create Oracle Label Security event audit policies.
- Example: Auditing Oracle Label Security Session Label Attributes The AUDIT CONTEXT NAMESPACE statement can audit Oracle Label Security session label attributes.
- Example: Excluding a User from an Oracle Label Security Policy The CREATE AUDIT POLICY statement can exclude users from policies.
- Example: Auditing Oracle Label Security Policy Actions The CREATE AUDIT POLICY statement can audit Oracle Label Security policy actions.
- Example: Querying for Audited OLS Session Labels The LBACSYS.ORA_GET_AUDITED_LABEL function can be used in a UNIFIED_AUDIT_TRAIL query to find audited Oracle Label Security session labels.
- How Oracle Label Security Audit Events Appear in the Audit Trail The UNIFIED_AUDIT_TRAIL data dictionary view lists Oracle Label Security audit events.
## About Auditing Oracle Label Security Events
As with all unified auditing, you must have the `AUDIT_ADMIN` role before you can audit Oracle Label Security (OLS) events.
To create Oracle Label Security unified audit policies, you must set the `CREATE AUDIT POLICY` statement `COMPONENT` clause to `OLS`.
To audit user session label information, you use the `AUDIT` statement to audit application context values.
To access the audit trail, you can query the `UNIFIED_AUDIT_TRAIL` data dictionary view. This view contains Oracle Label Security-specific columns whose names begin with `OLS_`. If you want to find audit information about the internally generated VPD predicate that is created when you apply an Oracle Label Security policy to a table, then you can query the `RLS_INFO` column.
## Oracle Label Security Unified Audit Trail Events
The unified audit trail can capture Oracle Label Security audit events.
To find a list of auditable Oracle Label Security events that you can audit, you can query the `COMPONENT` and `NAME` columns of the `AUDITABLE_SYSTEM_ACTIONS` data dictionary view.
For example:
```
SELECT NAME FROM AUDITABLE_SYSTEM_ACTIONS WHERE COMPONENT = 'Label Security';
NAME
-------------
CREATE POLICY ALTER POLICY DROP POLICY ...
```
The following table describes the Oracle Label Security audit events.

| Audit Event | Description |
|---|---|
| CREATE POLICY | Creates an Oracle Label Security policy through the SA_SYSDBA.CREATE_POLICY procedure |
| ALTER POLICY | Alters an Oracle Label Security policy through the SA_SYSDBA.ALTER_POLICY procedure |
| DROP POLICY | Drops an Oracle Label Security policy through the SA_SYSDBA.DROP_POLICY procedure |
| APPLY POLICY | Applies a table policy through the SA_POLICY_ADMIN.APPLY_TABLE_POLICY procedure or a schema policy through the SA_POLICY_ADMIN.APPLY_SCHEMA_POLICY procedure |
| REMOVE POLICY | Removes a table policy through the SA_POLICY_ADMIN.REMOVE_TABLE_POLICY procedure or a schema policy through the SA_POLICY_ADMIN.REMOVE_SCHEMA_POLICY procedure |
| SET AUTHORIZATION | Covers all Oracle Label Security authorizations, including Oracle Label Security privileges and user labels to either users or trusted stored procedures. The PL/SQL procedures that correspond to the SET AUTHORIZATION event are SA_USER_ADMIN.SET_USER_LABELS, SA_USER_ADMIN.SET_USER_PRIVS, and SA_USER_ADMIN.SET_PROG_PRIVS. |
| PRIVILEGED ACTION | Covers any action that requires the user of an Oracle Label Security privilege. These actions are logons, SA_SESSION.SET_ACCESS_PROFILE executions, and the invocation of trusted stored procedures. |
| ENABLE POLICY | Enables an Oracle Label Security policy through the following procedures: SA_SYSDBA.ENABLE_POLICY - enforces access control on the tables and schemas protected by the policy, SA_POLICY_ADMIN.ENABLE_TABLE_POLICY - enables an Oracle Label Security policy for a specified table, and SA_POLICY_ADMIN.ENABLE_SCHEMA_POLICY- enables an Oracle Label Security policy for all the tables in a specified schema. |
| DISABLE POLICY | Disables an Oracle Label Security policy through the following procedures: SA_SYSDBA.DISABLE_POLICY - disables the enforcement of an Oracle Label Security policy, SA_POLICY_ADMIN.DISABLE_TABLE_POLICY - disables the enforcement an Oracle Label Security policy for a specified table, and SA_POLICY_ADMIN.DISABLE_SCHEMA_POLICY - disables the enforcement of an Oracle Label Security policy for all the tables in a specified schema. |
| SUBSCRIBE OID | Subscribes to an Oracle Internet Directory-enabled Oracle Label Security policy through the SA_POLICY_ADMIN.POLICY_SUBSCRIBE procedure |
| UNSUBSCRIBE OID | Unsubscribes to an Oracle Internet Directory-enabled Oracle Label Security policy through the SA_POLICY_ADMIN.POLICY_UNSUBSCRIBE procedure |
| CREATE DATA LABEL | Creates an Oracle Label Security data label through the SA_LABEL_ADMIN.CREATE_LABEL procedure. CREATE DATA LABEL also corresponds to the LBACSYS.TO_DATA_LABEL function. |
| ALTER DATA LABEL | Alters an Oracle Label Security data label through the SA_LABEL_ADMIN.ALTER_LABEL procedure |
| DROP DATA LABEL | Drops an Oracle Label Security data label through the SA_LABEL_ADMIN.DROP_LABEL procedure |
| CREATE LABEL COMPONENT | Creates an Oracle Label Security component through the following procedures: levels, SA_COMPONENTS.CREATE_LEVEL; compartments, SA_COMPONENTS.CREATE_COMPARTMENT; and groups, SA_COMPONENTS.CREATE_GROUP. |
| ALTER LABEL COMPONENTS | Alters an Oracle Label Security component through the following procedures: levels - SA_COMPONENTS.ALTER_LEVEL, compartments - SA_COMPONENTS.ALTER_COMPARTMENT, and groups - SA_COMPONENTS.ALTER_GROUP and SA_COMPONENTS.ALTER_GROUP_PARENT. |
| DROP LABEL COMPONENTS | Drops an Oracle Label Security component through the following procedures: levels - SA_COMPONENTS.DROP_LEVEL, compartments - SA_COMPONENTS.DROP_COMPARTMENT, and groups -SA_COMPONENTS.DROP_GROUP. |
| ALL | Enables auditing of all Oracle Label Security actions |

## Oracle Label Security Auditable User Session Labels
The `ORA_OLS_SESSION_LABELS` application context can capture user session label usage for each Oracle Database event.
The attributes used by this application context refer to Oracle Label Security policies. .
The syntax is the same as the syntax used for application context auditing, described in Configuring Application Context Audit Settings. For example:
```
AUDIT CONTEXT NAMESPACE ORA_SESSION_LABELS ATTRIBUTES policy1, policy2;
```
Because the recording of session labels is not user-session specific, the `BY` *user_list* clause is not required for auditing Oracle Label Security application contexts.
To disable the auditing of user session label information, you use the `NOAUDIT` statement. For example, to stop auditing for policies `policy1` and `policy2`, enter the following statement:
```
NOAUDIT CONTEXT NAMESPACE ORA_SESSION_LABELS ATTRIBUTES policy1, policy2;
```
## Configuring a Unified Audit Policy for Oracle Label Security
The `ACTIONS` and `ACTIONS COMPONENT` clauses in the `CREATE AUDIT POLICY` statement can be used to create Oracle Label Security event audit policies.
  - Use the following syntax to create an Oracle Label Security unified audit policy:
```
CREATE AUDIT POLICY policy_name ACTIONS action1 [,action2 ] ACTIONS COMPONENT=OLS component_action1 [, action2];
```
For example:
```
CREATE AUDIT POLICY audit_ols ACTIONS SELECT ON OE.ORDERS ACTIONS COMPONENT=OLS ALL;
```
You can build more complex policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing Oracle Label Security Session Label Attributes
The `AUDIT CONTEXT NAMESPACE` statement can audit Oracle Label Security session label attributes.
Example 27-26 shows how to audit `ORA_OLS_SESSION_LABELS` application context attributes for the Oracle Label Security policies `usr_pol1` and `usr_pol2`.
Example 27-26 Auditing Oracle Label Security Session Label Attributes
```
AUDIT CONTEXT NAMESPACE ORA_SESSION_LABELS ATTRIBUTES usr_pol1, usr_pol2;
```
## Example: Excluding a User from an Oracle Label Security Policy
The `CREATE AUDIT POLICY` statement can exclude users from policies.
Example 27-27 shows how to create a unified audit policy that excludes actions from user `ols_mgr`.
Example 27-27 Excluding a User from an Oracle Label Security Policy
```
CREATE AUDIT POLICY auth_ols_audit_pol ACTIONS SELECT ON HR.EMPLOYEES ACTIONS COMPONENT=OLS DROP POLICY, DISABLE POLICY;
AUDIT POLICY auth_ols_audit_pol EXCEPT ols_mgr;
```
## Example: Auditing Oracle Label Security Policy Actions
The `CREATE AUDIT POLICY` statement can audit Oracle Label Security policy actions.
Example 27-28 shows how to audit the `DROP POLICY`, `DISABLE POLICY`, `UNSUBSCRIBE OID` events, and `UPDATE` and `DELETE` statements on the `HR.EMPLOYEES` table. Then this policy is applied to the `HR` and `LBACSYS` users, and audit records are written to the unified audit trail only when the audited actions are successful.
Example 27-28 Auditing Oracle Label Security Policy Actions
```
CREATE AUDIT POLICY generic_audit_pol ACTIONS UPDATE ON HR.EMPLOYEES, DELETE ON HR.EMPLOYEES ACTIONS COMPONENT=OLS DROP POLICY, DISABLE POLICY, UNSUBSCRIBE OID;
AUDIT POLICY generic_audit_pol BY HR, LBACSYS WHENEVER SUCCESSFUL;
```
## Example: Querying for Audited OLS Session Labels
The `LBACSYS.ORA_GET_AUDITED_LABEL` function can be used in a UNIFIED_AUDIT_TRAIL query to find audited Oracle Label Security session labels.
Example 27-29 shows how to use the `LBACSYS.ORA_GET_AUDITED_LABEL` function in a `UNIFIED_AUDIT_TRAIL` data dictionary view query.
Example 27-29 Querying for Audited Oracle Label Security Session Labels
```
SELECT ENTRY_ID, SESSIONID, LBACSYS.ORA_GET_AUDITED_LABEL( APPLICATION_CONTEXTS,'GENERIC_AUDIT_POL1') AS  SESSION_LABEL1, LBACSYS.ORA_GET_AUDITED_LABEL( APPLICATION_CONTEXTS,'GENERIC_AUDIT_POL2') AS  SESSION_LABEL2 FROM UNIFIED_AUDIT_TRAIL;
/ ENTRY_ID  SESSIONID  SESSION_LABEL1  SESSION_LABEL2
--------  ---------  --------------  --------------
1       1023  SECRET          LEVEL_ALPHA 2       1024  TOP_SECRET      LEVEL_BETA
```
## How Oracle Label Security Audit Events Appear in the Audit Trail
The `UNIFIED_AUDIT_TRAIL` data dictionary view lists Oracle Label Security audit events.
The `OLS_`* columns of the `UNIFIED_AUDIT_TRAIL` view show Oracle Label Security-specific audit data. For example:
```
SELECT OLS_PRIVILEGES_USED FROM UNIFIED_AUDIT_TRAIL WHERE DBUSERNAME = 'psmith';
OLS_PRIVILEGES_USED
-------------------
READ WRITEUP WRITEACROSS
```
The session labels that the audit trail captures are stored in the `APPLICATION_CONTEXTS` column of the `UNIFIED_AUDIT_TRAIL` view. You can use the `LBACSYS.ORA_GET_AUDITED_LABEL` function to retrieve session labels that are stored in the `APPLICATION_CONTEXTS` column. This function accepts the `UNIFIED_AUDIT_TRAIL.APPLICATION_CONTEXTS` column value, and the Oracle Label Security policy name as arguments, and then returns the session label that is stored in the column for the specified policy.
## Related Topics
  - Auditing of Oracle Virtual Private Database Predicates for information about how to format the output of the RLS_INFO column
  **- Oracle Label Security Administrator’s Guide for more information about Oracle Label Security
  - Syntax for Creating a Unified Audit Policy
  **- Oracle Label Security Administrator’s Guide for more information about the ORA_GET_AUDITED_LABEL function
