# constraint                  document.write(''); document.write('body > .noscript, body > .noscript ~ * { opacity: 0; }'); document.write('');    if (window.require === undefined) { document.write(''); document.write(''); }

# *constraint*
## Purpose
Use a *constraint* to define an **integrity constraint-**a rule that restricts the values in a database. Oracle Database lets you create six types of constraints and lets you declare them in two ways.
The six types of integrity constraint are described briefly here and more fully in “Semantics”:
************
- A NOT NULLconstraint prohibits a database value from being null.
****
- A unique constraint prohibits multiple rows from having the same value in the same column or combination of columns but allows some values to be null.
****````
- A primary key constraint combines a NOT NULL constraint and a unique constraint in a single declaration. It prohibits multiple rows from having the same value in the same column or combination of columns and prohibits values from being null.
****
- A foreign key constraint requires values in one table to match values in another table.
****
- A check constraint requires a value in the database to comply with a specified condition.
****
- A REF column by definition references an object in another object type or in a relational table. A REF constraint lets you further describe the relationship between the REF column and the object it references.
You can define constraints syntactically in two ways:
****
- As part of the definition of an individual column or attribute. This is called inline specification.
****
- As part of the table definition. This is called out-of-line specification.
`NOT` `NULL` constraints must be declared inline. All other constraints can be declared either inline or out of line.
Constraint clauses can appear in the following statements:
``````
- CREATE TABLE (see CREATE TABLE)
````
- ALTER TABLE (see ALTER TABLE)
``````
- CREATE VIEW (see CREATE VIEW)
``````
- ALTER VIEW (see ALTER VIEW)
**View Constraints** Oracle Database does not enforce view constraints. However, you can enforce constraints on views through constraints on base tables.
You can specify only unique, primary key, and foreign key constraints on views, and they are supported only in `DISABLE` `NOVALIDATE` mode. You cannot define view constraints on attributes of an object column.
**See Also:**   View Constraints for additional information on view constraints and “DISABLE Clause” for information on `DISABLE` `NOVALIDATE` mode **External Table Constraints** You can specify only `NOT` `NULL`, unique, primary key, and foreign key constraints on external tables. Unique, primary key, and foreign key constraints are supported only in `RELY` `DISABLE` mode.
**See Also:**    DISABLE Clause for information on `RELY` and `DISABLE`.
## Prerequisites
You must have the privileges necessary to issue the statement in which you are defining the constraint.
To create a foreign key constraint, in addition, the parent table or view must be in your own schema or you must have the `REFERENCES` privilege on the columns of the referenced key in the parent table or view.
## Syntax
## *constraint*::=
Description of the illustration constraint.eps (*inline_constraint::=*, *out_of_line_constraint::=*, *inline_ref_constraint::=*, *out_of_line_ref_constraint::=*)
## *inline_constraint*::=
Description of the illustration inline_constraint.eps (*references_clause::=*)
## *out_of_line_constraint*::=
Description of the illustration out_of_line_constraint.eps (*references_clause::=*, *constraint_state::=*)
## *inline_ref_constraint*::=
Description of the illustration inline_ref_constraint.eps (*references_clause::=*, *constraint_state::=*)
## *out_of_line_ref_constraint*::=
Description of the illustration out_of_line_ref_constraint.eps (*references_clause::=*, *constraint_state::=*)
## *references_clause*::=
Description of the illustration references_clause.eps
## *constraint_state*::=
Description of the illustration constraint_state.eps (*using_index_clause::=*, *exceptions_clause::=*)
## *using_index_clause*::=
Description of the illustration using_index_clause.eps (*create_index::=*, *index_properties::=*)
## *index_properties*::=
Description of the illustration index_properties.eps (*global_partitioned_index::=*, *local_partitioned_index::=*–part of `CREATE` `INDEX`, *index_attributes::=*. The `INDEXTYPE` `IS` … clause is not valid when defining a constraint.)
## *index_attributes*::=
Description of the illustration index_attributes.eps (*physical_attributes_clause::=*, *logging_clause::=*, *index_compression::=*, *partial_index_clause::=*–all part of `CREATE` `INDEX`, *parallel_clause*: not supported in *using_index_clause*)
## *exceptions_clause*::=
Description of the illustration exceptions_clause.eps
## Semantics
This section describes the semantics of *constraint*. For additional information, refer to the SQL statement in which you define or redefine a constraint for a table or view.
Oracle Database does not support constraints on columns or attributes whose type is a user-defined object, nested table, `VARRAY`, `REF`, or LOB, with two exceptions:
````````
- NOT NULL constraints are supported for a column or attribute whose type is user-defined object, VARRAY, REF, or LOB.
````````
- NOT NULL, foreign key, and REF constraints are supported on a column of type REF.
## CONSTRAINT*constraint_name*
Specify a name for the constraint. The name must satisfy the requirements listed in “Database Object Naming Rules”. If you omit this identifier, then Oracle Database generates a name with the form `SYS_C`*n*. Oracle stores the name and the definition of the integrity constraint in the `USER_`, `ALL_`, and `DBA_CONSTRAINTS` data dictionary views (in the `CONSTRAINT_NAME` and `SEARCH_CONDITION` columns, respectively).
**See Also:**   *Oracle Database Reference* for information on the data dictionary views
## NOT NULL Constraints
A `NOT` `NULL` constraint prohibits a column from containing nulls. The `NULL` keyword by itself does not actually define an integrity constraint, but you can specify it to explicitly permit a column to contain nulls. You must define `NOT` `NULL` and `NULL` using inline specification. If you specify neither `NOT` `NULL` nor `NULL`, then the default is `NULL`.
`NOT` `NULL` constraints are the only constraints you can specify inline on `XMLType` and `VARRAY` columns.
To satisfy a `NOT` `NULL` constraint, every row in the table must contain a value for the column.
**Note:**   Oracle Database does not index table rows in which all key columns are null except in the case of bitmap indexes. Therefore, if you want an index on all rows of a table, then you must either specify `NOT` `NULL` constraints for at least one of the index key columns or create a bitmap index.
**Restrictions on NOT NULL Constraints** `NOT` `NULL` constraints are subject to the following restrictions:
``````
- You cannot specify NULL or NOT NULL in a view constraint.
``````````````****
- You cannot specify NULL or NOT NULL for an attribute of an object. Instead, use a CHECK constraint with the IS [NOT] NULL condition. See Also: “Attribute-Level Constraints Example” and “NOT NULL Example”
## Unique Constraints
A **unique** constraint designates a column as a unique key. A **composite unique key** designates a combination of columns as the unique key. When you define a unique constraint inline, you need only the `UNIQUE` keyword. When you define a unique constraint out of line, you must also specify one or more columns. You must define a composite unique key out of line.
To satisfy a unique constraint, no two rows in the table can have the same value for the unique key. However, the unique key made up of a single column can contain nulls. To satisfy a composite unique key, no two rows in the table or view can have the same combination of values in the key columns. Any row that contains nulls in all key columns automatically satisfies the constraint. However, two rows that contain nulls for one or more key columns and the same combination of values for the other key columns violate the constraint.
Unique constraints are sensitive to declared collations of their key columns. See Collation Sensitivity of Constraints for more details.
When you specify a unique constraint on one or more columns, Oracle implicitly creates an index on the unique key. If you are defining uniqueness for purposes of query performance, then Oracle recommends that you instead create the unique index explicitly using a `CREATE` `UNIQUE` `INDEX` statement. You can also use the `CREATE` `UNIQUE` `INDEX` statement to create a unique function-based index that defines a conditional unique constraint. See “Using a Function-based Index to Define Conditional Uniqueness: Example” for more information.
When you specify an enabled unique constraint on an extended data type column, you may receive a “maximum key length exceeded” error when Oracle tries to create the index to enforce uniqueness for the enabled constraint. See “Creating an Index on an Extended Data Type Column” for information on how to work around this issue.
**Restrictions on Unique Constraints** Unique constraints are subject to the following restrictions:
``````````````````````````````````
- None of the columns in the unique key can be of LOB, LONG, LONG RAW, VARRAY, NESTED TABLE, OBJECT, REF, TIMESTAMP WITH TIME ZONE, or user-defined type. However, the unique key can contain a column of TIMESTAMP WITH LOCAL TIME ZONE.
- A composite unique key cannot have more than 32 columns.
- You cannot designate the same column or combination of columns as both a primary key and a unique key.
- You cannot specify a unique key when creating a subview in an inheritance hierarchy. The unique key can be specified only for the top-level (root) view.
````
- When you specify a unique constraint for an external table, you must specify the RELY and DISABLE constraint states. See External Table Constraints for more information.
**See Also:**   “Unique Key Example” and Composite Unique Key Example
## Primary Key Constraints
A **primary key** constraint designates a column as the primary key of a table or view. A **composite primary key** designates a combination of columns as the primary key. When you define a primary key constraint inline, you need only the `PRIMARY` `KEY` keywords. When you define a primary key constraint out of line, you must also specify one or more columns. You must define a composite primary key out of line.
To satisfy a primary key constraint:
- No primary key value can appear in more than one row in the table.
- No column that is part of the primary key can contain a null.
When you create a primary key constraint:
- Oracle Database uses an existing index if it contains a unique set of values before enforcing the primary key constraint. The existing index can be defined as unique or nonunique. When a DML operation is performed, the primary key constraint is enforced using this existing index.
- If no existing index can be used, then Oracle Database generates a unique index.
When you drop a primary key constraint:
- If the primary key was created using an existing index, then the index is not dropped.
- If the primary key was created using a system-generated index, then the index is dropped.
When you designate an extended data type column as an enabled primary key, you may receive a “maximum key length exceeded” error when Oracle tries to create the index to enforce uniqueness for the enabled constraint. See “Creating an Index on an Extended Data Type Column” for information on how to work around this issue.
Primary key constraints are sensitive to declared collations of their key columns. See Collation Sensitivity of Constraints for more details.
**Restrictions on Primary Key Constraints** Primary constraints are subject to the following restrictions:
- A table or view can have only one primary key.
``````````````````````````````````
- None of the columns in the primary key can be LOB, LONG, LONG RAW, VARRAY, NESTED TABLE, BFILE, REF, TIMESTAMP WITH TIME ZONE, or user-defined type. However, the primary key can contain a column of TIMESTAMP WITH LOCAL TIME ZONE.
- The size of the primary key cannot exceed approximately one database block.
- A composite primary key cannot have more than 32 columns.
- You cannot designate the same column or combination of columns as both a primary key and a unique key.
- You cannot specify a primary key when creating a subview in an inheritance hierarchy. The primary key can be specified only for the top-level (root) view.
````
- When you specify a primary key constraint for an external table, you must specify the RELY and DISABLE constraint states. See External Table Constraints for more information.
**See Also:**   “Primary Key Example” and “Composite Primary Key Example”
## Foreign Key Constraints
A **foreign key constraint** (also called a **referential integrity constraint**) designates a column as the foreign key and establishes a relationship between that foreign key and a specified primary or unique key, called the **referenced key**. A **composite foreign key** designates a combination of columns as the foreign key.
The table or view containing the foreign key is called the **child** object, and the table or view containing the referenced key is called the **parent** object. The foreign key and the referenced key can be in the same table or view. In this case, the parent and child tables are the same. If you identify only the parent table or view and omit the column name, then the foreign key automatically references the primary key of the parent table or view. The corresponding column or columns of the foreign key and the referenced key must match in order, data types, and declared collations.
Foreign key constraints are sensitive to declared collations of the referenced primary or unique key columns. See Collation Sensitivity of Constraints for more details.
You can define a foreign key constraint on a single key column either inline or out of line. You must specify a composite foreign key and a foreign key on an attribute out of line.
To satisfy a composite foreign key constraint, the composite foreign key must refer to a composite unique key or a composite primary key in the parent table or view, or the value of at least one of the columns of the foreign key must be null.
You can designate the same column or combination of columns as both a foreign key and a primary or unique key. You can also designate the same column or combination of columns as both a foreign key and a cluster key.
You can define multiple foreign keys in a table or view. Also, a single column can be part of more than one foreign key.
**Restrictions on Foreign Key Constraints** Foreign key constraints are subject to the following restrictions:
``````````````````````````````````
- None of the columns in the foreign key can be of LOB, LONG, LONG RAW, VARRAY, NESTED TABLE, BFILE, REF, TIMESTAMP WITH TIME ZONE, or user-defined type. However, the primary key can contain a column of TIMESTAMP WITH LOCAL TIME ZONE.
- The referenced unique or primary key constraint on the parent table or view must already be defined.
- A composite foreign key cannot have more than 32 columns.
- The child and parent tables must be on the same database. To enable referential integrity constraints across nodes of a distributed database, you must use database triggers. See CREATE TRIGGER.
- If either the child or parent object is a view, then the constraint is subject to all restrictions on view constraints. See “View Constraints”.
``````**````
- You cannot define a foreign key constraint in a CREATE TABLE statement that contains an AS subquery clause. Instead, you must create the table without the constraint and then add it later with an ALTER TABLE statement.
- When a table has a foreign key, and the parent of the foreign key is an index-organized table, a session that updates a row that contains the foreign key can hang when another session is updating a non-key column in the parent table.
````
```

```
- When you specify a foreign key constraint for an external table, you must specify the RELY and DISABLE constraint states. See External Table Constraints for more information.
## *references_clause*
Foreign key constraints use the *references_clause* syntax. When you specify a foreign key constraint inline, you need only the *references_clause*. When you specify a foreign key constraint out of line, you must also specify the `FOREIGN` `KEY` keywords and one or more columns.
**ON DELETE Clause**
The `ON` `DELETE` clause lets you determine how Oracle Database automatically maintains referential integrity if you remove a referenced primary or unique key value. If you omit this clause, then Oracle does not allow you to delete referenced key values in the parent table that have dependent rows in the child table.
- Specify CASCADE if you want Oracle to remove dependent foreign key values.
``````
- Specify SET NULL if you want Oracle to convert dependent foreign key values to NULL. You cannot specify this clause for a virtual column, because the values in a virtual column cannot be updated directly. Rather, the values from which the virtual column are derived must be updated.
**Restriction on ON DELETE** You cannot specify this clause for a view constraint.
**See Also:**   “ON DELETE Example”
## Check Constraints
A **check constraint** lets you specify a condition that each row in the table must satisfy. To satisfy the constraint, each row in the table must make the condition either `TRUE` or unknown (due to a null). When Oracle evaluates a check constraint condition for a particular row, any column names in the condition refer to the column values in that row.
The syntax for inline and out-of-line specification of check constraints is the same. However, inline specification can refer only to the column (or the attributes of the column if it is an object column) currently being defined, whereas out-of-line specification can refer to multiple columns or attributes.
Oracle does not verify that conditions of check constraints are not mutually exclusive. Therefore, if you create multiple check constraints for a column, design them carefully so their purposes do not conflict. Do not assume any particular order of evaluation of the conditions.
If the condition of a check constraint depends on NLS parameters, such as `NLS_DATE_FORMAT`, Oracle evaluates the condition using the database values of the parameters, not the session values. You can find the database values of the NLS parameters in the data dictionary view `NLS_DATABASE_PARAMETERS`. These values are associated with a database by the DDL statement `CREATE` `DATABASE` and never change afterwards.
**See Also:**
- Conditions for additional information and syntax
- “Check Constraint Examples” and “Attribute-Level Constraints Example”
**Restrictions on Check Constraints** Check constraints are subject to the following restrictions:
``````
- You cannot specify a check constraint for a view. However, you can define the view using the WITH CHECK OPTION clause, which is equivalent to specifying a check constraint for the view.
- The condition of a check constraint can refer to any column in the table, but it cannot refer to columns of other tables.
  - Subqueries and scalar subquery expressions
