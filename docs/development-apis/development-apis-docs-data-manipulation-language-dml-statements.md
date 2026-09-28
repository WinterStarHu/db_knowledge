# About Data Manipulation Language (DML) Statements

**Data manipulation language (DML) statements** access and manipulate data in existing tables.
In the SQL*Plus environment, you can enter a DML statement after the SQL> prompt.
In the SQL Developer environment, you can enter a DML statement in the Worksheet. Alternatively, you can use the SQL Developer Connections frame and tools to access and manipulate data.
To see the effect of a DML statement in SQL Developer, you might have to select the schema object type of the changed object in the Connections frame and then click the Refresh icon.
The effect of a DML statement is not permanent until you commit the transaction that includes it. A **transaction** is a sequence of SQL statements that Oracle Database treats as a unit (it can be a single DML statement). Until a transaction is committed, it can be rolled back (undone). For more information about transactions, see “About Transaction Control Statements”.
**See Also:**   *Oracle Database SQL Language Reference* for more information about DML statements
## About the INSERT Statement
The INSERT statement inserts rows into an existing table.
The simplest recommended form of the INSERT statement has this syntax:
```
INSERT INTO table_name (list_of_columns)
VALUES (list_of_values);
```
Every column in list_of_columns must have a valid value in the corresponding position in list_of_values. Therefore, before you insert a row into a table, you must know what columns the table has, and what their valid values are. To get this information using SQL Developer, see “Tutorial: Viewing EMPLOYEES Table Properties and Data with SQL Developer”. To get this information using SQL*Plus, use the DESCRIBE statement. For example:
```
DESCRIBE EMPLOYEES;
```
Result:
```
Name                                      Null?    Type
----------------------------------------- -------- ------------
EMPLOYEE_ID                               NOT NULL NUMBER(6)
FIRST_NAME                                         VARCHAR2(20)
LAST_NAME                                 NOT NULL VARCHAR2(25)
EMAIL                                     NOT NULL VARCHAR2(25)
PHONE_NUMBER                                       VARCHAR2(20)
HIRE_DATE                                 NOT NULL DATE
JOB_ID                                    NOT NULL VARCHAR2(10)
SALARY                                             NUMBER(8,2)
COMMISSION_PCT                                     NUMBER(2,2)
MANAGER_ID                                         NUMBER(6)
DEPARTMENT_ID                                      NUMBER(4)
```
The INSERT statement in Example 3-1 inserts a row into the EMPLOYEES table for an employee for which all column values are known.
You need not know all column values to insert a row into a table, but you must know the values of all NOT NULL columns. If you do not know the value of a column that can be NULL, you can omit that column from list_of_columns. Its value defaults to NULL.
The INSERT statement in Example 3-2 inserts a row into the EMPLOYEES table for an employee for which all column values are known except SALARY. For now, SALARY can have the value NULL. When you know the salary, you can change it with the UPDATE statement (see Example 3-4).
The INSERT statement in Example 3-3 tries to insert a row into the EMPLOYEES table for an employee for which LAST_NAME is not known.
**Example 3-1 Using the INSERT Statement When All Information Is Available**
```
INSERT INTO EMPLOYEES (
  EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  EMAIL,
  PHONE_NUMBER,
  HIRE_DATE,
  JOB_ID,
  SALARY,
  COMMISSION_PCT,
  MANAGER_ID,
  DEPARTMENT_ID
)
VALUES (
  10,              -- EMPLOYEE_ID
  'George',        -- FIRST_NAME
  'Gordon',        -- LAST_NAME
  'GGORDON',       -- EMAIL
  '650.506.2222',  -- PHONE_NUMBER
  '01-JAN-07',     -- HIRE_DATE
  'SA_REP',        -- JOB_ID
  9000,            -- SALARY
  .1,              -- COMMISSION_PCT
  148,             -- MANAGER_ID
  80               -- DEPARTMENT_ID
);
```
Result:
```
1 row created.
```
**Example 3-2 Using the INSERT Statement When Not All Information Is Available**
```
INSERT INTO EMPLOYEES (
  EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  EMAIL,
  PHONE_NUMBER,
  HIRE_DATE,
  JOB_ID,          -- Omit SALARY; its value defaults to NULL.
  COMMISSION_PCT,
  MANAGER_ID,
  DEPARTMENT_ID
)
VALUES (
  20,              -- EMPLOYEE_ID
  'John',          -- FIRST_NAME
  'Keats',         -- LAST_NAME
  'JKEATS',        -- EMAIL
  '650.506.3333',  -- PHONE_NUMBER
  '01-JAN-07',     -- HIRE_DATE
  'SA_REP',        -- JOB_ID
  .1,              -- COMMISSION_PCT
  148,             -- MANAGER_ID
  80               -- DEPARTMENT_ID
);
```
Result:
```
1 row created.
```
**Example 3-3 Using the INSERT Statement Incorrectly**
```
INSERT INTO EMPLOYEES (
  EMPLOYEE_ID,
  FIRST_NAME,      -- Omit LAST_NAME (error)
  EMAIL,
  PHONE_NUMBER,
  HIRE_DATE,
  JOB_ID,
  COMMISSION_PCT,
  MANAGER_ID,
  DEPARTMENT_ID
)
VALUES (
  20,              -- EMPLOYEE_ID
  'John',          -- FIRST_NAME
  'JOHN',          -- EMAIL
  '650.506.3333',  -- PHONE_NUMBER
  '01-JAN-07',     -- HIRE_DATE
  'SA_REP',        -- JOB_ID
  .1,              -- COMMISSION_PCT
  148,             -- MANAGER_ID
  80               -- DEPARTMENT_ID
);
```
Result:
```
ORA-01400: cannot insert NULL into ("HR"."EMPLOYEES"."LAST_NAME")
```
**See Also:** **
- Oracle Database SQL Language Reference for information about the INSERT statement
**
- Oracle Database SQL Language Reference for information about data types
- “Tutorial: Adding Rows to Tables with the Insert Row Tool”
## About the UPDATE Statement
The UPDATE statement updates (changes the values of) a set of existing table rows.
A simple form of the UPDATE statement has this syntax:
```
UPDATE table_name
SET column_name = value [, column_name = value]...
[ WHERE condition ];
```
Each value must be valid for its column_name. If you include the WHERE clause, the statement updates column values only in rows that satisfy condition.
The UPDATE statement in Example 3-4 updates the value of the SALARY column in the row that was inserted into the EMPLOYEES table in Example 3-2, before the salary of the employee was known.
The UPDATE statement in Example 3-5 updates the commission percentage for every employee in department 80.
**Example 3-4 Using the UPDATE Statement to Add Data**
```
UPDATE EMPLOYEES
SET SALARY = 8500
WHERE LAST_NAME = 'Keats';
```
Result:
```
1 row updated.
```
**Example 3-5 Using the UPDATE Statement to Update Multiple Rows**
```
UPDATE EMPLOYEES
SET COMMISSION_PCT = COMMISSION_PCT + 0.05
WHERE DEPARTMENT_ID = 80;
```
Result:
```
34 rows updated.
```
**See Also:** **
- Oracle Database SQL Language Reference for information about the UPDATE statement
**
- Oracle Database SQL Language Reference for information about data types
- “Tutorial: Changing Data in Tables in the Data Pane”
## About the DELETE Statement
The DELETE statement deletes rows from a table.
A simple form of the DELETE statement has this syntax:
```
DELETE FROM table_name [ WHERE condition ];
```
If you include the WHERE clause, the statement deletes only rows that satisfy condition. If you omit the WHERE clause, the statement deletes all rows from the table, but the empty table still exists. To delete a table, use the DROP TABLE statement.
The DELETE statement in Example 3-6 deletes the rows inserted in Example 3-1 and Example 3-2.
**Example 3-6 Using the DELETE Statement**
```
DELETE FROM EMPLOYEES
WHERE HIRE_DATE = TO_DATE('01-JAN-07', 'dd-mon-yy');
```
Result:
```
2 rows deleted.
```
**See Also:** **
- Oracle Database SQL Language Reference for information about the DELETE statement
**
- Oracle Database SQL Language Reference for information about the DROP TABLE statement
- “Tutorial: Deleting Rows from Tables with the Delete Selected Row(s) Tool”
