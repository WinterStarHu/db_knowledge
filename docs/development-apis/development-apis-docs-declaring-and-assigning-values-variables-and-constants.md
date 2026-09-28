# Declaring and Assigning Values to Variables and Constants

A variable or constant declared in a package specification is available to any program that has access to the package. A variable or constant declared in a package body or subprogram is local to that package or subprogram. When declaring a constant, you must assign it an initial value.
One significant advantage that PL/SQL has over SQL is that PL/SQL lets you declare and use variables and constants.
A variable or constant declared in a package specification is available to any program that has access to the package. A variable or constant declared in a package body or subprogram is local to that package or subprogram.
A **variable** holds a value of a particular data type. Your program can change the value at runtime. A **constant** holds a value that cannot be changed.
A variable or constant can have any PL/SQL data type. When declaring a variable, you can assign it an initial value; if you do not, its initial value is NULL. When declaring a constant, you must assign it an initial value. To assign an initial value to a variable or constant, use the assignment operator (`:=`).
**Tip:**   Declare all values that do not change as constants. This practice optimizes your compiled code and makes your source code easier to maintain.
**See Also:**   *Oracle Database PL/SQL Language Reference* for general information about variables and constants
## Tutorial: Declaring Variables and Constants in a Subprogram
This tutorial shows how to use the SQL Developer tool Edit to declare variables and constants in the EMP_EVAL.CALCULATE_SCORE function. (This tutorial is also an example of changing a package body.) The EMP_EVAL.CALCULATE_SCORE function is specified in “Tutorial: Creating a Package Specification”).
**Steps to declare variables and constants in CALCULATE_SCORE function:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Packages.
****
- In the list of packages, expand EMP_EVAL.
****
- In the list of choices, right-click EMP_EVAL Body. A list of choices appears.
****
```
 CREATE OR REPLACE
 PACKAGE BODY EMP_EVAL AS
   PROCEDURE eval_department ( dept_id IN NUMBER ) AS
   BEGIN
     -- TODO implementation required for PROCEDURE EMP_EVAL.eval_department
     NULL;
   END eval_department;
   FUNCTION calculate_score ( evaluation_id IN NUMBER
                           , performance_id IN NUMBER)
                           RETURN NUMBER AS
   BEGIN
     -- TODO implementation required for FUNCTION EMP_EVAL.calculate_score
     RETURN NULL;
   END calculate_score;
 END EMP_EVAL;
```
- In the list of choices, select Edit. The EMP_EVAL Body pane appears, showing the code for the package body:
````
```
n_score       NUMBER(1,0);                -- variable n_weight      NUMBER;                     -- variable max_score     CONSTANT NUMBER(1,0) := 9;  -- constant, initial value 9 max_weight    CONSTANT NUMBER(8,8) := 1;  -- constant, initial value 1
```
```
The title of the EMP_EVAL Bodypane changes to italic font, indicating that the code is not saved in the database.
```
- Between RETURN NUMBER AS and BEGIN, add these variable and constant declarations:
****
- From the File menu, select Save. Oracle Database compiles and saves the changed package body. The title of the EMP_EVAL Body pane is no longer in italic font.
**See Also:**
**
- Oracle Database PL/SQL Language Reference for general information about declaring variables and constants
- “Assigning Values to Variables with the Assignment Operator”
## Ensuring that Variables, Constants, and Parameters Have Correct Data Types
Ensure that variables, constants, and parameters have the correct data types by declaring them with the %TYPE attribute.
After “Tutorial: Declaring Variables and Constants in a Subprogram”, the code for the EMP_EVAL.CALCULATE_SCORE function is:
```
FUNCTION calculate_score ( evaluation_id IN NUMBER , performance_id IN NUMBER ) RETURN NUMBER AS n_score       NUMBER(1,0);                -- variable n_weight      NUMBER;                     -- variable max_score     CONSTANT NUMBER(1,0) := 9;  -- constant, initial value 9 max_weight    CONSTANT NUMBER(8,8) := 1;  -- constant, initial value 1 BEGIN -- TODO implementation required for FUNCTION EMP_EVAL.calculate_score RETURN NULL;
END calculate_score;
```
The variables, constants, and parameters of the function represent values from the tables SCORES and PERFORMANCE_PARTS (created in “Creating Tables”):
- Variable n_score will hold a value from the column SCORE.SCORES and constant max_score will be compared to such values.
- Variable n_weight will hold a value from the column PERFORMANCE_PARTS.WEIGHT and constant max_weight will be compared to such values.
- Parameter evaluation_id will hold a value from the column SCORE.EVALUATION_ID.
- Parameter performance_id will hold a value from the column SCORE.PERFORMANCE_ID.
Therefore, each variable, constant, and parameter has the same data type as its corresponding column.
If the data types of the columns change, you want the data types of the variables, constants, and parameters to change to the same data types; otherwise, the CALCULATE_SCORE function is invalidated.
To ensure that the data types of the variables, constants, and parameters always match those of the columns, declare them with the %TYPE attribute. The %TYPE attribute supplies the data type of a table column or another variable, ensuring the correct data type assignment.
**See Also:**
**
- Oracle Database PL/SQL Language Reference for more information about the %TYPE attribute
**
- Oracle Database PL/SQL Language Reference for the syntax of the %TYPE attribute
## Tutorial: Changing Declarations to Use the %TYPE Attribute
This tutorial shows how to use the SQL Developer tool Edit to change the declarations of the variables, constants, and formal parameters of the EMP_EVAL.CALCULATE_SCORE function to use the %TYPE attribute.
The EMP_EVAL.CALCULATE_SCORE function is shown in “Tutorial: Declaring Variables and Constants in a Subprogram”.
**Steps to change the declarations in CALCULATE_SCORE to use %TYPE:**
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Packages.
****
- In the list of packages, expand EMP_EVAL.
****
- In the list of choices, right-click EMP_EVAL Body.
****
```
CREATE OR REPLACE PACKAGE BODY emp_eval AS PROCEDURE eval_department ( dept_id IN NUMBER ) AS BEGIN -- TODO implementation required for PROCEDURE EMP_EVAL.eval_department NULL;
END eval_department;
FUNCTION calculate_score ( evaluation_id IN NUMBER , performance_id IN NUMBER ) RETURN NUMBER AS n_score       NUMBER(1,0);                -- variable n_weight      NUMBER;                     -- variable max_score     CONSTANT NUMBER(1,0) := 9;  -- constant, initial value 9 max_weight    CONSTANT NUMBER(8,8) := 1;  -- constant, initial value 1 BEGIN -- TODO implementation required for FUNCTION EMP_EVAL.calculate_score RETURN NULL;
END calculate_score;
END emp_eval;
```
- In the list of choices, select Edit. The EMP_EVAL Bodypane appears, showing the code for the package body:
```
FUNCTION calculate_score ( evaluation_id IN SCORES.EVALUATION_ID%TYPE , performance_id IN SCORES.PERFORMANCE_ID%TYPE) RETURN NUMBER AS n_score       SCORES.SCORE%TYPE;
n_weight      PERFORMANCE_PARTS.WEIGHT%TYPE;
max_score     CONSTANT SCORES.SCORE%TYPE := 9;
max_weight    CONSTANT PERFORMANCE_PARTS.WEIGHT%TYPE := 1;
```
- In the code for the function, make the following changes:
****
- Right-click EMP_EVAL.
****
```
CREATE OR REPLACE PACKAGE EMP_EVAL AS PROCEDURE eval_department(dept_id IN NUMBER);
FUNCTION calculate_score(evaluation_id IN NUMBER , performance_id IN NUMBER) RETURN NUMBER;
END EMP_EVAL;
```
- In the list of choices, select Edit. The EMP_EVAL paneopens, showing the CREATE PACKAGE statement that created the package:
```
FUNCTION calculate_score(evaluation_id IN scores.evaluation_id%TYPE , performance_id IN scores.performance_id%TYPE)
```
- In the code for the function, make the following changes:
****
- Right-click EMP_EVAL.
****
- In the list of choices, select Compile.
****
- Right-click EMP_EVAL Body.
****
- In the list of choices, select Compile.
## Assigning Values to Variables
You can assign a value to a variable in the following ways:
- Use the assignment operator to assign it the value of an expression.
- Use the SELECT INTO or FETCH statement to assign it a value from a table.
- Pass it to a subprogram as an OUT or IN OUT parameter, and then assign the value inside the subprogram.
- Bind the variable to a value.
**See Also:**
**
- Oracle Database PL/SQL Language Reference for more information about assigning values to variables
**
- Oracle Database 2 Day + Java Developer’s Guide for information about binding variables
### Assigning Values to Variables with the Assignment Operator
With the assignment operator (`:=`), you can assign the value of an expression to a variable in either the declarative or executable part of a subprogram.
In the declarative part of a subprogram, you can assign an initial value to a variable when you declare it. The syntax is:
```
variable_name data_type := expression;
```
In the executable part of a subprogram, you can assign a value to a variable with an assignment statement. The syntax is:
```
variable_name := expression;
```
Example 5-1 shows the changes to make to the EMP_EVAL.CALCULATE_SCORE function to add a variable, running_total, and use it as the return value of the function. The assignment operator appears in both the declarative and executable parts of the function. (The data type of running_total must be NUMBER, rather than SCORES.SCORE%TYPE or PERFORMANCE_PARTS.WEIGHT%TYPE, because it holds the product of two NUMBER values with different precisions and scales.)
**See Also:**
**
- Oracle Database PL/SQL Language Reference for variable declaration syntax
**
- Oracle Database PL/SQL Language Reference for assignment statement syntax
**Example 5-1 Assigning Values to a Variable with Assignment Operator**
```
FUNCTION calculate_score(evaluation_id IN SCORES.EVALUATION_ID%TYPE , performance_id IN SCORES.PERFORMANCE_ID%TYPE) RETURN NUMBER AS n_score       SCORES.SCORE%TYPE;
n_weight      PERFORMANCE_PARTS.WEIGHT%TYPE;
running_total NUMBER := 0;
max_score     CONSTANT SCORES.SCORE%TYPE := 9;
max_weight    CONSTANT PERFORMANCE_PARTS.WEIGHT%TYPE:= 1;
BEGIN running_total := max_score * max_weight;
RETURN running_total;
END calculate_score;
```
### Assigning Values to Variables with the SELECT INTO Statement
To use table values in subprograms or packages, you must assign them to variables with SELECT INTO statements.
Example 5-2 shows the changes to make to the EMP_EVAL.CALCULATE_SCORE function to have it calculate running_total from table values.
The ADD_EVAL procedure in Example 5-3 inserts a row into the EVALUATIONS table, using values from the corresponding row in the EMPLOYEES table. Add the ADD_EVAL procedure to the body of the EMP_EVAL package, but not to the specification. Because it is not in the specification, ADD_EVAL is local to the package-it can be invoked only by other subprograms in the package, not from outside the package.
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about the SELECT INTO statement
**Example 5-2 Assigning Table Values to Variables with SELECT INTO**
```
FUNCTION calculate_score ( evaluation_id IN scores.evaluation_id%TYPE , performance_id IN scores.performance_id%TYPE ) RETURN NUMBER AS n_score       scores.score%TYPE;
n_weight      performance_parts.weight%TYPE;
running_total NUMBER := 0;
max_score     CONSTANT scores.score%TYPE := 9;
max_weight    CONSTANT performance_parts.weight%TYPE:= 1;
BEGIN SELECT s.score INTO n_score FROM SCORES s WHERE evaluation_id = s.evaluation_id AND performance_id = s.performance_id;
SELECT p.weight INTO n_weight FROM PERFORMANCE_PARTS p WHERE performance_id = p.performance_id;
running_total := n_score * n_weight;
RETURN running_total;
END calculate_score;
```
**Example 5-3 Inserting a Table Row with Values from Another Table**
```
PROCEDURE add_eval ( employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE , today IN DATE ) AS job_id         EMPLOYEES.JOB_ID%TYPE;
manager_id     EMPLOYEES.MANAGER_ID%TYPE;
department_id  EMPLOYEES.DEPARTMENT_ID%TYPE;
BEGIN INSERT INTO EVALUATIONS ( evaluation_id, employee_id, evaluation_date, job_id, manager_id, department_id, total_score ) SELECT evaluations_sequence.NEXTVAL,   -- evaluation_id add_eval.employee_id,      -- employee_id add_eval.today,            -- evaluation_date e.job_id,                  -- job_id e.manager_id,              -- manager_id e.department_id,           -- department_id 0                          -- total_score FROM employees e;
IF SQL%ROWCOUNT = 0 THEN RAISE NO_DATA_FOUND;
END IF;
END add_eval;
```
