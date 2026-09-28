# Preserving User Identity in Multitiered Environments

You can use middle tier servers for proxy authentication and client identifiers to identify application users who are not known to the database.
- Middle Tier Server Use for Proxy Authentication Oracle Call Interface (OCI), JDBC/OCI, or JDBC Thin Driver supports the middle tier for proxy authentication for database users or enterprise users.
- Using Client Identifiers to Identify Application Users Unknown to the Database Client identifiers preserve user identity in middle tier systems; they also can be used independently of the global application context.
## Middle Tier Server Use for Proxy Authentication
Oracle Call Interface (OCI), JDBC/OCI, or JDBC Thin Driver supports the middle tier for proxy authentication for database users or enterprise users.
- About Proxy Authentication Oracle Database provides proxy authentication in Oracle Call Interface (OCI), JDBC/OCI, or JDBC Thin Driver for database users or enterprise users.
- Advantages of Proxy Authentication In multitier environments, proxy authentication preserves client identities and privileges through all tiers in middle-tier applications and by auditing client actions.
- Who Can Create Proxy User Accounts? To create proxy user accounts, users must have special privileges.
- Guidelines for Creating Proxy User Accounts Oracle provides special guidelines for when you create proxy user accounts.
````
- Creating Proxy User Accounts and Authorizing Users to Connect Through Them The CREATE USER and ALTER USER statements can be used to create a proxy user and authorize users to connect through it.
- Proxy User Accounts and the Authorization of Users to Connect Through Them The CREATE USER statement enables you to create the several types of user accounts, all of which can be used as proxy accounts.
- Using Proxy Authentication with the Secure External Password Store Use a secure external password store if you are concerned about the password used in proxy authentication being obtained by a malicious user.
- How the Identity of the Real User Is Passed with Proxy Authentication You can use Oracle Call Interface, JDBC/OCI, or Thin drivers for enterprise users or database users.
- Limits to the Privileges of the Middle Tier Least privilege is the principle that users should have the fewest privileges necessary to perform their duties and no more.
- Authorizing a Middle Tier to Proxy and Authenticate a User You can authorize a middle-tier server to connect as a user.
- Authorizing a Middle Tier to Proxy a User Authenticated by Other Means You can authorize a middle tier to proxy a user that has been authenticated by other means.
````
- Reauthenticating a User Through the Middle Tier to the Database You can specify that authentication is required by using the AUTHENTICATION REQUIRED proxy clause with the ALTER USER SQL statement.
- Using Password-Based Proxy Authentication When you use password-based proxy authentication, Oracle Database passes the password of the client to the middle-tier server.
- Using Proxy Authentication with Enterprise Users How the middle-tier responds for proxy authentication depends on how the user is authenticated, either as an enterprise user or a password-authenticated user.
## Using Client Identifiers to Identify Application Users Unknown to the Database
Client identifiers preserve user identity in middle tier systems; they also can be used independently of the global application context.
````
- About Client Identifiers Oracle Database provides the CLIENT_IDENTIFIER attribute of the built-in USERENV application context namespace for application users.
- How Client Identifiers Work in Middle Tier Systems Many applications use session pooling to set up several sessions to be reused by multiple application users.
````
- Use of the CLIENT_IDENTIFIER Attribute to Preserve User Identity The CLIENT_IDENTIFIER predefined attribute of the built-in application context namespace, USERENV, captures the application user name for use with a global application context.
- Use of the CLIENT_IDENTIFIER Independent of Global Application Context Using the CLIENT_IDENTIFIER attribute is especially useful for those applications in which the users are unknown to the database.
- Setting the CLIENT_IDENTIFIER Independent of Global Application Context You can set the CLIENT_IDENTIFIER setting with Oracle Call Interface to be independent of the global application context.
- Use of the DBMS_SESSION PL/SQL Package to Set and Clear the Client Identifier The DBMS_SESSION PL/SQL package manages client identifiers on both the middle tier and the database itself.
````
- Enabling the CLIENTID_OVERWRITE Event System-Wide The ALTER SYSTEM statement can enable the CLIENTID_OVERWRITE event system-wide.
````
- Enabling the CLIENTID_OVERWRITE Event for the Current Session The ALTER SESSION statement can enable the CLIENTID_OVERWRITE event for the current session only.
````
- Disabling the CLIENTID_OVERWRITE Event The ALTER SYSTEM statement can disable the CLIENTID_OVERWRITE event.
### About Client Identifiers
Oracle Database provides the `CLIENT_IDENTIFIER` attribute of the built-in `USERENV` application context namespace for application users.
These application users are known to an application but unknown to the database. The `CLIENT_IDENTIFIER` attribute can capture any value that the application uses for identification or access control, and passes it to the database. The `CLIENT_IDENTIFIER` attribute is supported in OCI, JDBC/OCI, or Thin driver.
### How Client Identifiers Work in Middle Tier Systems
Many applications use session pooling to set up several sessions to be reused by multiple application users.
Users authenticate themselves to a middle-tier application, which uses a single identity to log in to the database and maintains all the user connections. In this model, application users are users who are authenticated to the middle tier of an application, but who are not known to the database. You can use a `CLIENT_IDENTIFIER` attribute, which acts like an application user proxy for these types of applications.
In this model, the middle tier passes a client identifier to the database upon the session establishment. The client identifier could actually be anything that represents a client connecting to the middle tier, for example, a cookie or an IP address. The client identifier, representing the application user, is available in user session information and can also be accessed with an application context (by using the `USERENV` naming context). In this way, applications can set up and reuse sessions, while still being able to keep track of the *application user* in the session. Applications can reset the client identifier and thus reuse the session for a different user, enabling high performance.
### Use of the CLIENT_IDENTIFIER Attribute to Preserve User Identity
The `CLIENT_IDENTIFIER` predefined attribute of the built-in application context namespace, `USERENV`, captures the application user name for use with a global application context.
You also can use the `CLIENT_IDENTIFIER` attribute independently.
When you use the `CLIENT_IDENTIFIER` attribute independently from a global application context, you can set `CLIENT_IDENTIFIER` with the `DBMS_SESSION` interface. The ability to pass a `CLIENT_IDENTIFIER` to the database is supported in Oracle Call Interface (OCI), JDBC/OCI, or Thin driver.
When you use the `CLIENT_IDENTIFIER` attribute with global application context, it provides flexibility and high performance for building applications. For example, suppose a Web-based application that provides information to business partners has three types of users: gold partner, silver partner, and bronze partner, representing different levels of information available. Instead of each user having his or her own session set up with individual application contexts, the application could set up global application contexts for gold partners, silver partners, and bronze partners. Then, use the `CLIENT_IDENTIFIER` to point the session at the correct context to retrieve the appropriate type of data. The application need only initialize the three global contexts once and use the `CLIENT_IDENTIFIER` to access the correct application context to limit data access. This provides performance benefits through session reuse and through accessing global application contexts set up once, instead of having to initialize application contexts for each session individually.
### Use of the CLIENT_IDENTIFIER Independent of Global Application Context
Using the `CLIENT_IDENTIFIER` attribute is especially useful for those applications in which the users are unknown to the database.
In these situations, the application typically connects as a single database user and all actions are taken as that user.
Because all user sessions are created as the same user, this security model makes it difficult to achieve data separation for each user. These applications can use the `CLIENT_IDENTIFIER` attribute to preserve the real application user identity through to the database.
With this approach, sessions can be reused by multiple users by changing the value of the `CLIENT_IDENTIFIER` attribute, which captures the name of the real application user. This avoids the overhead of setting up a separate session and separate attributes for each user, and enables reuse of sessions by the application. When the `CLIENT_IDENTIFIER` attribute value changes, the change is added to the next OCI, JDBC/OCI, or Thin driver call for additional performance benefits.
For example, the user Daniel connects to a Web Expense application. Daniel is not a database user; he is a typical Web Expense application user. The application accesses the built-in application context namespace and sets `DANIEL` as the `CLIENT_IDENTIFIER` attribute value. Daniel completes his Web Expense form and exits the application. Then, Ajit connects to the Web Expense application. Instead of setting up a new session for Ajit, the application reuses the session that currently exists for Daniel, by changing the `CLIENT_IDENTIFIER` to `AJIT`. This avoids the overhead of setting up a new connection to the database and the overhead of setting up a global application context. The `CLIENT_IDENTIFIER` attribute can be set to any value on which the application bases access control. It does not have to be the application user name.
### Setting the CLIENT_IDENTIFIER Independent of Global Application Context
You can set the `CLIENT_IDENTIFIER` setting with Oracle Call Interface to be independent of the global application context.
  ``````- To set the CLIENT_IDENTIFIER attribute with OCI, use the OCI_ATTR_CLIENT_IDENTIFIER attribute in the call to OCIAttrSet(). Then, on the next request to the server, the information is propagated and stored in the server sessions.
