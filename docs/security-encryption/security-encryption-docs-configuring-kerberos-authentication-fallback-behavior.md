# Configuring Kerberos Authentication Fallback Behavior

You can configure fallback behavior (password-based authentication) in case the Kerberos authentication fails.
After you have configured Kerberos authentication for Oracle clients to use Kerberos authentication to authenticate to an Oracle database, there are cases where you may want to fall back to password-based authentication. An example would be if you have fixed user database links in the Oracle database.
  ````````- To enable Kerberos authentication to fall back to password-based authentication, set the SQLNET.FALLBACK_AUTHENTICATION parameter to TRUE in the sqlnet.ora files on both the client and server. The default of this parameter is FALSE. This means that by default, the connection fails when Kerberos authentication fails.
## Related Topics
  **- Oracle Database Net Services Reference for more information about the SQLNET.FALLBACK_AUTHENTICATION parameter
