# Changes in Oracle Database Security 19c

*Oracle Database Security Guide* for Oracle Database 19c has new security features.
- Next-Generation Cryptographic Provider Oracle Database 19c includes a next-generation cryptographic provider that supports TLS 1.3, FIPS 140-3, and post-quantum cryptography.
- Deprecated and Desupported Cryptographic Features Several older cryptographic algorithms, protocol versions, and configuration parameters are deprecated or desupported when you use the next-generation cryptographic provider.
- Preparing for FIPS 140-3 Compliance Oracle Database 19c will support FIPS 140-3 in 2026. You may need to change encryption algorithms to be compliant with FIPS 140-3.
````````
- Constrained Kerberos Configuration In Oracle AI Database 23.26.1 and Oracle Database 19.30 a new sqlnet.ora parameter has been introduced, SQLNET.KERBEROS5_DELEGATION_MODE. This parameter allows you to specify if ticket granting ticket (TGT) forwarding by Kerberos is UNCONSTRAINED or CONSTRAINED.
- Multi-Factor Authentication Now Available Starting with Oracle Database 19.28, multi-factor authentication can be enabled for native database users.
- Signature-Based Security for LOB Locators Starting with this release, you can configure signature-based security for large object (LOB) locators.
- Default User Accounts Now Schema Only Using the schema only account feature from Oracle Database release 18c, most of the Oracle Database supplied schemas (users) now have their passwords removed to prevent users from authenticating to these accounts.
**
- Privilege Analysis Documentation Moved to Oracle Database Security Guide The documentation for privilege analysis has moved from Oracle Database Vault Administrator’s Guide to Oracle Database Security Guide.
````
- Ability to Grant or Revoke Administrative Privileges to and from Schema-Only Accounts Administrative privileges such as SYSOPER and SYSBACKUP can now be granted to schema-only (passwordless) accounts.
- Automatic Support for Both SASL and Non-SASL Active Directory Connections Starting with this release, both Simple Authentication and Security Layer (SASL) and Transport Layer Security (TLS) binds are supported for Microsoft Active Directory connections.
- Support for Oracle Native Encryption and TLS Authentication for Different Users Concurrently In previous releases, Oracle Database prevented the use of both Oracle native encryption (also called Advanced Networking Option (ANO) encryption) and Transport Layer Security (TLS) authentication together.
- Support for Host Name-Based Partial DN Matching for Matching for Server Certificates This new support for partial DN matching adds the ability for the client to further verify the server certificate.
- Ability to Audit Only Top-Level SQL Statements The unified auditing top-level statements feature enables you to audit top level user (or, direct user) activities in the database but without collecting indirect user activity audit data.
- Improved Read Performance for the Unified Audit Trial The AUDSYS.AUD$UNIFIED system table, which stores the unified audit trail records, has been redesigned to use partition pruning to improve read performance.
- SYSLOG Destination for Common Unified Audit Policies Available with Oracle Database release 19.9, certain predefined columns of unified audit records from common unified audit policies can be written to the UNIX SYSLOG destination.
````
- PDB_GUID as Audit Record Field Name for SYSLOG and the Windows Event Viewer The audit record fields for SYSLOG and the Windows Event Viewer now have a new field, PDB_GUID, to identify the pluggable database associated with a unified audit trail record.
## Next-Generation Cryptographic Provider
Starting with this release update, Oracle Database 19c includes a next-generation cryptographic provider. The next-generation provider supports TLS 1.3, FIPS 140-3, and post-quantum cryptography, including ML-KEM and ML-DSA algorithms.
The legacy provider remains the default provider and continues to support TLS 1.0, TLS 1.1, TLS 1.2, and FIPS 140-2. You can use the `set_crypto_provider.py` script to switch between the legacy provider and the next-generation provider.
For more information, see Switching the Cryptographic Provider for Oracle Database 19c, Post-Quantum Cryptography in Oracle Database, and Oracle Database FIPS 140-2 and FIPS 140-3 Settings.
## Deprecated and Desupported Cryptographic Features
Starting with Oracle Database 19.32, some cryptographic features are deprecated or desupported depending on the active cryptographic provider.
### Oracle Database Parameters
The following parameters are deprecated starting in Oracle Database 19.32.
  ````- The SSL_DISABLE_WEAK_EC_CURVES parameter is deprecated. Use TLS_KEY_EXCHANGE_GROUPS to control TLS 1.3 key exchange groups.
  ``````- The SSLFIPS_140 parameter is deprecated. Use FIPS_140 and FIPS_140_3 instead.
### Cryptographic Algorithms and Protocol Versions - Next-Generation Cryptographic Provider
When the next-generation cryptographic provider is enabled for Oracle Database, the following are not supported.
  - DES, 2-key Triple-DES, RC2, RC4, RC5, SEED, and GOST algorithms.
  - 3-key Triple-DES is not available when configured for FIPS 140-3.
  - MD5 and SHA-1 are not supported for certificate signatures.
  - SSL 3.0, TLS 1.0, and TLS 1.1 are not supported.
