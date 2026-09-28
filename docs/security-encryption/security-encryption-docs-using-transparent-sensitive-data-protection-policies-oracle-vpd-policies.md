# Using Transparent Sensitive Data Protection Policies with Oracle VPD Policies

You can combine protections from TSDP and Oracle Virtual Private Database into one policy.
````
- About Using TSDP Policies with Oracle Virtual Private Database Policies To incorporate Oracle Virtual Private Database protection with transparent sensitive data protection policies, you must use the DBMS_TSDP_PROTECT and DBMS_RLS packages.
- DBMS_RLS.ADD_POLICY Parameters That Are Used for TSDP Policies Oracle Database provides a set of parameters for fine-tuning the behavior of TSDP policies.
- Tutorial: Creating a TSDP Policy That Uses Virtual Private Database Protection This tutorial demonstrates how to incorporate Oracle Virtual Private Database protection with a transparent sensitive data protection policy.
## About Using TSDP Policies with Oracle Virtual Private Database Policies
To incorporate Oracle Virtual Private Database protection with transparent sensitive data protection policies, you must use the `DBMS_TSDP_PROTECT` and `DBMS_RLS` packages.
This feature works as follows:
  - You create a VPD policy function with a suitable predicate. Later on, when you create the TSDP policy, you will refer to this VPD policy function by using the `policy_function` setting of the `DBMS_RLS.ADD_POLICY` procedure for the `feature_options` parameter of the `DBMS_TSDP_PROTECT.ADD_POLICY` procedure.
````
- You create a TSDP policy with the necessary VPD settings similar to the VPD policy function. The TSDP policy uses parameter settings from the DBMS_RLS.ADD_POLICY procedure to provide VPD protection. The table in DBMS_RLS.ADD_POLICY Parameters That Are Used for TSDP Policies lists these parameters. Be aware that parameters from the DBMS_RLS.ADD_GROUPED_POLICY policy are not supported.
- You associate the TSDP policy with the necessary sensitive types by using the DBMS_TSDP_PROTECT.ASSOCIATE_POLICY procedure.
- You then enable TSDP protection by using any of the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_* procedures.
````````
- You enable the TSDP policy. At this point, Oracle Database creates an internal VPD policy that uses the function that you created in Step 1. The name of the internal policy begins with ORA$VPD followed by an identifier (for example, ORA$VPD_6J6L3RSJSN2VAN0XF). You can find this policy by querying the POLICY_NAME column of the DBA_POLICIES data dictionary view.
- When users query the table, the output for the column is based on both the VPD protections and the TSDP policy that are now in place.
  - These protections remain in place until you disable the TSDP policy for this column. At that point, Oracle Database automatically drops the internal VPD policy, because it is no longer needed. If you reenable the TSDP policy, then the internal VPD policy is recreated.
## DBMS_RLS.ADD_POLICY Parameters That Are Used for TSDP Policies
Oracle Database provides a set of parameters for fine-tuning the behavior of TSDP policies.
The following table describes the `DBMS_RLS.ADD_POLICY` parameters that are permissible in the `FEATURE_OPTIONS` parameter when you use the `DBMS_TSDP_PROTECT.ADD_POLICY` or `DBMS_TSDP_PROTECT.ALTER_POLICY` procedure.

| Parameter | Description | Default |
|---|---|---|
| function_schema | Schema of the policy function (current default schema, if NULL). If no function_schema is specified, then the current user’s schema is assumed. | NULL |
| policy_function | Name of a function that generates a predicate for the policy. If the function is defined within a package, then you must include the name of the package (for example, my_package.my_function). | NULL |
| statement_types | Statement types to which the policy applies. It can be any combination of INDEX, SELECT, INSERT, UPDATE, or DELETE. The default is to apply to most of these types except INDEX. | NULL |
| update_check | Optional argument for INSERT or UPDATE statement types. Setting update_check to TRUE sets Oracle Database to check the policy against the value after an INSERT or UPDATE operation. The check applies only to the security relevant columns that are included in the policy definition. In other words, the INSERT or UPDATE operation will fail only if the security relevant column that is defined in the policy is added or updated in the INSERT or UPDATE statement. | FALSE |
| static_policy | If you set this value to TRUE, then Oracle Database assumes that the policy function for the static policy produces the same predicate string for anyone accessing the object, except for SYS or the privileged user who has the EXEMPT ACCESS POLICY privilege. | FALSE |
| policy_type | Default is NULL, which means policy_type is decided by the value of the static_policy parameter. Specifying any of these policy types overrides the value of static_policy. | NULL |
| long_predicate | Default is FALSE, which means the policy function can return a predicate with a length of up to 4000 bytes. TRUE means the predicate text string length can be up to 32K bytes. Policies existing before the availability of the long_predicate parameter retain a 32K limit. | FALSE |
| sec_relevant_cols_opt | If you specify this parameter, then transparent sensitive data protection inputs the sensitive column on which the protection is enabled to the sec_relevant_cols parameter of the DBMS_RLS.ADD_POLICY procedure. Allowed values are for sec_relevant_cols_opt are as follows: NULL enables the filtering defined with sec_relevant_cols to take effect or DBMS_RLS.ALL_ROWS displays all rows, but with sensitive column values, which are filtered by the sec_relevant_cols parameter, they display as NULL. | NULL |

