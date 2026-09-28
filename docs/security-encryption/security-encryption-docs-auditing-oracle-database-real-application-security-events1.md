# Auditing Oracle Database Real Application Security Events

You can use `CREATE AUDIT POLICY` statement to audit Oracle Database Real Application Security events.
- About Auditing Oracle Database Real Application Security Events You must have the AUDIT_ADMIN role to audit Oracle Database Real Application Security events.
````
- Oracle Database Real Application Security Auditable Events Oracle Database provides Real Application Security events that you can audit, such CREATE USER, UPDATE USER.
- Oracle Database Real Application Security User, Privilege, and Role Audit Events The unified audit trail can capture Oracle Database Real Application Security events for users, privileges, and roles.
- Oracle Database Real Application Security Security Class and ACL Audit Events The unified audit trail can capture Oracle Database Real Application Security security class and ACL audit events.
- Oracle Database Real Application Security Session Audit Events The unified audit trail can capture Oracle Database Real Application Security session audit events.
- Oracle Database Real Application Security ALL Events The unified audit trail can capture Oracle Database Real Application Security ALL events.
- Configuring a Unified Audit Policy for Oracle Database Real Application Security The CREATE AUDIT POLICY statement can create a unified audit policy for Oracle Real Application Security.
- Example: Auditing Real Application Security User Account Modifications The CREATE AUDIT POLICY statement can audit Real Application Security user account modifications.
- Example: Using a Condition in a Real Application Security Unified Audit Policy The CREATE AUDIT POLICY statement can set a condition for a Real Application Security unified audit policy.
- How Oracle Database Real Application Security Events Appear in the Audit Trail The DBA_XS_AUDIT_TRAIL data dictionary view lists Oracle Real Application Security audit events.
## About Auditing Oracle Database Real Application Security Events
You must have the `AUDIT_ADMIN` role to audit Oracle Database Real Application Security events.
To access the audit trail, you can query the `UNIFIED_AUDIT_TRAIL` data dictionary view, whose Real Application Security-specific columns begin with `XS_`. If you want to find audit information about the internally generated VPD predicate that is created while an Oracle Real Application Security policy is being enabled, then you can query the `RLS_INFO` column.
Real Application Security-specific views are as follows:
- DBA_XS_AUDIT_TRAIL provides detailed information about Real Application Security events that were audited.
- DBA_XS_AUDIT_POLICY_OPTIONS describes the auditing options that were defined for Real Application Security unified audit policies.
- DBA_XS_ENB_AUDIT_POLICIES lists users for whom Real Application Security unified audit polices are enabled.
## Oracle Database Real Application Security Auditable Events
Oracle Database provides Real Application Security events that you can audit, such `CREATE USER`, `UPDATE USER`.
To find a list of auditable Real Application Security events that you can audit, you can query the `COMPONENT` and `NAME` columns of the `AUDITABLE_SYSTEM_ACTIONS` data dictionary view, as follows:
```
SELECT NAME FROM AUDITABLE_SYSTEM_ACTIONS WHERE COMPONENT = 'XS';
NAME
-------------
CREATE USER UPDATE USER DELETE USER ...
```
## Oracle Database Real Application Security User, Privilege, and Role Audit Events
The unified audit trail can capture Oracle Database Real Application Security events for users, privileges, and roles. The following table describes various audit events for Real Application Security.
**Note:**  An audit policy created on any standard action(s): `CREATE USER`, `ALTER USER`, `DROP
                USER`, `GRANT`, `REVOKE`, `CREATE
                ROLE`, `ALTER ROLE`, `DROP ROLE`, and `CHANGE PASSWORD` will also audit the respective RAS action(s). Oracle has added the equivalent RAS component action(s), such as `GRANT
                PRIVILEGE` and `GRANT ROLE`, to the audit policy definition if the policy contained any of the previously stated standard actions, such as `GRANT`. The XS component actions added to the audit policy definition are visible in `AUDIT_UNIFIED_POLICIES`.
                {: .infoboxnote}

