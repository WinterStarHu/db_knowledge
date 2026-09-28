# Creating Transparent Sensitive Data Protection Policies

You must create a sensitive type, find the sensitive columns to be protected, and then import these columns from ADM into your database.
- Step 1: Create a Sensitive Type The sensitive type is a class of data that you designate as sensitive.
- Step 2: Identify the Sensitive Columns to Protect After you define a sensitive column, you are ready to identify the columns to protect.
- Step 3: Import the Sensitive Columns List from ADM into Your Database Next, you are ready to import the sensitive columns list from ADM into your database.
- Step 4: Create the Transparent Sensitive Data Protection Policy After you have created the list of sensitive columns and imported this list into your database, you can create the transparent sensitive data protection policy.
- Step 5: Associate the Policy with a Sensitive Type The DBMS_TSDP_PROTECT.ASSOCIATE_POLICY procedure associates a TSDP policy with a sensitive type.
- Step 6: Enable the Transparent Sensitive Data Protection Policy You can enable the TSDP policy for the current database in a protected source, a specific table column, or a specific column type.
- Step 7: Optionally, Export the Policy to Other Databases You can export or import the policy to or from another database.
## Step 1: Create a Sensitive Type
The sensitive type is a class of data that you designate as sensitive.
For example, you can create a `credit_card_type` sensitive type for all credit card numbers.
- To create a sensitive type, either create it from an Enterprise Manager Cloud Control Application Data Model or use the DBMS_TSDP_MANAGE.ADD_SENSITIVE_TYPE PL/SQL procedure. To drop a sensitive type, you can use the DBMS_TSDP_MANAGE.DROP_SENSITIVE_TYPE procedure.
For example, to create the sensitive type `credit_card_num_type`:
```
BEGIN
 DBMS_TSDP_MANAGE.ADD_SENSITIVE_TYPE (
  sensitive_type  => 'credit_card_num_type',
  user_comment    => 'Type for credit card columns using a number data type');
END;
/
```
In this example:
````
- sensitive_type: Create a name that describes the sensitive type that you want to capture. This value is case sensitive, so when you reference it later on, ensure that you use the case in which you created it. You can find existing sensitive types by querying the DBA_SENSITIVE_COLUMN_TYPES data dictionary view.
- user_comment: Optionally, enter a description for the sensitive type.
## Step 2: Identify the Sensitive Columns to Protect
After you define a sensitive column, you are ready to identify the columns to protect.
To identify the columns to protect, based on the sensitive type that you defined, you either can use an Enterprise Manager Cloud Control Application Data Model to identify these columns, or you can use the `DBMS_TSDP_MANAGE.ADD_SENSITIVE_COLUMN` procedure.
To remove the column from the list of sensitive columns for the database, you can use the `DBMS_TSDP_MANAGE.DROP_SENSITIVE_COLUMN` procedure.
- Find the sensitive type that you want to use. For example:
```
SELECT NAME FROM DBA_SENSITIVE_COLUMN_TYPES;
NAME
---------------------
credit_card_num_type
```
````
- Execute the DBMS_TSDP_MANAGE.ADD_SENSITIVE_COLUMN procedure to associate the sensitive type with a table column. Ensure that you enter the sensitive_type parameter using the case in which you used to create the sensitive type. For example:
```
BEGIN
 DBMS_TSDP_MANAGE.ADD_SENSITIVE_COLUMN(
 schema_name        => 'OE',
 table_name         => 'CUST_CC',
 column_name        => 'CREDIT_CARD',
 sensitive_type     => 'credit_card_num_type',
 user_comment       => 'Sensitive column addition of credit_card_num_type');
END;
/
```
## Step 3: Import the Sensitive Columns List from ADM into Your Database
Next, you are ready to import the sensitive columns list from ADM into your database.
- If you had used an Application Data Model to create the list of sensitive columns, then import this list into your database by running the DBMS_TSDP_MANAGE.IMPORT_DISCOVERY_RESULT procedure. If you had used the DBMS_TSDP_MANAGE.ADD_SENSITIVE_COLUMN procedure to identify these columns, then you can bypass this step.
For example, to import the Cloud Control Application Data Model into the current database:
```
BEGIN
 DBMS_TSDP_MANAGE.IMPORT_DISCOVERY_RESULT (
 discovery_result      => xml_adm_result,
 discovery_source      => 'ADM_Demo');
END;
/
```
In this example:
- discovery_result refers to the list of sensitive columns and their associated sensitive types. This list is in XML format.
````****************
- discover_source refers to the name of the Application Data Model that contains the list of sensitive columns referred by the discovery_result setting. You can find a list of the Application Data Models from the Data Discovery and Modeling page in Enterprise Manager Cloud Control. (To access this page, from the Enterprise menu, select Quality Management, and then Data Discovery and Modeling. You can find a list of the sensitive columns and their associated types in the Sensitive Columns tab.)
## Step 4: Create the Transparent Sensitive Data Protection Policy
After you have created the list of sensitive columns and imported this list into your database, you can create the transparent sensitive data protection policy.
- About Creating the Transparent Sensitive Data Protection Policy The DBMS_TSDP_PROTECT.ADD_POLICY procedure creates the transparent sensitive data protection policy.
- Creating the Transparent Sensitive Data Protection Policy You can create a transparent sensitive data protection policy that uses a partial number data type-based Data Redaction policy.
- Setting the Oracle Data Redaction or Virtual Private Database Feature Options The TSDP feature options describe the Oracle Data Redaction or Virtual Private Database settings to use for the transparent sensitive data protection policy.
- Setting Conditions for the Transparent Sensitive Data Protection Policy Optionally, you can specify conditions for the transparent sensitive data protection policy.
``````
- Specifying the DBMS_TSDP_PROTECT.ADD_POLICY Procedure The DBMS_TSDP_PROTECT.ADD_POLICY procedure names the TSDP policy and executes the FEATURE_OPTIONS and POLICY_CONDITIONS settings.
### About Creating the Transparent Sensitive Data Protection Policy
The `DBMS_TSDP_PROTECT.ADD_POLICY` procedure creates the transparent sensitive data protection policy.
After you have identified the sensitive columns, and if you had used an Application Data Model to create the list of sensitive columns, and imported this list into your database, you are ready to create the transparent sensitive data protection policy. To create the transparent sensitive data protection policy, you must configure it for the Virtual Private Database or Oracle Data Redaction settings that you want to use, and then apply these settings to a transparent sensitive data protection policy defined by `DBMS_TSDP_PROTECT.ADD_POLICY`.
You can create the policy by defining an anonymous block that has the following components:
- If you are using Oracle Data Redaction for your policy, a specification of the type of Data Redaction that you want to use, such as partial Data Redaction
- If you are using Oracle Virtual Private Database for your policy, a specification of the VPD settings that you want to use
- Conditions to test when the policy is enabled. For example, the data type of the column which should be satisfied before the policy can be enabled.
- A named transparent sensitive data protection policy to tie these components together, by using the DBMS_TSDP_PROTECT.ADD_POLICY procedure
After you create the sensitive type, it resides in the `SYS` schema.
### Creating the Transparent Sensitive Data Protection Policy
You can create a transparent sensitive data protection policy that uses a partial number data type-based Data Redaction policy.
Example 15-1 shows how to create this type of policy.
  - To create the policy, use the DBMS_TSDP_PROTECT.ADD_POLICY procedure, as shown in Example 15-1.
