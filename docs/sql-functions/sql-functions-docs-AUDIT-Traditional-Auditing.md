# AUDIT (Traditional Auditing)

This section describes the `AUDIT` statement for **traditional** **auditing**, which is the same auditing functionality used in releases earlier than Oracle Database 12*c*.
Beginning with Oracle Database 12*c*, Oracle introduces **unified** **auditing**, which provides a full set of enhanced auditing features. For backward compatibility, traditional auditing is still supported. However, Oracle recommends that you plan the migration of your existing audit settings to the new unified audit policy syntax. For new audit requirements, Oracle recommends that you use the new unified auditing. Traditional auditing may be desupported in a future major release.
**See Also:**   AUDIT (Unified Auditing) for a description of the `AUDIT` statement for unified auditing
## Purpose
Use the `AUDIT` statement to:
- Track the issuance of SQL statements in subsequent user sessions. You can track the issuance of a specific SQL statement or of all SQL statements authorized by a particular system privilege. Auditing operations on SQL statements apply only to subsequent sessions, not to current sessions.
- Track operations on a specific schema object. Auditing operations on schema objects apply to current sessions as well as to subsequent sessions.
**See Also:** **
- [[ANCHOR:d311045e229]]Oracle Database PL/SQL Packages and Types Reference for information on the DBMS_FGA package, which lets you create and administer value-based auditing policies
- NOAUDIT (Traditional Auditing)
## Prerequisites
To audit issuances of a SQL statement, you must have the `AUDIT` `SYSTEM` system privilege. However, the `AUDIT` `SYSTEM` system privilege is not required when you use the `IN` `SESSION` `CURRENT` clause.
To collect auditing results, you must enable auditing by setting the initialization parameter `AUDIT_TRAIL` to a value other than the default setting of `NONE`. You can specify auditing options regardless of whether auditing is enabled. However, Oracle Database does not generate audit records until you enable auditing.
To audit operations on a schema object, the object you choose for auditing must be in your own schema or you must have `AUDIT` `ANY` system privilege. In addition, if the object you choose for auditing is a directory object, even if you created it, then you must have `AUDIT` `ANY` system privilege.
When you are connected to a multitenant container database (CDB), you must have the privileges described in this section, either granted locally in the current container or granted commonly.
To specify the `CONTAINER` clause, you must be connected to a multitenant container database (CDB). To specify `CONTAINER` `=` `CURRENT`, the current container must be a pluggable database (PDB). To specify `CONTAINER` `=` `ALL`, the current container must be the root.
**Notes on Using the AUDIT Statement in a CDB** When you issue the `AUDIT` statement in a CDB, the database performs auditing as follows:
``````
- If you issue the AUDIT statement when the current container is a PDB, then the database performs auditing in that PDB. If you specify the auditing_by_clause, then user must be a local user in the PDB or a common user. If you specify the audit_schema_object_clause, then the object must be a local object in the PDB.
````````
****`````` ******
- If you issue the AUDIT statement when the current container is the root, then the database performs auditing across the entire CDB, that is, in the root and all PDBs. If you specify the auditing_by_clause, then user must be a common user. If you omit the auditing_by_clause, then all common users are audited. If you specify the audit_schema_object_clause, then the object must be a local object in the root or a common object. Note: The AUDIT ANY system privileges allows the grantee to audit any object in any schema except the SYS schema. See Also: Oracle Database Reference for information on the AUDIT_TRAIL parameter
## Syntax
## *audit*::=
Description of the illustration audit.eps
## *audit_operation_clause*::=
Description of the illustration audit_operation_clause.eps
## *auditing_by_clause*::=
Description of the illustration auditing_by_clause.eps
## *audit_schema_object_clause*::=
Description of the illustration audit_schema_object_clause.eps
## *auditing_on_clause*::=
Description of the illustration auditing_on_clause.eps
## Semantics
## *audit_operation_clause*
Use the *audit_operation_clause* to audit specified operations, regardless of the schema objects affected by the operations.
## *sql_statement_shortcut*
Specify a shortcut to audit the use of specific SQL statements. Table 12-1 and Table 12-2 list the shortcuts and the SQL statements they audit.
```

```
For each audited operation, Oracle Database produces an audit record containing this information:
- The user performing the operation
- The type of operation
- The object involved in the operation
- The date and time of the operation
Oracle Database writes audit records to the audit trail, which is a database table containing audit records. You can review database activity by examining the audit trail through data dictionary views.
**See Also:** ******
- Oracle Database Security Guide 11g Release 2 (11.2) for a listing of the audit trail data dictionary views. Refer to Oracle Database Upgrade Guide for instructions on how to locate the Oracle Database 11g Release 2 (11.2) documentation.
**
- Oracle Database Reference for detailed descriptions of the data dictionary views
- “Auditing SQL Statements Relating to Roles: Example”
## *system_privilege*
Specify a system privilege to audit SQL statements and other operations that are authorized by the specified system privilege.
**Note:** Auditing the use of a system privilege containing the `ANY` keyword is more restrictive than auditing the use of the same privilege without the `ANY` keyword. For example:
````````````````
- AUDIT CREATE PROCEDURE audits the statements issued using either the CREATE PROCEDURE or CREATE ANY PROCEDURE privilege.
``````````````
- AUDIT CREATE ANY PROCEDURE audits only those statements issued using the CREATE ANY PROCEDURE privilege.
Rather than specifying many individual system privileges, you can specify the roles `CONNECT`, `RESOURCE`, and `DBA`. Doing so is equivalent to auditing all of the system privileges granted to those roles.
Oracle Database also provides three shortcuts for specifying groups of system privileges and statement options at once:
**ALL** Specify `ALL` to audit all statements options shown in Table 12-1 but not the additional statement options shown in Table 12-2.
**ALL STATEMENTS** Specify `ALL` `STATEMENTS` to audit all **top-level SQL statements** executed. Top-level SQL statements are issued directly by a user. SQL statements run from within a PL/SQL procedure or function are not considered top-level statements. Therefore, this clause does not audit the statements executed within PL/SQL procedures or functions. However, the execution of the PL/SQL procedure or function itself is audited. This clause is useful if you want to audit all the statements in a specific environment, regardless of other auditing configurations that are system wide or user specific.
**ALL PRIVILEGES** Specify `ALL` `PRIVILEGES` to audit system privileges.
**Note:**   Oracle recommends that you specify individual system privileges and statement options for auditing rather than roles or shortcuts. The specific system privileges and statement options encompassed by roles and shortcuts change from one release to the next and may not be supported in future versions of Oracle Database.
**See Also:**
- Table 18-1 for a list of all system privileges and the operations that they authorize
**``````
- Oracle Database Security Guide for more information on the CONNECT, RESOURCE, and DBA roles
- “Auditing Query and Update SQL Statements: Example”, “Auditing Deletions: Example”, and “Auditing Statements Relating to Directories: Examples”
## *auditing_by_clause*
Specify the *auditing_by_clause* to restrict auditing to only SQL statements issued by the specified users. If you omit this clause, then Oracle Database audits all users’ statements.
## IN SESSION CURRENT
Use this clause to limit auditing to the current session. Auditing will persist until the end of the session and cannot be stopped using the `NOAUDIT` statement.
## *audit_schema_object_clause*
Use the *audit_schema_object_clause* to audit operations on specific schema objects.
**Restriction on the** ***audit_schema_object_clause*** When connected to a CDB, you can specify the `audit_schema_object_clause`, but you cannot also specify the `CONTAINER` clause. This restriction does not limit functionality because the only allowed values for the `CONTAINER` clause are the default values. Refer to CONTAINER Clause for more information.
***sql_operation*** Specify the SQL operation to be audited. Table 12-3 shows the types of objects that can be audited, and for each object the SQL statements that can be audited. For example, if you choose to audit a table with the `ALTER` operation, then Oracle Database audits all `ALTER` `TABLE` statements issued against the table. If you choose to audit a sequence with the `SELECT` operation, then the database audits all statements that use any values of the sequence.
**ALL** Specify `ALL` as a shortcut equivalent to specifying all SQL operations applicable for the type of object.
## *auditing_on_clause*
The *auditing_on_clause* lets you specify the particular schema object to be audited.
**See Also:**   “Auditing Queries on a Table: Example”, “Auditing Inserts and Updates on a Table: Example”, and “Auditing Operations on a Sequence: Example” ***schema*** Specify the schema containing the object chosen for auditing. If you omit *schema*, then Oracle Database assumes the object is in your own schema.
***object*** Specify the name of the object to be audited. The object must be a table, view, sequence, stored procedure, function, package, materialized view, mining model, or library.
You can also specify a synonym for a table, view, sequence, procedure, stored function, package, materialized view, or user-defined type.
**ON DEFAULT** Specify `ON` `DEFAULT` to establish the specified object options as default object options for subsequently created objects. After you have established these default auditing options, any subsequently created object is automatically audited with those options. The default auditing options for a view are always the union of the auditing options for the base tables of the view. You can see the current default auditing options by querying the `ALL_DEF_AUDIT_OPTS` data dictionary view.
When you change the default auditing options, the auditing options for previously created objects remain the same. You can change the auditing options for an existing object only by specifying the object in the `ON` clause of the `AUDIT` statement.
**See Also:**   “Setting Default Auditing Options: Example” **ON DIRECTORY** The `ON` `DIRECTORY` clause lets you specify the name of a directory chosen for auditing.
**ON MINING MODEL** The `ON` `MINING` `MODEL` clause lets you specify the name of a mining model to be audited.
**ON SQL TRANSLATION PROFILE** The `ON` `SQL` `TRANSLATION` `PROFILE` clause lets you specify the name of a SQL translation profile to be audited.
## NETWORK
Use this clause to detect internal failures in the network layer.
**See Also:**   *Oracle Database Security Guide 11g Release 2 (11.2)* for information on network auditing. Refer to *Oracle Database Upgrade Guide* for instructions on how to locate the Oracle Database 11*g* Release 2 (11.2) documentation.
## DIRECT_PATH LOAD
Use this clause to audit SQL*Loader direct path loads.
## BY SESSION
In earlier releases, `BY` `SESSION` caused the database to write a single record for all SQL statements or operations of the same type executed on the same schema objects in the same session. Beginning with this release of Oracle Database, both `BY` `SESSION` and `BY` `ACCESS` cause Oracle Database to write one audit record for each audited statement and operation. `BY` `SESSION` continues to populate different values to the audit trail compared with `BY` `ACCESS`. Oracle recommends that you include the `BY` `ACCESS` clause for all `AUDIT` statements, which results in a more detailed audit record. If you specify neither clause, then `BY` `ACCESS` is the default.
**Note:**   This change applies only to schema object audit options, statement options and system privileges that audit SQL statements other than data definition language (DDL) statements. The database has always audited `BY` `ACCESS` all SQL statements and system privileges that audit a DDL statement.
## BY ACCESS
Specify `BY` `ACCESS` if you want Oracle Database to write one record for each audited statement and operation.
**Note:**   If you specify either a SQL statement shortcut or a system privilege that audits a data definition language (DDL) statement, then the database always audits by access. In all other cases, the database honors the `BY` `SESSION` or `BY` `ACCESS` specification.
For statement options and system privileges that audit SQL statements other than DDL, you can specify either `BY` `SESSION` or `BY` `ACCESS`. `BY` `ACCESS` is the default.
## WHENEVER [NOT] SUCCESSFUL
Specify `WHENEVER` `SUCCESSFUL` to audit only SQL statements and operations that succeed.
Specify `WHENEVER` `NOT` `SUCCESSFUL` to audit only SQL statements and operations that fail or result in errors.
If you omit this clause, then Oracle Database performs the audit regardless of success or failure.
## CONTAINER Clause
The `CONTAINER` clause applies only when you are connected to a CDB. You can use this clause to specify the scope of the `AUDIT` statement. However, it is not necessary to specify the `CONTAINER` clause because its default values are the only allowed values.
````````
- If you issue the AUDIT statement when the current container is a PDB, then you can optionally specify CONTAINER = CURRENT, which is the default.
````````
- If you issue the AUDIT statement when the current container is the root, then you can optionally specify CONTAINER = ALL, which is the default.
## Tables of Auditing Options
Table 1 SQL Statement Shortcuts for Auditing

