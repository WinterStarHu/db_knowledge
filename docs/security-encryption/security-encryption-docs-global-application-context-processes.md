# Global Application Context Processes

A simple global application context uses a database user account create the user session; a global application context is for lightweight users.
- Simple Global Application Context Process In a simple global application context process, the application uses a database user to create a user session.
- Global Application Context Process for Lightweight Users You can set a global application contexts for lightweight users.
## Simple Global Application Context Process
In a simple global application context process, the application uses a database user to create a user session.
The value for the context attribute of a simple global application context process can be retrieved from a `SELECT` statement.
Consider the application server, `AppSvr`, which has assigned the client identifier `12345` to client `SCOTT`. The `AppSvr` application uses the `SCOTT` user to create a session. (In other words, it is not a connection pool.) The value assigned to the context attribute can come from anywhere, for example, from running a `SELECT` statement on a table that holds the responsibility codes for users. When the application context is populated, it is stored in memory. As a result, any action that needs the responsibility code can access it quickly with a `SYS_CONTEXT` call, without the overhead of accessing a table. The only advantage of a global context over a local context in this case is if `SCOTT` were changing applications frequently and used the same context in each application.
The following steps show how the global application context process sets the client identifier for `SCOTT`:
  - The administrator creates a global context namespace by using the following statement:
```
CREATE OR REPLACE CONTEXT hr_ctx USING hr.init ACCESSED GLOBALLY;
```
  ````````- The administrator creates a PL/SQL package for the hr_ctx application context to indicate that, for this client identifier, there is an application context called responsibility with a value of 13 in the HR namespace.:
```
CREATE OR REPLACE PROCEDURE hr.init AS BEGIN DBMS_SESSION.SET_CONTEXT( namespace => 'hr_ctx', attribute => 'responsibility', value     => '13', username  => 'SCOTT', client_id => '12345' );
END;
/
```
```
This PL/SQL procedure is stored in the `HR` database schema, but typically it is stored in the schema of the security administrator.
```
  ````- The AppSvr application issues the following command to indicate the connecting client identity each time scott uses AppSvr to connect to the database:
```
EXEC DBMS_SESSION.SET_IDENTIFIER('12345');
```
``````
- When there is a SYS_CONTEXT('hr_ctx','responsibility') call within the database session, the database matches the client identifier, 12345, to the global context, and then returns the value 13.
- When exiting this database session, AppSvr clears the client identifier by issuing the following procedure:
```
EXEC DBMS_SESSION.CLEAR_IDENTIFIER( );
```
  - To release the memory used by the application context, AppSvr issues the following procedure:
```
DBMS_SESSION.CLEAR_CONTEXT('hr_ctx', '12345');
```
```
`CLEAR_CONTEXT` is needed when the user session is no longer active, either on an explicit logout, timeout, or other conditions determined by the `AppSvr` application.
```
**Note:**   After a client identifier in a session is cleared, it becomes a `NULL` value. This implies that subsequent `SYS_CONTEXT` calls only retrieve application contexts with `NULL` client identifiers, until the client identifier is set again using the `SET_IDENTIFIER` interface.
## Global Application Context Process for Lightweight Users
You can set a global application contexts for lightweight users.
You can configure this access so that when other users log in, they cannot access the global application context.
The following steps show the global application context process for a lightweight user application. The lightweight user, `robert`, is not known to the database through the application.
  - The administrator creates the global context namespace by using the following statement:
```
CREATE CONTEXT hr_ctx USING hr.init ACCESSED GLOBALLY;
```
````````
- The HR application server, AppSvr, starts and then establishes multiple connections to the HR database as the appsmgr user.
````
- User robert logs in to the HR application server.
````
- AppSvr authenticates robert to the application.
````
- AppSvr assigns a temporary session ID (or uses the application user ID), 12345, for this connection.
````
- The session ID is returned to the Web browser used by robert as part of a cookie or is maintained by AppSvr.
````
- AppSvr initializes the application context for this client by calling the hr.init package, which issues the following statements:
```
DBMS_SESSION.SET_CONTEXT( 'hr_ctx', 'id', 'robert', 'APPSMGR', 12345 );
DBMS_SESSION.SET_CONTEXT( 'hr_ctx', 'dept', 'sales', 'APPSMGR', 12345 );
```
  - AppSvr assigns a database connection to this session and initializes the session by issuing the following statement:
```
DBMS_SESSION.SET_IDENTIFIER( 12345 );
```
````
- All SYS_CONTEXT calls within this database session return application context values that belong only to the client session. For example, SYS_CONTEXT('hr','id') returns the value robert.
- When finished with the session, AppSvr issues the following statement to clean up the client identity:
```
DBMS_SESSION.CLEAR_IDENTIFIER ( );
```
Even if another user logged in to the database, this user cannot access the global context set by `AppSvr`, because `AppSvr` specified that only the application with user `APPSMGR` logged in can see it. If `AppSvr` used the following, then any user session with client ID set to `12345` can see the global context:
```
DBMS_SESSION.SET_CONTEXT( 'hr_ctx', 'id', 'robert', NULL , 12345 );
DBMS_SESSION.SET_CONTEXT( 'hr_ctx', 'dept', 'sales', NULL , 12345 );
```
Setting `USERNAME` to `NULL` enables different users to share the same context.
**Note:**   Be aware of the security implication of different settings of the global context. `NULL` in the user name means that any user can access the global context. A `NULL` client ID in the global context means that a session with an uninitialized client ID can access the global context. To ensure that only the user who has logged on can access the session, specify `USER` instead of `NULL`.
You can query the client identifier set in the session as follows:
```
SELECT SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER') FROM DUAL;
```
The following output should appear:
```
SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')
-------------------------------------------------
12345
```
A security administrator can see which sessions have the client identifier set by querying the `V$SESSION` view for the `CLIENT_IDENTIFIER` and `USERNAME`, for example:
```
COL client_identifier format a18
SELECT CLIENT_IDENTIFIER, USERNAME from V$SESSION;
```
The following output should appear:
```
CLIENT_IDENTIFIER   USERNAME
------------------  --------
12345               APPSMGR
```
To check the amount of global context area (in bytes) being used, use the following query:
```
SELECT SYS_CONTEXT('USERENV','GLOBAL_CONTEXT_MEMORY') FROM DUAL;
```
The following output should appear:
```
SYS_CONTEXT('USERENV','GLOBAL_CONTEXT_MEMORY')
----------------------------------------------
584
```
## Related Topics
  ````- For more information about using the CLIENT_IDENTIFIER predefined attribute of the USERENV application context:
  - Use of the CLIENT_IDENTIFIER Attribute to Preserve User Identity
  **- Oracle Database SQL Language Reference
  **- Oracle Call Interface Programmer’s Guide
