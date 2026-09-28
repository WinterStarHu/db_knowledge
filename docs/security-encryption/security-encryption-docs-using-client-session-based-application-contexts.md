# Using Client Session-Based Application Contexts

A client session-based application context is stored in the User Global Area (UGA).
- About Client Session-Based Application Contexts Oracle Call Interface (OCI) functions can set and clear the User Global Area (UGA) user session information.
- Setting a Value in the CLIENTCONTEXT Namespace Oracle Call Interface (OCI) can set the CLIENTCONTEXT namespace.
- Retrieving the CLIENTCONTEXT Namespace You can use Oracle Call Interface to retrieve the CLIEINTCONTEXT namespace.
- Example: Retrieving a Client Session ID Value for Client Session-Based Contexts The OCI OCIStmtExecute call can retrieve client session ID values for client session-based contexts.
- Clearing a Setting in the CLIENTCONTEXT Namespace You can use Oracle Call Interface to clear the CLIENTCONTEXT namespace.
- Clearing All Settings in the CLIENTCONTEXT Namespace You can use Oracle Call Interface (OCI) to clear the CLIENTCONTEXT namespace.
## About Client Session-Based Application Contexts
Oracle Call Interface (OCI) functions can set and clear the User Global Area (UGA) user session information.
The advantage of this type of application context in a session-based application context is that an individual application can check for specific nondatabase user session data, rather than having the database perform this task. Another advantage is that the calls to set the application context value are included in the next call to the server, which improves performance.
However, be aware that application context security is compromised with a client session-based application context: any application user can set the client application context, and no check is performed in the database.
You configure the client session-based application context for the client application only. You do not configure any settings on the database server to which the client connects. Any application context settings in the database server do not affect the client session-based application context.
To configure a client session-based application context, use the `OCIAppCtxSet` OCI function. A client session-based application context uses the `CLIENTCONTEXT` namespace, updatable by any OCI client or by the existing `DBMS_SESSION` package for application context. Oracle Database performs no privilege or package security checks for this type.
The `CLIENTCONTEXT` namespace enables a single application transaction to both change the user context information and use the same user session handle to service the new user request. You can set or clear individual values for attributes in the `CLIENTCONTEXT` namespace, or clear all their values.
``````
- An OCI client uses the OCIAppCtx function to set variable length data for the namespace, called OCISessionHandle. The OCI network single, round-trip transport sends all the information to the server in one round-trip. On the server side, you can query the application context information by using the SYS_CONTEXT SQL function on the namespace. For example:
- A JDBC client uses the oracle.jdbc.internal.OracleConnection function to achieve the same purposes.
Any user can set, clear, or collect the information in the `CLIENTCONTEXT` namespace, because it is not protected by package-based security.
## Setting a Value in the CLIENTCONTEXT Namespace
Oracle Call Interface (OCI) can set the `CLIENTCONTEXT` namespace.
  ````- To set a value in the CLIENTCONTEXT namespace, use the OCIAppCTXSet command, in the following syntax:
```
err = OCIAppCtxSet((void *) session_handle,(dvoid *)"CLIENTCONTEXT",(ub4) 13,
                   (dvoid *)attribute_name, length_of_attribute_name
                   (dvoid *)attribute_value, length_of_attribute_value, errhp,
                   OCI_DEFAULT);
```
In this specification:
**
- session_handle represents the OCISessionHandle namespace.
**````
- attribute_name is the name of the attribute. For example, responsibility, with a length of 14.
**````
- attribute_value is the value of the attribute. For example, manager, with a length of 7.
## Retrieving the CLIENTCONTEXT Namespace
You can use Oracle Call Interface to retrieve the `CLIEINTCONTEXT` namespace.
````
**
  - SELECT SYS_CONTEXT('CLIENTCONTEXT', 'attribute-1') FROM DUAL;
**
  - SELECT VALUE FROM SESSION_CONTEXT WHERE NAMESPACE='CLIENTCONTEXT' AND ATTRIBUTE='attribute-1';
The *attribute-1* value can be any attribute value that has already been set in the `CLIENTCONTEXT` namespace. Oracle Database only retrieves the set attribute; otherwise, it returns `NULL`. Typically, you set the attribute by using the `OCIAppCtxSet` call. In addition, you can embed a `DBMS_SESSION.SET_CONTEXT` call in the OCI code to set the attribute value.
## Example: Retrieving a Client Session ID Value for Client Session-Based Contexts
The OCI `OCIStmtExecute` call can retrieve client session ID values for client session-based contexts.
Example 13-10 shows how to use the `OCIStmtExecute` call to retrieve a client session ID value.
Example 13-10 Retrieving a Client Session ID Value for Client Session-Based Contexts
```
oratext    clientid[31];
OCIDefine  *defnp1 = (OCIDefine *) 0;
OCIStmt    *statementhndle;
oratext    *selcid = (oratext *)"SELECT SYS_CONTEXT('CLIENTCONTEXT', attribute) FROM  DUAL";
OCIStmtPrepare(statementhndle, errhp, selcid, (ub4) strlen((char *) selcid), (ub4) OCI_NTV_SYNTAX, (ub4) OCI_DEFAULT);
OCIDefineByPos(statementhndle, &defnp1, errhp, 1, (dvoid *)clientid, 31, SQLT_STR, (dvoid *) 0, (ub2 *) 0, (ub2 *) 0, OCI_DEFAULT);
OCIStmtExecute(servhndle, statementhndle, errhp, (ub4) 1, (ub4) 0, (CONST OCISnapshot *) NULL, (OCISnapshot *) NULL, OCI_DEFAULT);
printf("CLIENT_IDENTIFIER = %s \n", clientid);
```
In this example:
````````````
- oratext, OCIDefine, OCIStmt, and oratext create variables to store the client session ID, reference call for OCIDefine, the statement handle, and the SELECT statement to use.
````
- OCIStmtPrepare prepares the statement selcid for execution.
````
- OCIDefineByPos defines the output variable clientid for client session ID.
````
- OCIStmtExecute executes the statement in the selcid variable.
- printf prints the formatted output for the retrieved client session ID.
## Clearing a Setting in the CLIENTCONTEXT Namespace
You can use Oracle Call Interface to clear the `CLIENTCONTEXT` namespace.
````
  - The following command sets the empty string to zero:
```
(void) OCIAppCtxSet((void *) session_handle, (dvoid *)"CLIENTCONTEXT", 13,
                   (dvoid *)attribute_name, length_of_attribute_name,
                   (dvoid *)0, 0,errhp
                   OCI_DEFAULT);
```
  - This following command sets the empty string to a blank value:
```
(void) OCIAppCtxSet((void *) session_handle, (dvoid *)"CLIENTCONTEXT", 13
                   (dvoid *)attribute_name, length_of_attribute_name,
                   (dvoid *)"", 0,errhp,
                   OCI_DEFAULT);
```
## Clearing All Settings in the CLIENTCONTEXT Namespace
You can use Oracle Call Interface (OCI) to clear the `CLIENTCONTEXT` namespace.
  - To clear the namespace, use the OCIAppCtxClearAll command in the following form:
```
err = OCIAppCtxClearAll((void *) session_handle,
                       (dvoid *)"CLIENTCONTEXT", 13,
                        errhp,                        OCI_DEFAULT);
```
## Related Topics
**- Oracle Call Interface Programmer’s Guide for more information about client application contexts **- Oracle Call Interface Programmer’s Guide for details about the OCIAppCtx function
