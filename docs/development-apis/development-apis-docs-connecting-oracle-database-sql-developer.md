# Connecting to Oracle Database from SQL Developer

SQL Developer is a client program with which you can access Oracle Database.
Use the currently available release of SQL Developer, which you can download from the following URL:
`http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/` This section assumes that SQL Developer is installed on your system, and shows how to start it and connect to Oracle Database. If SQL Developer is not installed on your system, then see *Oracle SQL Developer User’s Guide* for installation instructions.
**Note:**
- If you're using a SQL Developer kit that does not include the JDK to complete the following procedure, the first time you start SQL Developer on your system, you must provide the path to the Java Development Kit.
- When prompted, you must enter a user name and password.
## Steps to connect to Oracle Database from SQL Developer:
** ****
- Start SQL Developer. For instructions, see Oracle SQL Developer User’s Guide. If this is the first time you have started SQL Developer on your system, you are prompted to enter the path to the Java Development Kit (JDK) installation (for example, C:\Program Files\Java\jdk1.8.0_65). Either type the path after the prompt or browse to it, and then press the Enter key.
****
- In the Connections frame, click the New Connection icon.
  - Type the appropriate values in the fields Connection Name, Username, and Password. For security, the password characters that you type appear as asterisks. Near the Password field is the check box Save Password. By default, it is deselected. Oracle recommends accepting the default.
****
  - If the Oracle pane is not showing, click the Oracle tab.
  - In the Oracle pane, accept the default values. (The default values are: Connection Type, Basic; Role, default, Hostname, localhost; Port, 1521; SID option, selected; SID field, xe.)
****
  - Click the Test button. The connection is tested. If the connection succeeds, the Status indicator changes from blank to Success.
****
  - If the test succeeded, click the button Connect. The New/Select Database Connection window closes. The Connections frame shows the connection whose name you entered in the Connection Name field in step 3.
You are in the SQL Developer environment.
To exit SQL Developer, select **Exit** from the File menu.
**Note:**   Exiting SQL Developer ends the SQL Developer session, but does not shut down the Oracle Database instance. The next time that you start SQL Developer, the connection you created using the preceding procedure still exists. SQL Developer prompts you for the password that you supplied in step 3 (unless you selected the check box Save Password).
**See Also:**
- “Connecting to Oracle Database as User HR from SQL Developer”
- “About SQL Developer” for a brief description of SQL Developer
**
- Oracle SQL Developer User’s Guide for more information about using SQL Developer to create connections to Oracle Database
