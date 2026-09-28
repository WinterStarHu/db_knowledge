# Creating the Schema Objects and Loading the Data

This section shows how to create the tables, editioning views, triggers, and sequences for the application, how to load data into the tables, and how to grant privileges on these schema objects to the users that need them.
## Steps to create the schema objects and load the data:
- Connect to Oracle Database as user app_data. For instructions, see either “Connecting to Oracle Database from SQL*Plus” or “Connecting to Oracle Database from SQL Developer”.
- Create the tables, with all necessary constraints except the foreign key constraint that you must add after you load the data.
- Create the editioning views.
- Create the triggers.
- Create the sequences.
- Load the data into the tables.
- Add the foreign key constraint.
## Creating the Tables
This section shows how to create the tables for the application, with all necessary constraints except one, which you must add after you load the data.
**Note:**   You must be connected to Oracle Database as user `app_data`.
In the following procedure, you can enter the statements either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the tables with the SQL Developer tool Create Table.
**Steps to create the tables:**
```
 CREATE TABLE jobs#
 ( job_id      VARCHAR2(10)
               CONSTRAINT jobs_pk PRIMARY KEY,
   job_title   VARCHAR2(35)
               CONSTRAINT jobs_job_title_not_null NOT NULL,
   min_salary  NUMBER(6)
               CONSTRAINT jobs_min_salary_not_null NOT NULL,
   max_salary  NUMBER(6)
               CONSTRAINT jobs_max_salary_not_null NOT NULL
 )
 /
```
- Create jobs#, which stores information about the jobs in the company (one row for each job):
```
 CREATE TABLE departments#
 ( department_id    NUMBER(4)
                   CONSTRAINT departments_pk PRIMARY KEY,
   department_name  VARCHAR2(30)
                   CONSTRAINT department_name_not_null NOT NULL
                   CONSTRAINT department_name_unique UNIQUE,
   manager_id       NUMBER(6)
 )
 /
```
- Create departments#, which stores information about the departments in the company (one row for each department):
```
 CREATE TABLE employees#
 ( employee_id     NUMBER(6)
                   CONSTRAINT employees_pk PRIMARY KEY,
   first_name      VARCHAR2(20)
                   CONSTRAINT emp_first_name_not_null NOT NULL,
   last_name       VARCHAR2(25)
                   CONSTRAINT emp_last_name_not_null NOT NULL,
   email_addr      VARCHAR2(25)
                   CONSTRAINT emp_email_addr_not_null NOT NULL,
   hire_date       DATE
                   DEFAULT TRUNC(SYSDATE)
                   CONSTRAINT emp_hire_date_not_null NOT NULL
                   CONSTRAINT emp_hire_date_check
                     CHECK(TRUNC(hire_date) = hire_date),
   country_code    VARCHAR2(5)
                   CONSTRAINT emp_country_code_not_null NOT NULL,
   phone_number    VARCHAR2(20)
                   CONSTRAINT emp_phone_number_not_null NOT NULL,
   job_id          CONSTRAINT emp_job_id_not_null NOT NULL
                   CONSTRAINT emp_jobs_fk REFERENCES jobs#,
   job_start_date  DATE
                   CONSTRAINT emp_job_start_date_not_null NOT NULL,
                   CONSTRAINT emp_job_start_date_check
                     CHECK(TRUNC(JOB_START_DATE) = job_start_date),
   salary          NUMBER(6)
                   CONSTRAINT emp_salary_not_null NOT NULL,
   manager_id      CONSTRAINT emp_mgr_to_empno_fk REFERENCES employees#,
   department_id   CONSTRAINT emp_to_dept_fk REFERENCES departments#
 )
 /
```
  - An employee must have an existing job. That is, values in the column employees#.job_id must also be values in the column jobs#.job_id.
  - An employee must have a manager who is also an employee. That is, values in the column employees#.manager_id must also be values in the column employees#.employee_id.
  - An employee must work in an existing department. That is, values in the column employees#.department_id must also be values in the column departments#.department_id.
