# Auditing Oracle SQL*Loader Direct Load Path Events

You can use the `CREATE AUDIT POLICY` statement to audit Oracle SQL*Loader direct load path events.
* *
- [About Auditing in Oracle SQLLoader Direct Path Load Events](#GUID-FB95E495-EB22-4F8D-A1CC-3E7941C587FC) You must have the AUDIT_ADMIN role to audit Oracle SQLLoader direct path events.
* *
- [Oracle SQLLoader Direct Load Path Unified Audit Trail Events](#GUID-763CB41D-95C6-41E7-893A-625628436081) The unified audit trail can capture SQLLoader Direct Load Path events.
*
````*
- [Configuring a Unified Audit Trail Policy for Oracle SQLLoader Direct Path Events](#GUID-6FF4B103-6AF1-41A0-A319-B8603565F068) The CREATE AUDIT POLICY statement ACTIONS COMPONENT clause can create unified audit policies for Oracle SQLLoader direct path events.
*
*
- [Example: Auditing Oracle SQLLoader Direct Path Load Operations](#GUID-61E426CA-DEB8-49A0-AD9F-2C7C64D38675) The CREATE AUDIT POLICY statement can audit Oracle SQLLoader direct path load operations.
*
*
- [How SQLLoader Direct Path Load Audited Events Appear in the Audit Trail](#GUID-0B701360-918E-4EC2-A0B8-F016302BA184) The UNIFIED_AUDIT_TRAIL data dictionary view lists SQLLoader direct path load audited events.
## About Auditing in Oracle SQL*Loader Direct Path Load Events
You must have the `AUDIT_ADMIN` role to audit Oracle SQL*Loader direct path events.
To create SQL*Loader unified audit policies, you must set the `CREATE AUDIT POLICY` statement’s `COMPONENT` clause to `DIRECT_LOAD`. You can audit direct path load operations only, not other SQL*Loader loads, such as conventional path loads.
To access the audit trail, you can query the `DIRECT_PATH_NUM_COLUMNS_LOADED` column in the `UNIFIED_AUDIT_TRAIL` data dictionary view.
## Oracle SQL*Loader Direct Load Path Unified Audit Trail Events
The unified audit trail can capture SQL*Loader Direct Load Path events.
The unified audit trail captures information about direct path loads that SQL*Loader performs (that is, when you set `direct=true` on the SQL*Loader command line or in the SQL*Loader control file).
It also audits Oracle Call Interface (OCI) programs that use the direct path API.
## Configuring a Unified Audit Trail Policy for Oracle SQL*Loader Direct Path Events
The `CREATE AUDIT POLICY` statement `ACTIONS COMPONENT` clause can create unified audit policies for Oracle SQL*Loader direct path events.
  - Use the following syntax to create an Oracle SQL*Loader unified audit policy:
```
CREATE AUDIT POLICY policy_name ACTIONS COMPONENT=DIRECT_LOAD { LOAD };
```
For example:
```
CREATE AUDIT POLICY audit_sqlldr_pol ACTIONS COMPONENT=DIRECT_LOAD LOAD;
```
You can build more complex policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing Oracle SQL*Loader Direct Path Load Operations
The `CREATE AUDIT POLICY` statement can audit Oracle SQL*Loader direct path load operations.
Example 27-32 shows how to audit SQL*Loader direct path load operations.
Example 27-34 Auditing Oracle SQL*Loader Direct Path Load Operations
```
CREATE AUDIT POLICY audit_sqlldr_load_pol ACTIONS COMPONENT=DIRECT_LOAD LOAD;
AUDIT POLICY audit_sqlldr_load_pol;
```
## How SQL*Loader Direct Path Load Audited Events Appear in the Audit Trail
The `UNIFIED_AUDIT_TRAIL` data dictionary view lists SQL*Loader direct path load audited events.
The `DIRECT_PATH_NUM_COLUMNS_LOADED `column of the `UNIFIED_AUDIT_TRAIL` view shows the number of columns that were loaded using the SQL*Loader direct path load method. For example:
```
SELECT DBUSERNAME, ACTION_NAME, OBJECT_SCHEMA, OBJECT_NAME, DIRECT_PATH_NUM_COLUMNS_LOADED FROM UNIFIED_AUDIT_TRAIL WHERE AUDIT_TYPE = 'DIRECT PATH API';
DBUSERNAME  ACTION_NAME OBJECT_SCHEMA OBJECT_NAME  DIRECT_PATH_NUM_COLUMNS_LOADED
----------- ----------- ------------- ------------ ------------------------------
RLAYTON     INSERT       HR            EMPLOYEES    4
```
## Related Topics
  **- Oracle Database Utilities for detailed information about Oracle SQL*Loader
  **- Oracle Database Utilities for detailed information about direct path loads in Oracle SQL*Loader
  - Syntax for Creating a Unified Audit Policy
