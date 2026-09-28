# Altering Unified Audit Policies

You can use the `ALTER AUDIT POLICY` statement to modify a unified audit policy.
- About Altering Unified Audit Policies You can change most properties in a unified audit policy, except for its CONTAINER setting.
- Altering a Unified Audit Policy The ALTER AUDIT POLICY statement can modify a unified audit policy.
- Example: Altering a Condition in a Unified Audit Policy The ALTER AUDIT POLICY statement can alter conditions in unified audit policies.
- Example: Altering an Oracle Label Security Component in a Unified Audit Policy The ALTER AUDIT POLICY statement can alter Oracle Label Security components in an audit policy.
- Example: Altering Roles in a Unified Audit Policy The ALTER AUDIT POLICY statement can alter roles in a unified audit policy.
- Example: Dropping a Condition from a Unified Audit Policy The ALTER AUDIT POLICY statement can drop a condition from a unified audit policy.
- Example: Altering an Existing Unified Audit Policy Top-Level Statement Audits The ALTER AUDIT POLICY statement can modify an existing unified audit policy so that the unified audit trail captures top-level SQL statements only.
## About Altering Unified Audit Policies
You can change most properties in a unified audit policy, except for its `CONTAINER` setting.
You cannot alter unified audit policies in a multitenant environment. For example, you cannot turn a common unified audit policy into a local unified audit policy.
To find existing unified audit policies, query the `AUDIT_UNIFIED_POLICIES` data dictionary view. If you want to find only the enabled unified audit policies, then query the `AUDIT_UNIFIED_ENABLED_POLICIES` view. You can alter both enabled and disabled audit policies. If you alter an enabled audit policy, it remains enabled after you alter it.
After you alter an object unified audit policy, the new audit settings take place immediately, for both the active and subsequent user sessions. If you alter system audit options, or audit conditions of the policy, then they are activated for new user sessions, but not the current user session.
## Altering a Unified Audit Policy
The `ALTER AUDIT POLICY` statement can modify a unified audit policy.
  - Use the following syntax to alter a unified audit policy, you use the ALTER AUDIT POLICY statement.
```
ALTER AUDIT POLICY  policy_name
[ADD [privilege_audit_clause][action_audit_clause]
  [role_audit_clause] [ONLY TOPLEVEL] ]
[DROP [privilege_audit_clause][action_audit_clause]
    [role_audit_clause] [ONLY TOPLEVEL]]
[CONDITION {DROP | audit_condition EVALUATE PER {STATEMENT|SESSION|INSTANCE}}]
```
In this specification:
**  - privilege_audit_clause describes privilege-related audit options. See Auditing System Privileges for details. The detailed syntax for configuring privilege audit options is as follows:
```
ADD privilege_audit_clause  :=  PRIVILEGES  privilege1 [, privilege2]
```
****- action_audit_clause and standard_actions describe object action-related audit options. See Auditing Object Actions. The syntax is as follows:
```
ADD action_audit_clause := {standard_actions | component_actions}
                                         [, component_actions ]
standard_actions :=
     ACTIONS action1 [ ON {schema.obj_name

                                          | DIRECTORY directory_name
                                          | MINING MODEL schema.obj_name

                                           }
                ]
           [, action2 [ ON {schema.obj_name

                                          | DIRECTORY directory_name
                                          | MINING MODEL schema.obj_name

                   }
                ]
```
**- role_audit_clause enables you to add or drop the policy for roles. See Auditing Roles. The syntax is:
```
ADD role_audit_clause := ROLES role1 [, role2]
```
- ONLY TOPLEVEL includes in the unified audit trail only the top-level SQL statements that are affected by this policy.
````
- DROP enables you to drop the same components that are described for the ADD clause. For example:
```
DROP role_audit_clause := ROLES role1 [, role2 ONLY TOPLEVEl]
```
  ````- CONDITION {DROP... enables you to add or drop a condition for the policy. If you are altering an existing condition, then you must include the EVALUATE PER clause with the condition. See Creating a Condition for a Unified Audit Policy. The syntax is:
```
CONDITION 'audit_condition := function operation value_list'
EVALUATE PER {STATEMENT|SESSION|INSTANCE}
```
If you want to drop a condition, then omit the condition definition and the `EVALUATE PER` clause. For example:
```
CONDITION DROP
```
## Example: Altering a Condition in a Unified Audit Policy
The `ALTER AUDIT POLICY` statement can alter conditions in unified audit policies.
Example 27-39 shows how to change a condition in an existing unified audit policy.
Example 27-39 Altering a Condition in a Unified Audit Policy
```
ALTER AUDIT POLICY orders_unified_audpol
 ADD ACTIONS INSERT ON SCOTT.EMP
CONDITION 'SYS_CONTEXT(''ENTERPRISE'', ''GROUP'') =  ''ACCESS_MANAGER'''
EVALUATE PER SESSION;
```
## Example: Altering an Oracle Label Security Component in a Unified Audit Policy
The `ALTER AUDIT POLICY` statement can alter Oracle Label Security components in an audit policy.
Example 27-40 shows how to alter an Oracle Label Security component in an audit policy.
Example 27-40 Altering an Oracle Label Security Component in a Unified Audit Policy
```
ALTER AUDIT POLICY audit_ols
 ADD ACTIONS SELECT ON HR.EMPLOYEES
 ACTIONS COMPONENT=OLS DROP POLICY, DISABLE POLICY, REMOVE POLICY;
```
## Example: Altering Roles in a Unified Audit Policy
The `ALTER AUDIT POLICY` statement can alter roles in a unified audit policy.
Example 27-41 shows how to add roles to a common unified audit policy.
Example 27-41 Altering Roles in a Unified Audit Policy
```
CONNECT c##sec_admin
Enter password: password
Connected.
ALTER AUDIT POLICY RoleConnectAudit
 ADD ROLES c##role1, c##role2;
```
## Example: Dropping a Condition from a Unified Audit Policy
The `ALTER AUDIT POLICY` statement can drop a condition from a unified audit policy.
Example 27-42 shows how to drop a condition from an existing unified audit policy.
Example 27-42 Dropping a Condition from a Unified Audit Policy
```
ALTER AUDIT POLICY orders_unified_audpol
CONDITION DROP;
```
## Example: Altering an Existing Unified Audit Policy Top-Level Statement Audits
The `ALTER AUDIT POLICY` statement can modify an existing unified audit policy so that the unified audit trail captures top-level SQL statements only.
The following example shows how to modify the `orders_unified_audpol` policy to capture only top-level SQL statements.
Example 27-43 Altering an Existing Unified Audit Policy to Audit for Top-Level Statements
```
ALTER AUDIT POLICY orders_unified_audpol ADD ONLY TOPLEVEL;
```
Similarly, to remove the top-level SQL statement audit, use the `DROP` clause:
```
ALTER AUDIT POLICY orders_unified_audpol DROP ONLY TOPLEVEL;
```