````````````````````
  - Calls to the functions that are not deterministic (CURRENT_DATE, CURRENT_TIMESTAMP, DBTIMEZONE, LOCALTIMESTAMP, SESSIONTIMEZONE, SYSDATE, SYSTIMESTAMP, UID, USER, and USERENV)
  - Calls to user-defined functions
````
  - Dereferencing of REF columns (for example, using the DEREF function)
  - Nested table columns or attributes
````````
  - The pseudocolumns CURRVAL, NEXTVAL, LEVEL, or ROWNUM
  - Date constants that are not fully specified
  - You cannot specify a check constraint for an external table.
## REF Constraints
`REF` constraints let you describe the relationship between a column of type `REF` and the object it references.
## *ref_constraint*
`REF` constraints use the *ref_constraint* syntax. You define a `REF` constraint either inline or out of line. Out-of-line specification requires you to specify the `REF` column or attribute you are further describing.
**
- For ref_column, specify the name of a REF column of an object or relational table.
**
- For ref_attribute, specify an embedded REF attribute within an object column of a relational table.
Both inline and out-of-line specification let you define a scope constraint, a rowid constraint, or a referential integrity constraint on a `REF` column.
If the scope table or referenced table of the `REF` column has a primary-key-based object identifier, then the `REF` column is a **user-defined****REF****column**.
**See Also:** **
- Oracle Database Object-Relational Developer’s Guide for more information on REF data types
- “Foreign Key Constraints”, and “REF Constraint Examples”
## SCOPE REF Constraints
In a table with a `REF` column, each `REF` value in the column can conceivably reference a row in a different object table. The `SCOPE` clause restricts the scope of references to a single table, *scope_table*. The values in the `REF` column or attribute point to objects in *scope_table*, in which object instances of the same type as the `REF` column are stored.
Specify the `SCOPE` clause to restrict the scope of references in the `REF` column to a single table. For you to specify this clause, *scope_table* must be in your own schema, or you must have the `READ` or `SELECT` privilege on *scope_table*, or you must have the `READ` `ANY` `TABLE` or `SELECT` `ANY` `TABLE` system privilege. You can specify only one scope table for each `REF` column.
**Restrictions on Scope Constraints** Scope constraints are subject to the following restrictions:
- You cannot add a scope constraint to an existing column unless the table is empty.
````
- You cannot specify a scope constraint for the REF elements of a VARRAY column.
**
- You must specify this clause if you specify AS subquery and the subquery returns user-defined REF data types.
- You cannot subsequently drop a scope constraint from a REF column.
- You cannot specify a scope constraint for an external table.
## Rowid REF Constraints
Specify `WITH` `ROWID` to store the rowid along with the `REF` value in *ref_column*or *ref_attribute*. Storing the rowid with the `REF` value can improve the performance of dereferencing operations, but will also use more space. Default storage of `REF` values is without rowids.
**See Also:**   The function DEREF for an example of dereferencing
**Restrictions on Rowid Constraints**
Rowid constraints are subject to the following restrictions:
````
- You cannot define a rowid constraint for the REF elements of a VARRAY column.
- You cannot subsequently drop a rowid constraint from a REF column.
````
- If the REF column or attribute is scoped, then this clause is ignored and the rowid is not stored with the REF value.
- You cannot specify a rowid constraint for an external table.
## Referential Integrity Constraints on REF Columns
The *references_clause* of the *ref_constraint* syntax lets you define a foreign key constraint on the `REF` column. This clause also implicitly restricts the scope of the `REF` column or attribute to the referenced table. However, whereas a foreign key constraint on a non-`REF` column references an actual column in the parent table, a foreign key constraint on a `REF` column references the implicit object identifier column of the parent table.
If you do not specify `a` constraint name, then Oracle generates a system name for the constraint of the form `SYS_C`*n*.
If you add a referential integrity constraint to an existing `REF` column that is already scoped, then the referenced table must be the same as the scope table of the `REF` column. If you later drop the referential integrity constraint, then the `REF` column will remain scoped to the referenced table.
As is the case for foreign key constraints on other types of columns, you can use the *references_clause* alone for inline declaration. For out-of-line declaration you must also specify the `FOREIGN` `KEY` keywords plus one or more `REF` columns or attributes.
**See Also:**   *Oracle Database Object-Relational Developer’s Guide* for more information on object identifiers
**Restrictions on Foreign Key Constraints on REF Columns**
Foreign key constraints on `REF` columns have the following additional restrictions:
- Oracle implicitly adds a scope constraint when you add a referential integrity constraint to an existing unscoped REF column. Therefore, all the restrictions that apply for scope constraints also apply in this case.
**
- You cannot specify a column after the object name in the references_clause.
## Collation Sensitivity of Constraints
Starting with Oracle Database 12*c* Release 2 (
12.2), primary key, unique, and foreign key constraints are sensitive to declared collations of their key columns. A primary or unique key character column value from a new or updated row is compared with values in existing rows using the declared collation of the key column. For example, if the declared collation of the key column is the case-insensitive collation `BINARY_CI`, a new or updated row may be rejected if the new key column value differs from some existing key value only by case. The collation `BINARY_CI` treats character values differing only by case as equal.
A foreign key character column value is compared to parent primary or unique key column values using the declared collation of the parent key column. For example, if the declared collation of the key column is the case-insensitive collation `BINARY_CI`, a new or updated child row may be accepted even if there is no identical parent key value for the corresponding foreign key value, provided there exists a value differing only by case.
The declared collation of a foreign key column must be the same as the collation of the corresponding parent key column.
Columns in a composite key of a constraint may have different declared collations.
When the declared collation of a key column of a constraint is a pseudo-collation, the constraint uses a corresponding variant of the collation `BINARY`. Pseudo-collations cannot be used directly to compare values for a constraint, because constraints are static and cannot depend on session NLS parameters on which the pseudo-collations depend. Therefore:
````````
- The pseudo-collations USING_NLS_COMP, USING_NLS_SORT, and USING_NLS_SORT_CS use the collation BINARY.
````
- The pseudo-collation USING_NLS_COMP_CI uses the collation BINARY_CI.
````
- The pseudo-collation USING_NLS_COMP_AI uses the collation BINARY_AI.
When the effective collation used by a primary or unique key column is not `BINARY`, Oracle creates a hidden virtual column for this column. The expression of the virtual column calculates collation keys for character values of the original key column. The primary key or unique constraint is internally created on the virtual column instead of the original column. The virtual column is visible in the data dictionary views of the `*_TAB_COLS` family. For each of these hidden virtual columns, the `COLLATED_COLUMN_ID` of the `*_TAB_COLS` views contains the internal sequence number pointing to the corresponding original key column. The hidden virtual columns count to the 1000-column limit of a table.
```

```
## Specifying Constraint State
You can specify how and when Oracle should enforce the constraint when you define the constraint.
## *constraint_state*
You can use *constraint_state* with both inline and out-of-line specification. Except for the clauses `DEFERRABLE` and `INITIALLY`, that may be specified in any order, you must specify the rest of the component clauses in the order shown, and each clause only once.
## DEFERRABLE Clause
The `DEFERRABLE` and `NOT` `DEFERRABLE` parameters indicate whether or not, in subsequent transactions, constraint checking can be deferred until the end of the transaction using the `SET` `CONSTRAINT`(`S`) statement. If you omit this clause, then the default is `NOT` `DEFERRABLE`.
``````````````
````````````
- Specify NOT DEFERRABLE to indicate that in subsequent transactions you cannot use the SET CONSTRAINT[S] clause to defer checking of this constraint until the transaction is committed. The checking of a NOT DEFERRABLE constraint can never be deferred to the end of the transaction. If you declare a new constraint NOT DEFERRABLE, then it must be valid at the time the CREATE TABLE or ALTER TABLE statement is committed or the statement will fail.
``````````****
- Specify DEFERRABLE to indicate that in subsequent transactions you can use the SET CONSTRAINT[S] clause to defer checking of this constraint until a COMMIT statement is submitted. If the constraint check fails, then the database returns an error and the transaction is not committed. This setting in effect lets you disable the constraint temporarily while making changes to the database that might violate the constraint until all the changes are complete. Note: The optimizer does not consider indexes on deferrable constraints as usable.
You cannot alter the deferrability of a constraint. Whether you specify either of these parameters, or make the constraint `NOT` `DEFERRABLE` implicitly by specifying neither of them, you cannot specify this clause in an `ALTER` `TABLE` statement. You must drop the constraint and re-create it.
**See Also:**
- SET CONSTRAINT[S] for information on setting constraint checking for a transaction
****
- Oracle Database Administrator’s Guide and Oracle Database Concepts for more information about deferred constraints
- “DEFERRABLE Constraint Examples”
**Restriction on [NOT] DEFERRABLE**
You cannot specify either of these parameters for a view constraint.
## INITIALLY Clause
The `INITIALLY` clause establishes the default checking behavior for constraints that are `DEFERRABLE`. The `INITIALLY` setting can be overridden by a `SET` `CONSTRAINT`(`S`) statement in a subsequent transaction.
**``````````
````````````
- **Specify INITIALLY IMMEDIATE to indicate that Oracle should check this constraint at the end of each subsequent SQL statement. If you do not specify INITIALLY at all, then the default is INITIALLY IMMEDIATE. If you declare a new constraint INITIALLY IMMEDIATE, then it must be valid at the time the CREATE TABLE or ALTER TABLE statement is committed or the statement will fail.
**````
- **Specify INITIALLY DEFERRED to indicate that Oracle should check this constraint at the end of subsequent transactions.
This clause is not valid if you have declared the constraint to be `NOT` `DEFERRABLE`, because a `NOT` `DEFERRABLE` constraint is automatically `INITIALLY` `IMMEDIATE` and cannot ever be `INITIALLY` `DEFERRED`.
## RELY Clause
The `RELY` and `NORELY` parameters specify whether a constraint in `NOVALIDATE` mode is to be taken into account for query rewrite. Specify `RELY` to activate a constraint in `NOVALIDATE` mode for query rewrite in an unenforced query rewrite integrity mode. The constraint is in `NOVALIDATE` mode, so Oracle does not enforce it. The default is `NORELY`.
Unenforced constraints are generally useful only with materialized views and query rewrite. Depending on the  `QUERY_REWRITE_INTEGRITY`  mode, query rewrite can use only constraints that are in `VALIDATE` mode, or that are in `NOVALIDATE` mode with the `RELY` parameter set, to determine join information.
**Restriction on the RELY Clause** You cannot set a nondeferrable `NOT` `NULL` constraint to `RELY`.
**See Also:**   *Oracle Database Data Warehousing Guide* for more information on materialized views and query rewrite
## Using Indexes to Enforce Constraints
When defining the state of a unique or primary key constraint, you can specify an index for Oracle to use to enforce the constraint, or you can instruct Oracle to create the index used to enforce the constraint.
## *using_index_clause*
You can specify the *using_index_clause* only when enabling unique or primary key constraints. You can specify the clauses of the *using_index_clause* in any order, but you can specify each clause only once.
******
- If you specify schema.index, then Oracle attempts to enforce the constraint using the specified index. If Oracle cannot find the index or cannot use the index to enforce the constraint, then Oracle returns an error.
**
- If you specify the create_index_statement, then Oracle attempts to create the index and use it to enforce the constraint. If Oracle cannot create the index or cannot use the index to enforce the constraint, then Oracle returns an error.
  - The index receives the same name as the constraint.
