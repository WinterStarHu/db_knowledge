# Creating and Managing Tables

Tables are the basic units of data storage in Oracle Database. Tables hold all user-accessible data. Each table contains rows that represent individual data records. Rows are composed of columns that represent the fields of the records.
**Note:**   To do the tutorials in this document, you must be connected to Oracle Database as the user HR from SQL Developer.
**See Also:**
- “Tutorial: Viewing EMPLOYEES Table Properties and Data with SQL Developer”
**
- Oracle SQL Developer User’s Guide for a SQL Developer tutorial that includes creating and populating tables
**
- Oracle Database Concepts for general information about tables
## About SQL Data Types
When you create a table, you must specify the SQL data type for each column, which determines what values the column can contain.
For example, a column of type DATE can contain the value `'01-MAY-05'`, but it cannot contain the numeric value 2 or the character value ‘shoe’. SQL data types fall into two categories: built-in and user-defined. (PL/SQL has additional data types-see “About PL/SQL Data Types”.) **See Also:** **
- Oracle Database SQL Language Reference for a summary of built-in SQL data types
**
- Oracle Database Concepts for introductions to each of the built-in SQL data types
**
- Oracle Database SQL Language Reference for more information about user-defined data types
- “About PL/SQL Data Types”
## Creating Tables
To create tables, use either the SQL Developer tool Create Table or the DDL statement CREATE TABLE.
This section shows how to use both of these ways to create these tables, which will contain data about employee evaluations:
- PERFORMANCE_PARTS, which contains the categories of employee performance that are evaluated and their relative weights
- EVALUATIONS, which contains employee information, evaluation date, job, manager, and department
- SCORES, which contains the scores assigned to each performance category for each evaluation
These tables appear in many tutorials and examples in this document.
### Tutorial: Creating a Table with the Create Table Tool
This tutorial shows how to create the `PERFORMANCE_PARTS` table using the SQL Developer tool Create Table.
**To create the PERFORMANCE_PARTS table using the Create Table tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Tables.
****
- In the list of choices, click New Table. The Create Table window opens, with default values for a new table, which has only one row.
- For Schema, accept the default value, HR.
- For Name, enter PERFORMANCE_PARTS.
  - For PK (primary key), accept the default option, deselected.
  - For Column Name, enter PERFORMANCE_ID.
  - For Type, accept the default value, VARCHAR2.
  - For Size, enter 2.
  - For Not Null, accept the default option, deselected.
