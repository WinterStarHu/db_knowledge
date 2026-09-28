# Exploring Oracle Database with SQL*Plus

If you are connected to Oracle Database from SQL*Plus as the user HR, you can view HR schema objects and the properties of the EMPLOYEES table.
**Note:**   If you are not connected to Oracle Database as user HR from SQL*Plus, see “Connecting to Oracle Database as User HR from SQL*Plus” and then return to this section.
## Viewing HR Schema Objects with SQL*Plus
With SQL*Plus, you can view the objects that belong to the HR schema by querying the static data dictionary view USER_OBJECTS.
Example 2-2 shows how to view the names and data types of the objects that belong to the HR schema.
**Example 2-2 Viewing HR Schema Objects with SQL*Plus**
```
COLUMN OBJECT_NAME FORMAT A25
COLUMN OBJECT_TYPE FORMAT A25
SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS
ORDER BY OBJECT_TYPE, OBJECT_NAME;
```
The result looks similar to the following text:
```
OBJECT_NAME               OBJECT_TYPE
------------------------- -------------------------
COUNTRY_C_ID_PK           INDEX
DEPT_ID_PK                INDEX
DEPT_LOCATION_IX          INDEX
EMP_DEPARTMENT_IX         INDEX
EMP_EMAIL_UK              INDEX
EMP_EMP_ID_PK             INDEX
EMP_JOB_IX                INDEX
EMP_MANAGER_IX            INDEX
EMP_NAME_IX               INDEX
JHIST_DEPARTMENT_IX       INDEX
JHIST_EMPLOYEE_IX         INDEX
JHIST_EMP_ID_ST_DATE_PK   INDEX
JHIST_JOB_IX              INDEX
JOB_ID_PK                 INDEX
LOC_CITY_IX               INDEX
LOC_COUNTRY_IX            INDEX
LOC_ID_PK                 INDEX
LOC_STATE_PROVINCE_IX     INDEX
REG_ID_PK                 INDEX
ADD_JOB_HISTORY           PROCEDURE
SECURE_DML                PROCEDURE
DEPARTMENTS_SEQ           SEQUENCE
EMPLOYEES_SEQ             SEQUENCE
LOCATIONS_SEQ             SEQUENCE
COUNTRIES                 TABLE
DEPARTMENTS               TABLE
EMPLOYEES                 TABLE
JOBS                      TABLE
JOB_HISTORY               TABLE
LOCATIONS                 TABLE
REGIONS                   TABLE
SECURE_EMPLOYEES          TRIGGER
UPDATE_JOB_HISTORY        TRIGGER
EMP_DETAILS_VIEW          VIEW
34 rows selected.
```
**See Also:** **
- Oracle Database Reference for information about USER_OBJECTS
- “Selecting Table Data” for information about using queries to view table data
- “About Sample Schema HR” for general information about the schema HR
## Viewing EMPLOYEES Table Properties and Data with SQL*Plus
You can a SQL*Plus command, the SQL SELECT statement, and static data dictionary views to view the properties and data of the HR.EMPLOYEES table.
You can use the SQL*Plus command `DESCRIBE` to view the properties of the columns of the EMPLOYEES table in the HR schema and the SQL statement SELECT to view the data. To view other properties of the table, use static data dictionary views (for example, USER_CONSTRAINTS, USER_INDEXES, and USER_TRIGGERS).
Example 2-3 shows how to view the properties of the EMPLOYEES table in the HR schema.
**Example 2-3 Viewing EMPLOYEES Table Properties with SQL*Plus**
```
DESCRIBE EMPLOYEES
```
Result:
```
Name                                      Null?    Type
----------------------------------------- -------- -------------
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
Example 2-4 shows how to view some data in the EMPLOYEES table in the HR schema.
**Example 2-4 Viewing EMPLOYEES Table Data with SQL*Plus**
```
COLUMN FIRST_NAME FORMAT A20
COLUMN LAST_NAME FORMAT A25
COLUMN PHONE_NUMBER FORMAT A20
SELECT LAST_NAME, FIRST_NAME, PHONE_NUMBER FROM EMPLOYEES
ORDER BY LAST_NAME;
```
The result looks similar to the following text:
```
LAST_NAME                 FIRST_NAME           PHONE_NUMBER
------------------------- -------------------- --------------------
Abel                      Ellen                011.44.1644.429267
Ande                      Sundar               011.44.1346.629268
Atkinson                  Mozhe                650.124.6234
Austin                    David                590.423.4569
Baer                      Hermann              515.123.8888
Baida                     Shelli               515.127.4563
Banda                     Amit                 011.44.1346.729268
Bates                     Elizabeth            011.44.1343.529268
...
Urman                     Jose Manuel          515.124.4469
Vargas                    Peter                650.121.2004
Vishney                   Clara                011.44.1346.129268
Vollman                   Shanta               650.123.4234
Walsh                     Alana                650.507.9811
Weiss                     Matthew              650.123.1234
Whalen                    Jennifer             515.123.4444
Zlotkey                   Eleni                011.44.1344.429018
107 rows selected.
```
**See Also:** **
- SQL*Plus User’s Guide and Reference for information about DESCRIBE
- “Selecting Table Data” for information about using queries to view table data
**
- Oracle Database Reference for information about static data dictionary views
