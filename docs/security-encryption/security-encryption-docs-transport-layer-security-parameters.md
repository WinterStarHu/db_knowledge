# Parameters for Clients and Servers Using Transport Layer Security

Oracle provides parameters to control Transport Layer Security authentication.
- Ways to Configure a Parameter for Transport Layer Security There are two ways to configure a parameter for Transport Layer Security (TLS).
- Transport Layer Security Authentication Parameters for Clients and Servers Oracle provides both static and dynamic Transport Layer Security (TLS) authentication parameters.
- Cipher Suite Parameters for Transport Layer Security You can configure cipher suite parameters for Transport Layer Security (TLS).
- Supported Transport Layer Security Cipher Suites Oracle Database supports a large number of cipher suites for Transport Layer Security (TLS).
- Transport Layer Security Version Parameters You can set a range of Transport Layer Security (TLS) parameters to configure the version of TLS to use.
- Transport Layer Security Key Exchange Group Parameters You can configure TLS 1.3 key exchange groups when the next-generation cryptographic provider is active.
- Transport Layer Security Client Authentication Parameters You can configure static and dynamic parameters for Transport Layer Security (TLS) on the client.
````
- Transport Layer Security X.509 Server Match Parameters The TLS_SERVER_DN_MATCH and TLS_SERVER_CERT_DN parameters validate the identity of the server to which a client connects.
- Oracle Wallet Location You must specify wallet location parameters for applications that must access an Oracle wallet for loading the security credentials into the process space.
## Ways to Configure a Parameter for Transport Layer Security
There are two ways to configure a parameter for Transport Layer Security (TLS).
****````````
- Static: The name of the parameter that exists in the sqlnet.ora file. Parameters like TLS_CIPHER_SUITES and TLS_VERSION can also be configured using the listener.ora file.
****
- Dynamic: The name of the parameter used in the security subsection of the Oracle Net address.
## Transport Layer Security Authentication Parameters for Clients and Servers
Oracle provides both static and dynamic Transport Layer Security (TLS) authentication parameters.
The following table describes the static and dynamic parameters for configuring TLS on the server.

| Attribute | Description |
|---|---|
| Parameter Name (static) | SQLNET.AUTHENTICATION_SERVICES |
| Parameter Name (dynamic) | AUTHENTICATION |
| Parameter Type | String LIST |
| Parameter Class | Static |
| Permitted Values | Add TCPS to the list of available authentication services. |
| Default Value | No default value. |
| Description | To control which authentication services a user wants to use. Note: The dynamic version supports only the setting of one type. |
| Existing/New Parameter | Existing |
| Syntax (static) | SQLNET.AUTHENTICATION_SERVICES = (TCPS, selected_method_1, selected_method_2) |
| Example (static) | SQLNET.AUTHENTICATION_SERVICES = (TCPS, radius) |
| Syntax (dynamic) | AUTHENTICATION = string |
| Example (dynamic) | AUTHENTICATION = (TCPS) |

## Cipher Suite Parameters for Transport Layer Security
You can configure cipher suite parameters for Transport Layer Security (TLS).
The following table describes the static and dynamic parameters for configuring cipher suites.

| Attribute | Description |
|---|---|
| Parameter Name (static) | TLS_CIPHER_SUITES |
| Parameter Name (dynamic) | TLS_CIPHER_SUITES |
| Parameter Type | String LIST |
| Parameter Class | Static |
| Permitted Values | Any known TLS cipher suite |
| Default Value | No default |
| Description | Controls the combination of encryption and data integrity used by TLS. |
| Existing/New Parameter | Existing |
| Syntax (static) | TLS_CIPHER_SUITES=(TLS_cipher_suite1[, TLS_cipher_suite2, ...TLS_cipher_suiteN]) |
| Example (static) | TLS_CIPHER_SUITES=(TLS_AES_256_GCM_SHA384) |
| Syntax (dynamic) | TLS_CIPHER_SUITES=(TLS_cipher_suite1[, TLS_cipher_suite2, ...TLS_cipher_suiteN]) |
| Example (dynamic) | TLS_CIPHER_SUITES=(TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) |

