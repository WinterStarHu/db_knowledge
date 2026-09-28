# Auditing Specific Activities with Fine-Grained Auditing

Fine-grained auditing enables you to create audit policies at the granular level.
- About Fine-Grained Auditing Fine-grained auditing enables you to create policies that define specific conditions that must take place for the audit to occur.
- Where Are Fine-Grained Audit Records Stored? Fine-grained auditing records are stored in the AUDSYS schema.
- Who Can Perform Fine-Grained Auditing? Oracle provides roles for privileges needed to create fine-grained audit policies and to view and analyze fine-grained audit policy data.
- Fine-Grained Auditing on Tables or Views That Have Oracle VPD Policies The audit trail captures the VPD predicate for fine-grained audited tables or views that are included in an Oracle VPD policy.
- Fine-Grained Auditing in a Multitenant Environment You can create fine-grained audit policies in the CDB root, application root, CDB PDBs, and application PDBs.
- Fine-Grained Audit Policies with Editions You can prepare an application for edition-based redefinition, and cover each table that the application uses with an editioning view.
- Using the DBMS_FGA PL/SQL Package to Manage Fine-Grained Audit Policies The DBMS_FGA PL/SQL package manages fine-grained audit policies.
- Tutorial: Adding an Email Alert to a Fine-Grained Audit Policy This tutorial demonstrates how to create a fine-grained audit policy that generates an email alert when users violate the policy.
## About Fine-Grained Auditing
Fine-grained auditing enables you to create policies that define specific conditions that must take place for the audit to occur.
You cannot create unified audit policies using fine-grained auditing but you can use fine-grained auditing to create very customized audit settings, such as auditing the times that data is accessed.
This enables you to monitor data access based on content. It provides granular auditing of queries, and `INSERT`, `UPDATE`, and `DELETE` operations. You can use fine-grained auditing to audit the following types of actions:
- Accessing a table between 9 p.m. and 6 a.m. or on Saturday and Sunday
- Using an IP address from outside the corporate network
- Selecting or updating a table column
- Modifying a value in a table column
In general, fine-grained audit policies are based on simple, user-defined SQL predicates on table objects as conditions for selective auditing. During fetching, whenever policy conditions are met for a row, the query is audited.
Unified audit policies can perform most of the operations that fine-grained audit policies can perform, except for the following actions:
****
- Auditing specific columns. You can audit specific relevant columns that hold sensitive information, such as salaries or Social Security numbers.
****
- Using event handlers. For example, you can write a function that sends an email alert to a security administrator when an audited column that should not be changed at midnight is updated.
Fine-grained auditing has the following advantages over unified auditing:
- It enables you to perform row value-based auditing. For example, you can audit updates to a salary column when the updated value is higher than a specified threshold, but not otherwise.
- You can use fine-grained auditing event handlers to proactively notify administrators or other users of specific events.
````
- During a bulk data processing operation using BULK COLLECT and FORALL in PL/SQL to execute the same DML statement repeatedly for different bind variables, fine-grained auditing can capture the repeatedly executed statement with the appropriate bind variable values.
**Note:**
- Fine-grained auditing is supported only with cost-based optimization. For queries using rule-based optimization, fine-grained auditing checks before applying row filtering, which could result in an unnecessary audit event trigger.
- Policies currently in force on an object involved in a flashback query are applied to the data returned from the specified flashback snapshot based on time or system change number (SCN).
- If you want to use fine-grained auditing to audit data that is being directly loaded (for example, using Oracle Warehouse Builder to execute DML statements), then Oracle Database transparently makes all direct loads that are performed in the database instance into conventional loads. If you want to preserve the direct loading of data, consider using unified audit policies instead.
## Where Are Fine-Grained Audit Records Stored?
Fine-grained auditing records are stored in the `AUDSYS` schema.
These audit records are stored in the `SYSAUX` tablespace by default. You can supply a new tablespace by using the `DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION` procedure. This tablespace can be an encrypted tablespace. To find the records have been generated for the audit policies that are in effect, you can query `UNIFIED_AUDIT_TRAIL` data dictionary view.
The audit trail captures an audit record for each reference of a table or a view within a SQL statement. For example, if you run a `UNION` statement that references the `HR.EMPLOYEES` table twice, then an audit policy for statement generates two audit records, one for each access of the `HR.EMPLOYEES` table.
## Who Can Perform Fine-Grained Auditing?
Oracle provides roles for privileges needed to create fine-grained audit policies and to view and analyze fine-grained audit policy data.
The fine-grained audit privileges are as follows:
``````
- To create fine-grained audit policies, you must be granted d the AUDIT_ADMIN role or the EXECUTE privilege on the DBMS_FGA package.
- To view and analyze fine-grained audit data, you must be granted the AUDIT_VIEWER role.
The PL/SQL package is already granted to `AUDIT_ADMIN` role. As with all privileges, grant these roles to trusted users only. You can find the roles that user have been granted by querying the `DBA_ROLE_PRIVS` data dictionary view.
## Fine-Grained Auditing on Tables or Views That Have Oracle VPD Policies
The audit trail captures the VPD predicate for fine-grained audited tables or views that are included in an Oracle VPD policy.
This behavior is similar to how the unified audit trail captures the VPD predicate for unified audit policies.
The audit trail also captures internal predicates from Oracle Label Security and Oracle Real Application Security policies.
You do not need to create a special audit policy to capture the VPD predicate audit records. The predicate information is automatically stored in the `RLS_INFO` column of the `DBA_FGA_AUDIT_TRAIL` and `UNIFIED_AUDIT_TRAIL` data dictionary views.
If there are multiple VPD policies applied to the same table or view, then by default the predicates for these policies are concatenated in the `RLS_INFO` column. You can reformat the output so that each predicate is in its own row (identified by its corresponding VPD policy name and other information) by using the functions in the `DBMS_AUDIT_UTIL` PL/SQL package.
## Fine-Grained Auditing in a Multitenant Environment
You can create fine-grained audit policies in the CDB root, application root, CDB PDBs, and application PDBs.
Note the following general rules about fine-grained audit policies in a multitenant environment:
- You cannot create fine-grained audit policies on SYS objects.
- You cannot create fine-grained audit policies, either local or application common, for extended data link objects.
- When you create a fine-grained audit policy in the CDB root, the policy cannot be applied to all PDBs. It only applies to objects within the CDB root. (In other words, there is no such thing as a common fine-grained audit policy for the CDB root.) If you want to create a fine-grained audit policy to audit a common object’s access in all the PDBs, then you must explicitly create that policy in each PDB and then enable it on the common objects that is accessible in the PDB.
- When you create a fine-grained audit policy in a PDB, it applies only to objects within the PDB.
````````
- You can create application common fine-grained audit policies only if you are connected to the application root and only within the BEGIN/END block. If you are connected to the application root and create the fine-grained audit policy outside the BEGIN/END block, then the fine-grained audit policy is created in the application root.
- You cannot create application common fine-grained audit policies on local PDB objects.
- If the application common fine-grained audit policy has a handler, then this handler must be owned by either an application common user or a CDB common user.
````
- You can create an application fine-grained audit policy on local (PDB) objects and CDB common objects. Because the policy is local to its container, the object on which the policy is defined is audited only in the particular container where the policy is defined. For example, if you create a fine-grained audit policy in the hr_pdb PDB, the object for which you create this policy must exist in the hr_pdb PDB.
- You cannot create local fine-grained audit policies in an application PDB on object linked and extended data link objects. On metadata-linked objects are allowed in the fine-grained audit policy.
- Application root local policies are allowed for all application common objects.
- When you create a fine-grained audit policy as a common audit policy in an application root, it will be effective in each PDB that belongs to this application root. Therefore, any access to the application common object and CDB common object (on which the application common fine-grained audit policy is defined) from the application PDB is audited in the fine-grained audit trail in that application PDB.
````
- When you create scripts for application install, upgrade, patch, or uninstall operations, you can include SQL statements within the ALTER PLUGGABLE DATABASE app_name BEGIN INSTALL and ALTER PLUGGABLE DATABASE app_name END INSTALL blocks to perform various operations. You can include fine-grained audit policy statements only within these blocks.
````
- You can only enable, disable, or drop application common fine-grained audit policies from the application root, and from within a ALTER PLUGGABLE DATABASE app_name BEGIN INSTALL and ALTER PLUGGABLE DATABASE app_name END INSTALL block in a script.
## Fine-Grained Audit Policies with Editions
You can prepare an application for edition-based redefinition, and cover each table that the application uses with an editioning view.
If you do this, then you must move the fine-grained audit polices that protect these tables to the editioning view. You can find information about the currently configured editions by querying the DBA_EDITIONS data dictionary view. To find information about fine-grained audit policies, query DBA_AUDIT_POLICIES.
## Using the DBMS_FGA PL/SQL Package to Manage Fine-Grained Audit Policies
The `DBMS_FGA` PL/SQL package manages fine-grained audit policies.
- About the DBMS_FGA PL/SQL PL/SQL Package The DBMS_FGA PL/SQL package can be used to combine statements into one policy and perform other fine-grained auditing management tasks.
- The DBMS_FGA PL/SQL Package with Editions You can create DBMS_FGA policies for use in an editions environment.
- The DBMS_FGA PL/SQL Package in a Multitenant Environment In a multitenant environment, the DBMS_FGA PL/SQL package applies only to the current local PDBs.
- Creating a Fine-Grained Audit Policy The DBMS_FGA.ADD_POLICY procedure creates a fine-grained audit policy.
- Example: Using DBMS_FGA.ADD_POLICY to Create a Fine-Grained Audit Policy The DBMS_FGA.ADD_POLICY procedure can create a fine-grained audit policy using multiple statement types.
- Disabling a Fine-Grained Audit Policy The DBMS_FGA.DISABLE_POLICY procedure disables a fine-grained audit policy.
- Enabling a Fine-Grained Audit Policy The DBMS_FGA.ENABLE_POLICY procedure enables a fine-grained audit policy.
- Dropping a Fine-Grained Audit Policy The DBMS_FGA.DROP_POLICY procedure drops a fine-grained audit policy.
### About the DBMS_FGA PL/SQL PL/SQL Package
The `DBMS_FGA` PL/SQL package can be used to combine statements into one policy and perform other fine-grained auditing management tasks.
However, unless you want to perform column-level auditing or use event handlers with your audit policy, you should create audit policies as described in Auditing Activities with Unified Audit Policies and the AUDIT Statement.
The `DBMS_FGA` PL/SQL package enables you to add all combinations of `SELECT`, `INSERT`, `UPDATE`, and `DELETE` statements to one policy. You also can audit `MERGE` statements, by auditing the underlying actions of `INSERT` and `UPDATE`. To audit `MERGE` statements, configure fine-grained access on the `INSERT` and `UPDATE` statements. Only one record is generated for each policy for successful `MERGE` operations.
To administer fine-grained audit policies, you must have be granted the `AUDIT_ADMIN` role. Note also that the `EXECUTE` privilege for the `DBMS_FGA` package is mandatorily audited.
The audit policy is bound to the table for which you created it. This simplifies the management of audit policies because the policy only needs to be changed once in the database, not in each application. In addition, no matter how a user connects to the database-from an application, a Web interface, or through SQL*Plus or Oracle SQL Developer-Oracle Database records any actions that affect the policy.
If any rows returned from a query match the audit condition that you define, then Oracle Database inserts an audit entry into the fine-grained audit trail. This entry excludes all the information that is reported in the regular audit trail. In other words, only one row of audit information is inserted into the audit trail for every fine-grained audit policy that evaluates to true.
### The DBMS_FGA PL/SQL Package with Editions
You can create `DBMS_FGA` policies for use in an editions environment.
If you plan to use the `DBMS_FGA` package policy across different editions, then you can control the results of the policy: whether the results are uniform across all editions, or specific to the edition in which the policy is used.
### The DBMS_FGA PL/SQL Package in a Multitenant Environment
In a multitenant environment, the `DBMS_FGA` PL/SQL package applies only to the current local PDBs.
You cannot create one policy for the entire multitenant environment. The policy must be specific to objects within a PDB. To find PDBs, you can query the `DBA_PDBS` data dictionary view. To find the name of the current PDB, issue the `show con_name` command.
### Creating a Fine-Grained Audit Policy
The `DBMS_FGA.ADD_POLICY` procedure creates a fine-grained audit policy.
- About Creating a Fine-Grained Audit Policy The DBMS_FGA.ADD_POLICY procedure creates an audit policy using the supplied predicate as the audit condition.
- Syntax for Creating a Fine-Grained Audit Policy The DBMS_FGA.ADD_POLICY procedure includes many settings, such as the ability to use a handler for complex auditing.
**
- Audits of Specific Columns and Rows You can fine-tune audit behavior by targeting a specific column (relevant column) to be audited if a condition is met.
#### About Creating a Fine-Grained Audit Policy
The `DBMS_FGA.ADD_POLICY` procedure creates an audit policy using the supplied predicate as the audit condition.
By default, Oracle Database executes the policy predicate with the privileges of the user who owns the policy. The maximum number of fine-grained policies on any table or view object is 256. Oracle Database stores the policy in the data dictionary table, but you can create the policy on any table or view that is not in the `SYS` schema. In a multitenant environment, the fine grained policy is only created in the local PDB.
If you plan to create a materialized view on the the base table on which you want to create a fine-grained audit policy, then you must create the fine-grained audit policy on the base table *before* you create the materialized view on the same table. Otherwise, any refresh operations on the materialized view will fail with an `ORA-12008: error in materialized view refresh path` error.
You cannot modify a fine-grained audit policy after you have created it. If you must modify the policy, then drop and recreate it.
You can find information about a fine-grained audit policy by querying the `ALL_AUDIT_POLICIES`, `DBA_AUDIT_POLICIES`, and `USER_AUDIT_POLICIES` views. The `UNIFIED_AUDIT_TRAIL` view contains a column entitled `FGA_POLICY_NAME`, which you can use to filter out rows that were generated using a specific fine-grained audit policy.
#### Syntax for Creating a Fine-Grained Audit Policy
The `DBMS_FGA.ADD_POLICY` procedure includes many settings, such as the ability to use a handler for complex auditing.
The `DBMS_FGA.ADD_POLICY` procedure syntax is as follows:
```
DBMS_FGA.ADD_POLICY(
   object_schema      IN  VARCHAR2 DEFAULT NULL
   object_name        IN  VARCHAR2,
   policy_name        IN  VARCHAR2,
   audit_condition    IN  VARCHAR2 DEFAULT NULL,
   audit_column       IN  VARCHAR2 DEFAULT NULL
   handler_schema     IN  VARCHAR2 DEFAULT NULL,
   handler_module     IN  VARCHAR2 DEFAULT NULL,
   enable             IN  BOOLEAN DEFAULT TRUE,
   statement_types    IN  VARCHAR2 DEFAULT SELECT,
   audit_trail        IN  BINARY_INTEGER DEFAULT NULL,
   audit_column_opts  IN  BINARY_INTEGER DEFAULT ANY_COLUMNS,
   policy_owner       IN  VARCHAR2 DEFAULT NULL);
```
In this specification:
````
- object_schema specifies the schema of the object to be audited. (If NULL, the current log-on user schema is assumed.)
- object_name specifies the name of the object to be audited.
- policy_name specifies the name of the policy to be created. Ensure that this name is unique.
````````
````````````````
  - Do not include functions, which execute the auditable statement on the same base table, in the audit_condition setting. For example, suppose you create a function that executes an INSERT statement on the HR.EMPLOYEES table. The policy’s audit_condition contains this function and it is for INSERT statements (as set by statement_types). When the policy is used, the function executes recursively until the system has run out of memory. This can raise the error ORA-1000: maximum open cursors exceeded or ORA-00036: maximum number of recursive SQL levels (50) exceeded.
