# Migrate from Oracle Database 19c TLS 1.2 to Oracle Database 19.32 with TLS 1.3

Migrate to TLS 1.3 in stages while validating clients, certificates, wallets, and optional PQC or FIPS configuration.
This topic describes a practical migration path from an Oracle Database 19c deployment using TLS 1.2 to Oracle Database 19.32 with TLS 1.3. It also covers two optional follow-on steps:
  - Enabling post-quantum cryptography with ML-KEM
  - Enabling FIPS 140-3 mode
The recommended approach is staged:
  - Inventory the current TLS and cryptographic configuration.
  - Confirm that the environment can adopt the next-generation cryptographic provider safely.
  - Enable the next-generation cryptographic provider in a nonproduction environment.
  - Establish a clean TLS 1.3 baseline while retaining TLS 1.2 only where compatibility requires it.
  - Verify clients, drivers, wallets, certificates, and negotiated protocol behavior.
  - Optionally enable ML-KEM or hybrid key exchange.
  - Optionally enable FIPS 140-3 after confirming compliance and algorithm requirements.
## Migration objectives
The migration should achieve the following outcomes:
  - Move the TLS deployment to the Oracle Database 19.32 patch that supports TLS 1.3.
  - Keep the initial configuration as close as possible to defaults so that Oracle can negotiate strong protocol versions and cipher suites automatically.
  - Avoid carrying forward old explicit cipher restrictions unless they are still required.
  - Preserve TLS 1.2 only for known compatibility dependencies.
  - Confirm client readiness before enforcing TLS 1.3 only.
  - Treat PQC and FIPS 140-3 as separate optional phases after the TLS 1.3 baseline is stable.
## Step 1: Inventory the current environment
Before enabling the next-generation cryptographic provider or changing TLS policy, record the current server, listener, and client state.
At minimum, capture:
  - Oracle Database server release and RU level
  - Oracle Net listener release and RU level
  - OCI / C
  - JDBC thin
  - JDBC thick
  - Python
  - ODP.NET
  - Node.js
  - SQL*Plus and tools that depend on OCI
  - JDK version
  - .NET version
  - OpenSSL version where applicable
  - WALLET_ROOT
  - Listener WALLET_LOCATION
  - Client wallet usage or system certificate store usage
  ``````  - TLS_VERSION
        - TLS_DISABLE_VERSION
        - TLS_CIPHER_SUITES
        - TLS_ENABLE_WEAK_CIPHERS
        - TLS_CLIENT_AUTHENTICATION
        - TLS_SERVER_DN_MATCH
        - TLS_SERVER_CERT_DN
        - TLS_CERT_REVOCATION
        - TLS_KEY_EXCHANGE_GROUPS
    - Issuer
        - Subject and SAN
        - Key type
        - Signature algorithm
        - Expiration
        - Renewal owner
  - RAC, DRCP, CMAN, database link, gateway, and application-server dependencies
    - NETWORK_PROTOCOL
        - TLS_VERSION
        - TLS_CIPHERSUITE
## Step 2: Confirm cryptographic dependencies before enabling the next-generation cryptographic provider
The next-generation cryptographic provider changes the cryptographic implementation used by Oracle Database. Before enabling it, confirm whether any deployed feature still depends on older algorithms, older protocol assumptions, or specific cryptographic behavior.
Review at least the following:
    - Confirm that certificates and trust chains use accepted algorithms.
        - Identify any certificates that rely on older or deprecated algorithms.
    - Verify whether thin clients depend on JDK, .NET, or operating system OpenSSL behavior
    - Database links
        - Gateways
        - Oracle RAC
        - Monitoring agents
        - Backup agents
        - Connection pools
        - Application servers
    - Determine whether the deployment must remain in non-FIPS mode, FIPS 140-2 mode, or intends to move to FIPS 140-3 mode
    - Determine whether ML-KEM or hybrid key exchange will be tested or enabled later
In practice, confirm whether any important database feature or client path still relies on:
  - Pinned TLS 1.2 behavior
  - Pinned cipher lists
  - Weak or deprecated cipher suites
  - Older certificate signature algorithms
  - Wallet assumptions that differ from the 19.32 guidance
  - A runtime that cannot negotiate TLS 1.3 correctly
