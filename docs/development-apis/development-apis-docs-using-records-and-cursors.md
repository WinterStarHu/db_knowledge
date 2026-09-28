# Using Records and Cursors

The script content on this page is for navigation purposes only and does not alter the content in any way.
You can store data values in records, and use a cursor as a pointer to a result set and related processing information.
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about records
## About Records
A **record** is a PL/SQL composite variable that can store data values of different types. You can treat Internal components (**fields**) like scalar variables. You can pass entire records as subprogram parameters. Records are useful for holding data from table rows, or from certain columns of table rows.
A **record** is a PL/SQL composite variable that can store data values of different types, similar to a struct type in C, C++, or Java. The internal components of a record are called **fields**. To access a record field, you use **dot notation** : record_name.field_name.
You can treat record fields like scalar variables. You can also pass entire records as subprogram parameters.
Records are useful for holding data from table rows, or from certain columns of table rows. Each record field corresponds to a table column.
There are three ways to create a record:
****
```
TYPE record_name IS RECORD
  ( field_name data_type [:=  initial_value]
 [, field_name data_type [:= initial_value ] ]... );
variable_name record_name;
```
- Declare a RECORD type and then declare a variable of that type. Use the following syntax:
- Declare a variable of the type table_name%ROWTYPE. The fields of the record have the same names and data types as the columns of the table.
- Declare a variable of the type cursor_name%ROWTYPE. The fields of the record have the same names and data types as the columns of the table in the FROM clause of the cursor SELECT statement.
**See Also:** **
- Oracle Database PL/SQL Language Reference for more information about defining RECORD types and declaring records of that type
**
- Oracle Database PL/SQL Language Reference for the syntax of a RECORD type definition
**
- Oracle Database PL/SQL Language Reference for more information about the %ROWTYPE attribute
**
- Oracle Database PL/SQL Language Reference for the syntax of the %ROWTYPE attribute
## Tutorial: Declaring a RECORD Type
The following steps show how to use the SQL Developer tool Edit to declare a RECORD type, `sal_info`, whose fields can hold salary information for an employee—job ID, minimum and maximum salary for that job ID, current salary, and suggested raise.
**Steps to declare RECORD type sal_info:** ****
- In the Connections frame, expand hr_conn. Under the hr_conn icon, a list of schema object types appears.
****
- Expand Packages. A list of packages appears.
****
- Right-click EMP_EVAL. A list of choices appears.
****
```
CREATE OR REPLACE PACKAGE EMP_EVAL AS
PROCEDURE eval_department(dept_id IN NUMBER);
FUNCTION calculate_score(evaluation_id IN NUMBER
                       , performance_id IN NUMBER)
                         RETURN NUMBER;
END EMP_EVAL;
```
- Select Edit. The EMP_EVAL pane opens, showing the CREATE PACKAGE statement that created the package:
```
 TYPE sal_info IS RECORD
   ( j_id     jobs.job_id%type
   , sal_min  jobs.min_salary%type
   , sal_max  jobs.max_salary%type
   , sal      employees.salary%type
   , sal_raise NUMBER(3,3) );
```
- In the EMP_EVAL pane, immediately before END EMP_EVAL, add this code: The title of the pane is in italic font, indicating that the changes have not been saved to the database.
****
- Select the Compile icon. The changed package specification compiles and is saved to the database. The title of the EMP_EVAL pane is no longer in italic font. Now you can declare records of the type sal_info, as in “Tutorial: Creating and Invoking a Subprogram with a Record Parameter”.
## Tutorial: Creating and Invoking a Subprogram with a Record Parameter
The following steps show how to use the SQL Developer tool Edit to create and invoke a subprogram with a parameter of the record type `sal_info`.
The record type `sal_info` was created in “Tutorial: Declaring a RECORD Type”.
This tutorial shows how to use the SQL Developer tool Edit to complete the following tasks:
- Create a procedure, SALARY_SCHEDULE, which has a parameter of type sal_info.
- Change the EVAL_FREQUENCY function so that it declares a record, emp_sal, of the type sal_info, populates its fields, and passes it to the SALARY_SCHEDULE procedure.
Because EVAL_FREQUENCY will invoke SALARY_SCHEDULE, the declaration of SALARY_SCHEDULE must precede the declaration of EVAL_FREQUENCY (otherwise the package will not compile). However, the definition of SALARY_SCHEDULE can be anywhere in the package body.
**Steps to create SALARY_SCHEDULE and change EVAL_FREQUENCY:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Packages.
****
- In the list of packages, expand EMP_EVAL.
****
- In the list of choices, right-click EMP_EVAL Body.
****
- In the list of choices, select Edit. The EMP_EVAL Body pane appears, showing the code for the package body.
```
 PROCEDURE salary_schedule (emp IN sal_info) AS
   accumulating_sal  NUMBER;
 BEGIN
   DBMS_OUTPUT.PUT_LINE('If salary ' || emp.sal ||
     ' increases by ' || ROUND((emp.sal_raise * 100),0) ||
     '% each year, it will be:');
   accumulating_sal := emp.sal;
   WHILE accumulating_sal <= emp.sal_max LOOP
     accumulating_sal := accumulating_sal * (1 + emp.sal_raise);
     DBMS_OUTPUT.PUT_LINE(ROUND(accumulating_sal,2) ||', ');
   END LOOP;
 END salary_schedule;
```
- In the EMP_EVAL Body pane, immediately before END EMP_EVAL, add the following definition of the SALARY_SCHEDULE procedure: The title of the pane is in italic font, indicating that the changes have not been saved to the database.
```
 CREATE OR REPLACE
 PACKAGE BODY EMP_EVAL AS
 FUNCTION eval_frequency (emp_id EMPLOYEES.EMPLOYEE_ID%TYPE)
   RETURN PLS_INTEGER;
 PROCEDURE salary_schedule(emp IN sal_info);
 PROCEDURE add_eval(employee_id IN employees.employee_id%type, today IN DATE);
 PROCEDURE eval_department (dept_id IN NUMBER) AS
```
- In the EMP_EVAL Body pane, enter the eval_frequency function and the salary_schedule and add_eval procedures in the following position:
```
 FUNCTION eval_frequency (emp_id EMPLOYEES.EMPLOYEE_ID%TYPE)
   RETURN PLS_INTEGER
 AS
   h_date     EMPLOYEES.HIRE_DATE%TYPE;
   today      EMPLOYEES.HIRE_DATE%TYPE;
   eval_freq  PLS_INTEGER;
   emp_sal    SAL_INFO;  -- replaces sal, sal_raise, and sal_max
 BEGIN
   SELECT SYSDATE INTO today FROM DUAL;
   SELECT HIRE_DATE INTO h_date
   FROM EMPLOYEES
   WHERE EMPLOYEE_ID = eval_frequency.emp_id;
   IF ((h_date + (INTERVAL '120' MONTH)) < today) THEN
     eval_freq := 1;
     /* populate emp_sal */
     SELECT j.JOB_ID, j.MIN_SALARY, j.MAX_SALARY, e.SALARY
     INTO emp_sal.j_id, emp_sal.sal_min, emp_sal.sal_max, emp_sal.sal
     FROM EMPLOYEES e, JOBS j
     WHERE e.EMPLOYEE_ID = eval_frequency.emp_id
     AND j.JOB_ID = eval_frequency.emp_id;
     emp_sal.sal_raise := 0;  -- default
     CASE emp_sal.j_id
       WHEN 'PU_CLERK' THEN emp_sal.sal_raise := 0.08;
       WHEN 'SH_CLERK' THEN emp_sal.sal_raise := 0.07;
       WHEN 'ST_CLERK' THEN emp_sal.sal_raise := 0.06;
       WHEN 'HR_REP' THEN emp_sal.sal_raise := 0.05;
       WHEN 'PR_REP' THEN emp_sal.sal_raise := 0.05;
       WHEN 'MK_REP' THEN emp_sal.sal_raise := 0.04;
       ELSE NULL;
     END CASE;
     IF (emp_sal.sal_raise != 0) THEN
       salary_schedule(emp_sal);
     END IF;
   ELSE
     eval_freq := 2;
   END IF;
   RETURN eval_freq;
 END eval_frequency;
```
- Edit the EVAL_FREQUENCY function, making the following changes:
****
- Select Compile.
## About Cursors
When Oracle Database runs a SQL statement, it stores the result set and processing information in an unnamed private SQL area. A pointer to this unnamed area, called a **cursor**, lets you retrieve the result set one row at a time. **Cursor attributes** return information about the state of the cursor.
Every time that you run either a SQL DML statement or a PL/SQL SELECT INTO statement, PL/SQL opens an **implicit cursor**. You can get information about this cursor from its attributes, but you cannot control it. After the statement runs, the database closes the cursor; however, its attribute values remain available until another DML or SELECT INTO statement runs.
PL/SQL also lets you declare cursors. A **declared cursor** has a name and is associated with a query (SQL SELECT statement)-usually one that returns multiple rows. After declaring a cursor, you must process it, either implicitly or explicitly. To process the cursor implicitly, use a cursor FOR LOOP. The syntax is:
```
FOR record_name IN cursor_name LOOP
  statement
  [ statement ]...
END LOOP;
```
To process the cursor explicitly, open it (with the OPEN statement), fetch rows from the result set either one at a time or in bulk (with the FETCH statement), and close the cursor (with the CLOSE statement). After closing the cursor, you can neither fetch records from the result set nor see the cursor attribute values.
The syntax for the value of an implicit cursor attribute is SQL%attribute (for example, SQL%FOUND). SQL%attribute always refers to the most recently run DML or SELECT INTO statement.
The syntax for the value of a declared cursor attribute is cursor_name%attribute (for example, c1%FOUND).
Table 1 lists the cursor attributes and the values that they can return. (Implicit cursors have additional attributes that are beyond the scope of this book.) **Table 1 Cursor Attribute Values**

