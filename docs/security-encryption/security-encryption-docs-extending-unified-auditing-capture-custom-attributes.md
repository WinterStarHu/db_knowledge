# Auditing Application Context Values

You can use the `AUDIT` statement to audit application context values.
- About Auditing Application Context Values You can capture application context values in the unified audit trail.
````
- Configuring Application Context Audit Settings The AUDIT statement with the CONTEXT keyword configures auditing for application context values.
- Disabling Application Context Audit Settings The NOAUDIT statement disables application context audit settings.
- Example: Auditing Application Context Values in a Default Database The AUDIT CONTEXT NAMESPACE statement can audit application context values.
- Example: Auditing Application Context Values from Oracle Label Security The AUDIT CONTEXT NAMESPACE statement can audit application context values from Oracle Label Security.
- How Audited Application Contexts Appear in the Audit Trail The UNIFIED_AUDIT_POLICIES data dictionary view lists application context audit events.
## About Auditing Application Context Values
You can capture application context values in the unified audit trail.
This feature enables you to capture any application context values set by the database applications, while executing the audited statement.
If you plan to audit Oracle Label Security, then this feature captures session label activity for the database audit trail. The audit trail records all the values retrieved for the specified context-attribute value pairs.
The application context audit setting or the audit policy have session static semantics. In other words, if a new policy is enabled for a user, then the subsequent user sessions will see an effect of this command. After the session is established, then the policies and contexts settings are loaded and the subsequent `AUDIT` statements have no effect on that session.
For multitenant environments, the application context audit policy applies only to the current PDB.
## Configuring Application Context Audit Settings
The `AUDIT` statement with the `CONTEXT` keyword configures auditing for application context values.
You do not create an unified audit policy for this type of auditing.
  - Use the following syntax to configure auditing for application context values:
```
AUDIT CONTEXT NAMESPACE context_name1 ATTRIBUTES attribute1 [, attribute2] [, CONTEXT NAMESPACE context_name2 ATTRIBUTES attribute1 [, attribute2]] [BY user_list];
```
In this specification:
**
- context_name1: Optionally, you can include one additional CONTEXT name-attribute value pair.
**
- user_list is an optional list of database user accounts. Separate multiple names with a comma. If you omit this setting, then Oracle Database configures the application context policy for all users. When each user logs in, a list of all pertinent application contexts and their attributes is cached for the user session.
For example:
```
AUDIT CONTEXT NAMESPACE clientcontext3 ATTRIBUTES module, action, CONTEXT NAMESPACE ols_session_labels ATTRIBUTES ols_pol1, ols_pol3 BY appuser1, appuser2;
```
To find a list of currently configured application context audit settings, query the `AUDIT_UNIFIED_CONTEXTS` data dictionary view.
## Disabling Application Context Audit Settings
The `NOAUDIT` statement disables application context audit settings.
  ````- To disable an application context audit setting, specify the namespace and attribute settings in the NOAUDIT statement. You can enter the attributes in any order (that is, they do not need to match the order used in the corresponding AUDIT CONTEXT statement.)
For example:
```
NOAUDIT CONTEXT NAMESPACE client_context ATTRIBUTES module,
 CONTEXT NAMESPACE ols_session_labels ATTRIBUTES ols_pol1, ols_pol3
 BY USERS WITH GRANTED ROLES emp_admin;
```
To find the currently audited application contexts, query the `AUDIT_UNIFIED_CONTEXTS` data dictionary view.
## Example: Auditing Application Context Values in a Default Database
The `AUDIT CONTEXT NAMESPACE` statement can audit application context values.
Example 27-18 shows how to audit the `clientcontext` application values for the `module` and `action` attributes, by the user `appuser1`.
Example 27-18 Auditing Application Context Values in a Default Database
```
AUDIT CONTEXT NAMESPACE clientcontext ATTRIBUTES module, action
BY appuser1;
```
## Example: Auditing Application Context Values from Oracle Label Security
The `AUDIT CONTEXT NAMESPACE` statement can audit application context values from Oracle Label Security.
Example 27-19 shows how to audit an application context for Oracle Label Security called `ols_session_labels`, for the attributes `ols_pol1` and `ols_pol2`.
Example 27-19 Auditing Application Context Values from Oracle Label Security
```
AUDIT CONTEXT NAMESPACE ols_session_labels ATTRIBUTES ols_pol1, ols_pol2;
```
## How Audited Application Contexts Appear in the Audit Trail
The `UNIFIED_AUDIT_POLICIES` data dictionary view lists application context audit events.
The `APPLICATION_CONTEXTS` column of the `UNIFIED_AUDIT_TRAIL` data dictionary view shows application context audit data. The application contexts appear as a list of semi-colon separated values.
For example:
```
SELECT APPLICATION_CONTEXTS FROM UNIFIED_AUDIT_TRAIL
 WHERE UNIFIED_AUDIT_POLICIES = 'app_audit_pol';
APPLICATION_CONTEXTS
----------------------------------------------------------
CLIENT_CONTEXT.APPROLE=MANAGER;E2E_CONTEXT.USERNAME=PSMITH
```
## Related Topics
  - Using Application Contexts to Retrieve User Information, for detailed information about application contexts
  - Unified Audit Policies or AUDIT Settings in a Multitenant Environment
**- Oracle Label Security Administrator’s Guide for detailed information about Oracle Label Security
