# Exploring Oracle Database with SQL Developer

If you are connected to Oracle Database from SQL Developer as the user HR, you can view HR schema objects and the properties of the EMPLOYEES table.
## Tutorial: Viewing HR Schema Objects with SQL Developer
This tutorial shows how to use SQL Developer to view the objects that belong to the HR schema-that is, how to **browse** the HR schema.
**Note:**   If you are not connected to Oracle Database as user HR from SQL Developer, see “Connecting to Oracle Database as User HR from SQL Developer” and then return to this tutorial.
**Steps to browse the HR schema:** ****
- In the Connections frame, to the left of the hr_conn icon, select the plus sign (+). If you are not connected to the database, the Connection Information window opens. If you are connected to the database, the hr_conn information expands (see the information that follows “Click OK” in step 2).
  - In the User Name field, enter hr.
  - In the Password field, enter the password for the user HR.
****
  - Click OK.
The hr_conn information expands: The plus sign becomes a minus sign (-), and under the hr_conn icon, a list of schema object types appears—Tables, Views, Indexes, and so on. (If you click the minus sign, the hr_conn information collapses: The minus sign becomes a plus sign, and the list disappears.) **See Also:** **
- Oracle SQL Developer User’s Guide for more information about the SQL Developer user interface
- “About Sample Schema HR” for general information about schema HR
## Tutorial: Viewing EMPLOYEES Table Properties and Data with SQL Developer
This tutorial shows how to use SQL Developer to view the properties and data of the EMPLOYEES table in the HR schema.
**Note:**   If you are not browsing the HR schema, see “Tutorial: Viewing HR Schema Objects with SQL Developer” and then return to this tutorial.
**Steps to view the properties and data of the EMPLOYEES table:** ****
- In the Connections frame, expand Tables. Under Tables, a list of the tables in the HR schema appears.
****
- Select the table EMPLOYEES. In the right frame of the Oracle SQL Developer window, in the Columns pane, a list of all columns of this table appears. To the right of each column are its properties—name, data type, and so on. (To see all column properties, move the horizontal scroll bar to the right.)
****
- In the right frame, select the Data tab. The Data pane appears, showing a numbered list of all records in this table. (To see more records, move the vertical scroll bar down. To see more columns of the records, move the horizontal scroll bar to the right.)
****
- In the right frame, click the Constraints tab. The Constraints pane appears, showing a list of all constraints on this table. To the right of each constraint are its properties—name, type, search condition, and so on. (To see all constraint properties, move the horizontal scroll bar to the right.)
********
- Explore the other properties by selecting the appropriate tabs. To see the SQL statement for creating the EMPLOYEES table, select the SQL tab. The SQL statement appears in a pane named EMPLOYEES. To close this pane, select the x to the right of the name EMPLOYEES.
**See Also:**   *Oracle SQL Developer User’s Guide* for more information about the SQL Developer user interface
