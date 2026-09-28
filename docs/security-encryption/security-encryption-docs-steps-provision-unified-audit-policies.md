# Selecting an Auditing Type

You can audit general activities (such as SQL statement actions), commonly used auditing activities, or fine-grained audit scenarios.
- Auditing SQL Statements, Privileges, and Other General Activities You can audit many types of objects, from SQL statements to other Oracle Database components, such as Oracle Database Vault..
- Auditing Commonly Used Security-Relevant Activities For commonly used security-relevant audits, Oracle Database provides a set of default unified audit policies that you can choose from.
- Auditing Specific, Fine-Grained Activities Use fine-grained auditing if you want to audit individual columns and use event handlers.
## Auditing SQL Statements, Privileges, and Other General Activities
You can audit many types of objects, from SQL statements to other Oracle Database components, such as Oracle Database Vault..
In addition, you can create policies that use conditions. However, if you want to audit specific columns or use event handlers, you must use fine-grained auditing.
When a unified audit policy configured with `ALL ACTIONS` audits a `MERGE` statement, the unified audit trail records the underlying database actions performed by the `MERGE` operation.
Depending on the execution path of the statement, a `MERGE` operation can internally perform `INSERT` operations, `UPDATE` operations, or both. Unified auditing records the corresponding underlying actions that are executed during statement processing.
As a result, the audit trail for a `MERGE` statement can contain audit records that reflect the internal DML actions associated with the statement execution, rather than a single generic `MERGE` action entry.
The general steps for performing this type of auditing are as follows:
````
- In most cases, use the CREATE AUDIT POLICY statement to create an audit policy. If you must audit application context values, then use the AUDIT statement.
``````
- If you are creating an audit policy, then use the AUDIT statement to enable it and optionally apply (or exclude) the audit settings to one or more users, including administrative users who log in with the SYSDBA administrative privilege (for example, the SYS user). AUDIT also enables you to create an audit record upon an action’s success, failure, or both.
- Query the UNIFIED_AUDIT_TRAIL view to find the generated audit records.
- Periodically archive and purge the contents of the audit trail.
## Auditing Commonly Used Security-Relevant Activities
For commonly used security-relevant audits, Oracle Database provides a set of default unified audit policies that you can choose from.
The general steps for performing this type of auditing are as follows:
- See Auditing Activities with the Predefined Unified Audit Policies to learn about the default audit policies.
- Use the AUDIT statement enable the policy and optionally apply (or exclude) the audit settings to one or more users. See Enabling and Applying Unified Audit Policies to Users and Roles.
- Query the UNIFIED_AUDIT_TRAIL view to find the generated audit records. See also Audit Policy Data Dictionary Views for additional views.
- Periodically archive and purge the contents of the audit trail. See Purging Audit Trail Records.
## Auditing Specific, Fine-Grained Activities
Use fine-grained auditing if you want to audit individual columns and use event handlers.
This type of auditing provides all the features available in unified audit policies.
The general steps for fine-grained auditing are as follows:
- See Auditing Specific Activities with Fine-Grained Auditing to understand more about auditing specific activities.
- Use the DBMS_FGA PL/SQL package to configure fine-grained auditing policies. See Using the DBMS_FGA PL/SQL Package to Manage Fine-Grained Audit Policies.
- Query the UNIFIED_AUDIT_TRAIL view to find the generated audit records. See also Audit Policy Data Dictionary Views for additional views.
- Periodically archive and purge the contents of the audit trail. See Purging Audit Trail Records.
## Related Topics
  - Auditing Activities with Unified Audit Policies and the AUDIT Statement
  - Audit Policy Data Dictionary Views
  - Purging Audit Trail Records