## Tutorial: Creating a TSDP Policy That Uses Virtual Private Database Protection
This tutorial demonstrates how to incorporate Oracle Virtual Private Database protection with a transparent sensitive data protection policy.
- Step 1: Create the hr_appuser User Account First, you must create a sample user account and then grant this user the appropriate privileges.
- Step 2: Identify the Sensitive Columns As the sample user tsdp_admin, you are ready to identify sensitive columns to protect.
- Step 3: Create an Oracle Virtual Private Database Function TSDP will associate the Oracle VPD policy function with the VPD policy that is automatically created when the TSDP policy is enabled.
- Step 4: Create and Enable a Transparent Sensitive Data Protection Policy After you have created the VPD policy function, you can associate it with a transparent sensitive data protection policy.
- Step 5: Test the Transparent Sensitive Data Protection Policy Now, you are ready to test the transparent sensitive data protection policy.
- Step 6: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
### Step 1: Create the hr_appuser User Account
First, you must create a sample user account and then grant this user the appropriate privileges.
  ````- Log into the database instance as user SYS with the SYSDBA administrative privilege.
```
sqlplus sys as sysdba
Enter password: password
```
- If you are using a multitenant environment, then connect to the appropriate pluggable database (PDB). For example:
```
CONNECT SYS@hrpdb AS SYSDBA
Enter password: password
```
```
To find the available PDBs, run the `show pdbs` command. To check the current PDB, run the `show con_name` command.
```
  - Create the following user accounts:
```
GRANT CREATE SESSION TO hr_appuser IDENTIFIED BY password;
GRANT CREATE SESSION TO tsdp_admin IDENTIFIED BY password;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
```
  - Grant user tsdp_admin the following privileges:
```
GRANT CREATE PROCEDURE TO tsdp_admin;
GRANT EXECUTE ON DBMS_TSDP_MANAGE TO tsdp_admin;
GRANT EXECUTE ON DBMS_TSDP_PROTECT TO tsdp_admin;
GRANT EXECUTE ON DBMS_RLS to tsdp_admin;
```
  - Connect as user SCOTT.
```
CONNECT SCOTT -- Or, CONNECT SCOTT@hrpdb
Enter password: password
```
  ``````- Grant the hr_appuser the READ object privilege for the EMP table.
```
GRANT READ ON EMP TO hr_appuser;
```
### Step 2: Identify the Sensitive Columns
As the sample user `tsdp_admin`, you are ready to identify sensitive columns to protect.
  - Connect as user tsdp_admin.
```
CONNECT tsdp_admin -- Or, CONNECT tsdb_admin@hrpdb Enter password: password
```
  - Create the salary_type sensitive type:
```
BEGIN DBMS_TSDP_MANAGE.ADD_SENSITIVE_TYPE ( sensitive_type  => 'salary_type', user_comment    => 'Type for SCOTT.EMP column');
END;
/
```
  ````- Associate the salary_type sensitive type with the SCOTT.EMP table.
```
BEGIN
 DBMS_TSDP_MANAGE.ADD_SENSITIVE_COLUMN (
 schema_name        => 'SCOTT',
 table_name         => 'EMP',
 column_name        => 'SAL',
 sensitive_type     => 'salary_type',
 user_comment       => 'Sensitive column addition of SALARY_TYPE');
END;
/
```
### Step 3: Create an Oracle Virtual Private Database Function
TSDP will associate the Oracle VPD policy function with the VPD policy that is automatically created when the TSDP policy is enabled.
  - To create the VPD policy function, use the CREATE OR REPLACE FUNCTION procedure, as follows:
```
CREATE OR REPLACE FUNCTION vpd_function (
  v_schema IN VARCHAR2,
  v_objname IN VARCHAR2)
 RETURN VARCHAR2 AS
BEGIN
 RETURN 'SYS_CONTEXT(''USERENV'',''SESSION_USER'') = ''HR_APPUSER''';
END vpd_function;
/
```
### Step 4: Create and Enable a Transparent Sensitive Data Protection Policy
After you have created the VPD policy function, you can associate it with a transparent sensitive data protection policy.
  - Create the Transparent Sensitive Data Protection policy.
