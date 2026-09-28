# REVOKE

## Purpose
Use the `REVOKE` statement to:
- Revoke system privileges from users and roles
- Revoke roles from users, roles, and program units.
- Revoke object privileges for a particular object from users and roles
Note on Oracle Automatic Storage Management A user authenticated `AS` `SYSASM` can use this statement to revoke the system privileges `SYSASM`, `SYSOPER`, and `SYSDBA` from a user in the Oracle ASM password file of the current node.
Note on Editionable Objects A `REVOKE` operation to revoke object privileges on an editionable object actualizes the object in the current edition. See *Oracle Database Development Guide* for more information about editions and editionable objects.
**See Also:**
- GRANT for information on granting system privileges and roles
- Table 18-2 for a listing of the object privileges for each type of object
## Prerequisites
To revoke a **system privilege,** you must have been granted the privilege with the `ADMIN` `OPTION`. You can revoke any privilege if you have the `GRANT` `ANY` `PRIVILEGE` system privilege.
To revoke a **role from a user or another role**, you must have been directly granted the role with the `ADMIN` `OPTION` or you must have created the role. You can revoke any role if you have the `GRANT` `ANY` `ROLE` system privilege.
To revoke a **role from a program unit**, you must be the user `SYS` or you must be the schema owner of the program unit.
To revoke an **object privilege**, one of the following conditions must be met:
- You must previously have granted the object privilege to the user or role.
``````````````````````****
- You must have the GRANT ANY OBJECT PRIVILEGE system privilege. In this case, you can revoke any object privilege that was granted by the object owner or on behalf of the owner by a user with the GRANT ANY OBJECT PRIVILEGE. However, you cannot revoke an object privilege that was granted by way of a WITH GRANT OPTION grant. See Also: “Revoke Operations that Use GRANT ANY OBJECT PRIVILEGE: Example”
The `REVOKE` statement can revoke only privileges and roles that were previously granted directly with a `GRANT` statement. You cannot use this statement to revoke:
- Privileges or roles not granted to the revokee
- Roles or object privileges granted through the operating system
- Privileges or roles granted to the revokee through roles
To specify the `CONTAINER` clause, you must be connected to a multitenant container database (CDB). To specify `CONTAINER` `=` `ALL`, the current container must be the root.
## Syntax
## *revoke*::=
Description of the illustration revoke.eps
(*revoke_system_privileges::=*, *revoke_object_privileges::=*, *revoke_roles_from_programs::=*)
## *revoke_system_privileges*::=
Description of the illustration revoke_system_privileges.eps
(*revokee_clause::=*)
## *revoke_object_privileges*::=
Description of the illustration revoke_object_privileges.eps
(*on_object_clause::=*, *revokee_clause::=*)
## *revokee_clause*::=
Description of the illustration revokee_clause.eps
## *on_object_clause*::=
Description of the illustration on_object_clause.eps
## *revoke_roles_from_programs*::=
Description of the illustration revoke_roles_from_programs.eps
## *program_unit*::=
Description of the illustration program_unit.eps
## Semantics
## *revoke_system_privileges*
Use these clauses to revoke system privileges.
***system_privilege***
Specify the system privilege to be revoked. Refer to Table 18-1 for a list of the system privileges.
If you revoke a system privilege from a **user**, then the database removes the privilege from the user’s privilege domain. Effective immediately, the user cannot exercise the privilege.
If you revoke a system privilege from a **role**, then the database removes the privilege from the privilege domain of the role. Effective immediately, users with the role enabled cannot exercise the privilege. Also, other users who have been granted the role and subsequently enable the role cannot exercise the privilege.
**See Also:**   “Revoking a System Privilege from a User: Example” and “Revoking a System Privilege from a Role: Example”
If you revoke a system privilege from **PUBLIC**, then the database removes the privilege from the privilege domain of each user who has been granted the privilege through `PUBLIC`. Effective immediately, such users can no longer exercise the privilege. However, the privilege is not revoked from users who have been granted the privilege directly or through roles.
Oracle Database provides a shortcut for specifying all system privileges at once: Specify `ALL` `PRIVILEGES` to revoke all the system privileges listed in Table 18-1.
**Restriction on Revoking System Privileges**
A system privilege cannot appear more than once in the list of privileges to be revoked.
***role***
Specify the role to be revoked.
If you revoke a role from a **user**, then the database makes the role unavailable to the user. If the role is currently enabled for the user, then the user can continue to exercise the privileges in the role’s privilege domain as long as it remains enabled. However, the user cannot subsequently enable the role.
If you revoke a role from another **role**, then the database removes the privilege domain of the revoked role from the privilege domain of the revokee role. Users who have been granted and have enabled the revokee role can continue to exercise the privileges in the privilege domain of the revoked role as long as the revokee role remains enabled. However, other users who have been granted the revokee role and subsequently enable it cannot exercise the privileges in the privilege domain of the revoked role.
**See Also:**   “Revoking a Role from a User: Example” and “Revoking a Role from a Role: Example”
If you revoke a role from **PUBLIC**, then the database makes the role unavailable to all users who have been granted the role through `PUBLIC`. Any user who has enabled the role can continue to exercise the privileges in its privilege domain as long as it remains enabled. However, users cannot subsequently enable the role. The role is not revoked from users who have been granted the role directly or through other roles.
**Restriction on Revoking System Roles**
A system role cannot appear more than once in the list of roles to be revoked. For information on the predefined roles, refer to *Oracle Database Security Guide*.
***revokee_clause***
Use the *revokee_clause* to specify the users or roles from which the system privilege, role, or object privilege is to be revoked.
**PUBLIC**
Specify `PUBLIC` to revoke the privileges or roles from all users.
## *revoke_object_privileges*
Use these clauses to revoke object privileges.
***object_privilege***
Specify the object privilege to be revoked. The object privileges, categorized by the type of object to which they apply, are described in Table 18-2.
**Note:**   Each privilege authorizes some operation. By revoking a privilege, you prevent the revokee from performing that operation. However, multiple users may grant the same privilege to the same user, role, or `PUBLIC`. To remove the privilege from the grantee’s privilege domain, all grantors must revoke the privilege. If even one grantor does not revoke the privilege, then the grantee can still exercise the privilege by virtue of that grant.
If you revoke an object privilege from a **user**, then the database removes the privilege from the user’s privilege domain. Effective immediately, the user cannot exercise the privilege.
- If that user has granted that privilege to other users or roles, then the database also revokes the privilege from those other users or roles.
- If that user’s schema contains a procedure, function, or package that contains SQL statements that exercise the privilege, then the procedure, function, or package can no longer be executed.
- If that user’s schema contains a view on that object, then the database invalidates the view.
``````
- If you revoke the REFERENCES object privilege from a user who has exercised the privilege to define referential integrity constraints, then you must specify the CASCADE CONSTRAINTS clause.
If you revoke an object privilege from a **role**, then the database removes the privilege from the privilege domain of the role. Effective immediately, users with the role enabled cannot exercise the privilege. Other users who have been granted the role cannot exercise the privilege after enabling the role.
If you revoke an object privilege from `PUBLIC`, then the database removes the privilege from the privilege domain of each user who has been granted the privilege through `PUBLIC`. Effective immediately, all such users are restricted from exercising the privilege. However, the privilege is not revoked from users who have been granted the privilege directly or through roles.
**ALL [PRIVILEGES]** Specify `ALL` to revoke all object privileges that you have granted to the revokee. (The keyword `PRIVILEGES` is provided for semantic clarity and is optional.) If no privileges have been granted on the object, then the database takes no action and does not return an error.
**Restriction on Revoking Object Privileges** A privilege cannot appear more than once in the list of privileges to be revoked. A user, a role, or `PUBLIC` cannot appear more than once in the `FROM` clause.
**See Also:**   “Revoking an Object Privilege from a User: Example”, “Revoking Object Privileges from PUBLIC: Example”, and “Revoking All Object Privileges from a User: Example” **CASCADE CONSTRAINTS** This clause is relevant only if you revoke the `REFERENCES` privilege or `ALL` [`PRIVILEGES`]. It drops any referential integrity constraints that the revokee has defined using the `REFERENCES` privilege, which might have been granted either explicitly or implicitly through a grant of `ALL` [`PRIVILEGES`].
**See Also:**   “Revoking an Object Privilege with CASCADE CONSTRAINTS: Example” **FORCE** Specify `FORCE` to revoke the `EXECUTE` object privilege on user-defined type objects with table or type dependencies. You must use `FORCE` to revoke the `EXECUTE` object privilege on user-defined type objects with table dependencies.
If you specify `FORCE`, then all privileges are revoked, all dependent objects are marked `INVALID`, data in dependent tables becomes inaccessible, and all dependent function-based indexes are marked `UNUSABLE`. Regranting the necessary type privilege will revalidate the table.
**See Also:**   *Oracle Database Concepts* for detailed information about type dependencies and user-defined object privileges ***on_object_clause*** The *on_object_clause* identifies the objects on which privileges are to be revoked.
***object*** Specify the object on which the object privileges are to be revoked. This object can be:
- A table, view, sequence, procedure, stored function, package, or materialized view
- A synonym for a table, view, sequence, procedure, stored function, package, materialized view, or user-defined type
- A library, indextype, or user-defined operator
If you do not qualify object with *schema*, then the database assumes the object is in your own schema.
**See Also:**   “Revoking an Object Privilege on a Sequence from a User: Example” If you revoke the `READ` or `SELECT` object privilege on the containing table or materialized view of a materialized view, whether the privilege was granted with or without the `GRANT` `OPTION`, then the database invalidates the materialized view.
If you revoke the `READ` or `SELECT` object privilege on any of the master tables of a materialized view, whether the privilege was granted with or without the `GRANT` `OPTION`, then the database invalidates both the materialized view and its containing table or materialized view.
**ON USER** Specify the database user you want to revoke privileges from.
**See Also:**   “Revoking an Object Privilege on a User from a User: Example” **ON DIRECTORY** Specify the name of the directory object on which privileges are to be revoked. You cannot qualify *directory_name* with a schema name.
**See Also:**   CREATE DIRECTORY and “Revoking an Object Privilege on a Directory from a User: Example” **ON EDITION** Specify the name of the edition on which the `USE` object privilege is to be revoked. You cannot qualify *edition_name* with a schema name.
**ON MINING MODEL** Specify the name of the mining model on which privileges are to be revoked. If you do not qualify *mining_model_name* with *schema*, then the database assumes that the mining model is in your own schema.
**ON JAVA SOURCE | RESOURCE** Specify the name of the Java source or resource schema object on which privileges are to be revoked. If you do not qualify *object* with *schema*, then the database assumes that the object is in your own schema.
**ON SQL TRANSLATION PROFILE** Specify the name of the SQL translation profile on which privileges are to be revoked. If you do not qualify *profile* with *schema*, then the database assumes the profile is in your own schema.
## *revoke_roles_from_programs*
Use this clause to revoke code based access control (CBAC) roles from program units.
***role*** Specify the role you want to revoke.
**ALL** Specify `ALL` to revoke all roles that are granted to the program unit.
***program_unit*** Specify the program unit from which the role is to be revoked. You can specify a PL/SQL function, procedure, or package. If you do not specify *schema*, then Oracle Database assumes the function, procedure, or package is in your own schema.
**See Also:**   *Oracle Database Security Guide* for more information on revoking CBAC roles from program units
## CONTAINER Clause
If the current container is a pluggable database (PDB):
  ````````````- Specify CONTAINER = CURRENT to revoke a locally granted system privilege, object privilege, or role from a local user, common user, local role, or common role. The privilege or role is revoked from the user or role only in the current PDB. This clause does not revoke privileges granted with CONTAINER = ALL.