Example 15-1 Creating a Transparent Sensitive Data Protection Policy
```
DECLARE
  redact_feature_options DBMS_TSDP_PROTECT.FEATURE_OPTIONS;
  policy_conditions DBMS_TSDP_PROTECT.POLICY_CONDITIONS;
BEGIN
  redact_feature_options ('expression') :=
   'SYS_CONTEXT(''USERENV'',''SESSION_USER'') =''APPUSER''';
  redact_feature_options ('function_type') := 'DBMS_REDACT.PARTIAL';
  redact_feature_options ('function_parameters') := '0,1,6';
  policy_conditions(DBMS_TSDP_PROTECT.DATATYPE) := 'NUMBER';
  policy_conditions(DBMS_TSDP_PROTECT.LENGTH) := '16';
 DBMS_TSDP_PROTECT.ADD_POLICY ('redact_partial_cc',
  DBMS_TSDP_PROTECT.REDACT,redact_feature_options,
   policy_conditions);
END;
/
```
In this example:
``````
- redact_feature_options DBMS_TSDP_PROTECT.FEATURE_OPTIONS creates the variable redact_feature_options, which uses the FEATURE_OPTIONS data type. See Setting the Oracle Data Redaction or Virtual Private Database Feature Options for more information.
``````
- policy_conditions DBMS_TSDP_PROTECT.POLICY_CONDITIONS creates the variable policy_conditions, which uses the POLICY_CONDITIONS data type. See Setting Conditions for the Transparent Sensitive Data Protection Policy for more information.
``````**
- redact_feature_options lines (3) write the Data Redaction policy settings to the redact_feature_option variable. This example applies the Data Redaction policy to the user APPUSER and defines the policy as a partial data redaction for number data types. See Oracle Database Advanced Security Guide for information about how the function_parameters parameter works for this case.
``````
- policy_conditions lines (2) write the TSDP policy conditions to the policy_conditions variable (that is, the data type and length) for the protected NUMBER data type column.
``````
- DBMS_TSDP_PROTECT.ADD_POLICY executes the DBMS_TSDP_PROTECT.ADD_POLICY procedure, which creates the redact_partial_cc TSDP policy. See Specifying the DBMS_TSDP_PROTECT.ADD_POLICY Procedure for more information.
If you want to see an example of a similar policy for VPD, see Step 4: Create and Enable a Transparent Sensitive Data Protection Policy.
### Setting the Oracle Data Redaction or Virtual Private Database Feature Options
The TSDP feature options describe the Oracle Data Redaction or Virtual Private Database settings to use for the transparent sensitive data protection policy.
  ````````- For Data Redaction, define the feature options by using the name redact_feature_options variable and for the type, you must use the type DBMS_TSDP_PROTECT.FEATURE_OPTIONS, which is an associative array of the data type VARCHAR2(TSDP_PARAM_MAX). Initialize these options with the parameter-value pairs that correspond with the DBMS_REDACT.ADD_POLICY parameters.
