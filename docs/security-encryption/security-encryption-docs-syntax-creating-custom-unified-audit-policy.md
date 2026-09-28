# Syntax for Creating a Unified Audit Policy

To create a unified audit policy, you must use the `CREATE AUDIT POLICY` statement.
When you create a unified audit policy, Oracle Database stores it in a first class object that is owned by the `SYS` schema, not in the schema of the user who created the policy.
Example 27-1 shows the syntax for the `CREATE AUDIT POLICY` statement.
Example 27-1 Syntax for the CREATE AUDIT POLICY Statement
```
CREATE AUDIT POLICY policy_name
    { {privilege_audit_clause [action_audit_clause ] [role_audit_clause ]}

        | { action_audit_clause  [role_audit_clause ] }
        | { role_audit_clause }

     }
    [WHEN audit_condition EVALUATE PER {STATEMENT|SESSION|INSTANCE}]
    [ONLY TOPLEVEL]
    [CONTAINER = {CURRENT | ALL}];
```
In this specification:
**- privilege_audit_clause describes privilege-related audit options. See Auditing System Privileges for details. The detailed syntax for configuring privilege audit options is as follows:
```
privilege_audit_clause  :=  PRIVILEGES  privilege1 [, privilege2]
```
****- action_audit_clause and standard_actions describe object action-related audit options. See Auditing Object Actions. The syntax is as follows:
```
action_audit_clause := {standard_actions | component_actions}
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
**- component_actions enables you to create an audit policy for Oracle Label Security, Oracle Database Real Application Security, Oracle Database Vault, Oracle Data Pump, or Oracle SQL*Loader. See the appropriate section under Auditing Activities with Unified Audit Policies and the AUDIT Statement for more information. The syntax is:
```
component_actions :=
     ACTIONS COMPONENT=[OLS|XS] action1 [,action2 ] |
     ACTIONS COMPONENT=DV DV_action ON DV_object_name |
     ACTIONS COMPONENT=DATAPUMP [ EXPORT | IMPORT | ALL ] |
     ACTIONS COMPONENT=DIRECT_LOAD [ LOAD | ALL ]
```
**- role_audit_clause enables you to audit roles. See Auditing Roles. The syntax is:
```
role_audit_clause := ROLES role1 [, role2]
```
**``````- WHEN audit_condition EVALUATE PER enables you to specify a function to create a condition for the audit policy and the evaluation frequency. You must include the EVALUATE PER clause with the WHEN condition. See Creating a Condition for a Unified Audit Policy. The syntax is:
```
WHEN 'audit_condition := function operation value_list'
EVALUATE PER {STATEMENT|SESSION|INSTANCE}
```
- ONLY TOPLEVEL allows users to audit only the top-level operations that are performed for the actions that were configured as part of this audit policy. See Auditing Only Top-Level Statements.
``````
- CONTAINER, allows users to specify if the audit policy will apply to the current CDB or application PDB (CURRENT) or across the entire multitenant environment (ALL). See Unified Audit Policies or AUDIT Settings in a Multitenant Environment.
**Note:**  `CONTAINER=ALL` is only applicable to common objects and only common audit policies can be created to audit common objects.
This syntax is designed to audit any of the components listed in the policy. For example, suppose you create the following policy:
```
CREATE AUDIT POLICY table_pol PRIVILEGES CREATE ANY TABLE, DROP ANY TABLE ROLES emp_admin, sales_admin;
```
The audit trail will capture SQL statements that require the `CREATE ANY TABLE` system privilege or the `DROP ANY TABLE` system privilege or any system privilege directly granted to the role `emp_admin` or any system privilege directly granted to the role `sales_admin`. (Be aware that it audits privileges that are *directly* granted, not privileges that are granted recursively through a role.)
After you create the policy, you must enable it by using the `AUDIT` statement. Optionally, you can apply the policy to one or more users, exclude one or more users from the policy, and designate whether an audit record is written when the audited action succeeds, fails, or both succeeds or fails. See Enabling and Applying Unified Audit Policies to Users and Roles.
