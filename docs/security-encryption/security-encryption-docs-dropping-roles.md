# Dropping Roles

Dropping a role affects the security domains of users or roles who had been granted the role.
That is, the security domains of all users and roles that were granted to the dropped role are changed to reflect the absence of the dropped role privileges.
All indirectly granted roles of the dropped role are also removed from affected security domains. Dropping a role automatically removes the role from all user default role lists.
Because the existence of objects is not dependent on the privileges received through a role, tables and other objects are not dropped when a role is dropped.
To drop a role, you must have the `DROP ANY ROLE` system privilege or have been granted the role with the `ADMIN` option.
  - To drop a role, use the DROP ROLE statement.
For example, to drop the role `CLERK`:
```
DROP ROLE clerk;
```