````
  - Do not issue the DBMS_FGA.ENABLE_POLICY or DBMS_FGA.DISABLE_POLICY statement from a function in a policy’s condition.
``````
- audit_column specifies one or more columns to audit, including hidden columns. If set to NULL or omitted, all columns are audited. These can include Oracle Label Security hidden columns or object type columns. The default, NULL, causes audit if any column is accessed or affected.
````
- handler_schema: If an alert is used to trigger a response when the policy is violated, specifies the name of the schema that contains the event handler. The default, NULL, uses the current schema. See also Tutorial: Adding an Email Alert to a Fine-Grained Audit Policy.
````````````
  - Do not create recursive fine-grained audit handlers. For example, suppose you create a handler that executes an INSERT statement on the HR.EMPLOYEES table. The policy that is associated with this handler is for INSERT statements (as set by the statement_types parameter). When the policy is used, the handler executes recursively until the system has run out of memory. This can raise the error ORA-1000: maximum open cursors exceeded or ORA-00036: maximum number of recursive SQL levels (50) exceeded.
``````
  - Do not issue the DBMS_FGA.ENABLE_POLICY or DBMS_FGA.DISABLE_POLICY statement from a policy handler. Doing so can raise the ORA-28144: Failed to execute fine-grained audit handler error.
````
- enable enables or disables the policy using true or false. If omitted, the policy is enabled. The default is TRUE.
``````````````````
- statement_types: Specifies the SQL statements to be audited: INSERT, UPDATE, DELETE, or SELECT only. If you want to audit a MERGE operation, then set statement_types to 'INSERT,UPDATE'. The default is SELECT.
- audit_trail: If you have migrated to unified auditing, then Oracle Database ignores this parameter and writes the audit records immediately to the unified audit trail. If you have migrated to unified auditing, then omit this parameter. Be aware that sensitive data, such as credit card information, can be recorded in clear text.
````
- audit_column_opts: If you specify more than one column in the audit_column parameter, then this parameter determines whether to audit all or specific columns. See Audits of Specific Columns and Rows for more information.
- policy_owner is the user who owns the fine-grained auditing policy. However, this setting is not a user-supplied argument. The Oracle Data Pump client uses this setting internally to recreate the fine-grained audit policies appropriately.
#### Audits of Specific Columns and Rows
You can fine-tune audit behavior by targeting a specific column (*relevant column*) to be audited if a condition is met.
To accomplish this, you use the `audit_column` parameter to specify one or more sensitive columns. In addition, you can audit data in specific rows by using the `audit_condition` parameter to define a Boolean condition. (However, if your policy needs only to audit for conditions, consider using an audit policy condition described in Creating a Condition for a Unified Audit Policy.)
The following settings from Example 27-47 enable you to perform an audit if anyone in Department 50 (`DEPARTMENT_ID = 50`) tries to access the `SALARY` and `COMMISSION_PCT` columns.
```
audit_condition    => 'DEPARTMENT_ID = 50', audit_column       => 'SALARY,COMMISSION_PCT,'
```
As you can see, this feature is enormously beneficial. It not only enables you to pinpoint particularly important types of data to audit, but it provides increased protection for columns that contain sensitive data, such as Social Security numbers, salaries, patient diagnoses, and so on.
If the `audit_column` lists more than one column, then you can use the `audit_column_opts` parameter to specify whether a statement is audited when the query references *any* column specified in the `audit_column` parameter or only when *all* columns are referenced. For example:
```
audit_column_opts   => DBMS_FGA.ANY_COLUMNS, audit_column_opts   => DBMS_FGA.ALL_COLUMNS,
```
If you do not specify a relevant column, then auditing applies to all columns.
### Example: Using DBMS_FGA.ADD_POLICY to Create a Fine-Grained Audit Policy
The `DBMS_FGA.ADD_POLICY` procedure can create a fine-grained audit policy using multiple statement types.
Example 27-47 shows how to audit statements `INSERT`, `UPDATE`, `DELETE`, and `SELECT` on table `HR.EMPLOYEES`.
Note that this example omits the `audit_column_opts` parameter, because it is not a mandatory parameter.
Example 27-47 Using DBMS_FGA.ADD_POLICY to Create a Fine-Grained Audit Policy
```
BEGIN DBMS_FGA.ADD_POLICY( object_schema      => 'HR', object_name        => 'EMPLOYEES', policy_name        => 'chk_hr_employees', audit_column       => 'SALARY', enable             =>  TRUE, statement_types    => 'INSERT, UPDATE, SELECT, DELETE');
END;
/
```
After you create the policy, if you query the `DBA_AUDIT_POLICIES` view, you will find the new policy listed:
```
SELECT POLICY_NAME FROM DBA_AUDIT_POLICIES;
POLICY_NAME
-------------------------------
CHK_HR_EMPLOYEES
```
Afterwards, any of the following SQL statements log an audit event record.
```
SELECT COUNT(*) FROM HR.EMPLOYEES WHERE COMMISSION_PCT = 20 AND SALARY > 4500;
SELECT SALARY FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 50;
DELETE FROM HR.EMPLOYEES WHERE SALARY > 1000000;
```
### Disabling a Fine-Grained Audit Policy
The `DBMS_FGA.DISABLE_POLICY` procedure disables a fine-grained audit policy.
  - Use the following syntax to disable a fine-grained audit policy:
```
DBMS_FGA.DISABLE_POLICY( object_schema  VARCHAR2, object_name    VARCHAR2, policy_name    VARCHAR2);
```
For example, to disable the fine-grained audit policy that was created in Example 27-47.
```
BEGIN DBMS_FGA.DISABLE_POLICY( object_schema        => 'HR', object_name          => 'EMPLOYEES', policy_name          => 'chk_hr_employees');
END;
/
```
### Enabling a Fine-Grained Audit Policy
The `DBMS_FGA.ENABLE_POLICY` procedure enables a fine-grained audit policy.
  - Use the following syntax to enable a fine-grained audit policy:
```
DBMS_FGA.ENABLE_POLICY( object_schema  VARCHAR2, object_name    VARCHAR2, policy_name    VARCHAR2, enable         BOOLEAN);
```
For example, to reenable the `chk_hr_emp` policy by using the `DBMS_FGA.ENABLE_POLICY` procedure
```
BEGIN DBMS_FGA.ENABLE_POLICY( object_schema        => 'HR', object_name          => 'EMPLOYEES', policy_name          => 'chk_hr_employees', enable               => TRUE);
END;
/
```
### Dropping a Fine-Grained Audit Policy
The `DBMS_FGA.DROP_POLICY` procedure drops a fine-grained audit policy.
Oracle Database automatically drops the audit policy if you remove the object specified in the `object_name` parameter of the `DBMS_FGA.ADD_POLICY` procedure, or if you drop the user who created the audit policy.
  - Use the following syntax to drop a fine-grained audit policy:
```
DBMS_FGA.DROP_POLICY( object_schema  VARCHAR2, object_name    VARCHAR2, policy_name    IVARCHAR2);
```
For example, to drop a fine-grained audit policy manually by using the `DBMS_FGA.DROP_POLICY` procedure:
```
BEGIN DBMS_FGA.DROP_POLICY( object_schema      => 'HR', object_name        => 'EMPLOYEES', policy_name        => 'chk_hr_employees');
END;
/
```
## Tutorial: Adding an Email Alert to a Fine-Grained Audit Policy
This tutorial demonstrates how to create a fine-grained audit policy that generates an email alert when users violate the policy.
- About This Tutorial This tutorial shows how you can add an email alert to a fine-grained audit policy that goes into effect when a user (or an intruder) violates the policy.
- Step 1: Install and Configure the UTL_MAIL PL/SQL Package The UTL_MAIL PL/SQL manages email that includes commonly used email features, such as attachments, CC, and BCC.
- Step 2: Create User Accounts You must create an administrative account and an auditor user.
- Step 3: Configure an Access Control List File for Network Services An access control list (ACL) file can be used to enable fine-grained access to external network services.
- Step 4: Create the Email Security Alert PL/SQL Procedure The email security alert PL/SQL procedure generates a message describing the violation and then sends this message to the appropriate users.
- Step 5: Create and Test the Fine-Grained Audit Policy Settings The fine-grained audit policy will trigger the alert when the policy is violated.
- Step 6: Test the Alert With the components in place, you are ready to test the alert.
- Step 7: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
### About This Tutorial
This tutorial shows how you can add an email alert to a fine-grained audit policy that goes into effect when a user (or an intruder) violates the policy.
```

```
To add an email alert to a fine-grained audit policy, you first must create a procedure that generates the alert, and then use the following `DBMS_FGA.ADD_POLICY` parameters to call this function when someone violates this policy:
- handler_schema: The schema in which the handler event is stored
- handler_module: The name of the event handler
The alert can come in any form that best suits your environment: an email or pager notification, updates to a particular file or table, and so on. Creating alerts also helps to meet certain compliance regulations, such as California Senate Bill 1386. In this tutorial, you will create an email alert.
In this tutorial, you create an email alert that notifies a security administrator that a Human Resources representative is trying to select or modify salary information in the `HR.EMPLOYEES` table. The representative is permitted to make changes to this table, but to meet compliance regulations, we want to create a record of all salary selections and modifications to the table.
### Step 1: Install and Configure the UTL_MAIL PL/SQL Package
The `UTL_MAIL` PL/SQL manages email that includes commonly used email features, such as attachments, CC, and BCC.
You must install and configure this package before you can use it. It is not installed and configured by default.
  ````- Log on as user SYS with the SYSDBA administrative privilege.
