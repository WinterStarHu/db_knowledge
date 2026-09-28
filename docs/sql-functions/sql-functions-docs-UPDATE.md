# UPDATE

## Purpose
Use the `UPDATE` statement to change existing values in a table or in the base table of a view or the master table of a materialized view.
## Prerequisites
For you to update values in a table, the table must be in your own schema or you must have the `UPDATE` object privilege on the table.
For you to update values in the base table of a view:
- You must have the UPDATE object privilege on the view, and
- Whoever owns the schema containing the view must have the UPDATE object privilege on the base table.
The `UPDATE` `ANY` `TABLE` system privilege also allows you to update values in any table or in the base table of any view.
To update values in an object on a remote database, you must also have the `READ` or `SELECT` object privilege on the object.
To specify the *returning_clause*, you must have the `READ` or `SELECT` object privilege on the object.
If the `SQL92_SECURITY` initialization parameter is set to `TRUE` and the `UPDATE` operation references table columns, such as the columns in a *where_clause* or*returning_clause*, then you must have the `SELECT` object privilege on the object you want to update.
## Syntax
## *update*::=
Description of the illustration update.eps (*DML_table_expression_clause::=*, *update_set_clause::=*, *where_clause::=*, *returning_clause::=*, *error_logging_clause::=*)
## *DML_table_expression_clause*::=
Description of the illustration dml_table_expression_clause.eps (*partition_extension_clause::=*, *subquery::=*–part of `SELECT`, *subquery_restriction_clause::=*, *table_collection_expression::=*)
## *partition_extension_clause*::=
Description of the illustration partition_extension_clause.eps
## *subquery_restriction_clause*::=
Description of the illustration subquery_restriction_clause.eps
## *table_collection_expression*::=
Description of the illustration table_collection_expression.eps
## *update_set_clause*::=
Description of the illustration update_set_clause.eps
## *where_clause*::=
Description of the illustration where_clause.eps
## *returning_clause*::=
Description of the illustration returning_clause.eps
## *error_logging_clause*::=
Description of the illustration error_logging_clause.eps
## Semantics
## *hint*
Specify a comment that passes instructions to the optimizer on choosing an execution plan for the statement.
You can place a parallel hint immediately after the `UPDATE` keyword to parallelize both the underlying scan and `UPDATE` operations.
```

```
## *DML_table_expression_clause*
The `ONLY` clause applies only to views. Specify `ONLY` syntax if the view in the `UPDATE` clause is a view that belongs to a hierarchy and you do not want to update rows from any of its subviews.
**See Also:**   “Restrictions on the DML_table_expression_clause” and “Updating a Table: Examples” ***schema*** Specify the schema containing the object to be updated. If you omit *schema*, then the database assumes the object is in your own schema.
***table*** **|** ***view*** **|** ***materialized_view*** **|*****subquery*** Specify the name of the table, view, materialized view, or the columns returned by a subquery to be updated. Issuing an `UPDATE` statement against a table fires any `UPDATE` triggers associated with the table.
**````
  - A set operator
  - A DISTINCT operator
  - An aggregate or analytic function
``````````````````
  - A GROUP BY, ORDER BY, MODEL, CONNECT BY, or START WITH clause
  - A collection expression in a SELECT list
  - A subquery in a SELECT list
``````
  - A subquery designated WITH READ ONLY
  - A recursive WITH clause
**
  - Joins, with some exceptions, as documented in Oracle Database Administrator’s Guide