| Audit Event | Description |
|---|---|
| CREATE USER | Creates an Oracle Database Real Application Security user account through the XS_PRINCIPAL.CREATE_USER procedure |
| UPDATE USER | Updates an Oracle Database Real Application Security user account through the following procedures: XS_PRINCIPAL.SET_EFFECTIVE_DATES, XS_PRINCIPAL.SET_USER_DEFAULT_ROLES_ALL, XS_PRINCIPAL.SET_USER_SCHEMA, XS_PRINCIPAL.SET_GUID, XS_PRINCIPAL.SET_USER_STATUS, and XS_PRINCIPAL.SET_DESCRIPTION. |
| DELETE USER | Deletes an Oracle Database Real Application Security user account through the through the XS_PRINCIPAL.DELETE_PRINCIPAL procedure |
| AUDIT_GRANT_PRIVILEGE | Audits the GRANT_SYSTEM_PRIVILEGE privilege |
| AUDIT_REVOKE_PRIVILEGE | Audits the REVOKE_SYSTEM_PRIVILEGE privilege |
| CREATE ROLE | Creates an Oracle Database Real Application Security role through the XS_PRINCIPAL.CREATE_ROLE procedure |
| UPDATE ROLE | Updates an Oracle Database Real Application Security role through the following procedures: XS_PRINCIPAL.SET_DYNAMIC_ROLE_SCOPE, XS_PRINCIPAL.SET_DYNAMIC_ROLE_DURATION, XS_PRINCIPAL.SET_EFFECTIVE_DATES, and XS_PRINCIPAL.SET_ROLE_DEFAULT. |
| DELETE ROLE | Deletes an Oracle Database Real Application Security role through the XS_PRINCIPAL.DELETE_ROLE procedure |
| GRANT ROLE | Grants Oracle Database Real Application Security roles through the XS_PRINCIPAL.GRANT_ROLES procedure |
| REVOKE ROLE | Revokes Oracle Database Real Application Security roles through the XS_PRINCIPAL.REVOKE_ROLES procedure and revokes all granted roles through the XS_PRINCIPAL.REVOKE_ALL_GRANTED_ROLES procedure |
| ADD PROXY | Adds Oracle Database Real Application Security proxy user account through the XS_PRINCIPAL.ADD_PROXY_USER procedure, and adds proxies to database users through the XS_PRINCIPAL.ADD_PROXY_TO_SCHEMA procedure |
| REMOVE PROXY | Removes an Oracle Database Real Application Security proxy user account through the XS_PRINCIPAL.REMOVE_PROXY_USER, XS_PRINCIPAL.REMOVE_ALL_PROXY_USERS, and XS_PRINCIPAL.REMOVE_PROXY_FROM_SCHEMA PROCEDURES |
| SET USER PASSWORD | Sets the Oracle Database Real Application Security user account password through the XS_PRINCIPAL.SET_PASSWORD procedure |
| SET USER VERIFIER | Sets the Oracle Database Real Application Security proxy user account verifier through the XS_PRINCIPAL.SET_VERIFIER procedure |

