# NOAUDIT (Unified Auditing)

This section describes the `NOAUDIT` statement for **unified** **auditing**. This type of auditing is new beginning with Oracle Database 12*c* and provides a full set of enhanced auditing features. Refer to *Oracle Database Security Guide* for more information on unified auditing.
## Purpose
Use the `NOAUDIT` statement to:
- Disable a unified audit policy for all users or for specified users
- Exclude the values of context attributes from audit records
Operations performed with this statement take effect in subsequent user sessions, not in the current session.
**See Also:**
- AUDIT (Unified Auditing)
- CREATE AUDIT POLICY (Unified Auditing)
- ALTER AUDIT POLICY (Unified Auditing)
- DROP AUDIT POLICY (Unified Auditing)
## Prerequisites
You must have the `AUDIT` `SYSTEM` system privilege or the `AUDIT_ADMIN` role.
If you are connected to a multitenant container database (CDB), then to disable a common unified audit policy, the current container must be the root and you must have the commonly granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` common role. To disable a local unified audit policy, the current container must be the container in which the audit policy was created and you must have the commonly granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` common role, or you must have the locally granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` local role in the container.
To specify the `NOAUDIT` `CONTEXT` … statement when connected to a CDB, you must have the commonly granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` common role, or you must have the locally granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` local role in the current session’s container.
## Syntax
## *unified_noaudit*::=
Description of the illustration unified_noaudit.eps
## *by_users_with_roles*::=
Description of the illustration by_users_with_roles.eps
## Semantics
## *policy*
Specify the name of the unified audit policy you want to disable.
You can find descriptions of all unified audit policies by querying the `AUDIT_UNIFIED_POLICIES` view and descriptions of all *enabled* unified audit policies by querying the `AUDIT_UNIFIED_ENABLED_POLICIES` view.
**See Also:**   *Oracle Database Reference* for more information on the `AUDIT_UNIFIED_POLICIES` and `AUDIT_UNIFIED_ENABLED_POLICIES` views
## CONTEXT Clause
Specify the `CONTEXT` clause to exclude the values of context attributes in audit records.
**
- For namespace, specify the context namespace.
**
- For attribute, specify one or more context attributes whose values you want to exclude from audit records.
If you specify the `CONTEXT` clause when the current container is the root of a CDB, then the values of context attributes will be included in audit records only for events executed in the root. If you specify the optional `BY` clause, then *user* must be a common user.
If you specify the `CONTEXT` clause when the current container is a pluggable database (PDB), then the values of context attributes will be included in audit records only for events executed in that PDB. If you specify the optional `BY` clause, then *user* must be a common user or a local user in that PDB.
You can find the application context attributes that are configured to be captured in the audit trail by querying the `AUDIT_UNIFIED_CONTEXTS` view.
**See Also:**   *Oracle Database Reference* for more information on the `AUDIT_UNIFIED_CONTEXTS` view
## BY
You can specify the `BY` clause for the `NOAUDIT` `POLICY` and `NOAUDIT` `CONTEXT` statements.
## NOAUDIT POLICY … BY
The behavior of the `BY` clause depends on whether *policy* is enabled for all users or specific users.
****````````
- If policy is enabled for all users, then you can disable policy for all users by omitting the BY clause. If you specify the BY clause, then the NOAUDIT POLICY statement will have no effect.
**`````` ****
  - Disable policy for one or more of those users by specifying the BY clause followed by the users for whom you want policy disabled
****
  - Completely disable policy by specifying the BY clause followed by all of the users for whom policy is enabled
If you do not specify the `BY` clause, then the `NOAUDIT` `POLICY` statement will have no effect.
**``````**````````
- If policy is enabled for all users except specific users (using the AUDIT POLICY ... EXCEPT ... statement), then you can disable policy for all users by omitting the BY clause. If you specify the BY clause, then the NOAUDIT POLICY statement will have no effect.
If *policy* is a common unified audit policy, then *user* must be a common user. If *policy* is a local unified audit policy, then *user* must be a common user or a local user in the container to which you are connected.
## NOAUDIT CONTEXT … BY
The behavior of the `BY` clause depends on whether *attribute* is configured to be included in audit records for all users or specific users.
****````````
- If attribute is configured to be included in audit records for all users, then you can exclude attribute from audit records for all users by omitting the BY clause. If you specify the BY clause, then the NOAUDIT CONTEXT statement will have no effect.
******``````
- If attribute is configured to be included in audit records for specific users, then you can exclude attribute for one or more of those users by specifying the BY clause followed by the users for whom you want attribute excluded. If you do not specify the BY clause, then the NOAUDIT CONTEXT statement will have no effect.
## *by_users_with_roles*
Specify this clause to disable *policy* only for users who have been directly granted the specified roles. If you subsequently grant one of the roles to an additional user, then the policy is automatically disabled for that user.
When you are connected to a CDB, if *policy* is a common unified audit policy, then *role* must be a common role. If *policy* is a local unified audit policy, then role must be a common role or a local role in the container to which you are connected.
## Examples
The following examples disable unified audit policies that were created in the `CREATE` `AUDIT` `POLICY` “Examples” and enabled in the `AUDIT` “Examples”.
**Disabling a Unified Audit Policy for All Users: Example** Assume that unified audit policy `table_pol` is enabled for all users. The following statement disables `table_pol` for all users:
```
NOAUDIT POLICY table_pol;
```
The following statement returns no rows, which verifies that `table_pol` is disabled for all users:
```
SELECT *
  FROM audit_unified_enabled_policies
  WHERE policy_name = 'TABLE_POL';
```
**Disabling a Unified Audit Policy for Specific Users: Example** Assume that unified audit policy `dml_pol` is enabled for users `hr` and `sh`, as shown by the following query:
```
SELECT policy_name, enabled_option, entity_name
  FROM audit_unified_enabled_policies
  WHERE policy_name = 'DML_POL'
  ORDER BY entity_name;
POLICY_NAME  ENABLED_OPTION  ENTITY_NAME
-----------  -----------  ---------
DML_POL      BY           HR
DML_POL      BY           SH
```
The following statement disables `dml_pol` for user `hr`:
```
NOAUDIT POLICY dml_pol BY hr;
```
The following statement verifies that `dml_pol` is now enabled for only user `sh`:
```
SELECT policy_name, enabled_option, entity_name
  FROM audit_unified_enabled_policies
  WHERE policy_name = 'DML_POL';
POLICY_NAME  ENABLED_OPTION  ENTITY_NAME
-----------  -----------  ---------
DML_POL      BY           SH
```
The following statement disables `dml_pol` for user `sh`:
```
NOAUDIT POLICY dml_pol BY sh;
```
The following statement returns no rows, which verifies that `dml_pol` is disabled for all users:
```
SELECT *
  FROM audit_unified_enabled_policies
  WHERE policy_name = 'DML_POL';
```
**Excluding Values of Context Attributes in Audit Records: Example** The following statement instructs the database to exclude the values of namespace `USERENV` attributes `CURRENT_USER` and `DB_NAME` from all audit records for user `hr`:
```
NOAUDIT CONTEXT NAMESPACE userenv
  ATTRIBUTES current_user, db_name
  BY hr;
```