-
- You cannot update more than one base table through a view.
``````
- In addition, if the view was created with the WITH CHECK OPTION, then you can update the view only if the resulting data satisfies the view’s defining query.
****
- If table or the base table of view contains one or more domain index columns, then this statement executes the appropriate indextype update routine.
- You cannot update rows in a read-only materialized view. If you update rows in a writable materialized view, then the database updates the rows from the underlying container table. However, the updates are overwritten at the next refresh operation. If you update rows in an updatable materialized view that is part of a materialized view group, then the database also updates the corresponding rows in the master table.
**See Also:**
**
- Oracle Database Data Cartridge Developer’s Guide for more information on the indextype update routines
- CREATE MATERIALIZED VIEW for information on creating updatable materialized views
***partition_extension_clause***
Specify the name or partition key value of the partition or subpartition within *table* targeted for updates. You need not specify the partition name when updating values in a partitioned table. However in some cases specifying the partition name can be more efficient than a complicated *where_clause*.
**See Also:**   “References to Partitioned Tables and Indexes” and “Updating a Partition: Example”
***dblink***
Specify a complete or partial name of a database link to a remote database where the object is located. You can use a database link to update a remote object only if you are using Oracle Database distributed functionality.
If you omit *dblink,* then the database assumes the object is on the local database.
**Note:**   Starting with Oracle Database 12*c* Release 2 (12.2), the `UPDATE` statement accepts remote LOB locators as bind variables. Refer to the “Distributed LOBs” chapter in *Oracle Database SecureFiles and Large Objects Developer’s Guide* for more information.
**See Also:**   “References to Objects in Remote Databases” for information on referring to database links
***subquery_restriction_clause***
Use the *subquery_restriction_clause* to restrict the subquery in one of the following ways:
**WITH READ ONLY**
Specify `WITH READ ONLY` to indicate that the table or view cannot be updated.
**WITH CHECK OPTION**
Specify `WITH CHECK OPTION` to indicate that Oracle Database prohibits any changes to the table or view that would produce rows that are not included in the subquery. When used in the subquery of a DML statement, you can specify this clause in a subquery in the `FROM` clause but not in subquery in the `WHERE` clause.
**CONSTRAINT** ***constraint***
Specify the name of the `CHECK OPTION` constraint. If you omit this identifier, then Oracle automatically assigns the constraint a name of the form `SYS_C`*n*, where n is an integer that makes the constraint name unique within the database.
**See Also:**   “Using the WITH CHECK OPTION Clause: Example”
***table_collection_expression***
The *table_collection_expression* lets you inform Oracle that the value of *collection_expression* should be treated as a table for purposes of query and DML operations. The *collection_expression* can be a subquery, a column, a function, or a collection constructor. Regardless of its form, it must return a collection value-that is, a value whose type is nested table or varray. This process of extracting the elements of a collection is called **collection unnesting**.
The optional plus (+) is relevant if you are joining the `TABLE` collection expression with the parent table. The + creates an outer join of the two, so that the query returns rows from the outer table even if the collection expression is null.
**Note:**   In earlier releases of Oracle, when *collection_expression* was a subquery, *table_collection_expression* was expressed as `THE` *subquery*. That usage is now deprecated.
You can use a *table_collection_expression* to update rows in one table based on rows from another table. For example, you could roll up four quarterly sales tables into a yearly sales table.
***t_alias***
Specify a **correlation name** (alias) for the table, view, or subquery to be referenced elsewhere in the statement. This alias is required if the *DML_table_expression_clause* references any object type attributes or object type methods.
**See Also:**   “Correlated Update: Example”
**Restrictions on the** ***DML_table_expression_clause***
This clause is subject to the following restrictions:
****````
- You cannot execute this statement if table or the base table of view contains any domain indexes marked IN_PROGRESS or FAILED.
- You cannot insert into a partition if any affected index partitions are marked UNUSABLE.
****
- You cannot specify the order_by_clause in the subquery of the DML_table_expression_clause.
````````****
- If you specify an index, index partition, or index subpartition that has been marked UNUSABLE, then the UPDATE statement will fail unless the SKIP_UNUSABLE_INDEXES session parameter has been set to TRUE. See Also: ALTER SESSION for information on the SKIP_UNUSABLE_INDEXES session parameter
## *update_set_clause*
The *update_set_clause* lets you set column values.
***column*** Specify the name of a column of the object that is to be updated. If you omit a column of the table from the *update_set_clause*, then the value of that column remains unchanged.
If *column* refers to a LOB object attribute, then you must first initialize it with a value of empty or null. You cannot update it with a literal. Also, if you are updating a LOB value using some method other than a direct `UPDATE` SQL statement, then you must first lock the row containing the LOB. See *for_update_clause* for more information.
If *column* is a virtual column, you cannot specify it here. Rather, you must update the values from which the virtual column is derived.
If *column* is part of the partitioning key of a partitioned table, then `UPDATE` will fail if you change a value in the column that would move the row to a different partition or subpartition, unless you enable row movement. Refer to the *row_movement_clause* of CREATE TABLE or ALTER TABLE.
In addition, if *column* is part of the partitioning key of a list-partitioned table, then `UPDATE` will fail if you specify a value for the column that does not already exist in the *partition_key_value* list of one of the partitions.
***subquery*** Specify a subquery that returns exactly one row for each row updated.
**
- If you specify only one column in the update_set_clause, then the subquery can return only one value.
**
- If you specify multiple columns in the update_set_clause, then the subquery must return as many values as you have specified columns.
- If the subquery returns no rows, then the column is assigned a null.
******
- If this subquery refers to remote objects, then the UPDATE operation can run in parallel as long as the reference does not loop back to an object on the local database. However, if the subquery in the DML_table_expression_clause refers to any remote objects, then the UPDATE operation will run serially without notification.
**You can use the *flashback_query_clause* within the subquery to update *table* with past data. Refer to the *flashback_query_clause* of `SELECT` for more information on this clause.
**See Also:**
- SELECT and “Using Subqueries”
**
- parallel_clause in the CREATE TABLE documentation
***expr*** Specify an expression that resolves to the new value assigned to the corresponding column.
**Note:**   Expressions for the syntax of *expr* and “Updating an Object Table: Example” **DEFAULT** Specify `DEFAULT` to set the column to the value previously specified as the default value for the column. If no default value for the corresponding column has been specified, then the database sets the column to null.
**Restriction on Updating to Default Values** You cannot specify `DEFAULT` if you are updating a view.
You cannot use the `DEFAULT` clause in an `UPDATE` statement if the table that you are specifying has an Oracle Label Security policy enabled.
**VALUE Clause** The `VALUE` clause lets you specify the entire row of an object table.
**Restriction on the VALUE clause** You can specify this clause only for an object table.
**Note:**   If you insert string literals into a `RAW` column, then during subsequent queries, Oracle Database will perform a full table scan rather than using any index that might exist on the `RAW` column.
**See Also:**   “Updating an Object Table: Example”
## *where_clause*
The *where_clause* lets you restrict the rows updated to those for which the specified *condition* is true. If you omit this clause, then the database updates all rows in the table or view. Refer to Conditions for the syntax of *condition*.
The *where_clause* determines the rows in which values are updated. If you do not specify the *where_clause*, then all rows are updated. For each row that satisfies the *where_clause*, the columns to the left of the equality operator (=) in the *update_set_clause* are set to the values of the corresponding expressions to the right of the operator. The expressions are evaluated as the row is updated.
## *returning_clause*
The returning clause retrieves the rows affected by a DML statement. You can specify this clause for tables and materialized views and for views with a single base table.
When operating on a single row, a DML statement with a *returning_clause* can retrieve column expressions using the affected row, rowid, and `REFs` to the affected row and store them in host variables or PL/SQL variables.
When operating on multiple rows, a DML statement with the *returning_clause* stores values from expressions, rowids, and `REFs` involving the affected rows in bind arrays.
***expr*** Each item in the *expr* list must be a valid expression syntax.
**INTO** The `INTO` clause indicates that the values of the changed rows are to be stored in the variable(s) specified in *data_item* list.
***data_item*** Each *data_item* is a host variable or PL/SQL variable that stores the retrieved *expr* value.
For each expression in the `RETURNING` list, you must specify a corresponding type-compatible PL/SQL variable or host variable in the `INTO` list.
**Restrictions** The following restrictions apply to the `RETURNING` clause:
**
````******````
  - For UPDATE and DELETE statements each expr must be a simple expression or a single-set aggregate function expression. You cannot combine simple expressions and single-set aggregate function expressions in the same returning_clause. For INSERT statements, each expr must be a simple expression. Aggregate functions are not supported in an INSERT statement RETURNING clause.
  - Single-set aggregate function expressions cannot include the DISTINCT keyword.
