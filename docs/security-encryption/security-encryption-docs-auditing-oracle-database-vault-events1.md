# Auditing Oracle Database Vault Events

In an Oracle Database Vault environment, the `CREATE AUDIT POLICY` statement can audit Database Vault activities.
- About Auditing Oracle Database Vault Events As with all unified auditing, you must have the AUDIT_ADMIN role before you can audit Oracle Database Vault events.
- Who Is Audited in Oracle Database Vault? Audited Oracle Database Vault users include administrators and users whose activities affect Database Vault enforcement policies.
- About Oracle Database Vault Unified Audit Trail Events The audit trail in an Oracle Database Vault environment captures all configuration changes or attempts at changes to Database Vault policies.
- Oracle Database Vault Realm Audit Events The unified audit trail captures Oracle Database Vault realm events.
- Oracle Database Vault Rule Set and Rule Audit Events The unified audit trail can capture Oracle Database Vault rule set and rule audit events.
- Oracle Database Vault Command Rule Audit Events The unified audit trail can capture Oracle Database Vault command rule audit events.
- Oracle Database Vault Factor Audit Events The unified audit trail can capture Oracle Database Vault factor events.
- Oracle Database Vault Secure Application Role Audit Events The unified audit trail can capture Oracle Database Vault secure application role audit events.
- Oracle Database Vault Oracle Label Security Audit Events The unified audit trail can capture Oracle Database Vault Oracle Label Security audit events.
- Oracle Database Vault Oracle Data Pump Audit Events The unified audit trail can capture Oracle Database Vault Oracle Data Pump audit events.
- Oracle Database Vault Enable and Disable Audit Events The unified audit trail can capture Oracle Database Vault enable and disable audit events.
``````
- Configuring a Unified Audit Policy for Oracle Database Vault The ACTIONS and ACTIONS COMPONENT clauses in the CREATE AUDIT POLICY statement can create unified audit policies for Oracle Database Vault events.
- Example: Auditing an Oracle Database Vault Realm The CREATE AUDIT POLICY statement can audit Oracle Database Vault realms.
- Example: Auditing an Oracle Database Vault Rule Set The CREATE AUDIT POLICY statement can audit Oracle Database Vault rule sets.
- Example: Auditing Two Oracle Database Vault Events The CREATE AUDIT POLICY statement can audit multiple Oracle Database Vault events.
- Example: Auditing Oracle Database Vault Factors The CREATE AUDIT POLICY statement can audit Oracle Database Vault factors.
- How Oracle Database Vault Audited Events Appear in the Audit Trail The UNIFIED_AUDIT_TRAIL data dictionary view lists Oracle Database Vault audited events.
## About Auditing Oracle Database Vault Events
As with all unified auditing, you must have the `AUDIT_ADMIN` role before you can audit Oracle Database Vault events.
To create Oracle Database Vault unified audit policies, you must set the `CREATE AUDIT POLICY` statement’s `COMPONENT` clause to `DV`, and then specify an action, such as `Rule Set Failure`, and an object, such as the name of a rule set.
To access the audit trail, you can query the following views:
- UNIFIED_AUDIT_TRAIL
- AUDSYS.DV$CONFIGURATION_AUDIT
- AUDSYS.DV$ENFORCEMENT_AUDIT
In the `UNIFIED_AUDIT_TRAIL` view, the Oracle Database Vault-specific columns begin with `DV_`. You must have the `AUDIT_VIEWER` role before you can query the `UNIFIED_AUDIT_TRAIL` view.
In addition to these views, the Database Vault reports capture the results of Database Vault-specific unified audit policies.
## Who Is Audited in Oracle Database Vault?
Audited Oracle Database Vault users include administrators and users whose activities affect Database Vault enforcement policies.
These users are as follows:
****
- Database Vault administrators. All configuration changes that are made to Oracle Database Vault are mandatorily audited. The auditing captures activities such as creating, modifying, or deleting realms, factors, command rules, rule sets, rules, and so on. The AUDSYS.DV$CONFIGURATION_AUDIT data dictionary view captures configuration changes made by Database Vault administrators.
****
- Users whose activities affect Oracle Database Vault enforcement policies. The AUDSYS.DV$ENFORCEMENT_AUDIT data dictionary view captures enforcement-related audits
## About Oracle Database Vault Unified Audit Trail Events
The audit trail in an Oracle Database Vault environment captures all configuration changes or attempts at changes to Database Vault policies.
It also captures violations by users to existing Database Vault policies.
You can audit the following kinds of Oracle Database Vault events:
****
- All configuration changes or attempts at changes to Oracle Database Vault policies. It captures both Database Vault administrator changes and attempts made by unauthorized users.
****
- Violations by users to existing Database Vault policies. For example, if you create a policy to prevent users from accessing a specific schema table during non-work hours, the audit trail will capture this activity.
## Oracle Database Vault Realm Audit Events
The unified audit trail captures Oracle Database Vault realm events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE_REALM | Creates a realm through the DVSYS.DBMS_MACADM.CREATE_REALM procedure |
| UPDATE_REALM | Updates a realm through the DVSYS.DBMS_MACADM.UPDATE_REALM procedure |
| RENAME_REALM | Renames a realm through the DVSYS.DBMS_MACADM.RENAME_REALM procedure |
| DELETE_REALM | Deletes a realm through the DVSYS.DBMS_MACADM.DELETE_REALM procedure |
| DELETE_REALM_CASCADE | Deletes a realm and its related Database Vault configuration information through the DVSYS.DBMS_MACADM.DELETE_REALM_CASCADE procedure |
| ADD_AUTH_TO_REALM | Adds an authorization to the realm through the DVSYS.DBMS_MACADM.ADD_AUTH_TO_REALM procedure |
| DELETE_AUTH_FROM_REALM | Removes an authorization from the realm through the DVSYS.DBMS_MACADM.DELETE_AUTH_FROM_REALM procedure |
| UPDATE_REALM_AUTH | Updates a realm authorization through the DVSYS.DBMS_MACADM.UPDATE_REALM_AUTHORIZATION procedure |
| ADD_OBJECT_TO_REALM | Adds an object to a realm authorization through the DVSYS.DBMS_MACADM.ADD_AUTH_TO_REALM procedure |
| DELETE_OBJECT_FROM_REALM | Removes an object from a realm authorization through the DVSYS.DBMS_MACADM.DELETE_OBJECT_FROM_REALM procedure |