For more information on deprecations and desupports see the Oracle Database Upgrade guide.
For more information, see Switching the Cryptographic Provider for Oracle Database 19c, Transport Layer Security Version Parameters, and Configuration of FIPS 140-2 and FIPS 140-3 for Transport Layer Security.
## Preparing for FIPS 140-3 Compliance
Oracle Database 19c will support FIPS 140-3 in 2026. You may need to change encryption algorithms to be compliant with FIPS 140-3.
FIPS 140-3 desupports 3DES (Triple Data Encryption Standard) encryption algorithms as it is considered insecure. Current security best practices advise using Advanced Encryption Standard (AES) algorithms as AES offers improved security, performance, and resistance to known attacks. In preparation for FIPS 140-3 later in 2026, you should ensure 3DES algorithms are no longer used and replaced with AES algorithms in your encryption configurations. For more information see Ensuring Encryption Algorithms are FIPS 140-3 Compliant.
## Constrained Kerberos Configuration
In Oracle AI Database 23.26.1 and Oracle Database 19.30 a new `sqlnet.ora` parameter has been introduced, `SQLNET.KERBEROS5_DELEGATION_MODE`. This parameter allows you to specify if ticket granting ticket (TGT) forwarding by Kerberos is `UNCONSTRAINED` or `CONSTRAINED`.
Currently, on Windows 11 (22H2) and Windows Server 2025 with Credential Guard enabled, Credential Guard prevents Windows clients using MSLSA credential cache from using database links altogether by blocking TGT forwarding.
In older configurations of Windows database clients using MSLSA, the `AllowTgtSessionKey` registry key must be set to `1` to allow TGT forwarding. However, because there are no additional restrictions this is insecure.
To allow for improved security by restricting TGT forwarding while still allowing for the use of database links, the `SQLNET.KERBEROS5_DELEGATION_MODE` parameter has been introduced.
When set to `UNCONSTRAINED`, the forwarding of the TGT from Kerberos is unrestricted. `UNCONSTRAINED` is the default configuration.
When set to `CONSTRAINED`, TGT forwarding is restricted to the configurations in Microsoft Active Directory, making it the more secure option.
For more information on configuration see How to Securely Use Database Links with Kerberos and Microsoft Active Directory.
## Multi-Factor Authentication Now Available
Starting with Oracle Database 19.28, multi-factor authentication can be enabled for native database users.
Oracle Database allows multi-factor authentication (MFA) configuration for native users in the form of either push notifications through Oracle Mobile Authenticator (OMA) or Cisco Duo, or certificate-based authentication.
For more information, see Configuring Multi-Factor Authentication.
## Signature-Based Security for LOB Locators
Starting with this release, you can configure signature-based security for large object (LOB) locators.
This feature strengthens the security of Oracle Database LOBs, particularly when instances of LOB data types (CLOB and BLOB) are used in distributed environments.
LOB signature keys can be in both multitenant PDBs or in standalone, non-multitenant databases. You can enable the encryption of the LOB signature key credentials by executing the `ALTER DATABASE DICTIONARY ENCRYPT CREDENTIALS` SQL statement; otherwise, the credentials are stored in obfuscated format. If you choose to store the LOB signature key in encrypted format, then the database or PDB must have an open TDE keystore.
For more information, see Securing LOBs with LOB Locator Signatures.
## Default User Accounts Now Schema Only
Using the schema only account feature from Oracle Database release 18c, most of the Oracle Database supplied schemas (users) now have their passwords removed to prevent users from authenticating to these accounts.
This enhancement does not affect the sample schemas. Sample schemas are still installed with their default passwords.
For the default schemas that are schema only, administrators can still alter these accounts with passwords if they need to authenticate to the schema, but Oracle recommends changing the schemas back to a schema-only account afterward.
The benefit of this feature is that administrators no longer have to periodically rotate the passwords for these Oracle Database-provided schemas. This feature also reduces the security risk of attackers using default passwords to hack into these accounts.
For more information, see Predefined Schema User Accounts Provided by Oracle Database and Schema-Only Accounts.
## Privilege Analysis Documentation Moved to Oracle Database Security Guide
The documentation for privilege analysis has moved from Oracle Database Vault Administrator’s Guide to *Oracle Database Security Guide*.
For more information, see Performing Privilege Analysis to Identify Privilege Use and *Oracle Database Licensing Information User Manual*.
## Ability to Grant or Revoke Administrative Privileges to and from Schema-Only Accounts
Administrative privileges such as `SYSOPER` and `SYSBACKUP` can now be granted to schema-only (passwordless) accounts.
Existing user accounts (active, rarely accessed, and unused users) that are currently granted administrative privileges can be altered to be schema-only accounts. This enhancement prevents administrators from having to manage the passwords of these accounts.
For more information, see About Schema-Only Accounts.
## Automatic Support for Both SASL and Non-SASL Active Directory Connections
Starting with this release, both Simple Authentication and Security Layer (SASL) and Transport Layer Security (TLS) binds are supported for Microsoft Active Directory connections.
For centrally managed users, the Oracle database will initially try to connect to Active Directory using SASL bind. If the Active Directory server rejects the SASL bind connection, then the Oracle database will automatically attempt the connection again without SASL bind but still secured with TLS.
The Active Directory administrator is responsible for configuring the connection parameters for Active Directory server, but does not need to configure the database to match this new Active Directory connection enhancement. The database will automatically adjust from using SASL to not using SASL bind.
For more information, see About Configuring the Oracle Database-Microsoft Active Directory Connection.
## Support for Oracle Native Encryption and TLS Authentication for Different Users Concurrently
In previous releases, Oracle Database prevented the use of both Oracle native encryption (also called Advanced Networking Option (ANO) encryption) and Transport Layer Security (TLS) authentication together.
Starting with this release, you can set a new parameter, `SQLNET.IGNORE_ANO_ENCRYPTION_FOR_TCPS`, to `TRUE` to ignore the `SQLNET.ENCRYPTION_CLIENT` or `SQLNET.ENCRYPTION_SERVER` when there is a conflict between the use of a TCPS client and either of these two parameters are set to `required`.
For more information, see Enabling Both Oracle Native Encryption and SSL Authentication for Different Users Concurrently.
## Support for Host Name-Based Partial DN Matching for Matching for Server Certificates
This new support for partial DN matching adds the ability for the client to further verify the server certificate.
The earlier ability to perform a full DN match with the server certificate during the Transport Layer Security (TLS) handshake is still supported. The client supports both full and partial DN matching. If the server DN matching is enabled, then partial DN matching is the default.
Allowing partial and full DN matching for certificate verification enables more flexibility based on how the certificates were created.
For more information, see About Configuring the Server DN Matching and Using TCP/IP with TLS on the Client.
## Ability to Audit Only Top-Level SQL Statements
The unified auditing top-level statements feature enables you to audit top level user (or, direct user) activities in the database but without collecting indirect user activity audit data.
You can use this feature to audit only the top-level user directly issued events, without the overhead of indirect SQL statements. Top-level statements are SQL statements that users directly issue. These statements can be important for both security and compliance. SQL statements run from within PL/SQL procedures or functions are not considered top level, so they may be less relevant for auditing purposes.
For more information, see Auditing Only Top-Level Statements.
## Improved Read Performance for the Unified Audit Trial
The `AUDSYS.AUD$UNIFIED` system table, which stores the unified audit trail records, has been redesigned to use partition pruning to improve read performance.
This redesign entailed the addition of a new column to the `AUDSYS.AUD$UNIFIED` table. The `UNIFIED_AUDIT_TRAIL` data dictionary view, which enables you to query the `AUDSYS.AUD$UNIFIED` table audit records, now has the `EVENT_TIMESTAMP_UTC` column to correspond with the new `AUDSYS.AUD$UNIFIED` table column. As part of this enhancement, the data type of the `EVENT_TIMESTAMP` column in the `GV$UNIFIED_AUDIT_TRAIL` view has changed `TIMESTAMP(6)`.
Oracle recommends that when you query the `UNIFIED_AUDIT_TRAIL` view, to include the `EVENT_TIMESTAMP_UTC` column in the `WHERE` clause to achieve partitioning pruning.
For more information, see Best Practices for Querying the UNIFIED_AUDIT_TRAIL Data Dictionary View.
## SYSLOG Destination for Common Unified Audit Policies
Available with Oracle Database release 19.9, certain predefined columns of unified audit records from common unified audit policies can be written to the UNIX SYSLOG destination.
To enable this feature, you set `UNIFIED_AUDIT_COMMON_SYSTEMLOG`, a new CDB level `init.ora` parameter. This enhancement enables all audit records from common unified audit policies to be consolidated into a single destination.
This feature is available only on UNIX platforms, not Windows.
For more information, see Enabling SYSLOG and Windows Event Viewer Captures for the Unified Audit Trail.
## PDB_GUID as Audit Record Field Name for SYSLOG and the Windows Event Viewer
The audit record fields for `SYSLOG` and the Windows Event Viewer now have a new field, `PDB_GUID`, to identify the pluggable database associated with a unified audit trail record.
In a multitenant database deployment, the pluggable database that generated a unified audit trail record must be identified in the audit trail. Starting with this release, the `SYSLOG` and Windows Event Viewer will have a new field, `PDB_GUID`, to capture this information. The data type is `VARCHAR2`.
For more information, see About Writing the Unified Audit Trail Records to SYSLOG or the Windows Event Viewer.