For example:
```
OCIAttrSet (session,
```
```
OCI_HTYPE_SESSION,
(dvoid *) "appuser1",
(ub4)strlen("appuser1"),
OCI_ATTR_CLIENT_IDENTIFIER,
*error_handle);
```
For applications that use JDBC, be aware that JDBC does not set the client identifier. To set the client identifier in a connection pooling environment, use Dynamic Monitoring Service (DMS) metrics. If DMS is not available, then use the `connection.setClientInfo` method. For example:
```
connection.setClientInfo("E2E_CONTEXT.CLIENT_IDENTIFIER", "appuser");
```
### Use of the DBMS_SESSION PL/SQL Package to Set and Clear the Client Identifier
The `DBMS_SESSION` PL/SQL package manages client identifiers on both the middle tier and the database itself.
To use the `DBMS_SESSION` package to set and clear the `CLIENT_IDENTIFIER` value on the middle tier, you must use the `SET_IDENTIFIER` and `CLEAR_IDENTIFIER` procedures.
The middle tier uses `SET_IDENTIFIER` to associate the database session with a particular user or group. Then, the `CLIENT_IDENTIFIER` is an attribute of the session and can be viewed in session information.
If you plan to use the `DBMS_SESSION.SET_IDENTIFIER` procedure, then be aware of the following:
````
- The maximum number of bytes for the client_id parameter of DBMS_SESSION.SET_IDENTIFIER is 64 bytes. If it exceeds 64, then the additional bytes are truncated.
````````````````
- The DBMS_APPLICATION_INFO.SET_CLIENT_INFO procedure can overwrite the value of the client identifier. Typically, these values should be the same, so if SET_CLIENT_INFO is set, then its value can be automatically propagated to the value set by SET_IDENTIFIER if the CLIENTID_OVERWRITE event is set to ON. You can check the status of the CLIENTID_OVERWRITE event by running the SHOW PARAMETER command for the EVENT parameter. For example, assuming that CLIENTID_OVERWRITE is enabled:
```
SHOW PARAMETER EVENT
NAME                           TYPE               VALUE
------------------------------ ------------------ ------------------
event                          string             clientid_overwrite
```
### Enabling the CLIENTID_OVERWRITE Event System-Wide
The `ALTER SYSTEM` statement can enable the `CLIENTID_OVERWRITE` event system-wide.
  - Enter the following ALTER SYSTEM statement:
```
ALTER SYSTEM SET EVENTS 'CLIENTID_OVERWRITE';
```
```
Or, enter the following line in your `init.ora` file:
```
```
event="clientid_overwrite"
```
- Restart the database. For example:
```
SHUTDOWN IMMEDIATE
STARTUP
```
### Enabling the CLIENTID_OVERWRITE Event for the Current Session
The `ALTER SESSION` statement can enable the `CLIENTID_OVERWRITE` event for the current session only.
````
- Use the ALTER SESSION statement to set the CLIENTID_OVERWRITE value for the session only. For example:
```
ALTER SESSION SET EVENTS 'CLIENTID_OVERWRITE OFF';
```
````
- If you set the client identifier by using the DBMS_APPLICATION_INFO.SET_CLIENT_INFO procedure, then run DBMS_SESSION.SET_IDENTIFIER so that the client identifier settings are the same. For example:
```
DBMS_SESSION.SET_IDENTIFIER(session_id_p);
```
### Disabling the CLIENTID_OVERWRITE Event
The `ALTER SYSTEM` statement can disable the `CLIENTID_OVERWRITE` event.
  - Enter the following ALTER SYSTEM statement:
```
ALTER SYSTEM SET EVENTS 'CLIENTID_OVERWRITE OFF';
```
- Restart the database. For example:
```
SHUTDOWN IMMEDIATE
STARTUP
```
## Related Topics
  - Global Application Contexts
  - Tutorial: Creating a Global Application Context That Uses a Client Session ID
**- Oracle Call Interface Programmer’s Guide about how the OCI_ATTR_CLIENT_IDENTIFIER user session handle attribute is used in middle-tier applications **- Oracle Database JDBC Developer’s Guide for more information about configuring client connections using JDBC and DMS metrics **- Oracle Database JDBC Developer’s Guide for more information about the setClientInfo method
  - Global Application Contexts for information about using client identifiers in a global application context
**- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_SESSION package
