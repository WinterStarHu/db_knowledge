# Handling Exceptions (Runtime Errors)

You can handle exceptions that occur at run time with PL/SQL code.
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about handling PL/SQL errors
## About Exceptions and Exception Handlers
When a runtime error occurs in PL/SQL code, an **exception** is raised. If the subprogram (or block) in which the exception is raised has an exception-handling part, then control transfers to it; otherwise, execution stops.
Runtime errors can arise from design faults, coding mistakes, hardware failures, and many other sources.
Oracle Database has many **predefined exceptions** , which it raises automatically when a program violates database rules or exceeds system-dependent limits. For example, if a SELECT INTO statement returns no rows, then Oracle Database raises the predefined exception NO_DATA_FOUND. For a summary of predefined PL/SQL exceptions, see *Oracle Database PL/SQL Language Reference*.
PL/SQL lets you define (declare) your own exceptions. An exception declaration has this syntax:
```
exception_name EXCEPTION;
```
Unlike a predefined exception, a **user-defined exception** must be raised explicitly, using either the RAISE statement or the DBMS_STANDARD.RAISE_APPLICATION_ERROR. procedure. For example:
```
IF condition THEN RAISE exception_name;
```
For information about the DBMS_STANDARD.RAISE_APPLICATION_ERROR procedure, see *Oracle Database PL/SQL Language Reference*.
The exception-handling part of a subprogram contains one or more exception handlers. An **exception handler** has this syntax:
```
WHEN { exception_name [ OR exception_name ]... | OTHERS } THEN
  statement; [ statement; ]...
```
(“About Subprogram Structure” shows where to put the exception-handling part of a subprogram.) A WHEN OTHERS exception handler handles unexpected runtime errors. If used, it must be last. For example:
```
EXCEPTION
  WHEN exception_1 THEN
    statement; [ statement; ]...
  WHEN exception_2 OR exception_3 THEN
    statement; [ statement; ]...
  WHEN OTHERS THEN
    statement; [ statement; ]...
    RAISE;  -- Reraise the exception (very important).
END;
```
An alternative to the WHEN OTHERS exception handler is the EXCEPTION_INIT pragma, which associates a user-defined exception name with an Oracle Database error number.
**See Also:** **
- Oracle Database PL/SQL Language Reference for more information about exception declaration syntax
**
- Oracle Database PL/SQL Language Reference for more information about exception handler syntax
**
- Oracle Database PL/SQL Language Reference for more information about the EXCEPTION_INIT pragma
## When to Use Exception Handlers
Use exception handlers only in the following situations.
- You expect an exception and want to handle it. For example, you expect that eventually, a SELECT INTO statement will return no rows, causing Oracle Database to raise the predefined exception NO_DATA_FOUND. You want your subprogram or block to handle that exception (which is not an error) and then continue, as in Example 5-13.
```
...
file := UTL_FILE.OPEN ...
BEGIN
  statement statement]...  -- If this code fails for any reason,
EXCEPTION
  WHEN OTHERS THEN
    UTL_FILE.FCLOSE(file);     -- then you want to close the file.
    RAISE;                     -- Reraise the exception (very important).
END;
UTL_FILE.FCLOSE(file);
...
```
- You must relinquish or close a resource, as shown in the following example.
```
BEGIN
  proc(...);
EXCEPTION
  WHEN OTHERS THEN
    log_error_using_autonomous_transaction(...);
    RAISE;  -- Reraise the exception (very important).
END;
/
```
- At the top level of the code, when you want to log the error. For example, a client process might issue this block: Alternatively, the standalone subprogram that the client invokes can include the same exception-handling logic—but only at the top level.
## Handling Predefined Exceptions
You can handle predefined exceptions.
Example 5-13 shows  how to change the EMP_EVAL.EVAL_DEPARTMENT procedure to handle the predefined exception NO_DATA_FOUND. Make this change and compile the changed procedure. (For an example of how to change a package body, see “Tutorial: Declaring Variables and Constants in a Subprogram”.) **Example 5-13 Handling Predefined Exception NO_DATA_FOUND**
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
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('The query did not return a result set');
END eval_department;
```
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about predefined exceptions
## Declaring and Handling User-Defined Exceptions
You can declare and handle user-defined exceptions.
Example 5-14 shows how to change the EMP_EVAL.CALCULATE_SCORE function to declare and handle two user-defined exceptions, wrong_weight and wrong_score. Make this change and compile the changed function. (For an example of how to change a package body, see “Tutorial: Declaring Variables and Constants in a Subprogram”.) **Example 5-14 Handling User-Defined Exceptions**
```
FUNCTION calculate_score ( evaluation_id IN scores.evaluation_id%TYPE
                         , performance_id IN scores.performance_id%TYPE )
                         RETURN NUMBER AS
  weight_wrong  EXCEPTION;
  score_wrong   EXCEPTION;
  n_score       scores.score%TYPE;
  n_weight      performance_parts.weight%TYPE;
  running_total NUMBER := 0;
  max_score     CONSTANT scores.score%TYPE := 9;
  max_weight    CONSTANT performance_parts.weight%TYPE:= 1;
BEGIN
  SELECT s.score INTO n_score
  FROM SCORES s
  WHERE evaluation_id = s.evaluation_id
  AND performance_id = s.performance_id;
  SELECT p.weight INTO n_weight
  FROM PERFORMANCE_PARTS p
  WHERE performance_id = p.performance_id;
  BEGIN
    IF (n_weight > max_weight) OR (n_weight < 0) THEN
      RAISE weight_wrong;
    END IF;
  END;
  BEGIN
    IF (n_score > max_score) OR (n_score < 0) THEN
      RAISE score_wrong;
   END IF;
 END;
  running_total := n_score * n_weight;
  RETURN running_total;
EXCEPTION
  WHEN weight_wrong THEN
    DBMS_OUTPUT.PUT_LINE(
      'The weight of a score must be between 0 and ' || max_weight);
    RETURN -1;
  WHEN score_wrong THEN
    DBMS_OUTPUT.PUT_LINE(
      'The score must be between 0 and ' || max_score);
    RETURN -1;
END calculate_score;
```
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about user-defined exceptions
