# Data Encryption and Integrity Parameters

The `sqlnet.ora` file has data encryption and integrity parameters.
- About Using sqlnet.ora for Data Encryption and Integrity You can use the default parameter settings as a guideline for configuring data encryption and integrity.
- Sample sqlnet.ora File The sample sqlnet.ora configuration file is based on a set of clients with similar characteristics and a set of servers with similar characteristics.
- Data Encryption and Integrity Parameters Oracle provides data and integrity parameters that you can set in the sqlnet.ora file.
## About Using sqlnet.ora for Data Encryption and Integrity
You can use the default parameter settings as a guideline for configuring data encryption and integrity.
This `sqlnet.ora` file is generated when you perform the network configuration described in Configuring Oracle Database Native Network Encryption and Data Integrity and Configuring Transport Layer Security Encryption. Also provided are encryption and data integrity parameters.
## Sample sqlnet.ora File
The sample `sqlnet.ora` configuration file is based on a set of clients with similar characteristics and a set of servers with similar characteristics.
The file includes examples of Oracle Database encryption and data integrity parameters.
By default, the `sqlnet.ora` file is located in the *ORACLE_HOME*`/network/admin` directory or in the location set by the `TNS_ADMIN` environment variable. Ensure that you have properly set the `TNS_ADMIN` variable to point to the correct `sqlnet.ora` file. See *SQL*Plus User’s Guide and Reference* for more information and examples of setting the `TNS_ADMIN` variable.
### Trace File Setup
```
#Trace file setup
trace_level_server=16
trace_level_client=16
trace_directory_server=/orant/network/trace
trace_directory_client=/orant/network/trace
trace_file_client=cli
trace_file_server=srv
trace_unique_client=true
```
### Oracle Database Native Network Encryption
```
sqlnet.encryption_server=accepted
sqlnet.encryption_client=requested
sqlnet.encryption_types_server=(RC4_40)
sqlnet.encryption_types_client=(RC4_40)
```
**Note:**   The RC4_40 algorithm is deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
### Oracle Database Network Data Integrity
```
#ASO Checksum
sqlnet.crypto_checksum_server=requested
sqlnet.crypto_checksum_client=requested
sqlnet.crypto_checksum_types_server = (SHA256)
sqlnet.crypto_checksum_types_client = (SHA256)
```
### Transport Layer Security
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CLIENT_AUTHENTICATION` and `SSL_CLIENT_AUTHENTICATION` parameters are configured, then the `SSL_CLIENT_AUTHENTICATION` parameter is ignored.
```
#TLS
WALLET_LOCATION = (SOURCE=
                   (METHOD = FILE)
                      (METHOD_DATA =
                         DIRECTORY=/wallet)
)
TLS_CIPHER_SUITES=(TLS_AES_256_GCM_SHA384)
TLS_VERSION=(1.3)
TLS_CLIENT_AUTHENTICATION=FALSE
```
### Common
```
#Common
automatic_ipc = off
sqlnet.authentication_services = (beq)
names.directory_path = (TNSNAMES)
```
### Kerberos
```
#Kerberos
sqlnet.authentication_services = (beq, kerberos5)
sqlnet.authentication_kerberos5_service = oracle
sqlnet.kerberos5_conf= /krb5/krb.conf
sqlnet.kerberos5_keytab= /krb5/v5srvtab
sqlnet.kerberos5_realms= /krb5/krb.realm
sqlnet.kerberos5_cc_name = /krb5/krb5.cc
sqlnet.kerberos5_clockskew=900
sqlnet.kerberos5_conf_mit=false
```
### RADIUS
```
#Radius
sqlnet.authentication_services = (beq, RADIUS )
sqlnet.radius_authentication_timeout = (10)
sqlnet.radius_authentication_retries = (2)
sqlnet.radius_authentication_port = (1645)
sqlnet.radius_send_accounting = OFF
sqlnet.radius_secret = /orant/network/admin/radius.key
sqlnet.radius_authentication = radius.us.example.com
sqlnet.radius_challenge_response = OFF
sqlnet.radius_challenge_keyword = challenge
sqlnet.radius_challenge_interface =
oracle/net/radius/DefaultRadiusInterface
sqlnet.radius_classpath = /jre1.1/
```
## Data Encryption and Integrity Parameters
Oracle provides data and integrity parameters that you can set in the `sqlnet.ora` file.
- About the Data Encryption and Integrity Parameters The data encryption and integrity parameters control the type of encryption algorithm you are using.
- SQLNET.ENCRYPTION_SERVER The SQLNET.ENCRYPTION_SERVER parameter specifies the encryption behavior when a client or a server acting as a client connects to this server.
- SQLNET.ENCRYPTION_CLIENT The SQLNET.ENCRYPTION_CLIENT parameter specifies the encryption behavior when this client or server acting as a client connects to a server.
- SQLNET.CRYPTO_CHECKSUM_SERVER The SQLNET.CRYPTO_CHECKSUM_SERVER parameter specifies the data integrity behavior when a client or another server acting as a client connects to this server.
- SQLNET.CRYPTO_CHECKSUM_CLIENT The SQLNET.CRYPTO_CHECKSUM_CLIENT parameter specifies the desired data integrity behavior when this client or server acting as a client connects to a server.
- SQLNET.ENCRYPTION_TYPES_SERVER The SQLNET.ENCRYPTION_TYPES_SERVER parameter specifies encryption algorithms this server uses in the order of the intended use.
- SQLNET.ENCRYPTION_TYPES_CLIENT The SQLNET.ENCRYPTION_TYPES_CLIENT parameter specifies encryption algorithms this client or the server acting as a client uses.
- SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER The SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER parameter specifies data integrity algorithms that this server or client to another server uses, in order of intended use.
- SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT The SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT parameter specifies a list of data integrity algorithms that this client or server acting as a client uses.
### About the Data Encryption and Integrity Parameters
The data encryption and integrity parameters control the type of encryption algorithm you are using.
If you do not specify any values for Server Encryption, Client Encryption, Server Checksum, or Client Checksum, the corresponding configuration parameters do not appear in the `sqlnet.ora` file. However, the defaults are `ACCEPTED`.
For both data encryption and integrity algorithms, the server selects the first algorithm listed in its `sqlnet.ora `file that matches an algorithm listed in the client `sqlnet.ora` file, or in the client installed list if the client lists no algorithms in its `sqlnet.ora` file. If there are no entries in the server `sqlnet.ora` file, the server sequentially searches its installed list to match an item on the client side-either in the client `sqlnet.ora `file or in the client installed list. *If no match can be made and one side of the connection REQUIRED the algorithm type (data encryption or integrity), then the connection fails.*Otherwise, the connection succeeds with the algorithm type `inactive`.
Data encryption and integrity algorithms are selected independently of each other. Encryption can be activated without integrity, and integrity can be activated without encryption, as shown in the following table:

| Encryption Selected? | Integrity Selected? |
|---|---|
| Yes | No |
| Yes | Yes |
| No | Yes |
| No | No |

### SQLNET.ENCRYPTION_SERVER
The `SQLNET.ENCRYPTION_SERVER` parameter specifies the encryption behavior when a client or a server acting as a client connects to this server.
The behavior of the server partially depends on the `SQLNET.ENCRYPTION_CLIENT` setting at the other end of the connection.
The following table describes the `SQLNET.ENCRYPTION_SERVER` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.ENCRYPTION_SERVER = valid_value |
| Valid Values | ACCEPTED, REJECTED, REQUESTED, REQUIRED |
| Default Setting | ACCEPTED |

### SQLNET.ENCRYPTION_CLIENT
The `SQLNET.ENCRYPTION_CLIENT` parameter specifies the encryption behavior when this client or server acting as a client connects to a server.
The behavior of the client partially depends on the value set for `SQLNET.ENCRYPTION_SERVER` at the other end of the connection.
The following table describes the `SQLNET.ENCRYPTION_CLIENT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.ENCRYPTION_CLIENT = valid_value |
| Valid Values | ACCEPTED, REJECTED, REQUESTED, REQUIRED |
| Default Setting | ACCEPTED |

