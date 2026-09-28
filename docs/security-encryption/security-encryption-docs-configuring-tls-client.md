# Configuring TLS for the Oracle Database and Client

This topic describes the three most common TLS configurations. More advanced and optional configurations are described later in this chapter.
- About Configuring TLS for the Oracle Database The three most common TLS configurations are described in detail in this topic.
- Configuring TLS Using a Public Certificate Authority Root of Trust for the Database Server Certificate Before you can configure TLS without using client wallets, you must first create the server wallet and ensure that the database and listener are properly configured.
- Configuring TLS with a Self-Signed Root Certificate Using a self-signed root certificate is very similar to the above use case, except you must create a root wallet and sign the database certificate with the self-signed root certificate.
- Configuring TLS Connection With a Client Wallet A client wallet is sometimes required when configuring TLS with a public or self-signed CA trust certificate.
- Enabling Distinguished Name (DN) Matching DN matching allows a connection to the Oracle Database server when the server certificate name or DN matches what the client expects.
- Configuring Mutual TLS (mTLS) In traditional Transport Layer Security (TLS), only the server authenticates to the client by presenting its certificate. With mutual Transport Layer Security (mTLS), both the server and the client present their certificates so that they are mutually authenticated.
- Configuring Transport Layer Security for Client Authentication and Encryption Using Microsoft Certificate Store To perform this configuration with Microsoft Certificate Store (MCS), you use the orapki command-line tool to generate certificates and manipulate the Oracle wallets.
