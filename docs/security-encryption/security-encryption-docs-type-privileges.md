# Type Privileges

You can control system and object privileges for types, methods, and objects.
- System Privileges for Named Types System privileges for named types can enable users to perform actions such as creating named types in their own schemas.
- Object Privileges for Named Types The only object privilege that applies to named types is EXECUTE.
- Method Execution Model for Named Types The method execution for named types is the same as any other stored PL/SQL procedure.
- Privileges Required to Create Types and Tables Using Types To create a type, you must have the appropriate privileges.
``````
- Example: Privileges for Creating Types and Tables Using Types The EXECUTE privilege with the GRANT OPTION is required for users to grant the EXECUTE privilege on a type to other users.
- Privileges on Type Access and Object Access Existing column-level and table-level privileges for DML statements apply to both column objects and row objects.
- Type Dependencies As with stored objects, such as procedures and tables, types that are referenced by other objects are called dependencies.
## System Privileges for Named Types
System privileges for named types can enable users to perform actions such as creating named types in their own schemas.
The following table lists system privileges for named types (object types, `VARRAY`s, and nested tables).

| Privilege | Enables you to … |
|---|---|
| CREATE TYPE | Create named types in your own schemas |
| CREATE ANY TYPE | Create a named type in any schema |
| ALTER ANY TYPE | Alter a named type in any schema |
| DROP ANY TYPE | Drop a named type in any schema |
| EXECUTE ANY TYPE | Use and reference a named type in any schema |

The `RESOURCE` role includes the `CREATE` `TYPE` system privilege. The `DBA` role includes all of these privileges.
## Object Privileges for Named Types
The only object privilege that applies to named types is `EXECUTE`.
If the `EXECUTE` privilege exists on a named type, then a user can use the named type to:
- Define a table
- Define a column in a relational table
- Declare a variable or parameter of the named type
The `EXECUTE` privilege permits a user to invoke the methods in the type, including the type constructor. This is similar to the `EXECUTE` privilege on a stored PL/SQL procedure.
## Method Execution Model for Named Types
The method execution for named types is the same as any other stored PL/SQL procedure.
Users must be granted the appropriate privileges for using the named types, such as the `EXECUTE` privilege. As with all privilege grants, only grant these privileges to trusted users. You can find the privileges that a user has been granted by querying the `DBA_SYS_PRIVS` data dictionary view.
## Privileges Required to Create Types and Tables Using Types
To create a type, you must have the appropriate privileges.
These privileges are as follows:
``````````
- You must have the CREATE TYPE system privilege to create a type in your schema or the CREATE ANY TYPE system privilege to create a type in the schema of another user. These privileges can be acquired explicitly or through a role.
````````
- The owner of the type must be explicitly granted the EXECUTE object privileges to access all other types referenced within the definition of the type, or have been granted the EXECUTE ANY TYPE system privilege. The owner cannot obtain the required privileges through roles.
````````````````
- If the type owner intends to grant access to the type to other users, then the owner must receive the EXECUTE privileges to the referenced types with the GRANT OPTION or the EXECUTE ANY TYPE system privilege with the ADMIN OPTION. If not, then the type owner has insufficient privileges to grant access on the type to other users.
To create a table using types, you must meet the requirements for creating a table and the following additional requirements:
````````
- The owner of the table must have been directly granted the EXECUTE object privilege to access all types referenced by the table, or has been granted the EXECUTE ANY TYPE system privilege. The owner cannot exercise the required privileges if these privileges were granted through roles.
````````````````
- If the table owner intends to grant access to the table to other users, then the owner must have the EXECUTE privilege to the referenced types with the GRANT OPTION or the EXECUTE ANY TYPE system privilege with the ADMIN OPTION. If not, then the table owner has insufficient privileges to grant access on the table.
## Example: Privileges for Creating Types and Tables Using Types
The `EXECUTE` privilege with the `GRANT OPTION` is required for users to grant the `EXECUTE` privilege on a type to other users.
Assume that three users exist with the `CONNECT` and `RESOURCE` roles:
- user1
- user2
- user3
The following DDL is run in the schema of `user1`:
```
CREATE TYPE type1 AS OBJECT (
  attr1 NUMBER);
CREATE TYPE type2 AS OBJECT (
  attr2 NUMBER);
GRANT EXECUTE ON type1 TO user2;
GRANT EXECUTE ON type2 TO user2 WITH GRANT OPTION;
```
The following DDL is performed in the schema of `user2`:
```
CREATE TABLE tab1 OF user
1.type1;
CREATE TYPE type3 AS OBJECT (
  attr3 user1.type2);
CREATE TABLE tab2 (
  col1 user1.type2);
```
The following statements succeed because `user2` has `EXECUTE` privilege on `user1.type2` with the `GRANT` `OPTION:`
```
GRANT EXECUTE ON type3 TO user3;
GRANT SELECT ON tab2 TO user3;
```
However, the following grant fails because `user2` does not have `EXECUTE` privilege on `user1.type1` with the `GRANT` `OPTION:`
```
GRANT SELECT ON tab1 TO user3;
```
The following statements can be successfully run by `user3`:
```
CREATE TYPE type4 AS OBJECT (
  attr4 user2.type3);
CREATE TABLE tab3 OF type4;
```
**Note:**   The `CONNECT` role presently retains only the `CREATE SESSION` and `SET CONTAINER` privileges.
## Privileges on Type Access and Object Access
Existing column-level and table-level privileges for DML statements apply to both column objects and row objects.
The following table lists the privileges for object tables.