**
  - If table is partitioned, then you can specify a locally or globally partitioned index for the unique or primary key constraint.
**Restrictions on the** ***using_index_clause*** The following restrictions apply to the *using_index_clause*:
- You cannot specify this clause for a view constraint.
````
- You cannot specify this clause for a NOT NULL, foreign key, or check constraint.
****
- You cannot specify an index (schema.index) or create an index (create_index_statement) when enabling the primary key of an index-organized table.
****
- You cannot specify the parallel_clause of index_attributes.
````**
- The INDEXTYPE IS ... clause of index_properties is not valid in the definition of a constraint.
**See Also:** ********
- CREATE INDEX for a description of index_attributes, the global_partitioned_index and local_partitioned_index clauses, and for a description of NOSORT and the logging_clause in relation to indexes
****
- physical_attributes_clause and PCTFREE parameters and storage_clause
- “Explicit Index Control Example”
## ENABLE Clause
Specify `ENABLE` if you want the constraint to be applied to the data in the table.
If you enable a unique or primary key constraint, and if no index exists on the key, then Oracle Database creates a unique index. Unless you specify `KEEP INDEX` when subsequently disabling the constraint, this index is dropped and the database rebuilds the index every time the constraint is reenabled.
You can also avoid rebuilding the index and eliminate redundant indexes by creating new primary key and unique constraints initially disabled. Then create (or use existing) nonunique indexes to enforce the constraint. Oracle does not drop a nonunique index when the constraint is disabled, so subsequent `ENABLE` operations are facilitated.
**````
````````
- **ENABLE VALIDATE specifies that all old and new data also complies with the constraint. An enabled validated constraint guarantees that all data is and will continue to be valid. If any row in the table violates the integrity constraint, then the constraint remains disabled and Oracle returns an error. If all rows comply with the constraint, then Oracle enables the constraint. Subsequently, if new data violates the constraint, then Oracle does not execute the statement and returns an error indicating the integrity constraint violation. If you place a primary key constraint in ENABLE VALIDATE mode, then the validation process will verify that the primary key columns contain no nulls. To avoid this overhead, mark each column in the primary key NOT NULL before entering data into the column and before enabling the primary key constraint of the table.
**````
- **ENABLE NOVALIDATE ensures that all new DML operations on the constrained data comply with the constraint. This clause does not ensure that existing data in the table complies with the constraint.
If you specify neither `VALIDATE` nor `NOVALIDATE`, then the default is `VALIDATE`.
If you change the state of any single constraint from `ENABLE` `NOVALIDATE` to `ENABLE` `VALIDATE`, then the operation can be performed in parallel, and does not block reads, writes, or other DDL operations.
**Restriction on the ENABLE Clause**
You cannot enable a foreign key that references a disabled unique or primary key.
## DISABLE Clause
Specify `DISABLE` to disable the integrity constraint. Disabled integrity constraints appear in the data dictionary along with enabled constraints. If you do not specify this clause when creating a constraint, then Oracle automatically enables the constraint.
````**````
******
- DISABLE VALIDATE disables the constraint and drops the index on the constraint, but keeps the constraint valid. This feature is most useful in data warehousing situations, because it lets you load large amounts of data while also saving space by not having an index. This setting lets you load data from a nonpartitioned table into a partitioned table using the exchange_partition_subpart clause of the ALTER TABLE statement or using SQL*Loader. All other modifications to the table (inserts, updates, and deletes) by other SQL statements are disallowed. See Also: Oracle Database Data Warehousing Guide for more information on using this setting
````
````````
******
- DISABLE NOVALIDATE signifies that Oracle makes no effort to maintain the constraint (because it is disabled) and cannot guarantee that the constraint is true (because it is not being validated). You cannot drop a table whose primary key is being referenced by a foreign key even if the foreign key constraint is in DISABLE NOVALIDATE state. Further, the optimizer can use constraints in DISABLE NOVALIDATE state. See Also: Oracle Database SQL Tuning Guide for information on when to use this setting
If you specify neither `VALIDATE` nor `NOVALIDATE`, then the default is `NOVALIDATE`.
If you disable a unique or primary key constraint that is using a unique index, then Oracle drops the unique index. Refer to the `CREATE` `TABLE` *enable_disable_clause* for additional notes and restrictions.
## VALIDATE | NOVALIDATE
The behavior of `VALIDATE` and `NOVALIDATE` depends on whether the constraint is enabled or disabled, either explicitly or by default. Therefore, the `VALIDATE` and `NOVALIDATE` keywords are described in the context of “ENABLE Clause” and “DISABLE Clause”.
**Note on Foreign Key Constraints in NOVALIDATE Mode** When a foreign key constraint is in `NOVALIDATE` mode, if existing data in the table does not comply with the constraint and the `QUERY_REWRITE_INTEGRITY` parameter is not set to `ENFORCED`, then the optimizer may use join elimination during queries on the table. In this case, a query may return table rows with noncompliant foreign key values even if the query contains a join condition that should filter out those rows.
## Handling Constraint Exceptions
When defining the state of a constraint, you can specify a table into which Oracle places the rowids of all rows violating the constraint.
## *exceptions_clause*
Use the *exceptions_clause* syntax to define exception handling. If you omit *schema*, then Oracle assumes the exceptions table is in your own schema. If you omit this clause altogether, then Oracle assumes that the table is named `EXCEPTIONS`. The `EXCEPTIONS` table or the table you specify must exist on your local database.
You can create the `EXCEPTIONS` table using one of these scripts:
- UTLEXCPT.SQL uses physical rowids. Therefore it can accommodate rows from conventional tables but not from index-organized tables. (See the Note that follows.)
- UTLEXPT1.SQL uses universal rowids, so it can accommodate rows from both conventional and index-organized tables.
If you create your own exceptions table, then it must follow the format prescribed by one of these two scripts.
If you are collecting exceptions from index-organized tables based on primary keys (rather than universal rowids), then you must create a separate exceptions table for each index-organized table to accommodate its primary-key storage. You create multiple exceptions tables with different names by modifying and resubmitting the script.
**Restrictions on the** ***exceptions_clause*** The following restrictions apply to the *exceptions_clause*:
- You cannot specify this clause for a view constraint.
````**
****
**
  - The DBMS_IOT package in Oracle Database PL/SQL Packages and Types Reference for information on the SQL scripts
