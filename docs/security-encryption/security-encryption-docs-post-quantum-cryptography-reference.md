# Post-Quantum Cryptography in Oracle Database

Oracle Database supports post-quantum cryptography (PQC) when the next-generation cryptographic provider is active.
PQC algorithms are designed to resist attacks from both classic and quantum computers, as standardized by NIST in FIPS 203, FIPS 204, and FIPS 205. PQC support in Oracle Database 19c includes three algorithm families:
****
- ML-KEM (Module-Lattice Key Encapsulation Mechanism): For TLS key exchange.
****
- ML-DSA (Module-Lattice Digital Signature Algorithm): For TLS digital signatures.
****
- SLH-DSA (Stateless Hash-Based Digital Signature Algorithm): For non-TLS digital signatures.
Usage Notes:
- The next-generation provider must be active.
- PQC algorithms are available in both non-FIPS mode and FIPS 140-3 mode with the next-generation cryptograpich provider only.
- PQC algorithms are not available in FIPS 140-2 mode regardless of which cryptographic provider is enabled.
**Note:** Post-quantum algorithms produce larger keys and signatures than classic algorithms. This may increase TLS handshake sizes and wallet storage requirements. Oracle recommends testing PQC configurations in a non-production environment before deployment.
- ML-KEM for TLS Key Exchange ML-KEM is used to establish a shared secret key during a TLS 1.3 handshake.
- ML-DSA for TLS Digital Signatures ML-DSA is used for TLS digital signatures and certificate validation in TLS 1.3 connections.
- SLH-DSA for Non-TLS Digital Signatures SLH-DSA provides post-quantum digital signatures for non-TLS use cases.
- Post-Quantum Cryptography and FIPS Mode PQC support depends on the active cryptographic provider and FIPS mode.
- Post-Quantum Cryptography Certificates and Wallets Use orapki to manage wallets and certificates for post-quantum cryptography.
## ML-KEM for TLS Key Exchange
ML-KEM (Module-Lattice Key Encapsulation Mechanism), standardized in NIST FIPS 203, is used to securely establish a shared secret key between two parties during a TLS 1.3 handshake. ML-KEM is a lattice-based algorithm intended to replace classical key exchange methods like Diffie-Hellman that are vulnerable to quantum computing attacks.
ML-KEM is only available with TLS 1.3. For TLS 1.2 connections, ECDHE key exchange is used automatically.
Key exchange (ML-KEM) is the more urgent PQC component to deploy due to the Harvest Now, Decrypt Later (HNDL) threat: an attacker can record classically encrypted traffic today and store it until a quantum computer can break the key exchange algorithm.
### Hybrid Key Exchange
As ML-KEM is a relatively new algorithm, Oracle recommends using hybrid mode to provide maximum assurance of privacy for network communications. Hybrid mode ensures quantum resistance while maintaining the proven security of classical ECDHE. In hybrid mode, both ECDHE and ML-KEM are used together to produce a single shared secret for the TLS session. This means both algorithms contribute to the key material. If either algorithm is later found to be compromised, the other still protects the session.
### Named Groups Reference:
The following named groups are available for negotiation. When using the `hybrid` or `ml-kem` modes, the specific group is negotiated automatically during the TLS handshake based on mutual support between client and server.
The following hybrid key exchange groups are available:

| Named Group | Description |
|---|---|
| X25519MLKEM768 | Combines X25519 (classical) with MLKEM768 (post-quantum) |
| SecP256r1MLKEM768 | Combines ECDH P-256 (classical) with MLKEM768 (post-quantum) |
| SecP384r1MLKEM1024 | Combines ECDH P-384 (classical) with MLKEM1024 (post-quantum) |

The following pure ML-KEM groups are available:

| Named Group | NIST Security Level | Approximate Classical Equivalent |
|---|---|---|
| MLKEM512 | Level 1 | AES-128 |
| MLKEM768 | Level 3 | AES-192 |
| MLKEM1024 | Level 5 | AES-256 |

Configure key exchange groups by using the `TLS_KEY_EXCHANGE_GROUPS` parameter. See TLS Key Exchange for parameter details.
## ML-DSA for TLS Digital Signatures
ML-DSA (Module-Lattice Digital Signature Algorithm), standardized in NIST FIPS 204, is a digital signature algorithm for authentication and data integrity. ML-DSA is lattice-based and intended to replace RSA and ECDSA. Certificate validation is supported only in TLS 1.3.
Oracle Database supports the following ML-DSA parameter sets:

| Parameter Set | Approximate Classical Equivalent | NIST Security Level |
|---|---|---|
| ML-DSA-87 | RSA 4096-bit key | Level 5 |
| ML-DSA-65 | RSA 3072-bit key | Level 3 |
| ML-DSA-44 | RSA 2048-bit key | Level 2 |

