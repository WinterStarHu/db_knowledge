# PostgreSQL: Documentation: 18: 20.3. Authentication Methods

PostgreSQL: Documentation: 18: 20.3. Authentication Methods Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
20.3. Authentication Methods
Prev Up Chapter 20. Client Authentication Home Next
20.3. Authentication Methods #
PostgreSQL provides various methods for authenticating users:
Trust authentication, which simply trusts that users are who they say they are.
Password authentication, which requires that users send a password.
GSSAPI authentication, which relies on a GSSAPI-compatible security library. Typically this is used to access an authentication server such as a Kerberos or Microsoft Active Directory server.
SSPI authentication, which uses a Windows-specific protocol similar to GSSAPI.
Ident authentication, which relies on an “Identification Protocol” (RFC 1413) service on the client's machine. (On local Unix-socket connections, this is treated as peer authentication.) Peer authentication, which relies on operating system facilities to identify the process at the other end of a local connection. This is not supported for remote connections.
LDAP authentication, which relies on an LDAP authentication server.
RADIUS authentication, which relies on a RADIUS authentication server.
Certificate authentication, which requires an SSL connection and authenticates users by checking the SSL certificate they send.
PAM authentication, which relies on a PAM (Pluggable Authentication Modules) library.
BSD authentication, which relies on the BSD Authentication framework (currently available only on OpenBSD).
OAuth authorization/authentication, which relies on an external OAuth 2.0 identity provider.
Peer authentication is usually recommendable for local connections, though trust authentication might be sufficient in some circumstances. Password authentication is the easiest choice for remote connections. All the other options require some kind of external security infrastructure (usually an authentication server or a certificate authority for issuing SSL certificates), or are platform-specific.
The following sections describe each of these authentication methods in more detail.
Prev Up Next
20.2. User Name Maps
Home
20.4. Trust Authentication
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