Also, the manager of an employee must be the manager of the department in which the employee works. That is, values in the column employees#.manager_id must also be values in the column departments#.manager_id. However, you could not specify the necessary constraint when you created departments#, because employees# did not exist yet. Therefore, you must add a foreign key constraint to departments# later (see “Adding the Foreign Key Constraint”).
```
 CREATE TABLE job_history#
 ( employee_id  CONSTRAINT job_hist_to_employees_fk REFERENCES employees#,
   job_id       CONSTRAINT job_hist_to_jobs_fk REFERENCES jobs#,
   start_date   DATE
               CONSTRAINT job_hist_start_date_not_null NOT NULL,
   end_date     DATE
               CONSTRAINT job_hist_end_date_not_null NOT NULL,
   department_id
             CONSTRAINT job_hist_to_departments_fk REFERENCES departments#
             CONSTRAINT job_hist_dept_id_not_null NOT NULL,
             CONSTRAINT job_history_pk PRIMARY KEY(employee_id,start_date),
             CONSTRAINT job_history_date_check CHECK( start_date < end_date )
 )
 /
```
  - Values in the column job_history#.employee_id must also be values in the column employees#.employee_id.
  - Values in the column job_history#.job_id must also be values in the column jobs#.job_id.
  - Values in the column job_history#.department_id must also be values in the column departments#.department_id.
