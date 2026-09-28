# MERGE

## Purpose
Use the `MERGE` statement to select rows from one or more sources for update or insertion into a table or view. You can specify conditions to determine whether to update or insert into the target table or view.
This statement is a convenient way to combine multiple operations. It lets you avoid multiple `INSERT`, `UPDATE`, and `DELETE` DML statements.
`MERGE` is a deterministic statement. You cannot update the same row of the target table multiple times in the same `MERGE` statement.
**Note:**   In previous releases of Oracle Database, when you created an Oracle Virtual Private Database policy on an application that included the `MERGE` `INTO` statement, the `MERGE` `INTO` statement would be prevented with an `ORA-28132: Merge into syntax does not support security policies` error, due to the presence of the Virtual Private Database policy. Beginning with Oracle Database 11*g* Release 2 (
11.2.0.2), you can create policies on applications that include `MERGE` `INTO` operations. To do so, in the `DBMS_RLS`.`ADD_POLICY` `statement_types` parameter, include the `INSERT`, `UPDATE`, and `DELETE` statements, or just omit the `statement_types` parameter altogether. Refer to *Oracle Database Security Guide* for more information on enforcing policies on specific SQL statement types.
## Prerequisites
You must have the `INSERT` and `UPDATE` object privileges on the target table and the `SELECT` object privilege on the source objects. To specify the `DELETE` clause of the *merge_update_clause*, you must also have the `DELETE` object privilege on the target table or view.
## Syntax
## *merge*::=
Description of the illustration merge.eps **Note:**   You must specify at least one of the clauses *merge_update_clause* or *merge_insert_clause*.
(*merge_update_clause::=*, *merge_insert_clause::=*, *error_logging_clause::=*
## *merge_update_clause*::=
Description of the illustration merge_update_clause.eps
## *merge_insert_clause*::=
Description of the illustration merge_insert_clause.eps
## *where_clause*::=
Description of the illustration where_clause.eps
## *error_logging_clause*::=
Description of the illustration error_logging_clause.eps
## Semantics
## INTO Clause
Use the `INTO` clause to specify the target table or view you are updating or inserting into. In order to merge data into a view, the view must be updatable. Refer to “Notes on Updatable Views” for more information.
**Restriction on Target Views** You cannot specify a target view on which an `INSTEAD` `OF` trigger has been defined.
## USING Clause
Use the `USING` clause to specify the source you are updating or inserting from.
## ON Clause
Use the `ON` clause to specify the condition upon which the `MERGE` operation either updates or inserts. For each row in the target table for which the search condition is true, Oracle Database updates the row with corresponding data from the source . If the condition is not true for any rows, then the database inserts into the target table based on the corresponding source row.
## *merge_update_clause*
The *merge_update_clause* specifies the new column values of the target table or view. Oracle performs this update if the condition of the `ON` clause is true. If the update clause is executed, then all update triggers defined on the target table are activated.
Specify the *where_clause* if you want the database to execute the update operation only if the specified condition is true. The condition can refer to either the data source or the target table. If the condition is not true, then the database skips the update operation when merging the row into the table.
Specify the `DELETE` *where_clause* to clean up data in a table while populating or updating it. The only rows affected by this clause are those rows in the destination table that are updated by the merge operation. The `DELETE` `WHERE` condition evaluates the updated value, not the original value that was evaluated by the `UPDATE` `SET` … `WHERE` condition. If a row of the destination table meets the `DELETE` condition but is not included in the join defined by the `ON` clause, then it is not deleted. Any delete triggers defined on the target table will be activated for each row deletion.
You can specify this clause by itself or with the *merge_insert_clause*. If you specify both, then they can be in either order.
**Restrictions on the** ***merge_update_clause*** This clause is subject to the following restrictions:
**
- You cannot update a column that is referenced in the ON condition clause.
- You cannot specify DEFAULT when updating a view.
## *merge_insert_clause*
The *merge_insert_clause* specifies values to insert into the column of the target table if the condition of the `ON` clause is false. If the insert clause is executed, then all insert triggers defined on the target table are activated. If you omit the column list after the `INSERT` keyword, then the number of columns in the target table must match the number of values in the `VALUES` clause.
To insert all of the source rows into the table, you can use a **constant filter predicate** in the `ON` clause condition. An example of a constant filter predicate is `ON` (`0=1`). Oracle Database recognizes such a predicate and makes an unconditional insert of all source rows into the table. This approach is different from omitting the *merge_update_clause*. In that case, the database still must perform a join. With constant filter predicate, no join is performed.
Specify the *where_clause* if you want Oracle Database to execute the insert operation only if the specified condition is true. The condition can refer only to the data source columns. Oracle Database skips the insert operation for all rows for which the condition is not true.
You can specify the *merge_insert_clause* by itself or with the *merge_update_clause*. If you specify both, then they can be in either order.
**Restriction on the** ***merge_insert_clause*** You cannot specify `DEFAULT` when inserting into a view.
## *error_logging_clause*
The *error_logging_clause* has the same behavior in a `MERGE` statement as in an `INSERT` statement. Refer to the `INSERT` statement *error_logging_clause* for more information.
**See Also:**   “Inserting Into a Table with Error Logging: Example”
## Examples
**Merging into a Table: Example** The following example uses the `bonuses` table in the sample schema `oe` with a default bonus of 100. It then inserts into the `bonuses` table all employees who made sales, based on the `sales_rep_id` column of the `oe.orders` table. Finally, the human resources manager decides that employees with a salary of $8000 or less should receive a bonus. Those who have not made sales get a bonus of 1% of their salary. Those who already made sales get an increase in their bonus equal to 1% of their salary. The `MERGE` statement implements these changes in one step:
```
CREATE TABLE bonuses (employee_id NUMBER, bonus NUMBER DEFAULT 100);
INSERT INTO bonuses(employee_id)
   (SELECT e.employee_id FROM hr.employees e, oe.orders o
   WHERE e.employee_id = o.sales_rep_id
   GROUP BY e.employee_id);
SELECT * FROM bonuses ORDER BY employee_id;
EMPLOYEE_ID      BONUS
----------- ----------
        153        100
        154        100
        155        100
        156        100
        158        100
        159        100
        160        100
        161        100
        163        100
MERGE INTO bonuses D
   USING (SELECT employee_id, salary, department_id FROM hr.employees
   WHERE department_id = 80) S
   ON (D.employee_id = S.employee_id)
   WHEN MATCHED THEN UPDATE SET D.bonus = D.bonus + S.salary*.01
     DELETE WHERE (S.salary > 8000)
   WHEN NOT MATCHED THEN INSERT (D.employee_id, D.bonus)
     VALUES (S.employee_id, S.salary*.01)
     WHERE (S.salary <= 8000);
SELECT * FROM bonuses ORDER BY employee_id;
EMPLOYEE_ID      BONUS
----------- ----------
        153        180
        154        175
        155        170
        159        180
        160        175
        161        170
        164         72
        165         68
        166         64
        167         62
        171         74
        172         73
        173         61
        179         62
```
**Conditional Insert and Update: Example** The following example conditionally inserts and updates table data by using the `MERGE` statement.
The following statements create two tables named `people_source` and `people_target` and populate them with names:
```
CREATE TABLE people_source (
  person_id  INTEGER NOT NULL PRIMARY KEY,
  first_name VARCHAR2(20) NOT NULL,
  last_name  VARCHAR2(20) NOT NULL,
  title      VARCHAR2(10) NOT NULL
);
CREATE TABLE people_target (
  person_id  INTEGER NOT NULL PRIMARY KEY,
  first_name VARCHAR2(20) NOT NULL,
  last_name  VARCHAR2(20) NOT NULL,
  title      VARCHAR2(10) NOT NULL
);
INSERT INTO people_target VALUES (1, 'John', 'Smith', 'Mr');
INSERT INTO people_target VALUES (2, 'alice', 'jones', 'Mrs');
INSERT INTO people_source VALUES (2, 'Alice', 'Jones', 'Mrs.');
INSERT INTO people_source VALUES (3, 'Jane', 'Doe', 'Miss');
INSERT INTO people_source VALUES (4, 'Dave', 'Brown', 'Mr');
COMMIT;
```
The following statement compares the contents of `people_target` and `people_source` by using the `person_id` column. The values in the `people_target` table are updated when there is a match in the `people_source` table:
```
MERGE INTO people_target pt
USING people_source ps
ON    (pt.person_id = ps.person_id)
WHEN MATCHED THEN UPDATE
  SET pt.first_name = ps.first_name,
      pt.last_name = ps.last_name,
      pt.title = ps.title;
```
The following statements display the contents of the `people_target` table and perform a rollback:
```
SELECT * FROM people_target;
PERSON_ID FIRST_NAME		LAST_NAME	     TITLE
---------- -------------------- -------------------- ----------
	 1 John 		Smith		     Mr
	 2 Alice		Jones		     Mrs.
ROLLBACK;
```
This statement compares the contents of the `people_target` and `people_source` tables by using the `person_id` column. The values in the `people_target` table are updated only when there is no match in the `people_source` table:
```
MERGE INTO people_target pt
USING people_source ps
ON    (pt.person_id = ps.person_id)
WHEN NOT MATCHED THEN INSERT
  (pt.person_id, pt.first_name, pt.last_name, pt.title)
  VALUES (ps.person_id, ps.first_name, ps.last_name, ps.title);
```
The following statements display the contents of the `people_target` table and perform a rollback:
```
SELECT * FROM people_target;
PERSON_ID FIRST_NAME		LAST_NAME	     TITLE
---------- -------------------- -------------------- ----------
	 1 John 		Smith		     Mr
	 2 alice		jones		     Mrs
	 3 Jane 		Doe		     Miss
	 4 Dave 		Brown		     Mr
ROLLBACK;
```
The following statement compares the contents of the `people_target` and `people_source` tables by using the `person_id` column and conditionally inserts and updates data in the `people_target` table. For each matching row in the `people_source` table, the values in the `people_target` table are updated by using the values from the `people_source` table. Any unmatched rows from the `people_source` table are added to the `people_target` table:
```
MERGE INTO people_target pt
USING people_source ps
ON    (pt.person_id = ps.person_id)
WHEN MATCHED THEN UPDATE
  SET pt.first_name = ps.first_name,
      pt.last_name = ps.last_name,
      pt.title = ps.title
WHEN NOT MATCHED THEN INSERT
  (pt.person_id, pt.first_name, pt.last_name, pt.title)
  VALUES (ps.person_id, ps.first_name, ps.last_name, ps.title);
```
The following statements display the contents of the `people_target` table and perform a rollback:
```
SELECT * FROM people_target;
PERSON_ID FIRST_NAME	 LAST_NAME	     TITLE
---------- -------------   ------------------ ----------
	 1 John 		Smith		     Mr
	 2 Alice		Jones		     Mrs.
	 3 Jane 		Doe		       Miss
	 4 Dave 		Brown		     Mr
ROLLBACK;
```
The following statement compares the `people_target` and `people_source` tables by using the `person_id` column. When the `person_id` matches, the corresponding rows in the `people_target` table are updated by using values from the `people_source` table. The `DELETE` clause removes all the values in `people_target` where `title` is ‘Mrs.’. When the `person_id` does not match, the rows from the `people_source` table are added to the `people_target` table. The `WHERE` clause ensures that only values that have `title` as ‘Mr’ are added to the `people_target` table:
```
MERGE INTO people_target pt
USING people_source ps
ON    (pt.person_id = ps.person_id)
WHEN MATCHED THEN UPDATE
  SET pt.first_name = ps.first_name,
      pt.last_name = ps.last_name,
      pt.title = ps.title
  DELETE where pt.title  = 'Mrs.'
WHEN NOT MATCHED THEN INSERT
  (pt.person_id, pt.first_name, pt.last_name, pt.title)
  VALUES (ps.person_id, ps.first_name, ps.last_name, ps.title)
  WHERE ps.title = 'Mr';
```
The following statements display the contents of the `people_target` table and perform a rollback:
```
SELECT * FROM people_target;
PERSON_ID FIRST_NAME		LAST_NAME	     TITLE
---------- -------------------- -------------------- ----------
	 1 John 		Smith		     Mr
	 4 Dave 		Brown		     Mr
ROLLBACK;
```
## Dealing with Inputs from an Application
Usually applications have to check for the existence of a row first in order to decide whether to `INSERT` a new row, or `UPDATE` an already existing one. The `MERGE` statement eliminates the need for such a check by allowing the use of bind variables inside the `USING` statement as a source.
The following statements demonstrate the use of bind variables to insert a new row into the `people_target` table:
```
var person_id  NUMBER;
var first_name VARCHAR2(20);
var last_name  VARCHAR2(20);
var title      VARCHAR2(10);
exec :person_id := 3;
exec :first_name := 'Gerald';
exec :last_name := 'Walker';
exec :title := 'Mr';
MERGE INTO people_target pt
   USING (SELECT :person_id  AS person_id,
                 :first_name AS first_name,
                 :last_name  AS last_name,
                 :title      AS title FROM DUAL) ps
   ON (pt.person_id = ps.person_id)
WHEN MATCHED THEN UPDATE
SET pt.first_name = ps.first_name,
    pt.last_name = ps.last_name,
    pt.title = ps.title
WHEN NOT MATCHED THEN INSERT
    (pt.person_id, pt.first_name, pt.last_name, pt.title)
    VALUES (ps.person_id, ps.first_name, ps.last_name, ps.title);
```
The following statements display the contents of the `people_target` table and perform a rollback:
```
SELECT * FROM people_target;
 PERSON_ID FIRST_NAME		LAST_NAME	     TITLE
---------- -------------------- -------------------- ----------
	 1   John                Smith		     Mr
	 2   alice               jones		     Mrs
	 3   Gerald              Walker		     Mr
ROLLBACK;
```
The following statements demonstrate the use of bind variables to update an already existing row in the `people_target`. Note that the `MERGE` statement is identical to the one just used to insert a new row:
```
var person_id  NUMBER;
var first_name VARCHAR2(20);
var last_name  VARCHAR2(20);
var title      VARCHAR2(10);
exec :person_id := 2;
exec :first_name := 'Alice';
exec :last_name := 'Jones';
exec :title := 'Mrs';
MERGE INTO people_target pt
   USING (SELECT :person_id  AS person_id,
                 :first_name AS first_name,
                 :last_name  AS last_name,
                 :title      AS title FROM DUAL) ps
   ON (pt.person_id = ps.person_id)
WHEN MATCHED THEN UPDATE
SET pt.first_name = ps.first_name,
    pt.last_name = ps.last_name,
    pt.title = ps.title
WHEN NOT MATCHED THEN INSERT
    (pt.person_id, pt.first_name, pt.last_name, pt.title)
    VALUES (ps.person_id, ps.first_name, ps.last_name, ps.title);
```
The following statements display the contents of the `people_target` table and perform a rollback:
```
SELECT * FROM people_target;
PERSON_ID FIRST_NAME		LAST_NAME	     TITLE
---------- -------------------- -------------------- ----------
	 1   John                 Smith		     Mr
	 2   Alice                Jones		     Mrs
ROLLBACK;
```