For example, to specify a TSDP policy that uses partial Data Redaction, Example 15-1 shows the following parameter-value pair:
```
redact_feature_options ('function_type')       := 'DBMS_REDACT.PARTIAL';
```
For a partial Data Redaction policy that uses a number data type for the protected column, Example 15-1 specifies the following additional parameter-value pairs:
```
redact_feature_options ('expression')          := 'expression';
redact_feature_options ('function_parameters') := 'values';
```
Similarly, for Virtual Private Database, you use the `vpd_feature_options` variable to define the VPD feature options. For example:
```
vpd_feature_options ('statement_types')   := 'SELECT, INSERT, UPDATE, DELETE';
```
### Setting Conditions for the Transparent Sensitive Data Protection Policy
Optionally, you can specify conditions for the transparent sensitive data protection policy.
However, if you choose to omit conditions, you still must include the following line in the `DECLARE` variables. (In this case, the default value for `policy_conditions` is an empty associative array.)
```
policy_conditions SYS.DBMS_TSDP_PROTECT.POLICY_CONDITIONS;
```
  ````````- To define the conditions, use the name policy_conditions for the variable and for the type, use type DBMS_TSDP_PROTECT.POLICY_CONDITIONS, which is an associative array of the data type VARCHAR2(TSDP_PARAM_MAX). Ensure that no two conditions are satisfied by a single target sensitive column. The target column’s properties should satisfy all the condition properties for the corresponding DBMS_TSDP_PROTECT.FEATURE_OPTIONS settings to be applied on the column
