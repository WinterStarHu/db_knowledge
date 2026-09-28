# PostgreSQL: Documentation: 18: 20.14. BSD Authentication

PostgreSQL: Documentation: 18: 20.14. BSD Authentication Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
20.14. BSD Authentication
Prev Up Chapter 20. Client Authentication Home Next
20.14. BSD Authentication #
This authentication method operates similarly to password except that it uses BSD Authentication to verify the password. BSD Authentication is used only to validate user name/password pairs. Therefore the user's role must already exist in the database before BSD Authentication can be used for authentication. The BSD Authentication framework is currently only available on OpenBSD.
BSD Authentication in PostgreSQL uses the auth-postgresql login type and authenticates with the postgresql login class if that's defined in login.conf. By default that login class does not exist, and PostgreSQL will use the default login class.
Note To use BSD Authentication, the PostgreSQL user account (that is, the operating system user running the server) must first be added to the auth group. The auth group exists by default on OpenBSD systems.
Prev Up Next
20.13. PAM Authentication
Home
20.15. OAuth Authorization/Authentication
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
