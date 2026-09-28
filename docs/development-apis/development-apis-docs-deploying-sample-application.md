# Deploying the Sample Application

You can deploy the sample application using installation scripts.
Use the installation scripts that you created in “Creating Installation Scripts for the Sample Application”.
**Note:**   For the following procedures, you need the name and password of a user who has the CREATE USER and DROP USER system privileges.
## Steps to deploy the sample application using SQL*Plus:
- Copy the installation scripts that you created in “Creating Installation Scripts for the Sample Application” to the deployment environment.
- In the deployment environment, connect to Oracle Database as a user with the CREATE USER and DROP USER system privileges.
```
 @create_app.sql
```
- At the SQL> prompt, run the primary installation script: The primary installation script runs the other four installation scripts for the sample application in the correct order, thereby deploying the sample application in the deployment environment.
## Steps to deploy the sample application using SQL Developer:
**
- If necessary, create a connection to the deployment environment. For Connection Name, enter a name that is not the name of the connection to the development environment.
- Copy the installation scripts that you created in “Creating Installation Scripts for the Sample Application” to the deployment environment.
- Connect to Oracle Database as a user with the CREATE USER and DROP USER system privileges in the deployment environment. A new pane is displayed. On its tab is the name of the connection to the deployment environment. The pane has two subpanes, Worksheet and Query Builder.
```
 @create_app.sql
```
- In the Worksheet pane, type the command for running the primary installation script:
****
- Click the icon Run Script. The primary installation script runs the other four installation scripts for the sample application in the correct order, thereby deploying the sample application in the deployment environment. The output appears in the Script Output pane, under the Worksheet pane. In the Connections frame, if you expand the connection to the deployment environment, and then expand the type of each object that the sample application uses, you see the objects of the sample application.
**See Also:** **
- SQL*Plus User’s Guide and Reference for more information about using scripts in SQL*Plus
**
- Oracle SQL Developer User’s Guide for more information about running scripts in SQL Developer
