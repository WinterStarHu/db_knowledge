# About Database Session-Based Application Contexts

A database session-based application context retrieves session information for database users.
This type of application context uses a PL/SQL procedure within Oracle Database to retrieve, set, and secure the data it manages.
The database session-based application context is managed entirely within Oracle Database. Oracle Database sets the values, and then when the user exits the session, automatically clears the application context values stored in cache. If the user connection ends abnormally, for example, during a power failure, then the PMON background process cleans up the application context data.You do not need to explicitly clear the application context from cache.
The advantage of having Oracle Database manage the application context is that you can centralize the application context management. Any application that accesses this database will need to use this application context to permit or prevent user access to that application. This provides benefits both in improved performance and stronger security.
**Note:**   If your users are application users, that is, users who are not in your database, consider using a global application context instead.
## Related Topics
  - Global Application Contexts
