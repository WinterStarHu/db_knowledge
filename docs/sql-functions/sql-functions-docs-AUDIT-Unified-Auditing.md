# AUDIT (Unified Auditing)

This section describes the `AUDIT` statement for **unified** **auditing**. This type of auditing is new beginning with Oracle Database 12*c* and provides a full set of enhanced auditing features. Refer to *Oracle Database Security Guide* for more information on unified auditing.
## Purpose
Use the `AUDIT` statement to:
- Enable a unified audit policy for all users or for specified users
- Specify whether an audit record is created if the audited event fails, succeeds, or both
- Specify application context attributes, whose values will be recorded in audit records
Operations performed with this statement take effect in subsequent user sessions, not in the current session.
**See Also:**
- NOAUDIT (Unified Auditing)
- CREATE AUDIT POLICY (Unified Auditing)
- ALTER AUDIT POLICY (Unified Auditing)
- DROP AUDIT POLICY (Unified Auditing)
## Prerequisites
You must have the `AUDIT` `SYSTEM` system privilege or the `AUDIT_ADMIN` role.
If you are connected to a multitenant container database (CDB), then to enable a common unified audit policy, the current container must be the root and you must have the commonly granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` common role. To enable a local unified audit policy, the current container must be the container in which the audit policy was created and you must have the commonly granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` common role, or you must have the locally granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` local role in the container.
To specify the `AUDIT` `CONTEXT` … statement when connected to a CDB, you must have the commonly granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` common role, or you must have the locally granted `AUDIT` `SYSTEM` privilege or the `AUDIT_ADMIN` local role in the current session’s container.
## Syntax
## *unified_audit*::=
Description of the illustration unified_audit.eps
## *by_users_with_roles*::=
Description of the illustration by_users_with_roles.eps
## Semantics
## *policy*
Specify the name of the unified audit policy to be enabled. The policy must have been created using the `CREATE` `AUDIT` `POLICY` statement.
You can find descriptions of all unified audit policies by querying the `AUDIT_UNIFIED_POLICIES` view and descriptions of all *enabled* unified audit policies by querying the `AUDIT_UNIFIED_ENABLED_POLICIES` view.
When you enable a unified audit policy, all SQL statements and operations that satisfy either a system privilege or action or role audit option specified in the enabled policy will be audited-that is, a unified audit record will be created in the `UNIFIED_AUDIT_TRAIL` view. If a single SQL statement or operation satisfies multiple enabled policies, then only one unified audit record will be created and all satisfied audit policy names will appear in a comma-separated list in the `UNIFIED_AUDIT_POLICIES` column of the `UNIFIED_AUDIT_TRAIL` view.
**See Also:**
- CREATE AUDIT POLICY (Unified Auditing)
**
- Oracle Database Reference for more information on the AUDIT_UNIFIED_POLICIES, AUDIT_UNIFIED_ENABLED_POLICIES, and UNIFIED_AUDIT_TRAIL views
## BY | EXCEPT
Specify the `BY` clause to enable *policy* for only the specified users.
Specify the `EXCEPT` clause to enable *policy* for all users except the specified users.
If you omit the `BY` and `EXCEPT` clauses and the *by_users_with_roles* clause, then Oracle Database enables *policy* for all users.
If *policy* is a common unified audit policy, then *user* must be a common user. If *policy* is a local unified audit policy, then *user* must be a common user or a local user in the container to which you are connected.
**Notes on the BY and EXCEPT Clauses** The following notes apply to the `BY` and `EXCEPT` clauses:
````
- If multiple AUDIT ... BY ... statements are specified for the same unified audit policy, then the policy is enabled for the union of the users specified in each statement.
````````
- If multiple AUDIT ... EXCEPT ... statements are specified for the same unified audit policy, then only the most recently specified statement takes effect. That is, the policy is enabled for all users except the users specified in the most recent AUDIT ... EXCEPT ... statement.
````````````
- If a policy is enabled using the BY clause and you would like to instead enable it using the EXCEPT clause, then you must first use the NOAUDIT ... BY ... statement to disable the policy for all users for whom the policy is currently enabled, and then enable the policy with the AUDIT ... EXCEPT ... statement.
``````````````
- If a policy is enabled using the EXCEPT clause and you would like to instead enable it using the BY clause, then you must first use the NOAUDIT statement to disable the audit policy. Note that you cannot specify the EXCEPT clause with the NOAUDIT statement. You can then enable the policy with the AUDIT ... BY ... statement.
**Restriction on the BY and EXCEPT Clauses** You cannot specify an `AUDIT` … `BY` … statement and an `AUDIT` … `EXCEPT` … statement for the same unified audit policy. If you attempt to do so, then an error occurs.
## *by_users_with_roles*
Specify this clause to enable *policy* for users who have been directly or indirectly granted the specified roles. If you subsequently grant one of the roles to an additional user or to a role which is directly or indirectly granted to a user, then the policy automatically applies to that user. If you subsequently revoke one of the roles from a user or from a role which was directly or indirectly granted to a role or a user, then the policy no longer applies to that user.
When you are connected to a CDB, if *policy* is a common unified audit policy, then *role* must be a common role. If *policy* is a local unified audit policy, then *role* must be a common role or a local role in the container to which you are connected.
**Enabling a Local Audit Policy on Roles** Local audit policy can be enabled on local roles as well as on common roles. When a local audit policy is enabled on a common role, it generates audit records when a common role is granted to user locally or commonly in the container.
**Enabling a Common Audit Policy on Roles** Common audit policy can only be enabled on common roles. When a common audit policy is enabled on a common role, it generates audit records when a common role is granted to an user commonly or locally in the ROOT container.
## WHENEVER [NOT] SUCCESSFUL
Specify `WHENEVER` `SUCCESSFUL` to audit only SQL statements and operations that succeed.
Specify `WHENEVER` `NOT` `SUCCESSFUL` to audit only SQL statements and operations that fail or result in errors.
If you omit this clause, then Oracle Database performs the audit regardless of success or failure.
## CONTEXT Clause
Specify the `CONTEXT` clause to include the values of context attributes in audit records.
**
- For namespace, specify the context namespace.
**
- For attribute, specify one or more context attributes whose values you want to include in audit records.
**
- Use the optional BY user clause to include the values of the context attributes only in audit records for events executed by the specified users. If you omit the BY clause, then the values of the context attributes are included in all audit records.
If you specify the `CONTEXT` clause when the current container is the root of a CDB, then the values of context attributes will be included in audit records only for events executed in the root. If you specify the optional `BY` clause, then *user* must be a common user.
If you specify the `CONTEXT` clause when the current container is a pluggable database (PDB), then the values of context attributes will be included in audit records only for events executed in that PDB. If you specify the optional `BY` clause, then *user* must be a common user or a local user in that PDB.
You can find the application context attributes that are configured to be captured in the audit trail by querying the `AUDIT_UNIFIED_CONTEXTS` view.
**See Also:**   *Oracle Database Reference* for more information on the `AUDIT_UNIFIED_CONTEXTS` view
## Examples
The following examples enable unified audit policies that were created in the `CREATE` `AUDIT` `POLICY` “Examples”.
**Enabling a Unified Audit Policy for All Users: Example** The following statement enables unified audit policy `table_pol` for all users:
```
AUDIT POLICY table_pol;
```
The following statement verifies that `table_pol` is enabled for all users:
```
SELECT policy_name, enabled_option, entity_name
  FROM audit_unified_enabled_policies
  WHERE policy_name = 'TABLE_POL';
POLICY_NAME  ENABLED_OPTION  ENTITY_NAME
-----------  -----------  ---------
TABLE_POL    BY           ALL USERS
```
**Enabling a Unified Audit Policy for Specific Users: Examples** The following statement enables unified audit policy `dml_pol` for only users `hr` and `sh`:
```
AUDIT POLICY dml_pol BY hr, sh;
```
The following statement verifies that `dml_pol` is enabled for only users `hr` and `sh`:
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
The following statement enables unified audit policy `read_dir_pol` for all users except `hr`:
```
AUDIT POLICY read_dir_pol EXCEPT hr;
```
The following statement verifies that `read_dir_pol` is enabled for all users except `hr`:
```
SELECT policy_name, enabled_option, entity_name
  FROM audit_unified_enabled_policies
  WHERE policy_name = 'READ_DIR_POL';
POLICY_NAME   ENABLED_OPTION  ENTITY_NAME
------------  -----------  ---------
READ_DIR_POL  EXCEPT       HR
```
The following statement enables unified audit policy `security_pol` for user `hr` and audits only the SQL statements and operations that fail:
```
AUDIT POLICY security_pol BY hr WHENEVER NOT SUCCESSFUL;
```
The following statement verifies that `security_pol` is enabled for only user `hr` and that only the SQL statements and operations that fail will be audited:
```
SELECT policy_name, enabled_option, entity_name, success, failure
  FROM audit_unified_enabled_policies
  WHERE policy_name = 'SECURITY_POL';
POLICY_NAME   ENABLED_OPTION           ENTITY_NAME   SUCCESS  FAILURE
------------  --------------------  ----------  -------  -------
SECURITY_POL  BY                    HR          NO       YES
```
**Including Values of Context Attributes in Audit Records: Example** The following statement instructs the database to include the values of namespace `USERENV` attributes `CURRENT_USER` and `DB_NAME` in all audit records for user `hr`:
```
AUDIT CONTEXT NAMESPACE userenv
  ATTRIBUTES current_user, db_name
  BY hr;
```