**See Also:**   “Creating Tables”
## Creating the Editioning Views
**Note:**   You must be connected to Oracle Database as user app_data.
To create the editioning views, use the following statements (in any order). You can enter the statements either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the editioning views with the SQL Developer tool Create View.
```
CREATE OR REPLACE EDITIONING VIEW jobs AS SELECT * FROM jobs#
/
CREATE OR REPLACE EDITIONING VIEW departments AS SELECT * FROM departments#
/
CREATE OR REPLACE EDITIONING VIEW employees AS SELECT * FROM employees#
/
CREATE OR REPLACE EDITIONING VIEW job_history AS SELECT * FROM job_history#
/
```
**Note:**   The application must always reference the base tables through the editioning views. Otherwise, the editioning views do not cover the tables and you cannot use EBR to upgrade the finished application when it is in use.
**See Also:**
- “Creating Views”
**
- Oracle Database Development Guide for general information about editioning views
**
- Oracle Database Development Guide for information about preparing an application to use editioning views
## Creating the Triggers
**Note:**   You must be connected to Oracle Database as user app_data.
The triggers in the application enforce these business rules:
****
- An employee with job j must have a salary between the minimum and maximum salaries for job j.
************
- If an employee with job j has salary s, then you cannot change the minimum salary for j to a value greater than s or the maximum salary for j to a value less than s. (To do so would make existing data invalid.)
**See Also:**   Using Triggers, for information about triggers
### Creating the Trigger to Enforce the First Business Rule
The first business rule is: An employee with job *j* must have a salary between the minimum and maximum salaries for job *j*.
This rule could be violated either when a new row is inserted into the employees table or when the salary or job_id column of the employees table is updated.
To enforce the rule, create the following trigger on the editioning view employees. You can enter the CREATE TRIGGER statement either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the trigger with the SQL Developer tool Create Trigger.
```
CREATE OR REPLACE TRIGGER employees_aiufer
AFTER INSERT OR UPDATE OF salary, job_id ON employees FOR EACH ROW
DECLARE
  l_cnt NUMBER;
BEGIN
  LOCK TABLE jobs IN SHARE MODE;  -- Ensure that jobs does not change
                                  -- during the following query.
  SELECT COUNT(*) INTO l_cnt
  FROM jobs
  WHERE job_id = :NEW.job_id
  AND :NEW.salary BETWEEN min_salary AND max_salary;
  IF (l_cnt<>1) THEN
    RAISE_APPLICATION_ERROR( -20002,
      CASE
        WHEN :new.job_id = :old.job_id
        THEN 'Salary modification invalid'
        ELSE 'Job reassignment puts salary out of range'
      END );
  END IF;
END;
/
```
`LOCK TABLE jobs IN SHARE MODE` prevents other users from changing the table jobs while the trigger is querying it. Preventing changes to jobs during the query is necessary because nonblocking reads prevent the trigger from “seeing” changes that other users make to jobs while the trigger is changing employees (and prevent those users from “seeing” the changes that the trigger makes to employees).
Another way to prevent changes to jobs during the query is to include the FOR UPDATE clause in the SELECT statement. However, SELECT FOR UPDATE restricts concurrency more than LOCK TABLE jobs IN SHARE MODE does.
`LOCK TABLE jobs IN SHARE MODE` prevents other users from changing jobs, but not from locking jobs in share mode themselves. Changes to jobs will probably be much rarer than changes to employees. Therefore, locking jobs in share mode provides more concurrency than locking a single row of jobs in exclusive mode.
**See Also:** **
- Oracle Database Development Guide for information about locking tables IN SHARE MODE
**
- Oracle Database PL/SQL Language Reference for information about SELECT FOR UPDATE
- “Creating Triggers”
- “Tutorial: Showing How the employees_pkg Subprograms Work” to see how the employees_aiufer trigger works
### Creating the Trigger to Enforce the Second Business Rule
The second business rule is: If an employee with job *j* has salary *s*, then you cannot change the minimum salary for *j* to a value greater than *s* or the maximum salary for *j* to a value less than *s*. (To do so would make existing data invalid.) This rule could be violated when the min_salary or max_salary column of the jobs table is updated.
To enforce the rule, create the following trigger on the editioning view jobs. You can enter the CREATE TRIGGER statement either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the trigger with the SQL Developer tool Create Trigger.
```
CREATE OR REPLACE TRIGGER jobs_aufer
AFTER UPDATE OF min_salary, max_salary ON jobs FOR EACH ROW
WHEN (NEW.min_salary > OLD.min_salary OR NEW.max_salary < OLD.max_salary)
DECLARE
  l_cnt NUMBER;
BEGIN
  LOCK TABLE employees IN SHARE MODE;
  SELECT COUNT(*) INTO l_cnt
  FROM employees
  WHERE job_id = :NEW.job_id
  AND salary NOT BETWEEN :NEW.min_salary and :NEW.max_salary;
  IF (l_cnt>0) THEN
    RAISE_APPLICATION_ERROR( -20001,
      'Salary update would violate ' || l_cnt || ' existing employee records' );
  END IF;
END;
/
```
`LOCK TABLE employees IN SHARE MODE` prevents other users from changing the table employees while the trigger is querying it. Preventing changes to employees during the query is necessary because nonblocking reads prevent the trigger from “seeing” changes that other users make to employees while the trigger is changing jobs (and prevent those users from “seeing” the changes that the trigger makes to jobs).
For this trigger, SELECT FOR UPDATE is not an alternative to LOCK TABLE IN SHARE MODE. While you are trying to change the salary range for this job, this trigger must prevent other users from changing a salary to be outside the new range. Therefore, the trigger must lock all rows in the employees table that have this job_id *and* lock all rows that someone could update to have this job_id.
One alternative to `LOCK TABLE employees IN SHARE MODE` is to use the DBMS_LOCK package to create a named lock with the name of the job_id and then use triggers on both the employees and jobs tables to use this named lock to prevent concurrent updates. However, using DBMS_LOCK and multiple triggers negatively impacts runtime performance.
Another alternative to `LOCK TABLE employees IN SHARE MODE` is to create a trigger on the employees table which, for each changed row of employees, locks the corresponding job row in jobs. However, this approach causes excessive work on updates to the employees table, which are frequent.
`LOCK TABLE employees IN SHARE MODE` is simpler than the preceding alternatives, and changes to the jobs table are rare and likely to happen at application maintenance time, when locking the table does not inconvenience users.
**See Also:** **````
- Oracle Database Development Guide for information about locking tables with SHARE MODE
**
- Oracle Database PL/SQL Packages and Types Reference for information about the DBMS_LOCK package
- “Creating Triggers”
- “Tutorial: Showing How the admin_pkg Subprograms Work”
## Creating the Sequences
**Note:**   You must be connected to Oracle Database as user app_data.
To create the sequences that generate unique primary keys for new departments and new employees, use the following statements (in either order). You can enter the statements either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can create the sequences with the SQL Developer tool Create Sequence.
```
CREATE SEQUENCE employees_sequence START WITH 210;
CREATE SEQUENCE departments_sequence START WITH 275;
```
To avoid conflict with the data that you will load from tables in the sample schema HR, the starting numbers for employees_sequence and departments_sequence must exceed the maximum values of employees.employee_id and departments.department_id, respectively. After “Loading the Data”, this query displays these maximum values:
```
SELECT MAX(e.employee_id), MAX(d.department_id)
FROM employees e, departments d;
```
Result:
```
MAX(E.EMPLOYEE_ID) MAX(D.DEPARTMENT_ID)
------------------ --------------------
               206                  270
```
**See Also:**   “Creating and Managing Sequences”
## Loading the Data
**Note:**   You must be connected to Oracle Database as user app_data.
Load the tables of the application with data from tables in the sample schema HR.
**Note:**   The following procedure references the tables of the application through their editioning views.
In the following procedure, you can enter the statements either in SQL*Plus or in the Worksheet of SQL Developer.
**To load data into the tables:**
```
 INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
 SELECT job_id, job_title, min_salary, max_salary
   FROM HR.JOBS
 /
```
```
 19 rows created.
```
- Load jobs with data from the table HR.JOBS: Result:
```
 INSERT INTO departments (department_id, department_name, manager_id)
 SELECT department_id, department_name, manager_id
   FROM HR.DEPARTMENTS
 /
```
```
 27 rows created.
```
- Load departments with data from the table HR.DEPARTMENTS: Result:
```
 INSERT INTO employees (employee_id, first_name, last_name, email_addr,
   hire_date, country_code, phone_number, job_id, job_start_date, salary,
   manager_id, department_id)
 SELECT employee_id, first_name, last_name, email, hire_date,
   CASE WHEN phone_number LIKE '011.%'
     THEN '+' || SUBSTR( phone_number, INSTR( phone_number, '.' )+1,
       INSTR( phone_number, '.', 1, 2 ) -  INSTR( phone_number, '.' ) - 1 )
     ELSE '+1'
   END country_code,
   CASE WHEN phone_number LIKE '011.%'
     THEN SUBSTR( phone_number, INSTR(phone_number, '.', 1, 2 )+1 )
     ELSE phone_number
   END phone_number,
   job_id,
   NVL( (SELECT MAX(end_date+1)
         FROM HR.JOB_HISTORY jh
         WHERE jh.employee_id = employees.employee_id), hire_date),
   salary, manager_id, department_id
   FROM HR.EMPLOYEES
 /
```
```
 107 rows created.
```
****
- Load employees with data from the tables HR.EMPLOYEES and HR.JOB_HISTORY, using searched CASE expressions and SQL functions to get employees.country_code and employees.phone_number from HR.phone_number and SQL functions and a scalar subquery to get employees.job_start_date from HR.JOB_HISTORY: Result: Note: The preceding INSERT statement fires the trigger created in “Creating the Trigger to Enforce the First Business Rule”.
```
 INSERT INTO job_history (employee_id, job_id, start_date, end_date,
   department_id)
 SELECT employee_id, job_id, start_date, end_date, department_id
   FROM HR.JOB_HISTORY
 /
```
```
 10 rows created.
```
- Load job_history with data from the table HR.JOB_HISTORY: Result:
```
 COMMIT;
```
- Commit the changes:
**See Also:**
- “About the INSERT Statement”
- “About Sample Schema HR”
- “Using CASE Expressions in Queries”
- “Using NULL-Related Functions in Queries” for information about the NVL function
**
- Oracle Database SQL Language Reference for information about the SQL functions
## Adding the Foreign Key Constraint
**Note:**   You must be connected to Oracle Database as user app_data.
Now that the tables departments and employees contain data, add a foreign key constraint with the following ALTER TABLE statement. You can enter the statement either in SQL*Plus or in the Worksheet of SQL Developer. Alternatively, you can add the constraint with the SQL Developer tool Add Foreign Key.
```
ALTER TABLE departments#
ADD CONSTRAINT dept_to_emp_fk
FOREIGN KEY(manager_id) REFERENCES employees#;
```
If you add this foreign key constraint before departments# and employees# contain data, then you get this error when you try to load either of them with data:
```
ORA-02291: integrity constraint (APP_DATA.JOB_HIST_TO_DEPT_FK) violated - parent key not found
```
**See Also:**   “Tutorial: Adding Constraints to Existing Tables”
## Granting Privileges on the Schema Objects to Users
**Note:**   You must be connected to Oracle Database as user app_data.
To grant privileges to users, use the SQL statement GRANT. You can enter the GRANT statements either in SQL*Plus or in the Worksheet of SQL Developer.
Grant to app_code *only* the privileges that it needs to create employees_pkg:
```
GRANT SELECT, INSERT, UPDATE, DELETE ON employees TO app_code;
GRANT SELECT ON departments TO app_code;
GRANT SELECT ON jobs TO app_code;
GRANT SELECT, INSERT on job_history TO app_code;
GRANT SELECT ON employees_sequence TO app_code;
```
Grant to app_admin *only* the privileges that it needs to create admin_pkg:
```
GRANT SELECT, INSERT, UPDATE, DELETE ON jobs TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON departments TO app_admin;
GRANT SELECT ON employees_sequence TO app_admin;
GRANT SELECT ON departments_sequence TO app_admin;
```
**See Also:**   *Oracle Database SQL Language Reference* for information about the `GRANT` statement
