# Creating and Managing Views

A view presents a query result as a table. In most places that you can use a table, you can use a view. Views are useful when you need frequent access to information that is stored in several different tables.
**See Also:**
- “Selecting Table Data” for information about queries
**
- Oracle Database Concepts for additional general information about views
## Creating Views
To create views, use either the SQL Developer tool Create View or the DDL statement CREATE VIEW.
This topic shows how to use both of these ways to create these views:
- SALESFORCE, which contains the names and salaries of the employees in the Sales department
- EMP_LOCATIONS, which contains the names and locations of all employees This view is used in “Creating an INSTEAD OF Trigger”.
**See Also:** **
- Oracle SQL Developer User’s Guide for more information about using SQL Developer to create a view
**
- Oracle Database SQL Language Reference for more information about the statement CREATE VIEW
### Tutorial: Creating a View with the Create View Tool
This tutorial shows how to create the SALESFORCE view using the Create View tool.
**Steps to create the SALESFORCE view using the Create View tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Views.
****
- In the list of choices, click New View. The Create View window opens, with default values for a new view.
- For Schema, accept the default value, HR.
- For Name, enter SALESFORCE.
****
- If the SQL Query pane does not show, click the tab SQL Query.
```
FIRST_NAME || ' ' || LAST_NAME "Name", SALARY*12 "Annual Salary"
```
  - After SELECT, type:
```
EMPLOYEES WHERE DEPARTMENT_ID = 80
```
  - After FROM, type:
****
- Click Check Syntax.
- Under Syntax Results, if the message is not No errors found in SQL, then return to step 7 and correct the syntax errors in the query.
**** ****
- Click OK. The view SALESFORCE is created. To see it, expand Views in the Connections frame. To see the CREATE VIEW statement for creating this view, select its name and click the tab SQL.
**See Also:**   *Oracle SQL Developer User’s Guide* for more information about using SQL Developer to create views
### Creating Views with the CREATE VIEW Statement
This example shows how to use the CREATE VIEW statement to create the EMP_LOCATIONS view, which joins four tables.
The CREATE VIEW statement in Example 4-3 creates the EMP_LOCATIONS view, which joins four tables. (For information about joins, see “Selecting Data from Multiple Tables”.) **Example 4-3 Creating the EMP_LOCATIONS View with CREATE VIEW**
```
CREATE VIEW EMP_LOCATIONS AS
SELECT e.EMPLOYEE_ID,
e.LAST_NAME || ', ' || e.FIRST_NAME NAME,
  d.DEPARTMENT_NAME DEPARTMENT,
  l.CITY CITY,
  c.COUNTRY_NAME COUNTRY
FROM EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID AND
 d.LOCATION_ID = l.LOCATION_ID AND
 l.COUNTRY_ID = c.COUNTRY_ID
ORDER BY LAST_NAME;
```
Result:
```
View EMP_LOCATIONS created.
```
**See Also:**   *Oracle Database SQL Language Reference* for information about the CREATE VIEW statement
## Changing Queries in Views
To change the query in a view, use the DDL statement CREATE VIEW with the OR REPLACE clause.
The CREATE OR REPLACE VIEW statement in Example 4-4 changes the query in the SALESFORCE view.
**Example 4-4 Changing the Query in the SALESFORCE View**
```
CREATE OR REPLACE VIEW SALESFORCE AS
SELECT FIRST_NAME || ' ' || LAST_NAME "Name",
  SALARY*12 "Annual Salary"
  FROM EMPLOYEES
WHERE DEPARTMENT_ID = 80 OR DEPARTMENT_ID = 20;
```
Result:
```
View SALESFORCE created.
```
**See Also:**   *Oracle Database SQL Language Reference* for information about the CREATE VIEW with the OR REPLACE clause
## Tutorial: Changing View Names with the Rename Tool
This tutorial shows how to use the Rename tool to change the name of the SALESFORCE view.
To change the name of a view, use either the SQL Developer tool Rename or the RENAME statement. The equivalent DDL statement is:
```
RENAME SALESFORCE to SALES_MARKETING;
```
**Steps to change the SALESFORCE view using the Rename tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Views.
****
- In the list of views, right-click SALESFORCE.
****
- In the list of choices, select Rename.
- In the Rename window, in the New View Name field, type SALES_MARKETING.
****
- Click Apply.
****
- In the Confirmation window, click OK.
**See Also:**   *Oracle Database SQL Language Reference* for information about the RENAME statement
## Dropping a View
To drop a view, use either the SQL Developer Connections frame and Drop tool or the DDL statement DROP VIEW.
The following tutorial shows how to use the Connections frame and Drop tool to drop the view SALES_MARKETING (changed in “Tutorial: Changing View Names with the Rename Tool”). The equivalent DDL statement is:
```
DROP VIEW SALES_MARKETING;
```
**Steps to drop the view SALES_MARKETING using the Drop tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the a list of schema object types, expand Views.
****
- In the a list of views, right-click SALES_MARKETING.
****
- In the a list of choices, click Drop.
****
- In the Drop window, click Apply.
****
- In the Confirmation window, click OK.
**See Also:**   *Oracle Database SQL Language Reference* for information about the DROP VIEW statement
