# Managing Common Roles and Local Roles

A common role is a role that is created in the root; a local role is created in a PDB.
- About Common Roles and Local Roles In a multitenant environment, database roles can be specific to a PDB or used throughout the entire system container or application container.
- How Common Roles Work Common roles are visible in the root and in every PDB of a container within which they are defined in a multitenant environment.
- How the PUBLIC Role Works in a Multitenant Environment All privileges that Oracle grants to the PUBLIC role are granted locally.
``````
- Privileges Required to Create, Modify, or Drop a Common Role Only common users who have the commonly granted CREATE ROLE, ALTER ROLE, and DROP ROLE privileges can create, alter, or drop common roles.
- Rules for Creating Common Roles When you create a common role, you must follow special rules.
- Creating a Common Role You can use the CREATE ROLE statement to create a common role.
- Rules for Creating Local Roles To create a local role, you must follow special rules.
- Creating a Local Role You can use the CREATE ROLE statement to create a role.
- Role Grants and Revokes for Common Users and Local Users Role grants and revokes apply only to the scope of access of the common user or the local user.
## About Common Roles and Local Roles
In a multitenant environment, database roles can be specific to a PDB or used throughout the entire system container or application container.
A common role is a role whose identity and (optional) password are created in the root of a container and will be known in the root and in all existing and future PDBs belonging to that container.
A local role exists in only one PDB and can only be used within this PDB. It does not have any commonly granted privileges.
Note the following:
- Common users can both create and grant common roles to other common and local users.
- You can grant a role (local or common) to a local user or role only locally.
- If you grant a common role locally, then the privileges of that common role apply only in the container where the role is granted.
- Local users cannot create common roles, but they can grant them to common and other local users.
- The CONTAINER = ALL clause is the default when you create a common role in the CDB root or an application root.
## How Common Roles Work
Common roles are visible in the root and in every PDB of a container within which they are defined in a multitenant environment.
A privilege can be granted commonly to a common role if:
- The grantor is a common user.
- The grantor possesses the commonly granted ADMIN OPTION for the privilege that is being granted.
````
- The GRANT statement contains the CONTAINER=ALL clause.
If the common role contains locally granted privileges, then these privileges apply only within the PDB in which they were granted to the common role. A local role cannot be granted commonly.
For example, suppose the CDB common user `c##hr_mgr` has been commonly granted the `DBA` role. This means that user `c##hr_mgr` can use the privileges associated with the `DBA` role in the root and in every PDB in the multitenant environment. However, if the CDB common user `c##hr_mgr` has only been locally granted the `DBA` role for the `hr_pdb` PDB, then this user can only use the `DBA` role’s privileges in the `hr_pdb` PDB.
## How the PUBLIC Role Works in a Multitenant Environment
All privileges that Oracle grants to the `PUBLIC` role are granted locally.
This feature enables you to revoke privileges or roles that have been granted to the `PUBLIC` role individually in each PDB as needed. If you must grant any privileges to the `PUBLIC` role, then grant them locally. Never grant privileges to `PUBLIC` commonly.
## Privileges Required to Create, Modify, or Drop a Common Role
Only common users who have the commonly granted `CREATE ROLE`, `ALTER ROLE`, and `DROP ROLE` privileges can create, alter, or drop common roles.
Common users can also create local roles, but these roles are available only in the PDB in which they were created.
## Rules for Creating Common Roles
When you create a common role, you must follow special rules.
The rules are as follows:
****
````
  - To confirm that you are in the CDB root, you can issue the show_con_name command. The output should be CDB$ROOT.
```
SELECT APPLICATION_ROOT FROM V$PDBS WHERE CON_ID=SYS_CONTEXT('USERENV', 'CON_ID');
```
  - To confirm that you are in an application root, verify that the following query returns YES:
****````
  - Ensure that the name that you give the common role starts with the value of the COMMON_USER_PREFIX parameter (which defaults to C##). Note that this requirement does not apply to the names of existing Oracle-supplied roles, such as DBA or RESOURCE.
****
- Optionally, set the CONTAINER clause to ALL. As long as you are in the root, if you omit the CONTAINER = ALL clause, then by default the role is created as a common role for the CDB root or the application root.
## Creating a Common Role
You can use the `CREATE ROLE` statement to create a common role.
```
CONNECT SYSTEM Enter password: password Connected.
```
- Connect to the root of the CDB or the application container in which you want to create the common role. For example:
``````
```
CREATE ROLE c##sec_admin IDENTIFIED BY password CONTAINER=ALL;
```
- Run the CREATE ROLE statement with the CONTAINER clause set to ALL. For example:
## Rules for Creating Local Roles
To create a local role, you must follow special rules.
These rules are as follows:
- You must be connected to the PDB in which you want to create the role, and have the CREATE ROLE privilege.
````
- The name that you give the local role must not start with the value of the COMMON_USER_PREFIX parameter (which defaults to C##).
``````
- You can include CONTAINER=CURRENT in the CREATE ROLE statement to specify the role as a local role. If you are connected to a PDB and omit this clause, then the CONTAINER=CURRENT clause is implied.
````
- You cannot have common roles and local roles with the same name. However, you can use the same name for local roles in different PDBs. To find the names of existing roles, query the CDB_ROLES and DBA_ROLES data dictionary views.
## Creating a Local Role
You can use the `CREATE ROLE` statement to create a role.
```
CONNECT SYSTEM@hrpdb Enter password: password Connected.
```
- Connect to the PDB in which you want to create the local role. For example:
``````
```
CREATE ROLE sec_admin CONTAINER=CURRENT;
```
- Run the CREATE ROLE statement with the CONTAINER clause set to CURRENT. For example:
## Role Grants and Revokes for Common Users and Local Users
Role grants and revokes apply only to the scope of access of the common user or the local user.
Common users can grant and revoke common roles to and from other common users. A local user can grant a common role to any user in a PDB, including common users, but this grant applies only within the PDB.
The following example shows how to grant the common user `c##sec_admin` the `AUDIT_ADMIN` common role for use in all containers.
```
CONNECT SYSTEM
Enter password: password
Connected.
GRANT AUDIT_ADMIN TO c##sec_admin CONTAINER=ALL;
```
Similarly, the next example shows how local user `aud_admin` can grant the common user `c##sec_admin` the `AUDIT_ADMIN` common role for use within the `hrpdb` PDB.
```
CONNECT aud_admin@hrpdb
Enter password: password
Connected.
GRANT AUDIT_ADMIN TO c##sec_admin CONTAINER=CURRENT;
```
This example shows how a local user `aud_admin` can revoke a role from another user in a PDB. If you omit the `CONTAINER` clause, then `CURRENT` is implied.
```
CONNECT aud_admin@hrpdb
Enter password: password
Connected.
REVOKE sec_admin FROM psmith CONTAINER=CURRENT;
```
## Related Topics
  - Predefined Roles in an Oracle Database Installation
  - About Commonly and Locally Granted Privileges
  - Creating a Role
  - Creating a Common Role in Enterprise Manager
  - Revoking Common Privilege Grants in Enterprise Manager
