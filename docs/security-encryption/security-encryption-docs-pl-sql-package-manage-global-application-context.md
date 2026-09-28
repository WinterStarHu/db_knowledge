# PL/SQL Package to Manage a Global Application Context

The `DBMS_SESSION` PL/SQL package to manages global application contexts.
- About the Package That Manages the Global Application Context The package that is associated with a global application context uses the DBMS_SESSION package to set and clear the global application context values.
- How Editions Affects the Results of a Global Application Context PL/SQL Package Global application context packages, Oracle Virtual Private Database packages, and fine-grained audit policies can be used across multiple editions.
``````
- DBMS_SESSION.SET_CONTEXT username and client_id Parameters The DBMS_SESSION.SYS_CONTEXT procedure provides the client_id and username parameters, to be used for global application contexts.
- Sharing Global Application Context Values for All Database Users You can share global application values for all database users to give them access to data in the database.
- Example: Package to Manage Global Application Values for All Database Users The CREATE PACKAGE statement can manage global application values for all database users.
- Global Contexts for Database Users Who Move Between Applications A global application context can be used for database users who move between application, even when the applications have different access requirements.
- Global Application Context for Nondatabase Users When a nondatabase user starts a client session, the application server generates a client session ID.
- Example: Package to Manage Global Application Context Values for Nondatabase Users The CREATE PACKAGE statement can manage global application context values for nondatabase users.
- Clearing Session Data When the Session Closes The application context exists within memory, so when the user exits a session, either by switching to another session or ending the current session, you must clear the client_identifier context value.
## About the Package That Manages the Global Application Context
The package that is associated with a global application context uses the `DBMS_SESSION` package to set and clear the global application context values.
You must have the `EXECUTE` privilege for the `DBMS_SESSION` package before you use its procedures. Typically, you create and store this package in the database schema of a security administrator. The `SYS` schema owns the `DBMS_SESSION` package.
Unlike PL/SQL packages used to set a local application context, you do not include a `SYS_CONTEXT` function to get the user session data. You do not need to include this function because the owner of the session, recorded in the `USERENV` context, is the same for every user who is connecting.
You can run the procedures within the PL/SQL package for a global application context at any time. You do not need to create logon and logoff triggers to execute the package procedures associated with the global application context. A common practice is to run the package procedures from within the database application. Additionally, for nondatabase users, you use middle-tier applications to get and set client session IDs.
## How Editions Affects the Results of a Global Application Context PL/SQL Package
Global application context packages, Oracle Virtual Private Database packages, and fine-grained audit policies can be used across multiple editions.
Follow these guidelines:
****``````````
- If you want to have the PL/SQL package results be the same across all editions. To do so, create the package in the schema of a user who has not been editions enabled. To find users who are not editions enabled, you can query the DBA_USERS and USER_USERS data dictionary views. Remember that SYS, SYSTEM, and other default Oracle Database administrative accounts that are listed in the DBA_REGISTRY data dictionary view are not and cannot be editions enabled.
****
  - The package must use a new application context.
  - The package must encode input values using a different scheme.
  - The package must apply different validation rules for users logging in to the database.
For PL/SQL packages that set a global application context, use a single getter function to wrap the primitive `SYS_CONTEXT` calls that will read the key-value application context pairs. You can put this getter function in the same package as the application context setter procedure. This approach lets you tag the value for the application context key to reflect a relevant concept. For example, the tag can be the edition in which the setter function is actual. Or, it can be the current edition of the session that set the context, which you can find by using `SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME')`. This tag can be any specific notion to which the setter function applies.
## DBMS_SESSION.SET_CONTEXT username and client_id Parameters
The `DBMS_SESSION.SYS_CONTEXT` procedure provides the `client_id` and `username` parameters, to be used for global application contexts.
The following table explains how the combination of these settings controls the type of global application context you can create.

