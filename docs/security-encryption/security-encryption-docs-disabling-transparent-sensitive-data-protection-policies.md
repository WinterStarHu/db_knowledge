# Disabling Transparent Sensitive Data Protection Policies

The `DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN` procedure disables one or all TSDP policies.
- Query the DBA_TSDP_POLICY_PROTECTION data dictionary view to find the protected columns and their associated transparent sensitive data protection policies. For example:
```
SELECT COLUMN_NAME, TSDP_POLICY FROM DBA_TSDP_POLICY_PROTECTION WHERE TABLE_NAME = 'CUST_CC';
COLUMN_NAME   TSDP_POLICY
------------  ------------------
CREDIT_CARD   redact_partial_cc
```
``````
- Run the DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN procedure. For example, to disable the redact_partial_cc policy on the CREDIT_CARD column of the CUST_CC table:
```
BEGIN DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN( schema_name          => 'OE', table_name           => 'CUST_CC', column_name          => 'CREDIT_CARD', policy               => 'redact_partial_cc');
END;
/
```
```
You can use the `%` wildcard in this procedure to specify multiple items. For example, to disable protection for any columns that begin with `CREDIT`, you could enter the following:
```
```
BEGIN DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN( schema_name          => 'OE', table_name           => 'CUST_CC', column_name          => 'CREDIT%', policy               => 'redact_partial_cc');
END;
/
```
```
To disable all transparent sensitive data protection policies for a table, you can omit the `policy` parameter. For example:
```
```
BEGIN DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN( schema_name          => 'OE', table_name           => 'CUST_CC', column_name          => '%');
END;
/
```
