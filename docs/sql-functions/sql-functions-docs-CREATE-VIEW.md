# CREATE VIEW

## Purpose
Use the `CREATE` `VIEW` statement to define a **view**, which is a logical table based on one or more tables or views. A view contains no data itself. The tables upon which a view is based are called **base tables**.
You can also create an **object view** or a relational view that supports LOBs, object types, `REF` data types, nested table, or varray types on top of the existing view mechanism. An object view is a view of a user-defined type, where each row contains objects, each object with a unique object identifier.
You can also create `XMLType` views, which are similar to object views but display data from XMLSchema-based tables of `XMLType`.
**See Also:** ******
- Oracle Database Concepts, Oracle Database Development Guide, and Oracle Database Administrator’s Guide for information on various types of views and their uses
**
- Oracle XML DB Developer’s Guide for information on XMLType views
- ALTER VIEW and DROP VIEW for information on modifying a view and removing a view from the database
## Prerequisites
To create a view in your own schema, you must have the `CREATE` `VIEW` system privilege. To create a view in another user’s schema, you must have the `CREATE` `ANY` `VIEW` system privilege.
To create a subview, you must have the `UNDER` `ANY` `VIEW` system privilege or the `UNDER` object privilege on the superview.
The owner of the schema containing the view must have the privileges necessary to either select (`READ` or `SELECT` privilege), insert, update, or delete rows from all the tables or views on which the view is based. The owner must be granted these privileges directly, rather than through a role.
To use the basic constructor method of an object type when creating an object view, one of the following must be true:
- The object type must belong to the same schema as the view to be created.
``````
- You must have the EXECUTE ANY TYPE system privileges.
****
- You must have the EXECUTE object privilege on that object type. See Also: SELECT, INSERT, UPDATE, and DELETE for information on the privileges required by the owner of a view on the base tables or views of the view being created
## Syntax
## *create_view*::=
Description of the illustration create_view.eps
(*inline_constraint::=* and *out_of_line_constraint::=*, *object_view_clause::=*, *XMLType_view_clause::=*, *subquery::=*-part of `SELECT`, *subquery_restriction_clause::=*, *annotations_clause*)
## *object_view_clause*::=
Description of the illustration object_view_clause.eps
(*inline_constraint::=* and *out_of_line_constraint::=*)
## *XMLType_view_clause*::=
Description of the illustration xmltype_view_clause.eps
## *XMLSchema_spec*::=
Description of the illustration xmlschema_spec.eps
## *subquery_restriction_clause*::=
Description of the illustration subquery_restriction_clause.eps
## Semantics
## OR REPLACE
Specify `OR` `REPLACE` to re-create the view if it already exists. You can use this clause to change the definition of an existing view without dropping, re-creating, and regranting object privileges previously granted on it.
`INSTEAD` `OF` triggers defined on a conventional view are dropped when the view is re-created. DML triggers defined on an editioning view are retained when an editioning view is re-created. However, such triggers can be rendered permanently invalid if the editioning view has changed so that it can no longer be compiled-for example if an editioning view column referenced in the trigger definition has been dropped.
If any materialized views are dependent on *view*, then those materialized views will be marked `UNUSABLE` and will require a full refresh to restore them to a usable state. Invalid materialized views cannot be used by query rewrite and cannot be refreshed until they are recompiled.
You cannot replace a conventional view with an editioning view or an editioning view with a conventional view. See *Oracle Database Development Guide* for more information on editioning views.
```

```
## FORCE
Specify `FORCE` if you want to create the view regardless of whether the base tables of the view or the referenced object types exist or the owner of the schema containing the view has privileges on them. These conditions must be true before any `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statements can be issued against the view.
If the view definition contains any constraints, `CREATE` `VIEW` … `FORCE` fails if the base table does not exist or the referenced object type does not exist. `CREATE` `VIEW` … `FORCE` also fails if the view definition names a constraint that does not exist.
## NO FORCE
Specify `NOFORCE` if you want to create the view only if the base tables exist and the owner of the schema containing the view has privileges on them. This is the default.
## EDITIONING
Use this clause to create an **editioning view**. An editioning view is a single-table view that selects all rows from the base table and displays a subset of the base table columns. You can use an editioning view to isolate an application from DDL changes to the base table during administrative operations such as upgrades. You can obtain information about the relationship of existing editioning view to their base tables by querying the `USER_`, `ALL_`, and `DBA_EDITIONING_VIEW` data dictionary views.
The owner of an editioning view must be editions-enabled. Refer to ENABLE EDITIONS for more information.
**Notes on Editioning Views**
Editioning views differ from conventional views in several important ways:
- Editioning views are intended only to select and provide aliases for a subset of columns in a table. Therefore, the syntax for creating an editioning view is more limited than the syntax for creating a conventional view. Any violation of the restrictions that follow causes the creation of the view to fail, even if you specify FORCE.
- You can create DML triggers on editioning views. In this case, the database considers the editioning view to be the base object of the trigger. Such triggers fire when a DML operation target the editioning view itself. They do not fire if the DML operation targets the base table.
````
- You cannot create INSTEAD OF triggers on editioning views.
**Restrictions on Editioning Views** Editioning views are subject to the following restrictions:
- Within any edition, you can create only one editioning view for any single table.
****
- You cannot specify the object_view_clause, XMLType_view_clause, or BEQUEATH clause.
``````
- You cannot define a constraint WITH CHECK OPTION on an editioning view.
**
- In the select list of the defining subquery, you can specify only simple references to the columns of the base table, and you can specify each column of the base table only once in the select list. The asterisk wildcard symbol * and t_alias.* are supported to designate all columns of a base table.
- The FROM clause of the defining subquery of the view can reference only a single existing database table. Joins are not permitted. The base table must be in the same schema as the view being created. You cannot use a synonym to identify the table, but you can specify a table alias.
**````********``````
- The following clauses of the defining subquery are not valid for editioning views: subquery_factoring_clause, DISTINCT or UNIQUE, where_clause, hierarchical_query_clause, group_by_clause, HAVING condition, model_clause, or the set operators (UNION, INTERSECT, or MINUS)
**See Also:**
**
- Oracle Database Development Guide for detailed information about editioning views
- CREATE EDITION for information about editions, including an example of an editioning view
## EDITIONABLE | NONEDITIONABLE
Use these clauses to specify whether the view becomes an editioned or noneditioned object if editioning is enabled for the schema object type `VIEW` in *schema*. The default is `EDITIONABLE`. For information about editioned and noneditioned objects, see *Oracle Database Development Guide*.
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the view does not exist, a new one is created at the end of the statement.
- If the view exists, it is detected and a new one is not created.
You can only specify `OR REPLACE` or `IF NOT EXISTS` in a statement at a time. Using both `OR REPLACE` with `IF NOT EXISTS` in the very same statement results in an error.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## *schema*
Specify the schema to contain the view. If you omit *schema*, then Oracle Database creates the view in your own schema.
## *view*
Specify the name of the view or the object view. The name must satisfy the requirements listed in “Database Object Naming Rules”.
**Restriction on Views**
If a view has `INSTEAD` `OF` triggers, then any views created on it must have `INSTEAD` `OF` triggers, even if the views are inherently updatable.
**See Also:**   “Creating a View: Example”
## SHARING
This clause applies only when creating a view in an application root. This type of view is called an application common object and its data can be shared with the application PDBs that belong to the application root. To determine how the view data is shared, specify one of the following sharing attributes:
****
- METADATA - A metadata link shares the view’s metadata, but its data is unique to each container. This type of view is referred to as a metadata-linked application common object.
****
- DATA - A data link shares the view, and its data is the same for all containers in the application container. Its data is stored only in the application root. This type of view is referred to as a data-linked application common object.
````****
- EXTENDED DATA - An extended data link shares the view, and its data in the application root is the same for all containers in the application container. However, each application PDB in the application container can store data that is unique to the application PDB. For this type of view, data is stored in the application root and, optionally, in each application PDB. This type of view is referred to as an extended data-linked application common object.
- NONE - The view is not shared.
If you omit this clause, then the database uses the value of the `DEFAULT_SHARING` initialization parameter to determine the sharing attribute of the view. If the `DEFAULT_SHARING` initialization parameter does not have a value, then the default is `METADATA`.
When creating a conventional view, you can specify `METADATA`, `DATA`, `EXTENDED` `DATA`, or `NONE`.
When creating an object view or an `XMLTYPE` view, you can specify only `METADATA` or `NONE`.
You cannot change the sharing attribute of a view after it is created.
```

