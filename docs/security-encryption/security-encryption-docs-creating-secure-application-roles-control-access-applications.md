# Creating Secure Application Roles to Control Access to Applications

A secure application role is only enabled through its associated PL/SQL package or procedure.
``````
- Step 1: Create the Secure Application Role The CREATE ROLE statement with the IDENTIFIED USING clause creates a secure application role.
- Step 2: Create a PL/SQL Package to Define the Access Policy for the Application You can create a PL/SQL package that defines the access policy for your application.
## Step 1: Create the Secure Application Role
The `CREATE` `ROLE` statement with the `IDENTIFIED USING` clause creates a secure application role.
You must have the `CREATE ROLE` system privilege to execute this statement.
For example, to create a secure application role called `hr_admin` that is associated with the `sec_mgr.hr_admin` package:
  - Create the security application role as follows:
```
CREATE ROLE hr_admin IDENTIFIED USING sec_mgr.hr_admin_role_check;
```
```
This statement indicates the following:
- The role `hr_admin` to be created is a secure application role.
- The role can only be enabled by modules defined inside the PL/SQL procedure `sec_mgr`.`hr_admin_role_check`. At this stage, this procedure does not need to exist;[Step 2: Create a PL/SQL Package to Define the Access Policy for the Application](#GUID-7D39957F-31DC-4C7D-9BFB-93FB2C631E25) explains how to create the package or procedure.
```
````````````
- Grant the security application role the privileges you would normally associate with this role. For example, to grant the hr_admin role SELECT, INSERT, UPDATE, and DELETE privileges on the HR.EMPLOYEES table, you enter the following statement:
```
GRANT SELECT, INSERT, UPDATE, DELETE ON HR.EMPLOYEES TO hr_admin;
```
```
Do not grant the role directly to the user. The PL/SQL procedure or package does that for you, assuming the user passes its security policies.
```
## Step 2: Create a PL/SQL Package to Define the Access Policy for the Application
You can create a PL/SQL package that defines the access policy for your application.
- About Creating a PL/SQL Package to Define the Access Policy for an Application To enable or disable the secure application role, you must create the security policies of the role within a PL/SQL package.
- Creating a PL/SQL Package or Procedure to Define the Access Policy for an Application The PL/SQL package or procedure that you create must use invoker’s rights to define the access policy.
- Testing the Secure Application Role As a user who has been granted the secure application role, try performing an action that requires the privileges the role grants.
### About Creating a PL/SQL Package to Define the Access Policy for an Application
To enable or disable the secure application role, you must create the security policies of the role within a PL/SQL package.
You also can create an individual procedure to do this, but a package lets you group a set of procedures together. This lets you group a set of policies that, used together, present a solid security strategy to protect your applications. For users (or potential intruders) who fail the security policies, you can add auditing checks to the package to record the failure. Typically, you create this package in the schema of the security administrator.
The package or procedure must accomplish the following:
****```` **
- It must use invoker’s rights to enable the role.To create the package using invoker’s rights, you must set the AUTHID property to CURRENT_USER. You cannot create the package by using definer’s rights. For more information about invoker’s rights and definer’s rights, see Oracle Database PL/SQL Language Reference.
******````
- It must include one or more security checks to validate the user. One way to validate users is to use the SYS_CONTEXT SQL function. See Oracle Database SQL Language Reference for more information about SYS_CONTEXT. To find session information for a user, you can use SYS_CONTEXT with an application context. See Using Application Contexts to Retrieve User Information, for details.
****```````````` **
- It must issue a SET ROLE SQL statement or DBMS_SESSION.SET_ROLE procedure when the user passes the security checks. Because you create the package using invoker’s rights, you must set the role by issuing the SET ROLE SQL statement or the DBMS_SESSION.SET_ROLE procedure. (However, you cannot use the SET ROLE ALL statement for this type of role enablement.) The PL/SQL embedded SQL syntax does not support the SET ROLE statement, but you can invoke SET ROLE by using dynamic SQL (for example, with EXECUTE IMMEDIATE). For more information about EXECUTE IMMEDIATE, see Oracle Database PL/SQL Language Reference.
Because of the way that you must create this package or procedure, you cannot use a logon trigger to enable or disable a secure application role. Instead, invoke the package directly from the application when the user logs in, before the user must use the privileges granted by the secure application role.
### Creating a PL/SQL Package or Procedure to Define the Access Policy for an Application
The PL/SQL package or procedure that you create must use invoker’s rights to define the access policy.
For example, suppose you wanted to restrict anyone using the `hr_admin` role to employees who are on site (that is, using certain terminals) and between the hours of 8 a.m. and 5 p.m. As the system or security administrator, you can create a procedure that defines the access policy for the application.
```
CREATE OR REPLACE PROCEDURE hr_admin_role_check
 AUTHID CURRENT_USER
 AS
 BEGIN
  IF (SYS_CONTEXT ('userenv','ip_address')
    IN ('192.0.2.10' , '192.0.2.11')
     AND
    TO_CHAR (SYSDATE, 'HH24') BETWEEN 8 AND 17)
  THEN
    EXECUTE IMMEDIATE 'SET ROLE hr_admin';
  END IF;
 END;
/
```
  - AUTHID CURRENT_USER sets the AUTHID property to CURRENT_USER so that invoker’s rights can be used.
````
  - IF (SYS_CONTEXT ('userenv','ip_address') validates the user by using the SYS_CONTEXT SQL function to retrieve the user session information.
````
  - BETWEEN ... TO_CHAR creates a test to grant or deny access. The test restricts access to users who are on site (that is, using certain terminals) and working between the hours of 8:00 a.m. and 5:00 p.m. If the user passes this check, the hr_admin role is granted.
``````
  - THEN... EXECUTE grants the role to the user by issuing the SET ROLE statement using the EXECUTE IMMEDIATE command, assuming the user passes the test.
````
- Grant EXECUTE permissions for the hr_admin_role_check procedure to any user who was assigned it. For example:
```
GRANT EXECUTE ON hr_admin_role_check TO psmith;
```
### Testing the Secure Application Role
As a user who has been granted the secure application role, try performing an action that requires the privileges the role grants.
When you log in as a user who has been granted the secure application role, the role is then enabled.
- Log in to the database session as the user. For example:
```
CONNECT PSMITH@hrpdb
Enter password: password
```
````
- Perform an action that requires the privileges the secure application role grants. For example, if the role grants the EXECUTE privilege for a procedure called sec_admin.hr_admin_role_check:
```
EXECUTE sec_admin.hr_admin_role_check;
```
