# Auditing Oracle Data Mining Events

You can use the `CREATE AUDIT POLICY` statement to audit Oracle Data Mining events.
- About Auditing Oracle Data Mining Events You must have the AUDIT_ADMIN role to audit Oracle Data Mining events.
- Oracle Data Mining Unified Audit Trail Events The unified audit trail can capture Oracle Data Mining audit events..
``````
- Configuring a Unified Audit Policy for Oracle Data Mining The CREATE AUDIT POLICY statement ACTIONS and ON MINING MODEL clauses can be used to create Oracle Data Mining event unified audit policies.
- Example: Auditing Multiple Oracle Data Mining Operations by a User The CREATE AUDIT POLICY statement can audit multiple Oracle Data Mining operations.
- Example: Auditing All Failed Oracle Data Mining Operations by a User The CREATE AUDIT POLICY statement can audit failed Oracle Data Mining operations by a user.
- How Oracle Data Mining Events Appear in the Audit Trail The UNIFIED_AUDIT_TRAIL data dictionary view lists Oracle Data Mining audit events.
## About Auditing Oracle Data Mining Events
You must have the `AUDIT_ADMIN` role to audit Oracle Data Mining events.
To access the audit trail, you can query the `UNIFIED_AUDIT_TRAIL` data dictionary view.
## Oracle Data Mining Unified Audit Trail Events
The unified audit trail can capture Oracle Data Mining audit events..
The following table describes these events.

| Audit Event | Description |
|---|---|
| AUDIT | Generates an audit record for a Data Mining model |
| COMMENT | Adds a comment to a Data Mining model |
| GRANT | Gives permission to a user to access the Data Mining model |
| RENAME | Changes the name of the Data Mining model |
| SELECT | Applies the Data Mining model or view its signature |

## Configuring a Unified Audit Policy for Oracle Data Mining
The `CREATE AUDIT POLICY` statement `ACTIONS` and `ON MINING MODEL` clauses can be used to create Oracle Data Mining event unified audit policies.
  - Use the following syntax to create a unified audit policy for Oracle Data Mining:
```
CREATE AUDIT POLICY policy_name ACTIONS {operation | ALL} ON MINING MODEL schema_name.model_name;
```
For example:
```
CREATE AUDIT POLICY dm_ops ACTIONS RENAME ON MINING MODEL hr.dm_emp;
```
You can build more complex policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing Multiple Oracle Data Mining Operations by a User
The `CREATE AUDIT POLICY` statement can audit multiple Oracle Data Mining operations.
Example 27-30 shows how to audit multiple Oracle Data Mining operations by user `psmith`. Include the `ON MINING MODEL `*schema_name.model_name* clause for each event, and separate each with a comma. This example specifies the same *schema_name.model name* for both actions, but the syntax enables you to specify different *schema_name.model_name* settings for different schemas and data models.
Example 27-30 Auditing Multiple Oracle Data Mining Operations by a User
```
CREATE AUDIT POLICY dm_ops_pol ACTIONS SELECT ON MINING MODEL dmuser1.nb_model, ALTER ON MINING MODEL dmuser1.nb_model;
AUDIT POLICY dm_ops_pol BY psmith;
```
## Example: Auditing All Failed Oracle Data Mining Operations by a User
The `CREATE AUDIT POLICY` statement can audit failed Oracle Data Mining operations by a user.
Example 27-31 shows how to audit all failed Oracle Data Mining operations by user `psmith`.
Example 27-31 Auditing All Failed Oracle Data Mining Operations by a User
```
CREATE AUDIT POLICY dm_all_ops_pol ACTIONS ALL ON MINING MODEL dmuser1.nb_model;
AUDIT POLICY dm_all_ops_pol BY psmith WHENEVER NOT SUCCESSFUL;
```
## How Oracle Data Mining Events Appear in the Audit Trail
The `UNIFIED_AUDIT_TRAIL` data dictionary view lists Oracle Data Mining audit events.
The following example shows how to query the `UNIFIED_AUDIT_TRAIL` data dictionary view for Data Mining audit events.
```
SELECT DBUSERNAME, ACTION_NAME, SYSTEM_PRIVILEGE_USED, RETURN_CODE, OBJECT_SCHEMA, OBJECT_NAME, SQL_TEXT FROM UNIFIED_AUDIT_TRAIL;
DBUSERNAME ACTION_NAME          SYSTEM_PRIVILEGE_USED     RETURN_CODE
---------- -------------------- ------------------------- -----------
OBJECT_SCHEMA        OBJECT_NAME
-------------------- --------------------
SQL_TEXT
--------------------------------------------------------------------------------
DMUSER1    CREATE MINING MODEL  CREATE MINING MODEL                 0 DMUSER1 BEGIN dbms_data_mining.create_model(model_name => 'nb_model', mining_function => dbms_data_mining.classification, data_table_name => 'dm_data', case_id_column_name => 'case_id', target_column_name => 'target');
END;
DMUSER1    SELECT MINING MODEL                                      0 DMUSER1              NB_MODEL select prediction(nb_model using *) from dual DMUSER2    SELECT MINING MODEL                                  40284 DMUSER1              NB_MODEL select prediction(dmuser1.nb_model using *) from dual DMUSER1    ALTER MINING MODEL                                       0 DMUSER1              NB_MODEL BEGIN dbms_data_mining.rename_model('nb_model', 'nb_model1'); END;
DMUSER2    ALTER MINING MODEL                                   40284 DMUSER1              NB_MODEL BEGIN dbms_data_mining.rename_model('dmuser1.nb_model1', 'nb_model'); END;
DMUSER2    ALTER MINING MODEL                                   40284 DMUSER1              NB_MODEL BEGIN dbms_data_mining.rename_model('dmuser1.nb_model1', 'nb_model'); END;
```
## Related Topics
  **- Oracle Data Mining Concepts for more information about Oracle Data Mining
  - Syntax for Creating a Unified Audit Policy
