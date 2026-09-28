# Managing Object Privileges

Object privileges enable you to perform actions on schema objects, such as tables or indexes.
- About Object Privileges An object privilege grants permission to perform a particular action on a specific schema object.
- Who Can Grant Object Privileges? A user automatically has all object privileges for schema objects contained in his or her schema.
- Grants and Revokes of Object Privileges You can grant privileges to or revoke privileges from objects either directly to a user or through roles.
````
- READ and SELECT Object Privileges The READ and SELECT privileges provide different layers of query privileges.
- Object Privilege Use with Synonyms The CREATE SYNONYM statement create synonyms for database objects.
- Sharing Application Common Objects Database objects can be configured so that their metadata links, data links, and extended data links can be shared in the application root.
## About Object Privileges
An object privilege grants permission to perform a particular action on a specific schema object.
Different object privileges are available for different types of schema objects. The privilege to delete rows from the `departments` table is an example of an object privilege.
Some schema objects, such as clusters, indexes, triggers, and database links, do not have associated object privileges. Their use is controlled with system privileges. For example, to alter a cluster, a user must own the cluster or have the `ALTER` `ANY` `CLUSTER` system privilege.
Some examples of object privileges include the right to:
- Use an edition
- Update a table
- Select rows from another user’s table
- Execute a stored procedure of another user
## Who Can Grant Object Privileges?
A user automatically has all object privileges for schema objects contained in his or her schema.
A user with the `GRANT ANY OBJECT PRIVILEGE` system privilege can grant any specified object privilege to another user with or without the `WITH GRANT OPTION` clause of the `GRANT` statement. A user with the `GRANT ANY OBJECT PRIVILEGE` privilege can also use that privilege to revoke any object privilege that was granted either by the object owner or by some other user with the `GRANT ANY OBJECT PRIVILEGE` privilege.
If the grantee does not have the `GRANT ANY OBJECT PRIVILEGE` privilege or had been granted the privilege without the `WITH GRANT OPTION` clause of the `GRANT` statement, then this user cannot grant the privilege to other users.
The `WITH GRANT OPTION` can be used only with object privilege grants to users. It cannot be used for object privilege grants to roles.
## Grants and Revokes of Object Privileges
You can grant privileges to or revoke privileges from objects either directly to a user or through roles.
- About Granting and Revoking Object Privileges Object privileges can be granted to and revoked from users and roles.
- How the ALL Clause Grants or Revokes All Available Object Privileges Each type of object has different privileges associated with it, which can be controlled by the ALL clause.
### About Granting and Revoking Object Privileges
Object privileges can be granted to and revoked from users and roles.
If you grant object privileges to roles, then you can make the privileges selectively available To grant object privileges, you can use the `GRANT` statement; to revoke object privileges, you can use the `REVOKE` statement.
### How the ALL Clause Grants or Revokes All Available Object Privileges
Each type of object has different privileges associated with it, which can be controlled by the `ALL` clause.
You can specify `ALL` [`PRIVILEGES`] to grant or revoke all available object privileges for an object. `ALL` is not a privilege. Rather, it is a shortcut, or a way of granting or revoking all object privileges with one `GRANT` and `REVOKE` statement. If all object privileges are granted using the `ALL` shortcut, then individual privileges can still be revoked.
Similarly, you can revoke all individually granted privileges by specifying `ALL`. However, if you `REVOKE ALL`, and revoking causes integrity constraints to be deleted (because they depend on a `REFERENCES` privilege that you are revoking), then you must include the `CASCADE CONSTRAINTS` option in the `REVOKE` statement.
Example 4-3 revokes all privileges on the orders table in the `HR` schema using `CASCADE CONSTRAINTS`.
Example 4-3 Revoking All Object Privileges Using CASCADE CONSTRAINTS
```
REVOKE ALL ON ORDERS FROM HR CASCADE CONSTRAINTS;
```
## READ and SELECT Object Privileges
The `READ` and `SELECT` privileges provide different layers of query privileges.
````
- About Managing READ and SELECT Object Privileges You can grant users either the READ or the SELECT object privilege.
````
- Enabling Users to Use the READ Object Privilege to Query Any Table in the Database The READ ANY TABLE system privilege provides the READ object privilege for querying any table in the database.
````
- Restrictions on the READ and READ ANY TABLE Privileges There are special restrictions on the READ and READ ANY TABLE privileges.
### About Managing READ and SELECT Object Privileges
You can grant users either the `READ` or the `SELECT` object privilege.
The grant of these privileges depend on the level of access that you want to allow the user.
Follow these guidelines:
  - If you want the user only to be able to query tables, views, materialized views, or synonyms, then you should grant the READ object privilege. For example:
```
GRANT READ ON HR.EMPLOYEES TO psmith;
```
**
  - LOCK TABLE table_name IN EXCLUSIVE MODE;
**
  - SELECT ... FROM table_name FOR UPDATE;
For example:
```
GRANT SELECT ON HR.EMPLOYEES TO psmith;
```
In either case, user `psmith` would use a `SELECT` statement to perform query.
### Enabling Users to Use the READ Object Privilege to Query Any Table in the Database
The `READ ANY TABLE` system privilege provides the `READ` object privilege for querying any table in the database.
  ````- To enable a user to have the READ object privilege for any table in the database, grant the user the READ ANY TABLE system privilege.
For example:
```
GRANT READ ANY TABLE TO psmith;
```
As with the `READ` object privilege, the `READ ANY TABLE` system privilege does not enable users to lock tables in exclusive mode nor select tables for update operations. Conversely, the `SELECT ANY TABLE` system privilege enables users to lock the rows of a table, or lock the entire table, through a `SELECT ... FOR UPDATE` statement, in addition to querying any table.
### Restrictions on the READ and READ ANY TABLE Privileges
There are special restrictions on the `READ` and `READ ANY TABLE` privileges.
These privileges are as follows:
``````````````````````
- The READ object privilege has no effect on the requirements of the SQL92_SECURITY standard. If the SQL92_SECURITY initialization parameter has been set to TRUE, then its requirement that users must be granted the SELECT object privilege in addition to UPDATE or DELETE in order to execute the UPDATE or DELETE statements is not relaxed to require that READ is sufficient instead of SELECT.
````````````````
- If Oracle Database Vault is enabled, remember that the SQL92_SECURITY initialization parameter is automatically set to TRUE. Hence, UPDATE and DELETE statements will fail if the user has only been granted the READ object privilege or the READ ANY TABLE system privilege. In this case, you must grant the user the SELECT object privilege or, if the user is a trusted user, the SELECT ANY TABLE system privilege.
## Object Privilege Use with Synonyms
The `CREATE SYNONYM` statement create synonyms for database objects.
You can create synonyms for the following objects: tables, views, sequences, operators, procedures, stored functions, packages, materialized views, Java class schema objects, user-defined object types, or other synonyms.
If you grant users the privilege to use the synonym, then the object privileges granted on the underlying objects apply whether the user references the base object by name or by using the synonym.
For example, suppose user `OE` creates the following synonym for the `CUSTOMERS` table:
```
CREATE SYNONYM customer_syn FOR CUSTOMERS;
```
Then `OE` grants the `READ` privilege on the `customer_syn` synonym to user `HR`.
```
GRANT READ ON customer_syn TO HR;
```
User `HR` then tries either of the following queries:
```
SELECT COUNT(*) FROM OE.customer_syn;
SELECT COUNT(*) FROM OE.CUSTOMERS;
```
Both queries will yield the same result:
```
COUNT(*)
----------
319
```
Be aware that when you grant the synonym to another user, the grant applies to the underlying object that the synonym represents, not to the synonym itself. For example, if user `HR` queries the `ALL_TAB_PRIVS` data dictionary view for his privileges, he will learn the following:
```
SELECT TABLE_SCHEMA, TABLE_NAME, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA = 'OE';
TABLE_SCHEMA  TABLE_NAME  PRIVILEGE
------------  ----------  ------------------
**OE            CUSTOMER    READ** OE            OE          INHERIT PRIVILEGES
```
The results show that in addition to other privileges, he has the `READ` privilege for the underlying object of the `customer_syn` synonym, which is the `OE.CUSTOMER` table.
At this point, if user `OE` then revokes the `READ` privilege on the `customer_syn` synonym from `HR`, here are the results if `HR` checks his privileges again:
```
TABLE_SCHEMA  TABLE_NAME  PRIVILEGE
------------  ----------  ------------------
OE            OE          INHERIT PRIVILEGES
```
User `HR` no longer has the `READ` privilege for the `OE.CUSTOMER` table. If he tries to query the `OE.CUSTOMERS` table, then the following error appears:
```
SELECT COUNT(*) FROM OE.CUSTOMERS;
ERROR at line 1:
ORA-00942: table or view does not exist
```
## Sharing Application Common Objects
Database objects can be configured so that their metadata links, data links, and extended data links can be shared in the application root.
- Metadata-Linked Application Common Objects A metadata link enables database objects in an application pluggable database (PDB) to share metadata with objects in the application root.
- Data-Linked Application Common Objects Data links manage references and privileges for objects in a multitenant environment.
- Extended Data-Linked Application Common Objects Extended data links can combine data from an application pluggable database (PDB) with an application root.
### Metadata-Linked Application Common Objects
A metadata link enables database objects in an application pluggable database (PDB) to share metadata with objects in the application root.
Metadata links are useful for reducing disk and memory requirements because they store only one copy of an object’s metadata (such as the source code for a PL/SQL package) for identically defined objects (such as Oracle-suppled PL/SQL packages). This improves the performance of upgrade operations because changes to this metadata will be made in one place, the application root.
You must configure the metadata link from the application root. You can use the `DBMS_PDB.SET_MEDATADATA_LINKED` PL/SQL procedure to change the database object to a metadata link.
The following example shows how to use the `DBMS_PDB.SET_METADATA_LINKED` procedure to change the `update_emp_rating` procedure in the `hr_mgr` schema to a metadata-linked application common object.
Example 4-4 Changing an Object to a Metadata-Linked Application Common Object
```
BEGIN DBMS_PDB.SET_METADATA_LINKED ( SCHEMA_NAME => 'hr_mgr', OBJECT_NAME => 'update_emp_rating', NAMESPACE   => 1);
END;
/
```
Any common user can own metadata links. Metadata links can only be used to share the metadata of application common objects that their creator in the application root owns.
To find if an object has a metadata link, query the `SHARING` column of the `DBA_OBJECTS` data dictionary view.
### Data-Linked Application Common Objects
Data links manage references and privileges for objects in a multitenant environment.
A data link (previously called an object link) enables references to, and privilege grants on, objects in an application root from an application pluggable database (PDB) that belong to the same application container.
If an application common user who owns an application common object wants to grant access to that object to a user in a PDB, then the application common user can accomplish this by granting the privilege on a data link that points to the common object. For example, you can create data links for objects such as tables, views, clusters, sequences, or PL/SQL packages if you want to ensure that an operation on the object (such as a query, a DML, an `EXECUTE` statement, and so on) that refers to this operation affects the same object regardless of the container in which the operation is performed.
You must configure the data link from an application root. You can use the `DBMS_PDB.SET_DATA_LINKED` PL/SQL procedure to change the data link. You should use this procedure only when you want to convert an existing object to become data linked.
The following example shows how to use the `DBMS_PDB.SET_DATA_LINKED` procedure to change the `emp_ratings` table in the `hr_mgr` schema to a data-linked application common object.
Example 4-5 Changing an Object to a Data-Linked Application Common Object
```
BEGIN DBMS_PDB.SET_DATA_LINKED ( SCHEMA_NAME => 'hr_mgr', OBJECT_NAME => 'emp_ratings', NAMESPACE   => 1);
END;
/
```
Any common user can own data links.
To find if an object has an data link, query the `SHARING` column of the `DBA_OBJECTS` data dictionary view. The `NAMESPACE` column of this view provides the namespace number.
### Extended Data-Linked Application Common Objects
Extended data links can combine data from an application pluggable database (PDB) with an application root.
An extended data link enables a data link to combine data found in a table in the PDB with data from a corresponding table in the application root.
You can think of an extended data link as a hybrid of a metadata link and a data link. An extended data-link object in an application PDB inherits metadata from the extended data link object in the application root. The data for the object is stored in the application root and, optionally, in each application PDB. You can create extended data links for tables and views only. When you query the `DBA_OBJECTS` data dictionary view for an extended data link object, this view returns extended data link-related rows from both the application PDB and the application root.
You must configure the extended data link from an application root. You can use the `DBMS_PDB.SET_EXT_DATA_LINKED` PL/SQL procedure to change the database object to an extended data link.
The following example shows how to use the `DBMS_PDB.SET_EXT_DATA_LINKED` procedure to change the `emp_salaries` data dictionary view in the `hr_mgr` schema to an extended data-linked application common object.
Example 4-6 Changing an Object to an Extended Data-Linked Application Common Object
```
BEGIN DBMS_PDB.SET_EXT_DATA_LINKED ( SCHEMA_NAME => 'hr_mgr', OBJECT_NAME => 'emp_salaries', NAMESPACE   => 1);
END;
/
```
Any common user can own extended data links.
To find if an object has an extended data link, query the `SHARING` column of the `DBA_OBJECTS` data dictionary view.
## Related Topics
  - How Commonly Granted Object Privileges Work
  **- Oracle Database SQL Language Reference for a list of object privileges and the operations they authorize
  **````- Oracle Database SQL Language Reference for information about GRANT and GRANT ANY OBJECT PRIVILEGE
  - Auditing the READ ANY TABLE and SELECT ANY TABLE Privileges
  **- Oracle Database Administrator’s Guide for information about creating application common objects: metadata-linked objects, data-linked objects, and extended data-linked objects
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_PDB.SET_METADATA_LINKED procedure
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_PDB.SET_DATA_LINKED procedure
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_PDB.SET_EXT_DATA_LINKED procedure
