# TLS Features in Oracle Database

TLS secures connections between the Oracle Database client and server. Starting with Oracle Database 19.32, Oracle Database 19c supports both the next-generation cryptographic provider and the legacy provider as cryptographic providers. Though the legacy provider remains the default provider, Oracle recommends that you switch to the next-generation cryptographic provider for TLS 1.3, FIPS 140-3 compliance, post-quantum cryptography (PQC) algorithms, and hybrid key exchange groups. For information on why and how to switch cryptographic providers see Why TLS Modernization Matters and Switching the Cryptographic Provider for Oracle Database 19c.
The database client and server can be configured to use TLS depending on your requirements. There are several options to consider which are mentioned below. Configuring a client-server TLS connection requires the database server to have a wallet. The server wallet includes the private key, the signed user certificate, the root of trust certificate and any intermediate certificates for the database server user certificate.
The TLS wallet on the database server must be stored under the `WALLET_ROOT` location. Create a directory for TLS under `WALLET_ROOT`, so it looks like `WALLET_ROOT//tls`. Each container (including CDB root) will have its own TLS wallet, there’s no configuration to have a single wallet work for more than one or all containers when using `WALLET_ROOT`.
## How TLS Network Encryption Works
When a client initiates a TCPS (Transmission Control Protocol Secured) connection, the client, listener, and database server participate in the TLS path as follows:
  - The client connects to the listener over tcps.
  - The TLS handshake starts before database user authentication.
  - The endpoints negotiate a common TLS version and cipher suite.
  - The server presents its certificate. The client validates the certificate chain and applies DN matching rules if DN matching is enabled.
  - If mutual TLS is required, the client also presents its certificate and the server validates it.
  - After the TLS session is established, Oracle Database performs database user authentication by the configured database method.
  - Application data then travels inside the negotiated encrypted TLS session.
The key operational point is that TLS certificate authentication and database user authentication are related but separate layers. A correct TLS deployment protects the transport path. Database access still depends on the configured database authentication and authorization model.
## Self-Signed Certificate vs. CA-Signed Certificate
Choose the trust model before configuring the listener or client.
- Self-signed or private CA certificate: This model is common for internal services. The organization creates or operates the trust anchor and signs the server certificate. Clients must receive the root certificate through the system certificate store or a client wallet.
- Public CA-signed certificate: A public CA signs the server certificate. Its root certificate is often already present in system certificate stores, which can eliminate client-wallet distribution for one-way TLS. Certificate issuance and renewal remain subject to the CA’s validation, policy, and cost.
## One-Way TLS vs. Mutual TLS
- One-way TLS: The server presents its certificate and the client validates it. The client does not present a separate certificate. The database server and listener require a wallet, while the client only needs access to the trusted CA root. This is the most common TLS pattern.
- Mutual TLS: Both client and server present certificates. Each endpoint validates the peer certificate. The TLS handshake authenticates certificates; it does not by itself authorize a database user. Database password, Kerberos, RADIUS, OCI IAM, Microsoft Entra ID, or PKI certificate authentication can still provide database-user authentication.
Use `TLS_CLIENT_AUTHENTICATION` to control the behavior.
  - TLS_CLIENT_AUTHENTICATION = FALSE: enables one-way TLS
  - TLS_CLIENT_AUTHENTICATION = TRUE: requires mTLS
  - TLS_CLIENT_AUTHENTICATION = OPTIONAL: accepts either one-way TLS or mTLS depending on whether the client presents a certificate.
To allow one-way TLS connections, set `TLS_CLIENT_AUTHENTICATION` to `FALSE` or `OPTIONAL` in both the server `sqlnet.ora` file and the listener `listener.ora` file. Use `FALSE` when you want to permit only one-way TLS.
For mTLS, configure the client to send its certificate and configure the server and listener to require or accept client certificates. If `TLS_CLIENT_AUTHENTICATION` is set to `FALSE` on the client, then the client does not send its certificate. If the server requires client authentication, then the connection fails.
## TLS With or Without a Client Wallet
A client wallet is required only when the client must present a certificate from an Oracle wallet for mTLS. A client that uses Microsoft Certificate Store (MCS) can present its certificate without an Oracle client wallet. A client wallet can also store a private or self-signed CA root when the system certificate store cannot be used.
A client can use one-way TLS without an Oracle wallet when all of the following apply:
  - The client does not need to present its own certificate.
  - The CA root that signed the server certificate is available in a supported system certificate store or supported PEM trust location.
  - The client platform and driver support the applicable system certificate store integration.
Using the system certificate store reduces wallet distribution and renewal work for large client estates.
## Certificate DN Matching
DN matching verifies that a valid certificate belongs to the server the client intended to reach. Without DN matching, a certificate signed by a trusted CA may be accepted even if it identifies a different server.
For partial matching, set `TLS_SERVER_DN_MATCH=TRUE` in the client `sqlnet.ora` file or in the connect descriptor in `tnsnames.ora`:
```
TLS_SERVER_DN_MATCH=TRUE
```
The client compares the connect descriptor `HOST` value with certificate identity fields such as the common name and subject alternative names. For full matching, set the expected DN only in the connect descriptor in `tnsnames.ora` or the connection string:
```
(SECURITY=
  (TLS_SERVER_DN_MATCH=TRUE)
  (TLS_SERVER_CERT_DN="CN=db.example.com,O=Example,C=US"))
```
Full DN matching validates the configured DN against the certificate in the listener wallet and is independent of the certificate in the database server wallet. For partial DN matching, the certificate CN must match the connect descriptor `HOST` value, and the corresponding certificate configuration must be present in both the listener and database server wallets. Establish basic TLS first, and then enable DN matching.
## Post-Quantum Cryptography
Determine if using post-quantum cryptography (PQC) is appropriate for your database configuration.
Post-Quantum Cryptography (PQC), also known as quantum-resistant or quantum-safe cryptography, is a new class of cryptographic algorithms designed to be secure against attacks by future, large-scale quantum computers.
Current widely used asymmetric-key cryptographic methods, such as RSA and Elliptic Curve Cryptography (ECC), rely on mathematical problems that are computationally difficult for classical computers to solve. However, a sufficiently powerful quantum computer, using algorithms like Shor’s algorithm, could easily break these systems, compromising the security of sensitive data.
PQC algorithms are based on different mathematical problems—such as those related to lattices, hash functions, or codes—that are believed to be difficult for both classical and quantum computers to solve. The transition to PQC is a critical, proactive measure to protect long-term data, such as medical records and intellectual property, from being harvested today and decrypted in the future once a quantum computer becomes available.
Oracle Database supports the use of two PQC algorithms standardized by the National Institute of Standards and Technology (NIST): ML-KEM and ML-DSA.
````````````
- ML-KEM - A Key Encapsulation Mechanism (KEM) used to securely establish a shared secret key between two parties. It is a lattice-based algorithm and is intended to replace classic key exchange methods like Diffie-Hellman. ML-KEM and Elliptic Curve Diffie-Hellman Ephemeral (ECDHE) hybrid key exchange are only supported in TLS 1.3. You will need to set the TLS_KEY_EXCHANGE_GROUPS parameter in sqlnet.ora. If the TLS_KEY_EXCHANGE_GROUPS parameter is not set while the next-generation cryptographic provider is enabled, then the default value of hybrid will be used. Setting the TLS_KEY_EXCHANGE_GROUPS parameter to hybrid produces a hybrid KEM that combines the key-exchange secrets from both ML-KEM and ECDHE to produce a single shared secret for the TLS session. A hybrid KEM can provide a critical security fallback in case either individual algorithm fails.
- ML-DSA - A digital signature algorithm used for authentication and data integrity. It is also a lattice-based algorithm and is intended to replace algorithms like RSA and ECDSA. ML-DSA algorithms for certificate validation are only supported in TLS 1.3. RSA and ECC algorithms are supported for certification validation in TLS 1.3 and TLS 1.2. orapki supports creating self-signed ML-DSA, reading ML-DSA certifications, and adding ML-DSA certificates to Oracle wallet with JDK 24 or later.
See Configuring Post-Quantum Cryptography and Post-Quantum Cryptography Reference for detailed information about PQC algorithms, configuration, and FIPS mode interaction.
