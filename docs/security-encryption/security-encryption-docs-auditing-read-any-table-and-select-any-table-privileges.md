# Auditing the READ ANY TABLE and SELECT ANY TABLE Privileges

The `CREATE AUDIT POLICY` statement can audit the `READ ANY TABLE` and `SELECT ANY TABLE` privileges.
````
- About Auditing the READ ANY TABLE and SELECT ANY TABLE Privileges You can create unified audit policies that capture the use of the READ ANY TABLE and SELECT ANY TABLE system privileges.
- Creating a Unified Audit Policy to Capture READ Object Privilege Operations You can create unified audit policies that capture READ object privilege operations.
``````
- How the Unified Audit Trail Captures READ ANY TABLE and SELECT ANY TABLE The unified audit trail captures SELECT behavior based on whether a user has the READ ANY TABLE or the SELECT ANY TABLE privilege.
## About Auditing the READ ANY TABLE and SELECT ANY TABLE Privileges
You can create unified audit policies that capture the use of the `READ ANY TABLE` and `SELECT ANY TABLE` system privileges.
Based on the action that the user tried to perform and the privilege that was granted to the user, the `SYSTEM_PRIVILEGE_USED` column of the `UNIFIED_AUDIT_TRAIL` data dictionary view will record either the `READ ANY TABLE` system privilege or the `SELECT ANY TABLE` system privilege. For example, suppose the user has been granted the `SELECT ANY TABLE` privilege and then performs a query on a table. The audit trail will record that the user used the `SELECT ANY TABLE` system privilege. If the user was granted `READ ANY TABLE` and performed the same query, then the `READ ANY TABLE` privilege is recorded.
## Creating a Unified Audit Policy to Capture READ Object Privilege Operations
You can create unified audit policies that capture `READ` object privilege operations.
  ``````- To create a unified audit policy to capture any READ object operations, create the policy for the SELECT statement, not for the READ statement.
For example:
```
CREATE AUDIT POLICY read_hr_employees ACTIONS SELECT ON HR.EMPLOYEES;
```
For any `SELECT` object operations, also create the policy on the `SELECT` statement, as with other object actions that you can audit.
## How the Unified Audit Trail Captures READ ANY TABLE and SELECT ANY TABLE
The unified audit trail captures `SELECT` behavior based on whether a user has the `READ ANY TABLE` or the `SELECT ANY TABLE` privilege.
The following table describes how the unified audit trail captures these actions.

| Statement User Issues | Privilege Granted to User | System Privilege Being Audited | Expected UNIFIED_AUDIT_TRAIL Behavior |
|---|---|---|---|
| SELECT | SELECT ANY TABLE | SELECT ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: SELECT ANY TABLE |
| SELECT | SELECT ANY TABLE | READ ANY TABLE | No record |
| SELECT | SELECT ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: SELECT ANY TABLE |
| SELECT | SELECT ANY TABLE | Neither SELECT ANY TABLE nor READ ANY TABLE | No record |
| SELECT | READ ANY TABLE | SELECT ANY TABLE | No record |
| SELECT | READ ANY TABLE | READ ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: READ ANY TABLE |
| SELECT | READ ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: READ ANY TABLE |
| SELECT | READ ANY TABLE | Neither SELECT ANY TABLE nor READ ANY TABLE | No record |
| SELECT | Both SELECT ANY TABLE and READ ANY TABLE | SELECT ANY TABLE | No record, because READ ANY TABLE was used for access |
| SELECT | Both SELECT ANY TABLE and READ ANY TABLE | READ ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: READ ANY TABLE |
| SELECT | Both SELECT ANY TABLE and READ ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: READ ANY TABLE |
| SELECT | Both SELECT ANY TABLE and READ ANY TABLE | Neither SELECT ANY TABLE nor READ ANY TABLE | No record |
| SELECT | Neither SELECT ANY TABLE nor READ ANY TABLE | SELECT ANY TABLE | No record |
| SELECT | Neither SELECT ANY TABLE nor READ ANY TABLE | READ ANY TABLE | No record |
| SELECT | Neither SELECT ANY TABLE nor READ ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | No record |
| SELECT | Neither SELECT ANY TABLE nor READ ANY TABLE | Neither SELECT ANY TABLE nor READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | SELECT ANY TABLE | SELECT ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: SELECT ANY TABLE |
| SELECT ... FOR UPDATE | SELECT ANY TABLE | READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | SELECT ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: SELECT ANY TABLE |
| SELECT ... FOR UPDATE | SELECT ANY TABLE | Neither SELECT ANY TABLE nor READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | READ ANY TABLE | SELECT ANY TABLE | No record |
| SELECT ... FOR UPDATE | READ ANY TABLE | READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | READ ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | READ ANY TABLE | Neither SELECT ANY TABLE nor READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | Both SELECT ANY TABLE and READ ANY TABLE | SELECT ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: SELECT ANY TABLE |
| SELECT ... FOR UPDATE | Both SELECT ANY TABLE and READ ANY TABLE | READ ANY TABLE | No record, because READ ANY TABLE was used for access |
| SELECT ... FOR UPDATE | Both SELECT ANY TABLE and READ ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | Record inserted into SYSTEM_PRIVILEGE_USED: SELECT ANY TABLE |
| SELECT ... FOR UPDATE | Both SELECT ANY TABLE and READ ANY TABLE | Neither SELECT ANY TABLE nor READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | Neither SELECT ANY TABLE nor READ ANY TABLE | SELECT ANY TABLE | No record |
| SELECT ... FOR UPDATE | Neither SELECT ANY TABLE nor READ ANY TABLE | READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | Neither SELECT ANY TABLE nor READ ANY TABLE | Both SELECT ANY TABLE and READ ANY TABLE | No record |
| SELECT ... FOR UPDATE | Neither SELECT ANY TABLE nor READ ANY TABLE | Neither SELECT ANY TABLE or READ ANY TABLE | No record |

## Related Topics
  - Auditing Object Actions
