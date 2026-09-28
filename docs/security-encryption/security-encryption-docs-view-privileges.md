# View Privileges

You can apply DML object privileges to views, similar to tables.
- Privileges Required to Create Views To create a view, you must have specific privileges.
- Privileges to Query Views in Other Schemas A view owner must be granted SELECT WITH GRANT OPTION on the base table of their view before users can query the view from a schema that is different from the schema in which the view is located.
- The Use of Views to Increase Table Security Database views can increase table security by restricting the data that users can see.
## Privileges Required to Create Views
To create a view, you must have specific privileges.
Object privileges for a view allow various DML operations, which affect the base tables from which the view is derived.
These privileges to create a view are as follows:
````
  - The CREATE VIEW system privilege (to create a view in your schema)
``````
  - The CREATE ANY VIEW system privilege (to create a view in the schema of another user)
````````
  - The SELECT, INSERT, UPDATE, or DELETE object privileges on all base objects underlying the view
````````````````````````
  - The SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, or DELETE ANY TABLE system privileges
``````````****
- In addition, before you can grant other users access to you view, you must have object privileges to the base objects with the GRANT OPTION clause or appropriate system privileges with the ADMIN OPTION clause. If you do not have these privileges, then you cannot to grant other users access to your view. If you try, an ORA-01720: grant option does not exist for object_name error is raised, with object_name referring to the view’s underlying object for which you do not have the sufficient privilege.
## Privileges to Query Views in Other Schemas
A view owner must be granted `SELECT WITH GRANT OPTION` on the base table of their view before users can query the view from a schema that is different from the schema in which the view is located.
## The Use of Views to Increase Table Security
Database views can increase table security by restricting the data that users can see.
To use a view, the user must have the appropriate privileges but only for the view itself, not its underlying objects. However, if access privileges for the underlying objects of the view are removed, then the user no longer has access.
This behavior occurs because the security domain that is used when a user queries the view is that of the definer of the view. If the privileges on the underlying objects are revoked from the view’s definer, then the view becomes invalid, and no one can use the view. Therefore, even if a user has been granted access to the view, the user may not be able to use the view if the definer’s rights have been revoked from the view’s underlying objects.
For example, suppose User A creates a view. User A has definer’s rights on the underlying objects of the view. User A then grants the `SELECT` privilege on that view to User B so that User B can query the view. But if User A no longer has access to the underlying objects of that view, then User B no longer has access either.
Views add two more levels of security for tables, column-level security and value-based security, as follows:
  ****````````- A view can provide access to selected columns of base tables. For example, you can define a view on the employees table to show only the employee_id, last_name, and manager_id columns:
```
CREATE VIEW employees_manager AS SELECT last_name, employee_id, manager_id FROM employees;
```
  ****- A view can provide value-based security for the information in a table. A WHERE clause in the definition of a view displays only selected rows of base tables. Consider the following two examples:
```
CREATE VIEW lowsal AS SELECT * FROM employees WHERE salary < 10000;
```
The `lowsal` view allows access to all rows of the `employees` table that have a salary value less than 10000. Notice that all columns of the `employees` table are accessible in the `lowsal` view.
```
CREATE VIEW own_salary AS SELECT last_name, salary FROM employees WHERE last_name = USER;
```
In the `own_salary` view, only the rows with an `last_name` that matches the current user of the view are accessible. The `own_salary` view uses the `user `pseudo column, whose values always refer to the current user. This view combines both column-level security and value-based security.
## Related Topics
  **- Oracle Database SQL Language Reference