| SQL Statement Shortcut | SQL Statements and Operations Audited |
|---|---|
| ALTER SYSTEM | ALTER SYSTEM |
| CLUSTER | CREATE CLUSTERALTER CLUSTERDROP CLUSTERTRUNCATE CLUSTER |
| CONTEXT | CREATE CONTEXTDROP CONTEXT |
| DATABASE LINK | CREATE DATABASE LINKALTER DATABASE LINKDROP DATABASE LINK |
| DIMENSION | CREATE DIMENSIONALTER DIMENSIONDROP DIMENSION |
| DIRECTORY | CREATE DIRECTORYDROP DIRECTORY |
| INDEX | CREATE INDEXALTER INDEXANALYZE INDEXDROP INDEX |
| MATERIALIZED VIEW | CREATE MATERIALIZED VIEWALTER MATERIALIZED VIEWDROP MATERIALIZED VIEW |
| NOT EXISTS | All SQL statements that fail because a specified object does not exist. |
| OUTLINE | CREATE OUTLINEALTER OUTLINEDROP OUTLINE |
| PLUGGABLE DATABASE | CREATE PLUGGABLE DATABASEALTER PLUGGABLE DATABASEDROP PLUGGABLE DATABASE |
| PROCEDURE (See note at end of table) | CREATE FUNCTIONCREATE LIBRARYCREATE PACKAGECREATE PACKAGE BODYCREATE PROCEDUREDROP FUNCTIONDROP LIBRARYDROP PACKAGEDROP PROCEDURE |
| PROFILE | CREATE PROFILEALTER PROFILEDROP PROFILE |
| PUBLIC DATABASE LINK | CREATE PUBLIC DATABASE LINKALTER PUBLIC DATABASE LINKDROP PUBLIC DATABASE LINK |
| PUBLIC SYNONYM | CREATE PUBLIC SYNONYMDROP PUBLIC SYNONYM |
| ROLE | CREATE ROLEALTER ROLEDROP ROLESET ROLE |
| ROLLBACK SEGMENT | CREATE ROLLBACK SEGMENTALTER ROLLBACK SEGMENTDROP ROLLBACK SEGMENT |
| SEQUENCE | CREATE SEQUENCEDROP SEQUENCE |
| SESSION | Logons |
| SYNONYM | CREATE SYNONYMDROP SYNONYM |
| SYSTEM AUDIT | AUDIT sql_statementsNOAUDIT sql_statements |
| SYSTEM GRANT | GRANT system_privileges_and_rolesREVOKE system_privileges_and_roles |
| TABLE | CREATE TABLEDROP TABLETRUNCATE TABLE |
| TABLESPACE | CREATE TABLESPACEALTER TABLESPACEDROP TABLESPACE |
| TRIGGER | CREATE TRIGGERALTER TRIGGER with ENABLE and DISABLE clausesDROP TRIGGERALTER TABLE with ENABLE ALL TRIGGERS clause and DISABLE ALL TRIGGERS clause |
| TYPE | CREATE TYPECREATE TYPE BODYALTER TYPEDROP TYPEDROP TYPE BODY |
| USER | CREATE USERALTER USERDROP USERNotes: AUDIT USER audits these three SQL statements. Use AUDIT ALTER USER to audit statements that require the ALTER USER system privilege. An AUDIT ALTER USER statement does not audit a user changing his or her own password, as this activity does not require the ALTER USER system privilege. |
| VIEW | CREATE VIEWDROP VIEW |

