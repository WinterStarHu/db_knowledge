# Configuring Post-Quantum Cryptography

When the next-generation cryptographic provider is enabled for Oracle Database 19c, ML-KEM and hybrid post-quantum key exchange become available for TLS 1.3. Additionally, ML-DSA becomes available for signing and verifying certificates. This is ideal if you want to standardize on the forward-looking Oracle Database 19c cryptographic path.
See Switching the Cryptographic Provider for Oracle Database 19c and Configuring TLS 1.3 for more information.
## Enabling Post-Quantum Cryptography with ML-KEM for TLS
ML-KEM in Oracle Database 19c requires the next-generation cryptographic provider, TLS 1.3, and client, listener, and server support for the selected key-exchange configuration. Post-quantum key exchange in this section is supported only with TLS 1.3, not TLS 1.2.
The reason to plan this work now is not that quantum computers can already break modern Oracle Database TLS deployments at operational scale. The more immediate concern is harvest-now, decrypt-later risk: attackers can intercept and store encrypted traffic today, then attempt to decrypt it later if quantum hardware or algorithms become capable enough to break the public-key cryptography used for key establishment. This matters most for data with a long confidentiality life, such as personally identifiable information, regulated records, intellectual property, and long-retention backups.
For TLS, the main quantum concern is the public-key cryptography used to establish session keys and authenticate endpoints. Oracle’s post-quantum guidance also recommends raising symmetric key strength for long-lived data, because symmetric encryption remains relevant to the broader quantum risk discussion even though ML-KEM specifically addresses key establishment.
Treat ML-KEM adoption as infrastructure modernization work. Inventory the affected clients, drivers, listeners, certificates, key sizes, and operational owners first, then introduce post-quantum settings in controlled stages.
### Configure Key Exchange Groups
Start with a hybrid rollout before considering a stricter ML-KEM-first policy. Hybrid key establishment helps reduce risk while preserving a classical and a post-quantum component during the migration window.
  - Build a cryptographic inventory for the Oracle Database 19c environment, including systems, protocols, certificates, key sizes, dependencies, and owners.
  - Enforce TLS 1.3 where possible and maintain TLS 1.2 only where compatibility still requires it.
  - Login to the database server or the client server.
``````````
```
TLS_KEY_EXCHANGE_GROUPS=(hybrid,ml-kem)
```
- Edit the sqlnet.ora or listener.ora file to include the TLS_KEY_EXCHANGE_GROUPS parameter. The default location of the sqlnet.ora file is in the $ORACLE_HOME/network/admin directory. For example: See TLS_KEY_EXCHANGE_GROUPS in Oracle Database Net Services Reference for more information.
  - Test each client driver, application server, and partner integration path separately before requiring only post-quantum groups. The negotiated key exchange is separate from the TLS 1.3 cipher suite.
  - Validate both successful connections and expected failures.
  - Keep fallback behavior explicit during transition and document each exception.
  - Confirm policy expectations for FIPS and PQC independently, because they address different requirements.
### Client Driver Support Matrix for TLS 1.3 and ML-KEM
Client support for TLS 1.3 and ML-KEM in Oracle Database 19c depends on both the driver implementation and the underlying runtime or cryptographic library. OCI-based clients currently provide the clearest path for ML-KEM support. Thin drivers and managed runtimes can vary by platform, operating system, JDK, .NET, or OpenSSL level, so verify the exact client stack before requiring ML-KEM or hybrid key exchange in production.
The following table summarizes which clients support TLS 1.3 and post-quantum cryptography.

| Client driver | Variant or platform | TLS 1.3 support | ML-KEM / PQC support | Notes |
|---|---|---|---|---|
| OCI / C client | OCI-based client stack | Yes | Yes | Supports TLS_KEY_EXCHANGE_GROUPS in client sqlnet.ora |
| JDBC thin | Java thin driver | Yes | Limited | Needs to use with JDK versions that have PQC support |
| JDBC thick | JDBC with OCI/thick path | Yes | Yes | Uses the OCI-based path and aligns with OCI client support |
| Python thin | Linux with OS OpenSSL 3.5 or later | Yes | Yes, conditional | PQC support depends on the operating system OpenSSL version |
| Python thin | Linux without OpenSSL 3.5 or later | Yes | No | TLS 1.3 available, but PQC algorithms are not available |
| Python thin | Windows or macOS | Yes | Yes (see Notes column) | Depends on the runtime OS crypto stack |
| Node.js thin | Runtime-dependent | Yes | Yes (see Notes column) | Confirm runtime crypto support and negotiated key exchange before enabling ML-KEM-only policy |
| ODP.NET unmanaged | OCI-based | Yes | Yes | Uses the OCI-based path and aligns with OCI client support |
| ODP.NET Core | Linux | Yes | Yes | - |
| ODP.NET Core | Windows | Yes | No | TLS works, but PQC over TLS is not available |
| ODP.NET managed | Windows | Yes | No | TLS works, but PQC over TLS is not available |

## Configuring Post-Quantum Cryptography with ML-DSA Signed Certificates
Public certificate authorities do not yet broadly issue ML-DSA certificates for production TLS deployments. The current Oracle guidance is therefore to use self-signed ML-DSA certificates for development, interoperability testing, and controlled internal environments until the broader CA and trust ecosystem adds support for PQC certificate issuance and validation.
For Oracle Database TLS, ML-DSA certificates are relevant to authentication and certificate validation, while ML-KEM is the key encapsulation mechanism. These are separate functions. A TLS connection can use ML-KEM for TLS 1.3 key exchange and use an ML-DSA certificate for server or client authentication, but both peers must support PQC certificate handling. ML-DSA certificates are not usable with TLS 1.2. Use TLS 1.3 only.
### Prerequisites
  - Oracle environment with the next-generation cryptographic provider and PQC support
  - orapki with JDK 24 or later for ML-DSA certificate creation and wallet operations
  - TLS 1.3 enabled on both client and server
  - Both peers must support ML-DSA certificate parsing and validation
  - A test or internal trust model, because self-signed ML-DSA certificates are not publicly trusted
### Supported ML-DSA variants in `orapki`
The Oracle PKI command-line interface supports the following ML-DSA key variants:
  - ML-DSA-44
  - ML-DSA-65
  - ML-DSA-87
The corresponding signature algorithm names are:
  - mldsa44
  - mldsa65
  - mldsa87
Oracle PKI help for addition of certificate or certificate-request shows the relevant options in this form:
```
orapki wallet add -wallet  -pwd  -dn  -alias  \ -asym_alg [RSA | ECC | ML-DSA-44 | ML-DSA-65 | ML-DSA-87] \ -sign_alg [md5 | sha1 | sha256 | sha384 | sha512 | mldsa44 | mldsa65 | mldsa87]
```
### Important behavior and limitations
  - orapki currently supports creation of self-signed ML-DSA certificates.
  - The same tooling supports reading ML-DSA certificates and adding them to Oracle Wallet.
  - TLS 1.3 is required for ML-DSA certificates in TLS.
  - TLS 1.2 handshake fails if either side uses an ML-DSA certificate.
  - If one side uses an ML-DSA certificate and the peer does not support PQC certificate handling, the TLS handshake fails during certificate validation.
  - ML-KEM negotiation is independent of whether the certificate is RSA, ECC, or ML-DSA.
### Recommended internal workflow
Use a small private trust hierarchy:
  - One self-signed ML-DSA root certificate
  - One server certificate signed by that root
  - One client certificate signed by that root if mutual TLS is required
