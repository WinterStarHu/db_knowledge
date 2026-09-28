# CREATE SYNONYM

## Purpose
Use the `CREATE` `SYNONYM` statement to create a **synonym**, which is an alternative name for a table, view, sequence, operator, procedure, stored function, package, materialized view, Java class schema object, user-defined object type, or another synonym. A synonym places a dependency on its target object and becomes invalid if the target object is changed or dropped.
Synonyms provide both data independence and location transparency. Synonyms permit applications to function without modification regardless of which user owns the table or view and regardless of which database holds the table or view. However, synonyms are not a substitute for privileges on database objects. Appropriate privileges must be granted to a user before the user can use the synonym.
You can refer to synonyms in the following DML statements: `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `FLASHBACK` `TABLE`, `EXPLAIN` `PLAN`, `LOCK` `TABLE`, `MERGE`, and `CALL` .
You can refer to synonyms in the following DDL statements: `AUDIT`, `NOAUDIT`, `GRANT`, `REVOKE`, and `COMMENT`.
**See Also:**   *Oracle Database Concepts* for general information on synonyms
## Prerequisites
To create a private synonym in your own schema, you must have the `CREATE` `SYNONYM` system privilege.
To create a private synonym in another user’s schema, you must have the `CREATE` `ANY` `SYNONYM` system privilege.
To create a `PUBLIC` synonym, you must have the `CREATE` `PUBLIC` `SYNONYM` system privilege.
## Syntax
## *create_synonym*::=
Description of the illustration create_synonym.eps
## Semantics
## OR REPLACE
Specify `OR` `REPLACE` to re-create the synonym if it already exists. Use this clause to change the definition of an existing synonym without first dropping it.
**Restriction on Replacing a Synonym** You cannot use the `OR` `REPLACE` clause for a type synonym that has any dependent tables or dependent valid user-defined object types.
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the synonym does not exist, a new one is created at the end of the statement.
- If the synonym exists, it is detected and a new one is not created.
You can only specify `OR REPLACE` or `IF NOT EXISTS` in a statement at a time. Using both `OR REPLACE` with `IF NOT EXISTS` in the very same statement results in an error.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## [ EDITIONABLE | NONEDITIONABLE ]
Use these clauses to specify whether the synonym is an editioned or noneditioned object if editioning is enabled for the schema object type `SYNONYM` in *schema*. For private synonyms, the default is `EDITIONABLE`. For public synonyms, the default is `NONEDITIONABLE`. For information about editioned and noneditioned objects, see *Oracle Database Development Guide*.
## PUBLIC
Specify `PUBLIC` to create a public synonym. Public synonyms are accessible to all users. However each user must have appropriate privileges on the underlying object in order to use the synonym.
When resolving references to an object, Oracle Database uses a public synonym only if the object is not prefaced by a schema and is not followed by a database link.
If you omit this clause, then the synonym is private. A private synonym name must be unique in its schema. A private synonym is accessible to users other than the owner only if those users have appropriate privileges on the underlying database object and specify the schema along with the synonym name.
Notes on Public Synonyms The following notes apply to public synonyms:
- If you create a public synonym and it subsequently has dependent tables or dependent valid user-defined object types, then you cannot create another database object of the same name as the synonym in the same schema as the dependent objects.
- Take care not to create a public synonym with the same name as an existing schema. If you do so, then all PL/SQL units that use that name will be invalidated.
## *schema*
Specify the schema to contain the synonym. If you omit *schema*, then Oracle Database creates the synonym in your own schema. You cannot specify a schema for the synonym if you have specified `PUBLIC`.
## *synonym*
Specify the name of the synonym to be created. The name must satisfy the requirements listed in “Database Object Naming Rules”.
```
    **See Also:**   "[CREATE SYNONYM: Examples](CREATE-SYNONYM.html#GUID-A806C82F-1171-478E-A910-F9C6C42739B2__I2153082)" and "[Oracle Database Resolution of Synonyms: Example](CREATE-SYNONYM.html#GUID-A806C82F-1171-478E-A910-F9C6C42739B2__I2102145)"
