# Creating a Package to Set a Database Session-Based Application Context

A PL/SQL package can be used to retrieve the session information and set the name-value attributes of the application context.
- About the Package That Manages the Database Session-Based Application Context This defines procedures that manage the session data represented by the application context.
- Using the SYS_CONTEXT Function to Retrieve Session Information You can retrieve session information for the application context by using the SYS_CONTEXT function.
````
- Checking the SYS_CONTEXT Settings You can check the SYS_CONTEXT settings, which are stored in the DUAL table.
- Dynamic SQL with SYS_CONTEXT During a session in which you expect a change in policy between executions of a given query, the query must use dynamic SQL.
- SYS_CONTEXT in a Parallel Query If you use SYS_CONTEXT inside a SQL function that is embedded in a parallel query, then the function includes the application context.
- SYS_CONTEXT with Database Links The SYS_CONTEXT function is compatible with the use of database links.
- DBMS_SESSION.SET_CONTEXT for Setting Session Information After SYS_CONTEXT retrieves the session data of a user, you can set the application context values from the user session.
- Example: Simple Procedure to Create an Application Context Value You can use the DBMS_SESSION.SET_CONTEXT statement in a procedure to set an application context value.
## About the Package That Manages the Database Session-Based Application Context
This defines procedures that manage the session data represented by the application context.
This package is usually created in the security administrator schema. The package must perform the following tasks:
****````````
- Retrieve session information. To retrieve the user session information, you can use the SYS_CONTEXT SQL function. The SYS_CONTEXT function returns the value of the parameter associated with the context namespace. You can use this function in both SQL and PL/SQL statements. Typically, you will use the built-in USERENV namespace to retrieve the session information of a user. You also can use the SYS_SESSION_ROLES namespace to indicate whether the specified role is currently enabled for the session.
****
  - If the value of the parameter in the namespace already has been set, then SET_CONTEXT overwrites this value.
  - Be aware that any changes in the context value are reflected immediately and subsequent calls to access the value through the SYS_CONTEXT function will return the most recent value.
****
- Be executed by users. After you create the package, the user will need to execute the package when he or she logs on. You can create a logon trigger to execute the package automatically when the user logs on, or you can embed this functionality in your applications. Remember that the application context session values are cleared automatically when the user ends the session, so you do not need to manually remove the session data.
It is important to remember that the procedure is a trusted procedure: It is designed to prevent the user from setting his or her own application context attribute values. The user runs the procedure, but the procedure sets the application context values, not the user.
## Using the SYS_CONTEXT Function to Retrieve Session Information
You can retrieve session information for the application context by using the `SYS_CONTEXT` function.
The `SYS_CONTEXT` function provides a default namespace, `USERENV`, which describes the current session of the user logged on. `SYS_CONTEXT` enables you to retrieve different types of session-based information about a user, such as the user host computer ID, host IP address, operating system user name, and so on. Remember that you only use `USERENV` to *retrieve* session data, not *set* it. The predefined attributes are listed in the description for the PL/SQL function in the *Oracle Database SQL Language Reference*.
- To use retrieve session information, set the namespace, parameter, and optionally, the length values of the SYS_CONTEXT function. For example:
```
SYS_CONTEXT ('USERENV','HOST')
```
The syntax for the PL/SQL function `SYS_CONTEXT` is as follows:
```
SYS_CONTEXT ('namespace','parameter'[,length])
```
In this specification:
**````
- namespace is the name of the application context. You can specify either a string or an expression that evaluates to a string. The SYS_CONTEXT function returns the value of parameter associated with the context namespace at the current instant. If the value of the parameter in the namespace already has been set, then SET_CONTEXT overwrites this value.
****
- parameter is a parameter within the namespace application context. This value can be a string or an expression.
**````````****````
- length is the default maximum size of the return type, which is 256 bytes, but you can override the length by specifying a value up to 4000 bytes. Enter a value that is a NUMBER data type, or a value that can be can be implicitly converted to NUMBER. The data type of the SYS_CONTEXT return type is a VARCHAR2. This setting is optional. Note: The USERENV application context namespace replaces the USERENV function provided in earlier Oracle Database releases.
## Checking the SYS_CONTEXT Settings
You can check the `SYS_CONTEXT` settings, which are stored in the `DUAL` table.
The `DUAL` table is a small table in the data dictionary that Oracle Database and user-written programs can reference to guarantee a known result. This table has one column called `DUMMY` and one row that contains the value `X`.
  ``````- To check the SYS_CONTEXT settings, issue a SELECT SQL statement on the DUAL table.
