# About Auditing Activities with Unified Audit Policies and AUDIT

You can audit the several types of activities, using unified audit policies and the `AUDIT` SQL statement.
The kinds of activities that you can audit are as follows:
- User accounts (including administrative users who log in with the SYSDBA administrative privilege), roles, and privileges
- Object actions, such as dropping a table or a running a procedure
- Application context values
- Activities from Oracle Database Real Application Security, Oracle Recovery Manager, Oracle Data Mining, Oracle Data Pump, Oracle SQL*Loader direct path events, Oracle Database Vault, and Oracle Label Security
When a unified audit policy configured with `ALL ACTIONS` audits a `MERGE` statement, the unified audit trail records the underlying database actions performed by the `MERGE` operation.
Depending on the execution path of the statement, a `MERGE` operation can internally perform `INSERT` operations, `UPDATE` operations, or both. Unified auditing records the corresponding underlying actions that are executed during statement processing.
As a result, the audit trail for a `MERGE` statement can contain audit records that reflect the internal DML actions associated with the statement execution, rather than a single generic `MERGE` action entry.
To find system actions to audit, you can query the `AUDITABLE_SYSTEM_ACTIONS` system table.
To accomplish this, depending on what you want to audit, use the following:
****
- Unified audit policies. A unified audit policy is a named group of audit settings that enable you to audit a particular aspect of user behavior in the database. To create the policy, you use the CREATE AUDIT POLICY statement. The policy can be as simple as auditing the activities of a single user or you can create complex audit policies that use conditions. You can have more than one audit policy in effect at a time in a database. An audit policy can contain both system-wide and object-specific audit options. Most of the auditing that you will do for general activities (including standard auditing) requires the use of audit policies.
****``````````
- AUDIT and NOAUDIT SQL statements. The AUDIT and NOAUDIT SQL statements enable you to, respectively, enable and disable an audit policy. The AUDIT statement also lets you include or exclude specific users for the policy. The AUDIT and NOAUDIT statements also enable you to audit application context values.
****
- For Oracle Recovery Manager, you do not create unified audit policies. The UNIFIED_AUDIT_TRAIL view automatically captures commonly audited Recovery Manager events.