**
  - Oracle Database Performance Tuning Guide for information on eliminating migrated and chained rows
## View Constraints
Oracle does not enforce view constraints. However, operations on views are subject to the integrity constraints defined on the underlying base tables. This means that you can enforce constraints on views through constraints on base tables.
**Notes on View Constraints**
View constraints are a subset of table constraints and are subject to the following restrictions:
``````
- You can specify only unique, primary key, and foreign key constraints on views. However, you can define the view using the WITH CHECK OPTION clause, which is equivalent to specifying a check constraint for the view.
````````
- View constraints are supported only in DISABLE NOVALIDATE mode. You cannot specify any other mode. You must specify the keyword DISABLE when you declare the view constraint. You need not specify NOVALIDATE explicitly, as it is the default.
````````````
- The RELY and NORELY parameters are optional. View constraints, because they are unenforced, are usually specified with the RELY parameter to make them more useful. The RELY or NORELY keyword must precede the DISABLE keyword.
``````
- Because view constraints are not enforced directly, you cannot specify INITIALLY DEFERRED or DEFERRABLE.
****````**
- You cannot specify the using_index_clause, the exceptions_clause clause, or the ON DELETE clause of the references_clause.
- You cannot define view constraints on attributes of an object column.
## External Table Constraints
Starting with Oracle Database 12*c* Release 2 (12.2), you can specify `NOT` `NULL`, unique, primary key, and foreign key constraints on external tables.
`NOT` `NULL` constraints on external tables are enforced and prohibit columns from containing nulls.
Unique, primary key, and foreign key constraints are supported on external tables only in `RELY` `DISABLE` mode. You must specify the keywords `RELY` and `DISABLE` when you create these constraints. These constraints are declarative and are not enforced. They can increase query performance and reduce resource consumption because more optimizer transformations can be taken into account. In order for the optimizer to utilize these `RELY` `DISABLE` constraints, the `QUERY_REWRITE_INTEGRITY` initialization parameter must be set to either `trusted` or `stale_tolerated`.
## Examples
**Unique Key Example**
The following statement is a variation of the statement that created the sample table `sh.promotions`. It defines inline and implicitly enables a unique key on the `promo_id` column (other constraints are not shown):
```
CREATE TABLE promotions_var1 ( promo_id         NUMBER(6) CONSTRAINT promo_id_u  UNIQUE , promo_name       VARCHAR2(20) , promo_category   VARCHAR2(15) , promo_cost       NUMBER(10,2) , promo_begin_date DATE , promo_end_date   DATE ) ;
```
The constraint `promo_id_u` identifies the `promo_id` column as a unique key. This constraint ensures that no two promotions in the table have the same ID. However, the constraint does allow promotions without identifiers.
Alternatively, you can define and enable this constraint out of line:
```
CREATE TABLE promotions_var2 ( promo_id         NUMBER(6) , promo_name       VARCHAR2(20) , promo_category   VARCHAR2(15) , promo_cost       NUMBER(10,2) , promo_begin_date DATE , promo_end_date   DATE , CONSTRAINT promo_id_u UNIQUE (promo_id) USING INDEX PCTFREE 20 TABLESPACE stocks STORAGE (INITIAL 8M) );
```
The preceding statement also contains the *using_index_clause*, which specifies storage characteristics for the index that Oracle creates to enable the constraint.
**Composite Unique Key Example**
The following statement defines and enables a composite unique key on the combination of the `warehouse_id` and `warehouse_name` columns of the `oe.warehouses` table:
```
ALTER TABLE warehouses ADD CONSTRAINT wh_unq UNIQUE (warehouse_id, warehouse_name) USING INDEX PCTFREE 5 EXCEPTIONS INTO wrong_id;
```
The `wh_unq` constraint ensures that the same combination of `warehouse_id` and `warehouse_name` values does not appear in the table more than once.
The `ADD` `CONSTRAINT` clause also specifies other properties of the constraint:
````
- The USING INDEX clause specifies storage characteristics for the index Oracle creates to enable the constraint.
``````````
- The EXCEPTIONS INTO clause causes Oracle to write to the wrong_id table information about any rows currently in the warehouses table that violate the constraint. If the wrong_id exceptions table does not already exist, then this statement will fail.
**Primary Key Example**
The following statement is a variation of the statement that created the sample table `hr.locations`. It creates the `locations_demo` table and defines and enables a primary key on the `location_id` column (other constraints from the `hr.locations` table are omitted):
```
CREATE TABLE locations_demo ( location_id    NUMBER(4) CONSTRAINT loc_id_pk PRIMARY KEY , street_address VARCHAR2(40) , postal_code    VARCHAR2(12) , city           VARCHAR2(30) , state_province VARCHAR2(25) , country_id     CHAR(2) ) ;
```
The `loc_id_pk` constraint, specified inline, identifies the `location_id` column as the primary key of the `locations_demo` table. This constraint ensures that no two locations in the table have the same location number and that no location identifier is `NULL`.
Alternatively, you can define and enable this constraint out of line:
```
CREATE TABLE locations_demo ( location_id    NUMBER(4) , street_address VARCHAR2(40) , postal_code    VARCHAR2(12) , city           VARCHAR2(30) , state_province VARCHAR2(25) , country_id     CHAR(2) , CONSTRAINT loc_id_pk PRIMARY KEY (location_id));
```
**NOT NULL Example**
The following statement alters the `locations_demo` table (created in “Primary Key Example”) to define and enable a `NOT` `NULL` constraint on the `country_id` column:
```
ALTER TABLE locations_demo MODIFY (country_id CONSTRAINT country_nn NOT NULL);
```
The constraint `country_nn` ensures that no location in the table has a null `country_id`.
**Composite Primary Key Example**
The following statement defines a composite primary key on the combination of the `prod_id` and `cust_id` columns of the sample table `sh.sales`:
```
ALTER TABLE sales ADD CONSTRAINT sales_pk PRIMARY KEY (prod_id, cust_id) DISABLE;
```
This constraint identifies the combination of the `prod_id` and `cust_id` columns as the primary key of the `sales` table. The constraint ensures that no two rows in the table have the same combination of values for the `prod_id` column and `cust_id` columns.
The constraint clause (`PRIMARY` `KEY`) also specifies the following properties of the constraint:
- The constraint definition does not include a constraint name, so Oracle generates a name for the constraint.
- The DISABLE clause causes Oracle to define the constraint but not enable it.
**Foreign Key Constraint Example**
The following statement creates the `dept_20` table and defines and enables a foreign key on the `department_id` column that references the primary key on the `department_id` column of the `departments` table:
```
CREATE TABLE dept_20 (employee_id     NUMBER(4), last_name       VARCHAR2(10), job_id          VARCHAR2(9), manager_id      NUMBER(4), hire_date       DATE, salary          NUMBER(7,2), commission_pct  NUMBER(7,2), department_id   CONSTRAINT fk_deptno REFERENCES departments(department_id) );
```
The constraint `fk_deptno` ensures that all departments given for employees in the `dept_20` table are present in the `departments` table. However, employees can have null department numbers, meaning they are not assigned to any department. To ensure that all employees are assigned to a department, you could create a `NOT` `NULL` constraint on the `department_id` column in the `dept_20` table in addition to the `REFERENCES` constraint.
Before you define and enable this constraint, you must define and enable a constraint that designates the `department_id` column of the `departments` table as a primary or unique key.
The foreign key constraint definition does not use the `FOREIGN` `KEY` clause, because the constraint is defined inline. The data type of the *department_id* column is not needed, because Oracle automatically assigns to this column the data type of the referenced key.
The constraint definition identifies both the parent table and the columns of the referenced key. Because the referenced key is the primary key of the parent table, the referenced key column names are optional.
Alternatively, you can define this foreign key constraint out of line:
```
CREATE TABLE dept_20 (employee_id     NUMBER(4), last_name       VARCHAR2(10), job_id          VARCHAR2(9), manager_id      NUMBER(4), hire_date       DATE, salary          NUMBER(7,2), commission_pct  NUMBER(7,2), department_id, CONSTRAINT fk_deptno FOREIGN  KEY (department_id) REFERENCES  departments(department_id) );
```
The foreign key definitions in both variations of this statement omit the `ON` `DELETE` clause, causing Oracle to prevent the deletion of a department if any employee works in that department.
**ON DELETE Example**
This statement creates the `dept_20` table, defines and enables two referential integrity constraints, and uses the `ON` `DELETE` clause:
```
CREATE TABLE dept_20 (employee_id     NUMBER(4) PRIMARY KEY, last_name       VARCHAR2(10), job_id          VARCHAR2(9), manager_id      NUMBER(4) CONSTRAINT fk_mgr REFERENCES employees ON DELETE SET NULL, hire_date       DATE, salary          NUMBER(7,2), commission_pct  NUMBER(7,2), department_id   NUMBER(2)   CONSTRAINT fk_deptno REFERENCES departments(department_id) ON DELETE CASCADE );
```
Because of the first `ON` `DELETE` clause, if manager number 2332 is deleted from the `employees` table, then Oracle sets to null the value of `manager_id` for all employees in the `dept_20` table who previously had manager 2332.
Because of the second `ON` `DELETE` clause, Oracle cascades any deletion of a `department_id` value in the `departments` table to the `department_id` values of its dependent rows of the `dept_20` table. For example, if Department 20 is deleted from the `departments` table, then Oracle deletes all of the employees in Department 20 from the `dept_20` table.
**Composite Foreign Key Constraint Example**
The following statement defines and enables a foreign key on the combination of the `employee_id` and `hire_date` columns of the `dept_20` table:
```
ALTER TABLE dept_20 ADD CONSTRAINT fk_empid_hiredate FOREIGN KEY (employee_id, hire_date) REFERENCES hr.job_history(employee_id, start_date) EXCEPTIONS INTO wrong_emp;
```
The constraint `fk_empid_hiredate` ensures that all the employees in the `dept_20` table have `employee_id` and `hire_date` combinations that exist in the `employees` table. Before you define and enable this constraint, you must define and enable a constraint that designates the combination of the `employee_id` and `hire_date` columns of the `employees` table as a primary or unique key.
The `EXCEPTIONS` `INTO` clause causes Oracle to write information to the `wrong_emp` table about any rows in the `dept_20` table that violate the constraint. If the `wrong_emp` exceptions table does not already exist, then this statement will fail.
**Check Constraint Examples**
The following statement creates a `divisions` table and defines a `check` constraint in each column of the table:
```
CREATE TABLE divisions (div_no    NUMBER  CONSTRAINT check_divno CHECK (div_no BETWEEN 10 AND 99) DISABLE, div_name  VARCHAR2(9)  CONSTRAINT check_divname CHECK (div_name = UPPER(div_name)) DISABLE, office    VARCHAR2(10)  CONSTRAINT check_office CHECK (office IN ('DALLAS','BOSTON', 'PARIS','TOKYO')) DISABLE);
```
Each constraint restricts the values of the column in which it is defined:
- check_divno ensures that no division numbers are less than 10 or greater than 99.
- check_divname ensures that all division names are in uppercase.
- check_office restricts office locations to Dallas, Boston, Paris, or Tokyo.
Because each `CONSTRAINT` clause contains the `DISABLE` clause, Oracle only defines the constraints and does not enable them.
The following statement creates the `dept_20` table, defining out of line and implicitly enabling a check constraint:
```
CREATE TABLE dept_20 (employee_id     NUMBER(4) PRIMARY KEY, last_name       VARCHAR2(10), job_id          VARCHAR2(9), manager_id      NUMBER(4), salary          NUMBER(7,2), commission_pct  NUMBER(7,2), department_id   NUMBER(2), CONSTRAINT check_sal CHECK (salary * commission_pct <= 5000));
```
This constraint uses an inequality condition to limit an employee’s total commission, the product of `salary` and `commission_pct`, to $5000:
- If an employee has non-null values for both salary and commission, then the product of these values must not exceed $5000 to satisfy the constraint.
- If an employee has a null salary or commission, then the result of the condition is unknown and the employee automatically satisfies the constraint.
Because the constraint clause in this example does not supply a constraint name, Oracle generates a name for the constraint.
The following statement defines and enables a primary key constraint, two foreign key constraints, a `NOT` `NULL` constraint, and two check constraints:
```
CREATE TABLE order_detail (CONSTRAINT pk_od PRIMARY KEY (order_id, part_no), order_id    NUMBER CONSTRAINT fk_oid REFERENCES oe.orders(order_id), part_no     NUMBER CONSTRAINT fk_pno REFERENCES oe.product_information(product_id), quantity    NUMBER CONSTRAINT nn_qty NOT NULL CONSTRAINT check_qty CHECK (quantity > 0), cost        NUMBER CONSTRAINT check_cost CHECK (cost > 0) );
```
The constraints enable the following rules on table data:
``````````````
- pk_od identifies the combination of the order_id and part_no columns as the primary key of the table. To satisfy this constraint, no two rows in the table can contain the same combination of values in the order_id and the part_no columns, and no row in the table can have a null in either the order_id or the part_no column.
````````````````
- fk_oid identifies the order_id column as a foreign key that references the order_id column in the orders table in the sample schema oe. All new values added to the column order_detail.order_id must already appear in the column oe.orders.order_id.
``````````````
- fk_pno identifies the product_id column as a foreign key that references the product_id column in the product_information table owned by oe. All new values added to the column order_detail.product_id must already appear in the column oe.product_information.product_id.
````
- nn_qty forbids nulls in the quantity column.
````
- check_qty ensures that values in the quantity column are always greater than zero.
- check_cost ensures the values in the cost column are always greater than zero.
This example also illustrates the following points about constraint clauses and column definitions:
- Out-of-line constraint definition can appear before or after the column definitions. In this example, the out-of-line definition of the pk_od constraint precedes the column definitions.
``````
- A column definition can contain multiple inline constraint definitions. In this example, the definition of the quantity column contains the definitions of both the nn_qty and check_qty constraints.
``````
- A table can have multiple CHECK constraints. Multiple CHECK constraints, each with a simple condition enforcing a single business rule, are preferable to a single CHECK constraint with a complicated condition enforcing multiple business rules. When a constraint is violated, Oracle returns an error identifying the constraint. Such an error more precisely identifies the violated business rule if the identified constraint enables a single business rule.
**Case-Insensitive Constraints Example** The following statements create two tables in a parent-child relationship. The parent table is a product description table and the child table is a product component description table. Unique constraints are defined to assure that product and description values are unambiguous. For illustrative purposes, the product and component ID are case-insensitive character values. (In real-world applications, primary key IDs are usually numeric or case-normalized.)
```
CREATE TABLE products
    ( product_id VARCHAR2(20) COLLATE BINARY_CI
           CONSTRAINT product_pk PRIMARY KEY
    , description VARCHAR2(1000) COLLATE BINARY_CI
           CONSTRAINT product_description_unq UNIQUE
    );
CREATE TABLE product_components
    ( component_id VARCHAR2(40) COLLATE BINARY_CI
           CONSTRAINT product_component_pk PRIMARY KEY
    , product_id CONSTRAINT product_component_fk REFERENCES products(product_id)
    , description VARCHAR2(1000) COLLATE BINARY_CI
           CONSTRAINT product_component_descr_unq UNIQUE
    );
```
Note that if you do not specify the data type or the collation for a foreign key column, then they are inherited from the parent key column.
The following statements add a product and its components into the tables:
```
INSERT INTO products(product_id, description)
            VALUES('BICY0001', 'Men''s bicycle, fr 21", wh 24", gear 3x7');
INSERT INTO product_components(component_id, product_id, description)
            VALUES('BICY0001_FRAME01', 'BICY0001', 'Aluminium frame 21"');
INSERT INTO product_components(component_id, product_id, description)
            VALUES('BICY0001_WHEEL01', 'bicy0001', 'Wheels 24"');
INSERT INTO product_components(component_id, product_id, description)
            VALUES('BICY0001_GEAR01', 'Bicy0001', 'Front derailleur 3 chainrings');
INSERT INTO product_components(component_id, product_id, description)
            VALUES('BICY0001_gear02', 'BiCy0001', 'Rear derailleur 7 chainrings');
```
Note the different case of the product ID in different component rows. Because the primary key on the product ID is declared as case-insensitive, all possible letter case combinations of the same ID are considered equal.
The following statement demonstrates that it is not possible to enter another product with the same description differing only by case. It fails with the error `ORA-00001:` `unique` `constraint` `(`*schema*`.PRODUCT_DESCRIPTION_UNQ)` `violated`.
```
INSERT INTO products(product_id, description)
            VALUES('BICY0002', 'MEN''S BICYCLE, fr 21", wh 24", gear 3x7');
```
Similarly, the following statement demonstrates that the primary key contraint of the product table is case-insensitive and does not allow values differing only by case. It fails with the error `ORA-00001:` `unique` `constraint` `(`*schema*`.PRODUCT_PK)` `violated`.
```
INSERT INTO products(component_id, product_id, description)
            VALUES('bicy0001', 'Women''s bicycle, fr 21", wh 24", gear 2x6');
```
The following statement demonstrates that it is not possible to enter another component with the same description differing only by case. It fails with the error `ORA-00001:` `unique` `constraint` `(`*schema*`.PRODUCT_COMPONENT_DESCR_UNQ)` `violated`.
```
INSERT INTO product_components(component_id, product_id, description)
            VALUES('BICY0001_gear03', 'BiCy0001', 'REAR DERAILLEUR 7 CHAINRINGS');
```
**Attribute-Level Constraints Example** The following example guarantees that a value exists for both the `first_name` and `last_name` attributes of the `name` column in the `students` table:
```
CREATE TYPE person_name AS OBJECT
   (first_name VARCHAR2(30), last_name VARCHAR2(30));
/
CREATE TABLE students (name person_name, age INTEGER,
   CHECK (name.first_name IS NOT NULL AND
          name.last_name IS NOT NULL));
```
**REF Constraint Examples** The following example creates a duplicate of the sample schema object type `cust_address_typ`, and then creates a table containing a `REF` column with a `SCOPE` constraint:
```
CREATE TYPE cust_address_typ_new AS OBJECT
    ( street_address     VARCHAR2(40)
    , postal_code        VARCHAR2(10)
    , city               VARCHAR2(30)
    , state_province     VARCHAR2(10)
    , country_id         CHAR(2)
    );
/
CREATE TABLE address_table OF cust_address_typ_new;
CREATE TABLE customer_addresses (
   add_id NUMBER,
   address REF cust_address_typ_new
   SCOPE IS address_table);
```
The following example creates the same table but with a referential integrity constraint on the `REF` column that references the object identifier column of the parent table:
```
CREATE TABLE customer_addresses (
   add_id NUMBER,
   address REF cust_address_typ REFERENCES address_table);
```
The following example uses the type `department_typ` and the table `departments_obj_t`, created in “Creating Object Tables: Examples”. A table with a scoped `REF` is then created.
```
CREATE TABLE employees_obj
   ( e_name   VARCHAR2(100),
     e_number NUMBER,
     e_dept   REF department_typ SCOPE IS departments_obj_t );
```
The following statement creates a table with a `REF` column which has a referential integrity constraint defined on it:
```
CREATE TABLE employees_obj
   ( e_name   VARCHAR2(100),
     e_number NUMBER,
     e_dept   REF department_typ REFERENCES departments_obj_t);
```
**Explicit Index Control Example** The following statement shows another way to create a unique (or primary key) constraint that gives you explicit control over the index (or indexes) Oracle uses to enforce the constraint:
```
CREATE TABLE promotions_var3
    ( promo_id         NUMBER(6)
    , promo_name       VARCHAR2(20)
    , promo_category   VARCHAR2(15)
    , promo_cost       NUMBER(10,2)
    , promo_begin_date DATE
    , promo_end_date   DATE
    , CONSTRAINT promo_id_u UNIQUE (promo_id, promo_cost)
         USING INDEX (CREATE UNIQUE INDEX promo_ix1
            ON promotions_var3 (promo_id, promo_cost))
    , CONSTRAINT promo_id_u2 UNIQUE (promo_cost, promo_id)
         USING INDEX promo_ix1);
```
This example also shows that you can create an index for one constraint and use that index to create and enable another constraint in the same statement.
**DEFERRABLE Constraint Examples** The following statement creates table `games` with a `NOT` `DEFERRABLE` `INITIALLY` `IMMEDIATE` constraint check (by default) on the `scores` column:
```
CREATE TABLE games (scores NUMBER CHECK (scores >= 0));
```
To define a unique constraint on a column as `INITIALLY` `DEFERRED` `DEFERRABLE`, issue the following statement:
```
CREATE TABLE games
  (scores NUMBER, CONSTRAINT unq_num UNIQUE (scores)
   INITIALLY DEFERRED DEFERRABLE);
```