| Combination Settings | Result |
|---|---|
| username set to a value and client_id set to NULL | This combination enables an application context to be accessed by multiple sessions, as long as the username setting is the same throughout. Ensure that the user name specified is a valid database user. See Global Contexts for Database Users Who Move Between Applications for more information. |
| username set to a value and client_id set to NULL | This combination enables an application context to be accessed by multiple sessions, as long as the username setting is the same throughout. Ensure that the user name specified is a valid database user. See Global Contexts for Database Users Who Move Between Applications for more information. |
| username set to NULL and client_id set to a value | This combination enables an application to be accessed by multiple user sessions, as long as the client_id parameter is set to the same value throughout. This enables sessions of all users to see the application context values. |
| username set to a value and client_id set to a value | This combination enables the following two scenarios: Lightweight users. If the user does not have a database account, the username specified is a connection pool owner. The client_id setting is then associated with the nondatabase user who is logging in. Database users. If the user is a database user, this combination can be used for stateless Web sessions. Setting the username parameter in the SET_CONTEXT procedure to USER calls the Oracle Database-supplied USER function. The USER function specifies the session owner from the application context retrieval process and ensures that only the user who set the application context can access the context. See Oracle Database SQL Language Reference for more information about the USER function. See Global Application Context for Nondatabase Users for more information. |

## Sharing Global Application Context Values for All Database Users
You can share global application values for all database users to give them access to data in the database.
  ````````- To share global application values for all database users, set the namespace, attribute, and value parameters in the SET_CONTEXT procedure.
