# Disabling Unified Audit Policies

You can use the `NOAUDIT POLICY` statement to disable a unified audit policy.
````
- About Disabling Unified Audit Policies The NOAUDIT statement with the POLICY clause can disable a unified audit policy.
- Disabling a Unified Audit Policy The NOAUDIT statement can disable a unified audit policy using supported audit options.
- Example: Disabling a Unified Audit Policy The NOAUDIT POLICY statement disable a unified audit policy using filtering, such as by user name.
## About Disabling Unified Audit Policies
The `NOAUDIT` statement with the `POLICY` clause can disable a unified audit policy.
In the `NOAUDIT` statement, you can specify a `BY` user or `BY USERS WITH GRANTED ROLES` role list, but not an `EXCEPT` user list. The disablement of a unified audit policy takes effect on subsequent user sessions.
You can find a list of existing unified audit policies by querying the `AUDIT_UNIFIED_POLICIES` data dictionary view.
In a multitenant environment, you can disable a common audit policy only from the root and a local audit policy only from the PDB to which it applies.
## Disabling a Unified Audit Policy
The `NOAUDIT` statement can disable a unified audit policy using supported audit options.
  - Use the following syntax to disable a unified audit policy:
```
NOAUDIT POLICY {policy_auditing | existing_audit_options};
```
In this specification:
**````````
- policy_auditing is the name of the policy. To find all currently enabled policies, query the AUDIT_UNIFIED_ENABLED_POLICIES data dictionary view. As part of this specification, you optionally can include the BY or BY USERS WITH GRANTED ROLES clause, but not the EXCEPT clause. See About Enabling Unified Audit Policies for more information.
****
  - SELECT ANY TABLE, UPDATE ANY TABLE BY SCOTT, HR
  - UPDATE ON SCOTT.EMP
If the unified policy had been applied to all users, then you only need to specify the policy name. For example:
```
NOAUDIT POLICY logons_pol;
```
## Example: Disabling a Unified Audit Policy
The `NOAUDIT POLICY` statement disable a unified audit policy using filtering, such as by user name.
Example 27-45 shows examples of how to disable a unified audit policy for a user and for a role.
Example 27-45 Disabling a Unified Audit Policy
```
NOAUDIT POLICY dv_admin_pol BY tjones;
NOAUDIT POLICY dv_admin_pol BY USERS WITH GRANTED ROLES emp_admin;
```