## Oracle Database Real Application Security Security Class and ACL Audit Events
The unified audit trail can capture Oracle Database Real Application Security security class and ACL audit events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE SECURITY CLASS | Creates a security class through the XS_SECURITY_CLASS.CREATE_SECURITY_CLASS procedure |
| UPDATE SECURITY CLASS | Creates a security class through the following procedures: XS_SECURITY_CLASS.SET_DEFAULT_ACL, XS_SECURITY_CLASS.ADD_PARENTS, XS_SECURITY_CLASS.REMOVE_ALL_PARENTS, XS_SECURITY_CLASS.REMOVE_PARENTS, XS_SECURITY_CLASS.ADD_PRIVILEGES, XS_SECURITY_CLASS.REMOVE_ALL_PRIVILEGES, XS_SECURITY_CLASS.ADD_IMPLIED_PRIVILEGES, XS_SECURITY_CLASS.REMOVE_IMPLIED_PRIVILEGES, XS_SECURITY_CLASS.REMOVE_ALL_IMPLIED_PRIVILEGES, and XS_SECURITY_CLASS.SET_DESCRIPTION. |
| DELETE SECURITY CLASS | Deletes a security class through the XS_SECURITY_CLASS.DELETE_SECURITY_CLASS procedure |
| CREATE ACL | Creates an Access Control List (ACL) through the XS_ACL.CREATE_ACL procedure |
| UPDATE ACL | Updates an ACL through the following procedures: XS_ACL.APPEND_ACES, XS_ACL.REMOVE_ALL_ACES, XS_ACL.SET_SECURITY_CLASS, XS_ACL.SET_PARENT_ACL, XS_ACL.ADD_ACL_PARAMETER, XS_ACL.REMOVE_ALL_ACL_PARAMETERS, XS_ACL.REMOVE_ACL_PARAMETER, and XS_ACL.SET_DESCRIPTION. |
| DELETE ACL | Deletes an ACL through the XS_ACL.DELETE_ACL procedure |
| CREATE DATA SECURITY- | Creates a data security policy through the XS_DATA_SECURITY.CREATE_DATA_SECURITY procedure |
| UPDATE DATA SECURITY | Updates a data security policy through the following procedures: XS_DATA_SECURITY.CREATE_ACL_PARAMETER, XS_DATA_SECURITY.DELETE_ACL_PARAMETER, and XS_DATA_SECURITY.SET_DESCRIPTION. |
| DELETE DATA SECURITY | Deletes a data security policy through the XS_DATA_SECURITY.DELETE_DATA_SECURITY procedure |
| ENABLE DATA SECURITY | Enables extensible data security for a database table or view through the XS_DATA_SECURITY.ENABLE_OBJECT_POLICY procedure |
| DISABLE DATA SECURITY | Disables extensible data security for a database table or view through the XS_DATA_SECURITY.DISABLE_XDS procedure |

## Oracle Database Real Application Security Session Audit Events
The unified audit trail can capture Oracle Database Real Application Security session audit events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| CREATE SESSION | Creates a session through the DBMS_XS_SESSIONS.CREATE_SESSION procedure |
| DESTROY SESSION | Destroys a session through the DBMS_XS_SESSIONS.DESTROY_SESSION procedure |
| CREATE SESSION NAMESPACE | Creates a namespace through the DBMS_XS_SESSIONS.CREATE_NAMESPACE procedure |
| DELETE SESSION NAMESPACE | Deletes a namespace through the DBMS_XS_SESSIONS.DELETE_NAMESPACE procedure |
| CREATE NAMESPACE ATTRIBUTE | Creates a namespace attribute through the DBMS_XS_SESSIONS.CREATE_ATTRIBUTE procedure |
| SET NAMESPACE ATTRIBUTE | Sets a namespace attribute through the DBMS_XS_SESSIONS.SET_ATTRIBUTE procedure |
| GET NAMESPACE ATTRIBUTE | Gets a namespace attribute through the DBMS_XS_SESSIONS.GET_ATTRIBUTE procedure |
| DELETE NAMESPACE ATTRIBUTE | Deletes a namespace attribute through the DBMS_XS_SESSIONS.DELETE_ATTRIBUTE procedure |
| CREATE NAMESPACE TEMPLATE | Creates a namespace attribute through the XS_NS_TEMPLATE.CREATE_NS_TEMPLATE procedure |
| UPDATE NAMESPACE TEMPLATE | Updates a namespace attribute through the following procedures: XS_NS_TEMPLATE.SET_HANDLER, XS_NS_TEMPLATE.ADD_ATTRIBUTES, XS_NS_TEMPLATE.REMOVE_ALL_ATTRIBUTES, XS_NS_TEMPLATE.REMOVE_ATTRIBUTES, and XS_NS_TEMPLATE.SET_DESCRIPTION. |
| DELETE NAMESPACE TEMPLATE | Deletes a namespace through the XS_NS_TEMPLATE.DELETE_NS_TEMPLATE procedure |
| ADD GLOBAL CALLBACK | Adds a global callback through the DBMS_XS_SESSIONS.ADD_GLOBAL_CALLBACK procedure |
| DELETE GLOBAL CALLBACK | Deletes a global callback through the DBMS_XS_SESSIONS.DELETE_GLOBAL_CALLBACK procedure |
| ENABLE GLOBAL CALLBACK | Enables a global callback through the DBMS_XS_SESSIONS.ENABLE_GLOBAL_CALLBACK procedure |
| SET COOKIE | Sets a session cookie through the DBMS_XS_SESSIONS.SET_SESSION_COOKIE procedure |
| SET INACTIVE TIMEOUT | Sets the time-out time for inactive sessions through the DBMS_XS_SESSIONS.SET_INACTIVITY_TIMEOUT procedure |
| SWITCH USER | Sets the security context of the current lightweight user session to a newly initialized security context for a specified user through the DBMS_XS_SESSIONS.SWITCH_USER procedure |
| ASSIGN USER | Assigns or removes one or more dynamic roles for the specified user through the DBMS_XS_SESSIONS.ASSIGN_USER procedure |
| ENABLE ROLE | Enable a role for a lightweight user session through the DBMS_XS_SESSIONS.ENABLE_ROLE procedure |
| DISABLE ROLE | Disables a role for a lightweight user session through the DBMS_XS_SESSIONS.DISABLE_ROLE procedure |