****
- Click Add Column.
- For Column Name, enter NAME.
- For Type, accept the default value, VARCHAR2.
- For Size, enter 80.
****
- Click Add Column.
- For Column Name, enter WEIGHT.
- For Type, select NUMBER from the menu.
**** ****
- Click OK. The table PERFORMANCE_PARTS is created. Its name appears under Tables in the Connections frame. To see the CREATE TABLE statement for creating this table, select PERFORMANCE_PARTS and click the tab SQL.
**See Also:**   *Oracle SQL Developer User’s Guide* for more information about using SQL Developer to create tables
### Creating Tables with the CREATE TABLE Statement
This section shows how to use the CREATE TABLE statement to create the EVALUATIONS and SCORES tables.
The CREATE TABLE statement in Example 4-1 creates the EVALUATIONS table.
The CREATE TABLE statement in Example 4-2 creates the SCORES table.
In SQL Developer, in the Connections frame, if you expand Tables, you can see the tables EVALUATIONS and SCORES.
**Example 4-1 Creating the EVALUATIONS Table with CREATE TABLE**
```
CREATE TABLE EVALUATIONS (
  EVALUATION_ID    NUMBER(8,0),
  EMPLOYEE_ID      NUMBER(6,0),
  EVALUATION_DATE  DATE,
  JOB_ID           VARCHAR2(10),
  MANAGER_ID       NUMBER(6,0),
  DEPARTMENT_ID    NUMBER(4,0),
  TOTAL_SCORE      NUMBER(3,0)
);
```
Result:
```
Table created.
```
**Example 4-2 Creating the SCORES Table with CREATE TABLE**
```
CREATE TABLE SCORES (
  EVALUATION_ID   NUMBER(8,0),
  PERFORMANCE_ID  VARCHAR2(2),
  SCORE           NUMBER(1,0)
);
```
Result:
```
Table created.
```
**See Also:**   *Oracle Database SQL Language Reference* for information about the CREATE TABLE statement
## Ensuring Data Integrity in Tables
To ensure that the data in your tables satisfies the business rules that your application models, you can use constraints, application logic, or both.
**Tip:**    Wherever possible, use constraints instead of application logic. Oracle Database checks that all data obeys constraints much faster than application logic can.
**See Also:** **
- Oracle Database Concepts for additional general information about data integrity
**
- Oracle Database SQL Language Reference for syntactic information about constraints
**
- Oracle Database Development Guide for information about enabling and disabling constraints
### About Constraints
**Constraints** restrict the values that columns can have. Trying to change the data in a way that violates a constraint causes an error and rolls back the change. Trying to add a constraint to a populated table causes an error if existing data violates the constraint.
Constraints can be enabled and disabled. By default, they are created in the enabled state.
The following types of constraints are available:
****
- Not Null, which prevents a value from being null In the EMPLOYEES table, the column LAST_NAME has the NOT NULL constraint, which enforces the business rule that every employee must have a last name.
****
- Unique, which prevents multiple rows from having the same value in the same column or combination of columns, but allows some values to be null In the EMPLOYEES table, the column EMAIL has the UNIQUE constraint, which enforces the business rule that an employee can have no email address, but cannot have the same email address as another employee.
- Primary Key, which is a combination of NOT NULL and UNIQUE In the EMPLOYEES table, the column EMPLOYEE_ID has the PRIMARY KEY constraint, which enforces the business rule that every employee must have a unique employee identification number.
****
- Foreign Key, which requires values in one table to match values in another table In the EMPLOYEES table, the column JOB_ID has a FOREIGN KEY constraint that references the JOBS table, which enforces the business rule that an employee cannot have a JOB_ID that is not in the JOBS table.
**** ****
- Check, which requires that a value satisfy a specified condition The EMPLOYEES table does not have CHECK constraints. However, suppose that EMPLOYEES needs a new column, EMPLOYEE_AGE, and that every employee must be at least 18. The constraint CHECK (EMPLOYEE_AGE >= 18) enforces the business rule. Tip: Use check constraints only when other constraint types cannot provide the necessary checking.
**
- REF, which further describes the relationship between a REF column and the object that it references A REF column references an object in another object type or in a relational table. For information about REF constraints, see Oracle Database Concepts.
**See Also:** **- Oracle Database SQL Language Reference for syntactic information about constraints
### Tutorial: Adding Constraints to Existing Tables
This tutorial shows how to add constraints to existing tables using both SQL Developer tools and the ALTER TABLE statement.
To add constraints to existing tables, use either SQL Developer tools or the DDL statement ALTER TABLE. This topic shows how to use both of these ways to add constraints to the tables created in “Creating Tables”.
This tutorial has several procedures. The first procedure uses the Edit Table tool to add a Not Null constraint to the `NAMES` column of the `PERFORMANCE_PARTS` table. The remaining procedures show how to use other tools to add constraints; however, you could add the same constraints using the Edit Table tool.
**Note:** After any step of the tutorial, you can view the constraints that a table has by completing the following steps:
- In the Connections frame, select the name of the table.
****
- In the right frame, click the tab Constraints.
For more information about viewing table properties and data, see “Tutorial: Viewing EMPLOYEES Table Properties and Data with SQL Developer”.
**Steps to add a Not Null constraint using the Edit Table tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, right-click PERFORMANCE_PARTS.
****
- In the list of choices, click Edit.
****
- In the Edit Table window, click the column NAME.
****
- Select the property Not Null.
****
````
- Click OK. The Not Null constraint is added to the NAME column of the PERFORMANCE_PARTS table.
The following procedure uses the ALTER TABLE statement to add a Not Null constraint to the `WEIGHT` column of the `PERFORMANCE_PARTS` table.
**Steps to add a Not Null constraint using the ALTER TABLE statement:**
********
- If a pane with the tab hr_conn is there, select it. Otherwise, click the icon SQL Worksheet, as in “Running Queries in SQL Developer”.
```
ALTER TABLE PERFORMANCE_PARTS MODIFY WEIGHT NOT NULL;
```
- In the Worksheet pane, type this statement:
****
````
- Click the icon Run Statement. The statement runs, adding the Not Null constraint to the WEIGHT column of the PERFORMANCE_PARTS table.
The following procedure uses the Add Unique tool to add a Unique constraint to the `SCORES` table.
**Steps to add a Unique constraint using the Add Unique tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, right-click SCORES.
****
- In the list of choices, select Constraint.
****
- In the list of choices, click Add Unique.
  - For Constraint Name, enter SCORES_EVAL_PERF_UNIQUE.
****
  - For Column 1, select EVALUATION_ID from the menu.
****
  - For Column 2, select PERFORMANCE_ID from the menu.