If the current container is the root:
````````````
- Specify CONTAINER = CURRENT to revoke a locally granted system privilege, object privilege, or role from a common user or common role. The privilege or role is revoked from the user or role only in the root. This clause does not revoke privileges granted with CONTAINER = ALL.
``````````````````
- Specify CONTAINER = ALL to revoke a commonly granted system privilege, object privilege on a common object, or role from a common user or common role. The privilege or role is revoked from the user or role across the entire CDB. This clause can revoke only a privilege or role granted with CONTAINER = ALL from the specified common user or common role. This clause does not revoke privileges granted locally with CONTAINER = CURRENT. However, any locally granted privileges that depend on the commonly granted privilege being revoked are also revoked.
If you omit this clause, then `CONTAINER` `=` `CURRENT` is the default.
## Examples
**Revoking a System Privilege from a User: Example**
The following statement revokes the `DROP` `ANY` `TABLE` system privilege from the users `hr` and `oe`:
```
REVOKE DROP ANY TABLE FROM hr, oe;
```
The users `hr` and `oe` can no longer drop tables in schemas other than their own.
**Revoking a Role from a User: Example**
The following statement revokes the role `dw_manager` from the user `sh`:
```
REVOKE dw_manager FROM sh;
```
The user `sh` can no longer enable the `dw_manager` role.
**Revoking a System Privilege from a Role: Example**
The following statement revokes the `CREATE` `TABLESPACE` system privilege from the `dw_manager` role:
```
REVOKE CREATE TABLESPACE FROM dw_manager;
```
Enabling the `dw_manager` role no longer allows users to create tablespaces.
**Revoking a Role from a Role: Example**
To revoke the role `dw_user` from the role `dw_manager`, issue the following statement:
```
REVOKE dw_user FROM dw_manager;
```
The `dw_user` role privileges are no longer granted to `dw_manager`.
**Revoking an Object Privilege from a User: Example**
You can grant `DELETE`, `INSERT`, `READ`, `SELECT`, and `UPDATE` privileges on the table `orders` to the user `hr` with the following statement:
```
GRANT ALL ON orders TO hr;
```
To revoke the `DELETE` privilege on `orders` from `hr`, issue the following statement:
```
REVOKE DELETE ON orders FROM hr;
```
**Revoking All Object Privileges from a User: Example**
To revoke the remaining privileges on `orders` that you granted to `hr`, issue the following statement:
```
REVOKE ALL ON orders FROM hr;
```
**Revoking Object Privileges from PUBLIC: Example**
You can grant `SELECT` and `UPDATE` privileges on the view `emp_details_view` to all users by granting the privileges to the role `PUBLIC`:
```
GRANT SELECT, UPDATE ON emp_details_view TO public;
```
The following statement revokes `UPDATE` privilege on `emp_details_view` from all users:
```
REVOKE UPDATE ON emp_details_view FROM public;
```
Users can no longer update the `emp_details_view` view, although users can still query it. However, if you have also granted the `UPDATE` privilege on `emp_details_view` to any users, either directly or through roles, then these users retain the privilege.
**Revoking an Object Privilege on a User from a User: Example**
You can grant the user `hr` the `INHERIT` `PRIVILEGES` privilege on user `sh` with the following statement:
```
GRANT INHERIT PRIVILEGES ON USER sh TO hr;
```
To revoke the `INHERIT` `PRIVILEGES` privilege on user `sh` from user `hr`, issue the following statement:
```
REVOKE INHERIT PRIVILEGES ON USER sh FROM hr;
```
**Revoking an Object Privilege on a Sequence from a User: Example**
You can grant the user `oe` the `SELECT` privilege on the `departments_seq` sequence in the schema `hr` with the following statement:
```
GRANT SELECT ON hr.departments_seq TO oe;
```
To revoke the `SELECT` privilege on `departments_seq` from `oe`, issue the following statement:
```
REVOKE SELECT ON hr.departments_seq FROM oe;
```
However, if the user `hr` has also granted `SELECT` privilege on `departments` to `sh`, then `sh` can still use `departments` by virtue of `hr`’s grant.
**Revoking an Object Privilege with CASCADE CONSTRAINTS: Example**
You can grant to `oe` the privileges `REFERENCES` and `UPDATE` on the `employees` table in the schema `hr` with the following statement:
```
GRANT REFERENCES, UPDATE ON hr.employees TO oe;
```
The user `oe` can exercise the `REFERENCES` privilege to define a constraint in his or her own `dependent` table that refers to the `employees` table in the schema `hr`:
```
CREATE TABLE dependent (dependno   NUMBER, dependname VARCHAR2(10), employee   NUMBER CONSTRAINT in_emp REFERENCES hr.employees(employee_id) );
```
You can revoke the `REFERENCES` privilege on `hr.employees` from `oe` by issuing the following statement that contains the `CASCADE` `CONSTRAINTS` clause:
```
REVOKE REFERENCES ON hr.employees FROM oe CASCADE CONSTRAINTS;
```
Revoking `oe`’s `REFERENCES` privilege on `hr.employees` causes Oracle Database to drop the `in_emp` constraint, because `oe` required the privilege to define the constraint.
However, if `oe` has also been granted the `REFERENCES` privilege on `hr.employees` by a user other than you, then the database does not drop the constraint. `oe` still has the privilege necessary for the constraint by virtue of the other user’s grant.
**Revoking an Object Privilege on a Directory from a User: Example**
You can revoke the `READ` object privilege on directory `bfile_dir` from `hr` by issuing the following statement:
```
REVOKE READ ON DIRECTORY bfile_dir FROM hr;
```
**Revoke Operations that Use GRANT ANY OBJECT PRIVILEGE: Example**
Suppose that the database administrator has granted `GRANT` `ANY` `OBJECT` `PRIVILEGE` to user `sh`. Now suppose that user `hr` grants the update privilege on the `employees` table to `oe`:
```
CONNECT hr GRANT UPDATE ON employees TO oe WITH GRANT OPTION;
```
This grant gives user `oe` the right to pass the object privilege along to another user:
```
CONNECT oe GRANT UPDATE ON hr.employees TO pm;
```
User `sh`, who has the `GRANT` `ANY` `OBJECT` `PRIVILEGE`, can now act on behalf of user `hr` and revoke the update privilege from user `oe`, because `oe` was granted the privilege by `hr`:
```
CONNECT sh REVOKE UPDATE ON hr.employees FROM oe;
```
User `sh` cannot revoke the update privilege from user `pm` explicitly, because `pm` received the grant neither from the object owner (`hr`), nor from `sh`, nor from another user with `GRANT` `ANY` `OBJECT` `PRIVILEGE`, but from user `oe`. However, the preceding statement cascades, removing all privileges that depend on the one revoked. Therefore the object privilege is implicitly revoked from `pm` as well.
