# Creating the employees_pkg Package

This section shows how to create the employees_pkg package, how its subprograms work, how to grant the execute privilege on the package to the users who need it, and how those users can invoke one of its subprograms.
## Steps to create the employees_pkg package:
- Connect to Oracle Database as user app_code. For instructions, see either “Connecting to Oracle Database from SQL*Plus” or “Connecting to Oracle Database from SQL Developer”.
```
 CREATE OR REPLACE SYNONYM employees FOR app_data.employees;
 CREATE OR REPLACE SYNONYM departments FOR app_data.departments;
 CREATE OR REPLACE SYNONYM jobs FOR app_data.jobs;
 CREATE OR REPLACE SYNONYM job_history FOR app_data.job_history;
```
- Create these synonyms: You can enter the CREATE SYNONYM statements either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the synonyms with the SQL Developer tool Create Synonym.
- Create the package specification.
- Create the package body.
**See Also:**
- “Creating Synonyms”
- “About Packages”
## Creating the Package Specification for employees_pkg
**Note:**   You must be connected to Oracle Database as user app_code.
To create the package specification for employees_pkg, the API for managers, use the following CREATE PACKAGE statement. You can enter the statement either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the package with the SQL Developer tool Create Package.
```
CREATE OR REPLACE PACKAGE employees_pkg
AS
  PROCEDURE get_employees_in_dept
    ( p_deptno     IN     employees.department_id%TYPE,
      p_result_set IN OUT SYS_REFCURSOR );
  PROCEDURE get_job_history
    ( p_employee_id  IN     employees.department_id%TYPE,
      p_result_set   IN OUT SYS_REFCURSOR );
  PROCEDURE show_employee
    ( p_employee_id  IN     employees.employee_id%TYPE,
      p_result_set   IN OUT SYS_REFCURSOR );
  PROCEDURE update_salary
    ( p_employee_id IN employees.employee_id%TYPE,
      p_new_salary  IN employees.salary%TYPE );
  PROCEDURE change_job
    ( p_employee_id IN employees.employee_id%TYPE,
      p_new_job     IN employees.job_id%TYPE,
      p_new_salary  IN employees.salary%TYPE := NULL,
      p_new_dept    IN employees.department_id%TYPE := NULL );
END employees_pkg;
/
```
**See Also:**
- “About the Application”
- “Creating and Managing Packages”
**
- Oracle Database PL/SQL Language Reference for information about the CREATE PACKAGE statement
## Creating the Package Body for employees_pkg
**Note:**   You must be connected to Oracle Database as user app_code.
To create the package body for employees_pkg, the API for managers, use the following CREATE PACKAGE BODY statement. You can enter the statement either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the package with the SQL Developer tool Create Body.
```
CREATE OR REPLACE PACKAGE BODY employees_pkg
AS
  PROCEDURE get_employees_in_dept
    ( p_deptno     IN     employees.department_id%TYPE,
      p_result_set IN OUT SYS_REFCURSOR )
  IS
     l_cursor SYS_REFCURSOR;
  BEGIN
    OPEN p_result_set FOR
      SELECT e.employee_id,
        e.first_name || ' ' || e.last_name name,
        TO_CHAR( e.hire_date, 'Dy Mon ddth, yyyy' ) hire_date,
        j.job_title,
        m.first_name || ' ' || m.last_name manager,
        d.department_name
      FROM employees e INNER JOIN jobs j ON (e.job_id = j.job_id)
        LEFT OUTER JOIN employees m ON (e.manager_id = m.employee_id)
        INNER JOIN departments d ON (e.department_id = d.department_id)
      WHERE e.department_id = p_deptno ;
  END get_employees_in_dept;
  PROCEDURE get_job_history
    ( p_employee_id  IN     employees.department_id%TYPE,
      p_result_set   IN OUT SYS_REFCURSOR )
  IS
  BEGIN
    OPEN p_result_set FOR
      SELECT e.First_name || ' ' || e.last_name name, j.job_title,
        e.job_start_date start_date,
        TO_DATE(NULL) end_date
      FROM employees e INNER JOIN jobs j ON (e.job_id = j.job_id)
      WHERE e.employee_id = p_employee_id
      UNION ALL
      SELECT e.First_name || ' ' || e.last_name name,
        j.job_title,
        jh.start_date,
        jh.end_date
      FROM employees e INNER JOIN job_history jh
        ON (e.employee_id = jh.employee_id)
        INNER JOIN jobs j ON (jh.job_id = j.job_id)
      WHERE e.employee_id = p_employee_id
      ORDER BY start_date DESC;
  END get_job_history;
  PROCEDURE show_employee
    ( p_employee_id  IN     employees.employee_id%TYPE,
      p_result_set   IN OUT sys_refcursor )
  IS
  BEGIN
    OPEN p_result_set FOR
      SELECT *
      FROM (SELECT TO_CHAR(e.employee_id) employee_id,
              e.first_name || ' ' || e.last_name name,
              e.email_addr,
              TO_CHAR(e.hire_date,'dd-mon-yyyy') hire_date,
              e.country_code,
              e.phone_number,
              j.job_title,
              TO_CHAR(e.job_start_date,'dd-mon-yyyy') job_start_date,
              to_char(e.salary) salary,
              m.first_name || ' ' || m.last_name manager,
              d.department_name
            FROM employees e INNER JOIN jobs j on (e.job_id = j.job_id)
              RIGHT OUTER JOIN employees m ON (m.employee_id = e.manager_id)
              INNER JOIN departments d ON (e.department_id = d.department_id)
            WHERE e.employee_id = p_employee_id)
      UNPIVOT (VALUE FOR ATTRIBUTE IN (employee_id, name, email_addr, hire_date,
        country_code, phone_number, job_title, job_start_date, salary, manager,
        department_name) );
  END show_employee;
  PROCEDURE update_salary
    ( p_employee_id IN employees.employee_id%type,
      p_new_salary  IN employees.salary%type )
  IS
  BEGIN
    UPDATE employees
    SET salary = p_new_salary
    WHERE employee_id = p_employee_id;
  END update_salary;
  PROCEDURE change_job
    ( p_employee_id IN employees.employee_id%TYPE,
      p_new_job     IN employees.job_id%TYPE,
      p_new_salary  IN employees.salary%TYPE := NULL,
      p_new_dept    IN employees.department_id%TYPE := NULL )
  IS
  BEGIN
    INSERT INTO job_history (employee_id, start_date, end_date, job_id,
      department_id)
    SELECT employee_id, job_start_date, TRUNC(SYSDATE), job_id, department_id
      FROM employees
      WHERE employee_id = p_employee_id;
    UPDATE employees
    SET job_id = p_new_job,
      department_id = NVL( p_new_dept, department_id ),
      salary = NVL( p_new_salary, salary ),
      job_start_date = TRUNC(SYSDATE)
    WHERE employee_id = p_employee_id;
  END change_job;
END employees_pkg;
/
```
**See Also:**
- “About the Application”
- “Creating and Managing Packages”
**
- Oracle Database PL/SQL Language Reference for information about the CREATE PACKAGE BODY statement
## Tutorial: Showing How the employees_pkg Subprograms Work
Using SQL*Plus, this tutorial shows how the subprograms of the employees_pkg package work. The tutorial also shows how the trigger employees_aiufer and the CHECK constraint job_history_date_check work.
**Note:**   You must be connected to Oracle Database as user app_code from SQL*Plus.
**To use SQL*Plus to show how the employees_pkg subprograms work:**
```
 SET LINESIZE 80
 SET RECSEP WRAPPED
 SET RECSEPCHAR "="
 COLUMN NAME FORMAT A15 WORD_WRAPPED
 COLUMN HIRE_DATE FORMAT A20 WORD_WRAPPED
 COLUMN DEPARTMENT_NAME FORMAT A10 WORD_WRAPPED
 COLUMN JOB_TITLE FORMAT A29 WORD_WRAPPED
 COLUMN MANAGER FORMAT A11 WORD_WRAPPED
```
- Use formatting commands to improve the readability of the output. For example:
```
 VARIABLE c REFCURSOR
```
- Declare a bind variable for the value of the subprogram parameter p_result_set:
```
 EXEC employees_pkg.get_employees_in_dept( 90, :c );
 PRINT c
```
```
 EMPLOYEE_ID NAME            HIRE_DATE            JOB_TITLE
 ----------- --------------- -------------------- --------------------------
 MANAGER     DEPARTMENT
 ----------- ----------
         100 Steven King     Tue Jun 17th, 2003   President
             Executive                                                         ===========================================================================
         102 Lex De Haan     Sat Jan 13th, 2001   Administration Vice President
 Steven King Executive
 ===========================================================================
         101 Neena Kochhar   Wed Sep 21st, 2005   Administration Vice President
 Steven King Executive
 ===========================================================================
```
- Show the employees in department 90: Result:
```
 EXEC employees_pkg.get_job_history( 101, :c );
 PRINT c
```
```
 NAME            JOB_TITLE                     START_DAT END_DATE
 --------------- ----------------------------- --------- ---------
 Neena Kochhar   Administration Vice President 16-MAR-05
 Neena Kochhar   Accounting Manager            28-OCT-01 15-MAR-05
 Neena Kochhar   Public Accountant             21-SEP-97 27-OCT-01
```
- Show the job history of employee 101: Result:
```
 EXEC employees_pkg.show_employee( 101, :c );
 PRINT c
```
```
 ATTRIBUTE       VALUE
 --------------- ----------------------------------------------
 EMPLOYEE_ID     101
 NAME            Neena Kochhar
 EMAIL_ADDR      NKOCHHAR
 HIRE_DATE       21-sep-2005
 COUNTRY_CODE    +1
 PHONE_NUMBER    515.123.4568
 JOB_TITLE       Administration Vice President
 JOB_START_DATE  16-mar-05
 SALARY          17000
 MANAGER         Steven King
 DEPARTMENT_NAME Executive
 11 rows selected.
```
- Show general information about employee 101: Result:
```
 SELECT * FROM jobs WHERE job_title = 'Administration Vice President';
```
```
 JOB_ID     JOB_TITLE                     MIN_SALARY MAX_SALARY
 ---------- ----------------------------- ---------- ----------
 AD_VP      Administration Vice President      15000      30000
```
- Show the information about the job Administration Vice President: Result:
```
 EXEC employees_pkg.update_salary( 101, 30001 );
```
```
 SQL> EXEC employees_pkg.update_salary( 101, 30001 );
 BEGIN employees_pkg.update_salary( 101, 30001 ); END;
 *
 ERROR at line 1:
 ORA-20002: Salary modification invalid
 ORA-06512: at "APP_DATA.EMPLOYEES_AIUFER", line 13
 ORA-04088: error during execution of trigger 'APP_DATA.EMPLOYEES_AIUFER'
 ORA-06512: at "APP_CODE.EMPLOYEES_PKG", line 77
 ORA-06512: at line 1
```
- Try to give employee 101 a new salary outside the range for her job: Result:
```
 EXEC employees_pkg.update_salary( 101, 18000 );
 EXEC employees_pkg.show_employee( 101, :c );
 PRINT c
```
```
 ATTRIBUTE       VALUE
 --------------- ----------------------------------------------
 EMPLOYEE_ID     101
 NAME            Neena Kochhar
 EMAIL_ADDR      NKOCHHAR
 HIRE_DATE       21-sep-2005
 COUNTRY_CODE    +1
 PHONE_NUMBER    515.123.4568
 JOB_TITLE       Administration Vice President
 JOB_START_DATE  16-mar-05
 SALARY          18000
 MANAGER         Steven King
 DEPARTMENT_NAME Executive
 11 rows selected.
```
- Give employee 101 a new salary inside the range for her job and show general information about her again: Result:
```
 EXEC employees_pkg.change_job( 101, 'AD_VP', 17500, 90 );
```
```
 SQL> exec employees_pkg.change_job( 101, 'AD_VP', 17500, 90 );
 BEGIN employees_pkg.change_job( 101, 'AD_VP', 17500, 80 ); END;
 *
 ERROR at line 1:
 ORA-02290: check constraint (APP_DATA.JOB_HISTORY_DATE_CHECK) violated
 ORA-06512: at "APP_CODE.EMPLOYEES_PKG", line 101
 ORA-06512: at line 1
```
- Change the job of employee 101 to her current job with a lower salary: Result:
```
exec employees_pkg.show_employee( 101, :c );
print c
```
```
ATTRIBUTE       VALUE
--------------- ----------------------------------------------
EMPLOYEE_ID     101
NAME            Neena Kochhar
EMAIL_ADDR      NKOCHHAR
HIRE_DATE       21-sep-2005
COUNTRY_CODE    +1
PHONE_NUMBER    515.123.4568
JOB_TITLE       Administration Vice President
JOB_START_DATE  10-mar-2015
SALARY          18000
MANAGER         Steven King
DEPARTMENT_NAME Executive
11 rows selected.
```
- Show information about the employee. (Note that the salary was not changed by the statement in the preceding step; it is 18000, not 17500.) Result:
**See Also:** **
- SQL*Plus User’s Guide and Reference for information about SQL*Plus commands
- “Creating and Managing Packages”
## Granting the Execute Privilege to app_user and app_admin_user
**Note:**   You must be connected to Oracle Database as user app_code.
To grant the execute privilege on the package employees_pkg to app_user (typically a manager) and app_admin_user (an application administrator), use the following GRANT statements (in either order). You can enter the statements either in SQL*Plus or in the Worksheet of SQL Developer.
```
GRANT EXECUTE ON employees_pkg TO app_user;
GRANT EXECUTE ON employees_pkg TO app_admin_user;
```
**See Also:**
- “Schemas for the Application”
**
- Oracle Database SQL Language Reference for information about the GRANT statement
## Tutorial: Invoking get_job_history as app_user or app_admin_user
Using SQL*Plus, this tutorial shows how to invoke the subprogram app_code.employees_pkg.get_job_history as the user app_user (typically a manager) or app_admin_user (an application administrator).
**Steps to invoke employees_pkg.get_job_history as app_user or app_admin_user:**
- Connect to Oracle Database as user app_user or app_admin_user from SQL*Plus. For instructions, see “Connecting to Oracle Database from SQL*Plus”.
```
 CREATE SYNONYM employees_pkg FOR app_code.employees_pkg;
```
- Create this synonym:
```
 EXEC employees_pkg.get_job_history( 101, :c );
 PRINT c
```
```
 NAME            JOB_TITLE                     START_DAT END_DATE
 --------------- ----------------------------- --------- ---------
 Neena Kochhar   Administration Vice President 16-MAR-05 15-MAY-12
 Neena Kochhar   Accounting Manager            28-OCT-01 15-MAR-05
 Neena Kochhar   Public Accountant             21-SEP-97 27-OCT-01
```
- Show the job history of employee 101: Result:
