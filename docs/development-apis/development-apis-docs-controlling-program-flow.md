# Controlling Program Flow

Unlike SQL, which runs statements in the order in which you enter them, PL/SQL has control statements that let you control the flow of your program.
## About Control Statements
PL/SQL has three categories of control statements: conditional selection statements, loop statements, and sequential control statements.
**Conditional selection statements** let you execute different statements for different data values. The conditional selection statements are `IF` and `CASE`.
**Loop statements** let you repeat the same statements with a series of different data values. The loop statements are `FOR` `LOOP`, `WHILE` `LOOP`, and basic `LOOP`. The `EXIT` statement transfers control to the end of a loop. The `CONTINUE` statement exits the current iteration of a loop and transfers control to the next iteration. Both `EXIT` and `CONTINUE` have an optional `WHEN` clause, in which you can specify a condition.
**Sequential control statements** let you go to a specified labeled statement or to do nothing. The sequential control statements are `GOTO` and `NULL`.
**See Also:**   *Oracle Database PL/SQL Language Reference* for an overview of PL/SQL control statements
## Using the IF Statement
The IF statement either executes or skips a sequence of statements, depending on the value of a Boolean expression.
The IF statement has this syntax:
```
IF boolean_expression THEN statement [, statement ]
[ ELSIF boolean_expression THEN statement [, statement ] ]...
[ ELSE  statement [, statement ] ]
END IF;
```
Suppose that your company evaluates employees twice a year in the first 10 years of employment, but only once a year afterward. You want a function that returns the evaluation frequency for an employee. You can use an IF statement to determine the return value of the function, as in Example 5-4.
Add the EVAL_FREQUENCY function to the body of the EMP_EVAL package, but not to the specification. Because it is not in the specification, EVAL_FREQUENCY is local to the package-it can be invoked only by other subprograms in the package, not from outside the package.
**Tip:**    When using a PL/SQL variable in a SQL statement, as in the second SELECT statement in Example 5-4, qualify the variable with the subprogram name to ensure that it is not mistaken for a table column.
**See Also:** **
- Oracle Database PL/SQL Language Reference for the syntax of the IF statement
**
- Oracle Database PL/SQL Language Reference for more information about using the IF statement
**Example 5-4 IF Statement that Determines Return Value of Function**
```
FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date     EMPLOYEES.HIRE_DATE%TYPE;
  today      EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq  PLS_INTEGER;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE INTO h_date
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = eval_frequency.emp_id;
  IF ((h_date + (INTERVAL '120' MONTH)) < today) THEN
    eval_freq := 1;
  ELSE
    eval_freq := 2;
  END IF;
  RETURN eval_freq;
END eval_frequency;
```
## Using the CASE Statement
The CASE statement chooses from a sequence of conditions, and executes the corresponding statement.
The simple CASE statement evaluates a single expression and compares it to several potential values. It has this syntax:
```
CASE expression
WHEN value THEN statement
[ WHEN value THEN statement ]...
[ ELSE statement [, statement ]... ]
END CASE;
```
The searched CASE statement evaluates multiple Boolean expressions and chooses the first one whose value is TRUE. For information about the searched CASE statement, see *Oracle Database PL/SQL Language Reference*.
**Tip:**    When you can use either a CASE statement or nested IF statements, use a CASE statement-it is both more readable and more efficient.
Suppose that, if an employee is evaluated only once a year, you want the EVAL_FREQUENCY function to suggest a salary increase, which depends on the JOB_ID.
Change the EVAL_FREQUENCY function as shown in Example 5-5. (For information about the procedures that prints the strings, DBMS_OUTPUT.PUT_LINE, see *Oracle Database PL/SQL Packages and Types Reference*.) **Example 5-5 CASE Statement that Determines Which String to Print**
```
FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date     EMPLOYEES.HIRE_DATE%TYPE;
  today      EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq  PLS_INTEGER;
  j_id       EMPLOYEES.JOB_ID%TYPE;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, JOB_ID INTO h_date, j_id
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = eval_frequency.emp_id;
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
       WHEN 'PU_CLERK' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 8% salary increase for employee # ' || emp_id);
       WHEN 'SH_CLERK' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 7% salary increase for employee # ' || emp_id);
       WHEN 'ST_CLERK' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 6% salary increase for employee # ' || emp_id);
       WHEN 'HR_REP' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 5% salary increase for employee # ' || emp_id);
       WHEN 'PR_REP' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 5% salary increase for employee # ' || emp_id);
       WHEN 'MK_REP' THEN DBMS_OUTPUT.PUT_LINE(
         'Consider 4% salary increase for employee # ' || emp_id);
       ELSE DBMS_OUTPUT.PUT_LINE(
         'Nothing to do for employee #' || emp_id);
    END CASE;
  ELSE
    eval_freq := 2;
  END IF;
  RETURN eval_freq;
END eval_frequency;
```
**See Also:**
- “Using CASE Expressions in Queries”
**
- Oracle Database PL/SQL Language Reference for the syntax of the CASE statement
**
- Oracle Database PL/SQL Language Reference for more information about using the CASE statement
## Using the FOR LOOP Statement
The FOR LOOP statement repeats a sequence of statements once for each integer in the range lower_bound through upper_bound.
The syntax of the FOR LOOP is:
```
FOR counter IN lower_bound..upper_bound LOOP
  statement [, statement ]...
END LOOP;
```
The statements between LOOP and END LOOP can use counter, but cannot change its value.
Suppose that, instead of only suggesting a salary increase, you want the EVAL_FREQUENCY function to report what the salary would be if it increased by the suggested amount every year for five years.
Change the EVAL_FREQUENCY function as shown in Example 5-6. (For information about the procedure that prints the strings, `DBMS_OUTPUT.PUT_LINE`, see *Oracle Database PL/SQL Packages and Types Reference*.) **Example 5-6 FOR LOOP Statement that Computes Salary After Five Years**
```
FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date      EMPLOYEES.HIRE_DATE%TYPE;
  today       EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq   PLS_INTEGER;
  j_id        EMPLOYEES.JOB_ID%TYPE;
  sal         EMPLOYEES.SALARY%TYPE;
  sal_raise   NUMBER(3,3) := 0;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, JOB_ID, SALARY INTO h_date, j_id, sal
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = eval_frequency.emp_id;
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
      WHEN 'PU_CLERK' THEN sal_raise :=
0.08;
      WHEN 'SH_CLERK' THEN sal_raise := 0.07;
      WHEN 'ST_CLERK' THEN sal_raise := 0.06;
      WHEN 'HR_REP'   THEN sal_raise := 0.05;
      WHEN 'PR_REP'   THEN sal_raise := 0.05;
      WHEN 'MK_REP'   THEN sal_raise := 0.04;
      ELSE NULL;
    END CASE;
    IF (sal_raise != 0) THEN
      BEGIN
        DBMS_OUTPUT.PUT_LINE('If salary ' || sal || ' increases by ' ||
          ROUND((sal_raise * 100),0) ||
          '% each year for 5 years, it will be:');
        FOR i IN 1..5 LOOP
          sal := sal * (1 + sal_raise);
          DBMS_OUTPUT.PUT_LINE(ROUND(sal, 2) || ' after ' || i || ' year(s)');
        END LOOP;
      END;
    END IF;
  ELSE
    eval_freq := 2;
  END IF;
  RETURN eval_freq;
END eval_frequency;
```
**See Also:** **
- Oracle Database PL/SQL Language Reference for the syntax of the FOR LOOP statement
**
- Oracle Database PL/SQL Language Reference for more information about using the FOR LOOP statement
## Using the WHILE LOOP Statement
The WHILE LOOP statement repeats a sequence of statements while a condition is TRUE.
The syntax of the WHILE LOOP statement is:
```
WHILE condition LOOP
  statement [, statement ]...
END LOOP;
```
**Note:**   If the statements between LOOP and END LOOP never cause condition to become FALSE, then the WHILE LOOP statement runs indefinitely.
Suppose that the EVAL_FREQUENCY function uses the WHILE LOOP statement instead of the FOR LOOP statement and ends after the proposed salary exceeds the maximum salary for the JOB_ID.
Change the EVAL_FREQUENCY function as shown in Example 5-7. (For information about the procedures that prints the strings, DBMS_OUTPUT.PUT_LINE, see *Oracle Database PL/SQL Packages and Types Reference*.) **Example 5-7 WHILE LOOP Statement that Computes Salary to Maximum**
```
FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date      EMPLOYEES.HIRE_DATE%TYPE;
  today       EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq   PLS_INTEGER;
  j_id        EMPLOYEES.JOB_ID%TYPE;
  sal         EMPLOYEES.SALARY%TYPE;
  sal_raise   NUMBER(3,3) := 0;
  sal_max     JOBS.MAX_SALARY%TYPE;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, j.JOB_ID, SALARY, MAX_SALARY INTO h_date, j_id, sal, sal_max
  FROM EMPLOYEES e, JOBS j
  WHERE EMPLOYEE_ID = eval_frequency.emp_id AND JOB_ID = eval_frequency.j_id;
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
      WHEN 'PU_CLERK' THEN sal_raise := 0.08;
      WHEN 'SH_CLERK' THEN sal_raise := 0.07;
      WHEN 'ST_CLERK' THEN sal_raise := 0.06;
      WHEN 'HR_REP'   THEN sal_raise := 0.05;
      WHEN 'PR_REP'   THEN sal_raise := 0.05;
      WHEN 'MK_REP'   THEN sal_raise := 0.04;
      ELSE NULL;
    END CASE;
    IF (sal_raise != 0) THEN
      BEGIN
        DBMS_OUTPUT.PUT_LINE('If salary ' || sal || ' increases by ' ||
          ROUND((sal_raise * 100),0) ||
          '% each year, it will be:');
        WHILE sal <= sal_max LOOP
          sal := sal * (1 + sal_raise);
          DBMS_OUTPUT.PUT_LINE(ROUND(sal, 2));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Maximum salary for this job is ' || sal_max);
      END;
    END IF;
  ELSE
    eval_freq := 2;
  END IF;
  RETURN eval_freq;
END eval_frequency;
```
**See Also:** **
- Oracle Database PL/SQL Language Reference for the syntax of the WHILE LOOP statement
**
- Oracle Database PL/SQL Language Reference for more information about using the WHILE LOOP statement
## Using the Basic LOOP and EXIT WHEN Statements
The basic LOOP statement repeats a sequence of statements.
The syntax of the basic LOOP statement is:
```
LOOP
  statement [, statement ]...
END LOOP;
```
At least one statement must be an EXIT statement; otherwise, the LOOP statement runs indefinitely.
The EXIT WHEN statement (the EXIT statement with its optional WHEN clause) exits a loop when a condition is TRUE and transfers control to the end of the loop.
In the EVAL_FREQUENCY function, in the last iteration of the WHILE LOOP statement, the last computed value usually exceeds the maximum salary.
Change the WHILE LOOP statement to a basic LOOP statement that includes an EXIT WHEN statement, as in Example 5-8.
**Example 5-8 Using the EXIT WHEN Statement**
```
FUNCTION eval_frequency (emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
  RETURN PLS_INTEGER
AS
  h_date      EMPLOYEES.HIRE_DATE%TYPE;
  today       EMPLOYEES.HIRE_DATE%TYPE;
  eval_freq   PLS_INTEGER;
  j_id        EMPLOYEES.JOB_ID%TYPE;
  sal         EMPLOYEES.SALARY%TYPE;
  sal_raise   NUMBER(3,3) := 0;
  sal_max     JOBS.MAX_SALARY%TYPE;
BEGIN
  SELECT SYSDATE INTO today FROM DUAL;
  SELECT HIRE_DATE, j.JOB_ID, SALARY, MAX_SALARY INTO h_date, j_id, sal, sal_max
  FROM EMPLOYEES e, JOBS j
  WHERE EMPLOYEE_ID = eval_frequency.emp_id AND JOB_ID = eval_frequency.j_id;
  IF ((h_date + (INTERVAL '12' MONTH)) < today) THEN
    eval_freq := 1;
    CASE j_id
      WHEN 'PU_CLERK' THEN sal_raise := 0.08;
      WHEN 'SH_CLERK' THEN sal_raise := 0.07;
      WHEN 'ST_CLERK' THEN sal_raise := 0.06;
      WHEN 'HR_REP'   THEN sal_raise := 0.05;
      WHEN 'PR_REP'   THEN sal_raise := 0.05;
      WHEN 'MK_REP'   THEN sal_raise := 0.04;
      ELSE NULL;
    END CASE;
    IF (sal_raise != 0) THEN
      BEGIN
        DBMS_OUTPUT.PUT_LINE('If salary ' || sal || ' increases by ' ||
          ROUND((sal_raise * 100),0) ||
          '% each year, it will be:');
        LOOP
          sal := sal * (1 + sal_raise);
          EXIT WHEN sal > sal_max;
          DBMS_OUTPUT.PUT_LINE(ROUND(sal,2));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Maximum salary for this job is ' || sal_max);
      END;
    END IF;
  ELSE
    eval_freq := 2;
  END IF;
  RETURN eval_freq;
END eval_frequency;
```
**See Also:** **
- Oracle Database PL/SQL Language Reference for the syntax of the LOOP statement
**
- Oracle Database PL/SQL Language Reference for the syntax of the EXIT statement
**
- Oracle Database PL/SQL Language Reference for more information about using the LOOP and EXIT statements
