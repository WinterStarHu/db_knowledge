# Configuring Kerberos Authentication

Kerberos is a trusted third-party authentication system that relies on shared secrets and presumes that the third party is secure.
- Enabling Kerberos Authentication To enable Kerberos authentication for Oracle Database, you must first install it, and then follow a set of configuration steps.
- Utilities for the Kerberos Authentication Adapter The Oracle Kerberos authentication adapter utilities are designed for an Oracle client with Oracle Kerberos authentication support installed.
- Connecting to an Oracle Database Server Authenticated by Kerberos After Kerberos is configured, you can connect to an Oracle database server without using a user name or password.
- Configuring Interoperability with a Windows 2008 Domain Controller KDC You can configure Oracle Database to interoperate with a Microsoft Windows 2008 domain controller key distribution center (KDC).
- Configuring Kerberos Authentication Fallback Behavior You can configure fallback behavior (password-based authentication) in case the Kerberos authentication fails.
````
- How to Securely Use Database Links with Kerberos and Microsoft Active Directory When using Windows Active Directory, the KERBEROS5_DELEGATION_MODE sqlnet.ora parameter introduced in Oracle AI Database 23.26.1 and Oracle Database 19.30 allows you to constrain ticket granting ticket (TGT) forwarding. This allows for a more secure configuration, but requires additional configuration in Active Directory if you use database links.
- Troubleshooting the Oracle Kerberos Authentication Configuration Oracle provides guidance for common Kerberos configuration problems.