**````````
- If the expr list contains a primary key column or other NOT NULL column, then the update statement fails if the table has a BEFORE UPDATE trigger defined on it.
**
- You cannot specify the returning_clause for a multitable insert.
- You cannot use this clause with parallel DML or with remote objects.
- You cannot retrieve LONG types with this clause.
````******````
- You cannot specify this clause for a view on which an INSTEAD OF trigger has been defined. See Also: Oracle Database PL/SQL Language Reference for information on using the BULK COLLECT clause to return multiple values to collection variables
## *error_logging_clause*
The `error_logging_clause` has the same behavior in an `UPDATE` statement as it does in an `INSERT` statement. Refer to the `INSERT` statement *error_logging_clause* for more information.
**See Also:**   “Inserting Into a Table with Error Logging: Example”
## Examples
**Updating a Table: Examples** The following statement gives null commissions to all employees with the job `SH_CLERK`:
```
UPDATE employees
   SET commission_pct = NULL
   WHERE job_id = 'SH_CLERK';
```
The following statement promotes Douglas Grant to manager of Department 20 with a $1,000 raise:
```
UPDATE employees SET
    job_id = 'SA_MAN', salary = salary + 1000, department_id = 120
    WHERE first_name||' '||last_name = 'Douglas Grant';
```
The following statement increases the salary of an employee in the `employees` table on the `remote` database:
```
UPDATE employees@remote
   SET salary = salary*1.1
   WHERE last_name = 'Baer';
```
The next example shows the following syntactic constructs of the `UPDATE` statement:
**
- Both forms of the update_set_clause together in a single statement
- A correlated subquery
**
- A where_clause to limit the updated rows
```
UPDATE employees a
    SET department_id =
        (SELECT department_id
            FROM departments
            WHERE location_id = '2100'),
        (salary, commission_pct) =
        (SELECT 1.1*AVG(salary), 1.5*AVG(commission_pct)
          FROM employees b
          WHERE a.department_id = b.department_id)
    WHERE department_id IN
        (SELECT department_id
          FROM departments
          WHERE location_id = 2900
              OR location_id = 2700);
```
The preceding `UPDATE` statement performs the following operations:
- Updates only those employees who work in Geneva or Munich (locations 2900 and 2700)
``````
- Sets department_id for these employees to the department_id corresponding to Bombay (location_id 2100)
- Sets each employee’s salary to 1.1 times the average salary of their department
- Sets each employee’s commission to 1.5 times the average commission of their department
**Updating a Partition: Example**
The following example updates values in a single partition of the `sales` table:
```
UPDATE sales PARTITION (sales_q1_1999) s SET s.promo_id = 494 WHERE amount_sold > 1000;
```
**Updating an Object Table: Example**
The following statement creates two object tables, `people_demo1` and `people_demo2`, of the `people_typ` object created in Table Collections: Examples. The example shows how to update a row of `people_demo1` by selecting a row from `people_demo2`:
```
CREATE TABLE people_demo1 OF people_typ;
CREATE TABLE people_demo2 OF people_typ;
UPDATE people_demo1 p SET VALUE(p) = (SELECT VALUE(q) FROM people_demo2 q WHERE p.department_id = q.department_id) WHERE p.department_id = 10;
```
The example uses the `VALUE` object reference function in both the `SET` clause and the subquery.
**Correlated Update: Example**
For an example that uses a correlated subquery to update nested table rows, refer to “Table Collections: Examples”.
**Using the RETURNING Clause During UPDATE: Example**
The following example returns values from the updated row and stores the result in PL/SQL variables `bnd1`, `bnd2`, `bnd3`:
```
UPDATE employees SET job_id ='SA_MAN', salary = salary + 1000, department_id = 140 WHERE last_name = 'Jones' RETURNING salary*0.25, last_name, department_id INTO :bnd1, :bnd2, :bnd3;
```
The following example shows that you can specify a single-set aggregate function in the expression of the returning clause:
```
UPDATE employees SET salary = salary * 1.1 WHERE department_id = 100 RETURNING SUM(salary) INTO :bnd1;
```