**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CIPHER_SUITES` and `SSL_CIPHER_SUITES` parameters are configured, then the `SSL_CIPHER_SUITES` parameter is ignored.
## Supported Transport Layer Security Cipher Suites
Oracle Database supports a large number of cipher suites for Transport Layer Security (TLS).
TLS 1.3 cipher suites are available when the next-generation cryptographic provider is active and TLS 1.3 is enabled. The supported TLS 1.3 cipher suites are as follows:
- TLS_AES_256_GCM_SHA384
- TLS_AES_128_GCM_SHA256
- TLS_AES_128_CCM_SHA256
- TLS_CHACHA20_POLY1305_SHA256
The following TLS 1.2 cipher suites are supported. Oracle recommends using the GCM cipher suites for new deployments.
- TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
- TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
- TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256
- TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
- TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384
- TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
- TLS_RSA_WITH_AES_128_CBC_SHA256
- TLS_RSA_WITH_AES_128_GCM_SHA256
- TLS_RSA_WITH_AES_128_CBC_SHA
- TLS_RSA_WITH_AES_256_CBC_SHA
- TLS_RSA_WITH_AES_256_CBC_SHA256
- TLS_RSA_WITH_AES_256_GCM_SHA384
- TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
- TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
## Transport Layer Security Version Support by Cryptographic Provider
The TLS protocol versions available to Oracle Database 19c depend on the active cryptographic provider.

| TLS Version | Next-Generation Provider | Next-Generation Provider in FIPS 140-3 Mode | Legacy Provider | Legacy Provider in FIPS 140-2 Mode |
|---|---|---|---|---|
| SSLv3 | Not supported | Not supported | Supported but not recommended | Not supported |
| TLS 1.0 | Not supported | Not supported | Supported but not recommended | Not supported |
| TLS 1.1 | Not supported | Not supported | Supported but not recommended | Not supported |
| TLS 1.2 | Supported | Supported | Supported | Supported |
| TLS 1.3 | Supported | Supported | Not supported | Not supported |

Oracle recommends using TLS 1.2 or TLS 1.3 for all new deployments. TLS 1.3 is available only with the next-generation provider.
## Transport Layer Security Version Parameters
You can set a range of Transport Layer Security (TLS) parameters to configure the version of TLS to use.
The table below describes the `TLS_VERSION` static and dynamic parameters for configuring the version of TLS to be used.

| Attribute | Description |
|---|---|
| Parameter Name (static) | TLS_VERSION |
| Parameter Name (dynamic) | TLS_VERSION |
| Parameter Type | string |
| Parameter Class | Static |
| Permitted Values | For the legacy cryptographic provider, valid values are undetermined, 1.0, 1.1, and 1.2. For the next-generation cryptographic provider, valid values are 1.2 and 1.3. You can specify a list separated by “or” such as (1.2 or 1.3). You can append a + to specify the minimum version, such as TLS_VERSION=(1.2+). |
| Default Value | undetermined. Oracle Database negotiates the highest TLS version supported by both the client and server. |
| Description | To force the version of the TLS connection. |
| Existing/New Parameter | New |
| Syntax (static) | TLS_VERSION=version |
| Example (static) | TLS_VERSION=(1.3) |
| Syntax (dynamic) | TLS_VERSION=version |
| Example (dynamic) | TLS_VERSION=(1.2 or 1.3) |

**Note:** The `ADD_SSLv3_IMPLICITLY` initialization parameter has no effect on the `TLS_VERSION` parameter.
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_VERSION` and `SSL_VERSION` parameters are configured, then the `SSL_VERSION` parameter is ignored.
- TLS_DISABLE_VERSION Parameter You can exclude Transport Layer Security (TLS) versions by configuring the TLS_DISABLE_VERSION parameter.
### TLS_DISABLE_VERSION Parameter
You can exclude Transport Layer Security (TLS) versions by configuring the `TLS_DISABLE_VERSION` parameter.