## Example: Package to Manage Global Application Values for All Database Users
The `CREATE PACKAGE` statement can manage global application values for all database users.
Example 13-7 shows how to create a package that sets and clears a global application context for all database users.
Example 13-7 Package to Manage Global Application Values for All Database Users
```
CREATE OR REPLACE PACKAGE hr_ctx_pkg
   AS
    PROCEDURE set_hr_ctx(sec_level IN VARCHAR2);
    PROCEDURE clear_hr_context;
   END;
  /
  CREATE OR REPLACE PACKAGE BODY hr_ctx_pkg
   AS
    PROCEDURE set_hr_ctx(sec_level IN VARCHAR2)
    AS
    BEGIN
     DBMS_SESSION.SET_CONTEXT(
      namespace  => 'global_hr_ctx',
      attribute  => 'job_role',
      value      => sec_level);
     END set_hr_ctx;
  PROCEDURE clear_hr_context
    AS
    BEGIN
     DBMS_SESSION.CLEAR_CONTEXT('global_hr_ctx', 'job_role');
    END clear_context;
  END;
 /
```
In this example:
``````````````
``````
- DBMS_SESSION.SET_CONTEXT ... END set_hr_ctx uses the DBMS_SESSION.SET_CONTEXT procedure to set values for the namespace, attribute, and value parameters. The sec_level value is specified when the database application runs the hr_ctx_pkg.set_hr_ctx procedure. The username and client_id values are not set, hence, they are NULL. This enables all users (database users) to have access to the values, which is appropriate for server-wide settings.
````````
- namespace => 'global_hr_ctx' sets the namespace to global_hr_ctx, in the SET_CONTEXT procedure.
````
- attribute => 'job_role' creates the job_role attribute.
``````
- value => sec_level sets the value for the job_role attribute to sec_level.
````
- PROCEDURE clear_hr_context creates the clear_hr_context procedure to clear the context values. See Clearing Session Data When the Session Closes for more information.
Typically, you execute this procedure within a database application. For example, if all users logging in are clerks, and you want to use “clerk” as a security level, you would embed a call within a database application similar to the following:
```
BEGIN
 hr_ctx_pkg.set_hr_ctx('clerk');
END;
/
```
If the procedure successfully completes, then you can check the application context values as follows:
```
SELECT SYS_CONTEXT('global_hr_ctx', 'job_role') job_role FROM DUAL;
JOB_ROLE
-----------
clerk
```
You can clear the global application context values for all database users by running the following procedure:
```
BEGIN
 hr_ctx_pkg.clear_hr_context;
END;
/
```
To check that the global context value is really cleared, the following `SELECT` statement should return no values:
```
SELECT SYS_CONTEXT('global_hr_ctx', 'job_role') job_role FROM DUAL;
JOB_ROLE
-----------
```
If Oracle Database returns error messages saying that you have insufficient privileges, then ensure that you have correctly created the global application context. You should also query the `DBA_CONTEXT` database view to ensure that your settings are correct, for example, that you are calling the procedure from the schema in which you created it.
If `NULL` is returned, then you may have inadvertently set a client identifier. To clear the client identifier, run the following procedure:
```
EXEC DBMS_SESSION.CLEAR_IDENTIFIER;
```
## Global Contexts for Database Users Who Move Between Applications
A global application context can be used for database users who move between application, even when the applications have different access requirements.
To do so, you must include the `username` parameter in the `DBMS_SESSION.SET_CONTEXT` procedure.
This parameter specifies that the same schema be used for all sessions.
You can use the following `DBMS_SESSION.SET_CONTEXT` parameters:
- namespace
- attribute
- value
- username
Oracle Database matches the `username` value so that the other application can recognize the application context. This enables the user to move between applications.
By omitting the `client_id` setting, its value is `NULL`, the default. This means that values can be seen by multiple sessions if the `username` setting is the same for a database user who maintains the same context in different applications. For example, you can have a suite of applications that control user access with Oracle Virtual Private Database policies, with each user restricted to a job role.
Example 13-8 demonstrates how to set the `username` parameter so that a specific user can move between applications. The use of the `username` parameter is indicated in **bold** typeface.
Example 13-8 Package for Global Application Context Values for Moving Between Applications
```
CREATE OR REPLACE PACKAGE hr_ctx_pkg
  AS
    PROCEDURE set_hr_ctx(sec_level IN VARCHAR2, **user_name IN VARCHAR2);**
    PROCEDURE clear_hr_context;
   END;
  /
  CREATE OR REPLACE PACKAGE BODY hr_ctx_pkg
   AS
    PROCEDURE set_hr_ctx(sec_level IN VARCHAR2, **user_name IN VARCHAR2)**
    AS
     BEGIN
      DBMS_SESSION.SET_CONTEXT(
       namespace  => 'global_hr_ctx',
       attribute  => 'job_role',
       value      => sec_level,
**username   => user_name);**
      END set_hr_ctx;
   PROCEDURE clear_hr_context
    AS
     BEGIN
      DBMS_SESSION.CLEAR_CONTEXT('global_hr_ctx');
     END clear_context;
  END;
 /
```
Typically, you execute this procedure within a database application by embedding a call similar to the following example. Ensure that the value for the `user_name` parameter (`scott` in this case) is a valid database user name.
```
BEGIN
 hr_ctx_pkg.set_hr_ctx('clerk', 'scott');
END;
```
A secure way to manage this type of global application context is within your applications, embed code to grant a secure application role to the user. This code should include `EXECUTE` permissions on the trusted PL/SQL package that sets the application context. In other words, the application, not the user, will set the context for the user.
## Global Application Context for Nondatabase Users
When a nondatabase user starts a client session, the application server generates a client session ID.
A nondatabase user is a user who is not known to the database, such as a Web application user.
Once this ID is set on the application server, it must be passed to the database server side. You can do this by using the `DBMS_SESSION.SET_IDENTIFIER` procedure to set the client session ID.
To set the context, you can set the `client_id` parameter in the `DBMS_SESSION.SET_CONTEXT` procedure, in a PL/SQL procedure on the server side. This enables you to manage the application context globally, yet each client sees only his or her assigned application context.
The `client_id` value is the key here to getting and setting the correct attributes for the global application context. Remember that the client identifier is controlled by the middle-tier application, and once set, it remains open until it is cleared.
A typical way to manage this type of application context is to place the `session_id` value (`client_identifier`) in a cookie, and send it to the end user’s HTML page so that is returned on the next request. A lookup table in the application should also keep client identifiers so that they are prevented from being reused for other users and to implement an end-user session time out.
For nondatabase users, configure the following `SET_CONTEXT` parameters:
- namespace
- attribute
- value
- username
- client_id
## Example: Package to Manage Global Application Context Values for Nondatabase Users
The `CREATE PACKAGE` statement can manage global application context values for nondatabase users.
Example 13-9 shows how to create a package that manages this type of global application context.
Example 13-9 Package to Manage Global Application Context Values for Nondatabase Users
```
CREATE OR REPLACE PACKAGE hr_ctx_pkg
  AS
   PROCEDURE set_session_id(session_id_p IN NUMBER);
   PROCEDURE set_hr_ctx(sec_level_attr IN VARCHAR2,
      sec_level_val IN VARCHAR2);
   PROCEDURE clear_hr_session(session_id_p IN NUMBER);
   PROCEDURE clear_hr_context;
  END;
/
  CREATE OR REPLACE PACKAGE BODY hr_ctx_pkg
   AS
    session_id_global NUMBER;
  PROCEDURE set_session_id(session_id_p IN NUMBER)
   AS
   BEGIN
    session_id_global := session_id_p;
    DBMS_SESSION.SET_IDENTIFIER(session_id_p);
  END set_session_id;
  PROCEDURE set_hr_ctx(sec_level_attr IN VARCHAR2,
     sec_level_val IN VARCHAR2)
   AS
   BEGIN
    DBMS_SESSION.SET_CONTEXT(
     namespace  => 'global_hr_ctx',
     attribute  => sec_level_attr,
     value      => sec_level_val,
     username   => USER,
     client_id  => session_id_global);
   END set_hr_ctx;
  PROCEDURE clear_hr_session(session_id_p IN NUMBER)
   AS
   BEGIN
      DBMS_SESSION.SET_IDENTIFIER(session_id_p);
      DBMS_SESSION.CLEAR_IDENTIFIER;
   END clear_hr_session;
  PROCEDURE clear_hr_context
  AS
  BEGIN
   DBMS_SESSION.CLEAR_CONTEXT('global_hr_ctx', session_id_global);
  END clear_hr_context;
 END;
 /
```
In this example:
``````
- session_id_global NUMBER creates the session_id_global variable, which will hold the client session ID. The session_id_global variable is referenced throughout the package definition, including the procedure that creates the global application context attributes and assigns them values. This means that the global application context values will always be associated with this particular session ID.
``````
- PROCEDURE set_session_id ... END set_session_id creates the set_session_id procedure, which writes the client session ID to the session_id_global variable.
````
````````**
````
````````````````
  - username => USER specifies the username value. This example sets it by calling the Oracle Database-supplied USER function, which adds the session owner from the context retrieval process. The USER function ensures that only the user who set the application context can access the context. See Oracle Database SQL Language Reference for more information about the USER function. If you had specified NULL (the default for the username parameter), then any user can access the context. Setting both the username and client_id values enables two scenarios. For lightweight users, set the username parameter to a connection pool owner (for example, APPS_USER), and then set client_id to the client session ID. If you want to use a stateless Web session, set the user_name parameter to the same database user who has logged in, and ensure that this user keeps the same client session ID. See DBMS_SESSION.SET_CONTEXT username and client_id Parameters for an explanation of how different username and client_id settings work.
