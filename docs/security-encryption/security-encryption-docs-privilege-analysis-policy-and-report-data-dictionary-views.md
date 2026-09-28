# Privilege Analysis Policy and Report Data Dictionary Views

Oracle Database provides data dictionary views that show information about analyzed privileges.
The following table lists these data dictionary views.

| View | Description |
|---|---|
| DBA_PRIV_CAPTURES | Lists information about existing privilege analysis policies |
| DBA_USED_PRIVS | Lists the privileges and capture runs that have been used for reported privilege analysis policies |
| DBA_UNUSED_GRANTS | Lists the privilege grants that have not been used |
| DBA_UNUSED_PRIVS | Lists the privileges and capture runs that have not been used for reported privilege analysis policies |
| DBA_USED_OBJPRIVS | Lists the object privileges and capture runs that have been used for reported privilege analysis policies. It does not include the object grant paths. |
| DBA_UNUSED_OBJPRIVS | Lists the object privileges and capture runs that have not been used for reported privilege analysis policies. It does not include the object privilege grant paths. |
| DBA_USED_OBJPRIVS_PATH | Lists the object privileges and capture runs that have been used for reported privilege analysis policies. It includes the object privilege grant paths. |
| DBA_UNUSED_OBJPRIVS_PATH | Lists the object privileges and capture runs that have not been used for reported privilege analysis policies. It includes the object privilege grant paths. |
| DBA_USED_SYSPRIVS | Lists the system privileges and capture runs that have been used for reported privilege analysis policies. It does not include the system privilege grant paths. |
| DBA_UNUSED_SYSPRIVS | Lists the system privileges and capture runs that have not been used for reported privilege analysis policies. It does not include the system privilege grant paths. |
| DBA_USED_SYSPRIVS_PATH | Lists the system privileges and capture runs that have been used for reported privilege analysis policies. It includes the system privilege grant paths. |
| DBA_UNUSED_SYSPRIVS_PATH | Lists the system privileges and capture runs that have not been used for reported privilege analysis policies. It includes system privilege grant paths |
| DBA_USED_PUBPRIVS | Lists all the privileges and capture runs for the PUBLIC role that have been used for reported privilege analysis policies |
| DBA_USED_USERPRIVS | Lists the user privileges and capture runs that have been used for reported privilege analysis policies. It does not include the user privilege grant paths. |
| DBA_UNUSED_USERPRIVS | Lists the user privileges and capture runs that have not been used for reported privilege analysis policies. It does not include the user privilege grant paths. |
| DBA_USED_USERPRIVS_PATH | Lists the user privileges and capture runs that have been used for reported privilege analysis policies. It includes the user privilege grant paths. |
| DBA_UNUSED_USERPRIVS_PATH | Lists the privileges and capture runs that have not been used for reported privilege analysis policies. It includes the user privilege grant paths. |

## Related Topics
**- Oracle Database Reference
