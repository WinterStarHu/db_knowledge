# Auditing Roles

You can use the `CREATE AUDIT POLICY` statement to audit database roles.
- About Role Auditing When you audit a role, Oracle Database audits all system privileges that are directly granted to the role.
````
- Configuring Role Unified Audit Policies To create a unified audit policy to capture role use, you must include the ROLES clause in the CREATE AUDIT POLICY statement.
- Example: Auditing the DBA Role in a Multitenant Environment The CREATE AUDIT POLICY statement can audit roles in a multitenant environment.
## About Role Auditing
When you audit a role, Oracle Database audits all system privileges that are directly granted to the role.
You can audit any role, including user-defined roles. If you create a common unified audit policy for roles with the `ROLES` audit option, then you must specify only common roles in the role list. When such a policy is enabled, Oracle Database audits all system privileges that are commonly and directly granted to the common role. The system privileges that are locally granted to the common role will not be audited. To find if a role was commonly granted, query the `DBA_ROLES` data dictionary view. To find if the privileges granted to the role were commonly granted, query the `ROLE_SYS_PRIVS` view.
## Configuring Role Unified Audit Policies
To create a unified audit policy to capture role use, you must include the `ROLES` clause in the `CREATE AUDIT POLICY` statement.
  - Use the following syntax to create a unified audit policy that audits roles:
```
CREATE AUDIT POLICY policy_name ROLES role1 [, role2];
```
For example:
```
CREATE AUDIT POLICY audit_roles_pol ROLES IMP_FULL_DATABASE, EXP_FULL_DATABASE;
```
You can build more complex role unified audit policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing the DBA Role in a Multitenant Environment
The `CREATE AUDIT POLICY` statement can audit roles in a multitenant environment.
The following example shows how to audit a predefined common role `DBA` in a multitenant environment.
Example 27-2 Auditing the DBA Role in a Multitenant Environment
```
CREATE AUDIT POLICY role_dba_audit_pol ROLES DBA CONTAINER = ALL;
AUDIT POLICY role_dba_audit_pol;
```
## Related Topics
  - Predefined Roles in an Oracle Database Installation
  - Syntax for Creating a Unified Audit Policy