### SQLNET.CRYPTO_CHECKSUM_SERVER
The `SQLNET.CRYPTO_CHECKSUM_SERVER` parameter specifies the data integrity behavior when a client or another server acting as a client connects to this server.
The behavior partially depends on the `SQLNET.CRYPTO_CHECKSUM_CLIENT` setting at the other end of the connection.
The following table describes the `SQLNET.CRYPTO_CHECKSUM_SERVER` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.CRYPTO_CHECKSUM_SERVER = valid_value |
| Valid Values | ACCEPTED, REJECTED, REQUESTED, REQUIRED |
| Default Setting | ACCEPTED |

### SQLNET.CRYPTO_CHECKSUM_CLIENT
The `SQLNET.CRYPTO_CHECKSUM_CLIENT` parameter specifies the desired data integrity behavior when this client or server acting as a client connects to a server.
The behavior partially depends on the `SQLNET.CRYPTO_CHECKSUM_SERVER` setting at the other end of the connection.
The following table describes the `SQLNET.CRYPTO_CHECKSUM_CLIENT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.CRYPTO_CHECKSUM_CLIENT = valid_value |
| Valid Values | ACCEPTED, REJECTED, REQUESTED, REQUIRED |
| Default Setting | ACCEPTED |

### SQLNET.ENCRYPTION_TYPES_SERVER
The `SQLNET.ENCRYPTION_TYPES_SERVER` parameter specifies encryption algorithms this server uses in the order of the intended use.
This list is used to negotiate a mutually acceptable algorithm with the client end of the connection. Each algorithm is checked against the list of available client algorithm types until a match is found. If an algorithm that is not installed is specified on this side, the connection terminates with the error message `ORA-12650: No common encryption or data integrity algorithm.` The following table describes the `SQLNET.ENCRYPTION_TYPES_SERVER` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.ENCRYPTION_TYPES_SERVER = (valid_encryption_algorithm [,valid_encryption_algorithm]) |
| Valid Values | AES256: AES (256-bit key size); AES192: AES (192-bit key size); AES128: AES (128-bit key size) |
| Default Setting | If no algorithms are defined in the local sqlnet.ora file, then all installed algorithms are used in a negotiation in the preceding sequence. |
| Usage Notes | You can specify multiple encryption algorithms. It can be either a single value or a list of algorithm names. For example, either SQLNET.ENCRYPTION_TYPES_SERVER=(AES256) or SQLNET.ENCRYPTION_TYPES_SERVER=(AES256,AES192,AES128) is acceptable. |

### SQLNET.ENCRYPTION_TYPES_CLIENT
The `SQLNET.ENCRYPTION_TYPES_CLIENT` parameter specifies encryption algorithms this client or the server acting as a client uses.
This list is used to negotiate a mutually acceptable algorithm with the other end of the connection. If an algorithm that is not installed is specified on this side, the connection terminates with the `ORA-12650: No common encryption or data integrity algorithm error` message.
The following table describes the `SQLNET.ENCRYPTION_TYPES_CLIENT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.ENCRYPTION_TYPES_CLIENT = (valid_encryption_algorithm [,valid_encryption_algorithm]) |
| Valid Values | AES256: AES (256-bit key size); AES192: AES (192-bit key size); AES128: AES (128-bit key size) |
| Default Setting | If no algorithms are defined in the local sqlnet.ora file, all installed algorithms are used in a negotiation. |
| Usage Notes | You can specify multiple encryption algorithms by separating each one with a comma. For example: SQLNET.ENCRYPTION_TYPES_CLIENT=(AES256,AES192,AES128). |

### SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER
The `SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER` parameter specifies data integrity algorithms that this server or client to another server uses, in order of intended use.
This list is used to negotiate a mutually acceptable algorithm with the other end of the connection. Each algorithm is checked against the list of available client algorithm types until a match is found. If an algorithm is specified that is not installed on this side, the connection terminates with the ```ORA-12650: No common encryption or data integrity algorithm error` error message.
The following table describes the `SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER = (valid_crypto_checksum_algorithm [,valid_crypto_checksum_algorithm]) |
| Valid Values | SHA512: SHA-2, produces a 512-bit hash; SHA384: SHA-2, produces a 384-bit hash; SHA256: SHA-2, produces a 256-bit hash and is the default value; SHA1: Secure Hash Algorithm; MD5: Message Digest 5 |
| Default Setting | All available algorithms |

**Note:** MD5 is deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
### SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT
The `SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT` parameter specifies a list of data integrity algorithms that this client or server acting as a client uses.
This list is used to negotiate a mutually acceptable algorithm with the other end of the connection. If an algorithm that is not installed on this side is specified, the connection terminates with the `ORA-12650: No common encryption or data integrity algorithm error` error message.
The following table describes the `SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT = (valid_crypto_checksum_algorithm [,valid_crypto_checksum_algorithm]) |
| Valid Values | SHA512: SHA-2, produces a 512-bit hash; SHA384: SHA-2, produces a 384-bit hash; SHA256: SHA-2, produces a 256-bit hash and is the default value; SHA1: Secure Hash Algorithm; MD5: Message Digest 5 |
| Default Setting | If no algorithms are defined in the local sqlnet.ora file, all installed algorithms are used in a negotiation starting with SHA256. |

**Note:** MD5 is deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
## Related Topics
  - Configuring Oracle Database Native Network Encryption and Data Integrity
  - About Activating Encryption and Integrity
**- Oracle Database Net Services Reference for more information about the SQLNET.ENCRYPTION_SERVER parameter **- Oracle Database Net Services Reference for more information about the SQLNET.ENCRYPTION_CLIENT parameter **- Oracle Database Net Services Reference for more information about the SQLNET.CRYPTO_CHECKSUM_SERVER parameter **- Oracle Database Net Services Reference for more information about the SQLNET.ENCRYPTION_TYPES_SERVER parameter **- Oracle Database Net Services Reference for more information about the SQLNET.ENCRYPTION_TYPES_CLIENT parameter **- Oracle Database Net Services Reference for more information about the SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER parameter **- Oracle Database Net Services Reference for more information about the SQLNET.CRYPTO_CHECKSUM_TYPES_CLIENT parameter
