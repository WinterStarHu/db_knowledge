# Updates to Oracle Database Security 19c

Oracle Database release 19c has several updates from the last update of release 19c.
- Authenticating and Authorizing IAM Users to Oracle Autonomous Database on Dedicated Exadata Infrastructure Available for Oracle Database release 19.14, users now can authenticate and authorize IAM users to Oracle Autonomous Database on Dedicated Exadata Infrastructure.
- Enhancements for Identity and Access Management Integration with Oracle Database Environments Available for Oracle Database release 19.16 are enhancements to the integration of Identity and Access Management (IAM) users with Oracle Database Environments.
- Identity and Access Management Integration with Oracle Autonomous Cloud Databases Available for Oracle Database release 19.13, Identity and Access Management (IAM) users can log in to an Oracle Autonomous Database Serverless using either password or token-based authentication.
- Database Integration Support for Non-Default Domains for Identity and Access Management with Identity Domains Starting with this release, Oracle Database supports non-default domains in tenancies with Identity and Access Management (IAM) with Identity Domains.
- Microsoft Azure Active Directory Integration with Additional Oracle Database Environments Including On-Premises Available for Oracle Database release 19.16, Microsoft Azure Active Directory (Azure AD) users can log in to additional Oracle Database environments with their Azure AD OAuth2 access token.
- Microsoft Azure Active Directory Integration with Oracle Cloud Infrastructure Autonomous Databases Available for Oracle Autonomous Database in June, 2022, Microsoft Azure Active Directory (Azure AD) users can log in to Oracle Cloud Infrastructure (OCI) Autonomous Database with their Azure AD OAuth2 access token.
- Gradual Database Password Rollover for Applications Available for Oracle Database release 19.12, an application can change its database passwords without an administrator having to schedule downtime.
- Ability to Use Multiple Kerberos Principals with a Single Database Client Available for Oracle Database release 19.10, when you configure Kerberos authentication for an Oracle Database client, you can specify multiple Kerberos principals with a single Oracle Database client.
- Updated Support for Micro Edition Suite (MES) for FIPS 140.2 Available for Oracle Database release 19.10, Oracle Database supports Micro Edition Suite (MES) version 4.5 for FIPS 140.2.
- Support for DBMS_CRYPTO Asymmetric Key Operations Available for Oracle Database release 19.9, the DBMS_CRYPTO PL/SQL package supports asymmetric key operations, in addition to the existing support for symmetric key operations.
- SYSLOG Destination for Common Unified Audit Policies Available with Oracle Database release 19.9, certain predefined columns of unified audit records from common unified audit policies can be written to the UNIX SYSLOG destination.
- Security Update for Native Encryption Oracle provides a patch that you can download to address necessary security enhancements that affect native network encryption environments in Oracle Database release 11.2 and later.
- Ability to Configure Transport Layer Security Connections without Client Wallets Available in Oracle Database release 19.14, an Oracle Database client will not be required to provide a wallet to hold well-known CA root certificates if they are available elsewhere in the local system.
````
- TLS_ALLOW_WEAK_DN_MATCH Parameter to Control the Behavior of TLS_SERVER_DN_MATCH Available with Oracle Database release 19.23, you can use the TLS_ALLOW_WEAK_DN_MATCH parameter to control how TLS_SERVER_DN_MATCH allows the service name for partial distinguished name matching and to only check the database server certificate.
````
- SSL_ Parameter Deprecation in Favor of TLS_ Parameters Starting with Oracle Database release 19.30, Oracle is deprecating parameters prefixed with SSL_ in favor of parameters prefixed with TLS_.
## Authenticating and Authorizing IAM Users to Oracle Autonomous Database on Dedicated Exadata Infrastructure
Available for Oracle Database release 19.14, users now can authenticate and authorize IAM users to Oracle Autonomous Database on Dedicated Exadata Infrastructure.
Additional enhancements are as follows:
- Applications can now connect to an Autonomous Database instance by using end-user, instance, and resource principals.
- IAM users can now proxy to an Autonomous Database by using a database user schema.
- Database links are supported for IAM connections.
For more information, see Authenticating and Authorizing IAM Users for Oracle DBaaS Databases.
## Enhancements for Identity and Access Management Integration with Oracle Database Environments
Available for Oracle Database release 19.16 are enhancements to the integration of Identity and Access Management (IAM) users with Oracle Database Environments.
****
  - Oracle Autonomous Database on Dedicated Exadata Infrastructure
  - Oracle Autonomous Database Serverless
  - Oracle Base Database Service
****
- Ability to use the IAM user name and password to retrieve an IAM token: Retrieving a token using an IAM user name and password or secure external password store (SEPS) is more secure than using the password verifier method of database access.
## Identity and Access Management Integration with Oracle Autonomous Cloud Databases
Available for Oracle Database release 19.13, Identity and Access Management (IAM) users can log in to an Oracle Autonomous Database Serverless using either password or token-based authentication.
An IAM `ADMIN` user can configure both the authentication and authorization of IAM users and IAM groups. The IAM user can log in to the Oracle Autonomous Database using tools such as SQL*Plus or SQLcl.
This enhancement provides the security advantages of both IAM and Oracle Database. For example, the Oracle Database gradual password rollover feature can be used in this configuration and update the application passwords without downtime.
## Database Integration Support for Non-Default Domains for Identity and Access Management with Identity Domains
Starting with this release, Oracle Database supports non-default domains in tenancies with Identity and Access Management (IAM) with Identity Domains.
The following releases are supported:
- Oracle Autonomous Database Serverless
- Oracle Autonomous Database on Dedicated Exadata Infrastructure
This update allows IAM users in non-default IAM domains to access the database with IAM database password verifiers or IAM access tokens. IAM users in default domains are already supported.
In previous releases, the IAM integration only worked with users and groups from the default domain, and did not support users and groups from custom, non-default domains.
## Microsoft Azure Active Directory Integration with Additional Oracle Database Environments Including On-Premises
Available for Oracle Database release 19.16, Microsoft Azure Active Directory (Azure AD) users can log in to additional Oracle Database environments with their Azure AD `OAuth2` access token.
The previous release supported Azure AD integration support for Oracle Cloud Infrastructure (OCI) Autonomous Databases. This release has expanded Azure AD integration support to on-premises Oracle Database release 19.16 and later, but not for Oracle Database 21c.
You can use Azure AD `OAuth2` tokens to access the database. Azure AD users can access the database directly using their Azure AD token, and applications can use their service tokens to access the database.
For more information, see Authenticating and Authorizing Microsoft Azure Active Directory Users for Oracle Databases.
## Microsoft Azure Active Directory Integration with Oracle Cloud Infrastructure Autonomous Databases
Available for Oracle Autonomous Database in June, 2022, Microsoft Azure Active Directory (Azure AD) users can log in to Oracle Cloud Infrastructure (OCI) Autonomous Database with their Azure AD `OAuth2` access token.
OCI Oracle Autonomous Database now can accept Azure AD `OAuth2` tokens to access the database. Azure AD users can access the database directly using their Azure AD token, and applications can use their service tokens to access the database.
You can use Azure AD `OAuth2` tokens to access the database. Azure AD users can access the database directly using their Azure AD token, and applications can use their service tokens to access the database.
## Gradual Database Password Rollover for Applications
Available for Oracle Database release 19.12, an application can change its database passwords without an administrator having to schedule downtime.
To accomplish this, a database administrator can associate a profile having a non-zero limit for the `PASSWORD_ROLLOVER_TIME` password profile parameter, new with this release, with an application schema. This allows the database password of the application user to be altered while allowing the older password to remain valid for the time specified by the `PASSWORD_ROLLOVER_TIME` limit. During the rollover period of time, the application instance can use either the old password or the new password to connect to the database server. When the rollover time expires, only the new password is allowed.
Before this enhancement, an administrator normally took the application down when the application database password was being rotated. This is because the password update requires changes on both the database and the application side. With the gradual database password rollover enhancement, the application can continue to use the older password until the new password is configured in the application.
In addition to the new clause `PASSWORD_ROLLOVER_TIME` in the `CREATE PROFILE` and `ALTER PROFILE` statements, the `ALTER USER` statement has a new clause, `EXPIRE PASSWORD ROLLOVER PERIOD`. The `ACCOUNT_STATUS` column of the `DBA_USERS` and `USER_USERS` data dictionary views have several new statuses indicating values to indicate rollover status.
For more information, see Managing Gradual Database Password Rollover for Applications.
## Ability to Use Multiple Kerberos Principals with a Single Database Client
Available for Oracle Database release 19.10, when you configure Kerberos authentication for an Oracle Database client, you can specify multiple Kerberos principals with a single Oracle Database client.
To enable this functionality, you will need to create a separate credential cache for each user in the client and then use the connect string to specify the user.
In previous releases, you were restricted to one Kerberos principal for each Oracle Database client.
For more information, see Step 1C: Optionally, Specify Additional Kerberos Principals Using tnsnames.ora and *Oracle Database Net Services Reference*.
## Updated Support for Micro Edition Suite (MES) for FIPS 140.2
Available for Oracle Database release 19.10, Oracle Database supports Micro Edition Suite (MES) version 4.5 for FIPS 140.2.
The Micro Edition Suite (MES) version 4.5 updates include four new CVEs in the RSA BSAFE MES library, support for the rules that FIPS 140.2 requires, and access to the updated NZ/ZT library from the Crypto Foundation.
This enhancement enables the Oracle Database FIPS 140.2 configuration to benefit from new features and security improvements available from the latest RSA BSAFE MES library.
For more information, see Configuring FIPS 140-2 for Transparent Data Encryption and DBMS_CRYPTO.
## Support for DBMS_CRYPTO Asymmetric Key Operations
Available for Oracle Database release 19.9, the `DBMS_CRYPTO` PL/SQL package supports asymmetric key operations, in addition to the existing support for symmetric key operations.
To implement the support for asymmetric key operations, the following procedures have been added to the `DBMS_CRYPTO` package:
- PKENCRYPT
- PKDECRYPT
- SIGN
- VERIFY
For more information, see Asymmetric Key Operations with the DBMS_CRYPTO Package and *Oracle Database PL/SQL Packages and Types Reference*.
## SYSLOG Destination for Common Unified Audit Policies
Available with Oracle Database release 19.9, certain predefined columns of unified audit records from common unified audit policies can be written to the UNIX SYSLOG destination.
To enable this feature, you set `UNIFIED_AUDIT_COMMON_SYSTEMLOG`, a new CDB level `init.ora` parameter. This enhancement enables all audit records from common unified audit policies to be consolidated into a single destination.
This feature is available only on UNIX platforms, not Windows.
For more information, see Enabling SYSLOG and Windows Event Viewer Captures for the Unified Audit Trail.
## Security Update for Native Encryption
Oracle provides a patch that you can download to address necessary security enhancements that affect native network encryption environments in Oracle Database release 11.2 and later.
This patch is available in My Oracle Support note 2118136.2.
The supported algorithms that have been improved are as follows:
- Encryption algorithms: AES128, AES192 and AES256
- Checksumming algorithms: SHA1, SHA256, SHA384, and SHA512
Algorithms that are deprecated and should not be used are as follows:
- Encryption algorithms: DES, DES40, 3DES112, 3DES168, RC4_40, RC4_56, RC4_128, and RC4_256
- Checksumming algorithm: MD5
If your site requires the use of network native encryption, then you must download the patch that is described in My Oracle Support note 2118136.2. To enable a smooth transition for your Oracle Database installation, this patch provides two parameters that enable you to disable the weaker algorithms and start using the stronger algorithms. You will need to install this patch on both servers and clients in your Oracle Database installation.
An alternative to network native encryption is Transport Layer Security (TLS), which provides protection against person-in-the-middle attacks.
For more information, see Choosing Between Native Network Encryption and Transport Layer Security and Improving Native Network Encryption Security.
## Ability to Configure Transport Layer Security Connections without Client Wallets
Available in Oracle Database release 19.14, an Oracle Database client will not be required to provide a wallet to hold well-known CA root certificates if they are available elsewhere in the local system.
Transport Layer Security (TLS) encryption requires either one-way authentication or two-way authentication. In one-way authentication (the default), which is commonly used for HTTPS connections, the server certificate is verified using well-known root CA certificates that are already available in local systems. Starting in this release, you will no longer need to install and configure a wallet to hold a well-known root certificate if it is already available in the local system.
This enhancement greatly simplifies the Oracle Database client installation and the use of TLS protocol to encrypt Oracle Database client-server communications.
For more information, see Transport Layer Security Connection without a Client Wallet.
## TLS_ALLOW_WEAK_DN_MATCH Parameter to Control the Behavior of TLS_SERVER_DN_MATCH
Available with Oracle Database release 19.23, you can use the `TLS_ALLOW_WEAK_DN_MATCH` parameter to control how `TLS_SERVER_DN_MATCH` allows the service name for partial distinguished name matching and to only check the database server certificate.
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both the `TLS_` and `SSL_` versions of a parameter are configured, then the `SSL_` version is ignored.
In this release, the behavior of the `TLS_SERVER_DN_MATCH` parameter has changed. Full DN matching validates the configured DN against the certificate in the listener wallet and is independent of the certificate in the database server wallet. For partial DN matching, the certificate common name (CN) must match the `HOST` value in the connect string, and the corresponding certificate configuration must be present in both the listener and database server wallets. The `SERVICE_NAME` setting is not used during a partial DN match. When set to `TRUE`, the `TLS_ALLOW_WEAK_DN_MATCH` parameter enables the earlier DN-matching behavior.
DN matching with both the listener and server certificates provides better security to ensure that the client is connecting to the correct database server. The service name setting is also removed from `TLS_SERVER_DN_MATCH` for better security and partial DN matching can still be performed with the host name connect string parameter with the certificate common names (CN) and subject alternative name (SAN) matching.
The `TLS_ALLOW_WEAK_DN_MATCH`, though new to this release, is marked as deprecated because it is considered a temporary solution.
See Advanced and Optional Configurations for TLS
## SSL_ Parameter Deprecation in Favor of TLS_ Parameters
Starting with Oracle Database release 19.30, Oracle is deprecating parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_` to bring Oracle parameters in accord with the actual encryption and authentication methods for network connections.
These parameters include:
  - SSL_CIPHER_SUITES
  - SSL_VERSION
  - SSL_CLIENT_AUTHENTICATION
  - SSL_SERVER_CERT_DN
  - SSL_SERVER_DN_MATCH
  - SSL_ALLOW_WEAK_DN_MATCH
  - SSL_CERT_REVOCATION
  - SSL_CRL_PATH
  - SSL_CRL_FILE
  - SSL_EXTENDED_KEY_USAGE
  - SSL_ENABLE_WEAK_CIPHERS
  - SSL_CERTIFICATE_ALIAS
  - SSL_CERTIFICATE_THUMBPRINT
  - SSL_DISABLE_WEAK_EC_CURVES
  - SSL_CIPHER_SUITES_ORDER
During this deprecation period, if both the `SSL_` and `TLS_` versions of a parameter are configured, then the `SSL_` parameter is ignored.