```
## SHARING
This clause applies only when creating a synonym in an application root. This type of synonym is called an application common object and it can be shared with the application PDBs that belong to the application root. To determine how the synonym is shared, specify one of the following sharing attributes:
****
- METADATA - A metadata link shares the synonym’s metadata, but its data is unique to each container. This type of synonym is referred to as a metadata-linked application common object.
- NONE - The synonym is not shared.
If you omit this clause, then the database uses the value of the `DEFAULT_SHARING` initialization parameter to determine the sharing attribute of the synonym. If the `DEFAULT_SHARING` initialization parameter does not have a value, then the default is `METADATA`.
You cannot change the sharing attribute of a synonym after it is created.
**See Also:** **
- Oracle Database Reference for more information on the DEFAULT_SHARING initialization parameter
**
- Oracle Database Administrator’s Guide for complete information on creating application common objects
## FOR Clause
Specify the object for which the synonym is created. The schema object for which you are creating the synonym can be of the following types:
- Table or object table
- View or object view
- Sequence
- Stored procedure, function, or package
- Materialized view
- Java class schema object
- User-defined object type
- Synonym
The schema object need not currently exist and you need not have privileges to access the object.
Restriction on the FOR Clause The schema object cannot be contained in a package.
***schema*** Specify the schema in which the object resides. If you do not qualify object with *schema*, then the database assumes that the schema object is in your own schema.
If you are creating a synonym for a procedure or function on a remote database, then you must specify *schema* in this `CREATE` statement. Alternatively, you can create a local public synonym on the database where the object resides. However, the database link must then be included in all subsequent calls to the procedure or function.
***dblink*** You can specify a complete or partial database link to create a synonym for a schema object on a remote database where the object is located. If you specify *dblink* and omit *schema*, then the synonym refers to an object in the schema specified by the database link. Oracle recommends that you specify the schema containing the object in the remote database.
If you omit *dblink*, then Oracle Database assumes the object is located on the local database.
**Restriction on Database Links** You cannot specify *dblink* for a Java class synonym.
**See Also:**
- “References to Objects in Remote Databases” for more information on referring to database links
- CREATE DATABASE LINK for more information on creating database links
## Examples
**CREATE SYNONYM: Examples** To define the synonym `offices` for the table `locations` in the schema `hr`, issue the following statement:
```
CREATE SYNONYM offices
   FOR hr.locations;
```
To create a `PUBLIC` synonym for the `employees` table in the schema `hr` on the `remote` database, you could issue the following statement:
```
CREATE PUBLIC SYNONYM emp_table
   FOR hr.employees@remote.us.example.com;
```
A synonym may have the same name as the underlying object, provided the underlying object is contained in another schema.
**Oracle Database Resolution of Synonyms: Example** Oracle Database attempts to resolve references to objects at the schema level before resolving them at the `PUBLIC` synonym level. For example, the schemas `oe` and `sh` both contain tables named `customers`. In the next example, user `SYSTEM` creates a `PUBLIC` synonym named `customers` for `oe.customers`:
```
CREATE PUBLIC SYNONYM customers FOR oe.customers;
```
If the user `sh` then issues the following statement, then the database returns the count of rows from `sh.customers`:
```
SELECT COUNT(*) FROM customers;
```
To retrieve the count of rows from `oe.customers`, the user `sh` must preface `customers` with the schema name. (The user `sh` must have select permission on `oe.customers` as well.)
```
SELECT COUNT(*) FROM oe.customers;
```
If the user `hr`’s schema does not contain an object named `customers`, and if `hr` has select permission on `oe.customers`, then `hr` can access the `customers` table in `oe`’s schema by using the public synonym `customers`:
```
SELECT COUNT(*) FROM customers;
```