****
  - Click Apply.
****
````
- In the Confirmation window, click OK. A unique constraint named SCORES_EVAL_PERF_UNIQUE is added to the SCORES table.
The following procedure uses the Add Primary Key tool to add a Primary Key constraint to the `PERFORMANCE_ID` column of the `PERFORMANCE_PARTS` table.
**Steps to add a Primary Key constraint using the Add Primary Key tool:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, right-click PERFORMANCE_PARTS.
****
- In the list of choices, select Constraint.
****
- In the list of choices, click Add Primary Key.
  - For Primary Key Name, enter PERF_PERF_ID_PK.
****
  - For Column 1, select PERFORMANCE_ID from the menu.
****
  - Click Apply.
****
``````
- In the Confirmation window, click OK. A primary key constraint named PERF_PERF_ID_PK is added to the PERFORMANCE_ID column of the PERFORMANCE_PARTS table.
The following procedure uses the ALTER TABLE statement to add a Primary Key constraint to the `EVALUATION_ID` column of the `EVALUATIONS` table.
**Steps to add a Primary Key constraint using the ALTER TABLE statement:** ********
- If a pane with the tab hr_conn is there, select it. Otherwise, click the icon SQL Worksheet, as in “Running Queries in SQL Developer”.
```
 ALTER TABLE EVALUATIONS
 ADD CONSTRAINT EVAL_EVAL_ID_PK PRIMARY KEY (EVALUATION_ID);
```
- In the Worksheet pane, type this statement:
****
````
- Click the icon Run Statement. The statement runs, adding the Primary Key constraint to the EVALUATION_ID column of the EVALUATIONS table.
The following procedure uses the Add Foreign Key tool to add two Foreign Key constraints to the `SCORES` table.
**Steps to add two Foreign Key constraints using the Add Foreign Key tool:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, right-click SCORES.
****
- In the list of choices, select Constraint.
****
- In the list of choices, click Add Foreign Key.
  - For Constraint Name, enter SCORES_EVAL_FK.
****
  - For Column Name, select EVALUATION_ID from the menu.
****
  - For References Table Name, select EVALUATIONS from the menu.
****
  - For Referencing Column, select EVALUATION_ID from the menu.
****
  - Click Apply.
****
``````````
- In the Confirmation window, click OK. A foreign key constraint named SCORES_EVAL_FK is added to the EVALUTION_ID column of the SCORES table, referencing the EVALUTION_ID column of the EVALUATIONS table. The following steps add another foreign key constraint to the SCORES table.
****
- In the list of tables, right-click SCORES.
****
- In the list of tables, select Constraint.
****
- In the list of choices, click Add Foreign Key. The Add Foreign Key window opens.
  - For Constraint Name, enter SCORES_PERF_FK.
****
  - For Column Name, select PERFORMANCE_ID from the menu.
****
  - For Reference Table Name, select PERFORMANCE_PARTS from the menu.
****
  - For Referencing Column, select PERFORMANCE_ID from the menu.
****
  - Click Apply.
****
``````````
- In the Confirmation window, click OK. A foreign key constraint named SCORES_PERF_FK is added to the EVALUTION_ID column of the SCORES table, referencing the EVALUTION_ID column of the EVALUATIONS table.
The following procedure uses the ALTER TABLE statement to add a Foreign Key constraint to the `EMPLOYEE_ID` column of the `EVALUATIONS` table, referencing the `EMPLOYEE_ID` column of the `EMPLOYEES` table.
**Steps to add a Foreign Key constraint using the ALTER TABLE statement:**
********
- If a pane with the tab hr_conn is there, select it. Otherwise, click the icon SQL Worksheet, as in “Running Queries in SQL Developer”.
```
ALTER TABLE EVALUATIONS ADD CONSTRAINT EVAL_EMP_ID_FK FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES (EMPLOYEE_ID);
```
- In the Worksheet pane, type this statement:
****
````````
- Click the icon Run Statement. The statement runs, adding the Foreign Key constraint to the EMPLOYEE_ID column of the EVALUATIONS table, referencing the EMPLOYEE_ID column of the EMPLOYEES table.
The following procedure uses the Add Check tool to add a Check constraint to the `SCORES` table.
**Steps to add a Check constraint using the Add Check tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, right-click SCORES.
****
- In the list of choices, select Constraint.
****
- In the list of choices, click Add Check.
  - For Constraint Name, enter SCORE_VALID.
  - For Check Condition, enter score >= 0 and score <+ 9.
  - For Status, accept the default, ENABLE.
****
  - Click Apply.
