# Creating an Installation Script with the Database Export Wizard

To create an installation script in SQL Developer with the Database Export wizard, you specify the name of the installation script, the objects and data to export, and the desired options, and the wizard generates an installation script.
**Note:**   In the following procedure, you might have to enlarge the SQL Developer windows to see all fields and options.
## Steps to create an installation script with the Database Export wizard:
- If you have not done so, create a directory for the installation script, separate from the Oracle Database installation directory (for example, C:\my_exports).
****
- In the SQL Developer window, click the menu Tools.
****
- From the menu, select Database Export.
  - In the Connection field, select your connection to the development environment.
****
  - Select the desired Export DDL options (and deselect any selected undesired options). Note: Do not deselect Terminator, or the installation script will fail.
******
  - If you do not want the installation script to export data, then deselect Export Data.
````
  - In the Save As field, accept the default Single File and type the full path name of the installation script (for example, C:\my_exports\hr_export.sql). The file name must end with .sql.
****
  - Click Next.
**
****
  - Deselect the check boxes for the types that you do not want to export. Selecting or deselecting Toggle All selects or deselects all check boxes.
****
  - Click Next.
****
  - Click More.
  - In the Schema field, select your schema from the menu.
        - In the Type field, select from the menu either `ALL OBJECTS` or a specific object type (for example, `TABLE`).
****
  - Click Lookup. A list of objects appears in the left frame. If the value of the Type field is ALL OBJECTS, then the list contains all objects in the selected schema. If the value of the Type field is a specific object type, then the list contains all objects of that type in the selected schema.
        - Move the objects that you want to export from the left frame to the right frame: To move all objects, click >>. (To move all objects back, click . (To move selected objects back, select them and click <.)
  - (Optional) Repeat steps 6.c through 6.e for other object types.
****
**
  - Click Next. If you deselected Export Data in the Source/Destination window, then the Export Summary window appears—go to step 8. If you did not deselect Export Data in the Source/Destination window, then the Export Wizard - Step 4 of 5 (Specify Data) window appears. The lower frame lists the objects that you specified in the Specify Objects window.
**
  - Move the objects whose data you do not want to export from the lower frame to the upper frame: To move all objects, click the double upward arrow icon. (To move all objects back, click the double downward arrow icon.) To move selected objects, select them and then click the single upward arrow icon.
****
  - Click Next.
****
- In the Export Wizard - Step 5 of 5 (Export Summary) window, click Finish. The Exporting window opens, showing that exporting is occurring. When exporting is complete, the Exporting window closes, and the Worksheet shows the contents of the installation script that you specified in the Source/Destination window.
  - Referenced objects are created before their dependent objects.
  - Tables are created before data is inserted into them.
If necessary, edit the file in the Worksheet or any text editor.
**See Also:**   *Oracle SQL Developer User’s Guide* for more information about the Database Export wizard