## Oracle Database Vault Rule Set and Rule Audit Events
The unified audit trail can capture Oracle Database Vault rule set and rule audit events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE_RULE_SET | Creates a rule set through the DVSYS.DBMS_MACADM.CREATE_RULE_SET procedure |
| UPDATE_RULE_SET | Updates a rule set through the DVSYS.DBMS_MACADM.UPDATE_RULE_SET procedure |
| RENAME_RULE_SET | Renames a rule set through the DVSYS.DBMS_MACADM.RENAME_RULE_SET procedure |
| DELETE_RULE_SET | Deletes a rule set through the DVSYS.DBMS_MACADM.DELETE_RULE_SET procedure |
| ADD_RULE_TO_RULE_SET | Adds a rule to an existing rule set through the DVSYS.DBMS_MACADM.ADD_RULE_TO_RULE_SET procedure |
| DELETE_RULE_FROM_RULE_SET | Removes a rule from an existing rule set through the DVSYS.DBMS_MACADM.DELETE_RULE_FROM_RULE_SET procedure |
| CREATE_RULE | Creates a rule through the DVSYS.DBMS_MACADM.CREATE_RULE procedure |
| UPDATE_RULE | Updates a rule through the DVSYS.DBMS_MACADM.UPDATE_RULE procedure |
| RENAME_RULE | Renames a rule through the DVSYS.DBMS_MACADM.RENAME_RULE procedure |
| DELETE_RULE | Deletes a rule through the DVSYS.DBMS_MACADM.DELETE_RULE procedure |
| SYNC_RULES | Synchronizes the rules in Oracle Database Vault and Advanced Queuing Rules engine through the DVSYS.DBMS_MACADM.SYNC_RULES procedure |

## Oracle Database Vault Command Rule Audit Events
The unified audit trail can capture Oracle Database Vault command rule audit events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE_COMMAND_RULE | Creates a command rule through the DVSYS.DBMS_MACADM.CREATE_COMMAND_RULE procedure |
| DELETE_COMMAND_RULE | Deletes a command rule through the DVSYS.DBMS_MACADM.DELETE_COMMAND_RULE procedure |
| UPDATE_COMMAND_RULE | Updates a command rule through the DVSYS.DBMS_MACADM.UPDATE_COMMAND_RULE procedure |

## Oracle Database Vault Factor Audit Events
The unified audit trail can capture Oracle Database Vault factor events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE_FACTOR_TYPE | Creates a factor type through the DVSYS.DBMS_MACADM.CREATE_FACTOR_TYPE procedure |
| DELETE_FACTOR_TYPE | Deletes a factor type through the DVSYS.DBMS_MACADM.DELETE_FACTOR_TYPE procedure |
| UPDATE_FACTOR_TYPE | Updates a factor type through the DVSYS.DBMS_MACADM.UPDATE_FACTOR_TYPE procedure |
| RENAME_FACTOR_TYPE | Renames a factor type through the DVSYS.DBMS_MACADM.RENAME_FACTOR_TYPE procedure |
| CREATE_FACTOR | Creates a factor through the DVSYS.DBMS_MACADM.CREATE_FACTOR procedure |
| UPDATE_FACTOR | Updates a factor through the DVSYS.DBMS_MACADM.UPDATE_FACTOR procedure |
| DELETE_FACTOR | Deletes a factor through the DVSYS.DBMS_MACADM.DELETE_FACTOR procedure |
| RENAME_FACTOR | Renames a factor through the DVSYS.DBMS_MACADM.RENAME_FACTOR procedure |
| ADD_FACTOR_LINK | Specifies a parent-child relationship between two factors through the DVSYS.DBMS_MACADM.ADD_FACTOR_LINK procedure |
| DELETE_FACTOR_LINK | Removes the parent-child relationship between two factors through the DVSYS.DBMS_MACADM.DELETE_FACTOR_LINK procedure |
| ADD_POLICY_FACTOR | Specifies that the label for a factor contributes to the Oracle Label Security label for a policy, through the DVSYS.DBMS_MACADM.ADD_POLICY_FACTOR procedure |
| DELETE_POLICY_FACTOR | Removes factor label from being associated with an Oracle Label Security label for a policy, through the DBMS_MACADM.DELETE_POLICY_FACTOR procedure |
| CREATE_IDENTITY | Creates a factor identity through the DVSYS.DBMS_MACADM.CREATE_IDENTITY procedure |
| UPDATE_IDENTITY | Updates a factor identity through the DVSYS.DBMS_MACADM.UPDATE_IDENTITY procedure |
| CHANGE_IDENTITY_FACTOR | Associates an identity with a different factor through the DVSYS.DBMS_MACADM.CHANGE_IDENTITY_FACTOR procedure |
| CHANGE_IDENTITY_VALUE | Updates the value of an identity through the DVSYS.DBMS_MACADM.CHANGE_IDENTITY_VALUE procedure |
| DELETE_IDENTITY | Deletes an existing factor identity through the DVSYS.DBMS_MACADM.DELETE_IDENTITY procedure |
| CREATE_IDENTITY_MAP | Creates a factor identity map through the DVSYS.DBMS_MACADM.CREATE_IDENTITY_MAP procedure |
| DELETE_IDENTITY_MAP | Deletes a factor identity map through the DVSYS.DBMS_MACADM.DELETE_IDENTITY_MAP procedure |
| CREATE_DOMAIN_IDENTITY | Adds an Oracle Database Real Application Clusters database node to the domain factor identities and labels it according to the Oracle Label Security policy, through the DVSYS.DBMS_MACADM.CREATE_DOMAIN_IDENTITY procedure |
| DROP_DOMAIN_IDENTITY | Drops an Oracle RAC node from the domain factor identities through the DVSYS.DBMS_MACADM.DROP_DOMAIN_IDENTITY procedure |