```
## *alias*
Specify names for the expressions selected by the defining query of the view. The number of aliases must match the number of expressions selected by the view. Aliases must follow the rules for naming Oracle Database schema objects. Aliases must be unique within the view.
If you omit the aliases, then the database derives them from the columns or column aliases in the query. For this reason, you must use aliases if the query contains expressions rather than only column names. Also, you must specify aliases if the view definition includes constraints.
**Restriction on View Aliases** You cannot specify an alias when creating an object view.
**See Also:**   “Syntax for Schema Objects and Parts in SQL Statements”
## VISIBLE | INVISIBLE
Use this clause to specify whether a view column is `VISIBLE` or `INVISIBLE`. By default, view columns are `VISIBLE` regardless of their visibility in the base tables, unless you specify `INVISIBLE`. This applies to conventional views and editioning views. For complete information on these clauses, refer to “VISIBLE | INVISIBLE” in the documentation on `CREATE` `TABLE`.
## *inline_constraint*and*out_of_line_constraint*
You can specify constraints on views and object views. You define the constraint at the view level using the *out_of_line_constraint* clause. You define the constraint as part of column or attribute specification using the *inline_constraint* clause after the appropriate alias.
Oracle Database does not enforce view constraints. For a full discussion of view constraints, including restrictions, refer to “View Constraints”.
**See Also:**   “Creating a View with Constraints: Example”
## *object_view_clause*
The *object_view_clause* lets you define a view on an object type.
**See Also:**   “Creating an Object View: Example” **OF** ***type_name*** **Clause** Use this clause to explicitly create an **object view** of type *type_name*. The columns of an object view correspond to the top-level attributes of type *type_name*. Each row will contain an object instance and each instance will be associated with an object identifier as specified in the `WITH` `OBJECT` `IDENTIFIER` clause. If you omit *schema*, then the database creates the object view in your own schema.
Object tables, as well as `XMLType` tables, object views, and `XMLType` views, do not have any column names specified for them. Therefore, Oracle Database defines a system-generated pseudocolumn `OBJECT_ID`. You can use this column name in queries and to create object views with the `WITH` `OBJECT` `IDENTIFIER` clause.
**WITH OBJECT IDENTIFIER Clause** Use the `WITH` `OBJECT` `IDENTIFIER` clause to specify a top-level (root) object view. This clause lets you specify the attributes of the object type that will be used as a key to identify each row in the object view. In most cases these attributes correspond to the primary key columns of the base table. You must ensure that the attribute list is unique and identifies exactly one row in the view. The `WITH` `OBJECT` `IDENTIFIER` and `WITH` `OBJECT` `ID` clauses can be used interchangeably and are provided for semantic clarity.
**Restrictions on Object Views** Object views are subject to the following restrictions:
- If you try to dereference or pin a primary key REF that resolves to more than one instance in the object view, then the database returns an error.
- You cannot specify this clause if you are creating a subview, because subviews inherit object identifiers from superviews.
If the object view is defined on an object table or an object view, then you can omit this clause or specify `DEFAULT`.
**DEFAULT** Specify `DEFAULT` if you want the database to use the intrinsic object identifier of the underlying object table or object view to uniquely identify each row.
***attribute*** For *attribute*, specify an attribute of the object type from which the database should create the object identifier for the object view.
**UNDER Clause** Use the `UNDER` clause to specify a subview based on an object superview.
**Restrictions on Subviews** Subviews are subject to the following restrictions:
- You must create a subview in the same schema as the superview.
****
- The object type type_name must be the immediate subtype of superview.
- You can create only one subview of a particular type under the same superview.
**See Also:**
- CREATE TYPE for information about creating objects
**
- Oracle Database Reference for information on data dictionary views
## *XMLType_view_clause*
Use this clause to create an `XMLType` view, which displays data from an XMLSchema-based table of type `XMLType`. The *XMLSchema_spec* indicates the XMLSchema to be used to map the XML data to its object-relational equivalents. The XMLSchema must already have been created before you can create an `XMLType` view.
The `WITH` `OBJECT` `IDENTIFIER` and `WITH` `OBJECT` `ID` clauses can be used interchangeably and are provided for semantic clarity.
Object tables, as well as `XMLType` tables, object views, and `XMLType` views, do not have any column names specified for them. Therefore, Oracle Database defines a system-generated pseudocolumn `OBJECT_ID`. You can use this column name in queries and to create object views with the `WITH` `OBJECT` `IDENTIFIER` clause.
**See Also:** **
- Oracle XML DB Developer's Guide for information on XMLType views and XMLSchemas
- “Creating an XMLType View: Example” and “Creating a View on an XMLType Table: Example”
## DEFAULT COLLATION
Use this clause to specify the default collation for the view. The default collation is used as the derived collation for all the character literals included in the defining query of the view. The default collation is not used by the view columns; the collations for the view columns are derived from the view’s defining subquery. The `CREATE` `VIEW` statement fails with an error if any of its character columns is based on an expression in the defining subquery that has no derived collation.
For *collation_name*, specify a valid named collation or pseudo-collation.
If you omit this clause, then the default collation for the view is set to the effective schema default collation of the schema containing the view. Refer to the DEFAULT_COLLATION clause of `ALTER` `SESSION` for more information on the effective schema default collation.
You can specify the `DEFAULT` `COLLATION` clause only if the `COMPATIBLE` initialization parameter is set to `12.2` or greater, and the `MAX_STRING_SIZE` initialization parameter is set to `EXTENDED`.
To change the default collation for a view, you must recreate the view.
**Restriction on the Default Collation for Views** If the defining query of the view contains the `WITH` *plsql_declarations* clause, then the default collation of the view must be `USING_NLS_COMP`.
## BEQUEATH
Use the `BEQUEATH` clause to specify whether functions referenced in the view are executed using the view invoker’s rights or the view definer’s rights.
**CURRENT_USER** If you specify `BEQUEATH` `CURRENT_USER`, then functions referenced by the view are executed using the view invoker’s rights as long as one of the following conditions is met:
````
- The view owner has the INHERIT PRIVILEGES object privilege on the invoking user.
``````
- The view owner has the INHERIT ANY PRIVILEGES system privilege.
If a query of the view invokes an identityor privilege-sensitive SQL function, or an invoker’s rights PL/SQL or Java function, then the current schema, current user, and currently enabled roles within the operation’s execution are inherited from the querying user’s environment, rather than from the owner of the view.
This clause does not turn the view itself into an invoker’s rights object. Name resolution within the view is still handled using the view owner’s schema, and privilege checking for the view is done using the view owner’s privileges.
**DEFINER** If you specify `BEQUEATH` `DEFINER`, then functions referenced by the view are executed using the view definer’s rights. If a query on the view invokes an identityor privilege-sensitive SQL function, or an invoker’s rights PL/SQL or Java function, then the current schema, current user, and currently enabled roles within the operation’s execution are inherited from the owner of the view.
Name resolution within the view is handled using the view owner’s schema, and privilege checking for the view is done using the view owner’s privileges.
This is the default.
**Restriction on the BEQUEATH Clause** You cannot specify this clause with the `EDITIONING` clause.
**See Also:**   *Oracle Database Security Guide* for more information on controlling invoker’s rights and definer’s rights in views
## *annotations_clause*
For the full semantics of the annotations clause see *annotations_clause*.
## AS*subquery*
Specify a subquery that identifies columns and rows of the table(s) that the view is based on. The select list of the subquery can contain up to 1000 expressions.
If you create views that refer to remote tables and views, then the database links you specify must have been created using the `CONNECT` `TO` clause of the `CREATE` `DATABASE` `LINK` statement, and you must qualify them with a schema name in the view subquery.
If you create a view with the *flashback_query_clause* in the defining query, then the database does not interpret the `AS` `OF` expression at create time but rather each time a user subsequently queries the view.
**See Also:**   “Creating a Join View: Example” and *Oracle Database Development Guide* for more information on Oracle Flashback Query **Restrictions on the Defining Query of a View** The view query is subject to the following restrictions:
````
- The subquery cannot select the CURRVAL or NEXTVAL pseudocolumns.
``````
- If the subquery selects the ROWID, ROWNUM, or LEVEL pseudocolumns, then those columns must have aliases in the view subquery.
````````
- If the subquery uses an asterisk (*) to select all columns of a table, and you later add new columns to the table, then the view will not contain those columns until you re-create the view by issuing a CREATE OR REPLACE VIEW statement.
- For object views, the number of elements in the subquery select list must be the same as the number of top-level attributes for the object type. The data type of each of the selecting elements must be the same as the corresponding top-level attribute.
- You cannot specify the SAMPLE clause.
The preceding restrictions apply to materialized views as well.
**Notes on Updatable Views**
The following notes apply to updatable views:
An updatable view is one you can use to insert, update, or delete base table rows. You can create a view to be inherently updatable, or you can create an `INSTEAD OF` trigger on any view to make it updatable.
To learn whether and in what ways the columns of an inherently updatable view can be modified, query the `USER_UPDATABLE_COLUMNS` data dictionary view. The information displayed by this view is meaningful only for inherently updatable views. For a view to be inherently updatable, the following conditions must be met:
- Each column in the view must map to a column of a single table. For example, if a view column maps to the output of a TABLE clause (an unnested collection), then the view is not inherently updatable.
  - A set operator
  - A DISTINCT operator
  - An aggregate or analytic function
``````````````````
  - A GROUP BY, ORDER BY, MODEL, CONNECT BY, or START WITH clause
  - A collection expression in a SELECT list
  - A subquery in a SELECT list
  - A subquery designated WITH READ ONLY
**
  - Joins, with some exceptions, as documented in Oracle Database Administrator’s Guide
- In addition, if an inherently updatable view contains pseudocolumns or expressions, then you cannot update base table rows with an UPDATE statement that refers to any of these pseudocolumns or expressions.
  - The DML statement must affect only one table underlying the join.
````````****
  - For an INSERT statement, the view must not be created WITH CHECK OPTION, and all columns into which values are inserted must come from a key-preserved table. A key-preserved table is one for which every primary key or unique key value in the base table is also unique in the join view.
````````
  - For an UPDATE statement, the view must not be created WITH CHECK OPTION, and all columns updated must be extracted from a key-preserved table.
``````````
  - For a DELETE statement, if the join results in more than one key-preserved table, then Oracle Database deletes from the first table named in the FROM clause, whether or not the view was created WITH CHECK OPTION.
**See Also:**
**
- Oracle Database Administrator’s Guide for more information on updatable views
**````
- “Creating an Updatable View: Example”, “Creating a Join View: Example” for an example of updatable join views and key-preserved tables, and Oracle Database PL/SQL Language Reference for an example of an INSTEAD OF trigger on a view that is not inherently updatable
## *subquery_restriction_clause*
Use the *subquery_restriction_clause* to restrict the defining query of the view in one of the following ways:
**WITH READ ONLY**
Specify `WITH` `READ` `ONLY` to indicate that the table or view cannot be updated.
**WITH CHECK OPTION**
Specify `WITH` `CHECK` `OPTION` to indicate that Oracle Database prohibits any changes to the table or view that would produce rows that are not included in the subquery. When used in the subquery of a DML statement, you can specify this clause in a subquery in the `FROM` clause but not in subquery in the `WHERE` clause.
**CONSTRAINT** ***constraint***
Specify the name of the `READ` `ONLY` or `CHECK` `OPTION` constraint. If you omit this identifier, then Oracle automatically assigns the constraint a name of the form `SYS_C`*n*, where *n* is an integer that makes the constraint name unique within the database.
**Note:**
For tables, `WITH` `CHECK` `OPTION` guarantees that inserts and updates result in tables that the defining table subquery can select. For views, `WITH` `CHECK` `OPTION` cannot make this guarantee if:
- There is a subquery within the defining query of this view or any view on which this view is based or
``````````
- INSERT, UPDATE, or DELETE operations are performed using INSTEAD OF triggers.
**Restriction on the*****subquery_restriction_clause*** You cannot specify this clause if you specify an `ORDER` `BY` clause.
**See Also:**   “Creating a Read-Only View: Example”
## CONTAINER_MAP
Specify the `CONTAINER_MAP` clause to enable the view to be queried using a container map.
## CONTAINERS_DEFAULT
Specify the `CONTAINERS_DEFAULT` clause to enable the view for the `CONTAINERS` clause.
## Examples
**Creating a View: Example** The following statement creates a view of the sample table `employees` named `emp_view`. The view shows the employees in department 20 and their annual salary:
```
CREATE VIEW emp_view AS
   SELECT last_name, salary*12 annual_salary
   FROM employees
   WHERE department_id = 20;
