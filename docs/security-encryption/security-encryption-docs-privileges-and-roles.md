# About Privileges and Roles

Authorization permits users to access, process, or alter data; it also creates limitations on user access or actions.
The limitations placed on (or removed from) users can apply to objects such as schemas, entire tables, or table rows.
A user **privilege** is the right to run a particular type of SQL statement, or the right to access an object that belongs to another user, run a PL/SQL package, and so on. The types of privileges are defined by Oracle Database.
**Roles** are created by users (usually administrators) to group together privileges or other roles. They are a way to facilitate the granting of multiple privileges or roles to users.
Privileges can fall into the following general categories:
****
- Administrative privileges. Administrative privileges are designed for commonly performed administrative tasks, such as performing backup and recovery operations. Oracle Database provides administrative privileges tailored to specific administrative tasks, such as the SYSKM administrative privilege for performing Transparent Data Encryption tasks.
****
- System privileges. System privileges enable users to perform actions on schema objects. Examples of a system privilege are the ability to create and update tables or tablespaces.
********
- Roles. A role groups several privileges and roles, so that they can be granted to and revoked from users simultaneously. You must enable the role for a user before the user can use it.
****
- Object privileges. Each type of object has privileges associated with it. Objects are schema objects, such as tables or indexes
****``````````````
- Table privileges. These privileges enable security at the DML (data manipulation language) or DDL (data definition language) level. DML operations are DELETE, INSERT, SELECT, and UPDATE operations on tables. DDL operations are ALTER, INDEX, and REFERENCES operations on tables and views.
****
- View privileges. You can apply DML object privileges to views, similar to tables.
****
- Procedure privileges. Procedures, including standalone procedures and functions, can be granted the EXECUTE privilege.
****
- Type privileges. You can grant system privileges to named types (object types, VARRAYs, and nested tables).
## Related Topics
  - Managing Administrative Privileges
  - Managing System Privileges
  - Managing Commonly and Locally Granted Privileges
