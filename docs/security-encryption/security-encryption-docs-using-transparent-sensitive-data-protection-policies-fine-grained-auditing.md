# Using Transparent Sensitive Data Protection Policies with Fine-Grained Auditing

The transparent sensitive data protection and fine-grained auditing procedures can combine the protections of these two features.
- About Using TSDP Policies with Fine-Grained Auditing You can configure a Transparent Sensitive Data Protection policy for fine-grained auditing.
````````
- Fine-Grained Auditing Parameters That Are Used with TSDP Policies DBMS_FGA.ADD_POLICY settings can be used in the POLICY_ENABLE_OPTIONS parameter for the DBMS_TSDP_PROTECT.ADD_POLICY or DBMS_TSDP_PROTECT.ALTER_POLICY procedure.
## About Using TSDP Policies with Fine-Grained Auditing
You can configure a Transparent Sensitive Data Protection policy for fine-grained auditing.
The `DBMS_TSDP_PROTECT.ADD_POLICY` and `DBMS_TSDP_PROTECT.ALTER_POLICY` procedures enable you to specify settings from the `DBMS_FGA.ADD_POLICY` procedure.
This feature works as follows:
  - You create a TSDP policy with the necessary fine-grained audit settings. The TSDP policy uses parameter settings from the `DBMS_FGA.ADD_POLICY` procedure.[Fine-Grained Auditing Parameters That Are Used with TSDP Policies](#GUID-F852F1BE-D835-426C-9779-89139B066EEE) lists these settings.
- You associate the TSDP policy with the necessary sensitive types by using the DBMS_TSDP_PROTECT.ASSOCIATE_POLICY procedure.
- You then enable TSDP protection by using any of the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_* procedures.
````````
- You enable the TSDP policy. As part of the TSDP policy enablement process, Oracle Database internally creates a fine-grained audit policy that you specified in the DBMS_TSDP_PROTECT.ADD_POLICY procedure from Step 1. The name of the internal policy begins with ORA$FGA_ followed by a random alpha-numeric string (for example, ORA$FGA_6J6L3RSJSN2VAN0XF). You can find this policy by querying the POLICY_NAME column of the DBA_POLICIES data dictionary view.
- When users try to perform an action on the table that is being protected by the TSDP policies, then based on the policy configuration, a fine-grained audit record is generated in the DBA_FGA_AUDIT_TRAIL data dictionary view for this object access.
  - These protections remain in place until you disable the TSDP policy for this column. At that point, Oracle Database automatically drops the internal policy, because it is no longer needed. If you reenable the TSDP policy, then the internal policy is recreated.
## Fine-Grained Auditing Parameters That Are Used with TSDP Policies
`DBMS_FGA.ADD_POLICY` settings can be used in the `POLICY_ENABLE_OPTIONS` parameter for the `DBMS_TSDP_PROTECT.ADD_POLICY` or `DBMS_TSDP_PROTECT.ALTER_POLICY` procedure.
The following table describes these settings.

| Parameter | Description | Default |
|---|---|---|
| audit_condition | Specifies a Boolean value to indicate a monitoring condition, using the following syntax: operator value. For example: < 1000. | NULL |
| handler_schema | Schema that contains the event handler. The default, NULL, enables the current schema to be used. | NULL |
| handler_module | Function name of the event handler. Include the package name if necessary. This function is invoked only after the first row that matches the audit condition in the query is processed. If the procedure fails with an exception, then the user’s SQL statement fails as well. | NULL |
| statement_types | You can specify one of the following statement types: INSERT, UPDATE, SELECT, or DELETE. | SELECT |
| audit_trail | If you have not yet migrated the database to full unified auditing, then use this setting to set the destination of the audit records: DB for the database or XML for XML records. This setting also specifies whether to populate the LSQLTEXT and LSQLBIND columns in the FGA_LOG$ system table. If full unified auditing is enabled, then Oracle Database ignores this parameter and writes the audit records to the unified audit trail. | NULL |
| object_schema | The schema that corresponds to the sensitive column | Schema that contains the sensitive column |
| object_name | The table that contains the sensitive column | The object (table or view) that contains the sensitive column |
| policy_name | A system-generated name for the internal fine-grained audit policy | Internal fine-grained audit policy system-generated name |
| audit_column | The sensitive column | The sensitive column |
| audit_column_opts | Determines whether to audit all or specific columns | DBMS_FGA.ANY_COLUMN |
| enable | Enable status for the TSDP policy; can be either TRUE or FALSE | TRUE |
| policy_owner | User who invokes the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_* procedure | Current user |
