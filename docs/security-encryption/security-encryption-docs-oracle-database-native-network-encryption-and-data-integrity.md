# About Oracle Database Native Network Encryption and Data Integrity

Oracle Database enables you to encrypt data that is sent over a network.
- How Oracle Database Native Network Encryption and Integrity Works Oracle Database provides native data network encryption and integrity to ensure that data is secure as it travels across the network.
- Native Network Encryption Algorithm Support by Cryptographic Provider The native network encryption algorithms that are available depend on the active cryptographic provider and FIPS mode.
- Advanced Encryption Standard Oracle Database supports the Federal Information Processing Standard (FIPS) encryption algorithm, Advanced Encryption Standard (AES).
- Triple-DES Encryption Triple-DES encryption (3DES) encrypts message data with three passes of the DES algorithm.
- Choosing Between Native Network Encryption and Transport Layer Security Oracle offers two ways to encrypt data over the network, native network encryption and Transport Layer Security (TLS).
## How Oracle Database Native Network Encryption and Integrity Works
Oracle Database provides native data network encryption and integrity to ensure that data is secure as it travels across the network.
The purpose of a secure cryptosystem is to convert plaintext data into unintelligible ciphertext based on a key, in such a way that it is very hard (computationally infeasible) to convert ciphertext back into its corresponding plaintext without knowledge of the correct key.
In a symmetric cryptosystem, the same key is used both for encryption and decryption of the same data. Oracle Database provides the Advanced Encryption Standard (AES) symmetric cryptosystem for protecting the confidentiality of Oracle Net Services traffic.
## Native Network Encryption Algorithm Support by Cryptographic Provider
The encryption algorithms available for explicit configuration depend on the active cryptographic provider.

| Algorithm | Legacy provider (Default) | Next-Generation provider |
|---|---|---|
| AES256 | Supported | Supported |
| AES192 | Supported | Supported |
| AES128 | Supported | Supported |
| 3DES168 | Supported (deprecated) | Supported (deprecated; not in FIPS 140-3) |
| 3DES112 | Supported (deprecated) | Not supported |
| DES | Supported (deprecated) | Not supported |
| DES40 | Supported (deprecated) | Not supported |
| RC4_256 | Supported (deprecated) | Not supported |
| RC4_128 | Supported (deprecated) | Not supported |
| RC4_56 | Supported (deprecated) | Not supported |
| RC4_40 | Supported (deprecated) | Not supported |

Oracle recommends AES256 for deployments that require explicit algorithm configuration:
```
SQLNET.ENCRYPTION_TYPES_SERVER = (AES256)
```
When using the next-generation provider, only AES and 3DES168 algorithms are available for NNE. 3DES168 is further restricted: it is not available when FIPS 140-3 mode is enabled. FIPS 140-3 desupports 3DES. 3DES encryption is outdated, slow, and no longer considered secure. Oracle recommends transitioning to AES.
If you switch from the legacy provider to the next-generation provider and your `SQLNET.ENCRYPTION_TYPES` configuration includes algorithms not supported by the next-generation provider (such as DES or RC4 variants), Oracle Net negotiates using only the algorithms that are supported. If no mutually supported algorithm is available, the connection may fail depending on your `SQLNET.ENCRYPTION_SERVER` and `SQLNET.ENCRYPTION_CLIENT` settings.
## Advanced Encryption Standard
Oracle Database supports the Federal Information Processing Standard (FIPS) encryption algorithm, Advanced Encryption Standard (AES).
AES can be used by all U.S. government organizations and businesses to protect sensitive data over a network. This encryption algorithm defines three standard key lengths, which are 128-bit, 192-bit, and 256-bit. All versions operate in outer Cipher Block Chaining (CBC) mode. CBC mode is an encryption method that protects against block replay attacks by making the encryption of a cipher block dependent on all blocks that precede it; it is designed to make unauthorized decryption incrementally more difficult. Oracle Database employs outer cipher block chaining because it is more secure than inner cipher block chaining, with no material performance penalty.
**Note:**  The AES algorithms have been improved. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note
2118136.2.
## Triple-DES Encryption
Triple-DES encryption (3DES) encrypts message data with three passes of the DES algorithm.
**Note:** The DES, DES40, 3DES112, and 3DES168 algorithms are deprecated in this release. 3DES is not available when the next-generation provider is configured for FIPS 140-3. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
3DES provides a high degree of message security, but with a performance penalty. The magnitude of the performance penalty depends on the speed of the processor performing the encryption. 3DES typically takes three times as long to encrypt a data block when compared to the standard DES algorithm.
3DES is available in two-key and three-key versions, with effective key lengths of 112-bits and 168-bits, respectively. Both versions operate in outer Cipher Block Chaining (CBC) mode.
The DES40 algorithm, available with Oracle Database and Secure Network Services, is a variant of DES in which the secret key is preprocessed to provide 40 effective key bits. It was designed to provide DES-based encryption to customers outside the U.S. and Canada at a time when the U.S. export laws were more restrictive. Currently DES40, DES, and 3DES are all available for export. DES40 is still supported to provide backward-compatibility for international customers.
## Choosing Between Native Network Encryption and Transport Layer Security
Oracle offers two ways to encrypt data over the network, native network encryption and Transport Layer Security (TLS).
There are advantages and disadvantages to both methods. See the comparison of Native Network Encryption and Transport Layer Security below.
**Native Network Encryption** Advantages:
  - It is configured with parameters in the sqlnet.ora configuration file.
  - In most cases, no client configuration changes are required.
  - No certificates are required.
  - Clients that do not support native network encryption can fall back to unencrypted connections while incompatibility is mitigated.
Disadvantages:
  - It uses a non-standard, Oracle proprietary implementation.
  - It provides no non-repudiation of the server connection (that is, no protection against a third-party attack).
**Transport Layer Security** Advantages:
  - It is an industry standard for encrypting data in motion.
  - It provides non-repudiation for server connections to prevent third-party attacks.
  - It can be used for database user authentication.
Disadvantages:
  - It requires client and server changes.
  - Certificates are required for server and are optional for the client. However, the client must have the trusted root certificate for the certificate authority that issued the server’s certificate.
  - Certificates eventually expire.
## Related Topics
  - Ensuring Encryption Algorithms are FIPS 140-3 Compliant