| Attribute | Description |
|---|---|
| Parameter Name (static) | TLS_DISABLE_VERSION |
| Parameter Name (dynamic) | TLS_DISABLE_VERSION |
| Parameter Type | string |
| Parameter Class | Static |
| Permitted Values | Any version that is valid to TLS. Values are as follows: undetermined \| 1.1 \| 1.2 \| 1.3. You can specify a list separated by “or” as the following: (1.2 or 1.3). |
| Default Value | undetermined. No TLS version is excluded by default. |
| Description | To specify which TLS versions should be excluded from use. |
| Existing/New Parameter | New |
| Syntax (static) | TLS_DISABLE_VERSION=version |
| Example (static) | TLS_DISABLE_VERSION=(1.3) |
| Syntax (dynamic) | TLS_DISABLE_VERSION=version |
| Example (dynamic) | TLS_DISABLE_VERSION=(1.2 or 1.3) |

## Transport Layer Security Key Exchange Group Parameters
You can configure the key exchange groups that are available for TLS 1.3 connections when the next-generation cryptographic provider is active.
The `TLS_KEY_EXCHANGE_GROUPS` parameter applies to TLS 1.3 only. For TLS 1.2 connections, the key exchange algorithm is determined by the negotiated cipher suite.

| Attribute | Description |
|---|---|
| Parameter Name (static) | TLS_KEY_EXCHANGE_GROUPS |
| Parameter Name (dynamic) | TLS_KEY_EXCHANGE_GROUPS |
| Parameter Type | String LIST |
| Parameter Class | Static |
| Permitted Values | hybrid, ec, ml-kem, or a comma-separated list of these values. |
| Default Value | hybrid,ec,ml-kem |
| Description | Controls the TLS 1.3 key exchange groups offered by Oracle Database when the next-generation provider is active. |
| Existing/New Parameter | New |
| Syntax (static) | TLS_KEY_EXCHANGE_GROUPS=(group1[, group2, ...groupN]) |
| Example (static) | TLS_KEY_EXCHANGE_GROUPS=(hybrid,ec,ml-kem) |
| Syntax (dynamic) | TLS_KEY_EXCHANGE_GROUPS=(group1[, group2, ...groupN]) |
| Example (dynamic) | TLS_KEY_EXCHANGE_GROUPS=(hybrid,ec) |

The `hybrid` value enables hybrid key exchange groups that combine elliptic curve cryptography with ML-KEM post-quantum key establishment. The `ec` value enables elliptic curve groups. The `ml-kem` value enables ML-KEM key exchange groups.
**Note:** The `SSL_DISABLE_WEAK_EC_CURVES` parameter is deprecated. Use `TLS_KEY_EXCHANGE_GROUPS` to control key exchange groups for TLS 1.3 connections.
## Transport Layer Security Client Authentication Parameters
You can configure static and dynamic parameters for Transport Layer Security (TLS) on the client.
The following table describes the `TLS_CLIENT_AUTHENTICATION` parameters.

| Attribute | Description |
|---|---|
| Parameter Name (static) | TLS_CLIENT_AUTHENTICATION |
| Parameter Name (dynamic) | TLS_CLIENT_AUTHENTICATION |
| Parameter Type | Boolean |
| Parameter Class | Static |
| Permitted Values | TRUE or FALSE |
| Default Value | TRUE |
| Description | To control whether a client, in addition to the server, is authenticated using TLS. |
| Existing/New Parameter | New |
| Syntax (static) | TLS_CLIENT_AUTHENTICATION={TRUE \| FALSE} |
| Example (static) | TLS_CLIENT_AUTHENTICATION=FALSE |
| Syntax (dynamic) | TLS_CLIENT_AUTHENTICATION={TRUE \| FALSE} |
| Example (dynamic) | TLS_CLIENT_AUTHENTICATION=FALSE |

