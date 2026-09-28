# Auditing Administrative Users

The script content on this page is for navigation purposes only and does not alter the content in any way.
You can create unified audit policies to capture the actions of administrative user accounts, such as `SYS`.
- Administrative User Accounts That Can Be Audited Oracle Database provides administrative user accounts that are associated with administrative privileges.
- Configuring a Unified Audit Policy to Capture Administrator Activities The CREATE AUDIT POLICY statement can audit administrative users.
````
- Example: Auditing the SYS User The CREATE AUDIT POLICY statement can audit the SYS user.
## Administrative User Accounts That Can Be Audited
Oracle Database provides administrative user accounts that are associated with administrative privileges.
The following table lists default administrative user accounts and the administrative privileges with which they are typically associated.

| Administrative User Account | Administrative Privilege |
|---|---|
| SYS | SYSDBA |
| PUBLIC1 | SYSOPER |
| SYSASM | SYSASM |
| SYSBACKUP | SYSBACKUP |
| SYSDG | SYSDG |
| SYSKM | SYSKM |

## Configuring a Unified Audit Policy to Capture Administrator Activities
The `CREATE AUDIT POLICY` statement can audit administrative users.
  - To audit administrative users, create a unified audit policy and then apply this policy to the user, the same as you would for non-administrative users. Note that top-level statements by administrative users are mandatorily audited until the database opens.
## Example: Auditing the SYS User
The `CREATE AUDIT POLICY` statement can audit the `SYS` user.
Example 27-5 shows how to audit grants of the `DBMS_FGA` PL/SQL package by user `SYS`.
Example 27-5 Auditing the SYS User
```
CREATE AUDIT POLICY dbms_fga_grants ACTIONS GRANT ON DBMS_FGA;
AUDIT POLICY dbms_fga_grants BY SYS;
```
## Related Topics
  - Activities That Are Mandatorily Audited
````````
- PUBLIC refers to the user PUBLIC, which is the effective user when you log in with the SYSOPER administrative privilege. It does not refer to the PUBLIC role. ↩
