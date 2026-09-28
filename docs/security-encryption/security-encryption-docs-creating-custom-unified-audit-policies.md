# Auditing Activities with Unified Audit Policies and the AUDIT Statement

You can use the `CREATE AUDIT POLICY` and `AUDIT` statements to use unified audit policies.
- About Auditing Activities with Unified Audit Policies and AUDIT You can audit the several types of activities, using unified audit policies and the AUDIT SQL statement.
- Best Practices for Creating Custom Unified Audit Policies You can enable multiple policies at a time in the database, but ideally, limit the number of enabled policies.
- Syntax for Creating a Unified Audit Policy To create a unified audit policy, you must use the CREATE AUDIT POLICY statement.
- Auditing Roles You can use the CREATE AUDIT POLICY statement to audit database roles.
- Auditing System Privileges You can use the CREATE AUDIT POLICY statement to audit system privileges.
- Auditing Administrative Users You can create unified audit policies to capture the actions of administrative user accounts, such as SYS.
- Auditing Object Actions You can use the CREATE AUDIT POLICY statement to audit object actions.
``````
- Auditing the READ ANY TABLE and SELECT ANY TABLE Privileges The CREATE AUDIT POLICY statement can audit the READ ANY TABLE and SELECT ANY TABLE privileges.
- Auditing SQL Statements and Privileges in a Multitier Environment You can create a unified audit policy to audit the activities of a client in a multitier environment.
- Creating a Condition for a Unified Audit Policy You can use the CREATE AUDIT POLICY statement to create conditions for a unified audit policy.
- Auditing Application Context Values You can use the AUDIT statement to audit application context values.
- Auditing Oracle Database Real Application Security Events You can use CREATE AUDIT POLICY statement to audit Oracle Database Real Application Security events.
- Auditing Oracle Recovery Manager Events You can use the CREATE AUDIT POLICY statement to audit Oracle Recovery Manager events.
- Auditing Oracle Database Vault Events In an Oracle Database Vault environment, the CREATE AUDIT POLICY statement can audit Database Vault activities.
- Auditing Oracle Label Security Events In an Oracle Label Security environment, the CREATE AUDIT POLICY statement can audit Oracle Label Security activities.
- Auditing Oracle Data Mining Events You can use the CREATE AUDIT POLICY statement to audit Oracle Data Mining events.
- Auditing Oracle Data Pump Events You can use the CREATE AUDIT POLICY statement to audit Oracle Data Pump.
*
*
- [Auditing Oracle SQLLoader Direct Load Path Events](auditing-oracle-sqlloader-direct-load-path-events.html#GUID-E7DAC7DA-7164-4B2D-81BC-4094BDDE4EC7) You can use the CREATE AUDIT POLICY statement to audit Oracle SQLLoader direct load path events.
- Auditing Only Top-Level Statements You can audit top-level SQL or PL/SQL statements to limit the volume of audit records.
- Unified Audit Policies or AUDIT Settings in a Multitenant Environment In a multitenant environment, you can create unified audit policies for individual PDBs and in the root.
- Altering Unified Audit Policies You can use the ALTER AUDIT POLICY statement to modify a unified audit policy.
- Enabling and Applying Unified Audit Policies to Users and Roles You can use the AUDIT POLICY statement to enable and apply unified audit policies to users and roles.
- Disabling Unified Audit Policies You can use the NOAUDIT POLICY statement to disable a unified audit policy.
- Dropping Unified Audit Policies You can use the DROP AUDIT POLICY statement to drop a unified audit policy.
- Tutorial: Auditing Nondatabase Users This tutorial shows how to create a unified audit policy that uses a client identifier to audit a nondatabase user’s actions.
## Related Topics
  - Auditing SQL Statements, Privileges, and Other General Activities
