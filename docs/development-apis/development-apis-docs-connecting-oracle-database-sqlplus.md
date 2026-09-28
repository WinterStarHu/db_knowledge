# Connecting to Oracle Database from SQL*Plus

SQL*Plus is a client program from which you can access Oracle Database. This topic shows how to start SQL*Plus and connect to Oracle Database.
**Note:**   For steps 3 and 4 of the following procedure, you need a user name and password.
## Steps to connect to Oracle Database from SQL*Plus:
- If you are on a Windows system, open a Windows command prompt.
****
- At the command prompt, type sqlplus and then press the Enter key.
****
- At the user name prompt, type your user name and then press the Enter key.
****
- At the password prompt, type your password and then press the Enter key.
**Note:**   For security, your password is not visible on your screen.
The system connects you to an Oracle Database instance.
You are in the SQL*Plus environment. At the `SQL>` prompt, you can enter and run SQL*Plus commands, SQL statements, PL/SQL statements, and operating system commands.
To exit SQL*Plus, type `exit` and press the **Enter** key.
**Note:**   Exiting SQL*Plus ends the SQL*Plus session, but does not shut down the Oracle Database instance.
Example 2-1 starts SQL*Plus, connects to Oracle Database, runs a SQL `SELECT` statement, and exits SQL*Plus.
**Example 2-1 Connecting to Oracle Database from SQL*Plus**
```
> sqlplus
SQL*Plus: Release 12.1.0.1.0 Production on Thu Dec 27 07:43:41 2012
Copyright (c) 1982, 2012, Oracle.  All rights reserved.
Enter user-name: your_user_name
Enter password: your_password
Connected to:
Oracle Database 12c Enterprise Edition Release - 12.1.0.1.0 64bit Production
SQL> select count(*) from employees;
  COUNT(*)
----------
       107
SQL> exit
Disconnected from Oracle Database 12c Enterprise Edition Release - 12.1.0.1.0 64bit Production
>
```
**See Also:**
- “Connecting to Oracle Database as User HR from SQL*Plus”
- “About SQL*Plus” for a brief description of SQL*Plus
**
- SQL*Plus User’s Guide and Reference for more information about starting SQL*Plus and connecting to Oracle Database
