# Audit Policy Data Dictionary Views

Data dictionary and dynamic views can be used to find detailed auditing information.
The following table lists these views.
**Tip:** To find error information about audit policies, check the trace files. The `USER_DUMP_DEST` initialization parameter sets the location of the trace files.

| View | Description |
|---|---|
| ALL_AUDIT_POLICIES | Displays information about all fine-grained audit policies |
| ALL_DEF_AUDIT_OPTS | Lists default object-auditing options that are to be applied when objects are created |
| AUDIT_UNIFIED_CONTEXTS | Describes application context values that have been configured to be captured in the audit trail |
| AUDIT_UNIFIED_ENABLED_POLICIES | Describes all unified audit policies that are enabled in the database |
| AUDIT_UNIFIED_POLICIES | Describes all unified audit policies created in the database |
| AUDIT_UNIFIED_POLICY_COMMENTS | Shows the description of each unified audit policy, if a description was entered for the unified audit policy using the COMMENT SQL statement |
| AUDITABLE_SYSTEM_ACTIONS | Maps the auditable system action numbers to the action names |
| CDB_UNIFIED_AUDIT_TRAIL | Similar to the UNIFIED_AUDIT_TRAIL view, displays the audit records but from all PDBs in a multitenant environment. This view is available only in the CDB root and must be queried from there. |
| DBA_AUDIT_POLICIES | Displays information about fine-grained audit policies |
| DBA_SA_AUDIT_OPTIONS | Describes audited Oracle Label Security events performed by users, and indicates if the user’s action failed or succeeded |
| DBA_XS_AUDIT_TRAIL | Displays audit trail information related to Oracle Database Real Application Security |
| DV$CONFIGURATION_AUDIT | Displays configuration changes made by Oracle Database Vault administrators |
| DV$ENFORCEMENT_AUDIT | Displays user activities that are affected by Oracle Database Vault policies |
| SYSTEM_PRIVILEGE_MAP (table) | Describes privilege (auditing option) type codes. This table can be used to map privilege (auditing option) type numbers to type names. |
| USER_AUDIT_POLICIES | Displays information about all fine-grained audit policies on table and views owned by the current user |
| UNIFIED_AUDIT_TRAIL | Displays all audit records |
| V$OPTION | You can query the PARAMETER column for Unified Auditing to find if unified auditing is enabled |
| V$XML_AUDIT_TRAIL | Displays standard, fine-grained, SYS, and mandatory audit records written in XML format files. |

## Related Topics
**- Oracle Database Reference