This follows the standard Oracle `orapki` request-and-sign model and is a better testing pattern than using unrelated self-signed end-entity certificates on each side.
### Create the ML-DSA root CA wallet and self-signed root certificate
```
orapki wallet create -wallet  -pwd  -auto_login
```
- Create the root CA wallet.
```
orapki wallet add \ -wallet  \ -pwd  \ -dn "CN=PQC Root CA,O=Example,C=US" \ -alias pqc_root_ca \ -asym_alg ML-DSA-65 \ -sign_alg mldsa65 \ -self_signed \ -validity 3650
```
- Add a self-signed ML-DSA root certificate. Example using ML-DSA-65:
```
orapki wallet display -wallet  -pwd  -complete
```
- Display the root wallet.
```
orapki wallet export \ -wallet  \ -dn "CN=PQC Root CA,O=Example,C=US" \ -cert  \ -pwd
```
- Export the root CA certificate so it can be imported as a trusted certificate elsewhere.
### Create a server certificate request and sign it with the ML-DSA root
```
orapki wallet create -wallet  -pwd  -auto_login
```
- Create the server wallet.
```
orapki wallet add \ -wallet  \ -pwd  \ -dn "CN=dbserver.example.com,O=Example,C=US" \ -alias server_mldsa \ -asym_alg ML-DSA-65
```
- Add the server key and certificate request to the wallet.
```
orapki wallet export \ -wallet  \ -dn "CN=dbserver.example.com,O=Example,C=US" \ -request  \ -pwd
```
- Export the server certificate request.
```
orapki cert create \ -wallet  \ -request  \ -cert  \ -validity 3650 \ -sign_alg mldsa65 \ -pwd
```
- Sign the server certificate request with the ML-DSA root wallet.
```
orapki wallet add \ -wallet  \ -trusted_cert \ -cert  \ -pwd
```
- Add the root CA certificate to the server wallet as a trusted certificate.
```
orapki wallet add \ -wallet  \ -user_cert \ -cert  \ -pwd
```
- Add the signed server certificate to the server wallet as the user certificate.
```
orapki wallet display -wallet  -pwd  -complete
```
- Display the server wallet to confirm both the trusted root and user certificate are present.
### Create a client certificate request and sign it with the ML-DSA root
Use this section when mutual TLS is required.
```
orapki wallet create -wallet  -pwd  -auto_login
```
- Create the client wallet.
```
orapki wallet add \ -wallet  \ -pwd  \ -dn "CN=dbclient.example.com,O=Example,C=US" \ -alias client_mldsa \ -asym_alg ML-DSA-65
```
- Add the client key and certificate request to the wallet.
```
orapki wallet export \ -wallet  \ -dn "CN=dbclient.example.com,O=Example,C=US" \ -request  \ -pwd
```
- Export the client certificate request.
```
orapki cert create \ -wallet  \ -request  \ -cert  \ -validity 3650 \ -sign_alg mldsa65 \ -pwd
```
- Sign the client request with the ML-DSA root wallet.
```
orapki wallet add \ -wallet  \ -trusted_cert \ -cert  \ -pwd
```
- Add the root CA certificate to the client wallet as a trusted certificate.
```
orapki wallet add \ -wallet  \ -user_cert \ -cert  \ -pwd
```
- Add the signed client certificate to the client wallet as the user certificate.
```
orapki wallet display -wallet  -pwd  -complete
```
- Display the client wallet.
- Oracle PKI help for addition of certificate or certificate-request shows the relevant options in this form:
```
orapki wallet add -wallet  -pwd  -dn  -alias  \ -asym_alg [RSA | ECC | ML-DSA-44 | ML-DSA-65 | ML-DSA-87] \ -sign_alg [md5 | sha1 | sha256 | sha384 | sha512 | mldsa44 | mldsa65 | mldsa87]
```
### Establish trust for one-way TLS
For one-way TLS, the client must trust the server certificate.
Import the server self-signed certificate into the client wallet as a trusted certificate:
```
orapki wallet add \ -wallet  \ -trusted_cert \ -cert  \ -pwd
```
If the client uses the system certificate store instead of a wallet, this self-signed model is usually less suitable unless the certificate is explicitly imported into the host trust store.
### Establish trust for mutual TLS
For mutual TLS, each side must trust the other side’s self-signed certificate.
Import the client certificate into the server wallet:
```
orapki wallet add \ -wallet  \ -trusted_cert \ -cert  \ -pwd
```
Import the server certificate into the client wallet:
```
orapki wallet add \ -wallet  \ -trusted_cert \ -cert  \ -pwd
```
### Use the certificates in TLS connections
For the database server:
  - Place the server wallet under WALLET_ROOT//tls or the appropriate server wallet path
  - Keep the TCPS endpoints configured for TLS connections
  - Use TLS 1.3
  - If testing ML-KEM key exchange, configure:
```
TLS_VERSION=(1.3) TLS_KEY_EXCHANGE_GROUPS=(ml-kem)
```
For a transitional configuration:
```
TLS_VERSION=(1.3) TLS_KEY_EXCHANGE_GROUPS=(hybrid,ml-kem)
```
For one-way TLS:
```
TLS_CLIENT_AUTHENTICATION=FALSE
```
For mutual TLS:
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
For the client:
  - Point to the client wallet if using a wallet-based trust model
  - Use PROTOCOL=tcps
  - Use TLS 1.3
  - For mTLS, present the client wallet containing the client ML-DSA key and certificate
### Validation steps
After configuration:
  - Verify both wallets contain the expected user certificate and trusted peer certificate.
  - Confirm the connection negotiates tcps and TLS 1.3.
  - If ML-KEM testing is in scope, verify the negotiated TLS key exchange group with supported diagnostics or tracing.
    - TLS 1.3 with both peers PQC-capable
        - Handshake failure when one side lacks ML-DSA certificate support
        - Handshake failure when TLS 1.2 is forced
### Suggested usage guidance
Use self-signed ML-DSA certificates for:
  - PQC interoperability testing
  - Internal lab validation
  - Controlled proofs of concept
  - Early TLS 1.3 PQC rollout testing
Do not position this as a public internet PKI model until public CA support and broader trust-store ecosystem support become available.
## Related Topics
  - Switching Cryptographic Providers
  - TLS_KEY_EXCHANGE_GROUPS in Oracle Database Net Services Reference