| Attribute | Values for Declared Cursor | Values for Implicit Cursor |
|---|---|---|
| %FOUND | If cursor is open (Footnote 1) but no fetch was attempted, NULL.If the most recent fetch returned a row, TRUE.If the most recent fetch did not return a row, FALSE. | If no DML or SELECT INTO statement has run, NULL.If the most recent DML or SELECT INTOstatement returned a row, TRUE.If the most recent DML or SELECT INTOstatement did not return a row, FALSE. |
| %NOTFOUND | If cursor is open (Footnote 1) but no fetch was attempted, NULL.If the most recent fetch returned a row, FALSE.If the most recent fetch did not return a row, TRUE. | If no DML or SELECT INTO statement has run, NULL.If the most recent DML or SELECT INTOstatement returned a row, FALSE.If the most recent DML or SELECT INTO statement did not return a row, TRUE. |
| %ROWCOUNT | If cursor is open (Footnote 1), a number greater than or equal to zero. | NULL if no DML or SELECT INTO statement has run; otherwise, a number greater than or equal to zero. |
| %ISOPEN | If cursor is open, TRUE; if not, FALSE. | Always FALSE. |

**Footnote 1:**   If the cursor is not open, the attribute raises the predefined exception INVALID_CURSOR.
**See Also:**
- “About Queries”
- “About Data Manipulation Language (DML) Statements”
**
- Oracle Database PL/SQL Language Reference for more information about the SELECT INTO statement
**
- Oracle Database PL/SQL Language Reference for more information about managing cursors in PL/SQL
## Using a Declared Cursor to Retrieve Result Set Rows One at a Time
You can use a declared cursor to retrieve result set rows one at a time.
The following procedure uses each necessary statement in its simplest form, but provides references to its complete syntax.
**Steps to use a declared cursor to retrieve result set rows one at a time:**
```
 CURSOR cursor_name IS query;
```
**
  - Declare the cursor: For complete declared cursor declaration syntax, see Oracle Database PL/SQL Language Reference.
