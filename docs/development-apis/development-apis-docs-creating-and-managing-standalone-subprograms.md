# Creating and Managing Standalone Subprograms

You can create and manage standalone PL/SQL subprograms.
**Note:**   To do the tutorials in this document, you must be connected to Oracle Database as the user HR from SQL Developer.
## About Subprogram Structure
A subprogram follows PL/SQL block structure; that is, it has:
****
- Declarative part (optional) The declarative part contains declarations of types, constants, variables, exceptions, declared cursors, and nested subprograms. These items are local to the subprogram and cease to exist when the subprogram completes execution.
****
- Executable part (required) The executable part contains statements that assign values, control execution, and manipulate data.
****
- Exception-handling part (optional) The exception-handling part contains code that handles exceptions (runtime errors).
**Comments** can appear anywhere in PL/SQL code. The PL/SQL compiler ignores them. Adding comments to your program promotes readability and aids understanding. A **single-line comment** starts with a double hyphen (`--`) and extends to the end of the line. A **multiline comment** starts with a slash and asterisk (`/*`) and ends with an asterisk and a slash (`*/`).
The structure of a procedure is:
```
PROCEDURE name [ ( parameter_list ) ]
{ IS | AS }
  [ declarative_part ]
BEGIN  -- executable part begins
  statement; [ statement; ]...
[ EXCEPTION -- executable part ends, exception-handling part begins]
  exception_handler; [ exception_handler; ]... ]
END; /* exception-handling part ends if it exists;
        otherwise, executable part ends */
```
The structure of a function is like that of a procedure, except that it includes a `RETURN` clause and at least one `RETURN` statement (and some optional clauses that are beyond the scope of this document):
```
FUNCTION name [ ( parameter_list ) ] RETURN data_type [ clauses ]
{ IS | AS }
  [ declarative_part ]
BEGIN  -- executable part begins
  -- at least one statement must be a RETURN statement
  statement; [ statement; ]...
[ EXCEPTION -- executable part ends, exception-handling part begins]
  exception_handler; [ exception_handler; ]... ]
END; /* exception-handling part ends if it exists;
        otherwise, executable part ends */
```
The code that begins with PROCEDURE or FUNCTION and ends before IS or AS is the **subprogram signature**. The declarative, executable, and exception-handling parts comprise the **subprogram body**. The syntax of exception-handler is in “About Exceptions and Exception Handlers”.
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about subprogram parts
## Tutorial: Creating a Standalone Procedure
This tutorial shows how to use the Create Procedure tool to create a standalone procedure named ADD_EVALUATION that adds a row to the EVALUATIONS table.
The EVALUATIONS table was created in Example 4-1.
To create a standalone procedure, use either the SQL Developer tool Create Procedure or the DDL statement CREATE PROCEDURE.
**Steps to create a standalone procedure using Create Procedure tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Procedures.
****
- In the list of choices, click New Procedure. The Create Procedure window opens.
- For Schema, accept the default value, HR.
- For Name, change PROCEDURE1 to ADD_EVALUATION.
****
- Click the icon Add Parameter. A row appears under the column headings. Its fields have these default values: Name, PARAM1; Mode, IN; No Copy, deselected; Data Type, VARCHAR2; Default Value, empty.
- For Name, change PARAM1 to EVALUATION_ID.
- For Mode, accept the default value, IN.
****
- For Data Type, select NUMBER from the menu.
- Leave Default Value empty.
- Add a second parameter by repeating steps 6 through 10 with the Name EMPLOYEE_ID and the Data Type NUMBER.
- Add a third parameter by repeating steps 6 through 10 with the Name EVALUATION_DATE and the Data Type DATE.
- Add a fourth parameter by repeating steps 6 through 10 with the Name JOB_ID and the Data Type VARCHAR2.
- Add a fifth parameter by repeating steps 6 through 10 with the Name MANAGER_ID and the Data Type NUMBER.
- Add a sixth parameter by repeating steps 6 through 10 with the Name DEPARTMENT_ID and the Data Type NUMBER.
- Add a seventh parameter by repeating steps 6 through 10 with the Name TOTAL_SCORE and the Data Type NUMBER.
****
```
CREATE OR REPLACE PROCEDURE ADD_EVALUATION
(
  EVALUATION_ID IN NUMBER
, EMPLOYEE_ID IN NUMBER
, EVALUATION_DATE IN DATE
, JOB_ID IN VARCHAR2
, MANAGER_ID IN NUMBER
, DEPARTMENT_ID IN NUMBER
, TOTAL_SCORE IN NUMBER
) AS
BEGIN
  NULL;
END ADD_EVALUATION;
```
- Click OK. The title of the ADD_EVALUATION pane is in italic font, indicating that the procedure is not yet saved in the database. Because the execution part of the procedure contains only the NULL statement, the procedure does nothing.
```
INSERT INTO EVALUATIONS (
  evaluation_id,
  employee_id,
  evaluation_date,
  job_id,
  manager_id,
  department_id,
  total_score
)
VALUES (
  ADD_EVALUATION.evaluation_id,
  ADD_EVALUATION.employee_id,
  ADD_EVALUATION.evaluation_date,
  ADD_EVALUATION.job_id,
  ADD_EVALUATION.manager_id,
  ADD_EVALUATION.department_id,
  ADD_EVALUATION.total_score
);
```
- Replace the NULL statement with this statement: (Qualifying the parameter names with the procedure name ensures that they are not confused with the columns that have the same names.)
****
- From the File menu, select Save.
Oracle Database compiles the procedure and saves it. The title of the ADD_EVALUATION pane is no longer in italic font. The Message - Log pane has the message `Compiled`.
**See Also:** **
- Oracle SQL Developer User’s Guide for another example of using SQL Developer to create a standalone procedure
- “About Data Definition Language (DDL) Statements” for general information that applies to the CREATE PROCEDURE statement
**
- Oracle Database PL/SQL Language Reference for information about the CREATE PROCEDURE statement
## Tutorial: Creating a Standalone Function
This tutorial shows how to use the Create Function tool to create a standalone function named CALCULATE_SCORE that has three parameters and returns a value of type NUMBER.
To create a standalone function, use either the SQL Developer tool Create Function or the DDL statement CREATE FUNCTION.
**Steps to create a standalone function using Create Function tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Functions.
****
- In the list of choices, click New Function. The Create Function window opens.
- For Schema, accept the default value, HR.
- For Name, change FUNCTION1 to CALCULATE_SCORE.
****
- For Return Type, select NUMBER from the menu.
****
- Click the icon Add Parameter. A row appears under the column headings. Its fields have these default values: Name, PARAM1; Mode, IN; No Copy, deselected; Data Type, VARCHAR2; Default Value, empty.
- For Name, change PARAM1 to cat.
- For Mode, accept the default value, IN.
- For Data Type, accept the default, VARCHAR2.
- Leave Default Value empty.
- Add a second parameter by repeating steps 7 through 11 with the Name score and the Data Type NUMBER.
- Add a third parameter by repeating steps 7 through 11 with the Name weight and the Data Type NUMBER.
****
```
CREATE OR REPLACE FUNCTION CALCULATE_SCORE
(
  CAT IN VARCHAR2
, SCORE IN NUMBER
, WEIGHT IN NUMBER
) RETURN NUMBER AS
BEGIN
  RETURN NULL;
END CALCULATE_SCORE;
```
- Click OK. The CALCULATE_SCORE pane opens, showing the CREATE FUNCTION statement that created the function: The title of the CALCULATE_SCORE pane is in italic font, indicating that the function is not yet saved in the database. Because the only statement in the execution part of the function is the statement RETURN NULL, the function does nothing.
- Replace NULL with score * weight.
****
- From the File menu, select Save. Oracle Database compiles the function and saves it. The title of the CALCULATE_SCORE pane is no longer in italic font. The Message - Log pane has the message Compiled.
**See Also:**
- “About Data Definition Language (DDL) Statements” for general information that applies to the CREATE FUNCTION statement
**
- Oracle Database PL/SQL Language Reference for information about the CREATE FUNCTION statement
## Changing Standalone Subprograms
To change a standalone subprogram, use either the SQL Developer tool Edit or the DDL statement ALTER PROCEDURE or ALTER FUNCTION.
**Steps to change a standalone subprogram using the Edit tool:** ****
- In the Connections frame, expand hr_conn.
********
- In the list of schema object types, expand either Functions or Procedures. A list of functions or procedures appears.
- Click the function or procedure to change. To the right of the Connections frame, a frame appears. Its top tab has the name of the subprogram to change. The Code pane shows the code that created the subprogram. The Code pane is in write mode. (Clicking the pencil icon switches the mode from write mode to read only, or the reverse.)
- In the Code pane, change the code. The title of the pane changes to italic font, indicating that the change is not yet saved in the database.
****
- From the File menu, select Save. Oracle Database compiles the subprogram and saves it. The title of the pane is no longer in italic font. The Message - Log pane has the message Compiled.
**See Also:**
- “About Data Definition Language (DDL) Statements” for general information that applies to the ALTER PROCEDURE and ALTER FUNCTION statements
**
- Oracle Database PL/SQL Language Reference for information about the ALTER PROCEDURE statement
**
- Oracle Database PL/SQL Language Reference for information about the ALTER FUNCTION statement
## Tutorial: Testing a Standalone Function
This tutorial shows how to use the SQL Developer tool Run to test the standalone function CALCULATE_SCORE.
**Steps to test the CALCULATE_SCORE function using the Run tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Functions.
****
- In the list of functions, right-click CALCULATE_SCORE.
****
```
 v_Return := CALCULATE_SCORE (
     CAT => CAT,
     SCORE => SCORE,
     WEIGHT => WEIGHT
   );
```
- In the list of choices, click Run. The Run PL/SQL window opens. Its PL/SQL Block frame includes this code:
````
```
v_Return := CALCULATE_SCORE ( CAT => CAT, SCORE => 8, WEIGHT => 0.2 );
```
- Change the values of SCORE and WEIGHT to 8 and 0.2, respectively:
****
```
Connecting to the database hr_conn.
Process exited.
Disconnecting from the database hr_conn.
```
- Click OK. Under the Code pane, the Running window opens, showing this result: To the right of the tab Running is the tab Output Variables.
****
- Click the tab Output Variables. Two frames appear, Variable and Value, which contain the values  and 1.6, respectively.
**See Also:**   *Oracle SQL Developer User’s Guide* for information about using SQL Developer to run and debug procedures and functions
## Dropping Standalone Subprograms
To drop a standalone subprogram, use either the SQL Developer Connections frame and Drop tool, or the DDL statement DROP PROCEDURE or DROP FUNCTION.
**Caution:**   Do not drop the procedure `ADD_EVALUATION` or the function `CALCULATE_SCORE`—you need them for later tutorials. If you want to practice dropping subprograms, create simple ones and then drop them.
**Steps to drop a standalone subprogram using the Drop tool:**
****
- In the Connections frame, expand hr_conn.
********
- In the list of schema object types, expand either Functions or Procedures.
- In the list of functions or procedures, right-click the name of the function or procedure to drop.
****
- In the list of choices, click Drop.
****
- In the Drop window, click Apply.
****
- In the Confirmation window, click OK.
**See Also:**
- “About Data Definition Language (DDL) Statements” for general information that applies to the DROP PROCEDURE and DROP FUNCTION statements
**
- Oracle Database SQL Language Reference for information about the DROP PROCEDURE statement
**
- Oracle Database SQL Language Reference for information about the DROP FUNCTION statement
