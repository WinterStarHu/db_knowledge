# Restricting SQL*Plus Users from Using Database Roles

You should restrict SQL*Plus users from using database roles, which helps to safeguard the database from intruder attacks.
- Potential Security Problems of Using Ad Hoc Tools Ad hoc tools can pose problems if malicious users have access to such tools.
````**
- How the PRODUCT_USER_PROFILE System Table Can Limit Roles The SYSTEM schema PRODUCT_USER_PROFILE table can disable SQL and SQLPlus commands in the SQLPlus environment for each user.
- How Stored Procedures Can Encapsulate Business Logic Stored procedures encapsulate privileges use with business logic so that privileges are only exercised in the context of a well-formed business transaction.
## Potential Security Problems of Using Ad Hoc Tools
Ad hoc tools can pose problems if malicious users have access to such tools.
Prebuilt database applications explicitly control the potential actions of a user, including the enabling and disabling of user roles while using the application. By contrast, ad hoc query tools such as SQL*Plus, permit a user to submit any SQL statement (which may or may not succeed), including enabling and disabling a granted role.
Potentially, an application user can exercise the privileges attached to that application to issue destructive SQL statements against database tables by using an ad hoc tool.
For example, consider the following scenario:
- The Vacation application has a corresponding vacation role.
````````````
- The vacation role includes the privileges to issue SELECT, INSERT, UPDATE, and DELETE statements against the emp_tab table.
- The Vacation application controls the use of privileges obtained through the vacation role.
Now, consider a user who has been granted the `vacation` role. Suppose that, instead of using the Vacation application, the user executes SQL*Plus. At this point, the user is restricted only by the privileges granted to him explicitly or through roles, including the `vacation` role. Because SQL*Plus is an ad hoc query tool, the user is not restricted to a set of predefined actions, as with designed database applications. The user can query or modify data in the `emp_tab` table as he or she chooses.
## How the PRODUCT_USER_PROFILE System Table Can Limit Roles
The `SYSTEM` schema `PRODUCT_USER_PROFILE` table can disable SQL and SQL*Plus commands in the SQL*Plus environment for each user.
SQL*Plus, not the Oracle Database, enforces this security. You can even restrict access to the `GRANT`, `REVOKE`, and `SET ROLE` commands to control user ability to change their database privileges.
The `PRODUCT_USER_PROFILE` table enables you to list roles that you do not want users to activate with an application. You can also explicitly disable the use of various commands, such as `SET ROLE`.
For example, you could create an entry in the `PRODUCT_USER_PROFILE` table to:
````
- Disallow the use of the clerk and manager roles with SQL*Plus
- Disallow the use of SET ROLE with SQL*Plus
Suppose user Marla connects to the database using SQL*Plus. Marla has the `clerk`, `manager`, and `analyst` roles. As a result of the preceding entry in `PRODUCT_USER_PROFILE`, Marla is only able to exercise her `analyst` role with SQL*Plus. Also, when Ginny attempts to issue a `SET ROLE` statement, she is explicitly prevented from doing so because of the entry in the `PRODUCT_USER_PROFILE` table prohibiting use of `SET ROLE`.
Be aware that the `PRODUCT_USER_PROFILE` table does not completely guarantee security, for multiple reasons. In the preceding example, while `SET ROLE` is disallowed with SQL*Plus, if Marla had other privileges granted to her directly, then she could exercise these using SQL*Plus.
## How Stored Procedures Can Encapsulate Business Logic
Stored procedures encapsulate privileges use with business logic so that privileges are only exercised in the context of a well-formed business transaction.
For example, an application developer can create a procedure to update the employee name and address in the `employees` table, which enforces that the data can only be updated in normal business hours.
In addition, rather than grant a human resources clerk the `UPDATE` privilege on the `employees` table, a security administrator may grant the privilege on the procedure only. Then, the human resources clerk can exercise the privilege only in the context of the procedures, and cannot update the `employees` table directly.
## Related Topics
  **- SQLPlus User’s Guide and Reference* for more information about the PRODUCT_USER_PROFILE table