```
The view declaration need not define a name for the column based on the expression `salary*12`, because the subquery uses a column alias (`annual_salary`) for this expression.
**Creating an Editioning View: Example** The following statement creates an editioning view of the `orders` table:
```
CREATE EDITIONING VIEW ed_orders_view (o_id, o_date, o_status)
  AS SELECT order_id, order_date, order_status FROM orders
  WITH READ ONLY;
```
You can use this view to isolate an application from DDL changes to the `orders` table during an administrative operation such as an upgrade. You can create a DML trigger on this view, so that the trigger fires when a DML operation targets the view itself, but does not fire if the DML operation targets the `orders` table.
**Creating a View with Constraints: Example** The following statement creates a restricted view of the sample table `hr.employees` and defines a unique constraint on the `email` view column and a primary key constraint for the view on the `emp_id` view column:
```
CREATE VIEW emp_sal (emp_id, last_name,
      email UNIQUE RELY DISABLE NOVALIDATE,
   CONSTRAINT id_pk PRIMARY KEY (emp_id) RELY DISABLE NOVALIDATE)
   AS SELECT employee_id, last_name, email FROM employees;
```
**Creating an Updatable View: Example** The following statement creates an updatable view named `clerk` of all clerks in the `employees` table. Only the employees’ IDs, last names, department numbers, and jobs are visible in this view, and these columns can be updated only in rows where the employee is a kind of clerk:
```
CREATE VIEW clerk AS
   SELECT employee_id, last_name, department_id, job_id
   FROM employees
   WHERE job_id = 'PU_CLERK'
      or job_id = 'SH_CLERK'
      or job_id = 'ST_CLERK';