```
sqlplus sys as sysdba
Enter password: password
```
- In a multitenant environment, connect to the appropriate PDB. For example:
```
CONNECT SYS@hrpdb AS SYSDBA
Enter password: password
```
```
To find the available PDBs, run the `show pdbs` command. To check the current PDB, run the `show con_name` command.
```
  - Install the UTL_MAIL package.
```
@$ORACLE_HOME/rdbms/admin/utlmail.sql
@$ORACLE_HOME/rdbms/admin/prvtmail.plb
```
```
The `UTL_MAIL` package enables you to manage email.
Be aware that currently, the `UTL_MAIL` PL/SQL package does not support SSL servers.
```
- Check the current value of the SMTP_OUT_SERVER initialization parameter, and make a note of this value so that you can restore it when you complete this tutorial. For example:
```
SHOW PARAMETER SMTP_OUT_SERVER
```
```
If the `SMTP_OUT_SERVER` parameter has already been set, then output similar to the following appears:
```
```
NAME                    TYPE              VALUE
----------------------- ----------------- ----------------------------------
SMTP_OUT_SERVER         string            some_imap_server.example.com
```
  - Issue the following ALTER SYSTEM statement:
```
ALTER SYSTEM SET SMTP_OUT_SERVER="imap_mail_server.example.com";
```
```
Replace *imap_mail_server.example.com* with the name of your SMTP server, which you can find in the account settings in your email tool. Enclose these settings in quotation marks. For example:
```
```
ALTER SYSTEM SET SMTP_OUT_SERVER="my_imap_server.example.com";
```
  ````- Connect as SYS using the SYSOPER privilege and then restart the database.
