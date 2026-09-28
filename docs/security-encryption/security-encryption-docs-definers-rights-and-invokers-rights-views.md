# Definer’s Rights and Invoker’s Rights in Views

The `BEQEATH` clause in the `CREATE VIEW` SQL statement can control definer’s rights and invoker’s rights in user-created views.
- About Controlling Definer’s Rights and Invoker’s Rights in Views You can configure user-defined views to accommodate invoker’s rights functions that are referenced in the view.
- Using the BEQUEATH Clause in the CREATE VIEW Statement The BEQUEATH controls how an invoker’s right function can be executed using the rights of the invoking user.
- Finding the User Name or User ID of the Invoking User PL/SQL functions can be used to find the invoking user, based on whether invoker’s rights or definer’s rights are being used.
````
- Finding BEQUEATH DEFINER and BEQUEATH_CURRENT_USER Views You can find out if a view is a BEQUEATH DEFINER or BEQUEATH CURRENT_USER view.
## About Controlling Definer’s Rights and Invoker’s Rights in Views
You can configure user-defined views to accommodate invoker’s rights functions that are referenced in the view.
When a user invokes an identityor privilege-sensitive SQL function or an invoker’s rights PL/SQL or Java function, then current schema, current user, and currently enabled roles within the operation’s execution can be inherited from the querying user’s environment, rather than being set to the owner of the view.
This configuration does not turn the view itself into an invoker’s rights object. Name resolution within the view is still handled using the view owner’s schema, and privilege checking for the view is done using the view owner’s privileges. However, at runtime, the function referenced by view runs under the invoking user’s privileges rather than those of the view owner’s.
The benefit of this feature is that it enables functions such as `SYS_CONTEXT` and `USERENV`, which must return information accurate for the invoking user, to return consistent results when these functions are referenced in a view.
## Using the BEQUEATH Clause in the CREATE VIEW Statement
The `BEQUEATH` controls how an invoker’s right function can be executed using the rights of the invoking user.
To enable an invoker’s rights function to be executed using the rights of the user issuing SQL that references the view, in the `CREATE VIEW` statement, you can set the `BEQUEATH` clause to `CURRENT_USER`.
If you plan to issue a SQL query or DML statement against the view, then the view owner must be granted the `INHERIT` `PRIVILEGES` privilege on the invoking user or the view owner must have the `INHERIT ANY PRIVILEGES` privilege. If not, then when a `SELECT` query or DML statement involves a `BEQUEATH` `CURRENT_USER` view, the run-time system will raise error `ORA-06598: insufficient INHERIT PRIVILEGES privilege`.
  - Use the use BEQUEATH CURRENT_USER clause to set the view’s function to be executed using invoker’s rights.
For example:
```
CREATE VIEW MY_OBJECTS_VIEW BEQUEATH CURRENT_USER AS SELECT GET_OBJS_FUNCTION;
```
If you want the function within the view to be executed using the view owner’s rights, then you should either omit the `BEQUEATH` clause or set it to `DEFINER`.
For example:
```
CREATE VIEW my_objects_view BEQUEATH DEFINER AS SELECT OBJECT_NAME FROM USER_OBJECTS;
```
## Finding the User Name or User ID of the Invoking User
PL/SQL functions can be used to find the invoking user, based on whether invoker’s rights or definer’s rights are being used.
````
``````
  - ORA_INVOKING_USER: Use this function to return the name of the user who is invoking the current statement or view. This function treats the intervening views as specified by their BEQUEATH clauses. If the invoking user is an Oracle Database Real Application Security-defined user, then this function returns XS$NULL.
````
  - ORA_INVOKING_USERID: Use this function to return the identifier (ID) of the user who is invoking the current statement or view. This function treats the intervening views as specified by their BEQUEATH clauses. If the invoking user is an Oracle Database Real Application Security-defined user, then this function returns an ID that is common to all Real Application Security sessions but is different from the ID of any database user. For example:
```
CONNECT HR
Enter password: password
SELECT ORA_INVOKING_USER FROM DUAL;
ORA_INVOKING_USER
--------------------
HR
```
## Finding BEQUEATH DEFINER and BEQUEATH_CURRENT_USER Views
You can find out if a view is a `BEQUEATH DEFINER` or `BEQUEATH CURRENT_USER` view.
  ``````````- To find if a view is BEQUEATH DEFINER or BEQUEATH CURRENT_USER view, query the BEQUEATH column of a *_VIEWS or *_VIEWS_AE static data dictionary view for that view.
## Related Topics
  - Controlling Invoker's Rights Privileges for Procedure Calls and View Access for more information about how the INHERIT PRIVILEGE privilege works
  **``````````- Oracle Database SQL Language Reference for additional information about granting the INHERIT PRIVILEGES and INHERIT ANY PRIVILEGES privileges
  **- Oracle Database Real Application Security Administrator’s and Developer’s Guide for information about how to use BEQUEATH CURRENT_USER views with Oracle Database Real Application Security applications
  **- Oracle Database Real Application Security Administrator’s and Developer’s Guide for information about similar functions that are used for Oracle Database Real Application Security applications
  **- Oracle Database Reference for more information about *_VIEWS static data dictionary views
  **````- Oracle Database Reference for more information about *_VIEWS_AE static data dictionary views For example: SELECT BEQUEATH FROM USER_VIEWS WHERE VIEW_NAME = 'MY_OBJECTS'; BEQUEATH ------------ CURRENT_USER
