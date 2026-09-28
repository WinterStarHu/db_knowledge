# Creating the Schemas for the Application

Using the procedure in this section, create the schemas for the application.
Use the following schema names:
- app_data
- app_code
- app_admin
- app_user
- app_admin_user
**Note:**   For the following procedure, you need the name and password of a user who has the CREATE USER and DROP USER system privileges.
## Steps to create the schemas or users:
- Using SQL*Plus, connect to Oracle Database as a user with the CREATE USER and DROP USER system privileges. The SQL> prompt appears.
```
 DROP USER schema_name CASCADE;
```
```
 User dropped.
```
```
 DROP USER schema_name CASCADE
         *
 ERROR at line 1:
 ORA-01918: user 'schema_name' does not exist
```
- In case the schema exists, drop the schema and its objects with this SQL statement: If the schema existed, the system responds: If the schema did not exist, the system responds:
**``````
```
 CREATE USER schema_name IDENTIFIED BY password
 DEFAULT TABLESPACE USERS
 QUOTA UNLIMITED ON USERS
 ENABLE EDITIONS;
```
```
 CREATE USER schema_name IDENTIFIED BY password
 ENABLE EDITIONS;
```
******
```
 User created.
```
- If schema_name is either app_data, app_code, or app_admin, then create the schema with this SQL statement: Otherwise, create the schema with this SQL statement: Caution: Choose a secure password. For guidelines for secure passwords, see Oracle Database Security Guide. The system responds:
- (Optional) In SQL Developer, create a connection for the schema, using the instructions in “Connecting to Oracle Database from SQL Developer”.
**See Also:**
- “About the Application”
- “Connecting to Oracle Database from SQL*Plus”
**````
- Oracle Database SQL Language Reference for information about the DROP USER statement
**````
- Oracle Database SQL Language Reference for information about the CREATE USER statement
