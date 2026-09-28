# Mapping Oracle Database Schemas and Roles

Azure AD users will be mapped to one database schema and optionally to one or more database roles.
- Exclusively Mapping an Oracle Database Schema to a Microsoft Azure AD User You can exclusively map an Oracle Database schema to a Microsoft Azure AD user.
- Mapping a Shared Oracle Schema to an App Role In this mapping, an Oracle schema is mapped to an app role. Therefore, anyone who has that app role would get the same shared schema.
- Mapping an Oracle Database Global Role to an App Role Oracle Database global roles that are mapped to Azure app roles give Azure users and applications additional privileges and roles above those that they have been granted through their login schemas.
## Exclusively Mapping an Oracle Database Schema to a Microsoft Azure AD User
You can exclusively map an Oracle Database schema to a Microsoft Azure AD user.
````
- Log in to the Oracle Database instance as a user who has been granted the CREATE USER or ALTER USER system privilege.
``````
````
```
CREATE USER peter_fitch IDENTIFIED GLOBALLY AS 'AZURE_USER=peter.fitch@example.com';
```
- Run the CREATE USER or ALTER USER statement with the IDENTIFIED GLOBALLY AS clause specifying the Azure AD user name. For example, to create a new database schema user named peter_fitch and map this user to an existing Azure AD user named peter.fitch@example.com:
```
GRANT CREATE SESSION TO peter_fitch;
```
- Grant the CREATE SESSION privilege to the user.
## Mapping a Shared Oracle Schema to an App Role
In this mapping, an Oracle schema is mapped to an app role. Therefore, anyone who has that app role would get the same shared schema.
````
- Log in to the Oracle Database instance as a user who has the CREATE USER or ALTER USER system privilege.
``````
````
```
CREATE USER dba_azure IDENTIFIED GLOBALLY AS 'AZURE_ROLE=AZURE_DBA';
```
- Run the CREATE USER or ALTER USER statement with the IDENTIFIED GLOBALLY AS clause specifying the Azure application role name. For example, to create a new database global user account (schema) named dba_azure and map it to an existing Azure AD application role named AZURE_DBA:
## Mapping an Oracle Database Global Role to an App Role
Oracle Database global roles that are mapped to Azure app roles give Azure users and applications additional privileges and roles above those that they have been granted through their login schemas.
````
- Log in to the Oracle Database instance as a user who has been granted the CREATE ROLE or ALTER ROLE system privilege
``````
````
```
CREATE ROLE widget_sales_role IDENTIFIED GLOBALLY AS 'AZURE_ROLE=WidgetManagerGroup';
```
- Run the CREATE ROLE or ALTER ROLE statement with the IDENTIFIED GLOBALLY AS clause specifying the name of the Azure AD application role. For example, to create a new database global role named widget_sales_role and map it to an existing Azure AD application role named WidgetManagerGroup:
