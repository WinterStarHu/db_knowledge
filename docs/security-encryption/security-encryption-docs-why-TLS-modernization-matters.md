# Why TLS Modernization Matters

TLS modernization, transitioning from TLS 1.2 to TLS 1.3, reduces exposure to obsolete protocols, aging cryptographic configurations, and compatibility exceptions that are difficult to secure consistently. It also makes database connections easier to audit and update as security requirements change. For Oracle Database 19c, prefer TLS 1.3 when clients support it. Retain TLS 1.2 where compatibility requires it, using approved cipher suites and a documented client-upgrade plan.
## Risks from Legacy TLS Protocols and Configurations
Oracle Database 19c with next-generation cryptographic provider supports TLS 1.2 and TLS 1.3, but not TLS 1.0 or TLS 1.1. TLS 1.0 and TLS 1.1 are obsolete. They were defined before current authenticated-encryption profiles and lack protections introduced in later TLS versions. Keeping them enabled also adds protocol and fallback paths that should no longer protect sensitive database traffic. The IETF moved these versions to Historic status.
Protocol age is only one part of the risk. Long-lived TLS configurations can retain CBC-mode cipher suites, SHA-1-based CBC suites, static RSA key exchange, pinned protocol versions, long cipher lists, duplicated wallets, or exceptions for clients that are no longer in service. These choices may be associated with TLS 1.2 deployments, even though TLS 1.2 can be secure when it uses strong cipher suites, modern certificates, and ephemeral key exchange. Deprecated cipher suites are disabled by default in Oracle Database 19c.
Legacy protocols and configurations increase risk in several ways:
  - Obsolete protections: Older TLS versions lack protections introduced in TLS 1.2 and TLS 1.3 and rely on older record, handshake, and algorithm designs.
  - Downgrade and fallback exposure: Supporting more versions and compatibility paths increases the chance that a configuration mistake or outdated endpoint permits weaker protection than intended.
  - Configuration error: Broad cipher support and accumulated exceptions make it harder to apply the same security policy to every database client and listener.
  - Larger attack surface: Every additional protocol, algorithm, and compatibility exception must be maintained, tested, and monitored.
  - Compliance and interoperability risk: Current security standards and client libraries increasingly prohibit or remove obsolete protocols and algorithms.
TLS 1.2 remains suitable when compatibility requires it and it is configured with Oracle-approved cipher suites, certificates that use currently accepted signature algorithms, and ephemeral key exchange. Prefer TLS 1.3 for compatible clients, and manage TLS 1.2 as an explicit compatibility requirement with an owner and upgrade plan.
In Oracle Database 19c, TLS modernization also matters because TLS 1.3, ML-KEM or hybrid post-quantum key exchange, and FIPS 140-3 depend on the next-generation cryptographic provider. Enabling that module in 19c lets teams move toward the same cryptographic direction used in later database releases while retaining a controlled transition path for existing 19c estates.
## TLS 1.2 and TLS 1.3 Comparison

| Area | TLS 1.2 | TLS 1.3 |
|---|---|---|
| Protocol choices | Supports a broad range of cipher and key-exchange combinations, including older choices that require careful policy control. | Removes obsolete protocol features and limits negotiation to modern authenticated-encryption choices. |
| Authenticated encryption | Depends on the selected cipher suite. | Uses authenticated encryption with associated data (AEAD), which encrypts data and verifies its integrity as one operation. |
| Forward secrecy | Depends on selecting an ephemeral key-exchange cipher suite. Static RSA and static Diffie-Hellman do not provide it. | Removes static RSA and static Diffie-Hellman key exchange. ECDHE and supported hybrid exchanges use ephemeral key material. |
| Full handshake | Normally requires two network round trips before application data can be sent. | Normally requires one network round trip before application data can be sent. Actual connection time also depends on authentication, network latency, client behavior, and session reuse. |
| Downgrade protection | Relies more heavily on correct version and cipher configuration. | Provides stronger protection against negotiating an older protocol than the endpoints intend. |
| Policy management | Cipher suites combine encryption, integrity, and key-exchange decisions. | Separates cipher-suite selection from certificate and key-exchange policy, reducing the number of combinations to manage. |
| Post-quantum key exchange in Oracle Database 19c | Does not provide ML-KEM key exchange. | Provides ML-KEM and hybrid post-quantum key-exchange options when supported by both endpoints. |

## Benefits of TLS 1.3 in Oracle Database 19c
TLS 1.3 provides a stronger and simpler baseline. It restricts negotiation to modern authenticated-encryption cipher suites, removes static RSA and static Diffie-Hellman key exchange, and reduces the number of protocol combinations that administrators must configure and audit. When explicit restrictions are absent, each TLS connection selects the strongest protocol version and cipher suite supported by its two endpoints. When both the database server and client are 19c and no protocol version is pinned, TLS 1.3 is enabled by default.
TLS 1.3 connections that use Elliptic Curve Diffie-Hellman Ephemeral (ECDHE) or a supported hybrid exchange provide forward secrecy. These exchanges use ephemeral key material, so if a certificate private key is compromised later, that key alone is not sufficient to decrypt previously recorded sessions that used ECDHE or a supported hybrid exchange.
The shorter full handshake can reduce connection setup time, especially across higher-latency networks or for applications that frequently open new connections. Connection pooling and session reuse can reduce how often applications incur a full handshake, so measure performance in the actual application environment.
Modernization also improves crypto agility: the ability to replace protocols, algorithms, certificates, or key-exchange methods without redesigning the deployment. A consistent configuration, a current client inventory, and repeatable verification make future security changes easier to plan and enforce.
Oracle Database 19c supports ML-KEM and hybrid post-quantum key exchange with TLS 1.3. Organizations with long confidentiality requirements should consider harvest-now, decrypt-later risk, the possibility that an attacker records encrypted traffic today and attempts to decrypt it later using a sufficiently capable quantum computer, when prioritizing applications. First establish and verify a clean TLS 1.3 deployment, and then evaluate ML-KEM or hybrid policy according to data sensitivity and client support.
## Recommended Modernization Approach
  - Inventory the current listener, server, and client TLS settings.
  - Identify whether the deployment still depends on older protocol or cipher restrictions.
  - Enable the next-generation cryptographic provider in a controlled test environment first.
  - Establish a clean one-way TLS baseline before adding mTLS, DN matching, or PQC controls.
  - Allow automatic protocol and cipher negotiation unless policy requires explicit restrictions.
  - Verify the negotiated TLS version and cipher suite from representative client types.
  - Add explicit TLS 1.3, DN matching, mTLS, revocation, or PQC controls one at a time.
## Related Topics
  - Configuring TLS 1.3