**Note:**   Java schema objects (sources, classes, and resources) are considered the same as procedures for purposes of auditing SQL statements.
Table 2 Additional SQL Statement Shortcuts for Auditing

| SQL Statement Shortcut | SQL Statements and Operations Audited |
|---|---|
| ALTER SEQUENCE | ALTER SEQUENCE |
| ALTER TABLE | ALTER TABLE |
| COMMENT TABLE | COMMENT ON TABLE table, view, materialized viewCOMMENT ON COLUMN table.column, view.column, materialized view.column |
| DELETE TABLE | DELETE FROM table, view |
| EXECUTE DIRECTORY | Execution of any program in a directory |
| EXECUTE PROCEDURE | CALLExecution of any procedure or function or access to any variable, library, or cursor inside a package |
| GRANT DIRECTORY | GRANT privilege ON directoryREVOKE privilege ON directory |
| GRANT PROCEDURE | GRANT privilege ON procedure, function, packageREVOKE privilege ON procedure, function, package |
| GRANT SEQUENCE | GRANT privilege ON sequenceREVOKE privilege ON sequence |
| GRANT TABLE | GRANT privilege ON table, view, materialized viewREVOKE privilege ON table, view, materialized view |
| GRANT TYPE | GRANT privilege ON TYPEREVOKE privilege ON TYPE |
| INSERT TABLE | INSERT INTO table, view |
| LOCK TABLE | LOCK TABLE table, view |
| READ DIRECTORY | Read operations on a directory |
| SELECT SEQUENCE | Any statement containing sequence.CURRVAL or sequence.NEXTVAL |
| SELECT TABLE | SELECT FROM table, view, materialized view |
| UPDATE TABLE | UPDATE table, view |
| WRITE DIRECTORY | Write operations on a directory |

