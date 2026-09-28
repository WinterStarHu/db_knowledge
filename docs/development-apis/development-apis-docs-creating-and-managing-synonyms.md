# Creating and Managing Synonyms

A synonym is an alias for another schema object. Some reasons to use synonyms are security (for example, to hide the owner and location of an object) and convenience.
Examples of convenience are:
``````
- Using a short synonym, such as SALES, for a long object name, such as ACME_CO.SALES_DATA
``````
- Using a synonym for a renamed object, instead of changing that object name throughout the applications that use it For example, if your application uses a table named DEPARTMENTS, and its name changes to DIVISIONS, you can create a DEPARTMENTS synonym for that table and continue to reference it by its original name.
**See Also:**   *Oracle Database Concepts* for additional general information about synonyms
## Creating Synonyms
To create a synonym, use either the SQL Developer tool Create Database Synonym or the DDL statement CREATE SYNONYM.
The following tutorial shows how to use the Create Database Synonym tool to create the synonym EMP for the EMPLOYEES table. The equivalent DDL statement is:
```
CREATE SYNONYM EMPL FOR EMPLOYEES;
```
**To create the synonym EMP using the Create Database Synonym tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Synonyms.
****
- In the list of choices, click New Synonym.
  - In the Synonym Name field, type EMPL.
****
  - In the Object Owner field, select HR from the menu.
****
  - In the Object Name field, select EMPLOYEES from the menu. The synonym refers to a specific schema object; in this case, the table EMPLOYEES.
****
  - Click Apply.
**** ****
- In the Confirmation window, click OK. The synonym EMPL is created. To see it, expand Synonyms in the Connections frame. You can now use EMPL instead of EMPLOYEES.
**See Also:**   *Oracle Database SQL Language Reference* for information about the CREATE SYNONYM statement
## Dropping Synonyms
To drop a synonym, use either the SQL Developer Connections frame and Drop tool, or the DDL statement DROP SYNONYM.
This statement drops the synonym EMP:
```
DROP SYNONYM EMP;
```
**To drop a synonym using the Drop tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Synonyms.
- In the list of synonyms, right-click the name of the synonym to drop.
****
- In the list of choices, click Drop.
****
- In the Drop window, click Apply.
****
- In the Confirmation window, click OK.
**See Also:**   *Oracle Database SQL Language Reference* for information about the DROP SYNONYM statement
