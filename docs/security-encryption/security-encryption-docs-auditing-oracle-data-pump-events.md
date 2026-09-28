# Auditing Oracle Data Pump Events

You can use the `CREATE AUDIT POLICY` statement to audit Oracle Data Pump.
``````
- About Auditing Oracle Data Pump Events The CREATE AUDIT POLICY statement COMPONENT clause must be set to DATAPUMP to create Oracle Data Pump unified audit policies.
- Oracle Data Pump Unified Audit Trail Events The unified audit trail can capture Oracle Data Pump events.
````
- Configuring a Unified Audit Policy for Oracle Data Pump The ACTIONS COMPONENT clause in the CREATE AUDIT POLICY statement can be used to create an Oracle Data Pump event unified audit policy.
- Example: Auditing Oracle Data Pump Import Operations The CREATE AUDIT POLICY statement can audit Oracle Data Pump import operations.
- Example: Auditing All Oracle Data Pump Operations The CREATE AUDIT POLICY statement can audit all Oracle Data Pump operations.
- How Oracle Data Pump Audited Events Appear in the Audit Trail The UNIFIED_AUDIT_TRAIL data dictionary view lists Oracle Data Pump audited events.
## About Auditing Oracle Data Pump Events
The `CREATE AUDIT POLICY` statement `COMPONENT` clause must be set to `DATAPUMP` to create Oracle Data Pump unified audit policies.
You can audit Data Pump export (`expdp`) and import (`impdp`) operations.
As with all unified auditing, you must have the `AUDIT_ADMIN` role before you can audit Oracle Data Pump events.
To access the audit trail, query the `UNIFIED_AUDIT_TRAIL` data dictionary view. The Data Pump-specific columns in this view begin with `DP_`.
Oracle Database records the Oracle Data Pump record before the worker process has determined or dispatched the actual workload. Therefore, there is no success or failure code that is captured in the audit record. A return code of 0 is expected behavior irrespective of the success or failure of the Data Pump job. Additionally, because Data Pump is restartable, reports on the success and failure status of the export or import operations might not be feasible to obtain.
## Oracle Data Pump Unified Audit Trail Events
The unified audit trail can capture Oracle Data Pump events.
The unified audit trail captures information about both export (`expdp`) and import (`impdp`) operations.
## Configuring a Unified Audit Policy for Oracle Data Pump
The `ACTIONS COMPONENT` clause in the `CREATE AUDIT POLICY` statement can be used to create an Oracle Data Pump event unified audit policy.
  - Use the following syntax to create a unified audit policy for Oracle Data Pump:
```
CREATE AUDIT POLICY policy_name
ACTIONS COMPONENT=DATAPUMP { EXPORT | IMPORT | ALL };
```
For example:
```
CREATE AUDIT POLICY audit_dp_export_pol
 ACTIONS COMPONENT=DATAPUMP EXPORT;
```
You can build more complex policies, such as those that include conditions. Remember that after you create the policy, you must use the `AUDIT` statement to enable it.
## Example: Auditing Oracle Data Pump Import Operations
The `CREATE AUDIT POLICY` statement can audit Oracle Data Pump import operations.
Example 27-32 shows how to audit all Oracle Data Pump import operations.
Example 27-32 Auditing Oracle Data Pump Import Operations
```
CREATE AUDIT POLICY audit_dp_import_pol
 ACTIONS COMPONENT=DATAPUMP IMPORT;
AUDIT POLICY audit_dp_import_pol;
```
## Example: Auditing All Oracle Data Pump Operations
The `CREATE AUDIT POLICY` statement can audit all Oracle Data Pump operations.
Example 27-33 shows how to audit both Oracle Database Pump export and import operations.
Example 27-33 Auditing All Oracle Data Pump Operations
```
CREATE AUDIT POLICY audit_dp_all_pol
 ACTIONS COMPONENT=DATAPUMP ALL;
AUDIT POLICY audit_dp_all_pol BY SYSTEM;
```
## How Oracle Data Pump Audited Events Appear in the Audit Trail
The `UNIFIED_AUDIT_TRAIL` data dictionary view lists Oracle Data Pump audited events.
The `DP_*` columns of the `UNIFIED_AUDIT_TRAIL` view show Oracle Data Pump-specific audit data. For example:
```
SELECT DP_TEXT_PARAMETERS1, DP_BOOLEAN_PARAMETERS1 FROM UNIFIED_AUDIT_TRAIL
WHERE AUDIT_TYPE = 'DATAPUMP';
DP_TEXT_PARAMETERS1                            DP_BOOLEAN_PARAMETERS1
---------------------------------------------- ----------------------------------
MASTER TABLE:  "SCOTT"."SYS_EXPORT_TABLE_01",  MASTER_ONLY: FALSE,
JOB_TYPE: EXPORT,                              DATA_ONLY: FALSE,
METADATA_JOB_MODE: TABLE_EXPORT,               METADATA_ONLY: FALSE,
JOB VERSION: 19.1.0.0,                         DUMPFILE_PRESENT: TRUE,
ACCESS METHOD: DIRECT_PATH,                    JOB_RESTARTED: FALSE
DATA OPTIONS: 0,
DUMPER DIRECTORY: NULL
REMOTE LINK: NULL,
TABLE EXISTS: NULL,
PARTITION OPTIONS: NONE
```
(This output was reformatted for easier readability.) Oracle Database records the Oracle Data Pump record before the worker process has determined or dispatched the actual workload. Therefore, there is no success or failure code that is captured in the audit record. A return code of 0 is expected behavior irrespective of the success or failure of the Data Pump job. Additionally, because Data Pump is restartable reports on the success and failure status of the export or import operations might not show as much data as desired.
## Related Topics
**- Oracle Database Utilities
  - Syntax for Creating a Unified Audit Policy
