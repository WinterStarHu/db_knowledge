# Auditing Activities with the Predefined Unified Audit Policies

Oracle Database provides predefined unified audit policies that cover commonly used security-relevant audit settings.
- Logon Failures Predefined Unified Audit Policy The ORA_LOGON_FAILURES unified audit policy tracks failed logons only, but not any other kinds of logons.
- Secure Options Predefined Unified Audit Policy The ORA_SECURECONFIG unified audit policy provides all the secure configuration audit options.
- Oracle Database Parameter Changes Predefined Unified Audit Policy The ORA_DATABASE_PARAMETER policy audits commonly used Oracle Database parameter modification commands.
- User Account and Privilege Management Predefined Unified Audit Policy The ORA_ACCOUNT_MGMT policy audits commonly used user account and privilege settings.
- Center for Internet Security Recommendations Predefined Unified Audit Policy The ORA_CIS_RECOMMENDATIONS policy performs audits that the Center for Internet Security (CIS) recommends.
- Oracle Database Real Application Security Predefined Audit Policies You can use predefined unified audit policies for Oracle Database Real Application Security events.
``````
- Oracle Database Vault Predefined Unified Audit Policy for DVSYS and LBACSYS Schemas The ORA_DV_AUDPOL predefined unified audit policy audits Oracle Database Vault DVSYS and LBACSYS schema objects.
- Oracle Database Vault Predefined Unified Audit Policy for Default Realms and Command Rules The ORA_DV_AUDPOL2 predefined unified audit policy audits the Oracle Database Vault default realms and command rules.
## Logon Failures Predefined Unified Audit Policy
The `ORA_LOGON_FAILURES` unified audit policy tracks failed logons only, but not any other kinds of logons.
For new databases, this policy is enabled by default for both pure unified auditing and mixed-mode auditing environments. This policy is not enabled for databases that were upgraded from earlier versions, except if you have created a new database from the previous release and then upgrade it to the current release.
**Note:**   Only user `SYS` can alter or drop this predefined policy.
The following `CREATE AUDIT POLICY` statement shows the `ORA_LOGON_FAILURES` unified audit policy definition:
```
CREATE AUDIT POLICY ORA_LOGON_FAILURES ACTIONS LOGON;
```
You should enable the `ORA_LOGON_FAILURES` unified audit policy as follows:
```
AUDIT POLICY ORA_LOGON_FAILURES WHENEVER NOT SUCCESSFUL;
```
## Secure Options Predefined Unified Audit Policy
The `ORA_SECURECONFIG` unified audit policy provides all the secure configuration audit options.
For new databases, this policy is enabled by default for both pure unified auditing and mixed-mode auditing environments. This policy is not enabled for databases that were upgraded from earlier versions, except if you have created a new database from the previous release and then upgrade it to the current release.
**Note:**   Only user `SYS` can alter or drop this predefined policy.
The following statement shows the `ORA_SECURECONFIG` unified audit policy definition.
```
PRIVILEGES ALTER ANY TABLE, CREATE ANY TABLE, DROP ANY TABLE, CREATE ANY PROCEDURE, DROP ANY PROCEDURE, ALTER ANY PROCEDURE, GRANT ANY PRIVILEGE, GRANT ANY OBJECT PRIVILEGE, GRANT ANY ROLE, AUDIT SYSTEM, CREATE EXTERNAL JOB, CREATE ANY JOB, CREATE ANY LIBRARY, EXEMPT ACCESS POLICY, CREATE USER, DROP USER, ALTER DATABASE, ALTER SYSTEM, CREATE PUBLIC SYNONYM, DROP PUBLIC SYNONYM, CREATE SQL TRANSLATION PROFILE, CREATE ANY SQL TRANSLATION PROFILE, DROP ANY SQL TRANSLATION PROFILE, ALTER ANY SQL TRANSLATION PROFILE, TRANSLATE ANY SQL, EXEMPT REDACTION POLICY, PURGE DBA_RECYCLEBIN, LOGMINING, ADMINISTER KEY MANAGEMENT, BECOME USER ACTIONS    ALTER USER, CREATE ROLE, ALTER ROLE, DROP ROLE, SET ROLE, CREATE PROFILE, ALTER PROFILE, DROP PROFILE, CREATE DATABASE LINK, ALTER DATABASE LINK, DROP DATABASE LINK, CREATE DIRECTORY, DROP DIRECTORY, CREATE PLUGGABLE DATABASE, DROP PLUGGABLE DATABASE, ALTER PLUGGABLE DATABASE, EXECUTE ON DBMS_RLS, ALTER DATABASE DICTIONARY;
```
**Note:**  An audit policy created on any standard action(s): `CREATE USER`, `ALTER USER`, `DROP USER`, `GRANT`, `REVOKE`, `CREATE ROLE`, `ALTER ROLE`, `DROP ROLE`, and `CHANGE PASSWORD` will also audit the respective RAS action(s). Oracle has added the equivalent RAS component action(s), such as `GRANT PRIVILEGE` and `GRANT ROLE`, to the audit policy definition if the policy contained any of the previously stated standard actions, such as `GRANT`. The XS component actions added to the audit policy definition are visible in `AUDIT_UNIFIED_POLICIES`.
To enable `ORA_SECURECONFIG`, run the following command:
```
AUDIT POLICY ORA_SECURECONFIG;
```
## Oracle Database Parameter Changes Predefined Unified Audit Policy
The `ORA_DATABASE_PARAMETER` policy audits commonly used Oracle Database parameter modification commands.
**Note:**   Only user `SYS` can alter or drop this predefined policy.
The following statement shows the `ORA_DATABASE_PARAMETER` unified audit policy definition. By default, this policy is not enabled.
```
ACTIONS ALTER DATABASE, ALTER SYSTEM, CREATE SPFILE;
```
To enable `ORA_DATABASE_PARAMETER`, run the following command:
```
AUDIT POLICY ORA_DATABASE_PARAMETER;
```
## User Account and Privilege Management Predefined Unified Audit Policy
The `ORA_ACCOUNT_MGMT` policy audits commonly used user account and privilege settings.
**Note:**   Only user `SYS` can alter or drop this predefined policy.
The following statement shows the `ORA_ACCOUNT_MGMT` unified audit policy definition. By default, this policy is not enabled.
```
ACTIONS CREATE USER, ALTER USER, DROP USER, CREATE ROLE, DROP ROLE, ALTER ROLE, SET ROLE, GRANT, REVOKE;
```
**Note:**  An audit policy created on any standard action(s): `CREATE USER`, `ALTER USER`, `DROP USER`, `GRANT`, `REVOKE`, `CREATE ROLE`, `ALTER ROLE`, `DROP ROLE`, and `CHANGE PASSWORD` will also audit the respective RAS action(s). Oracle has added the equivalent RAS component action(s), such as `GRANT PRIVILEGE` and `GRANT ROLE`, to the audit policy definition if the policy contained any of the previously stated standard actions, such as `GRANT`. The XS component actions added to the audit policy definition are visible in `AUDIT_UNIFIED_POLICIES`.
To enable `ORA_ACCOUNT_MGMT`, run the following command:
```
AUDIT POLICY ORA_ACCOUNT_MGMT;
```
## Center for Internet Security Recommendations Predefined Unified Audit Policy
The `ORA_CIS_RECOMMENDATIONS` policy performs audits that the Center for Internet Security (CIS) recommends.
**Note:**   Only user `SYS` can alter or drop this predefined policy.
The following statement shows the `ORA_CIS_RECOMMENDATIONS` unified audit policy definition. By default, this policy is not enabled.
```
PRIVILEGES SELECT ANY DICTIONARY, ALTER SYSTEM ACTIONS CREATE USER, ALTER USER, DROP USER, CREATE ROLE, DROP ROLE, ALTER ROLE, GRANT, REVOKE, CREATE DATABASE LINK, ALTER DATABASE LINK, DROP DATABASE LINK, CREATE PROFILE, ALTER PROFILE, DROP PROFILE, CREATE SYNONYM, DROP SYNONYM, CREATE PROCEDURE, DROP PROCEDURE, ALTER PROCEDURE, ALTER SYNONYM, CREATE FUNCTION, CREATE PACKAGE, CREATE PACKAGE BODY, ALTER FUNCTION, ALTER PACKAGE, ALTER SYSTEM, ALTER PACKAGE BODY, DROP FUNCTION, DROP PACKAGE, DROP PACKAGE BODY, CREATE TRIGGER, ALTER TRIGGER, DROP TRIGGER;
```
**Note:**  An audit policy created on any standard action(s): `CREATE USER`, `ALTER USER`, `DROP
```
USER`, `GRANT`, `REVOKE`, `CREATE ROLE`, `ALTER ROLE`, `DROP ROLE`, and `CHANGE PASSWORD` will also audit the respective RAS action(s). Oracle has added the equivalent RAS component action(s), such as `GRANT PRIVILEGE` and `GRANT ROLE`, to the audit policy definition if the policy contained any of the previously stated standard actions, such as `GRANT`. The XS component actions added to the audit policy definition are visible in `AUDIT_UNIFIED_POLICIES`.
{: .infoboxnote}
```
To enable `ORA_CIS_RECOMMENDATIONS`, run the following command:
```
AUDIT POLICY ORA_CIS_RECOMMENDATIONS;
```
## Oracle Database Real Application Security Predefined Audit Policies
You can use predefined unified audit policies for Oracle Database Real Application Security events.
- System Administrator Operations Predefined Unified Audit Policy The ORA_RAS_POLICY_MGMT predefined unified audit policy audits policies for all Oracle Real Application Security administrative actions on application users, roles, and policies.
- Session Operations Predefined Unified Audit Policy The ORA_RAS_SESSION_MGMT predefined unified audit policy audits policies for all run-time Oracle Real Application Security session actions and namespace actions.
1.md#GUID-4C76D168-B534-4E12-A4AA-B434FC3E3328)
### System Administrator Operations Predefined Unified Audit Policy
The `ORA_RAS_POLICY_MGMT` predefined unified audit policy audits policies for all Oracle Real Application Security administrative actions on application users, roles, and policies.
 **Note:**   Only user `SYS` can alter or drop this predefined policy.
