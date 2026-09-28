# Switching the Cryptographic Provider for Oracle Database 19c

This section explains how to switch an existing Oracle Database 19c environment from the default legacy cryptographic provider to the next-generation cryptographic provider.
## Understanding the Impacts of Switching the Cryptographic Provider
The following table shows how various capabilities, encryption algorithms, and parameters in Oracle Database 19c differ between the next-generation cryptographic provider and the legacy cryptographic provider.

| Capability | Next-Generation Cryptographic Provider | Legacy Cryptographic Provider (Default) |
|---|---|---|
| Supported TLS versions | TLS 1.2, TLS 1.3 | TLS 1.0, TLS 1.1, TLS 1.2 |
| Supported FIPS standard | FIPS 140-2 and FIPS 140-3 | FIPS 140-2 |
| FIPS configuration parameters | FIPS_140 in fips.ora for FIPS 140-2; FIPS_140 and FIPS_140_3 in fips.ora for FIPS 140-3. SSLFIPS_140 remains supported but is deprecated. | SSLFIPS_140, SQLNET.FIPS_140, and DBFIPS_140 |
| Supported post-quantum cryptography | ML-KEM, ML-DSA, and SLH-DSA | Not supported |
| Supported TLS 1.3 cipher suites | TLS_AES_256_GCM_SHA384, TLS_AES_128_GCM_SHA256, TLS_AES_128_CCM_SHA256, TLS_CHACHA20_POLY1305_SHA256 (non-FIPS mode only) | Not supported |
| Recommended TLS 1.2 ciphers | TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 | TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 |
| Native Network Encryption (NNE) encryption algorithms | AES only, or 3DES168 in non-FIPS mode only | AES, 3DES, DES, and RC4 |
| NNE checksum | SHA256, SHA384, SHA512; SHA1 checksum-only in non-FIPS mode; MD5 is deprecated | SHA256, SHA384, SHA512, MD5, and SHA1 |
| 3DES encryption | Supported but deprecated in non-FIPS mode; desupported in FIPS 140-3 | Deprecated but supported |
| DES, RC4, RC2, RC5 | Not supported | Deprecated but supported |
| SEED and ARIA | SEED is desupported; ARIA is supported in non-FIPS mode | Supported |
| SHA-1 and MD5 signing | Not supported | Deprecated but supported |
| TLS_VERSION minimum syntax, such as 1.2+ | Supported | Supported |
| TLS_KEY_EXCHANGE_GROUPS | Supported; default is hybrid,ec,ml-kem | Not supported |
| Supported certificate algorithms | RSA, ECC, and ML-DSA | RSA and ECC |
| Recommended ECC curves | secp521r1, secp384r1, secp256r1 | secp521r1, secp384r1, secp256r1 |
| Recommended RSA key length | 2048 bits or greater; NIST recommends 3072 bits after 2030 | 2048 or 4096 bits |
| Certificate CN maximum length | 64 characters | No specific limit |
| Local Single Sign-On (LSSO) wallets | Limited | Limited |

### TLS Protocol Versions and Cipher Suites
The TLS protocol versions available to Oracle Database 19c depend on the active cryptographic provider.
When using the next-generation cryptographic provider, Oracle Database supports only TLS 1.2 and TLS 1.3. SSLv3, TLS 1.0, and TLS 1.1 are not available with the next-generation provider, regardless of FIPS configuration.
When using the legacy cryptographic provider, Oracle Database supports TLS 1.0, TLS 1.1, and TLS 1.2. TLS 1.0 and TLS 1.1 are not recommended. The legacy cryptographic provider does not support TLS 1.3.
Oracle recommends using TLS 1.2 or TLS 1.3 for all new deployments. TLS 1.3 is available only with the next-generation cryptographic provider.
**Tip:** You can use `TLS_DISABLE_VERSION` to disable protocol versions that you do not want clients or servers to negotiate.
The following table summarizes the available TLS versions depending on the cryptographic provider in Oracle Database 19c.

| TLS Version | Next-Generation Cryptographic Provider | Next-Generation Cryptographic Provider in FIPS 140-3 Mode | Legacy Cryptographic Provider (Default) | Legacy Cryptographic Provider in FIPS 140-2 mode |
|---|---|---|---|---|
| SSLv3 | Not supported | Not supported | Supported (not recommended) | Not supported |
| TLS 1.0 | Not supported | Not supported | Supported (not recommended) | Supported (not recommended) |
| TLS 1.1 | Not supported | Not supported | Supported (not recommended) | Supported (not recommended) |
| TLS 1.2 | Supported | Supported | Supported | Supported |
| TLS 1.3 | Supported | Supported | Not supported | Not supported |

#### TLS 1.3 Cipher Suites
The following cipher suites are available when TLS 1.3 is enabled. TLS 1.3 can only be enabled when the next-generation cryptographic provider is enabled.
  - TLS_AES_256_GCM_SHA384 (recommended)
  - TLS_AES_128_GCM_SHA256
  - TLS_AES_128_CCM_SHA256
  - TLS_CHACHA20_POLY1305_SHA256 (non-FIPS mode only)
TLS 1.3 cipher suites use Authenticated Encryption with Associated Data (AEAD) constructions exclusively. Non-AEAD cipher suites, such as those using CBC mode, are not available in TLS 1.3.
#### TLS 1.2 Cipher Suites
The following TLS 1.2 cipher suites are approved for both the next-generation cryptographic provider and the legacy cryptographic provider:
  - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 (recommended)
  - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (recommended)
  - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
  - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
  - TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
  - TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
All other TLS 1.2 cipher suites are deprecated and should not be used.
## Pre-conversion of Cryptographic Providers
Before switching from the legacy cryptographic provider to the next-generation cryptographic provider, inventory the environment and resolve incompatibilities. Document each exception, its owner, and its removal plan.
### Inventory the current environment
  - Record the Oracle Database server, Oracle Net listener, and client driver releases and release updates.
  - Identify all TLS connections that use TLS 1.0 or TLS 1.1. Upgrade these connections to TLS 1.2 or later before switching.
  ````````````````````- Record TLS parameters in every server, listener, client sqlnet.ora, and connect descriptor, including TLS_VERSION, TLS_DISABLE_VERSION, TLS_CIPHER_SUITES, TLS_ENABLE_WEAK_CIPHERS, TLS_CLIENT_AUTHENTICATION, TLS_SERVER_DN_MATCH, TLS_SERVER_CERT_DN, TLS_CERT_REVOCATION, and TLS_KEY_EXCHANGE_GROUPS.
  ``````- Record the negotiated NETWORK_PROTOCOL, TLS_VERSION, and TLS_CIPHERSUITE values for representative clients.
  ````- Record wallet locations and trust configuration, including WALLET_ROOT, listener WALLET_LOCATION, client wallets, and system certificate stores.
  - Inventory each certificate’s issuer, subject and SAN, key type, signature algorithm, expiration date, and renewal owner.
  - Identify all configurations, such as TDE, DBMS_CRYPTO, and Oracle Wallet, that use 3DES. FIPS 140-3 desupports 3DES; transition these configurations to AES.
  - Check wallet encryption. Wallets created before Oracle Database 19.22 might use 3DES.
  - Identify certificates signed with SHA-1 or MD5 and replace them with certificates that use SHA-256 or stronger.
  - Identify configurations that use DES, RC2, RC4, RC5, SEED, or GOST.
  - Verify that RSA key lengths meet FIPS minimums.
  - Identify RAC, DRCP, CMAN, database link, gateway, monitoring, backup, connection pool, and application server dependencies.
### Confirm dependencies and remediate incompatibilities
  - Confirm that client runtimes, including JDK, .NET, and operating system OpenSSL versions, support the required cryptographic behavior.
  - Confirm that certificates and trust chains use accepted algorithms.
  - Determine whether TLS 1.2 compatibility, pinned cipher lists, older certificate signatures, or wallet assumptions must remain temporarily.
  - Determine whether the deployment must remain in non-FIPS mode, use FIPS 140-2, or move to FIPS 140-3.
  - Determine whether ML-KEM or hybrid key exchange will be tested or enabled after the provider switch.
  - Update TLS version configurations to use TLS 1.2 or TLS 1.3.
  - Replace 3DES with AES in all encryption configurations.
  - Reissue certificates using SHA-256 or stronger signing algorithms.
  - Replace legacy encryption algorithms with AES equivalents.
  - Convert 3DES-encrypted wallets to AES-256.
  - If you use explicit NNE checksum configuration, update the checksum to SHA512.
### Update FIPS configuration parameters
To move to FIPS 140-3 mode, remove the three legacy FIPS settings:
  ````- SSLFIPS_140=true from fips.ora
  ````- SQLNET.FIPS_140=TRUE from sqlnet.ora
  - DBFIPS_140=true initialization parameter
Add the two next-generation provider FIPS settings in `fips.ora`:
```
FIPS_140 = TRUE FIPS_140_3 = TRUE
```
## Switching the Cryptographic Provider
Oracle Database 19c supports two cryptographic providers: the next-generation cryptographic provider and the legacy cryptographic provider. The legacy cryptographic provider is the default and is active unless explicitly changed. Only one cryptographic provider can be active at a time.
  ****- Next-generation cryptographic provider: Supports TLS 1.2, TLS 1.3, FIPS 140-2, FIPS 140-3, and post-quantum cryptography. It does not support TLS 1.0, TLS 1.1, or legacy algorithms such as DES, RC4, RC2, RC5, SEED, and GOST.
  ****- Legacy cryptographic provider: Supports TLS 1.0 through TLS 1.2, FIPS 140-2, and legacy encryption algorithms.
Use the `set_crypto_provider.py` script to switch between providers.
### To switch from the legacy cryptographic provider to the next-generation cryptographic provider
  - Ensure you have performed the pre-conversion steps Pre-conversion of Cryptographic Providers.
```
python $ORACLE_HOME/bin/set_crypto_provider.py next-generation
```
****
- Run the following: Note: Switching the cryptographic provider does not modify wallet contents or certificate stores. Existing wallets remain valid, but certificates signed with desupported algorithms, such as SHA-1 or MD5, are not usable for TLS authentication with the next-generation cryptographic provider.
- After switching the cryptographic provider, restart the database instance and Oracle Net listener for the change to take effect.
- Verify that FIPS 140-3 mode is active by checking the database alert log.
  - Test all TLS connections, encryption operations, and certificate-based authentication.
**Note:** This switch cannot be performed incrementally. You must resolve all incompatibilities before switching the cryptographic provider because the switch is an all-or-nothing operation for the entire database instance.
### To switch back from the next-generation cryptographic provider to the legacy cryptographic provider
If issues arise after switching to the next-generation cryptographic provider, you can revert back to the legacy cryptographic provider:
```
python $ORACLE_HOME/bin/set_crypto_provider.py legacy
```
- Switch back by running the following:
````  - SSLFIPS_140=true in fips.ora
      ````  - SQLNET.FIPS_140=TRUE in sqlnet.ora
        - DBFIPS_140=true initialization parameter
- Restart the database instance and Oracle Net listener.
**Note:**
PQC certificates that were created while the next-generation cryptographic provider was active will not function with the legacy cryptographic provider.
### Verify the Active Cryptographic Provider
Run the following to determine the current cryptographic provider:
```
python $ORACLE_HOME/bin/set_crypto_provider.py status
```
## Related Topics
  - Configuring TLS 1.3
  - Configuring Post-Quantum Cryptography
  - Deprecated and Desupported Cryptographic Features
  - Oracle Database Upgrade guide