## Oracle Database Vault Secure Application Role Audit Events
The unified audit trail can capture Oracle Database Vault secure application role audit events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE_ROLE | Creates an Oracle Database Vault secure application role through the DVSYS.DBMS_MACADM.CREATE_ROLE procedure |
| DELETE_ROLE | Deletes an Oracle Database Vault secure application role through the DVSYS.DBMS_MACADM.DELETE_ROLE procedure |
| UPDATE_ROLE | Updates an Oracle Database Vault secure application role through the DVSYS.DBMS_MACADM.UPDATE_ROLE procedure |
| RENAME_ROLE | Renames an Oracle Database Vault secure application role through the DVSYS.DBMS_MACADM.RENAME_ROLE procedure |

## Oracle Database Vault Oracle Label Security Audit Events
The unified audit trail can capture Oracle Database Vault Oracle Label Security audit events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE_POLICY_LABEL | Creates an Oracle Label Security policy label through the DVSYS.DBMS_MACADM.CREATE_POLICY_LABEL procedure |
| DELETE_POLICY_LABEL | Deletes an Oracle Label Security policy label through the DVSYS.DBMS_MACADM.DELETE_POLICY_LABEL procedure |
| CREATE_MAC_POLICY | Specifies the algorithm that is used to merge labels when computing the label for a factor, or the Oracle Label Security Session label, through the DVSYS.DBMS_MACADM.CREATE_MAC_POLICY procedure |
| UPDATE_MAC_POLICY | Changes the Oracle Label Security merge label algorithm through the DVSYS.DBMS_MACADM.UPDATE_MAC_POLICY procedure |
| DELETE_MAC_POLICY_CASCADE | Deletes all Oracle Database Vault objects related to an Oracle Label Security policy, through the DVSYS.DBMS_MACADM.DELETE_MAC_POLICY_CASCADE procedure |

## Oracle Database Vault Oracle Data Pump Audit Events
The unified audit trail can capture Oracle Database Vault Oracle Data Pump audit events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| AUTHORIZE_DATAPUMP_USER | Authorizes an Oracle Data Pump user through the DVSYS.DBMS_MACADM.AUTHORIZE_DATAPUMP_USER procedure |
| UNAUTHORIZE_DATAPUMP_USER | Removes from authorization an Oracle Data Pump user through the DVSYS.DBMS_MACADM.UNAUTHORIZE_DATAPUMP_USER procedure |

## Oracle Database Vault Enable and Disable Audit Events
The unified audit trail can capture Oracle Database Vault enable and disable audit events.
The following table describes these events.

| Event | Description |
|---|---|
| ENABLE_EVENT | DBMS_MACADM.ENABLE_EVENT |
| DISABLE_EVENT | DBMS_MACADM.DISABLE_EVENT |

## Configuring a Unified Audit Policy for Oracle Database Vault
The `ACTIONS` and `ACTIONS COMPONENT` clauses in the `CREATE AUDIT POLICY` statement can create unified audit policies for Oracle Database Vault events.
  - Use the following syntax to create an Oracle Database Vault unified audit policy:
```
CREATE AUDIT POLICY policy_name ACTIONS COMPONENT= DV DV_action ON DV_object [,DV_action2 ON DV_object2]
```
In this specification:
**
  - Realm-related actions: Realm Violation audits realm violations (for example, when an unauthorized user attempts to access a realm-protected object). Realm Success audits when a realm-protected object is successfully accessed by an authorized user. Realm Access audits both realm violation and realm success cases, that is, audits whenever the realm access attempt has been made, whether the access succeeded or failed.
``````
  - Rule set-related actions: Rule Set Failure, Rule Set Success, Rule Set Eval
``````````````
  - Factor-related actions: Factor Error, Factor Null, Factor Validate Error, Factor Validate False, Factor Trust Level Null, Factor Trust Level Neg, Factor All
