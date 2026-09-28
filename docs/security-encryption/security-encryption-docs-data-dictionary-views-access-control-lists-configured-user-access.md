# Data Dictionary Views for Access Control Lists Configured for User Access

Oracle Database provides data data dictionary views that you can use to find information about existing access control lists.
The following table lists these views.

| View | Description |
|---|---|
| DBA_HOST_ACES | Shows the network privileges defined for the network hosts. The SELECT privilege on this view is granted to the SELECT_CATALOG_ROLE role only. |
| DBA_WALLET_ACES | Lists the wallet path, ACE order, start and end times, grant type, privilege, and information about principals |
| DBA_WALLET_ACLS | Shows the access control list assignments to the wallets. The SELECT privilege on this view is granted to the SELECT_CATALOG_ROLE role only. |
| DBA_HOST_ACLS | Shows the access control list assignments to the network hosts. The SELECT privilege on this view is granted to the SELECT_CATALOG_ROLE role only. |
| USER_HOST_ACES | Shows the status of the network privileges for the current user to access network hosts. The SELECT privilege on the view is granted to PUBLIC. |
| USER_WALLET_ACES | Shows the status of the wallet privileges for the current user to access contents in the wallets. The SELECT privilege on the view is granted to PUBLIC. |

## Related Topics
**- Oracle Database Reference