```
This view lets you change the `job_id` of a purchasing clerk to purchasing manager (`PU_MAN`):
```
UPDATE clerk SET job_id = 'PU_MAN' WHERE employee_id = 118;
```
The next example creates the same view `WITH` `CHECK` `OPTION`. You cannot subsequently insert a new row into `clerk` if the new employee is not a clerk. You can update an employee’s `job_id` from one type of clerk to another type of clerk, but the update in the preceding statement would fail, because the view cannot access employees with non-clerk `job_id`.
```
CREATE VIEW clerk AS
   SELECT employee_id, last_name, department_id, job_id
   FROM employees
   WHERE job_id = 'PU_CLERK'
      or job_id = 'SH_CLERK'
      or job_id = 'ST_CLERK'
   WITH CHECK OPTION;
```
**Creating a Join View: Example** A join view is one whose view subquery contains a join. If at least one column in the join has a unique index, then it may be possible to modify one base table in a join view. You can query `USER_UPDATABLE_COLUMNS` to see whether the columns in a join view are updatable. For example:
```
CREATE VIEW locations_view AS
   SELECT d.department_id, d.department_name, l.location_id, l.city
   FROM departments d, locations l
   WHERE d.location_id = l.location_id;
SELECT column_name, updatable
   FROM user_updatable_columns
   WHERE table_name = 'LOCATIONS_VIEW'
   ORDER BY column_name, updatable;