Table 3 Schema Object Auditing Options

| Object | SQL Operations |
|---|---|
| Table | ALTERAUDITCOMMENTDELETEFLASHBACK (Note 1)GRANTINDEXINSERTLOCKRENAMESELECTUPDATE |
| View | AUDITCOMMENTDELETEFLASHBACK (Note 1)GRANTINSERTLOCKRENAMESELECTUPDATE |
| Sequence | ALTERAUDITGRANTSELECT |
| Procedure, Function, Package (Note 2) | AUDITEXECUTE (Notes 3 and 4)GRANT |
| Materialized View (Note 5) | ALTERAUDITCOMMENTDELETEINDEXINSERTLOCKSELECTUPDATE |
| Mining Model | AUDITCOMMENTGRANTRENAMESELECT |
| Directory | AUDITGRANTREAD |
| Library | EXECUTEGRANT |
| Object Type | ALTERAUDITGRANT |

Note 1: The `FLASHBACK` audit object option applies only to flashback queries.
Note 2: Java schema objects (sources, classes, and resources) are considered the same as procedures, functions, and packages for purposes of auditing options.
Note 3: When you audit the `EXECUTE` operation on a PL/SQL stored procedure or stored function, the database considers only its ability to find the procedure or function and authorize its execution when determining the success or failure of the operation for the purposes of auditing. Therefore, if you specify the `WHENEVER` `NOT` `SUCCESSFUL` clause, then only invalid object errors, non-existent object errors, and authorization failures are audited; errors encountered during the execution of the procedure or function are not audited. If you specify the `WHENEVER` `SUCCESSFUL` clause, then all executions that are not blocked by invalid object errors, non-existent object errors, or authorization failures are audited, regardless of whether errors are encountered during execution.
Note 4: To audit the failure of a recursive SQL operation inside a PL/SQL stored procedure or stored function, configure auditing for the SQL operation.
Note 5: You can audit `INSERT`, `UPDATE`, and `DELETE` operations only on updatable materialized views.
## Examples
**Auditing SQL Statements Relating to Roles: Example** To choose auditing for every SQL statement that creates, alters, drops, or sets a role, regardless of whether the statement completes successfully, issue the following statement:
```
AUDIT ROLE;
```
To choose auditing for every statement that successfully creates, alters, drops, or sets a role, issue the following statement:
```
AUDIT ROLE
    WHENEVER SUCCESSFUL;
```
To choose auditing for every `CREATE` `ROLE`, `ALTER` `ROLE`, `DROP` `ROLE`, or `SET` `ROLE` statement that results in an Oracle Database error, issue the following statement:
```
AUDIT ROLE
    WHENEVER NOT SUCCESSFUL;
```
**Auditing Query and Update SQL Statements: Example** To choose auditing for any statement that queries or updates any table, issue the following statement:
```
AUDIT SELECT TABLE, UPDATE TABLE;
```
To choose auditing for statements issued by the users `hr` and `oe` that query or update a table or view, issue the following statement
```
AUDIT SELECT TABLE, UPDATE TABLE
    BY hr, oe;
```
**Auditing Deletions: Example** To choose auditing for statements issued using the `DELETE` `ANY` `TABLE` system privilege, issue the following statement:
```
AUDIT DELETE ANY TABLE;
```
**Auditing Statements Relating to Directories: Examples** To choose auditing for statements issued using the `CREATE` `ANY` `DIRECTORY` system privilege, issue the following statement:
```
AUDIT CREATE ANY DIRECTORY;
```
To choose auditing for `CREATE` `DIRECTORY` (and `DROP` `DIRECTORY`) statements that do not use the `CREATE` `ANY` `DIRECTORY` system privilege, issue the following statement:
```
AUDIT DIRECTORY;
```
To choose auditing for every statement that reads files from the `bfile_dir` directory, issue the following statement:
```
AUDIT READ ON DIRECTORY bfile_dir;
```
To choose auditing for every statement that reads files from any directory, issue the following statement:
```
AUDIT READ DIRECTORY;
```
**Auditing Queries on a Table: Example** To choose auditing for every SQL statement that queries the `employees` table in the schema `hr`, issue the following statement:
```
AUDIT SELECT
    ON hr.employees;
```
To choose auditing for every statement that successfully queries the `employees` table in the schema `hr`, issue the following statement:
```
AUDIT SELECT
    ON hr.employees
    WHENEVER SUCCESSFUL;
```
To choose auditing for every statement that queries the `employees` table in the schema `hr` and results in an Oracle Database error, issue the following statement:
```
AUDIT SELECT
    ON hr.employees
    WHENEVER NOT SUCCESSFUL;
```
**Auditing Inserts and Updates on a Table: Example** To choose auditing for every statement that inserts or updates a row in the `customers` table in the schema `oe`, issue the following statement:
```
AUDIT INSERT, UPDATE
    ON oe.customers;
```
**Auditing Operations on a Sequence: Example** To choose auditing for every statement that performs any operation on the `employees_seq` sequence in the schema `hr`, issue the following statement:
```
AUDIT ALL
    ON hr.employees_seq;
```
The preceding statement uses the `ALL` shortcut to choose auditing for the following statements that operate on the sequence:
````
- ALTER SEQUENCE
- AUDIT
- GRANT
````
- any statement that accesses the values of the sequence using the pseudocolumns CURRVAL or NEXTVAL
**Setting Default Auditing Options: Example** The following statement specifies default auditing options for objects created in the future:
```
AUDIT ALTER, GRANT, INSERT, UPDATE, DELETE
    ON DEFAULT;
```
Any objects created later are automatically configured for audit with the specified options that apply to them.
``````````
- If you create a table, then Oracle Database automatically configures audit options ALTER, GRANT, INSERT, UPDATE, or DELETE issued against the table.
````````
- If you create a view, then Oracle Database automatically configures audit options GRANT, INSERT, UPDATE, or DELETE against the view.
````
- If you create a sequence, then Oracle Database automatically configures audit options ALTER or GRANT against the sequence.
````
- If you create a procedure, package, or function, then Oracle Database automatically configures audit options ALTER or GRANT against it.
