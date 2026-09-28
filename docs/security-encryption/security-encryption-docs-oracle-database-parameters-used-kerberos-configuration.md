# Parameters for Clients and Servers Using Kerberos Authentication

Oracle Database provides client and server parameters for using Kerberos authentication.
The following list describes parameters to insert into the configuration files for clients and servers using Kerberos.
**`sqlnet.ora`**
  - SQLNET.AUTHENTICATION_SERVICES=(KERBEROS5): Set on both client and server.
  - SQLNET.AUTHENTICATION_KERBEROS5_SERVICE=oracle: Set on both client and server.
  ``````- SQLNET.KERBEROS5_CC_NAME=/usr/tmp/DCE-CC: Not normally required on the server. If your client is on Microsoft Windows and is part of a domain, you may want to consider using the in-memory ticket cache and set this parameter to OSMSFT:// or MSLSA:.
  - SQLNET.KERBEROS5_CLOCKSKEW=1200: Set on both client and server.
  - SQLNET.KERBEROS5_CONF=/krb5/krb.conf: Set on both client and server. (Normally, this path in the client is different from the path in the server.)
  ````- SQLNET.KERBEROS5_CONF_MIT=(TRUE): Set this to TRUE on both the client and the server.
  - SQLNET.KERBEROS5_REALMS=/krb5/krb.realms: This setting is not usually required for the client or the server.
  - SQLNET.KERBEROS5_KEYTAB=/krb5/v5srvtab: Only set this parameter on the server, not the client.
  - SQLNET.FALLBACK_AUTHENTICATION=FALSE: Set on both client and server.
**`initialization parameter file`**
  - OS_AUTHENT_PREFIX="": Set this parameter only on the server, not the client.
## Related Topics
  - Step 6C: Set sqlnet.ora Parameters (Optional)
