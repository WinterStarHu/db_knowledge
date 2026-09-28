# About Proxy Authentication

Oracle Database provides proxy authentication in Oracle Call Interface (OCI), JDBC/OCI, or JDBC Thin Driver for database users or enterprise users.
Enterprise users are those who are managed in Oracle Internet Directory and who access a shared schema in the database.
You can design a middle-tier server to authenticate clients in a secure fashion by using the following three forms of proxy authentication:
- The middle-tier server authenticates itself with the database server and a client, in this case an application user or another application, authenticates itself with the middle-tier server. Client identities can be maintained all the way through to the database.
- The client, in this case a database user, is not authenticated by the middle-tier server. The clients identity and database password are passed through the middle-tier server to the database server for authentication.
  - Distinguished name (DN)
  - Certificate
In all cases, an administrator must authorize the middle-tier server to act on behalf of the client.
## Related Topics
  - Auditing SQL Statements and Privileges in a Multitier Environment
**- Oracle Database JDBC Developer’s Guide