The following statement describes the `ORA_RAS_POLICY_MGMT` audit policy. By default, this policy is not enabled.
```
ACTIONS COMPONENT=XS CREATE USER, UPDATE USER, DELETE USER, CREATE ROLE, UPDATE ROLE, DELETE ROLE, GRANT ROLE, REVOKE ROLE, ADD PROXY, REMOVE PROXY, SET USER PASSWORD, SET USER VERIFIER, SET USER PROFILE, CREATE ROLESET, UPDATE ROLESET, DELETE ROLESET, CREATE SECURITY CLASS, UPDATE SECURITY CLASS, DELETE SECURITY CLASS, CREATE NAMESPACE TEMPLATE, UPDATE NAMESPACE TEMPLATE, DELETE NAMESPACE TEMPLATE, CREATE ACL, UPDATE ACL, DELETE ACL, CREATE DATA SECURITY, UPDATE DATA SECURITY, DELETE DATA SECURITY, ENABLE DATA SECURITY, DISABLE DATA SECURITY, ADD GLOBAL CALLBACK, DELETE GLOBAL CALLBACK, ENABLE GLOBAL CALLBACK;
```
For STIG compliance, enable the `ORA_RAS_POLICY_MGMT` unified audit policy for all users.
```
AUDIT POLICY ORA_RAS_POLICY_MGMT;
```
### Session Operations Predefined Unified Audit Policy
The `ORA_RAS_SESSION_MGMT` predefined unified audit policy audits policies for all run-time Oracle Real Application Security session actions and namespace actions.
**Note:**   Only user `SYS` can alter or drop this predefined policy.
The following statement describes the `ORA_RAS_SESSION_MGMT` policy. By default, this policy is not enabled.
```
CREATE AUDIT POLICY ORA_RAS_SESSION_MGMT ACTIONS COMPONENT=XS CREATE SESSION, DESTROY SESSION, ENABLE ROLE, DISABLE ROLE, SET COOKIE, SET INACTIVE TIMEOUT, SWITCH USER, ASSIGN USER, CREATE SESSION NAMESPACE, DELETE SESSION NAMESPACE, CREATE NAMESPACE ATTRIBUTE, GET NAMESPACE ATTRIBUTE, SET NAMESPACE ATTRIBUTE, DELETE NAMESPACE ATTRIBUTE;
```
For STIG compliance, enable the `ORA_RAS_SESSION_MGMT` for failed operations.
```
AUDIT POLICY ORA_RAS_SESSION_MGMT WHENEVER NOT SUCCESSFUL;
```
## Oracle Database Vault Predefined Unified Audit Policy for DVSYS and LBACSYS Schemas
The `ORA_DV_AUDPOL` predefined unified audit policy audits Oracle Database Vault `DVSYS` and `LBACSYS` schema objects.
The `ORA_DV_AUDPOL` policy audits all actions that are performed on the Oracle Database Vault `DVSYS` (including `DVF`) schema objects and the Oracle Label Security `LBACSYS` schema objects. It does not capture actions on the `F$`* factor functions in the `DVF` schema. By default, this policy is not enabled.
**Note:**   Only user `SYS` can alter or drop this predefined policy.
To view the complete definition of this policy, query the `AUDIT_UNIFIED_POLICIES` data dictionary view, where `POLICY_NAME` is `ORA_DV_AUDPOL`. Because this policy audits actions on schema objects, query the `AUDIT_OPTION`, `OBJECT_SCHEMA`, and `OBJECT_NAME` columns to see the audited actions and the schema objects on which they are audited.
```
SELECT AUDIT_OPTION || ' on ' || OBJECT_SCHEMA || '.' || OBJECT_NAME AS audit_option_on_objects FROM AUDIT_UNIFIED_POLICIES WHERE POLICY_NAME = 'ORA_DV_AUDPOL' ORDER BY 1;
```
1.md#GUID-909CE574-EEDA-45A9-960B-DFD7B8004010)
  - AUDIT_UNIFIED_POLICIES
## Oracle Database Vault Predefined Unified Audit Policy for Default Realms and Command Rules
The `ORA_DV_AUDPOL2` predefined unified audit policy audits the Oracle Database Vault default realms and command rules.
The `ORA_DV_AUDPOL2` policy constitutes the audit settings of the Oracle Database Vault-supplied default realms and command rules. By default, this policy is not enabled.
 **Note:**   Only user `SYS` can alter or drop this predefined policy.
To view the complete definition of this policy, query the `AUDIT_UNIFIED_POLICIES` data dictionary view, where `POLICY_NAME` is `ORA_DV_AUDPOL2`. Query the `AUDIT_OPTION`, `OBJECT_SCHEMA`, and `OBJECT_NAME` columns to see more details about the audit options and object-specific entries for this policy.
## Related Topics
  - Auditing Commonly Used Security-Relevant Activities
  - [Auditing Oracle Database Real Application Security Events](auditing-oracle-database-real-application-security-events
  - [Auditing Oracle Database Vault Events](auditing-oracle-database-vault-events
  - Auditing Oracle Database Vault Events
  - AUDIT_UNIFIED_POLICIES