If any such dependency exists, keep it documented as a migration exception with an owner and removal plan.
## Step 3: Enable the next-generation cryptographic provider in a test environment
Oracle Database 19.32 requires the next-generation cryptographic provider for TLS 1.3, ML-KEM, and FIPS 140-3.
Switch to the next-generation cryptographic provider by running the following:
```
python $ORACLE_HOME/bin/set_crypto_provider.py next-generation
```
After the provider change:
  - Restart the database instance.
  - Restart or reload the Oracle Net listener.
```
python $ORACLE_HOME/bin/set_crypto_provider.py status
```
- Verify that the expected cryptographic provider is active:
Do not combine this provider switch with major TLS policy changes in the same test step. First confirm that the environment still works with the next-generation cryptographic provider before tightening protocol or cipher policy.
## Step 4: Establish the TLS 1.3 baseline with minimum configuration
For the first working configuration on 19.32, keep the settings as close to default behavior as possible.
Recommended baseline:
  - Enable the next-generation cryptographic provider.
  - Keep TLS on tcps.
  - Do not set TLS_VERSION.
  - Do not set TLS_CIPHER_SUITES unless policy requires explicit selection.
  - Do not set TLS_KEY_EXCHANGE_GROUPS initially.
  - Do not force TLS 1.3 only until client validation is complete.
For the initial transition window, remove `TLS_VERSION` so that the client and database server negotiate TLS 1.3 or TLS 1.2 according to client capability. For configuration details, see Configuring TLS 1.3.
This allows:
  - TLS 1.3 for capable clients.
  - TLS 1.2 for known compatibility clients.
Use explicit `TLS_CIPHER_SUITES` only when required. Otherwise, let Oracle negotiate the strongest mutually supported cipher suite automatically.
For the server and listener:
  - Keep the server wallet under WALLET_ROOT.
  - Keep the listener wallet under WALLET_LOCATION.
  - Keep TLS_CLIENT_AUTHENTICATION=FALSE unless mutual TLS is already required.
For clients:
  - Keep wallet usage or system certificate store usage aligned with the existing trust model.
  - Avoid new per-client overrides unless testing requires them.
## Step 5: Verify wallet, certificate, and trust model correctness
Before moving from TLS 1.2 to TLS 1.3 enforcement, confirm that wallet and certificate layout already follows the 19.32 model.
Check the server wallet layout:
  - WALLET_ROOT is set correctly
  - The TLS wallet is deployed in the expected container-specific location.
    - Private key
        - User certificate
        - Trusted root certificate
        - Intermediate certificates if required
Check the listener:
  - TCPS endpoint is configured
  - WALLET_LOCATION points to the correct listener wallet
  - The wallet is readable by the listener.
Check the clients:
  - One-way TLS without a client wallet uses the system certificate store only when the trusted CA root is present and supported by the client platform.
  - Wallet-based clients point to the correct wallet path.
  - Mutual TLS clients have both a usable user certificate and the full trust chain.
## Step 6: Validate client readiness
Before forcing TLS 1.3 only, test every important client and connection path.
Client validation should cover:
  - SQL*Plus
  - OCI / C clients
  - JDBC thin
  - JDBC thick
  - Python
  - ODP.NET
  - Node.js
  - Connection pools
  - Application servers
  - RAC paths
  - Database links
  - Operational tooling
For every representative client:
  - Connect using tcps.
  - Verify:
```
SELECT sys_context('USERENV','NETWORK_PROTOCOL') AS network_protocol FROM dual;
SELECT sys_context('USERENV','TLS_VERSION') AS tls_version FROM dual;
SELECT sys_context('USERENV','TLS_CIPHERSUITE') AS tls_ciphersuite FROM dual;
```
````  - NETWORK_PROTOCOL is tcps.
  - The client negotiates TLS 1.3 when expected.
  - The selected cipher suite is a strong TLS 1.3 or TLS 1.2 suite as intended.
The client checks should also confirm:
  - Whether the client still pins TLS 1.2.
  - Whether it uses a wallet or system certificate store.
  - Whether runtime support is sufficient for TLS 1.3.
  - Whether application code relies on old TLS configuration assumptions.
