# Dropping Transparent Sensitive Data Protection Policies

You can drop an entire TSDP policy or a condition-enable-options combination from the policy.
If the policy only has one condition-enable-options combination, then Oracle Database drops the entire policy. You do not need to disable a policy before dropping it, but you do need to drop its associated sensitive column first, then its sensitive type.
  ````- Query the POLICY_NAME column of the DBA_TSDP_POLICY_FEATURE data dictionary view to find the policy that you want to drop.
```
SELECT POLICY_NAME FROM DBA_TSDP_POLICY_FEATURE;
POLICY_NAME
-----------------
redact_partial_cc
```
```
Remember that you must be granted the `SELECT_CATALOG_ROLE `role to query the transparent sensitive data protection data dictionary views.
```
- Find the sensitive column that is associated with this policy. For example:
```
SELECT COLUMN_NAME FROM DBA_TSDP_POLICY_PROTECTION WHERE TSDP_POLICY = 'redact_partial_cc';
COLUMN_NAME
-----------------
CREDIT_CARD
```
- Drop this sensitive column. For example:
```
BEGIN DBMS_TSDP_MANAGE.DROP_SENSITIVE_COLUMN ( schema_name        => 'OE', table_name         => 'CUST_CC', column_name        => 'CREDIT_CARD');
END;
/
```
- Find the sensitive type that is associated with this policy. For example:
```
SELECT SENSITIVE_TYPE FROM DBA_TSDP_POLICY_TYPE WHERE POLICY_NAME = 'redact_partial_cc';
SENSITIVE_TYPE
--------------------
credit_card_num_type
```
- Drop this sensitive type. For example:
```
BEGIN DBMS_TSDP_MANAGE.DROP_SENSITIVE_TYPE (   sensitive_type     => 'credit_card_num_type');END;
/
```
- Run the DBMS_TSDP_PROTECT.DROP_POLICY procedure to drop the policy. For example, to completely drop the policy:
```
BEGIN DBMS_TSDP_PROTECT.DROP_POLICY( policy_name     => 'redact_partial_cc');
END;
/
```
```
To drop the default condition-enable options combination from the policy:
```
```
DECLARE policy_conditions DBMS_TSDP_PROTECT.POLICY_CONDITIONS;
BEGIN DBMS_TSDP_PROTECT.DROP_POLICY ('redact_partial_cc', policy_conditions);
END;
/
```
```
To drop the default condition-enable options combination from the policy based on a specific condition:
```
```
DECLARE policy_conditions DBMS_TSDP_PROTECT.POLICY_CONDITIONS;
BEGIN policy_conditions (DBMS_TSDP_PROTECT.DATATYPE) := 'NUMBER';
DBMS_TSDP_PROTECT.DROP_POLICY ('redact_partial_cc', policy_conditions);
END;
/
```
