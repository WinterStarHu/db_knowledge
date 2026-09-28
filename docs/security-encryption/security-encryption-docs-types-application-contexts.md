# Types of Application Contexts

There are three general categories of application contexts.
These categories are as follows:
**** ****
  - Initialized locally. Initializes the application context locally, to the session of the user.
****
  - Initialized externally. Initializes the application context from an Oracle Call Interface (OCI) application, a job queue process, or a connected user database link.
****
  - Initialized globally. Uses attributes and values from a centralized location, such as an LDAP directory.
Using Database Session-Based Application Contexts describes this type of application context.
****
- Global application contexts. This type retrieves data that is stored in the System Global Area (SGA) so that it can be used for applications that use a sessionless model, such as middle-tier applications in a three-tiered architecture. A global application context is useful if the session context must be shared across sessions, for example, through connection pool implementations. Global Application Contexts describes this type.
****
- Client session-based application contexts. This type uses Oracle Call Interface functions on the client side to set the user session data, and then to perform the necessary security checks to restrict user access. Using Client Session-Based Application Contexts describes this type.
The following table summarizes the different types of application contexts.

| Application Context Type | Stored in UGA | Stored in SGA | Supports Connected User Database Links | Supports Centralized Storage of Users’ Application Context | Supports Sessionless Multitier Applications |
|---|---|---|---|---|---|
| Database session-based application context initialized locally | Yes | No | No | No | No |
| Database session-based application context initialized externally | Yes | No | Yes | No | No |
| Database session-based application context initialized globally | Yes | No | No | Yes | No |
| Global application context | No | Yes | No | No | Yes |
| Client session-based application context | Yes | No | Yes | No | Yes |