**
**
  - Realm_Name
**
  - Rule_Set_Name
**
  - Factor_Name
If the object was created in lower or mixed case, then you must enclose *DV_objects* in double quotation marks. If you had created the object in all capital letters, then you can omit the quotation marks.
For example, to audit realm violations on the Database Vault Account Management realm:
```
CREATE AUDIT POLICY audit_dv ACTIONS COMPONENT=DV Realm Violation ON "Database Vault Account Management";
```
Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing an Oracle Database Vault Realm
The `CREATE AUDIT POLICY` statement can audit Oracle Database Vault realms.
Example 27-22 shows how to audit a realm violation on the `HR` schema.
Example 27-22 Auditing a Realm Violation
```
CREATE AUDIT POLICY dv_realm_hr ACTIONS COMPONENT=DV Realm Violation ON "HR Schema Realm";
AUDIT POLICY dv_realm_hr;
```
## Example: Auditing an Oracle Database Vault Rule Set
The `CREATE AUDIT POLICY` statement can audit Oracle Database Vault rule sets.
Example: Auditing an Oracle Database Vault Rule Set shows how to audit the Can Maintain Accounts/Profile rule set.
Example 27-23 Auditing a Rule Set
```
CREATE AUDIT POLICY dv_rule_set_accts ACTIONS COMPONENT=DV RULE SET FAILURE ON "Can Maintain Accounts/Profile";
AUDIT POLICY dv_rule_set_accts;
```
## Example: Auditing Two Oracle Database Vault Events
The `CREATE AUDIT POLICY` statement can audit multiple Oracle Database Vault events.
Example 27-24 shows how to audit a realm violation and a rule set failure.
Example 27-24 Auditing Two Oracle Database Vault Events
```
CREATE AUDIT POLICY audit_dv ACTIONS COMPONENT=DV REALM VIOLATION ON "Oracle Enterprise Manager", Rule Set Failure ON "Allow Sessions";
AUDIT POLICY audit_dv;
```
## Example: Auditing Oracle Database Vault Factors
The `CREATE AUDIT POLICY` statement can audit Oracle Database Vault factors.
Example 27-25 shows how to audit two types of errors for one factor.
Example 27-25 Auditing Oracle Database Vault Factor Settings
```
CREATE AUDIT POLICY audit_dv_factor ACTIONS COMPONENT=DV FACTOR ERROR ON "Database_Domain", Factor Validate Error ON "Client_IP";
AUDIT POLICY audit_dv_factor;
```
## How Oracle Database Vault Audited Events Appear in the Audit Trail
The `UNIFIED_AUDIT_TRAIL` data dictionary view lists Oracle Database Vault audited events.
The `DV_`* columns of the `UNIFIED_AUDIT_TRAIL` view show Oracle Database Vault-specific audit data.
For example:
```
SELECT DBUSERNAME, SQL_TEXT, UNIFIED_AUDIT_POLICIES, DV_ACTION_NAME, DV_ACTION_OBJECT_NAME, DV_RULE_SET_NAME FROM UNIFIED_AUDIT_TRAIL WHERE AUDIT_TYPE = 'DATABASE VAULT' ORDER BY EVENT_TIMESTAMP;
DBUSERNAME SQL_TEXT                   UNIFIED_AUDIT_POLICIES DV_ACTION_NAME        DV_ACTION_OBJECT_NAME DV_RULE_SET_NAME
---------- -------------------------- ----------------------- --------------------- --------------------- ------------------
PFITCH     SELECT * FROM HR.EMPLOYEES DV_AUDIT_POLICY         Command Failure Audit SELECT                HR_data_protection
```
## Related Topics
  - Oracle Database Vault Predefined Unified Audit Policy for DVSYS and LBACSYS Schemas
  **- Oracle Database Vault Administrator’s Guide for detailed information about Oracle Database Vault audit policies
  **````- Oracle Database Vault Administrator’s Guide for more information about the AUDSYS.DV$CONFIGURATION_AUDIT and AUDSYS.DV$ENFORCEMENT_AUDIT data dictionary views
