# Initializing Database Session-Based Application Contexts Externally

Initializing database session-based application contexts externally increases performance because the application context is stored in the user global area (UGA).
- About Initializing Database Session-Based Application Contexts Externally You must use a special type of namespace to initialize session-based application context externally.
- Default Values from Users Oracle Database enables you to capture and use default values from users for your applications.
- Values from Other External Resources An application context can accept the initialization of attributes and values through external resources.
- Example: Creating an Externalized Database Session-based Application Context The CREATE CONTEXT SQL statement can create an externalized database session-based application context.
- Initialization of Application Context Values from a Middle-Tier Server Middle-tier servers can initialize application context values on behalf of database users.
## About Initializing Database Session-Based Application Contexts Externally
You must use a special type of namespace to initialize session-based application context externally.
This namespace must accept the initialization of attribute values from external resources and then stores them in the local user session.
Initializing an application context externally enhances performance because it is stored in the UGA and enables the automatic propagation of attributes from one session to another. Connected user database links are supported only by application contexts initialized from OCI-based external sources.
## Default Values from Users
Oracle Database enables you to capture and use default values from users for your applications.
Sometimes you need the default values from users. Initially, these default values may be hints or preferences, and then after validation, they become trusted contexts. Similarly, it may be more convenient for clients to initialize some default values, and then rely on a login event trigger or applications to validate the values.
For job queues, the job submission routine records the context being set at the time the job is submitted, and restores it when executing the batched job. To maintain the integrity of the context, job queues cannot bypass the designated PL/SQL package to set the context. Rather, the externally initialized application context accepts initialization of context values from the job queue process.
Automatic propagation of context to a remote session may create security problems. Developers or administrators can effectively handle the context that takes default values from resources other than the designated PL/SQL procedure by using logon triggers to reset the context when users log in.
## Values from Other External Resources
An application context can accept the initialization of attributes and values through external resources.
Examples include an Oracle Call Interface (OCI) interface, a job queue process, or a database link.
Externally initialized application contexts provide the following features:
- For remote sessions, automatic propagation of context values that are in the externally initialized application context namespace
- For job queues, restoration of context values that are in the externally initialized application context namespace
- For OCI interfaces, a mechanism to initialize context values that are in the externally initialized application context namespace
Although any client program that is using Oracle Call Interface can initialize this type of namespace, you can use login event triggers to verify the values. It is up to the application to interpret and trust the values of the attributes.
## Example: Creating an Externalized Database Session-based Application Context
The `CREATE CONTEXT` SQL statement can create an externalized database session-based application context.
Example 13-6 shows how to create a database session-based application context that obtains values from an external source.
Example 13-6 Creating an Externalized Database Session-based Application Context
```
CREATE CONTEXT ext_ctx USING ext_ctx_pkg INITIALIZED EXTERNALLY;
```
## Initialization of Application Context Values from a Middle-Tier Server
Middle-tier servers can initialize application context values on behalf of database users.
In this process, context attributes are propagated for the remote session at initialization time, and the remote database accepts the values if the namespace is externally initialized.
For example, a three-tier application creating lightweight user sessions through OCI or JDBC/OCI can access the `PROXY_USER` attribute in `USERENV`. This attribute enables you to determine if the user session was created by a middle-tier application. You could allow a user to access data only for connections where the user is proxied. If users connect directly to the database, then they would not be able to access any data.
You can use the `PROXY_USER` attribute from the `USERENV` namespace within Oracle Virtual Private Database to ensure that users only access data through a particular middle-tier application. For a different approach, you can develop a secure application role to enforce your policy that users access the database only through a specific proxy.
## Related Topics
  ````- Preserving User Identity in Multitiered Environments for information about proxy authentication and about using the USERENV attribute CLIENT_IDENTIFIER to preserve user identity across multiple tiers
  - Middle Tier Server Use for Proxy Authentication for information about using a secure application role to enforce a policy through a specific proxy
  **- Oracle Call Interface Programmer’s Guide
