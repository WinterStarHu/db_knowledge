# Creating Database Session-Based Application Contexts

A database session-based application context is a named object that stores the user’s session information.
- About Creating Database Session-Based Application Contexts A database user session (UGA) stores session-based application context, using a user-created namespace.
````
- Creating a Database Session-Based Application Context The CREATE CONTEXT SQL statement can be used to create a database session-based application context.
- Database Session-Based Application Contexts for Multiple Applications For each application, you can create an application context that has its own attributes.
## About Creating Database Session-Based Application Contexts
A database user session (UGA) stores session-based application context, using a user-created namespace.
Each application context must have a unique attribute and belong to a namespace. That is, context names must be unique within the database, not just within a schema.
You must have the `CREATE ANY CONTEXT` system privilege to create an application context, and the `DROP ANY CONTEXT` privilege to use the `DROP CONTEXT` statement if you want to drop the application context.
The ownership of the application context is as follows: Even though a user who has been granted the `CREATE ANY CONTEXT` and `DROP ANY CONTEXT` privileges can create and drop the application context, it is owned by the `SYS` schema. Oracle Database associates the context with the schema account that created it, but if you drop this user, the context still exists in the `SYS` schema. As user `SYS`, you can drop the application context.
You can find the names of existing application contexts by running the following query:
```
SELECT OBJECT_NAME FROM DBA_OBJECTS WHERE OBJECT_TYPE ='CONTEXT';
```
## Creating a Database Session-Based Application Context
The `CREATE` `CONTEXT` SQL statement can be used to create a database session-based application context.
When you create a database session-based application context, you must create a namespace for the application context and then associate it with a PL/SQL package that manages the name-value pair that holds the session information of the user. At the time that you create the context, the PL/SQL package does not need to exist, but it must exist at run time.
````
- To create a database session-based application context, use the CREATE CONTEXT SQL statement. For example:
```
CREATE CONTEXT empno_ctx USING set_empno_ctx_pkg CONTAINER = CURRENT;
```
In this example:
- empno_ctx is the context namespace.
````
- set_empno_ctx_pkg is the package (which does not need to exist when you create the context) that sets attributes for the empno_ctx namespace.Step 3: Create a Package to Retrieve Session Data and Set the Application Context shows an example of how to create a package that can be used with this application context.
``````
- CONTAINER creates the application context in the current PDB. To create the application context in the application or CDB root, you must set CONTAINER to ALL.
Notice that when you create the context, you do not set its name-value attributes in the `CREATE CONTEXT` statement. Instead, you set these in the PL/SQL package that you associate with the application context. The reason you must do this is to prevent a malicious user from changing the context attributes without proper attribute validation. Ensure that this package is in the same container as the application context. For example, if you created the application context in a PDB, then the PL/SQL package must reside in that PDB.
**Note:**   You cannot create a context called `CLIENTCONTEXT`. This word is reserved for use with client session-based application contexts. See Using Client Session-Based Application Contexts for more information about this type of application context.
## Database Session-Based Application Contexts for Multiple Applications
For each application, you can create an application context that has its own attributes.
Suppose, for example, you have three applications: General Ledger, Order Entry, and Human Resources.
You can specify different attributes for each application:
- For the order entry application context, you could specify the attribute CUSTOMER_NUMBER.
````
- For the general ledger application context, you could specify the attributes SET_OF_BOOKS and TITLE.
``````
- For the human resources application context, you could specify the attributes ORGANIZATION_ID, POSITION, and COUNTRY.
The data the attributes access is stored in the tables behind the applications. For example, the order entry application uses a table called `OE.CUSTOMERS`, which contains the `CUSTOMER_NUMBER` column, which provides data for the `CUSTOMER_NUMBER` attribute. In each case, you can adapt the application context to your precise security needs.