Example 15-1 shows the policy conditions as follows:
```
policy_conditions(DBMS_TSDP_PROTECT.DATATYPE) := 'NUMBER';
policy_conditions(DBMS_TSDP_PROTECT.LENGTH)   := '16';
```
Optionally, you can specify one or more of the following keys for the `POLICY_CONDITIONS` settings:
- DBMS_TSDP_PROTECT.DATATYPE enables you to specify a data type.
````
- DBMS_TSDP_PROTECT.LENGTH enables you to specify a data type length for the DBMS_TSDP_PROTECT.DATATYPE key.
- DBMS_TSDP_PROTECT.PARENT_SCHEMA enables you to restrict the policy to a specific schema. If you omit this setting, then the policy applies to all schemas in the database.
````
- DBMS_TSDP_PROTECT.PARENT_TABLE enables you to restrict the policy to a table specified by the DBMS_TSDP_PROTECT.PARENT_SCHEMA key. If you omit this setting, then the policy applies to all tables within the specified schema.
### Specifying the DBMS_TSDP_PROTECT.ADD_POLICY Procedure
The `DBMS_TSDP_PROTECT.ADD_POLICY` procedure names the TSDP policy and executes the `FEATURE_OPTIONS` and `POLICY_CONDITIONS` settings.
In the policy, the `redact_feature_options` and the `policy_conditions` settings work together: When the policy is enabled (using any of the `DBMS_TSDP_PROTECT.ENABLE_PROTECTION`* procedures) on the target object, then the `redact_feature_options` settings apply only if the corresponding `policy_condition` settings are satisfied. You must enter the following parameters:
````````
  - policy_name creates a name for the TSDP policy. The name that you enter is stored in the database using the case sensitivity that you used when you created it. For example, if you had entered redact_partial_cc, then the database stores it as redact_partial_cc, not redact_partial_cc.
````
  - security_feature refers to the security feature the TSDP policy will use. Enter DBMS_TSDP_PROTECT.REDACT to specify Oracle Data Redaction.
````
  - policy_enable_options refers to the variable that you defined for the DBMS_TSDP_PROTECT.FEATURE_OPTIONS type.
````
  - policy_apply_condition refers to the variable that you defined for the DBMS_TSDP_PROTECT.POLICY_CONDITIONS type.
Example 15-1 shows the policy set as follows:
```
DBMS_TSDP_PROTECT.ADD_POLICY('redact_partial_cc', DBMS_TSDP_PROTECT.REDACT, redact_feature_options, policy_conditions);
```
## Step 5: Associate the Policy with a Sensitive Type
The `DBMS_TSDP_PROTECT.ASSOCIATE_POLICY` procedure associates a TSDP policy with a sensitive type.
- Find the sensitive type that you want to use. For example, to find a list of all sensitive types:
```
SELECT NAME FROM DBA_SENSITIVE_COLUMN_TYPES ORDER BY NAME;
NAME
--------------------
credit_card_num_type
```
- Run the DBMS_TSDP_PROTECT.ASSOCIATE_POLICY procedure to associate the policy with a sensitive column type. For example:
```
BEGIN DBMS_TSDP_PROTECT.ASSOCIATE_POLICY( policy_name        => 'redact_partial_cc', sensitive_type     => 'credit_card_num_type', associate          => true);
END;
/
```
```
The following query shows that the `credit_card_num_type` is now associated with the `redact_partial_cc` policy.
```
```
SELECT POLICY_NAME, SENSITIVE_TYPE FROM DBA_TSDP_POLICY_TYPE ORDER BY SENSITIVE_TYPE;
POLICY_NAME       SENSITIVE_TYPE
----------------- --------------------
redact_partial_cc  credit_card_num_type
```
## Step 6: Enable the Transparent Sensitive Data Protection Policy
You can enable the TSDP policy for the current database in a protected source, a specific table column, or a specific column type.
- Enabling Protection for the Current Database in a Protected Source You can enable transparent sensitive data protection for the current database in a protected source.
- Enabling Protection for a Specific Table Column You can enable transparent sensitive data protection for a specific column in a table.
- Enabling Protection for a Specific Column Type You can enable transparent sensitive data protection for a specific column type, such as all columns that use the VARCHAR2 data type.
### Enabling Protection for the Current Database in a Protected Source
You can enable transparent sensitive data protection for the current database in a protected source.
If you must disable the protection, then you can run the `DBMS_TSDP_PROTECT.DISABLE_PROTECTION_SOURCE` procedure.
  - Run the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_SOURCE procedure to enable this type of protection.
