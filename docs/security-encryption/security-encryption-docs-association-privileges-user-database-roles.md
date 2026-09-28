# Association of Privileges with User Database Roles

Ensure that users have only the privileges associated with the current database role.
- Why Users Should Only Have the Privileges of the Current Database Role A single user can use many applications and associated roles.
````
- Use of the SET ROLE Statement to Automatically Enable or Disable Roles You can use a SET ROLE statement at the beginning of each application to automatically enable its associated role and to disable all others.
## Why Users Should Only Have the Privileges of the Current Database Role
A single user can use many applications and associated roles.
However, you should ensure that the user has only the privileges associated with the current database role.
Consider the following scenario:
``````
- The ORDER role (for an application called Order) contains the UPDATE privilege for the INVENTORY table.
``````
- The INVENTORY role (for an application called Inventory) contains the SELECT privilege for the INVENTORY table.
````
- Several order entry clerks were granted both the ORDER and INVENTORY roles.
In this scenario, an order entry clerk who was granted both roles can use the privileges of the `ORDER` role when running the `INVENTORY` application to update the `INVENTORY` table. The problem is that updating the `INVENTORY` table is not an authorized action for the `INVENTORY` application. It is an authorized action for the `ORDER` application. To avoid this problem, use the `SET` `ROLE` statement as explained in the following section.
## Use of the SET ROLE Statement to Automatically Enable or Disable Roles
You can use a `SET` `ROLE` statement at the beginning of each application to automatically enable its associated role and to disable all others.
This way, each application dynamically enables particular privileges for a user only when required. The `SET` `ROLE` statement simplifies privilege management. You control what information users can access and when they can access it. The `SET` `ROLE` statement also keeps users operating in a well-defined privilege domain. If a user obtains privileges only from roles, then the user cannot combine these privileges to perform unauthorized operations.
## Related Topics
  - How Grants and Revokes Work with SET ROLE and Default Role Settings
  - When Grants and Revokes Take Effect
