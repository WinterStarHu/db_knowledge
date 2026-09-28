# About Application Contexts

An application context provides many benefits in controlling the access that a user has to data.
****
- What Is an Application Context? An application context is a set of name-value pairs that Oracle Database stores in memory.
- Components of the Application Context An application context has two components, comprising a name-value pair.
- Where Are the Application Context Values Stored? Oracle Database stores the application context values in a secure data cache.
- Benefits of Using Application Contexts Most applications contain the kind of information that can be used for application contexts.
- How Editions Affects Application Context Values Oracle Database sets the application context in all editions that are affected by the application context package.
- Application Contexts in a Multitenant Environment Where you create an application in a multitenant environment determines where you must create the application context.
## What Is an Application Context?
An **application context** is a set of name-value pairs that Oracle Database stores in memory.
The context has a label called a **namespace** (for example, `empno_ctx` for an application context that retrieves employee IDs). This context enables Oracle Database to find information about both database and nondatabase users during authentication.
Inside the context are the name-value pairs (an associative array): the name points to a location in memory that holds the value. An application can use the application context to access session information about a user, such as the user ID or other user-specific information, or a client ID, and then securely pass this data to the database.
You can then use this information to either permit or prevent the user from accessing data through the application. You can use application contexts to authenticate both database and non-database users.
## Components of the Application Context
An application context has two components, comprising a name-value pair.
These components are as follows:
****``````
- Name. Refers to the name of the attribute set that is associated with the value. For example, if the empno_ctx application context retrieves an employee ID from the HR.EMPLOYEES table, it could have a name such as employee_id.
****``````
- Value. Refers to a value set by the attribute. For example, for the empno_ctx application context, if you wanted to retrieve an employee ID from the HR.EMPLOYEES table, you could create a value called emp_id that sets the value for this ID.
Think of an application context as a global variable that holds information that is accessed during a database session. To set the values for a secure application context, you must create a PL/SQL package procedure that uses the `DBMS_SESSION.SET_CONTEXT` procedure. In fact, this is the only way that you can set application context values if the context is not marked `INITIALIZED EXTERNALLY` or `INITIALIZED GLOBALLY`. You can assign the values to the application context attributes at run time, not when you create the application context. Because the **trusted** procedure, and not the user, assigns the values, it is a called secure application context. For client-session based application contexts, another way to set the application context is to use Oracle Call Interface (OCI) calls.
## Where Are the Application Context Values Stored?
Oracle Database stores the application context values in a secure data cache.
This cache is available in the User Global Area (UGA) or the System (sometimes called “Shared”) Global Area (SGA). This way, the application context values are retrieved during the session. Because the application context stores the values in this data cache, it increases performance for your applications. You can use an application context by itself, with Oracle Virtual Private Databases policies, or with other fine-grained access control policies.
Application context values are maintained in memory for the current database session. They are not stored as persistent table data and are not propagated from a primary database to a standby database in an Oracle Data Guard configuration. If an application requires these context values on a standby database, then the application must explicitly set them in the standby session. For example, the application can invoke the appropriate procedure in the trusted PL/SQL package associated with the application context.
## Benefits of Using Application Contexts
Most applications contain the kind of information that can be used for application contexts.
For example, in an order entry application that uses a table containing the columns `ORDER_NUMBER` and `CUSTOMER_NUMBER`, you can use the values in these columns as security attributes to restrict access by a customer to his or her own orders, based on the ID of that customer.
Application contexts are useful for the following purposes:
- Enforcing fine-grained access control (for example, in Oracle Virtual Private Database polices)
- Preserving user identity across multitier environments
- Enforcing stronger security for your applications, because the application context is controlled by a trusted procedure, not the user
- Increasing performance by serving as a secure data cache for attributes needed by an application for fine-grained auditing or for use in PL/SQL conditional statements or loops This cache saves the repeated overhead of querying the database each time these attributes are needed. Because the application context stores session data in cache rather than forcing your applications to retrieve this data repeatedly from a table, it greatly improves the performance of your applications.
- Serving as a holding area for name-value pairs that an application can define, modify, and access
## How Editions Affects Application Context Values
Oracle Database sets the application context in all editions that are affected by the application context package.
The values the application context sets are visible in all editions the application context affects. To find all editions in your database, and whether they are usable, you can query the ALL_EDITIONS data dictionary view.
## Application Contexts in a Multitenant Environment
Where you create an application in a multitenant environment determines where you must create the application context.
If an application is installed in the application root or CDB root, then it becomes accessible across the application container or system container and associated application PDBs. You will need to create a common application context in this root.
When you create a common application context for use with an application container, note the following:
``````````````
- You can create application contexts in a multitenant environment by setting the CONTAINER clause in the CREATE CONTEXT SQL statement. For example, to create a common application context in the application root, you must execute CREATE CONTEXT with CONTAINER set to ALL. To create the application context in a PDB, set CONTAINER to CURRENT.
```
SELECT OBJECT_NAME FROM DBA_OBJECTS WHERE OBJECT_TYPE ='CONTEXT';
```
- You cannot use the same name for a local application context for a common application context. You can find the names of existing application contexts by running the following query:
- The PL/SQL package that you create to manage a common application context must be a common PL/SQL package. That is, it must exist in the application root or CDB root. If you create the application context for a specific PDB, then you must store the associated PL/SQL package in that PDB.
- The name-value pairs that you set under a common session application context from an application container or a system container for a common application context are not accessible from other application containers or system containers when a common user accesses a different container.
- The name-value pairs that you set under a common global application context from an application container or a system container, are accessible only within the same container in the same user session.
- An application can retrieve the value of an application context whether it resides in the application root, the CDB root, or a PDB.
- During a plug-in operation of a PDB into a CDB or an application container, if the name of the common application context conflicts with a PDB’s local application context, then the PDB must open in restricted mode. A database administrator would then need to correct the conflict before opening the PDB in normal mode.
- During an unplug operation, a common application context retains its common semantics, so that later on, if the PDB is plugged into another CDB where a common application context with the same name exists, it would continue to behave like a common object. If a PDB is plugged into an application container or a system container, where the same common application context does not exist, then it behaves like a local object.
To find if an application context is a local application context or an application common application context, query the `SCOPE` column of the `DBA_CONTEXT` or `ALL_CONTEXT` data dictionary view.
## Related Topics
  - Auditing Application Context Values
  - Oracle Virtual Private Database Use with an Application Context
  **- Oracle Database Development Guide for detailed information about editions
