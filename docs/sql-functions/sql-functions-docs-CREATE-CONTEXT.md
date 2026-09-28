# CREATE CONTEXT

## Purpose
Use the `CREATE` `CONTEXT` statement to:
****
- Create a namespace for a context (a set of application-defined attributes that validates and secures an application)
- Associate the namespace with the externally created package that sets the context
You can use the `DBMS_SESSION`.`SET_CONTEXT` procedure in your designated package to set or reset the attributes of the context.
**See Also:** **
- Oracle Database Security Guide for a discussion of contexts
**````
- Oracle Database PL/SQL Packages and Types Reference for information on the DBMS_SESSION.SET_CONTEXT procedure
## Prerequisites
To create a context namespace, you must have `CREATE` `ANY` `CONTEXT` system privilege.
Note that you cannot use a synonym for a package name in the `CREATE CONTEXT` command.
## Syntax
## *create_context*::=
Description of the illustration create_context.eps
## Semantics
## OR REPLACE
Specify `OR` `REPLACE` to redefine an existing context namespace using a different package.
## *namespace*
Specify the name of the context namespace to create or modify. The name must satisfy the requirements listed in “Database Object Naming Rules”. Context namespaces are always stored in the schema `SYS`.
**See Also:**   “Database Object Naming Rules” for guidelines on naming a context namespace
## *schema*
Specify the schema owning *package*. If you omit *schema*, then Oracle Database uses the current schema.
## *package*
Specify the PL/SQL package that sets or resets the context attributes under the namespace for a user session.
To provide some design flexibility, Oracle Database does not verify the existence of the schema or the validity of the package at the time you create the context.
## SHARING
Use the sharing clause if you want to create the object in an application root in the context of an application maintenance. This type of object is called an application common object and it can be shared with the application PDBs that belong to the application root.
You can specify how the object is shared using one of the following sharing attributes:
- METADATA - A metadata link shares the metadata, but its data is unique to each container. This type of object is referred to as a metadata-linked application common object.
- NONE - The object is not shared and can only be accessed in the application root.
## INITIALIZED Clause
The `INITIALIZED` clause lets you specify an entity other than Oracle Database that can initialize the context namespace.
**EXTERNALLY** `EXTERNALLY` indicates that the namespace can be initialized using an OCI interface when establishing a session.
**See Also:**   *Oracle Call Interface Programmer’s Guide* for information on using OCI to establish a session **GLOBALLY** `GLOBALLY` indicates that the namespace can be initialized by the LDAP directory when a global user connects to the database.
After the session is established, only the designated PL/SQL package can issue commands to write to any attributes inside the namespace.
**See Also:**   *Oracle Database Security Guide* for information on establishing globally initialized contexts
##
## ACCESSED GLOBALLY
This clause indicates that any application context set in *namespace* is accessible throughout the entire instance. This setting lets multiple sessions share application attributes.
## Examples
**Creating an Application Context: Example** This example uses a PL/SQL package `emp_mgmt`, which validates and secures a human resources application. See *Oracle Database PL/SQL Language Reference* for the example that creates that package. The following statement creates the context namespace `hr_context` and associates it with the package `emp_mgmt`:
```
CREATE CONTEXT hr_context USING emp_mgmt;
```
You can control data access based on this context using the `SYS_CONTEXT` function. For example, the `emp_mgmt` package has defined an attribute `department_id` as a particular department identifier. You can secure the base table `employees` by creating a view that restricts access based on the value of `department_id`, as follows:
```
CREATE VIEW hr_org_secure_view AS
   SELECT * FROM employees
   WHERE department_id = SYS_CONTEXT('hr_context', 'department_id');
```
**See Also:**   SYS_CONTEXT and *Oracle Database Security Guide* for more information on using application contexts to retrieve user information