COLUMN_NAME                    UPD
------------------------------ ---
DEPARTMENT_ID                  YES
DEPARTMENT_NAME                YES
LOCATION_ID                    NO
CITY                           NO
```
In the preceding example, the primary key index on the `location_id` column of the `locations` table is not unique in the `locations_view` view. Therefore, `locations` is not a key-preserved table and columns from that base table are not updatable.
```
INSERT INTO locations_view VALUES
   (999, 'Entertainment', 87, 'Roma');
INSERT INTO locations_view VALUES
*
ERROR at line 1:
ORA-01776: cannot modify more than one base table through a join view
```
You can insert, update, or delete a row from the `departments` base table, because all the columns in the view mapping to the `departments` table are marked as updatable and because the primary key of `departments` is retained in the view.
```
INSERT INTO locations_view (department_id, department_name)
   VALUES (999, 'Entertainment');
1 row created.
```
**Note:**   For you to insert into the table using the view, the view must contain all `NOT` `NULL` columns of all tables in the join, unless you have specified `DEFAULT` values for the `NOT` `NULL` columns.
**See Also:**   *Oracle Database Administrator’s Guide* for more information on updating join views **Creating a Read-Only View: Example** The following statement creates a read-only view named `customer_ro` of the `oe.customers` table. Only the customers’ last names, language, and credit limit are visible in this view:
```
CREATE VIEW customer_ro (name, language, credit)
      AS SELECT cust_last_name, nls_language, credit_limit
      FROM customers
      WITH READ ONLY;
