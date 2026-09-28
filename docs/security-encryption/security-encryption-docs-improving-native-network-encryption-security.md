# Improving Native Network Encryption Security

Oracle provides a patch that will strengthen native network encryption security for both Oracle Database servers and clients.
- About Improving Native Network Encryption Security The Oracle patch will update encryption and checksumming algorithms and deprecate weak encryption and checksumming algorithms.
- Applying Security Improvement Updates to Native Network Encryption In addition to applying a patch to the Oracle Database server and client, you must set the server and client sqlnet.ora parameters.
## About Improving Native Network Encryption Security
The Oracle patch will update encryption and checksumming algorithms and deprecate weak encryption and checksumming algorithms.
This patch, which you can download from My Oracle Support note Assistant: Download Reference for Oracle Database/GI Update, Revision, PSU, SPU(CPU), Bundle Patches, Patchsets and Base Releases, strengthens the connection between servers and clients, fixing a vulnerability in native network encryption and checksumming algorithms. It adds two parameters that make it easy to disable older, less secure encryption and checksumming algorithms. Oracle strongly recommends that you apply this patch to your Oracle Database server and clients.
This patch applies to Oracle Database releases 11.2 and later. You can apply this patch in the following environments: standalone, multitenant, primary-standby, Oracle Real Application Clusters (Oracle RAC), and environments that use database links.
The supported algorithms that have been improved are as follows:
- Encryption algorithms: AES128, AES192 and AES256
- Checksumming algorithms: SHA1, SHA256, SHA384, and SHA512
Weak algorithms that are deprecated and should not be used after you apply the patch are as follows:
- Encryption algorithms: DES, DES40, 3DES112, 3DES168, RC4_40, RC4_56, RC4_128, and RC4_256
- Checksumming algorithm: MD5
The general procedure that you will follow is to first replace references to desupported algorithms in your Oracle Database environment with supported algorithms, patch the server, patch the client, and finally, set `sqlnet.ora` parameters to re-enable a proper connection between the server and clients.
The patch affects the following areas including, but not limited to, the following:
- JDBC network encryption-related configuration settings
- Encryption and integrity parameters that you have configured using Oracle Net Manager
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CIPHER_SUITE` and `SSL_CIPHER_SUITE` parameters are configured, then the `SSL_CIPHER_SUITE` parameter is ignored.
- Transport Layer Security (TLS) TLS_CIPHER_SUITE parameter settings
- SecureFiles LOB encrypted columns
- Database Resident Connection Pooling (DRCP) configurations
- Encryption settings used for the configuration of Oracle Call Interface (Oracle OCI), ODP.NET
## Applying Security Improvement Updates to Native Network Encryption
In addition to applying a patch to the Oracle Database server and client, you must set the server and client `sqlnet.ora` parameters.
Ensure that you perform the following steps in the order shown:
- Back up the servers and clients to which you will install the patch.
- Log in to My Oracle Support and then download patch described in My Oracle Support note 2118136.2. My Oracle Support is located at the following URL: https://support.oracle.com
- Patch the server. Follow the instructions in My Oracle Support note 2118136.2 to apply the patch to the server. You will apply the same patch to the client in a later step.
- Patch the clients. Determine which clients you need to patch. Follow the instructions in My Oracle Support note 2118136.2 to apply the patch to each client.
  - SQLNET.ENCRYPTION_TYPES_CLIENT
  - SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT
  - SQLNET.ENCRYPTION_TYPES_SERVER
  - SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER
  - SQLNET.ENCRYPTION_SERVER = REQUIRED
  - SQLNET.ENCRYPTION_TYPES_SERVER = (AES256)
  - SQLNET.CRYPTO_CHECKSUM_SERVER = REQUIRED
  - SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER = (SHA512)
  - SQLNET.ALLOW_WEAK_CRYPTO_CLIENTS = FALSE
  - SQLNET.ENCRYPTION_CLIENT = REQUIRED
  - SQLNET.ENCRYPTION_TYPES_CLIENT = (AES256)
  - SQLNET.CRYPTO_CHECKSUM_CLIENT = REQUIRED
  - SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT = (SHA512)
  - SQLNET.ALLOW_WEAK_CRYPTO = FALSE
````
````````
- In each client sqlnet.ora file, after you have removed all the deprecated algorithms from the server and the clients per steps 5 and 6, set the parameter SQLNET.ALLOW_WEAK_CRYPTO = FALSE so that the clients can be prevented from communicating with unpatched servers. If the SQLNET.ALLOW_WEAK_CRYPTO parameter is set to FALSE, then a client attempting to use a weak algorithm will produce an ORA-12269: client uses weak encryption/crypto-checksumming version error at the server. A client connecting to a server (or proxy) that is using weak algorithms will receive an ORA-12268: server uses weak encryption/crypto-checksumming version error.
``````
````````
````
- In the server sqlnet.ora file, after you have updated all the clients with SQLNET.ALLOW_WEAK_CRYPTO = FALSE per step 9, set the parameter SQLNET.ALLOW_WEAK_CRYPTO_CLIENTS = FALSE. This parameter prevents a patched server from communicating with unpatched clients. If the SQLNET.ALLOW_WEAK_CRYPTO parameter is set to FALSE, then a client attempting to use a weak algorithm will produce an ORA-12269: client uses weak encryption/crypto-checksumming version error at the server. A client connecting to a server (or proxy) that is using weak algorithms will receive an ORA-12268: server uses weak encryption/crypto-checksumming version error. If you use the database links, then the first database server acts as a client and connects to the second server. Therefore, ensure that all servers are fully patched and unsupported algorithms are removed before you set SQLNET.ALLOW_WEAK_CRYPTO to FALSE
## Related Topics
  **- Oracle Database JDBC Developer’s Guide
  - Configuring Encryption and Integrity Parameters Using Oracle Net Manager
  - Choosing Between Native Network Encryption and Transport Layer Security
