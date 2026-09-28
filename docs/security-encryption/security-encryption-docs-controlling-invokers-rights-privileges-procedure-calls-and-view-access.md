# Controlling Invoker’s Rights Privileges for Procedure Calls and View Access

The `INHERIT PRIVILEGES` and `INHERIT ANY PRIVILEGES` privileges regulate the privileges used when invoker’s rights procedures are run.
- How the Privileges of a Schema Affect the Use of Invoker’s Rights Procedures An invoker’s rights procedure is useful in situations where a lower-privileged user must execute a procedure owned by a higher-privileged user.
````
- How the INHERIT [ANY] PRIVILEGES Privileges Control Privilege Access Use the INHERIT PRIVILEGES and INHERIT ANY PRIVILEGES privileges to secure invoker’s rights procedures.
````**
- Grants of the INHERIT PRIVILEGES Privilege to Other Users By default, all users are granted INHERIT PRIVILEGES ON USER newuser TO PUBLIC.
````
- Example: Granting INHERIT PRIVILEGES on an Invoking User The GRANT statement can grant the INHERIT PRIVILEGES privilege on an invoking user to a procedure owner.
````
- Example: Revoking INHERIT PRIVILEGES The REVOKE statement can revoke the INHERIT PRIVILEGES privilege from a user.
````
- Grants of the INHERIT ANY PRIVILEGES Privilege to Other Users By default, user SYS has the INHERIT ANY PRIVILEGES system privilege and can grant this privilege to other database users or roles.
````
- Example: Granting INHERIT ANY PRIVILEGES to a Trusted Procedure Owner The GRANT statement can grant the INHERIT ANY PRIVILEGES privilege to trusted procedure owners.
````````
- Managing INHERIT PRIVILEGES and INHERIT ANY PRIVILEGES By default, PUBLIC has the INHERIT PRIVILEGE privilege on new and upgraded user accounts; the SYS user has the INHERIT ANY PRIVILEGES privilege.
## How the Privileges of a Schema Affect the Use of Invoker’s Rights Procedures
An invoker’s rights procedure is useful in situations where a lower-privileged user must execute a procedure owned by a higher-privileged user.
When a user runs an invoker’s rights procedure (or any PL/SQL program unit that has been created with the `AUTHID CURRENT_USER` clause), the procedure temporarily inherits all of the privileges of the invoking user while the procedure runs.
During that time, the procedure owner has, through the procedure, access to this invoking user’s privileges. Consider the following scenario:
````````
- User ebrown creates the check_syntax invoker’s rights procedure and then grants user jward the EXECUTE privilege on it.
``````
- User ebrown, who is a junior programmer, has only the minimum set of privileges necessary for his job. The check_syntax procedure resides in ebrown’s schema.
````
- User jward, who is a manager, has a far more powerful set of privileges than user ebrown.
``````
- When user jward runs the check_syntax invoker’s rights procedure, the procedure inherits user jward’s higher privileges while it runs.
``````````
- Because user ebrown owns the check_syntax procedure, he has access to user jward’s privileges whenever jward runs the check_syntax procedure.
The danger in this type of situation-in which the lower privileged `ebrown`’s procedure has access to `jward`’s higher privileges whenever `jward` runs the procedure-lies in the risk that the procedure owner can misuse the higher privileges of the invoking user. For example, user `ebrown` could make use of `jward`’s higher privileges by rewriting the `check_syntax` procedure to give `ebrown` a raise or delete `ebrown`’s bad performance appraisal record. Or, `ebrown` originally could have created the procedure as a definer’s rights procedure, granted its `EXECUTE` privilege to `jward`, and then later on change it to a potentially malicious invoker’s rights procedure without letting `jward` know. These types of risks increase when random users, such as application users, have access to a database that uses invoker’s rights procedures.
When user `jward` runs `ebrown`’s invoker’s rights procedure, there is an element of trust involved. He must be assured that `ebrown` will not use the `check_syntax` procedure in a malicious way when it accesses `jward`’s privileges. The `INHERIT PRIVILEGES` and `INHERIT ANY PRIVILEGES` privileges can help user `jward` control whether user `ebrown`’s procedure can have access to his (`jward`’s) privileges. Any user can grant or revoke the `INHERIT PRIVILEGES` privilege on themselves to the user whose invoker’s rights procedures they want to run. `SYS` users manage the `INHERIT ANY PRIVILEGES` privilege.
## How the INHERIT [ANY] PRIVILEGES Privileges Control Privilege Access
Use the `INHERIT PRIVILEGES` and `INHERIT ANY PRIVILEGES` privileges to secure invoker’s rights procedures.
The `INHERIT PRIVILEGES` and `INHERIT ANY PRIVILEGES` privileges regulate the privileges used when a user runs an invoker’s rights procedure or queries a `BEQUEATH CURRENT_USER` view that references an invoker’s rights procedure.
When a user runs an invoker’s rights procedure, Oracle Database checks it to ensure that the procedure owner has either the `INHERIT PRIVILEGES` privilege on the invoking user, or if the owner has been granted the `INHERIT ANY PRIVILEGES` privilege. If the privilege check fails, then Oracle Database returns an `ORA-06598: insufficient INHERIT PRIVILEGES privilege` error.
The benefit of these two privileges is that they give invoking users control over who can access their privileges when they run an invoker’s rights procedure or query a `BEQUEATH CURRENT_USER` view.
## Grants of the INHERIT PRIVILEGES Privilege to Other Users
By default, all users are granted `INHERIT PRIVILEGES` `ON USER` *newuser* `TO PUBLIC`.
This grant takes place when the user accounts are created or when accounts that were created earlier are upgraded to the current release.
The invoking user can revoke the `INHERIT PRIVILEGE` privilege from other users on himself and then grant it only to users that he trusts.
The syntax for the `INHERIT PRIVILEGES` privilege grant is as follows:
```
GRANT INHERIT PRIVILEGES ON USER invoking_user TO procedure_owner;
```
In this specification:
**
- invoking_user is the user who runs the invoker’s rights procedure. This user must be a database user account.
**
- procedure_owner is the user who owns the invoker’s rights procedure. This value must be a database user account. As an alternative to granting the INHERIT PRIVILEGES privilege to the procedure’s owner, you can grant the privilege to a role that is in turn granted to the procedure.
The following users or roles must have the `INHERIT PRIVILEGES` privilege granted to them by users who will run their invoker’s rights procedures:
- Users or roles who own the invoker’s rights procedures
- Users or roles who own BEQUEATH CURRENT_USER views
## Example: Granting INHERIT PRIVILEGES on an Invoking User
The `GRANT` statement can grant the `INHERIT PRIVILEGES` privilege on an invoking user to a procedure owner.
Example 9-1 shows how the invoking user `jward` can grant user `ebrown` the `INHERIT PRIVILEGES` privilege.
Example 9-1 Granting INHERIT PRIVILEGES on an Invoking User to a Procedure Owner
```
GRANT INHERIT PRIVILEGES ON USER jward TO ebrown;
```
The statement enables any invoker’s rights procedure that `ebrown` writes, or will write in the future, to access `jward`’s privileges when `jward` runs it.
## Example: Revoking INHERIT PRIVILEGES
The `REVOKE` statement can revoke the `INHERIT PRIVILEGES` privilege from a user.
Example 9-2 shows how user `jward` can revoke the use of his privileges from `ebrown`.
Example 9-2 Revoking INHERIT PRIVILEGES
```
REVOKE INHERIT PRIVILEGES ON USER jward FROM ebrown;
```
## Grants of the INHERIT ANY PRIVILEGES Privilege to Other Users
By default, user `SYS` has the `INHERIT ANY PRIVILEGES` system privilege and can grant this privilege to other database users or roles.
As with all `ANY` privileges, only grant this privilege to trusted users or roles. Once a user or role has been granted the `INHERIT ANY PRIVILEGES` privilege, then this user’s invoker’s rights procedures have access to the privileges of the invoking user. You can find the users who have been granted the `INHERIT ANY PRIVILEGES` privilege by querying the `DBA_SYS_PRIVS` data dictionary view.
## Example: Granting INHERIT ANY PRIVILEGES to a Trusted Procedure Owner
The `GRANT` statement can grant the `INHERIT ANY PRIVILEGES` privilege to trusted procedure owners.
Example 9-3 shows how to grant the `INHERIT ANY PRIVILEGES` privilege to user `ebrown`.
Example 9-3 Granting INHERIT ANY PRIVILEGES to a Trusted Procedure Owner
```
GRANT INHERIT ANY PRIVILEGES TO ebrown;
```
Be careful about revoking the `INHERIT ANY PRIVILEGES` privilege from powerful users. For example, suppose user `SYSTEM` has created a set of invoker’s rights procedures. If you revoke `INHERIT ANY PRIVILEGES` from `SYSTEM`, then other users cannot run his procedures, unless they have specifically granted him the `INHERIT PRIVILEGE` privilege.
## Managing INHERIT PRIVILEGES and INHERIT ANY PRIVILEGES
By default, `PUBLIC` has the `INHERIT PRIVILEGE` privilege on new and upgraded user accounts; the `SYS` user has the `INHERIT ANY PRIVILEGES` privilege.
Oracle by default configures a set of grants of `INHERIT PRIVILEGES` that are designed to help protect against misuse of the privileges of various Oracle-defined users.
You can choose to revoke the default grant of `INHERIT PRIVILEGES ON USER `*user_name* `TO PUBLIC` for a customer-defined user and grant more specific grants of `INHERIT PRIVILEGES` as appropriate for that particular user. To find the users who have been granted the `INHERIT ANY PRIVILEGES` privilege, query the `DBA_SYS_PRIVS` data dictionary view.
````
- Revoke the INHERIT PRIVILEGES privilege from PUBLIC. For example:
```
REVOKE INHERIT PRIVILEGES ON invoking_user FROM PUBLIC;
```
```
Be aware that this time, any users who run invoker's rights procedures cannot do so, due to run-time errors from failed `INHERIT PRIVILEGES` checks.
```
- Selectively grant the INHERIT PRIVILEGES privilege to trusted users or roles.
- Similarly, selectively grant the INHERIT ANY PRIVILEGES privilege only to trusted users or roles.
You can create an audit policy to audit the granting and revoking of these two privileges, but you cannot audit run-time errors that result from failed `INHERIT PRIVILEGES` privilege checks.
## Related Topics
  **- Oracle Database PL/SQL Packages and Types Reference for information about SQL injection attacks
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the GRANT statement and default privileges