| Privilege | Enables you to… |
|---|---|
| SELECT | Access an object and its attributes from the table |
| UPDATE | Modify the attributes of the objects that make up the rows in the table |
| INSERT | Create new objects in the table |
| DELETE | Delete rows |

Similar table privileges and column privileges apply to column objects. Retrieving instances does not in itself reveal type information. However, clients must access named type information to interpret the type instance images. When a client requests type information, Oracle Database checks for the `EXECUTE` privilege on the type.
Consider the following schema:
```
CREATE TYPE emp_type (
    eno NUMBER, ename CHAR(31), eaddr addr_t);
CREATE TABLE emp OF emp_t;
```
In addition, consider the following two queries:
```
SELECT VALUE(emp) FROM emp;
SELECT eno, ename FROM emp;
```
For either query, Oracle Database checks the `SELECT` privilege of the user for the `emp` table. For the first query, the user must obtain the `emp_type` type information to interpret the data. When the query accesses the `emp_type` type, Oracle Database checks the `EXECUTE` privilege of the user.
The second query, however, does not involve named types, so Oracle Database does not check type privileges.
In addition, by using the schema from the previous section, `user3` can perform the following queries:
```
SELECT tab1.col1.attr2 FROM user2.tab1 tab1;
SELECT attr4.attr3.attr2 FROM tab3;
```
Note that in both `SELECT` statements, `user3` does not have explicit privileges on the underlying types, but the statement succeeds because the type and table owners have the necessary privileges with the `GRANT` `OPTION.` Oracle Database checks privileges on the following events, and returns an error if the client does not have the privilege for the action:
````
- Pinning an object in the object cache using its REF value causes Oracle Database to check for the SELECT privilege on the containing object table.
- Modifying an existing object or flushing an object from the object cache causes Oracle Database to check for the UPDATE privilege on the destination object table.
- Flushing a new object causes Oracle Database to check for the INSERT privilege on the destination object table.
- Deleting an object causes Oracle Database to check for the DELETE privilege on the destination table.
- Pinning an object of a named type causes Oracle Database to check EXECUTE privilege on the object.
Modifying the attributes of an object in a client third-generation language application causes Oracle Database to update the entire object. Therefore, the user needs the `UPDATE` privilege on the object table. Having the `UPDATE` privilege on only certain columns of the object table is not sufficient, even if the application only modifies attributes corresponding to those columns. Therefore, Oracle Database does not support column-level privileges for object tables.
## Type Dependencies
As with stored objects, such as procedures and tables, types that are referenced by other objects are called dependencies.
There are some special issues for types on which tables depend. Because a table contains data that relies on the type definition for access, any change to the type causes all stored data to become inaccessible. Changes that can cause this are when necessary privileges required to use the type are revoked, or the type or dependent types are dropped. If these actions occur, then the table becomes invalid and cannot be accessed.
A table that is invalid because of missing privileges can automatically become valid and accessible if the required privileges are granted again. A table that is invalid because a dependent type was dropped can never be accessed again, and the only permissible action is to drop the table.
Because of the severe effects that revoking a privilege on a type or dropping a type can cause, the SQL statements `REVOKE` and `DROP TYPE` , by default, implement restricted semantics. This means that if the named type in either statement has table or type dependents, then an error is received and the statement cancels. However, if the `FORCE` clause for either statement is used, then the statement always succeeds. If there are depended-upon tables, then they are invalidated.
## Related Topics
  - Procedure Privileges
  - Table Privileges
  **````- Oracle Database SQL Language Reference for details about using the REVOKE and DROP TYPE SQL statements
