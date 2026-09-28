# Creating the admin_pkg Package

This section shows how to create the admin_pkg package, how its subprograms work, how to grant the execute privilege on the package to the user who needs it, and how that user can invoke one of its subprograms.
## To create the admin_pkg package:
- Connect to Oracle Database as user app_admin. For instructions, see either “Connecting to Oracle Database from SQL*Plus” or “Connecting to Oracle Database from SQL Developer”.
```
 CREATE SYNONYM departments FOR app_data.departments;
 CREATE SYNONYM jobs FOR app_data.jobs;
 CREATE SYNONYM departments_sequence FOR app_data.departments_sequence;
```
- Create the following synonyms: You can enter the CREATE SYNONYM statements either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the tables with the SQL Developer tool Create Synonym.
- Create the package specification.
- Create the package body.
**See Also:**
- “Creating and Managing Synonyms”
- “About Packages”
## Creating the Package Specification for admin_pkg
**Note:**   You must be connected to Oracle Database as user app_admin.
To create the package specification for admin_pkg, the API for application administrators, use the following CREATE PACKAGE statement. You can enter the statement either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the package with the SQL Developer tool Create Package.
```
CREATE OR REPLACE PACKAGE admin_pkg
AS
  PROCEDURE update_job
    ( p_job_id      IN jobs.job_id%TYPE,
      p_job_title   IN jobs.job_title%TYPE := NULL,
      p_min_salary  IN jobs.min_salary%TYPE := NULL,
      p_max_salary  IN jobs.max_salary%TYPE := NULL );
  PROCEDURE add_job
    ( p_job_id      IN jobs.job_id%TYPE,
      p_job_title   IN jobs.job_title%TYPE,
      p_min_salary  IN jobs.min_salary%TYPE,
      p_max_salary  IN jobs.max_salary%TYPE );
  PROCEDURE update_department
    ( p_department_id     IN departments.department_id%TYPE,
      p_department_name   IN departments.department_name%TYPE := NULL,
      p_manager_id        IN departments.manager_id%TYPE := NULL,
      p_update_manager_id IN BOOLEAN := FALSE );
  FUNCTION add_department
    ( p_department_name   IN departments.department_name%TYPE,
      p_manager_id        IN departments.manager_id%TYPE )
    RETURN departments.department_id%TYPE;
END admin_pkg;
/
```
**See Also:**
- “About the Application”
- “Creating and Managing Packages”
**
- Oracle Database PL/SQL Language Reference for information about the CREATE PACKAGE statement
## Creating the Package Body for admin_pkg
**Note:**   You must be connected to Oracle Database as user app_admin.
To create the package body for admin_pkg, the API for application administrators, use the following CREATE PACKAGE BODY statement. You can enter the statement either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the package with the SQL Developer tool Create Body.
```
CREATE OR REPLACE PACKAGE BODY admin_pkg
AS
  PROCEDURE update_job
    ( p_job_id      IN jobs.job_id%TYPE,
      p_job_title   IN jobs.job_title%TYPE := NULL,
      p_min_salary  IN jobs.min_salary%TYPE := NULL,
      p_max_salary  IN jobs.max_salary%TYPE := NULL )
  IS
  BEGIN
    UPDATE jobs
    SET job_title  = NVL( p_job_title, job_title ),
        min_salary = NVL( p_min_salary, min_salary ),
        max_salary = NVL( p_max_salary, max_salary )
    WHERE job_id = p_job_id;
  END update_job;
  PROCEDURE add_job
    ( p_job_id      IN jobs.job_id%TYPE,
      p_job_title   IN jobs.job_title%TYPE,
      p_min_salary  IN jobs.min_salary%TYPE,
      p_max_salary  IN jobs.max_salary%TYPE )
  IS
  BEGIN
    INSERT INTO jobs ( job_id, job_title, min_salary, max_salary )
    VALUES ( p_job_id, p_job_title, p_min_salary, p_max_salary );
  END add_job;
  PROCEDURE update_department
    ( p_department_id     IN departments.department_id%TYPE,
      p_department_name   IN departments.department_name%TYPE := NULL,
      p_manager_id        IN departments.manager_id%TYPE := NULL,
      p_update_manager_id IN BOOLEAN := FALSE )
  IS
  BEGIN
    IF ( p_update_manager_id ) THEN
      UPDATE departments
      SET department_name = NVL( p_department_name, department_name ),
          manager_id = p_manager_id
      WHERE department_id = p_department_id;
    ELSE
      UPDATE departments
      SET department_name = NVL( p_department_name, department_name )
      WHERE department_id = p_department_id;
    END IF;
  END update_department;
  FUNCTION add_department
    ( p_department_name   IN departments.department_name%TYPE,
      p_manager_id        IN departments.manager_id%TYPE )
    RETURN departments.department_id%TYPE
  IS
    l_department_id departments.department_id%TYPE;
  BEGIN
    INSERT INTO departments ( department_id, department_name, manager_id )
      VALUES ( departments_sequence.NEXTVAL, p_department_name, p_manager_id )
      RETURNING department_id INTO l_department_id;
    RETURN l_department_id;
  END add_department;
END admin_pkg;
/
```
**See Also:**
- “About the Application”
- “Creating and Managing Packages”
**
- Oracle Database PL/SQL Language Reference for information about the CREATE PACKAGE BODY statement
## Tutorial: Showing How the admin_pkg Subprograms Work
Using SQL*Plus, this tutorial shows how the subprograms of the admin_pkg package work. The tutorial also shows how the trigger jobs_aufer works.
**Note:**   You must be connected to Oracle Database as user app_admin from SQL*Plus.
**Steps to show how the admin_pkg subprograms work:**
```
 SELECT * FROM jobs WHERE job_id = 'AD_VP';
```
```
 JOB_ID     JOB_TITLE                           MIN_SALARY MAX_SALARY
 ---------- ----------------------------------- ---------- ----------
 AD_VP      Administration Vice President            15000      30000
```
- Show the information about the job whose ID is AD_VP: Result:
```
 EXEC admin_pkg.update_job( 'AD_VP', p_max_salary => 31000 );
 SELECT * FROM jobs WHERE job_id = 'AD_VP';
```
```
 JOB_ID     JOB_TITLE                           MIN_SALARY MAX_SALARY
 ---------- ----------------------------------- ---------- ----------
 AD_VP      Administration Vice President            15000      31000
```
- Increase the maximum salary for this job and show the information about it again: Result:
```
 SELECT * FROM jobs WHERE job_id = 'IT_PROG';
```
```
 JOB_ID     JOB_TITLE                           MIN_SALARY MAX_SALARY
 ---------- ----------------------------------- ---------- ----------
 IT_PROG    Programmer                                4000      10000
```
- Show the information about the job whose ID is IT_PROG: Result:
```
 EXEC admin_pkg.update_job( 'IT_PROG', p_max_salary => 4001 );
```
```
 SQL> EXEC admin_pkg.update_job( 'IT_PROG', p_max_salary => 4001 );
 BEGIN admin_pkg.update_job( 'IT_PROG', p_max_salary => 4001 ); END;
 *
 ERROR at line 1:
 ORA-20001: Salary update would violate 5 existing employee records
 ORA-06512: at "APP_DATA.JOBS_AUFER", line 12
 ORA-04088: error during execution of trigger 'APP_DATA.JOBS_AUFER'
 ORA-06512: at "APP_ADMIN.ADMIN_PKG", line 10
 ORA-06512: at line 1
```
- Try to increase the maximum salary for this job: Result (from SQL*Plus):
```
 EXEC admin_pkg.add_job( 'AD_CLERK', 'Administrative Clerk', 3000, 7000 );
 SELECT * FROM jobs WHERE job_id = 'AD_CLERK';
```
```
 JOB_ID     JOB_TITLE                           MIN_SALARY MAX_SALARY
 ---------- ----------------------------------- ---------- ----------
 AD_CLERK   Administrative Clerk                      3000       7000
```
- Add a new job and show the information about it: Result:
```
 SELECT * FROM departments WHERE department_id = 100;
```
```
 DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID
 ------------- ------------------------------ ----------
           100 Finance                               108
```
- Show the information about department 100: Result:
```
 EXEC admin_pkg.update_department( 100, 'Financial Services' );
 EXEC admin_pkg.update_department( 100, p_manager_id => 111,
   p_update_manager_id => true );
 SELECT * FROM departments WHERE department_id = 100;
```
```
 DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID
 ------------- ------------------------------ ----------
           100 Financial Services                    111
```
- Change the name and manager of department 100 and show the information about it: Result:
**See Also:**   “Creating and Managing Packages”
## Granting the Execute Privilege to app_admin_user
**Note:**   You must be connected to Oracle Database as user app_admin.
To grant the execute privilege on the package admin_pkg to app_admin_user (an application administrator), use the following GRANT statement. You can enter the statement either in SQL*Plus or in the Worksheet of SQL Developer.
```
GRANT EXECUTE ON admin_pkg TO app_admin_user;
```
**See Also:**
- “Schemas for the Application”
**
- Oracle Database SQL Language Reference for information about the GRANT statement
## Tutorial: Invoking add_department as app_admin_user
Using SQL*Plus, this tutorial shows how to invoke the function app_admin.admin_pkg.add_department as the user app_admin_user (an application administrator) and then see the information about the new department.
**Steps to invoke admin_pkg.add_department as app_admin_user:**
- Connect to Oracle Database as user app_admin_user from SQL*Plus. For instructions, see “Connecting to Oracle Database from SQL*Plus”.
```
 CREATE SYNONYM admin_pkg FOR app_admin.admin_pkg;
```
- Create this synonym:
```
 VARIABLE n NUMBER
```
- Declare a bind variable for the return value of the function:
```
 EXEC :n := admin_pkg.add_department( 'New department', NULL );
```
- Add a new department without a manager:
```
 PRINT :n
```
```
         N
 ----------
       275
```
- Show the ID of the manager of the new department: Result:
**Steps to see the information about the new department:**
- Connect to Oracle Database as user app_admin.
```
 SELECT * FROM departments WHERE department_name LIKE 'New department%';
```
```
 DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID
 ------------- ------------------------------ ----------
           275 New department
```
- Show the information about the new department: Result:
