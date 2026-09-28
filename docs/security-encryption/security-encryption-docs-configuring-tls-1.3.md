# Configuring TLS 1.3

TLS 1.3 is only available when the next-generation cryptographic provider is enabled. See Switching the Cryptographic Provider for Oracle Database 19c for more information.
Why TLS Modernization Matters
## TLS Protocol Versions and Cipher Suites
The TLS protocol versions available to Oracle Database 19c depend on the active cryptographic provider.
When using the next-generation cryptographic provider, Oracle Database supports only TLS 1.2 and TLS 1.3. SSLv3, TLS 1.0, and TLS 1.1 are not available in next-generation provider mode regardless of FIPS configuration.
When using the legacy provider, Oracle Database supports TLS 1.0, TLS 1.1, and TLS 1.2. TLS 1.0 and TLS 1.1 are not recommended. The legacy provider does not support TLS 1.3.
Oracle recommends using TLS 1.2 or TLS 1.3 for all new deployments. TLS 1.3 is available only with the next-generation provider.
**Tip:** You can use `TLS_DISABLE_VERSION` to disable protocol versions that you do not want clients or servers to negotiate.
The following table summarizes the available TLS versions depending on the cryptographic provider in Oracle Database 19c.

| TLS Version | Next-Generation Cryptographic Provider | Next-Generation Cryptographic Provider in FIPS 140-3 Mode | Legacy Provider (Default) | Legacy Provider in FIPS 140-2 mode |
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
The following TLS 1.2 cipher suites are approved for both the next-generation cryptographic provider and the legacy provider:
  - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 (recommended)
  - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (recommended)
  - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
  - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
  - TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
  - TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
All other TLS 1.2 cipher suites are deprecated and should not be used.
## Configure TLS 1.3
- Ensure you have reviewed the supported TLS version depending on your cryptographic provider. See TLS Protocol Versions and Cipher Suites for more information.
- Ensure that the next-generation provider is active. See Switch From the legacy provider to the next-generation cryptographic provider for more information.
````
```
TLS_VERSION=(1.3)
```
- Set the TLS_VERSION parameter in the sqlnet.ora file on both the database server and client:
```
TLS_VERSION=(1.2 or 1.3)
```
- To permit both TLS 1.2 and TLS 1.3 connections, use the following setting:
```
TLS_VERSION=(1.2+)
```
- To use the plus-sign minimum version syntax, use the following setting:
- Restart the Oracle Net listener and database instance.
**Warning:** TLS 1.3 is not available with the legacy cryptographic provider. If you set `TLS_VERSION` to `1.3` while the legacy provider is active, connections fail.
### `TLS_DISABLE_VERSION` Parameter
The `TLS_DISABLE_VERSION` parameter explicitly disables specific TLS versions. You can use this parameter with either cryptographic provider.
Use this parameter when you want to allow most TLS versions but explicitly prevent one or more specific versions from being negotiated.
### `TLS_CIPHER_SUITES` Parameters
Use `TLS_CIPHER_SUITES` for Oracle Database 19c TLS cipher suite configuration.
For example:
```
TLS_CIPHER_SUITES = (TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
```
