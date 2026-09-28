# Managing Commonly and Locally Granted Privileges

In a multitenant environment, privileges can be granted commonly for an entire CDB or application container, or granted locally to a specific PDB.
- About Commonly and Locally Granted Privileges In a multitenant environment, both common users and local users can grant privileges to one another.
- How Commonly Granted System Privileges Work Users can exercise system privileges only within the PDB in which they were granted.
- How Commonly Granted Object Privileges Work Object privileges on common objects applies to the object as well as all associated links on this common object.
- Granting or Revoking Privileges to Access a PDB You can grant and revoke privileges for PDB access in a multitenant environment.
- Example: Granting a Privilege in a Multitenant Environment You can use the GRANT statement to grant privileges in a multitenant environment.
- Enabling Common Users to View CONTAINER_DATA Object Information Common users can view information about CONTAINER_DATA objects in the root or for data in specific PDBs.
## About Commonly and Locally Granted Privileges
In a multitenant environment, both common users and local users can grant privileges to one another.
Privileges by themselves are neither common nor local. How the privileges are applied depends on whether the privilege is granted commonly or granted locally.
For commonly granted privileges:
- A privilege that is granted commonly can be used in every existing and future container.
- Only common users can grant privileges commonly, and only if the grantee is common.
- A common user can grant privileges to another common user or to a common role.
````
- The grantor must be connected to the root and must specify CONTAINER=ALL in the GRANT statement.
- Both system and object privileges can be commonly granted. (Object privileges become actual only with regard to the specified object.)
- When a common user connects to or switches to a given container, this user’s ability to perform various activities (such as creating a table) is controlled by privileges granted commonly as well as privileges granted locally in the given container.
- Do not grant privileges to PUBLIC commonly.
For locally granted privileges:
- A privilege granted locally can be used only in the container in which it was granted. When the privilege is granted in the root, it applies only to the root.
- Both common users and local users can grant privileges locally.
- A common user and a local user can grant privileges to other common or local roles.
````
- The grantor must be connected to the container and must specify CONTAINER=CURRENT in the GRANT statement.
- Any user can grant a privilege locally to any other user or role (both common and local) or to the PUBLIC role.
## How Commonly Granted System Privileges Work
Users can exercise system privileges only within the PDB in which they were granted.
For example, if a system privilege is locally granted to a common user `A` in a PDB `B`, user `A` can exercise that privilege only while connected to PDB `B`.
System privileges can apply in the root and in all existing and future PDBs if the following requirements are met:
````
- The system privilege grantor is a common user and the grantee is a common user, a common role, or the PUBLIC role. Do not commonly grant system privileges to the PUBLIC role, because this in effect makes the system privilege available to all users.
- The system privilege grantor possesses the ADMIN OPTION for the commonly granted privilege
````
- The GRANT statement must contain the CONTAINER=ALL clause.
The following example shows how to commonly grant a privilege to the common user `c##hr_admin`.
```
CONNECT SYSTEM
Enter password: password
Connected.
GRANT CREATE ANY TABLE TO c##hr_admin CONTAINER=ALL;
```
## How Commonly Granted Object Privileges Work
Object privileges on common objects applies to the object as well as all associated links on this common object.
These links include all metadata links, data links (previously called object links), or extended data links that are associated with it in the root and in all PDBs belonging to the container (including future PDBs) if certain requirements are met.
These requirements are as follows:
- The object privilege grantor is a common user and the grantee is a common user, a common role, or the PUBLIC role.
- The object privilege grantor possesses the commonly granted GRANT OPTION for the privilege
````
- The GRANT statement contains the CONTAINER=ALL clause.
The following example shows how to grant an object privilege to the common user `c##hr_admin` so that he can select from the `DBA_PDBS` view in the CDB root or in any of the associated PDBs that he can access.
```
CONNECT SYSTEM Enter password: password Connected.
GRANT SELECT ON DBA_OBJECTS TO c##hr_admin CONTAINER=ALL;
```
## Granting or Revoking Privileges to Access a PDB
You can grant and revoke privileges for PDB access in a multitenant environment.
**To grant a privilege in a multitenant environment:**
  ``````- Include the CONTAINER clause in the GRANT or REVOKE statement.
