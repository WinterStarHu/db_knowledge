# Using Transparent Sensitive Data Protection Policies with Unified Auditing

The transparent sensitive data protection and unified auditing procedures can combine the protections of these two features.
- About Using TSDP Policies with Unified Audit Policies You can configure transparent sensitive data protection policies to audit object actions using unified auditing.
``````
- Unified Audit Policy Settings That Are Used with TSDP Policies Audit policy settings can be used in the POLICY_ENABLE_OPTIONS parameter for the DBMS_TSDP_PROTECT.ADD_POLICY or DBMS_TSDP_PROTECT.ALTER_POLICY procedure.
## About Using TSDP Policies with Unified Audit Policies
You can configure transparent sensitive data protection policies to audit object actions using unified auditing.
The `DBMS_TSDP_PROTECT.ADD_POLICY` and `DBMS_TSDP_PROTECT.ALTER_POLICY` procedures enable you to specify settings from the `CREATE AUDIT POLICY`, `ALTER AUDIT POLICY`, `AUDIT POLICY`, and `COMMENT` SQL statements. The TSDP policy enables the creation of action audit-options for object-specific options in the policy, such as `INSERT` or `DELETE` operations. System-wide audit options are not supported. Therefore, the audited object type is always `TABLE`. Only standard actions (such as `INSERT`) are permitted. Component actions, such as creating policies for Oracle Label Security or other Oracle Database features, are not supported.
This feature works as follows:
  - You create a TSDP policy with the necessary unified audit settings. The TSDP policy uses parameter settings from the `CREATE AUDIT POLICY`, `AUDIT POLICY`, and `COMMENT` statements.[Unified Audit Policy Settings That Are Used with TSDP Policies](#GUID-0A3A7AE5-C44B-4B57-9DF6-F2FD06A88105) lists these settings.
- You associate the TSDP policy with the necessary sensitive types by using the DBMS_TSDP_PROTECT.ASSOCIATE_POLICY procedure.
- You then enable TSDP protection by using any of the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_* procedures.
``````````
- You enable the TSDP policy. As part of the TSDP policy enablement process, Oracle Database internally creates a unified audit policy and then enables it on the list of target users and roles that you specified in the DBMS_TSDP_PROTECT.ADD_POLICY procedure from Step 1. The name of the internal policy begins with ORA$UNIFIED_AUDIT_ followed by a random alpha-numeric string (for example, ORA$UNIFIED_AUDIT_6J6L3RSJSN2VAN0XF). You can find this policy by querying the POLICY_NAME column of the AUDIT_UNIFIED_POLICIES data dictionary view. To find the names of the users and roles on which this internally created TSDP unified audit policy is enforced, query the AUDIT_UNIFIED_ENABLED_POLICIES view.
- When users try to perform an action on the table that is being protected by the TSDP policy, then based on the TSDP unified audit policy configuration, a unified audit record is written to the unified audit trail for this object access. You can then query the UNIFIED_AUDIT_TRAIL view to see the unified audit record that was created because of the TSDP unified audit policy enforcement.
  - These protections remain in place until you disable the TSDP policy for this column. At that point, Oracle Database automatically disables and then drops the internal policy, because it is no longer necessary. (A unified audit policy must be disabled before it can be dropped.) If you re-enable the TSDP policy, then the internal policy is recreated.
## Unified Audit Policy Settings That Are Used with TSDP Policies
Audit policy settings can be used in the `POLICY_ENABLE_OPTIONS` parameter for the `DBMS_TSDP_PROTECT.ADD_POLICY` or `DBMS_TSDP_PROTECT.ALTER_POLICY` procedure.
These audit policy settings are from the `AUDIT`, `CREATE AUDIT POLICY`, and `ALTER AUDIT POLICY` statements.
The following table describes these settings.

| Parameter | Description | Default |
|---|---|---|
| ACTION_AUDIT_OPTIONS | A string containing a comma-separated list of SQL actions. Valid actions are: ALTER, AUDIT, COMMENT, DELETE, FLASHBACK, GRANT, INDEX, INSERT, LOCK, RENAME, SELECT, UPDATE. To configure the policy to audit all of these actions, specify the keyword ALL. | ALL |
| AUDIT_CONDITION | SYS_CONTEXT (namespace, attribute) operation value-list. In this syntax, operation can be any of the following operators: IN, NOT IN, =, , or <>. If the audit condition contains a single quotation mark, then specify two single quotation marks instead of one, and enclose the SYS_CONTEXT in single quotations. For example: 'SYS_CONTEXT(''USERENV'', ''CLIENT_IDENTIFIER'') = ''myclient'''. | NULL |
| EVALUATE_PER | Can be one of the following: STATEMENT, SESSION, INSTANCE. | STATEMENT |
| ENTITY_NAME | A string that contains a comma-separated list of users or roles. If you omit this parameter, then the audit policy is enabled for all users. | NULL (that is, all database users) |
| ENABLE_OPTION | Applies only if the ENTITY_NAME parameter is used. It specifies if the ENTITY_NAME is a BY user list, an EXCEPT user list, or a BY USERS WITH GRANTED ROLES role list. Valid settings are: BY, EXCEPT, BY USERS WITH GRANTED ROLES. | BY |
| UNIFIED_AUDIT_POLICY_COMMENT | A string that describes the unified audit policy that will be created | NULL |
