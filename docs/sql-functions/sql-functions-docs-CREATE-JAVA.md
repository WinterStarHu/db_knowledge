# CREATE JAVA

## Purpose
Use the `CREATE` `JAVA` statement to create a schema object containing a Java source, class, or resource.
**See Also:** **
- Oracle Database Java Developer’s Guide for Java concepts and information about Java stored procedures
**
- Oracle Database JDBC Developer’s Guide for information on JDBC
## Prerequisites
To create or replace a schema object containing a Java source, class, or resource in your own schema, you must have `CREATE` `PROCEDURE` system privilege. To create or replace such a schema object in another user’s schema, you must have `CREATE` `ANY` `PROCEDURE` system privilege.
## Syntax
## *create_java*::=
Description of the illustration create_java.eps
## *invoker_rights_clause*::=
Description of the illustration invoker_rights_clause.eps
## Semantics
## OR REPLACE
Specify `OR` `REPLACE` to re-create the schema object containing the Java class, source, or resource if it already exists. Use this clause to change the definition of an existing object without dropping, re-creating, and regranting object privileges previously granted.
If you redefine a Java schema object and specify `RESOLVE` or `COMPILE`, then Oracle Database recompiles or resolves the object. Whether or not the resolution or compilation is successful, the database invalidates classes that reference the Java schema object.
Users who had previously been granted privileges on a redefined function can still access the function without being regranted the privileges.
**See Also:**   ALTER JAVA for additional information
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the JAVA object does not exist, a new one is created at the end of the statement.
- If the JAVA object view exists, it is detected and a new one is not created.
You can only specify `OR REPLACE` or `IF NOT EXISTS` in a statement at a time. Using both `OR REPLACE` with `IF NOT EXISTS` in the very same statement results in an error.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## RESOLVE | COMPILE
`RESOLVE` and `COMPILE` are synonymous keywords. They specify that Oracle Database should attempt to resolve the Java schema object that is created if this statement succeeds.
- When applied to a class, resolution of referenced names to other class schema objects occurs.
- When applied to a source, source compilation occurs.
**Restriction on RESOLVE and COMPILE** You cannot specify these keywords for a Java resource.
## NOFORCE
Specify `NOFORCE` to roll back the results of this `CREATE` command if you have specified either `RESOLVE` or `COMPILE` and the resolution or compilation fails. If you do not specify this option, then Oracle Database takes no action if the resolution or compilation fails, and the created schema object remains.
## JAVA SOURCE Clause
Specify `JAVA` `SOURCE` to load a Java source file.
## JAVA CLASS Clause
Specify `JAVA` `CLASS` to load a Java class file.
## JAVA RESOURCE Clause
Specify `JAVA` `RESOURCE` to load a Java resource file.
## NAMED Clause
The `NAMED` clause is required for a Java source or resource. The *primary_name* must be enclosed in double quotation marks and its length must not exceed 4000 bytes in the database character set.
``````
- For a Java source, this clause specifies the name of the schema object in which the source code is held. A successful CREATE JAVA SOURCE statement will also create additional schema objects to hold each of the Java classes defined by the source.
- For a Java resource, this clause specifies the name of the schema object to hold the Java resource.
Use double quotation marks to preserve a loweror mixed-case *primary_name*.
If you do not specify *schema*, then Oracle Database creates the object in your own schema.
**Restrictions on NAMED Java Classes**
The `NAMED` clause is subject to the following restrictions:
- You cannot specify NAMED for a Java class.
**
- The primary_name cannot contain a database link.
## SCHEMA Clause
The `SCHEMA` clause applies only to a Java class. This optional clause specifies the schema in which the object containing the Java file will reside. If you do not specify this clause, then Oracle Database creates the object in your own schema.
## SHARING
This clause applies only when creating a Java schema object in an application root. This type of object is called an application common object and it can be shared with the application PDBs that belong to the application root. To determine how the Java schema object is shared, specify one of the following sharing attributes:
****
- METADATA - A metadata link shares the Java schema object’s metadata, but its data is unique to each container. This type of Java schema object is referred to as a metadata-linked application common object.
- NONE - The Java schema object is not shared.
If you omit this clause, then the database uses the value of the `DEFAULT_SHARING` initialization parameter to determine the sharing attribute of the Java schema object. If the `DEFAULT_SHARING` initialization parameter does not have a value, then the default is `METADATA`.
You cannot change the sharing attribute of a Java schema object after it is created.
```

```
## *invoker_rights_clause*
Use the *invoker_rights_clause* to indicate whether the methods of the class execute with the privileges and in the schema of the user who owns the class or with the privileges and in the schema of `CURRENT_USER`.
This clause also determines how Oracle Database resolves external names in queries, DML operations, and dynamic SQL statements in the member functions and procedures of the type.
**AUTHID CURRENT_USER**
`CURRENT_USER` indicates that the methods of the class execute with the privileges of `CURRENT_USER`. This clause is the default and creates an **invoker-rights class**.
This clause also specifies that external names in queries, DML operations, and dynamic SQL statements resolve in the schema of `CURRENT_USER`. External names in all other statements resolve in the schema in which the methods reside.
**AUTHID DEFINER**
`DEFINER` indicates that the methods of the class execute with the privileges of the owner of the schema in which the class resides, and that external names resolve in the schema where the class resides. This clause creates a **definer-rights class**.
**See Also:**
**
- Oracle Database Java Developer’s Guide
**
- Oracle Database PL/SQL Language Reference for information on how CURRENT_USER is determined
## RESOLVER Clause
The `RESOLVER` clause lets you specify a mapping of the fully qualified Java name to a Java schema object, where:
**
- match_string is either a fully qualified Java name, a wildcard that can match such a Java name, or a wildcard that can match any name.
**
- schema_name designates a schema to be searched for the corresponding Java schema object.
****
- A dash (-) as an alternative to schema_name indicates that if match_string matches a valid Java name, Oracle Database can leave the name unresolved. The resolution succeeds, but the name cannot be used at run time by the class.
This mapping is stored with the definition of the schema objects created in this command for use in later resolutions (either implicit or in explicit `ALTER` `JAVA` … `RESOLVE` statements).
## USING Clause
The `USING` clause determines a sequence of character data (`CLOB` or `BFILE`) or binary data (`BLOB` or `BFILE`) for the Java class or resource. Oracle Database uses the sequence of characters to define one file for a Java class or resource, or one source file and one or more derived classes for a Java source.
**BFILE Clause**
Specify the directory and filename of a previously created file on the operating system (*directory_object_name*) and server file (*server_file_name*) containing the sequence. `BFILE` is usually interpreted as a character sequence by `CREATE` `JAVA` `SOURCE` and as a binary sequence by `CREATE` `JAVA` `CLASS` or `CREATE` `JAVA` `RESOURCE`.
**CLOB | BLOB | BFILE** ***subquery***
Specify a subquery that selects a single row and column of the type specified (`CLOB`, `BLOB`, or `BFILE`). The value of the column makes up the sequence of characters.
**Note:**   In earlier releases, the `USING` clause implicitly supplied the keyword `SELECT`. This is no longer the case. However, the subquery without the keyword `SELECT` is still supported for backward compatibility.
***key_for_BLOB***
The *key_for_BLOB* clause supplies the following implicit query:
```
SELECT LOB FROM CREATE$JAVA$LOB$TABLE WHERE NAME = 'key_for_BLOB';
```
**Restriction on the** ***key_for_BLOB*** **Clause**
For you to use this case, the table `CREATE$JAVA$LOB$TABLE` must exist in the current schema and must have a column LOB of type `BLOB` and a column `NAME` of type `VARCHAR2`.
## AS*source_char*
Specify a sequence of characters for a Java source.
## Examples
**Creating a Java Class Object: Example**
The following statement creates a schema object containing a Java class using the name found in a Java binary file:
```
CREATE JAVA CLASS USING BFILE (java_dir, 'Agent.class') /
```
This example assumes the directory object `java_dir`, which points to the operating system directory containing the Java class `Agent.class`, already exists. In this example, the name of the class determines the name of the Java class schema object.
**Creating a Java Source Object: Example**
The following statement creates a Java source schema object:
```
CREATE JAVA SOURCE NAMED "Welcome" AS public class Welcome { public static String welcome() { return "Welcome World";   } } /
```
**Creating a Java Resource Object: Example**
The following statement creates a Java resource schema object named `apptext` from a `bfile`:
```
CREATE JAVA RESOURCE NAMED "appText" USING BFILE (java_dir, 'textBundle.dat') /
```
