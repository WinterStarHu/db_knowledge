# Data Integrity Algorithms Support

Data integrity algorithms protect against third-party attacks and message replay attacks. Oracle recommends SHA-2 algorithms.
**Note:**   MD5 is deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
These hashing algorithms create a checksum that changes if the data is altered in any way. This protection operates independently from the encryption process so you can enable data integrity with or without enabling encryption.
For deployments that use explicit native network encryption (NNE) configuration, the integrity (checksum) algorithms available depend on the active cryptographic provider.

| Algorithm | Legacy provider (Default) | Next-Generation provider |
|---|---|---|
| SHA512 | Supported | Supported |
| SHA384 | Supported | Supported |
| SHA256 | Supported | Supported |
| SHA1 | Supported (deprecated) | Supported (deprecated) |
| MD5 | Supported (deprecated) | Supported (deprecated) |

For deployments that require explicit checksum configuration, Oracle recommends SHA512:
```
SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER = (SHA512)
```
SHA-1 is considered cryptographically weak and is deprecated. Oracle recommends SHA-256 or stronger. MD5 is considered cryptographically weak and is deprecated. Oracle recommends SHA-256 or stronger.
## Related Topics
  - Configuring Integrity on the Client and the Server