````````````
  - client_id => session_id_global specifies client_id value. This example sets it to the session_id_global variable. This associates the context settings defined here with a specific client session ID, that is, the one that is set when you run the set_session_id procedure. If you specify the client_id parameter default, NULL, then the global application context settings could be used by any session.
````````````
- PROCEDURE clear_hr_session ... END clear_hr_session creates the clear_hr_session procedure to clear the client session identifier. The AS clause sets it to ensure that you are clearing the correct session ID, that is, the one stored in variable session_id_p defined in the CREATE OR REPLACE PACKAGE BODY hr_ctx_pkg procedure.
``````
- PROCEDURE clear_hr_context ... END clear_hr_context creates the clear_hr_context procedure, so that you can clear the context settings for the current user session, which were defined by the global_hr_ctx variable. See Clearing Session Data When the Session Closes for more information.
## Clearing Session Data When the Session Closes
The application context exists within memory, so when the user exits a session, either by switching to another session or ending the current session, you must clear the `client_identifier` context value.
This releases memory and prevents other users from accidentally using any left over values.
****  - Clearing the client identifier when a user exits a session. Use the DBMS_SESSION.CLEAR_IDENTIFIER procedure. For example:
```
EXEC DBMS_SESSION.CLEAR_IDENTIFIER;
```
****
  - DBMS_SESSION.CLEAR_CONTEXT clears the context for the current user. For example:
```
EXEC DBMS_SESSION.CLEAR_CONTEXT('my_ctx', 'my_client_id', 'my_attribute');
```
```
- `DBMS_SESSION.CLEAR_ALL_CONTEXT` clears the context values for all users, for example, when you need to shut down the application server. For example:
```
```
EXEC DBMS_SESSION.CLEAR_ALL_CONTEXT('my_ctx');
```
```
Global application context values are available until they are cleared, so you should use `DBMS_SESSION.CLEAR_CONTEXT` or `DBMS_SESSION.CLEAR_ALL_CONTEXT` to ensure that other sessions do not have access to these values. Be aware that any changes in the context value are reflected immediately and subsequent calls to access the value through the `SYS_CONTEXT` function will return the most recent value.
```
## Related Topics
  **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the DBMS_SESSION package
  **- Oracle Database Development Guide for detailed information about editions
  - Example: Package to Manage Global Application Values for All Database Users
  - Tutorial: Creating a Global Application Context That Uses a Client Session ID
  - Step 2: Set the Client Session ID Using a Middle-Tier Application
  - Using Client Identifiers to Identify Application Users Unknown to the Database
