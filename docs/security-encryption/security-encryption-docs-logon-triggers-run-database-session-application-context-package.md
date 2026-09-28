# Logon Triggers to Run a Database Session Application Context Package

Users must run database session application context package after when they log in to the database instance.
You can create a logon trigger that handles this automatically. You do not need to grant the user `EXECUTE` permissions to run the package.
Note the following:
****
- If the PL/SQL package procedure called by the logon trigger has any unhandled exceptions or raises any exceptions (because, for example, a security check failed), then the logon trigger fails. When the logon trigger fails, the logon fails, that is, the user is denied permission to log in to the database.
****
- Logon triggers may affect performance. In addition, test the logon trigger on a sample schema user first before creating it for the database. That way, if there is an error, you can easily correct it.
********``````
- Be aware of situations in which if you have a changing set of books, or if positions change constantly. In these cases, the new attribute values may not be picked up right away, and you must force a cursor reparse to pick them up. Note: A logon trigger can be used because the user context (information such as EMPNO, GROUP, MANAGER) should be set before the user accesses any data.