```
CONNECT SYS AS SYSOPER -- Or, CONNECT SYS@hrpdb AS SYSOPER Enter password: password SHUTDOWN IMMEDIATE STARTUP
```
  - Ensure that the SMTP_OUT_SERVER parameter setting is correct.
```
CONNECT SYS AS SYSDBA -- Or, CONNECT SYS@hrpdb AS SYSDBA Enter password: password SHOW PARAMETER SMTP_OUT_SERVER
```
```
Output similar to the following appears:
```
```
NAME                    TYPE              VALUE
----------------------- ----------------- ----------------------------------
SMTP_OUT_SERVER         string            my_imap_server.example.com
```
### Step 2: Create User Accounts
You must create an administrative account and an auditor user.
``````
- Ensure that you are connected as SYS using the SYSDBA administrative privilege, and then create the fga_admin user, who will create the fine-grained audit policy. For example:
```
CONNECT SYS AS SYSDBA -- Or, CONNECT SYS@hrpdb AS SYSDBA
Enter password: password
CREATE USER fga_admin IDENTIFIED BY password;
GRANT CREATE SESSION, CREATE PROCEDURE, AUDIT_ADMIN TO fga_admin;
GRANT EXECUTE ON UTL_TCP TO fga_admin;
GRANT EXECUTE ON UTL_SMTP TO fga_admin;
GRANT EXECUTE ON UTL_MAIL TO fga_admin;
GRANT EXECUTE ON DBMS_NETWORK_ACL_ADMIN TO fga_admin;
```
```
Follow the guidelines in  [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
The `UTL_TCP`, `UTL_SMTP`, `UTL_MAIL`, and `DBMS_NETWORK_ACL_ADMIN` PL/SQL packages are used by the email security alert that you create.
```
  - Create the auditor user, who will check the audit trail for this policy.
