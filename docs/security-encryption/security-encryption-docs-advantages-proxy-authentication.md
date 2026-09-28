# Advantages of Proxy Authentication

In multitier environments, proxy authentication preserves client identities and privileges through all tiers in middle-tier applications and by auditing client actions.
For example, this feature allows the identity of a user using a Web application (which acts as a proxy) to be passed through the application to the database server.
Three-tier systems provide the following benefits to organizations:
- Organizations can separate application logic from data storage, partitioning the former in application servers and the latter in databases.
- Application servers and Web servers enable users to access data stored in databases.
- Users like using a familiar, easy-to-use browser interface.
****
- Organizations can also lower their cost of computing by replacing many thick clients with numerous thin clients and an application server.
In addition, Oracle Database proxy authentication provides the following security benefits:
- A limited trust model, by controlling the users on whose behalf middle tiers can connect and the roles that the middle tiers can assume for the user
- Scalability, by supporting user sessions through OCI, JDBC/OCI, or JDBC Thin driver and eliminating the overhead of reauthenticating clients
- Accountability, by preserving the identity of the real user through to the database, and enabling auditing of actions taken on behalf of the real user
****
- Flexibility, by supporting environments in which users are known to the database, and in which users are merely application users of which the database has no awareness Note: Oracle Database supports this proxy authentication functionality in three tiers only. It does not support it across multiple middle tiers.