```
**Creating an Object View: Example** The following example shows the creation of the type `inventory_typ` in the `oc` schema, and the `oc_inventories` view that is based on that type:
```
CREATE TYPE inventory_typ
 OID '82A4AF6A4CD4656DE034080020E0EE3D'
 AS OBJECT
    ( product_id          NUMBER(6)
    , warehouse           warehouse_typ
    , quantity_on_hand    NUMBER(8)
    ) ;
/
CREATE OR REPLACE VIEW oc_inventories OF inventory_typ
 WITH OBJECT OID (product_id)
 AS SELECT i.product_id,
           warehouse_typ(w.warehouse_id, w.warehouse_name, w.location_id),
           i.quantity_on_hand
    FROM inventories i, warehouses w
    WHERE i.warehouse_id=w.warehouse_id;
```
**Creating a View on an XMLType Table: Example** The following example builds a regular view on the `XMLType` table `xwarehouses`, which was created in “Examples”:
```
CREATE VIEW warehouse_view AS
   SELECT VALUE(p) AS warehouse_xml
   FROM xwarehouses p;
```
You select from such a view as follows:
```
SELECT e.warehouse_xml.getclobval()
   FROM warehouse_view e
   WHERE EXISTSNODE(warehouse_xml, '//Docks') =1;