ML-DSA can be used for:
- TLS server and client certificate authentication (TLS 1.3 only)
- Certificate signing (issuing certificates with ML-DSA keys)
Starting with Oracle Database 19.32, the `orapki` utility supports creating self-signed ML-DSA certificates, reading ML-DSA certificates, and adding ML-DSA certificates to an Oracle wallet regardless of which cryptographic provider is enabled. This capability requires JDK 24 or later.
**Note:** ML-DSA signatures are significantly larger than RSA or ECDSA signatures. Plan for increased certificate and handshake sizes when deploying ML-DSA.
**Note:** Certificates created with ML-DSA keys are not compatible with the legacy provider. If you switch back to the legacy provider, TLS connections using ML-DSA certificates will fail.
## SLH-DSA for Non-TLS Digital Signatures
SLH-DSA (Stateless Hash-Based Digital Signature Algorithm), standardized in NIST FIPS 205, provides an alternative post-quantum digital signature algorithm based on hash functions rather than lattice mathematics.
Oracle Database supports SLH-DSA for non-TLS digital signature operations, such as signing database objects or code. SLH-DSA is not used for TLS handshake authentication.
SLH-DSA is considered a conservative PQC choice because its security relies on the well-understood properties of hash functions. However, SLH-DSA signatures are significantly larger and slower to generate than ML-DSA signatures. Use SLH-DSA when the additional assurance of hash-based security is required and performance is not the primary concern.
**Note:** For TLS digital signatures, use ML-DSA. SLH-DSA is intended for non-TLS use cases only.
## Post-Quantum Cryptography and FIPS Mode
The availability of post-quantum cryptography algorithms depends on the active cryptographic provider and FIPS mode setting.

| Configuration | ML-KEM | ML-DSA | SLH-DSA | Hybrid KEMs |
|---|---|---|---|---|
| Legacy provider, non-FIPS | Not available | Not available | Not available | Not available |
| Legacy provider, FIPS 140-2 | Not available | Not available | Not available | Not available |
| Next-generation cryptographic provider, non-FIPS | Available | Available | Available | Available |
| Next-generation cryptographic provider, FIPS 140-3 mode | Available | Available | Available | Available |

PQC algorithms require the next-generation cryptographic provider. They are not available with the legacy cryptographic provider regardless of FIPS mode.
When the next-generation cryptographic provider is active, PQC algorithms are available in both FIPS 140-3 mode and non-FIPS mode. There is no difference in PQC algorithm availability between these two configurations.
**Note:** To use PQC algorithms with FIPS compliance, enable FIPS 140-3 mode with the next-generation cryptographic provider (`FIPS_140=TRUE`, `FIPS_140_3=TRUE`).
The next-generation cryptographic provider has completed lab testing and is listed on the NIST Cryptographic Provider Validation Program (CMVP) modules in process list. Final FIPS 140-3 certificate issuance is pending. The FIPS 140-3 validation covers all cryptographic algorithms in the next-generation cryptographic provider with the exception of the new post-quantum cryptography (PQC) algorithms. Oracle will update this documentation when the final FIPS 140-3 certificate is issued.
## Post-Quantum Cryptography Certificate Management with `orapki`
Starting with Oracle Database 19.32, the `orapki` utility supports creating self-signed ML-DSA certificates, reading ML-DSA certificates, and adding ML-DSA certificates to an Oracle wallet regardless of which cryptographic provider is enabled. This capability requires JDK 24 or later.
Prerequisites:
  - JDK 24 or later must be installed and configured in the JAVA_HOME environment variable.
To create a self-signed certificate with an ML-DSA key:
```
orapki wallet add -wallet  -dn "CN=example" -keyAlg ML-DSA-65 -validity 365
```
Supported post-quantum key algorithms for orapki:
  - ML-DSA-44: Approximately equivalent to RSA 2048-bit key
  - ML-DSA-65: Approximately equivalent to RSA 3072-bit key
  - ML-DSA-87: Approximately equivalent to RSA 4096-bit key
Recommended Classic (non-PQC) Certificate Algorithms:
For classic (non-PQC) certificates, the following are recommended in order of strength:
  - ECC: ecdsa_secp521r1_sha512 (equivalent to RSA 15360-bit key)
  - ECC: ecdsa_secp384r1_sha384 (equivalent to RSA 7680-bit key)
  - ECC: ecdsa_secp256r1_sha256 (equivalent to RSA 3072-bit key)
  - RSA: 2048-bit minimum. NIST recommends at least 3072-bit after 2030.
To check the certificate algorithm and key length:
orapki wallet display -wallet wallet_dir -complete -details
### Wallet Encryption Check
Wallets created before Oracle Database 19.22 may use 3DES encryption. To determine the encryption algorithm:
```
openssl pkcs12 -info -in ./ewallet.p12 -nodes
```
If the wallet uses 3DES, convert it to AES-256:
```
orapki wallet convert -wallet wallet_location -compat_v12
```
## Related Topics
  - Switching the Cryptographic Provider for Oracle Database 19c
  - TLS Key Exchange
  - Post-Quantum Certificates with orapki
  - Configuring TLS 1.3
