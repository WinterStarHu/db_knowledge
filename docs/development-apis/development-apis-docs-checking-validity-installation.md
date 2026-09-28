# Checking the Validity of an Installation

After installing your application in a deployment environment, you can check its validity using SQL Developer.
  - Expand the connection to the deployment environment.
  - Examine the definitions of the new objects.
****
  - Expand Data Dictionary Reports. A list of data dictionary reports appears.
****
  - Expand All Objects. A list of objects reports appears.
****
  - Select All Objects. The Select Connection window appears.
  - In the Connection field, select from the menu the connection to the deployment environment.
****
  - Click OK.
````
  - In the Enter Bind Values window, select either Owner or Object Name.
****
  - Click Apply. The message Displaying Results shows, followed by the results. For each object, this report lists the Owner, Object Type, Object Name, Status (Valid or Invalid), Date Created, and Last DDL. Last DDL is the date of the last DDL operation that affected the object.
****
  - In the Reports pane, select Invalid Objects.
****
  - In the Enter Bind Values window, click Apply. For each object whose Status is Invalid, this report lists the Owner, Object Type, and Object Name.
**See Also:**   *Oracle SQL Developer User’s Guide* for more information about SQL Developer reports