```
**Creating an XMLType View: Example** In some cases you may have an object-relational table upon which you would like to build an `XMLType` view. The following example creates an object-relational table resembling the `XMLType` column `warehouse_spec` in the sample table `oe.warehouses`, and then creates an `XMLType` view of that table:
```
CREATE TABLE warehouse_table
(
  WarehouseID       NUMBER,
  Area              NUMBER,
  Docks             NUMBER,
  DockType          VARCHAR2(100),
  WaterAccess       VARCHAR2(10),
  RailAccess        VARCHAR2(10),
  Parking           VARCHAR2(20),
  VClearance        NUMBER
);
INSERT INTO warehouse_table
   VALUES(5, 103000,3,'Side Load','false','true','Lot',15);
CREATE VIEW warehouse_view OF XMLTYPE
 XMLSCHEMA "http://www.example.com/xwarehouses.xsd"
    ELEMENT "Warehouse"
    WITH OBJECT ID
    (extract(OBJECT_VALUE, '/Warehouse/Area/text()').getnumberval())
 AS SELECT XMLELEMENT("Warehouse",
            XMLFOREST(WarehouseID as "Building",
                      area as "Area",
                      docks as "Docks",
                      docktype as "DockType",
                      wateraccess as "WaterAccess",
                      railaccess as "RailAccess",
                      parking as "Parking",
                      VClearance as "VClearance"))
  FROM warehouse_table;
```
You query this view as follows:
```
SELECT VALUE(e) FROM warehouse_view e;
```