**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CLIENT_AUTHENTICATION` and `SSL_CLIENT_AUTHENTICATION` parameters are configured, then the `SSL_CLIENT_AUTHENTICATION` parameter is ignored.
## Transport Layer Security X.509 Server Match Parameters
The `TLS_SERVER_DN_MATCH` and `TLS_SERVER_CERT_DN` parameters validate the identity of the server to which a client connects.
- TLS_SERVER_DN_MATCH The TLS_SERVER_DN_MATCH parameter forces the server’s distinguished name (DN) to match the name of the service.
- TLS_SERVER_CERT_DN The TLS_SERVER_CERT_DN specifies the distinguished name (DN) of a server.
### TLS_SERVER_DN_MATCH
The `TLS_SERVER_DN_MATCH` parameter forces the server’s distinguished name (DN) to match the name of the service.
The following table describes the `TLS_SERVER_DN_MATCH` parameter.

| Attribute | Description |
|---|---|
| Parameter Name | TLS_SERVER_DN_MATCH |
| Where Stored | sqlnet.ora |
| Purpose | Use this parameter to force the server’s distinguished name (DN) to match its service name. If you force the match verifications, TLS ensures that the certificate is from the server. If you choose not to enforce the match verification, TLS performs the check but permits the connection, regardless of whether there is a match.Not forcing the match lets the server potentially fake its identity. |
| Values | yes\|on\|true. Specify to enforce a match. If the DN matches the service name, the connection succeeds; otherwise, the connection fails. no\|off\|false. Specify to not enforce a match. If the DN does not match the service name, the connection is successful, but an error is logged to the sqlnet.log file. |
| Default | Oracle8i, or later: false. TLS client (always) checks server DN. If it does not match the service name, the connection succeeds but an error is logged to sqlnet.log file. |
| Usage Notes | Additionally configure the tnsnames.ora parameter TLS_SERVER_CERT_DN to enable server DN matching. |

**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_SERVER_DN_MATCH` and `SSL_SERVER_DN_MATCH` parameters are configured, then the `SSL_SERVER_DN_MATCH` parameter is ignored.
### TLS_SERVER_CERT_DN
The `TLS_SERVER_CERT_DN` specifies the distinguished name (DN) of a server.
The following table describes the `TLS_SERVER_CERT_DN` parameter.

| Attribute | Description |
|---|---|
| Parameter Name | TLS_SERVER_CERT_DN |
| Where Stored | tnsnames.ora. It can be stored on the client, for every server it connects to, or it can be stored in the LDAP directory, for every server it connects to, updated centrally. |
| Purpose | This parameter specifies the distinguished name (DN) of the server. The client uses this information to obtain the list of DNs it expects for each of the servers to force the server’s DN to match its service name. |
| Values | Set equal to distinguished name (DN) of the server. |
| Default | N/A |
| Usage Notes | Additionally configure the sqlnet.ora parameter TLS_SERVER_DN_MATCH to enable server DN matching. |
| Example | dbalias=(description=address_list=(address=(protocol=tcps)(host=hostname)(port=portnum)))(connect_data=(sid=Finance))(security=(TLS_SERVER_CERT_DN="CN=Finance,CN=OracleContext,C=US,O=Acme")) |

**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_SERVER_CERT_DN` and `SSL_SERVER_CERT_DN` parameters are configured, then the `SSL_SERVER_CERT_DN` parameter is ignored.
## Oracle Wallet Location
You must specify wallet location parameters for applications that must access an Oracle wallet for loading the security credentials into the process space.
The following table lists the configuration files in which you must specify the wallet locations.
- sqlnet.ora
- listener.ora

| Static Configuration | Dynamic Configuration |
|---|---|
| WALLET_LOCATION = (SOURCE= (METHOD=File) (METHOD_DATA= (DIRECTORY=your_wallet_dir) )) | MY_WALLET_DIRECTORY = your_wallet_dir |

The default wallet location is the `ORACLE_HOME` directory.
## Related Topics
  - TLS Cipher Suite Authentication, Encryption, Integrity, and TLS Versions
