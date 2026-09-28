# Enabling and Applying Unified Audit Policies to Users and Roles

You can use the `AUDIT POLICY` statement to enable and apply unified audit policies to users and roles.
````
- About Enabling Unified Audit Policies The AUDIT statement with the POLICY clause enables a unified audit policy, applying for all types of audit options, including object-level options.
- Enabling a Unified Audit Policy The AUDIT POLICY statement can enable a unified audit policy.
````
- Example: Enabling a Unified Audit Policy The AUDIT POLICY statement can enable a unified audit policy using conditions, such as WHENEVER NOT SUCCESSFUL.
## About Enabling Unified Audit Policies
The `AUDIT` statement with the `POLICY` clause enables a unified audit policy, applying for all types of audit options, including object-level options.
The policy does not take effect until after the audited users (or users who have been granted the roles associated with the policy) log into the database instance. In other words, if you create and enable a policy while the audited users are logged in, then the policy cannot collect audit data; the users must log out and then log in again before auditing can begin. Once the session is set up with auditing for it, then the setting lasts as long as the user session and then ends when the session ends.
You can enable the audit policy for individual users or for roles. Enabling the audit policy for roles allows you to enable the policy for a group of users who have been directly granted the role. When the role has been directly granted to a new user, then the policy automatically applies to the user. When the role is revoked from a user, then the policy no longer applies to the user.
You can check the results of the audit by querying the `UNIFIED_AUDIT_TRAIL` data dictionary view. To find a list of existing unified audit policies, query the `AUDIT_UNIFIED_POLICIES` data dictionary view.
The `AUDIT` statement lets you specify the following optional additional settings:
****``````````
- Whether to apply the unified audit policy to one or more users or roles.To apply the policy to one or more users or roles, including administrative users who log in with the SYSDBA administrative privilege (such as SYS), use the BY clause. For example, to apply the policy to users SYS and SYSTEM: For example, to apply the policy to two users:
```
AUDIT POLICY role_connect_audit_pol BY SYS, SYSTEM;
```
To apply a policy to users who have been directly granted the `DBA` and `CDB_DBA` roles:
```
AUDIT POLICY admin_audit_pol BY USERS WITH GRANTED ROLES DBA, CDB_DBA;
```
****
- Whether to exclude users from the unified audit policy. To exclude users from the audit policy, include the EXCEPT clause. For example:
```
AUDIT POLICY role_connect_audit_pol EXCEPT rlee, jrandolph;
```
****
  - WHENEVER SUCCESSFUL audits only successful executions of the user’s activity.
  - WHENEVER NOT SUCCESSFUL audits only failed executions of the user’s activity. Monitoring unsuccessful SQL statement can expose users who are snooping or acting maliciously, though most unsuccessful SQL statements are neither.
For example:
```
AUDIT POLICY role_connect_audit_pol WHENEVER NOT SUCCESSFUL;
```
If you omit this clause, then both failed and successful user activities are written to the audit trail.
Note the following:
``````
- The unified audit policy only can have either the BY, BY USERS WITH GRANTED ROLES, or the EXCEPT clause, but not more than one of these clauses for the same policy.
````
- If you run multiple AUDIT statements on the same unified audit policy but specify different BY users or different BY USERS WITH GRANTED ROLES roles, then Oracle Database audits all of these users or roles.
````````
- If you run multiple AUDIT statements on the same unified audit policy but specify different EXCEPT users, then Oracle Database uses the last exception user list, not any of the users from the preceding lists. This means the effect of the earlier AUDIT POLICY ... EXCEPT statements are overridden by the latest AUDIT POLICY ... EXCEPT statement.
- You cannot use the EXCEPT clause for roles. It applies to users only.
- You can only enable common unified audit policies for common users or roles.
- In a multitenant environment, you can enable a common audit policy only from the root and a local audit policy only from the PDB to which it applies.
## Enabling a Unified Audit Policy
The `AUDIT POLICY` statement can enable a unified audit policy.
  - Use the following syntax to enable a unified audit policy:
```
AUDIT POLICY { policy_auditing } [WHENEVER [NOT] SUCCESSFUL]
```
In this specification:
**
****````
  - The name of the unified audit policy. To find all existing policies, query the AUDIT_UNIFIED_POLICIES data dictionary view. To find currently enabled policies, query AUDIT_UNIFIED_ENABLED_POLICIES.
****````
  - Users or roles to whom the unified audit policy applies. To apply the policy to one or more users (including user SYS), enter the BY clause. For example:
```
BY psmith, rlee
```
```
To apply the policy to one or more users to whom the list of roles are directly granted, use the `BY USERS WITH GRANTED ROLES` clause. For example:
```
```
BY USERS WITH GRANTED ROLES HS_ADMIN_ROLE, HS_ADMIN_SELECT_ROLE
```
  ****- Users to exclude from the unified audit policy. To exclude one or more users from the policy, enter the EXCEPT clause. For example:
```
EXCEPT psmith, rlee
```
```
Mandatory audit records are captured in the `UNIFIED_AUDIT_TRAIL` data dictionary view for the `AUDIT POLICY` SQL statement. To find users who have been excluded in the audit records, you can query the `EXCLUDED_USER` column in the `UNIFIED_AUDIT_TRAIL` view to list the excluded users.
```
You cannot enable the same audit policy with the `BY`, `BY USERS WITH GRANTED ROLES`, and `EXCEPT` clauses in the same statement. This action throws an error for the subsequent `AUDIT` statement with the conflicting clause
  - WHENEVER [NOT] SUCCESSFUL enables the policy to generate audit records based on whether the user’s actions failed or succeeded. See About Enabling Unified Audit Policies for more information.
After you enable the unified audit policy and it is generating records, you can find the audit records by querying the `UNIFIED_AUDIT_TRAIL` data dictionary view.
## Example: Enabling a Unified Audit Policy
The `AUDIT POLICY` statement can enable a unified audit policy using conditions, such as `WHENEVER NOT SUCCESSFUL`.
Example 27-44 shows how to enable a unified audit policy to record only failed actions by the user `dv_admin`.
Example 27-44 Enabling a Unified Audit Policy
```
AUDIT POLICY dv_admin_pol BY tjones WHENEVER NOT SUCCESSFUL;
```