```
GRANT CREATE SESSION TO fga_auditor IDENTIFIED BY password;
GRANT AUDIT_VIEWER TO fga_auditor;
```
  - Connect as user SYSTEM.
```
CONNECT SYSTEM -- Or, CONNECT SYSTEM@hrpdb
Enter password: password
```
  ````- Ensure that the HR schema account is unlocked and has a password. If necessary, unlock HR and grant this user a password.
```
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS WHERE USERNAME = 'HR';
```
```
The account status should be `OPEN`. If the `DBA_USERS` view lists user `HR` as locked and expired, then enter the following statement to unlock the `HR` account and create a new password:
```
```
ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY password;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to create a password that is secure. For greater security, do **not** give the `HR` account the same password from previous releases of Oracle Database.
```
  - Create a user account for Susan Mavris, who is an HR representative whose actions you will audit, and then grant this user access to the HR.EMPLOYEES table.
```
GRANT CREATE SESSION TO smavris IDENTIFIED BY password;
GRANT SELECT, INSERT, UPDATE, DELETE ON HR.EMPLOYEES TO SMAVRIS;
```
### Step 3: Configure an Access Control List File for Network Services
An access control list (ACL) file can be used to enable fine-grained access to external network services.
Before you can use PL/SQL network utility packages such as `UTL_MAIL`, you must configure this type of access control list (ACL) file.
  - Connect to SQL*Plus as user fga_admin.
```
CONNECT fga_admin -- Or, CONNECT fga_admin@hrpdb Enter password: password
```
  - Configure the following access control setting and its privilege definitions.
```
BEGIN DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE( host       => 'SMTP_OUT_SERVER_setting', lower_port => 25, ace        =>  xs$ace_type(privilege_list => xs$name_list('smtp'), principal_name => 'FGA_ADMIN', principal_type => xs_acl.ptype_db));
END;
/
```
```
In this example:
- *SMTP_OUT_SERVER_setting*: Enter the `SMTP_OUT_SERVER` setting that you set for the `SMTP_OUT_SERVER` parameter in [Step 1: Install and Configure the UTL_MAIL PL/SQL Package](#GUID-A1927687-CA58-4B98-B902-5625DAB8C5E6). This setting should match exactly the setting that your email tool specifies for its outgoing server.
- *lower_port*: Enter the port number that your email tool specifies for its outgoing server. Typically, this setting is 25. Enter this value for the `lower_port` setting. (Currently, the `UTL_MAIL` package does not support SSL. If your email server is an SSL server, then enter 25 for the port number, even if the email server uses a different port number.)
- `ace`: Define the privileges here.
```
### Step 4: Create the Email Security Alert PL/SQL Procedure
The email security alert PL/SQL procedure generates a message describing the violation and then sends this message to the appropriate users.
```
CREATE OR REPLACE PROCEDURE email_alert (sch varchar2, tab varchar2, pol varchar2) AS msg varchar2(20000) := 'HR.EMPLOYEES table violation. The time is: ';
BEGIN msg := msg||TO_CHAR(SYSDATE, 'Day DD MON, YYYY HH24:MI:SS');
UTL_MAIL.SEND ( sender      => 'youremail@example.com', recipients  => 'recipientemail@example.com', subject     => 'Table modification on HR.EMPLOYEES', message     => msg);
END email_alert;
/
```
````````
  - CREATE OR REPLACE PROCEDURE ...AS: You must include a signature that describes the schema name (sch), table name (tab), and the name of the audit procedure (pol) that you will define in audit policy in the next step.
````****
  - sender and recipients: Replace youremail@example.com with your email address, and recipientemail@example.com with the email address of the person you want to receive the notification.
### Step 5: Create and Test the Fine-Grained Audit Policy Settings
The fine-grained audit policy will trigger the alert when the policy is violated.
  ````- As user fga_admin, create the chk_hr_emp policy fine-grained audit policy as follows.
```
BEGIN
 DBMS_FGA.ADD_POLICY (
  object_schema      =>  'HR',
  object_name        =>  'EMPLOYEES',
  policy_name        =>  'CHK_HR_EMP',
  audit_column       =>  'SALARY',
  handler_schema     =>  'FGA_ADMIN',
  handler_module     =>  'EMAIL_ALERT',
  enable             =>   TRUE,
  statement_types    =>  'SELECT, UPDATE');
END;
/
```
  - Commit the changes you have made to the database.
```
COMMIT;
```
  - Test the settings that you have created so far.
