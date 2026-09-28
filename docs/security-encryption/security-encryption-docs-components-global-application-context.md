# Components of a Global Application Context

A global application context uses a package to manage its attributes and middle-tier application to manage the client session ID.
****````
- The global application context. You use the CREATE CONTEXT SQL statement to create the global application context, and include the ACCESSED GLOBALLY clause in the statement. This statement names the application context and associates it with a PL/SQL procedure that is designed to set the application data context data. The global application context is created and stored in the database schema of the security administrator who creates it.
****````
- A PL/SQL package to set the attributes. The package must contain a procedure that uses the DBMS_SESSION.SET_CONTEXT procedure to set the global application context. The SET_CONTEXT procedure provides parameters that enable you to create a global application context that fits any of the three user situations described in this section. You create, store, and run the PL/SQL package on the database server. Typically, it belongs in the schema of the security administrator who created it.
****`````````` ****
- A middle-tier application to get and set the client session ID. For nondatabase users, which require a client session ID to be authenticated, you can use the Oracle Call Interface (OCI) calls in the middle-tier application to retrieve and set their session data. You can also use the DBMS_SESSION.SET_IDENTIFIER procedure to set the client session ID. An advantage of creating a client session ID to store the nondatabase user’s name is that you can query the CLIENT_ID column of DBA_AUDIT_TRAIL, DBA_FGA_AUDIT_TRAIL, and DBA_COMMON_AUDIT_TRAIL data dictionary views to audit this user’s activity. Note: Be aware that the DBMS_APPLICATION_INFO.SET_CLIENT_INFO setting can overwrite the value.
## Related Topics
  - Use of the DBMS_SESSION PL/SQL Package to Set and Clear the Client Identifier