****
````
- In the Confirmation window, click OK. A Check constraint named SCORE_VALID is added to the SCORES table.
**See Also:**
**
- Oracle Database SQL Language Reference for more information about the ALTER TABLE statement
**
- Oracle SQL Developer User’s Guide for information about adding constraints to a table when you create it with SQL Developer
**
- Oracle Database SQL Language Reference for information about adding constraints to a table when you create it with the CREATE TABLE statement
## Tutorial: Adding Rows to Tables with the Insert Row Tool
This tutorial shows how to use the Insert Row tool to add six populated rows to the PERFORMANCE_PARTS table.
**Steps to add rows to the PERFORMANCE_PARTS table using the Insert Row tool:**
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, select PERFORMANCE_PARTS.
****
- In the right frame, click the tab Data. The Data pane appears, showing the names of the columns of the PERFORMANCE_PARTS table and no rows.
****
- In the Data pane, click the icon Insert Row. A new row appears, with empty columns. A green border around the row number indicates that the insertion has not been committed.
- Click the cell under the column heading PERFORMANCE_ID.
- Type the value of PERFORMANCE_ID: WM
********
- Either press the key Tab or click the cell under the column heading NAME.
- Type the value of NAME: Workload Management
****
- Either press the key Tab or click the cell under the column heading WEIGHT.
- Type the value of WEIGHT: 0.2
****
- Press the key Enter.
  - For PERFORMANCE_ID, type BR.
  - For NAME, type Building Relationships.
  - For WEIGHT, type 0.2.
  - For PERFORMANCE_ID, type CF.
  - For NAME, type Customer Focus.
  - For WEIGHT, type 0.2.
  - For PERFORMANCE_ID, type CM.
  - For NAME, type Communication.
  - For WEIGHT, type 0.2.
  - For PERFORMANCE_ID, type TW.
  - For NAME, type Teamwork.
  - For WEIGHT, type 0.2.
  - For PERFORMANCE_ID, type RO.
  - For NAME, type Results Orientation.
  - For WEIGHT, type 0.2.
****
- Click the Commit Changes icon. The green borders around the row numbers disappear. Under the Data pane is the label Messages - Log.
- Check the Messages - Log pane for the message Commit Successful.
- In the Data Pane, check the new rows.
**See Also:**   “About the INSERT Statement”
## Tutorial: Changing Data in Tables in the Data Pane
This tutorial shows how to change three of the WEIGHT values in the PERFORMANCE_PARTS table in the Data pane.
The PERFORMANCE_PARTS table was populated in “Tutorial: Adding Rows to Tables with the Insert Row Tool”.
**Steps to change data in the PERFORMANCE_PARTS table using the Data pane:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, select PERFORMANCE_PARTS.
****
- In the right frame, click the tab Data.
****
  - Click the WEIGHT value.
  - Enter the value 0.3.
****
  - Press the key Enter. An asterisk appears to the left of the row number to indicate that the change has not been committed.
****
****
  - Click the WEIGHT value.
  - Enter the value 0.15.
****
  - Press the key Enter. An asterisk appears to the left of the row number to indicate that the change has not been committed.
****
****
  - Click the WEIGHT value.
  - Enter the value 0.15.
****
  - Press the key Enter. An asterisk appears to the left of the row number to indicate that the change has not been committed.
