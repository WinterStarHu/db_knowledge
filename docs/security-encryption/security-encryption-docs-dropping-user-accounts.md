# Dropping User Accounts

You can drop user accounts if the user is not in a session, and if the user has objects in the user’s schema.
- About Dropping User Accounts Before you drop a user account, you must ensure that you have the appropriate privileges for doing so.
- Terminating a User Session A user who is connected to a database cannot be dropped.
- About Dropping a User After the User Is No Longer Connected to the Database After a user is disconnected from the database, you can use the DROP USER statement to drop the user.
- Dropping a User Whose Schema Contains Objects Before you drop a user whose schema contains objects, carefully investigate the implications of dropping these schema objects.
## About Dropping User Accounts
Before you drop a user account, you must ensure that you have the appropriate privileges for doing so.
To drop a user account in any environment, you must have the `DROP USER` system privilege. In a multitenant environment, you must have the commonly granted `DROP USER` system privilege to drop common user accounts. To drop local user accounts, you must have a commonly granted `DROP USER` privilege or a locally granted `DROP USER` privilege in the PDB in which the local user account resides.
When you drop a user account, Oracle Database removes the user account and associated schema from the data dictionary. It also immediately drops all schema objects contained in the user schema, if any.
**Note:**
- If a user schema and associated objects must remain but the user must be denied access to the database, then revoke the CREATE SESSION privilege from the user.
````
- Do not attempt to drop the SYS or SYSTEM user. Doing so corrupts your database.
## Terminating a User Session
A user who is connected to a database cannot be dropped.
You must first terminate the user session (or the user can exit the session) before you can drop the user.
- Query the V$SESSION dynamic view to find the session ID of the user whose session you want to terminate. For example:
```
SELECT SID, SERIAL#, USERNAME FROM V$SESSION;
SID         SERIAL# USERNAME
------- --------------- ----------------------
127          55234  ANDY ...
```
````````
- Use the ALTER SYSTEM SQL statement to stop the session for the user, based on the SID and SERIAL# settings of the V$SESSION view. For example:
```
ALTER SYSTEM KILL SESSION '127, 55234';
```
## About Dropping a User After the User Is No Longer Connected to the Database
After a user is disconnected from the database, you can use the `DROP USER` statement to drop the user.
To drop a user and all the user schema objects (if any), you must have the `DROP USER` system privilege. Because the `DROP USER` system privilege is powerful, a security administrator is typically the only type of user that has this privilege.
If the schema of the user contains any dependent schema objects, then use the `CASCADE` option to drop the user and all associated objects and foreign keys that depend on the tables of the user successfully. If you do not specify `CASCADE` and the user schema contains dependent objects, then an error message is returned and the user is not dropped.
## Dropping a User Whose Schema Contains Objects
Before you drop a user whose schema contains objects, carefully investigate the implications of dropping these schema objects.
- Query the DBA_OBJECTS data dictionary view to find the objects that are owned by the user. For example:
```
SELECT OWNER, OBJECT_NAME FROM DBA_OBJECTS WHERE OWNER LIKE 'ANDY';
```
```
Enter the user name in capital letters. Pay attention to any unknown cascading effects. For example, if you intend to drop a user who owns a table, then check whether any views or procedures depend on that particular table.
```
````
- Use the DROP USER SQL statement with the CASCADE clause to drop the user and all associated objects and foreign keys that depend on the tables that the user owns. For example:
```
DROP USER andy CASCADE;
```