```
 record_name cursor_name%ROWTYPE;
```
**
  - Declare a record to hold the row returned by the cursor: For complete %ROWTYPE syntax, see Oracle Database PL/SQL Language Reference.
```
 OPEN cursor_name;
```
**
  - Open the cursor: For complete OPEN statement syntax, see Oracle Database PL/SQL Language Reference.
```
 LOOP
   FETCH cursor_name INTO record_name;
   EXIT WHEN cursor_name%NOTFOUND;
   -- Process row that is in record_name:
   statement;
   [ statement; ]...
 END LOOP;
```
**
  - Fetch rows from the cursor (rows from the result set) one at a time, using a LOOP statement that has syntax similar to the following code: For complete FETCH statement syntax, see Oracle Database PL/SQL Language Reference.
```
 CLOSE cursor_name;
```
  - Close the cursor:
For complete CLOSE statement syntax, see *Oracle Database PL/SQL Language Reference*.
## Tutorial: Using a Declared Cursor to Retrieve Result Set Rows One at a Time
The following steps show how to implement the procedure EMP_EVAL.EVAL_DEPARTMENT, which uses a declared cursor, emp_cursor.
**Steps to implement the EMP_EVAL.EVAL_DEPARTMENT procedure:**
```
 PROCEDURE eval_department(dept_id IN employees.department_id%TYPE);
```
- In the EMP_EVAL package specification, change the declaration of the EVAL_DEPARTMENT procedure as shown:
```
 PROCEDURE eval_department (dept_id IN employees.department_id%TYPE)
 AS
   CURSOR emp_cursor IS
     SELECT * FROM EMPLOYEES
     WHERE DEPARTMENT_ID = eval_department.dept_id;
   emp_record  EMPLOYEES%ROWTYPE;  -- for row returned by cursor
   all_evals   BOOLEAN;  -- true if all employees in dept need evaluations
   today       DATE;
 BEGIN
   today := SYSDATE;
   IF (EXTRACT(MONTH FROM today) < 6) THEN
     all_evals := FALSE; -- only new employees need evaluations
   ELSE
     all_evals := TRUE;  -- all employees need evaluations
   END IF;
   OPEN emp_cursor;
   DBMS_OUTPUT.PUT_LINE (
     'Determining evaluations necessary in department # ' ||
     dept_id );
   LOOP
     FETCH emp_cursor INTO emp_record;
     EXIT WHEN emp_cursor%NOTFOUND;
     IF all_evals THEN
       add_eval(emp_record.employee_id, today);
     ELSIF (eval_frequency(emp_record.employee_id) = 2) THEN
       add_eval(emp_record.employee_id, today);
     END IF;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Processed ' || emp_cursor%ROWCOUNT || ' records.');
   CLOSE emp_cursor;
 END eval_department;
```
- In the EMP_EVAL package body, change the definition of the EVAL_DEPARTMENT procedure as shown in the following example: (For a step-by-step example of changing a package body, see “Tutorial: Declaring Variables and Constants in a Subprogram”.)
- Compile the EMP_EVAL package specification.
- Compile the EMP_EVAL package body.
## About Cursor Variables
A **cursor variable** is like a cursor that it is not limited to one query. You can open a cursor variable for a query, process the result set, and then use the cursor variable for another query. Cursor variables are useful for passing query results between subprograms.
For information about cursors, see “About Cursors”.
To declare a cursor variable, you declare a REF CURSOR type, and then declare a variable of that type (therefore, a cursor variable is often called a **REF CURSOR**). A REF CURSOR type can be either strong or weak.
A **strong REF CURSOR type** specifies a **return type** , which is the RECORD type of its cursor variables. The PL/SQL compiler does not allow you to use these **strongly typed** cursor variables for queries that return rows that are not of the return type. Strong REF CURSOR types are less error-prone than weak ones, but weak ones are more flexible.
A **weak REF CURSOR type** does not specify a return type. The PL/SQL compiler accepts **weakly typed** cursor variables in any queries. Weak REF CURSOR types are interchangeable; therefore, instead of creating weak REF CURSOR types, you can use the predefined type weak cursor type SYS_REFCURSOR.
After declaring a cursor variable, you must open it for a specific query (with the OPEN FOR statement), fetch rows one at a time from the result set (with the FETCH statement), and then either close the cursor (with the CLOSE statement) or open it for another specific query (with the OPEN FOR statement). Opening the cursor variable for another query closes it for the previous query. After closing a cursor variable for a specific query, you can neither fetch records from the result set of that query nor see the cursor attribute values for that query.
**See Also:** **
- Oracle Database PL/SQL Language Reference for more information about using cursor variables
**
- Oracle Database PL/SQL Language Reference for the syntax of cursor variable declaration
## Using a Cursor Variable to Retrieve Result Set Rows One at a Time
You can use a cursor variable to retrieve result set rows one at a time.
The following procedure uses each of the necessary statements in its simplest form, but provides references to their complete syntax.
**Steps to use a cursor variable to retrieve result set rows one at a time:**
```
 TYPE cursor_type IS REF CURSOR [ RETURN return_type ];
```
**
  - Declare the REF CURSOR type: For complete REF CURSOR type declaration syntax, see Oracle Database PL/SQL Language Reference.
