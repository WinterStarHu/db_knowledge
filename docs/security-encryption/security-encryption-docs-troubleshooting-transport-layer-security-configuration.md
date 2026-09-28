# Troubleshooting the Transport Layer Security Configuration

Common errors may occur while you use the Oracle Database SSL adapter.
When troubleshooting TLS in Oracle Database 19c, check which cryptographic provider is active. The next-generation cryptographic provider supports TLS 1.2 and TLS 1.3. The legacy provider supports TLS 1.0, TLS 1.1, and TLS 1.2. Provider mismatches can appear as protocol negotiation, cipher suite, key exchange, wallet, or certificate validation failures.
It may be necessary to enable Oracle Net tracing to determine the cause of an error. For information about setting tracing parameters to enable Oracle Net tracing, refer to *Oracle Database Net Services Administrator’s Guide*.
**ORA-28759: Failure to Open File** Cause: The system could not open the specified file. Typically, this error occurs because the wallet cannot be found.
Action: Check the following:
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CLIENT_AUTHENTICATION` and `SSL_CLIENT_AUTHENTICATION` parameters are configured, then the `SSL_CLIENT_AUTHENTICATION` parameter is ignored.
- Ensure that the correct wallet location is specified in the sqlnet.ora file. This should be the same directory location where you saved the wallet.
- Enable Oracle Net tracing to determine the name of the file that cannot be opened and the reason.
**
- Ensure that auto-login was enabled when you saved the wallet. See Oracle Database Enterprise User Security Administrator’s Guide.
**ORA-28786: Decryption of Encrypted Private Key Failure** Cause: An incorrect password was used to decrypt an encrypted private key. Frequently, this happens because an auto-login wallet is not being used.
Action: Use Oracle Wallet Manager to turn the auto-login feature on for the wallet. Then save the wallet again. See *Oracle Database Enterprise User Security Administrator’s Guide* If the auto-login feature is not being used, then enter the correct password.
**ORA-28858: SSL Protocol Error** Cause: This is a generic error that can occur during TLS handshake negotiation between two processes.
Action: Enable Oracle Net tracing and attempt the connection again to produce trace output. Then contact Oracle customer support with the trace output.
**ORA-28859 SSL Negotiation Failure** Cause: An error occurred during the negotiation between two processes as part of the TLS protocol. This error can occur when two sides of the connection do not support a common cipher suite.
Action: Check the following:
- Use Oracle Net Manager to ensure that the TLS versions on both the client and the server match, or are compatible. For example, if the server accepts only TLS 1.3 and the client accepts only TLS 1.1, then the TLS connection will fail. This can occur if the server uses the next-generation provider and the client can use only protocol versions supported by the legacy provider.
- Use Oracle Net Manager to check what cipher suites are configured on the client and the server, and ensure that compatible cipher suites are set on both.
- If TLS 1.3 is configured, verify that the next-generation provider is active and that the TLS_KEY_EXCHANGE_GROUPS setting is compatible on the client and server. If the error still persists, then enable Oracle Net tracing and attempt the connection again. Contact Oracle customer support with the trace output.
**Note:**   If you do not configure any cipher suites, then all available cipher suites are enabled.
**ORA-28862: SSL Connection Failed** Cause: This error occurred because the peer closed the connection.
Action: Check the following:
- Ensure that the correct wallet location is specified in the sqlnet.ora file so the system can find the wallet.
````
- Use Oracle Net Manager to ensure that cipher suites are set correctly in the sqlnet.ora file. Sometimes this error occurs because the sqlnet.ora has been manually edited and the cipher suite names are misspelled. Ensure that case sensitive string matching is used with cipher suite names.
- Use Oracle Net Manager to ensure that the TLS versions on both the client and the server match or are compatible. Sometimes this error occurs because the TLS version specified on the server and client do not match. For example, if the server accepts only TLS 1.3 and the client accepts only TLS 1.0, then the TLS connection will fail.
- For more diagnostic information, enable Oracle Net tracing on the peer.
**ORA-28865: SSL Connection Closed**
Cause: The TLS connection closed because of an error in the underlying transport layer, or because the peer process quit unexpectedly.
Action: Check the following:
- Use Oracle Net Manager to ensure that the TLS versions on both the client and the server match, or are compatible. Sometimes this error occurs because the TLS version specified on the server and client do not match. For example, if the server accepts only TLS 1.3 and the client accepts only TLS 1.0, then the TLS connection will fail.
````````
- If you are using a Diffie-Hellman anonymous cipher suite and the TLS_CLIENT_AUTHENTICATION parameter is set to true in the server’s listener.ora file, then the client does not pass its certificate to the server. When the server does not receive the client’s certificate, it (the server) cannot authenticate the client so the connection is closed. To resolve this use another cipher suite, or set this listener.ora parameter to false.
- Enable Oracle Net tracing and check the trace output for network errors.
- For details, refer to Actions listed for “ORA-28862: SSL Connection Failed”
**ORA-28868: Peer Certificate Chain Check Failed** Cause: When the peer presented the certificate chain, it was checked and that check failed. This failure can be caused by a number of problems, including:
- One of the certificates in the chain has expired.
- A certificate authority for one of the certificates in the chain is not recognized as a trust point.
- The signature in one of the certificates cannot be verified.
- The certificate or certificate chain uses MD5 or SHA-1 signatures while the next-generation provider is active.
Action: See *Oracle Database Enterprise User Security Administrator’s Guide* to use Oracle Wallet Manager to open your wallet and check the following:
- Ensure that all of the certificates installed in your wallet are current (not expired).
**
- Ensure that a certificate authority’s certificate from your peer’s certificate chain is added as a trusted certificate in your wallet. See Oracle Database Enterprise User Security Administrator’s Guide to use Oracle Wallet Manager to import a trusted certificate.
**ORA-28885: No certificate with the required key usage found.** Cause: Your certificate was not created with the appropriate X.509 version 3 key usage extension.
Action: Use Oracle Wallet Manager to check the certificate’s key usage. See *Oracle Database Enterprise User Security Administrator’s Guide* for information about key usage values.
**ORA-29024: Certificate Validation Failure** Cause: The certificate sent by the other side could not be validated. This may occur if the certificate has expired, has been revoked, or is invalid for any other reason.
Action: Check the following:
- Check the certificate to determine whether it is valid. If necessary, get a new certificate, inform the sender that her certificate has failed, or resend.
**
- Check to ensure that the server’s wallet has the appropriate trust points to validate the client’s certificate. If it does not, then use Oracle Wallet Manager to import the appropriate trust point into the wallet. See Oracle Database Enterprise User Security Administrator’s Guide for details about importing a trusted certificate.
- Ensure that the certificate has not been revoked and that certificate revocation list (CRL) checking is turned on. For details, refer to Configuring Certificate Validation with Certificate Revocation Lists
**ORA-29223: Cannot Create Certificate Chain** Cause: A certificate chain cannot be created with the existing trust points for the certificate being installed. Typically, this error is returned when the peer does not give the complete chain and you do not have the appropriate trust points to complete it.
Action: Use Oracle Wallet Manager to install the trust points that are required to complete the chain. See *Oracle Database Enterprise User Security Administrator’s Guide* for details about importing a trusted certificate.
