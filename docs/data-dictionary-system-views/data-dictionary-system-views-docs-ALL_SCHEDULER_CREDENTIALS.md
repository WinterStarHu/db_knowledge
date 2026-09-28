# ALL_SCHEDULER_CREDENTIALS

`ALL_SCHEDULER_CREDENTIALS` displays information about the credentials accessible to the current user (that is, those credentials that the user has `ALTER` or `EXECUTE` privileges for).
Note:
This view is deprecated in favor of the `ALL_CREDENTIALS` view. Oracle recommends that you use `ALL_CREDENTIALS` instead. `ALL_SCHEDULER_CREDENTIALS` is retained for backward compatibility only.
Related Views
- DBA_SCHEDULER_CREDENTIALS displays information about all credentials in the database.

- USER_SCHEDULER_CREDENTIALS displays information about the credentials owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the Scheduler credential |
| CREDENTIAL_NAME | VARCHAR2(128) | NOT NULL | Name of the Scheduler credential |
| USERNAME | VARCHAR2(128) |  | Name of the user that will be used to log in to the remote database or operating system |
| DATABASE_ROLE | VARCHAR2(9) |  | For a database target, the database role to use when logging in: SYSDBA SYSOPER |
| WINDOWS_DOMAIN | VARCHAR2(30) |  | For a Windows target, the Windows domain to use when logging in |
| COMMENTS | VARCHAR2(4000) |  | Comments on the credential |

See Also:
- "ALL_CREDENTIALS"
- "DBA_SCHEDULER_CREDENTIALS"
- "USER_SCHEDULER_CREDENTIALS"
