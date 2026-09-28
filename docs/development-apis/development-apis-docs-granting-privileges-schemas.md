# Granting Privileges to the Schemas

To grant privileges to schemas, use the SQL statement GRANT.
You can enter the GRANT statements either in SQL*Plus or in the Worksheet of SQL Developer. For security, grant each schema *only* the privileges that it needs.
**See Also:**
- “About the Application”
**
- Oracle Database SQL Language Reference for information about the GRANT statement
## Granting Privileges to the app_data Schema
Grant to the app_data schema *only* the privileges to do the following:
```
  GRANT CREATE SESSION TO app_data;
```
- Connect to Oracle Database:
```
  GRANT CREATE TABLE, CREATE VIEW, CREATE TRIGGER, CREATE SEQUENCE TO app_data;
```
- Create the tables, views, triggers, and sequences for the application:
```
  GRANT SELECT ON HR.DEPARTMENTS TO app_data;
  GRANT SELECT ON HR.EMPLOYEES TO app_data;
  GRANT SELECT ON HR.JOB_HISTORY TO app_data;
  GRANT SELECT ON HR.JOBS TO app_data;
```
- Load data from four tables in the sample schema HR into its own tables:
## Granting Privileges to the app_code Schema
Grant to the app_code schema *only* the privileges to do the following:
```
  GRANT CREATE SESSION TO app_code;
```
- Connect to Oracle Database:
```
  GRANT CREATE PROCEDURE TO app_code;
```
- Create the package employees_pkg:
```
  GRANT CREATE SYNONYM TO app_code;
```
- Create a synonym (for convenience):
## Granting Privileges to the app_admin Schema
Grant to the app_admin schema *only* the privileges to do the following:
```
  GRANT CREATE SESSION TO app_admin;
```
- Connect to Oracle Database:
```
  GRANT CREATE PROCEDURE TO app_admin;
```
- Create the package admin_pkg:
```
  GRANT CREATE SYNONYM TO app_admin;
```
- Create a synonym (for convenience):
## Granting Privileges to the app_user and app_admin_user Schemas
Grant to the app_user and app_admin_user schemas *only* the privileges to do the following:
```
  GRANT CREATE SESSION TO app_user;
  GRANT CREATE SESSION TO app_admin_user;
```
- Connect to Oracle Database:
```
  GRANT CREATE SYNONYM TO app_user;
  GRANT CREATE SYNONYM TO app_admin_user;
```
- Create synonyms (for convenience):