```
DECLARE
 vpd_feature_options DBMS_TSDP_PROTECT.FEATURE_OPTIONS;
 policy_conditions DBMS_TSDP_PROTECT.POLICY_CONDITIONS;
BEGIN
 vpd_feature_options ('policy_function') := 'vpd_function';
 vpd_feature_options ('sec_relevant_cols_opt') := 'DBMS_RLS.ALL_ROWS';
 dbms_tsdp_protect.add_policy('tsdp_vpd', DBMS_TSDP_PROTECT.VPD, vpd_feature_options, policy_conditions);
END;
/
```
```
In this example, the `vpd_feature_options` parameter refers to the `sec_relevant_cols_opt` parameter from the `DBMS_RLS.ADD_POLICY` procedure. When the TSDP policy is enabled, the VPD policy that is automatically created will have its `sec_relevant_cols` parameter (of `DBMS_RLS.ADD_POLICY`) set to the name of the sensitive column on which TSDP enables the VPD policy. If you had not used the `sec_relevant_cols_opt` parameter, then TSDP would not have used the `DBMS_RLS.ADD_POLICY` `sec_relevant_cols_opt` parameter.
```
  ````- Associate the tsdp_vpd1 TSDP policy with the salary_type sensitive type.
```
BEGIN DBMS_TSDP_PROTECT.ASSOCIATE_POLICY( policy_name        => 'tsdp_vpd', sensitive_type     => 'salary_type', associate          => TRUE);
END;
/
```
  - Enable protection to enforce the Virtual Private Database policy on all columns identified as SALARY_TYPE:
```
BEGIN DBMS_TSDP_PROTECT.ENABLE_PROTECTION_TYPE( sensitive_type           => 'salary_type');
END;
/
```
### Step 5: Test the Transparent Sensitive Data Protection Policy
Now, you are ready to test the transparent sensitive data protection policy.
  - Connect as user hr_appuser.
```
password
```
  - Query the SCOTT.EMP table as follows:
```
SELECT SAL, COMM, EMPNO FROM SCOTT.EMP;
```
```
The following output appears:
```
```
SAL   COMM   EMPNO
--------- ------ ----------
800          7369 1600    300   7499 1250    500   7521 2975          7566 1250   1400   7654 2850          7698 2450          7782 3000          7788 5000          7839 1500     0    7844 1100          7876 950          7900 3000          7902 1300          7934 14 rows selected.
```
```
The `vpd_function` function enables user `hr_appuser` to see the salaries in the `SAL` column of the `EMP` table.
```
  - Connect as user SCOTT and then perform the same query.
```
CONNECT SCOTT -- Or, CONNECT SCOTT@hrpdb Enter password: password SELECT SAL, COMM, EMPNO FROM SCOTT.EMP;
```
```
The following output appears:
```
```
SAL   COMM   EMPNO
--------- ------ ----------
7369 300   7499 500   7521 7566 1400   7654 7698 7782 7788 7839 0    7844 7876 7900 7902 7934 14 rows selected.
```
```
Even though `SCOTT` owns the `EMP` table, the `vpd_function` function prevents him from seeing the salaries in the `SAL` column of this table
```
### Step 6: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
  - Connect as user tsdp_admin.
```
CONNECT tsdp_admin -- Or, CONNECT tsdp_admin@hrpdb Enter password: password
```
  - Execute the following statements in the order shown.
```
BEGIN DBMS_TSDP_MANAGE.DROP_SENSITIVE_COLUMN ( schema_name        => 'SCOTT', table_name         => 'EMP', column_name        => 'SAL');
END;
/
```
```
BEGIN DBMS_TSDP_MANAGE.DROP_SENSITIVE_TYPE( sensitive_type     => 'salary_type');
END;
/ BEGIN DBMS_TSDP_PROTECT.DROP_POLICY( policy_name     => 'tsdp_vpd');
END;
/
```
  - Connect as user SYSTEM.
```
CONNECT SYSTEM -- Or, CONNECT SYSTEM@hrpdb Enter password: password
```
  ````- Drop the tsdp_admin and hr_appuser accounts.
```
DROP USER tsdp_admin CASCADE;
DROP USER hr_appuser
```
## Related Topics
  - Function to Generate the Dynamic WHERE Clause
  - Attaching a Policy to a Database Table, View, or Synonym
