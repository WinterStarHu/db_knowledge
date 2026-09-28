# About Installation Scripts

An **installation script** can either have all the SQL statements needed to create the application or it can be a **master script** that runs other scripts.
A **script** is a series of SQL statements in a file whose name ends with `.sql` (for example, create_app.sql). When you run a script in a client program such as SQL*Plus or SQL Developer, the SQL statements run in the order in which they appear in the script. A script whose SQL statements create an application is called an **installation script**.
To deploy an application, you run one or more installation scripts in the deployment environment. For a new application, you must create the installation scripts. For an older application, the installation scripts might exist, but if they do not, you can create them.
## About DDL Statements and Schema Object Dependencies
An installation script contains DDL statements that create schema objects and, optionally, INSERT statements that load data into tables that DDL statements create. To create installation scripts correctly, and to run multiple installation scripts in the correct order, you must understand the dependencies between the schema objects of your application.
If the definition of object A references object B, then A depends on B. Therefore, you must create B before you create A. Otherwise, the statement that creates B either fails or creates B in an invalid state, depending on the object type.
For a complex application, the order for creating the objects is rarely obvious. Usually, you must consult the database designer or a diagram of the design.
**See Also:** **
- Oracle Database Development Guide for more information about schema object dependencies
- “About Data Definition Language (DDL) Statements”
## About INSERT Statements and Constraints
When you run an installation script that contains INSERT statements, you must determine whether constraints could be violated when data from source tables (in the development environment) is inserted into new tables in the deployment environment.
For each source table in your application, you must determine whether any constraints could be violated when their data is inserted in the new table. If so, you must first disable those constraints, then insert the data, and then try to re-enable the constraints. If a data item violates a constraint, then you cannot re-enable that constraint until you correct the data item.
If you are simply inserting lookup data in correct order (as in “Loading the Data”), then constraints are not violated. Therefore, you do not need to disable them first.
If you are inserting data from an outside source (such as a file, spreadsheet, or older application), or from many tables that have much dependent data, disable the constraints before inserting the data.
You can disable and re-enable the constraints in the following ways:
  - In the Connections frame, select the appropriate table.
****
  - In the pane labeled with table name, select the subtab Constraints.
````
  - In the list of all constraints on the table, change ENABLED to DISABLED (or the reverse).
- Edit the installation script, adding SQL statements that disable and re-enable each constraint.
- Create a SQL script with SQL statements that disable and enable each constraint.
```
SELECT 'ALTER TABLE '|| TABLE_NAME || ' DISABLE CONSTRAINT '|| CONSTRAINT_NAME ||';' FROM user_constraints WHERE table_name IN ('EVALUATIONS','PERFORMANCE_PARTS','SCORES');
SELECT 'ALTER TABLE '|| TABLE_NAME || ' ENABLE CONSTRAINT '|| CONSTRAINT_NAME ||';' FROM user_constraints WHERE table_name IN ('EVALUATIONS','PERFORMANCE_PARTS','SCORES');
```
****
  - “About the INSERT Statement”
  - “Ensuring Data Integrity in Tables”