For example, to find the host computer on which you are logged, assuming that you are logged on to the `SHOBEEN_PC` host computer under `EMP_USERS`:
```
SELECT SYS_CONTEXT ('USERENV', 'HOST') FROM DUAL;
SYS_CONTEXT(USERENV,HOST)
-------------------------
EMP_USERS\SHOBEEEN_PC
```
## Dynamic SQL with SYS_CONTEXT
During a session in which you expect a change in policy between executions of a given query, the query must use dynamic SQL.
You must use dynamic SQL because static SQL and dynamic SQL parse statements differently:
- Static SQL statements are parsed at compile time. They are not parsed again at execution time for performance reasons.
- Dynamic SQL statements are parsed every time they are executed.
Consider a situation in which Policy A is in force when you compile a SQL statement, and then you switch to Policy B and run the statement. With static SQL, Policy A remains in force. Oracle Database parses the statement at compile time, but does not parse it again upon execution. With dynamic SQL, Oracle Database parses the statement upon execution, then the switch to Policy B takes effect.
For example, consider the following policy:
```
EMPLOYEE_NAME = SYS_CONTEXT ('USERENV', 'SESSION_USER')
```
The policy `EMPLOYEE_NAME` matches the database user name. It is represented in the form of a SQL predicate in Oracle Virtual Private Database: the predicate is considered a policy. If the predicate changes, then the statement must be parsed again to produce the correct result.
## SYS_CONTEXT in a Parallel Query
If you use `SYS_CONTEXT` inside a SQL function that is embedded in a parallel query, then the function includes the application context.
Consider a user-defined function within a SQL statement, which sets the user ID to 5:
```
CREATE FUNCTION set_id
 RETURN NUMBER IS
BEGIN
 IF SYS_CONTEXT ('hr', 'id') = 5
   THEN RETURN 1; ELSE RETURN 2;
 END IF;
END;
```
Now consider the following statement:
```
SELECT * FROM emp WHERE set_id( ) = 1;
```
When this statement is run as a parallel query, the user session, which contains the application context information, is propagated to the parallel execution servers (query child processes).
## SYS_CONTEXT with Database Links
The `SYS_CONTEXT` function is compatible with the use of database links.
When SQL statements within a user session involve database links, Oracle Database runs the `SYS_CONTEXT` function at the host computer of the database link, and then captures the context information in the host computer.
If remote PL/SQL procedure calls are run on a database link, then Oracle Database runs any `SYS_CONTEXT` function inside such a procedure at the destination database of the link.
In this case, only externally initialized application contexts are available at the database link destination site. For security reasons, Oracle Database propagates only the externally initialized application context information to the destination site from the initiating database link site.
## DBMS_SESSION.SET_CONTEXT for Setting Session Information
After `SYS_CONTEXT` retrieves the session data of a user, you can set the application context values from the user session.
To set the context values, you can use the `DBMS_SESSION.SET_CONTEXT` procedure. You must have the `EXECUTE` privilege for the `DBMS_SESSION` PL/SQL package.
The syntax for `DBMS_SESSION.SET_CONTEXT` is as follows:
```
DBMS_SESSION.SET_CONTEXT (
   namespace VARCHAR2,
   attribute VARCHAR2,
   value     VARCHAR2,
   username  VARCHAR2,
   client_id VARCHAR2);
```
In this specification:
  ````- namespace is the namespace of the application context to be set, limited to 30 bytes. For example, if you were using a namespace called custno_ctx, you would specify it as follows:
```
namespace => 'custno_ctx',
```
  ``````- attribute is the attribute of the application context to be set, limited to 30 bytes. For example, to create the ctx_attrib attribute for the custno_ctx namespace:
```
attribute => 'ctx_attrib',
```
  ````- value is the value of the application context to be set, limited to 4000 bytes. Typically, this is the value retrieved by the SYS_CONTEXT function and stored in a variable. For example:
```
value => ctx_value,
```
``````
````
- username is the database user name attribute of the application context. The default is NULL, which permits any user to access the session. For database session-based application contexts, omit this setting so that it uses the NULL default. This setting is optional. The username and client_id parameters are used for globally accessed application contexts. See DBMS_SESSION.SET_CONTEXT username and client_id Parameters for more information.
````````
- client_id is the application-specific client_id attribute of the application context (64-byte maximum). The default is NULL, which means that no client ID is specified. For database session-based application contexts, omit this setting so that it uses the NULL default.
## Example: Simple Procedure to Create an Application Context Value
You can use the DBMS_SESSION.SET_CONTEXT statement in a procedure to set an application context value.
Example 13-1 shows how to create a simple procedure that creates an attribute for the `empno_ctx` application context.
Example 13-1 Simple Procedure to Create an Application Context Value
```
CREATE OR REPLACE PROCEDURE set_empno_ctx_proc(
  emp_value IN VARCHAR2)
 IS
 BEGIN
  DBMS_SESSION.SET_CONTEXT('empno_ctx', 'empno_attrib', emp_value);
 END;
/
```
In this example:
``````
- emp_value IN VARCHAR2 takes emp_value as the input parameter. This parameter specifies the value associated with the application context attribute empno_attrib. The limit is 4000 bytes.
````
  - 'empno_ctx' refers to the application context namespace. Enclose its name in single quotation marks.
  - 'empno_attrib' creates the attribute associated with the application context namespace.
``````
  - emp_value specifies the value for the empno_attrib attribute. Here, it refers to the emp_value parameter.
At this stage, you can run the `set_empno_ctx_proc` procedure to set the application context:
```
EXECUTE set_empno_ctx_proc ('42783');
```
(In a real world scenario, you would set the application context values in the procedure itself, so that it becomes a trusted procedure. This example is only used to show how data can be set for demonstration purposes.)
To check the application context setting, run the following `SELECT` statement:
```
SELECT SYS_CONTEXT ('empno_ctx', 'empno_attrib') empno_attrib FROM DUAL;
EMPNO_ATTRIB
--------------
42783
```
You can also query the `SESSION_CONTEXT` data dictionary view to find all the application context settings in the current session of the database instance. For example:
```
SELECT * FROM SESSION_CONTEXT;
NAMESPACE                ATTRIBUTE          VALUE
--------------------------------------------------
EMPNO_CTX                EMP_ID             42783
```
## Related Topics
  **- Oracle Database SQL Language Reference for detailed information about the SYS_CONTEXT function
  - Tutorial: Creating and Using a Database Session-Based Application Context shows how to create a database session-based application context
  - Automatic Reparsing for Fine-Grained Access Control Policies Functions
  - Tutorial: Creating and Using a Database Session-Based Application Context for how to create a package that retrieves the user session information and then sets the application context based on this information
  **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the DBMS_SESSION.SET_CONTEXT procedure
  **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the DBMS_SESSION package
