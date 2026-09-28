# Creating Installation Scripts with the Cart

The SQL Developer Cart is a convenient tool for deploying Oracle Database objects from one or more database connections to a destination connection.
You drag and drop objects from the navigator frame into the Cart window, specify the desired options, and click the Export Cart icon to display the Export Objects dialog box. After you complete the information in that dialog box, SQL Developer creates a `.zip` file containing scripts (including a master script) to create the objects in the schema of a desired destination connection.
## Steps to create installation scripts with the Cart:
****
- In the SQL Developer window, click the menu View.
**** ********
- From the View menu, select Cart. The Cart window opens. The Export Cart icon is inactive (gray). Tip: In the Cart window, for information about Cart user preferences, press the key F1.
- In the Connections frame, select the schema objects that you want the installation script to create and drag them into the Cart window. In The Cart window, the Export Cart icon is now active (not gray).
****
- For each Selected Object of type TABLE, if you want the installation script to export data, then select the option Data.
****
- Click Export Cart.
**
- In the Export Objects dialog box, enter the desired values in the fields. For information about these fields, see Oracle SQL Developer User’s Guide.
****
- Click Apply. SQL Developer creates a .zip file containing scripts (including a master script) to create the objects in the schema of a desired destination connection.
  - Referenced objects are created before their dependent objects.
  - Tables are created before data is inserted into them.
If the installation scripts create sequences, see “Editing Installation Scripts that Create Sequences”.
If the installation scripts create triggers, see “Editing Installation Scripts that Create Sequences”.
If necessary, edit the installation files in the Worksheet or any text editor.
**See Also:**   *Oracle SQL Developer User’s Guide* for more information about the Cart
