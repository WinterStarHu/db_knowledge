# Transparent Sensitive Data Protection Data Dictionary Views

Oracle Database provides data dictionary views that list information about transparent sensitive data protection policies.
The following table describes these views. Before you can use these views, you must be granted the `SELECT_CATALOG_ROLE` role.

| View | Description |
|---|---|
| DBA_DISCOVERY_SOURCE | Describes discovery import information with regard to transparent sensitive data protection policies |
| DBA_SENSITIVE_COLUMN_TYPES | Describes the sensitive column types that have been defined for the current database |
| DBA_SENSITIVE_DATA | Describes the sensitive columns in the database |
| DBA_TSDP_IMPORT_ERRORS | Shows information regarding the errors encountered during import of discovery result. It shows information with regard to the error code, schema name, table name, column name, and sensitive type. |
| DBA_TSDP_POLICY_CONDITION | Describes the transparent sensitive data protection policy and condition mapping. This view also lists the property-value pairs for the condition. |
| DBA_TSDP_POLICY_FEATURE | Shows the transparent sensitive data protection policy security feature mapping. (At this time, only Oracle Data Redaction and Oracle Virtual Private Database are supported.) |
| DBA_TSDP_POLICY_PARAMETER | Describes the parameters of transparent sensitive data protection policies |
| DBA_TSDP_POLICY_PROTECTION | Shows the list of columns that have been protected through transparent sensitive data protection |
| DBA_TSDP_POLICY_TYPE | Shows the policy to sensitive column type mapping |

## Related Topics
**- Oracle Database Reference
