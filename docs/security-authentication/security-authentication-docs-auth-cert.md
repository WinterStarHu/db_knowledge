# PostgreSQL: Documentation: 18: 20.12. Certificate Authentication

PostgreSQL: Documentation: 18: 20.12. Certificate Authentication Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
20.12. Certificate Authentication
Prev Up Chapter 20. Client Authentication Home Next
20.12. Certificate Authentication #
This authentication method uses SSL client certificates to perform authentication. It is therefore only available for SSL connections; see Section 18.9.2 for SSL configuration instructions. When using this authentication method, the server will require that the client provide a valid, trusted certificate. No password prompt will be sent to the client. The cn (Common Name) attribute of the certificate will be compared to the requested database user name, and if they match the login will be allowed. User name mapping can be used to allow cn to be different from the database user name.
The following configuration options are supported for SSL certificate authentication:
map Allows for mapping between system and database user names. See Section 20.2 for details.
It is redundant to use the clientcert option with cert authentication because cert authentication is effectively trust authentication with clientcert=verify-full.
Prev Up Next
20.11. RADIUS Authentication
Home
20.13. PAM Authentication
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
