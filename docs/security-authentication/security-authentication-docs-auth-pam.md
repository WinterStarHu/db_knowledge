# PostgreSQL: Documentation: 18: 20.13. PAM Authentication

PostgreSQL: Documentation: 18: 20.13. PAM Authentication Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
20.13. PAM Authentication
Prev Up Chapter 20. Client Authentication Home Next
20.13. PAM Authentication #
This authentication method operates similarly to password except that it uses PAM (Pluggable Authentication Modules) as the authentication mechanism. The default PAM service name is postgresql. PAM is used only to validate user name/password pairs and optionally the connected remote host name or IP address. Therefore the user must already exist in the database before PAM can be used for authentication. For more information about PAM, please read the Linux-PAM Page.
The following configuration options are supported for PAM:
pamservice PAM service name.
pam_use_hostname Determines whether the remote IP address or the host name is provided to PAM modules through the PAM_RHOST item. By default, the IP address is used. Set this option to 1 to use the resolved host name instead. Host name resolution can lead to login delays. (Most PAM configurations don't use this information, so it is only necessary to consider this setting if a PAM configuration was specifically created to make use of it.) Note If PAM is set up to read /etc/shadow, authentication will fail because the PostgreSQL server is started by a non-root user. However, this is not an issue when PAM is configured to use LDAP or other authentication methods.
Prev Up Next
20.12. Certificate Authentication
Home
20.14. BSD Authentication
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