## Step 7: Clean up old TLS 1.2-era configuration
After the initial TLS 1.3 baseline is stable, remove unnecessary TLS 1.2-era overrides.
Prefer to remove:
  - Old explicit TLS_CIPHER_SUITES lists that were added only for legacy compatibility
  - Deprecated weak-cipher exceptions
  - Old protocol pinning that prevents TLS 1.3 negotiation
  - Redundant client wallet settings where the system certificate store is sufficient
Keep explicit configuration only where there is still a documented need.
## Step 8: Enforce TLS 1.3 when all required clients are ready
After client validation is complete, move from the compatibility window to TLS 1.3 only if the environment no longer requires TLS 1.2.
To require TLS 1.3 or explicitly block TLS 1.2, follow Configure TLS 1.3.
Use this only after confirming that every required client path succeeds with TLS 1.3.
## Step 9: Use defaults for strong cipher suites whenever possible
Oracle Database 19.32 with the next-generation cryptographic provider already supports strong modern cipher negotiation. The preferred operating model is:
  - Do not specify TLS_CIPHER_SUITES unless policy requires it
  - Let the endpoints negotiate the strongest common cipher suite
If explicit policy is required, use a narrow list of strong suites only.
Example:
```
TLS_CIPHER_SUITES=(TLS_AES_256_GCM_SHA384,TLS_AES_128_GCM_SHA256)
```
Avoid carrying forward old TLS 1.2 CBC or RSA-based compatibility suites unless a specific client still requires them and the exception is documented.
## Step 10: Optionally enable PQC after the TLS 1.3 baseline is stable
Do not introduce PQC in the same change window as the initial TLS 1.3 migration. First confirm that the environment is stable with TLS 1.3 and the next-generation cryptographic provider.
After that, enable PQC in a second phase.
Key checks before enabling ML-KEM or hybrid key exchange:
  - Client drivers actually support the required PQC path
  - Thin clients have the necessary runtime support
  - OCI-based clients are validated first
  - Operational teams know how to verify negotiated key exchange behavior
To configure hybrid or ML-KEM-only key exchange, see Configure Key Exchange Groups.
Use hybrid or ML-KEM only after confirming client compatibility. Keep PQC as a separately managed rollout, especially for mixed-client environments.
## Step 11: Optionally enable FIPS 140-3 after confirming compliance requirements
FIPS 140-3 is also a separate phase. Do not enable it just because TLS 1.3 or PQC is available.
First confirm:
  - The deployment actually requires FIPS mode
  - The target release and platform align with the intended FIPS mode
  - The approved algorithms are acceptable for the application
  - The compliance owner accepts the exact FIPS wording and module status
Use the `fips.ora` parameter model:
  - FIPS_140
  - FIPS_140_3
To enable FIPS 140-3:
```
FIPS_140=TRUE
FIPS_140_3=TRUE
```
To remain in non-FIPS mode:
```
FIPS_140=FALSE
```
Treat FIPS testing as its own validation cycle, because algorithm availability, allowed ciphers, and runtime behavior can differ from non-FIPS mode.
## Suggested migration sequence
Use this order:
  - Inventory the current TLS 1.2 deployment.
  - Document all client versions and runtime dependencies.
  - Confirm certificate and cryptographic dependencies.
  - Enable the next-generation cryptographic provider in test.
  - Retain TLS 1.2 and TLS 1.3 initially, as described in Configuring TLS 1.3.
  - Keep cipher and key-exchange settings at default unless policy requires explicit values.
  - Validate all important clients.
  - Remove unnecessary TLS 1.2-era overrides.
  - Require TLS 1.3 only after client validation is complete.
  - Optionally configure hybrid or ML-KEM key exchange in a later phase. See Configuring Post-Quantum Cryptography.
  ````- Optionally enable FIPS_140=TRUE and FIPS_140_3=TRUE in a separate compliance phase.
## Customer decision checklist
Before production cutover, confirm the following:
  - Are any required clients still limited to TLS 1.2?
  - Are any required clients pinned to explicit old cipher lists?
  - Are all server and client certificates using acceptable algorithms and valid trust chains?
  - Are wallet locations correct for server, listener, and client?
  - Are any database features or external integrations still dependent on older cryptographic behavior?
  - Has the next-generation cryptographic provider been tested independently before protocol tightening?
  - Has TLS 1.3 negotiation been verified from each important client family?
  - Are PQC and FIPS being treated as optional later phases rather than bundled into the initial migration?