For example, to enable transparent sensitive data protection policies for the `orders_db` database.
```
BEGIN DBMS_TSDP_PROTECT.ENABLE_PROTECTION_SOURCE( discovery_source       => 'orders_db');
END;
/
```
### Enabling Protection for a Specific Table Column
You can enable transparent sensitive data protection for a specific column in a table.
Remember that you can enable only one policy per table. If you must disable the protection, then you can run the `DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN` procedure.
  - Run the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_COLUMN procedure to enable this type of protection.
For example, to enable the transparent sensitive data protection policy `redact_partial_cc` for a specific table column:
```
BEGIN DBMS_TSDP_PROTECT.ENABLE_PROTECTION_COLUMN( schema_name          => 'OE', table_name           => 'CUST_CC', column_name          => 'CREDIT_CARD', policy               => 'redact_partial_cc');
END;
/
```
If an `ORA-45622: warnings generated during policy enforcement` error appears, then check the configuration of the policy. In this example, the `redact_partial_cc` policy is enabled on a column if this column is of the `NUMBER` data type and has a length of `16`. Even though the `OE.CUST_CC.CREDIT_CARD` column is associated with the `redact_partial_cc` policy, the policy is not enabled if this column fails to satisfy the conditions (data type and length).
### Enabling Protection for a Specific Column Type
You can enable transparent sensitive data protection for a specific column type, such as all columns that use the `VARCHAR2` data type.
If you must disable the protection, then you can run the `DBMS_TSDP_PROTECT.DISABLE_PROTECTION_TYPE` procedure.
  - Run the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_TYPE procedure to enable this type of protection.
For example, to enable transparent sensitive data protection for all columns that use the `credit_card_num_type` sensitive type:
```
BEGIN DBMS_TSDP_PROTECT.ENABLE_PROTECTION_TYPE( sensitive_type           => 'credit_card_num_type');
END;
/
```
## Step 7: Optionally, Export the Policy to Other Databases
You can export or import the policy to or from another database.
  - To export or import the TSDP policy to or from another database, use Oracle Data Pump to perform a full export or import of the database that contains the policy.
Remember that the export and import operations apply to the entire database, not just the transparent sensitive data protection policy.
## Related Topics
  **- Oracle Database Testing Guide for detailed information about Application Data Models
  **- Oracle Database PL/SQL Packages and Types Reference information about the DBMS_TSDP_MANAGE.ADD_SENSITIVE_TYPE PL/SQL procedure
  - Tutorial: Creating a TSDP Policy That Uses Virtual Private Database Protection
  **- Oracle Database Advanced Security Guide for more information about Data Redaction policy creation parameters
  - DBMS_RLS.ADD_POLICY Parameters That Are Used for TSDP Policies for more information about available VPD parameters
  **- Oracle Database Utilities for information about using Oracle Data Pump
  **- Oracle Database Vault Administrator’s Guide for information about using Oracle Data Pump in an Oracle Database Vault environment
