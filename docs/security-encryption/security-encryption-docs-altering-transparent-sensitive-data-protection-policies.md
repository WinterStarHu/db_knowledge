# Altering Transparent Sensitive Data Protection Policies

The `DBMS_TSDP_PROTECT.ALTER_POLICY` procedure can alter a TSDP policy.
When you alter a transparent data protection policy, you must define how the Data Redaction settings must change, and then apply these changes to the transparent sensitive data protection policy itself.
You can find a list of existing policies and their protection definitions by querying the `DBA_TSDP_POLICY_FEATURE` data dictionary view.
  - To alter a transparent sensitive data protection policy, use the DBMS_TSDP_PROTECT.ALTER_POLICY procedure.
For example, to alter an existing transparent sensitive data protection policy:
```
DECLARE
  redact_feature_options SYS.DBMS_TSDP_PROTECT.FEATURE_OPTIONS;
  policy_conditions SYS.DBMS_TSDP_PROTECT.POLICY_CONDITIONS;
  BEGIN
  redact_feature_options ('expression') :=
   'SYS_CONTEXT(''USERENV'',''SESSION_ USER'') =''APPUSER''';
  redact_feature_options ('function_type') := 'DBMS_REDACT.PARTIAL';
  redact_feature_options ('function_parameters') := '9,1,6';
  policy_conditions(DBMS_TSDP_PROTECT.DATATYPE) := 'NUMBER';
  policy_conditions(DBMS_TSDP_PROTECT.LENGTH) := '22';
 DBMS_TSDP_PROTECT.ALTER_POLICY ('redact_partial_cc',
  redact_feature_options, policy_conditions);
END;
/
```
In this example:
``````
- redact_feature_options SYS.DBMS_TSDP_PROTECT.FEATURE_OPTIONS creates the variable redact_feature_options, which uses the FEATURE_OPTIONS data type.
``````
- policy_conditions SYS.DBMS_TSDP_PROTECT.POLICY_CONDITIONS creates the variable policy_conditions, which uses the POLICY_CONDITIONS data type.
``````**
- redact_feature_options ... redact_feature_optionswrites the Data Redaction policy settings to the redact_feature_option variable. This example applies the Data Redaction policy to the user APPUSER, defines the policy as a partial data redaction for number data types. See Oracle Database Advanced Security Guide for information about how the function_parameters parameter works for this case.
``````
- policy_conditions ... policy_conditions writes the TSDP policy conditions to the policy_conditions variable (that is, the data type and length) for the protected NUMBER data type column.
``````````
- DBMS_TSDP_PROTECT.ALTER_POLICY ... executes the DBMS_TSDP_PROTECT.ALTER_POLICY procedure, which alters the redact_partial_cc TSDP policy to use the definitions set in the redact_feature_options and policy_conditions variables.