Setting `CONTAINER` to `ALL` applies the privilege to all existing and future containers; setting it to `CURRENT` applies the privilege to the local container only. Omitting the `CONTAINER` clause applies the privilege to the local container. If you issue the `GRANT` statement from the root and omit the `CONTAINER` clause, then the privilege is applied locally.
## Example: Granting a Privilege in a Multitenant Environment
You can use the GRANT statement to grant privileges in a multitenant environment.
Example 4-1 shows how to commonly grant the `CREATE TABLE` privilege to common user `c##hr_admin` so that this user can use this privilege in all existing and future containers.
Example 4-1 Granting a Privilege in a Multitenant Environment
```
CONNECT SYSTEM
Enter password: password
Connected.
GRANT CREATE TABLE TO c##hr_admin CONTAINER=ALL;
```
## Enabling Common Users to View CONTAINER_DATA Object Information
Common users can view information about `CONTAINER_DATA` objects in the root or for data in specific PDBs.
````````
- Viewing Data About the Root, CDB, and PDBs While Connected to the Root You can restrict view information for the X$ table and the V$, GV$ and CDB_* views when common users perform queries.
- Enabling Common Users to Query Data in Specific PDBs You can enable common users to access data pertaining to specific PDBs by adjusting the users’ CONTAINER_DATA attribute.
### Viewing Data About the Root, CDB, and PDBs While Connected to the Root
You can restrict view information for the `X$` table and the `V$`, `GV$` and `CDB_*` views when common users perform queries.
The `X$` table and these views contain information about the application root and its associated application PDBs or, if you are connected to the CDB root, the entire CDB.
Restricting this information is useful when you do not want to expose sensitive information about other PDBs. To enable this functionality, Oracle Database provides these tables and views as container data objects. You can find if a specific table or view is a container data object by querying the `TABLE_NAME`, `VIEW_NAME`, and `CONTAINER_DATA` columns of the `USER_`|`DBA_`|`ALL_VIEWS`|`TABLES` dictionary views.
**To find information about the default (user-level) and object-specific CONTAINER_DATA attributes:**
- In SQL*Plus or SQL Developer, log in to the root.
```
COLUMN USERNAME FORMAT A15 COLUMN DEFAULT_ATTR FORMAT A7 COLUMN OWNER FORMAT A15 COLUMN OBJECT_NAME FORMAT A15 COLUMN ALL_CONTAINERS FORMAT A3 COLUMN CONTAINER_NAME FORMAT A10 COLUMN CON_ID FORMAT A6 SELECT USERNAME, DEFAULT_ATTR, OWNER, OBJECT_NAME, ALL_CONTAINERS, CONTAINER_NAME, CON_ID FROM   CDB_CONTAINER_DATA ORDER BY OBJECT_NAME;
USERNAME        DEFAULT OWNER           OBJECT_NAME     ALL CONTAINERS CON_ID
--------------- ------- --------------- --------------- --- ---------- ------
C##HR_ADMIN     N       SYS             V$SESSION       N   CDB$ROOT        1 C##HR_ADMIN     N       SYS             V$SESSION       N   SALESPDB        1 C##HR_ADMIN     Y                                       N   HRPDB           1 C##HR_ADMIN     Y                                       N   CDB$ROOT        1 DBSNMP          Y                                       Y                   1 SYSTEM          Y                                       Y                   1
```
- Query the CDB_CONTAINER_DATA data dictionary view. For example:
### Enabling Common Users to Query Data in Specific PDBs
You can enable common users to access data pertaining to specific PDBs by adjusting the users’ `CONTAINER_DATA` attribute.
**To enable common users to access data about specific PDBs:**
  - Issue the ALTER USER statement in the root.
Example 4-2 Setting the CONTAINER_DATA Attribute
This example shows how to issue the `ALTER USER` statement to enable the common user `c##hr_admin` to view information pertaining to the `CDB$ROOT`, `SALES_PDB`, and `HRPDB` containers in the `V$SESSION` view (assuming this user can query that view).
```
CONNECT SYSTEM Enter password: password Connected.
ALTER USER c##hr_admin SET CONTAINER_DATA = (CDB$ROOT, SALESPDB, HRPDB) FOR V$SESSION CONTAINER=CURRENT;
```
In this specification:
- SET CONTAINER_DATA lists containers, data pertaining to which can be accessed by the user.
``````
- FOR V$SESSION specifies the CONTAINER_DATA dynamic view, which common user c##hr_admin will query.
````````
- CONTAINER = CURRENT must be specified because when you are connected to the root, CONTAINER=ALL is the default for the ALTER USER statement, but modification of the CONTAINER_DATA attribute must be restricted to the root.
If you want to enable user `c##hr_admin` to view information that pertains to the `CDB$ROOT`, `SALES_PDB`, `HRPDB` containers in all `CONTAINER_DATA` objects that this user can access, then omit `FOR V$SESSION`. For example:
```
ALTER USER c##hr_admin SET CONTAINER_DATA = (CDB$ROOT, SALESPDB, HRPDB) CONTAINER=CURRENT;
```
## Related Topics
  **- Oracle Multitenant Administrator’s Guide
  - How the PUBLIC Role Works in a Multitenant Environment
  **- Oracle Multitenant Administrator’s Guide
  **- Oracle Database SQL Language Reference
  **- Oracle Database Reference
  **- Oracle Database SQL Language Reference