```
EXEC email_alert ('hr', 'employees', 'chk_hr_emp');
```
```
SQL*Plus should display a `PL/SQL procedure successfully completed` message, and in a moment, depending on the speed of your email server, you should receive the email alert.
If you receive an `ORA-24247: network access denied by access control list (ACL)` error followed by `ORA-06512: at `*string*`line` *string* errors, then check the settings in the access control list file.
```
### Step 6: Test the Alert
With the components in place, you are ready to test the alert.
  - Connect to SQL*Plus as user smavris, check your salary, and give yourself a nice raise.
```
CONNECT smavris -- Or, CONNECT smavris@hrpdb
Enter password: password
SELECT SALARY FROM HR.EMPLOYEES WHERE LAST_NAME = 'Mavris';
SALARY
-----------
6500
UPDATE HR.EMPLOYEES SET SALARY = 38000 WHERE LAST_NAME = 'Mavris';
```
```
By now, depending on the speed of your email server, you (or your recipient) should have received an email with the subject header `Table modification on HR.EMPLOYEES` notifying you of the tampering of the `HR.EMPLOYEES` table. Now all you need to do is to query the `UNIFIED_AUDIT_TRAIL` data dictionary view to find who the violator is.
```
  ````- As user fga_auditor, query the UNIFIED_AUDIT_TRAIL data dictionary view as follows:
```
CONNECT fga_auditor -- Or, CONNECT fga_auditor@hrpdb Enter password: password col dbusername format a20 col sql_text format a66 col audit_type format a17 SELECT DBUSERNAME, SQL_TEXT, AUDIT_TYPE FROM UNIFIED_AUDIT_TRAIL WHERE OBJECT_SCHEMA = 'HR' AND OBJECT_NAME = 'EMPLOYEES';
```
```
Output similar to the following appears:
```
```
DBUSERNAME  SQL_TEXT                                                          AUDIT_TYPE
----------  ----------------------------------------------------------------- ----------------
SMAVRIS     UPDATE HR.EMPLOYEES SET SALARY = 38000 WHERE LAST_NAME = 'Mavris' FineGrainedAudit
```
```
The audit trail captures the SQL statement that Susan Mavris ran that affected the `SALARY` column in the `HR.EMPLOYEES` table. The first statement she ran, in which she asked about her current salary, was not recorded because it was not affected by the audit policy. This is because Oracle Database executes the audit function as an autonomous transaction, committing only the actions of the `handler_module` setting and not any user transaction. The function has no effect on any user SQL transaction.
```
### Step 7: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  ``````````- Connect to SQL*Plus as user SYSTEM privilege, and then drop users fga_admin (including the objects in the fga_admin schema), fga_auditor, and smavris.
```
CONNECT SYSTEM -- Or, CONNECT SYSTEM@hrpdb
Enter password: password
DROP USER fga_admin CASCADE;
DROP USER fga_auditor;
DROP USER smavris;
```
  - Connect as user HR and remove the loftiness of Susan Mavris’s salary.
```
CONNECT HR -- Or, CONNECT HR@hrpdb
Enter password: password
UPDATE HR.EMPLOYEES SET SALARY = 6500 WHERE LAST_NAME = 'Mavris';
```
  - If you want, lock and expire HR, unless other users want to use this account:
```
ALTER USER HR PASSWORD EXPIRE ACCOUNT LOCK;
```
  ````- Issue the following ALTER SYSTEM statement to restore the SMTP_OUT_SERVER parameter to the previous value, from Step 5 under Step 1: Install and Configure the UTL_MAIL PL/SQL Package:
```
ALTER SYSTEM SET SMTP_OUT_SERVER="previous_value";
```
```
Enclose this setting in quotation marks. For example:
```
```
ALTER SYSTEM SET SMTP_OUT_SERVER="some_imap_server.example.com"
```
  - Restart the database instance.
## Related Topics
  - Auditing Specific, Fine-Grained Activities
  - Activities That Are Mandatorily Audited
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_LOCATION procedure
  **- Oracle Database Reference for more information about the UNIFIED_AUDIT_TRAIL data dictionary view
  - Auditing of Oracle Virtual Private Database Predicates for more information about the auditing of VPD predicates and for an example of how to use the DBMS_AUDIT_UTIL package functions to format captured audit data
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_AUDIT_UTIL PL/SQL package
  **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the DBMS_FGA package
  - How Editions Affects the Results of a Global Application Context PL/SQL Package
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_FGA.ADD_POLICY syntax
  **``````````- Oracle Database PL/SQL Packages and Types Reference for more information about the audit_condition, audit_column, and audit_column_opts parameters in the DBMS_FGA.ADD_POLICY procedure (see also the usage notes for the ADD_POLICY procedure in that section)
  **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the DISABLE_POLICY syntax
  **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the ENABLE_POLICY syntax
  **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the DROP_POLICY syntax
  **- Oracle Database PL/SQL Packages and Types Reference for more information about the UTL_MAIL package
  - Managing Fine-Grained Access in PL/SQL Packages and Types for detailed information about configuring an access control list (ACL) file