```
 cursor_variable cursor_type;
```
**
  - Declare a cursor variable of that type: For complete cursor variable declaration syntax, see Oracle Database PL/SQL Language Reference.
```
 record_name return_type;
```
**
  - Declare a record to hold the row returned by the cursor: For complete information about record declaration syntax, see Oracle Database PL/SQL Language Reference.
```
 OPEN cursor_variable FOR query;
```
**
  - Open the cursor variable for a specific query: For complete information about OPEN FOR statement syntax, see Oracle Database PL/SQL Language Reference.
```
 LOOP
   FETCH cursor_variable INTO record_name;
   EXIT WHEN cursor_variable%NOTFOUND;
   -- Process row that is in record_name:
   statement;
   [ statement; ]...
 END LOOP;
```
**
  - Fetch rows from the cursor variable (rows from the result set) one at a time, using a LOOP statement that has syntax similar to this: For complete information about FETCH statement syntax, see Oracle Database PL/SQL Language Reference.
```
 CLOSE cursor_variable;
```
**
  - Close the cursor variable: Alternatively, you can open the cursor variable for another query, which closes it for the current query. For complete information about CLOSE statement syntax, see Oracle Database PL/SQL Language Reference.
## Tutorial: Using a Cursor Variable to Retrieve Result Set Rows One at a Time
This following steps show how to change the EMP_EVAL.EVAL_DEPARTMENT procedure so that it uses a cursor variable instead of a declared cursor (which lets it process multiple departments) and how to make EMP_EVAL.EVAL_DEPARTMENT and EMP_EVAL.ADD_EVAL more efficient.
How this tutorial makes EMP_EVAL.EVAL_DEPARTMENT and EMP_EVAL.ADD_EVAL more efficient: Instead of passing one field of a record to ADD_EVAL and having ADD_EVAL use three queries to extract three other fields of the same record, EVAL_DEPARTMENT passes the entire record to ADD_EVAL, and ADD_EVAL uses dot notation to access the values of the other three fields.
**Steps to change the EMP_EVAL.EVAL_DEPARTMENT procedure to use a cursor variable:**
```
 CREATE OR REPLACE
 PACKAGE emp_eval AS
   PROCEDURE eval_department (dept_id IN employees.department_id%TYPE);
   PROCEDURE eval_everyone;
   FUNCTION calculate_score(eval_id IN scores.evaluation_id%TYPE
                         , perf_id IN scores.performance_id%TYPE)
                           RETURN NUMBER;
   TYPE SAL_INFO IS RECORD
       ( j_id jobs.job_id%type
       , sal_min jobs.min_salary%type
       , sal_max jobs.max_salary%type
       , salary employees.salary%type
       , sal_raise NUMBER(3,3));
   TYPE emp_refcursor_type IS REF CURSOR RETURN employees%ROWTYPE;
 END emp_eval;
```
- In the EMP_EVAL package specification, add the procedure declaration and the REF CURSOR type definition, as shown in the following example:
```
 CREATE OR REPLACE
 PACKAGE BODY EMP_EVAL AS
   FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
     RETURN PLS_INTEGER;
   PROCEDURE salary_schedule(emp IN sal_info);
   PROCEDURE add_eval(emp_record IN EMPLOYEES%ROWTYPE, today IN DATE);
   PROCEDURE eval_loop_control(emp_cursor IN emp_refcursor_type);
 ...
```
- In the EMP_EVAL package body, add a forward declaration for the procedure EVAL_LOOP_CONTROL and change the declaration of the procedure ADD_EVAL, as shown: (For a step-by-step example of changing a package body, see “Tutorial: Declaring Variables and Constants in a Subprogram”.)
```
 PROCEDURE eval_department(dept_id IN employees.department_id%TYPE) AS
   emp_cursor    emp_refcursor_type;
   current_dept  departments.department_id%TYPE;
 BEGIN
   current_dept := dept_id;
   FOR loop_c IN 1..3 LOOP
     OPEN emp_cursor FOR
       SELECT *
       FROM employees
       WHERE current_dept = eval_department.dept_id;
     DBMS_OUTPUT.PUT_LINE
       ('Determining necessary evaluations in department #' ||
       current_dept);
     eval_loop_control(emp_cursor);
     DBMS_OUTPUT.PUT_LINE
       ('Processed ' || emp_cursor%ROWCOUNT || ' records.');
     CLOSE emp_cursor;
     current_dept := current_dept + 10;
   END LOOP;
 END eval_department;
```
- Change the EVAL_DEPARTMENT procedure to retrieve three separate result sets based on the department, and to invoke the EVAL_LOOP_CONTROL procedure, as shown in the following example:
```
 PROCEDURE add_eval(emp_record IN employees%ROWTYPE, today IN DATE)
 AS
 -- (Delete local variables)
 BEGIN
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
     evaluations_sequence.NEXTVAL,   -- evaluation_id
     emp_record.employee_id,    -- employee_id
     today,                     -- evaluation_date
     emp_record.job_id,         -- job_id
     emp_record.manager_id,     -- manager_id
     emp_record.department_id,  -- department_id
     0                           -- total_score
 );
 END add_eval;
```
- Change the ADD_EVAL procedure as shown:
```
 PROCEDURE eval_loop_control (emp_cursor IN emp_refcursor_type) AS
   emp_record      EMPLOYEES%ROWTYPE;
   all_evals       BOOLEAN;
   today           DATE;
 BEGIN
   today := SYSDATE;
   IF (EXTRACT(MONTH FROM today) < 6) THEN
     all_evals := FALSE;
   ELSE
     all_evals := TRUE;
   END IF;
   LOOP
     FETCH emp_cursor INTO emp_record;
     EXIT WHEN emp_cursor%NOTFOUND;
     IF all_evals THEN
       add_eval(emp_record, today);
     ELSIF (eval_frequency(emp_record.employee_id) = 2) THEN
       add_eval(emp_record, today);
     END IF;
   END LOOP;
 END eval_loop_control;
```
- Before END EMP_EVAL, add the following procedure, which fetches the individual records from the result set and processes them:
```
 PROCEDURE eval_everyone AS
   emp_cursor emp_refcursor_type;
 BEGIN
   OPEN emp_cursor FOR SELECT * FROM employees;
   DBMS_OUTPUT.PUT_LINE('Determining number of necessary evaluations.');
   eval_loop_control(emp_cursor);
   DBMS_OUTPUT.PUT_LINE('Processed ' || emp_cursor%ROWCOUNT || ' records.');
   CLOSE emp_cursor;
 END eval_everyone;
```
- Before END EMP_EVAL, add the following procedure, which retrieves a result set that contains all employees in the company:
- Compile the EMP_EVAL package specification.
- Compile the EMP_EVAL package body.