****
- Click the icon Commit Changes. The asterisks to the left of the row numbers disappear.
- Under the Data pane, check the Messages - Log pane for the message Commit Successful.
- In the Data Pane, check the new data.
**See Also:**   “About the UPDATE Statement”
## Tutorial: Deleting Rows from Tables with the Delete Selected Row(s) Tool
This tutorial shows how to use the Delete Selected Row(s) tool to delete a row from the PERFORMANCE_PARTS table.
The PERFORMANCE_PARTS table was populated in “Tutorial: Adding Rows to Tables with the Insert Row Tool”.
**Steps to delete row from PERFORMANCE_PARTS using Delete Selected Rows tool:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, select PERFORMANCE_PARTS.
****
- In the right frame, click the tab Data.
- In the Data pane, click the row where NAME is “Results Orientation”.
****
- Click the Delete Selected Rows icon. A red border appears around the row number to indicate that the deletion has not been committed.
****
- Click the Commit Changes icon. The row is deleted.
- Under the Data pane, check the Messages - Log pane for the message Commit Successful.
**Note:**   If you delete every row of a table, the empty table still exists. To delete a table, see “Dropping Tables”.
**See Also:**   “About the DELETE Statement”
## Managing Indexes
You can create indexes on one or more columns of a table to speed SQL statement execution on that table. When properly used, indexes are the primary means of reducing disk input/output (I/O).
When you define a primary key on a table:
- If an existing index starts with the primary key columns, then Oracle Database uses that existing index for the primary key. The existing index need not be Unique. For example, if you define the primary key (A, B), Oracle Database uses the existing index (A, B, C).
- If no existing index starts with the primary key columns and the constraint is immediate, then Oracle Database creates a Unique index on the primary key.
- If no existing index starts with the primary key columns and the constraint is deferrable, then Oracle Database creates a non-Unique index on the primary key.
For example, in “Tutorial: Adding Constraints to Existing Tables”, you added a Primary Key constraint to the EVALUATION_ID column of the EVALUATIONS table. Therefore, if you select the EVALUATIONS table in the SQL Developer Connections frame and click the Indexes tab, the Indexes pane shows a Unique index on the EVALUATION_ID column.
**See Also:**
For more information about indexes:
**
- Oracle Database Concepts
**
- Oracle Database Development Guide
### Tutorial: Adding an Index with the Create Index Tool
This tutorial shows how to use the Create Index tool to add an index to the EVALUATIONS table.
The EVALUATIONS table was created in Example 4-1.
To create an index, use either the SQL Developer tool Create Index or the DDL statement CREATE INDEX. The equivalent DDL statement is:
```
CREATE INDEX EVAL_JOB_IX ON EVALUATIONS (JOB_ID ASC) NOPARALLEL;
```
**Steps to add an index to the EVALUATIONS table using the Create Index tool:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
****
- In the list of tables, right-click EVALUATIONS.
****
- In the list of choices, select Index.
****
- In the list of choices, select Create Index.
  - For Schema, accept the default, HR.
  - For Name, type EVAL_JOB_IX.
****
  - If the Definition pane does not show, select the tab Definition.
****
  - In the Definition pane, for Index Type, select Unique from the menu.
****
  - Click the icon Add Expression. The Expression EMPLOYEE_ID with Order  appears.
  - Over EMPLOYEE_ID, type JOB_ID.
****
  - For Order, select ASC (ascending) from the menu.
****
  - Click OK. Now the EVALUATIONS table has an index named EVAL_JOB_IX on the column JOB_ID.
**See Also:**   *Oracle Database SQL Language Reference* for information about the CREATE INDEXstatement
### Tutorial: Changing an Index with the Edit Index Tool
This tutorial shows how to use the Edit Index tool to reverse the sort order of the index EVAL_JOB_IX.
To change an index, use either the SQL Developer tool Edit Index or the DDL statements DROP INDEX and CREATE INDEX.
The equivalent DDL statements are:
```
DROP INDEX EVAL_JOB_ID;
CREATE INDEX EVAL_JOB_IX ON EVALUATIONS (JOB_ID DESC) NOPARALLEL;
```
**Steps to reverse the sort order of the index EVAL_JOB_IX using the Edit Index tool:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Indexes.
****
- In the list of indexes, right-click EVAL_JOB_IX.
****
- In the list of choices, click Edit.
****
- In the Edit Index window, change Order to DESC.
****
- Click OK.
********
- In the Confirm Replace window, click either Yes or No.
**See Also:**   *Oracle Database SQL Language Reference* for information about the ALTER INDEX statement
### Tutorial: Dropping an Index
This tutorial shows how to use the Connections frame and Drop tool to drop the index EVAL_JOB_IX.
To drop an index, use either the SQL Developer Connections frame and Drop tool or the DDL statement DROP INDEX. The equivalent DDL statement is:
```
DROP INDEX EVAL_JOB_ID;
```
**To drop the index EVAL_JOB_IX:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Indexes.
****
- In the list of indexes, right-click EVAL_JOB_IX.
****
- In the list of choices, click Drop.
****
- In the Drop window, click Apply.
****
- In the Confirmation window, click OK.
**See Also:**   *Oracle Database SQL Language Reference* for information about the DROP INDEX statement
## Dropping Tables
To drop a table, use either the SQL Developer Connections frame and Drop tool, or the DDL statement DROP TABLE.
**Caution:**   Do not drop any tables that you created in “Creating Tables”—you need them for later tutorials. If you want to practice dropping tables, create simple ones and then drop them.
**Steps to drop a table using the Drop tool:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
- In the list of tables, right-click the name of the table to drop.
****
- In the list of choices, select Table.
****
- In the list of choices, click Drop.
****
- In the Drop window, click Apply.
****
- In the Confirmation window, click OK.
**See Also:**   *Oracle Database SQL Language Reference* for information about the statement DROP TABLE
