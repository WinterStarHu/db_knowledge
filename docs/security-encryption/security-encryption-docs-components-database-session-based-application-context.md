# Components of a Database Session-Based Application Context

A database session-based application context retrieves and sets data for the context and then sets this context when a user logs in.
You must use three components to create and use a database session-based application context: the application context, a procedure to retrieve the data and set the context, and a way to set the context when the user logs in.
****
- The application context. You use the CREATE CONTEXT SQL statement to create an application context. This statement names the application context (namespace) and associates it with a PL/SQL procedure that is designed to retrieve session data and set the application context.
****
- A PL/SQL procedure to perform the data retrieval and set the context. About the Package That Manages the Database Session-Based Application Context describes the tasks this procedure must perform. Ideally, create this procedure within a package, so that you can include other procedures if you want (for example, to perform error checking tasks).
****
- A way to set the application context when the user logs on. Users who log on to applications that use the application context must run a PL/SQL package that sets the application context. You can achieve this with either a logon trigger that fires each time the user logs on, or you can embed this functionality in your applications.
Tutorial: Creating and Using a Database Session-Based Application Context shows how to create and use a database session-based application context that is initialized locally.
In addition, you can initialize session-based application contexts either externally or globally. Either method stores the context information in the user session.
****
- External initialization. This type can come from an OCI interface, a job queue process, or a connected user database link. See Initializing Database Session-Based Application Contexts Externally for detailed information.
****
- Global initialization. This type uses attributes and values from a centralized location, such as an LDAP directory.Initializing Database Session-Based Application Contexts Globally provides more information.