## Oracle Database Real Application Security ALL Events
The unified audit trail can capture Oracle Database Real Application Security `ALL` events.
The following table describes these events.

| Audit Event | Description |
|---|---|
| ALL | Captures all Real Application Security actions |

## Configuring a Unified Audit Policy for Oracle Database Real Application Security
The `CREATE AUDIT POLICY` statement can create a unified audit policy for Oracle Real Application Security.
  - Use the following syntax to create a unified audit policy for Oracle Database Real Application Security:
```
CREATE AUDIT POLICY policy_name ACTIONS COMPONENT=XS component_action1 [, action2];
```
For example:
```
CREATE AUDIT POLICY audit_ras_pol ACTIONS COMPONENT=XS SWITCH USER, DISABLE ROLE;
```
You can build more complex policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing Real Application Security User Account Modifications
The `CREATE AUDIT POLICY` statement can audit Real Application Security user account modifications.
Example 27-20 shows how to audit user `bhurst'`s attempts to switch users and disable roles.
Example 27-20 Auditing Real Application Security User Account Modifications
```
CREATE AUDIT POLICY ras_users_pol ACTIONS COMPONENT=XS SWITCH USER, DISABLE ROLE;
AUDIT POLICY ras_users_pol BY bhurst;
```
## Example: Using a Condition in a Real Application Security Unified Audit Policy
The `CREATE AUDIT POLICY` statement can set a condition for a Real Application Security unified audit policy.
Example 27-21 shows how to create Real Application Security unified audit policy that applies the audit only to actions from the `nemosity` computer host.
Example 27-21 Using a Condition in a Real Application Security Unified Audit Policy
```
CREATE AUDIT POLICY ras_acl_pol ACTIONS DELETE ON OE.CUSTOMERS ACTIONS COMPONENT=XS CREATE ACL, UPDATE ACL, DELETE ACL WHEN 'SYS_CONTEXT(''USERENV'', ''HOST'') = ''nemosity''' EVALUATE PER INSTANCE;
AUDIT POLICY ras_acl_pol BY pfitch;
```
## How Oracle Database Real Application Security Events Appear in the Audit Trail
The `DBA_XS_AUDIT_TRAIL` data dictionary view lists Oracle Real Application Security audit events.
The following example queries the Real Application Security-specific view, `DBA_XS_AUDIT_TRAIL`:
```
SELECT XS_USER_NAME FROM DBA_XS_AUDIT_TRAIL WHERE XS_ENABLED_ROLE = 'CLERK';
XS_USER_NAME
-------------
USER2
```
## Related Topics
  - Auditing Application Context Values Oracle Database Real Application Security Predefined Audit Policies
  - Auditing of Oracle Virtual Private Database Predicates for information about how to format the output of the RLS_INFO column
  **- Oracle Database Real Application Security Administrator’s and Developer’s Guide for detailed information about Oracle Database Real Application Security
  - Oracle Database Real Application Security ALL Events
  - Oracle Database Real Application Security Security Class and ACL Audit Events
  - Oracle Database Real Application Security Session Audit Events
  - Oracle Database Real Application Security ALL Events
  - Syntax for Creating a Unified Audit Policy
