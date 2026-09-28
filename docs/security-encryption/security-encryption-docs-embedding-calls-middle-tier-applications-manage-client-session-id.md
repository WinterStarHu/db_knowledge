# Embedding Calls in Middle-Tier Applications to Manage the Client Session ID

You can embed calls in middle-tier applications to manage client session IDs.
- About Managing Client Session IDs Using a Middle-Tier Application The application server generates the client session ID.
- Step 1: Retrieve the Client Session ID Using a Middle-Tier Application When a user starts a client session, the application server generates a client session ID.
- Step 2: Set the Client Session ID Using a Middle-Tier Application Next, you are ready to set the client session ID using a middle-tier application.
- Step 3: Clear the Session Data Using a Middle-Tier Application The application context exists entirely within memory.
## About Managing Client Session IDs Using a Middle-Tier Application
The application server generates the client session ID.
From a middle-tier application, you can get, set, and clear the client session IDs. To do so, you can embed either Oracle Call Interface (OCI) calls or `DBMS_SESSION` PL/SQL package procedures into the middle-tier application code.
The application authenticates the user, sets the client identifier, and sets it in the current session. The PL/SQL package `SET_CONTEXT` sets the `client_identifier` value in the application context.
## Step 1: Retrieve the Client Session ID Using a Middle-Tier Application
When a user starts a client session, the application server generates a client session ID.
You can retrieve this ID for use in authenticating the user’s access.
  - SELECT SYS_CONTEXT('userenv', 'client_identifier') FROM DUAL;
  - SELECT CLIENT_IDENTIFIER from V$SESSION;
  - SELECT value FROM session_context WHERE attribute='CLIENT_IDENTIFIER';
For example, to use the `OCIStmtExecute` call to retrieve a client session ID value:
```
oratext    clientid[31];
 OCIDefine  *defnp1 = (OCIDefine *) 0;
 OCIStmt    *statementhndle;
 oratext    *selcid = (oratext *)"SELECT SYS_CONTEXT('userenv',
            'client_identifier') FROM  DUAL";
OCIStmtPrepare(statementhndle, errhp, selcid,
  (ub4) strlen((char *) selcid), (ub4) OCI_NTV_SYNTAX, (ub4) OCI_DEFAULT);
OCIDefineByPos(statementhndle, &defnp1, errhp, 1, (dvoid *)clientid, 31,
  SQLT_STR, (dvoid *) 0, (ub2 *) 0, (ub2 *) 0, OCI_DEFAULT);
OCIStmtExecute(servhndle, statementhndle, errhp, (ub4) 1, (ub4) 0,
 (CONST OCISnapshot *) NULL, (OCISnapshot *) NULL, OCI_DEFAULT);
  printf("CLIENT_IDENTIFIER = %s \n", clientid);
```
In this example:
````````````
- oratext, OCIDefine, OCIStmt, and oratext create variables to store the client session ID, reference call for OCIDefine, the statement handle, and the SELECT statement to use.
````
- OCIStmtPrepar prepares the statement selcid for execution.
````
- OCIDefineByPos defines the output variable clientid for client session ID.
````
- OCIStmtExecute executes the statement in the selcid variable.
- printf prints the formatted output for the retrieved client session ID.
## Step 2: Set the Client Session ID Using a Middle-Tier Application
Next, you are ready to set the client session ID using a middle-tier application.
- About Setting the Client Session ID Using a Middle-Tier Application After you use the OCIStmtExecute call to retrieve the client session ID, you are ready to set this ID.
- Setting the Client Session ID Using a Middle-Tier Application Oracle Call Interface or the DBMS_SESSION PL/SQL package can set the client session ID using a middle-tier application.
````
- Checking the Value of the Client Identifier For both OCIAttrSet and DBMS_SESSION.SET_IDENTIFIER, you can check the value of the client identifier.
### About Setting the Client Session ID Using a Middle-Tier Application
After you use the `OCIStmtExecute` call to retrieve the client session ID, you are ready to set this ID.
The `DBMS_SESSION.SET_CONTEXT` procedure in the server-side PL/SQL package then sets this session ID and optionally, overwrites the application context values.
You must ensure that the middle-tier application code checks that the client session ID value (for example, the value written to `user_id` in the previous examples) matches the `client_id` setting defined in the server-side `DBMS_SESSION.SET_CONTEXT` procedure. The sequence of calls on the application server side should be as follows:
- Get the current client session ID. The session should already have this ID, but it is safer to ensure that it truly has the correct value.
- Clear the current client session ID. This prepares the application to service a request from a different end user.
- Set the new client session ID or the client session ID that has been assigned to the end user. This ensures that the session is using a different set of global application context values.
### Setting the Client Session ID Using a Middle-Tier Application
Oracle Call Interface or the `DBMS_SESSION` PL/SQL package can set the client session ID using a middle-tier application.
****````
``````
  - Oracle Call Interface. Set the OCI_ATTR_CLIENT_IDENTIFIER attribute in an OCIAttrSet OCI call. This attribute sets the client identifier in the session handle to track the end user identity. The following example shows how to use OCIAttrSet with the ATTR_CLIENT_IDENTIFIER parameter. The user_id setting refers to a variable that stores the ID of the user who is logging on.
```
OCIAttrSet((void *)session_handle, (ub4) OCI_HTYPE_SESSION,
           (void *) user_id, (ub4)strlen(user_id),
           OCI_ATTR_CLIENT_IDENTIFIER, error_handle);
```
****````- DBMS_SESSION package. Use the DBMS_SESSION.SET_IDENTIFIER procedure to set the client identifier for the global application context. For example, assuming you are storing the ID of the user logging on in a variable called user_id, you would enter the following line into the middle-tier application code:
```
DBMS_SESSION.SET_IDENTIFIER(user_id);
```
```

```
### Checking the Value of the Client Identifier
For both `OCIAttrSet` and `DBMS_SESSION.SET_IDENTIFIER`, you can check the value of the client identifier.
  - To check it using the SYS_CONTEXT function:
```
SELECT SYS_CONTEXT('userenv', 'client_identifier') FROM DUAL;
```
  - To check it by querying the V$SESSION view:
```
SELECT CLIENT_IDENTIFIER from V$SESSION;
```
## Step 3: Clear the Session Data Using a Middle-Tier Application
The application context exists entirely within memory.
When the user exits a session, you must clear the context for the `client_identifier` value. This releases memory and prevents other users from accidentally using any left over values ****  - Clearing the client identifier when a user exits a session. Use the DBMS_SESSION.CLEAR_IDENTIFIER procedure. For example:
```
DBMS_SESSION.CLEAR_IDENTIFIER;
```
****````- Continuing the session but still clearing the context. If you want the session to continue, but you still need to clear the context, use the DBMS_SESSION.CLEAR_CONTEXT or the DBMS_SESSION.CLEAR_ALL_CONTEXT procedure. For example:
```
DBMS_SESSION.CLEAR_CONTEXT(namespace, client_identifier, attribute);
```
```
The `CLEAR_CONTEXT` procedure clears the context for the current user. To clear the context values for all users, for example, when you need to shut down the application server, use the `CLEAR_ALL_CONTEXT` procedure.
Global application context values are available until they are cleared, so you should use `CLEAR_CONTEXT` or `CLEAR_ALL_CONTEXT` to ensure that other sessions do not have access to these values.
```
## Related Topics
  - Global Application Context for Nondatabase Users
