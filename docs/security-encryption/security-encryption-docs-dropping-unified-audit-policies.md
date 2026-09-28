# Dropping Unified Audit Policies

You can use the `DROP AUDIT POLICY` statement to drop a unified audit policy.
- About Dropping Unified Audit Policies The DROP AUDIT POLICY statement can be used to unified audit policies.
- Dropping a Unified Audit Policy To drop a unified audit policy, you must first disable it, and then run the DROP AUDIT POLICY statement to remove it.
````
- Example: Disabling and Dropping a Unified Audit Policy The NOAUDIT POLICY and DROP AUDIT POLICY statements can disable and drop a unified audit policy.
## About Dropping Unified Audit Policies
The `DROP AUDIT POLICY` statement can be used to unified audit policies.
If a unified audit policy is already enabled for a session, the effect of dropping the policy is not seen by this existing session. Until that time, the unified audit policy’s settings remain in effect. For object-related unified audit policies, however, the effect is immediate.
You can find a list of existing unified audit policies by querying the `AUDIT_UNIFIED_POLICIES` data dictionary view.
When you disable an audit policy before dropping it, ensure that you disable it using the same settings that you used to enable it. For example, suppose you enabled the `logon_pol` policy as follows:
```
AUDIT POLICY logon_pol BY HR, OE;
```
Before you can drop it, your `NOAUDIT` statement must include the `HR` and `OE` users as follows:
```
NOAUDIT POLICY logon_pol BY HR, OE;
```
In a multitenant environment, you can drop a common audit policy only from the root and a local audit policy only from the PDB to which it applies.
## Dropping a Unified Audit Policy
To drop a unified audit policy, you must first disable it, and then run the `DROP AUDIT POLICY` statement to remove it.
  - Use the following the following syntax to drop a unified audit policy:
```
DROP AUDIT POLICY policy_name;
```
In a multitenant environment, the unified audit policy drop applies to the current PDB. If the unified audit policy was created as a common unified audit policy, then you cannot drop it from the local PDB.
## Example: Disabling and Dropping a Unified Audit Policy
The `NOAUDIT POLICY` and `DROP AUDIT POLICY` statements can disable and drop a unified audit policy.
Example 27-46 shows how to disable and drop a common unified audit policy.
Example 27-46 Disabling and Dropping a Unified Audit Policy
```
CONNECT c##sec_admin Enter password: password Connected.
NOAUDIT POLICY dv_admin_pol;
DROP AUDIT POLICY dv_admin_pol
```
## Related Topics
  - Unified Audit Policies or AUDIT Settings in a Multitenant Environment
