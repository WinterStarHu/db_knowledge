# About Configuring TLS for the Oracle Database

The three most common TLS configurations are described in detail in this topic.
The first decision is to use a self-signed certificate root of trust or a public CA root of trust. Once you make that decision, Oracle recommends using TLS without a wallet if your environment supports this and is allowed by your security policies. This greatly simplifies managing database clients. Start your configurations with the minimum set of mandatory parameters. And then once you are successful, add the recommended parameters and any optional parameters one by one.
The following parameters are used in the following configurations in this topic.

| Parameter | Description | Server (Defined in sqlnet.ora) | Listener (Defined in listener.ora) | Static Client (Defined in sqlnet.ora) | Dynamic Client (Defined in the connect string) |
|---|---|---|---|---|---|
| WALLET_ROOT | Database server system parameter (replaces WALLET_LOCATION) | Required | No | No | No |
| WALLET_LOCATION | Specifies wallet location if required | No | Required | Optional | Optional |
| Protocol=tcps | Enables TLS connection | No | Required | No | Required |
| TLS_CLIENT_AUTHENTICATION | Set to FALSE for one-way TLS only, or to OPTIONAL to permit one-way TLS or mTLS | Required | Required | Optional | Optional |
| TLS_SERVER_DN_MATCH | Enables partial or full DN matching | No | No | Recommended | Recommended |
| TLS_SERVER_CERT_DN | Use if full DN matching is required | No | No | No | Optional |

## `WALLET_ROOT` and `WALLET_LOCATION` Parameters
For Oracle Database server, Oracle recommends that you use the `WALLET_ROOT` system parameter instead of using `WALLET_LOCATION`.
The TLS wallet location for a PDB is `WALLET_ROOT//tls`.
`WALLET_LOCATION` must be used by the listener to find its wallet. Oracle recommends using the same wallet as the database server for DN matching. DN matching is used by the client to verify that it is connecting to the expected server, and the client checks the server certificates.
## `Protocol` Parameter
Set `Protocol` to `tcps` for both the client and listener. The listener specifies this in its address configuration, and the client specifies it in the connect string.
## `TLS_CLIENT_AUTHENTICATION` Parameter
`TLS_CLIENT_AUTHENTICATION` must be set to `FALSE` for the database server and listener to allow one-way TLS traffic. This setting is optional for the client and depends on whether the client already has a wallet with a client-side user certificate that is used for other connections.
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both the `TLS_` and `SSL_` versions of a parameter are configured, then the `SSL_` version is ignored.
## DN Matching
Oracle recommends using DN matching. However, add these settings once you have successfully confirmed a TLS connection.
The most common TLS configurations for the Oracle Database are:
- Configuring TLS Using a Public Certificate Authority Root of Trust for the Database Server Certificate
- Configuring TLS with a Self-Signed Root Certificate
- Configuring TLS Connection With a Client Wallet
