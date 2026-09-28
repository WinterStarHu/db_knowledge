# How the Unified Auditing Migration Affects Individual Audit Features

The script content on this page is for navigation purposes only and does not alter the content in any way.
Most of the pre-Oracle Database 12*c* release 1 (12.1) auditing features can be used before a unified auditing migration.
The following table describes how the pre-Oracle Database 12*c* audit features change in the migration.

| Feature | Availability in Pre-Migrated Environment | Availability in Post-Migrated Environment |
|---|---|---|
| General Auditing Features | - | - |
| Operating system audit trail | Yes | No |
| XML file audit trail | Yes | No |
| Network auditing | Yes | No |
| The ability of users to audit and to removing auditing from their own schema objects | Yes | No |
| Mandatory auditing of audit administrative actions | No | Yes |
| Auditing Roles | - | - |
| AUDIT_ADMIN | Yes, but not needed for users who want to audit their own objects, nor for users who already have the ALTER SYSTEM privilege and want to change the auditing initialization parameters | Yes |
| AUDIT_VIEWER | Yes | Yes |
| System Tables | - | - |
| SYS.AUD$ | Yes | Yes, but will only have pre-unified audit records |
| SYS.FGA_LOG$ | Yes | Yes, but will only have pre-unified audit records |
| Initialization Parameters | - | - |
| AUDIT_TRAIL | Yes | Yes, but will not have any effect |
| AUDIT_FILE_DEST | Yes | Yes, but will not have any effect |
| AUDIT_SYS_OPERATIONS | Yes | Yes, but will not have any effect |
| AUDIT_SYSLOG_LEVEL | Yes | Yes, but will not have any effect |
| UNIFIED_AUDIT_SGA_QUEUE_SIZE | Yes, but note that this parameter has been deprecated, but is currently retained for backward compatibility. | Yes, but note that this parameter has been deprecated, but is currently retained for backward compatibility. |
| Data Dictionary Views1 | - | - |
| ALL_AUDIT_POLICIES | Yes | Yes, but only if fine-grained audit policies are created using the DBMS_FGA PL/SQL package |
| DBA_AUDIT_POLICIES | Yes | Yes, but only if fine-grained audit policies are created using the DBMS_FGA PL/SQL package |
| DBA_AUDIT_POLICY_COLUMNS | Yes | Yes, but only if fine-grained audit policies are created using the DBMS_FGA PL/SQL package |
| DBA_COMMON_AUDIT_TRAIL | Yes | Yes, but will only have pre-unified audit records |
| DBA_AUDIT_EXISTS | Yes | Yes |
| DBA_AUDIT_OBJECT | Yes | Yes |
| DBA_AUDIT_POLICIES | Yes | Yes, but only if fine-grained audit policies are created using the DBMS_FGA PL/SQL package |
| DBA_AUDIT_POLICY_COLUMNS | Yes | Yes, but only if fine-grained audit policies are created using the DBMS_FGA PL/SQL package |
| DBA_AUDIT_SESSION | Yes | Yes, but will only have pre-unified audit records |
| DBA_AUDIT_STATEMENT | Yes | Yes, but will only have pre-unified audit records |
| DBA_AUDIT_TRAIL | Yes | Yes, but will only have pre-unified audit records. The RLS_INFO column captures audited Oracle VPD predicates. |
| DBA_FGA_AUDIT_TRAIL | Yes | Yes, but will only have pre-unified audit records. The RLS_INFO column captures audited Oracle VPD predicates. |
| DBA_OBJ_AUDIT_OPTS | Yes | Yes |
| DBA_PRIV_AUDIT_OPTS | Yes | Yes |
| DBA_STMT_AUDIT_OPTS | Yes | Yes |
| UNIFIED_AUDIT_TRAIL | Yes, but does not collect any audit records | Yes, and collects audit records |
| USER_AUDIT_OBJECT | Yes | Yes |
| USER_AUDIT_POLICY_COLUMN | Yes | Yes, but only if fine-grained audit policies are created using the DBMS_FGA PL/SQL package |
| USER_AUDIT_POLICIES | Yes | Yes, but only if fine-grained audit policies are created using the DBMS_FGA PL/SQL package |
| USER_AUDIT_SESSION | Yes | Yes |
| USER_AUDIT_STATEMENT | Yes | Yes |
| USER_AUDIT_TRAIL | Yes | Yes, but will only have pre-unified audit records |
| USER_OBJ_AUDIT_OPTS | Yes | Yes |
| V$XML_AUDIT_TRAIL | Yes | Yes, but will only have pre-unified audit records. The RLS_INFO column captures audited Oracle VPD predicates. |
| CREATE AUDIT POLICY, ALTER AUDIT POLICY, and DROP AUDIT POLICY Statements | The statements are available, but the audit policies will not write to the old audit trails. When a policy is enabled, its audit records are written to the unified audit trail. | Yes, but writes the audit record to the unified audit trail only |
| AUDIT and NOAUDIT Statements | - | - |
| AUDIT | Yes, and can be used in a multitenant environment | Yes, but enhanced to enable audit policies; create application context audit settings; create audit records on success, failure, or both; and use in a multitenant environment |
| NOAUDIT | Yes, and can be used in a multitenant environment | Yes, but changed to disable audit policies, disable application context audit settings, and use in a multitenant environment |
| DBMS_FGA.ADD_POLICY Procedure Parameters | - | - |
| audit_trail | Yes, and is used as in previous releases | Yes, but when unified auditing is enabled, you can omit this parameter because all records will be written to the unified audit trail. |
| DBMS_AUDIT_MGMT Package AUDIT_TRAIL_TYPE Property Options | - | - |
| DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD | Yes | Yes, but only pre-unified audit records |
| DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD | Yes | Yes, but only pre-unified audit records |
| DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD | Yes | Yes, but only pre-unified audit records |
| DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS | Yes | Yes, but only pre-unified audit records |
| DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML | Yes | Yes, but only pre-unified audit records |
| DBMS_AUDIT_MGMT.AUDIT_TRAIL_FILES | Yes | Yes, but only pre-unified audit records |
| DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL | Yes | Yes, but only pre-unified audit records |
| Oracle Database Vault Features | - | - |
| DVSYS.AUDIT_TRAIL$ system table | Yes | Is renamed to DVSYS.OLD_AUDIT_TRAIL$ and retains the old audit records. The previous DVSYS.AUDIT_TRAIL$ table is made into a view named DVSYS.AUDIT_TRAIL$. No new audit records are added. |
| Oracle Label Security Features | - | - |
| SA_AUDIT_ADMIN PL/SQL package | Yes | No |

``````````
- These data dictionary views will continue to show audit data from audit records that are still in the SYS.AUD$ and SYS.FGA_LOG$ system tables. Unified audit trail records are shown only in the unified audit trail-specific views. You must be granted the AUDIT_ADMIN or AUDIT_VIEWER role to query any views that are not prefaced with USER_. ↩
