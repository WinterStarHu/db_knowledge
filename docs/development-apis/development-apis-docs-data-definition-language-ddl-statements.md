# About Data Definition Language (DDL) Statements

**Data definition language (DDL) statements** create, change, and drop schema objects. Before and after a DDL statement, Oracle Database issues an implicit COMMIT statement; therefore, you cannot roll back a DDL statement.
**Note:**   When creating schema objects, you must observe the schema object naming rules in *Oracle Database SQL Language Reference*.
In the SQL*Plus environment, you can enter a DDL statement after the SQL> prompt.
In the SQL Developer environment, you can enter a DDL statement in the Worksheet. Alternatively, you can use SQL Developer tools to create, change, and drop objects.
Some DDL statements that create schema objects have an optional OR REPLACE clause, which allows a statement to replace an existing schema object with another that has the same name and type. When SQL Developer generates code for one of these statements, it always includes the OR REPLACE clause.
To see the effect of a DDL statement in SQL Developer, you might have to select the schema object type of the newly created object in the Connections frame and then click the **Refresh** icon.
**See Also:** **
- Oracle Database SQL Language Reference for more information about DDL statements
- “Committing Transactions”
