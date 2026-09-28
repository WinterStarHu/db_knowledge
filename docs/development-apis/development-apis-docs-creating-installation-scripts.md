# Creating Installation Scripts

You can create installation scripts in SQL Developer or a text editor.
If an installation script needs only DDL and INSERT statements, then you can create it with either SQL Developer or any text editor. In SQL Developer, you can use either the Cart or the Database Export wizard. Oracle recommends the Cart for installation scripts that you expect to run in multiple deployment environments and the Database Export wizard for installation scripts that you expect to run in only one deployment environment.
If an installation script needs SQL statements that are neither DDL nor INSERT statements, then you must create it with a text editor.
This section explains how to create installation scripts with the Cart and the Database Export wizard, when and how to edit installation scripts that create sequences and triggers, and how create installation scripts for the application in Developing a Simple Oracle Database Application (“the sample application”).
