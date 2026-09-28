# Guidelines for Securing the Network

Security for network communications is improved by using client, listener, and network guidelines to ensure thorough protection.
- Client Connection Security Authenticating clients stringently, configuring encryption for the connection, and using strong authentication strengthens client connections.
- Network Connection Security Protecting the network and its traffic from inappropriate access or modification is the essence of network security.
- Transport Layer Security Connection Security Oracle provides guidelines for securing Transport Layer Security (TLS).
## Client Connection Security
Authenticating clients stringently, configuring encryption for the connection, and using strong authentication strengthens client connections.
Because authenticating client computers is problematic, typically, user authentication is performed instead. This approach avoids client system issues that include falsified IP addresses, hacked operating systems or applications, and falsified or stolen client system identities.
Nevertheless, the following guidelines improve the security of client connections:
****
````
````**
````
**
- Enforce access controls effectively and authenticate clients stringently. By default, Oracle allows operating system-authenticated logins only over secure connections, which precludes using Oracle Net and a shared server configuration. This default restriction prevents a user over a network connection. Setting the initialization parameter REMOTE_OS_AUTHENT to TRUE forces the database to accept the client operating system user name received over an unsecure connection and use it for account access. Because clients, such as PCs, are not trusted to perform operating system authentication properly, it is poor security practice to use this feature. The default setting, REMOTE_OS_AUTHENT = FALSE, creates a more secure configuration that enforces proper, server-based authentication of clients connecting to an Oracle database. Be aware that the REMOTE_OS_AUTHENT was deprecated in Oracle Database Release 11g (11.1) and is retained only for backward compatibility. You should not alter the default setting of the REMOTE_OS_AUTHENT initialization parameter, which is FALSE. Setting this parameter to FALSE does not mean that users cannot connect remotely. It means that the database will not trust that the client has already authenticated, and will therefore apply its standard authentication processes. Be aware that the REMOTE_OS_AUTHENT parameter was deprecated in Oracle Database 11g Release 1 (11.1), and is retained only for backward compatibility.
****
- Configure the connection to use encryption. Oracle native network encryption makes eavesdropping difficult.
****
- Set up strong authentication. See Configuring Kerberos Authentication, for more information about using Kerberos and public key infrastructure (PKI).
  - LOCAL (default) enforces the existing behavior, which maintains a local copy of user account information in the standby database’s in-memory view. This setting only tracks login failures locally on a per-database basis. It denies the login when the maximum of failed logins is reached.
  - GLOBAL increases the security of logins by maintaining a single global copy of user account information across all Data Guard primary and standby databases. Login failures across all databases in the Data Guard environment count toward the maximum count. When this count is reached, then logins anywhere are denied access.
To learn more about the `ADG_ACCOUNT_INFO_TRACKING` parameter, see *Oracle Database Reference*
## Network Connection Security
Protecting the network and its traffic from inappropriate access or modification is the essence of network security.
You should consider all paths the data travels, and assess the threats on each path and node. Then, take steps to lessen or eliminate those threats and the consequences of a security breach. In addition, monitor and audit to detect either increased threat levels or penetration attempts.
To manage network connections, you can use Oracle Net Manager. For more information about Net Manager, see *Oracle Database Net Services Administrator’s Guide*.
The following practices improve network security:
****
- Use Transport Layer Security (TLS) when administering the listener. TLS can protect the messages sent and received by you or by applications and servers, supporting secure authentication, authorization, and messaging through certificates and, if necessary, encryption.
****
  - Add or alter this line in the listener.ora file:
```
ADMIN_RESTRICTIONS_LISTENER=ON
```
  - Use RELOAD to reload the configuration.
  - Use TLS when administering the listener by making the TCPS protocol the first entry in the address list, as follows:
```
LISTENER= (DESCRIPTION= (ADDRESS_LIST= (ADDRESS= (PROTOCOL=tcps) (HOST = sales.us.example.com) (PORT = 8281)))
```
```
To administer the listener remotely, you define the listener in the `listener.ora` file on the client computer. For example, to access listener USER281 remotely, use the following configuration:
```
```
user281 = (DESCRIPTION = (ADDRESS = (PROTOCOL = tcps) (HOST = sales.us.example.com) (PORT = 8281)) ) )
```
****
- Do not set the listener password. Ensure that the password has not been set in the listener.ora file. The local operating system authentication will secure the listener administration. The remote listener administration is disabled when the password has not been set. This prevents brute force attacks of the listener password. The listener password has been deprecated in this release. It will not be supported in the next release of Oracle Database.
****
- When a host computer has multiple IP addresses associated with multiple network interface controller (NIC) cards, configure the listener to the specific IP address. This allows the listener to listen on all the IP addresses. You can restrict the listener to listen on a specific IP address. Oracle recommends that you specify the specific IP addresses on these types of computers, rather than allowing the listener to listen on all IP addresses. Restricting the listener to specific IP addresses helps to prevent an intruder from stealing a TCP end point from under the listener process.
****
**
- Restrict the privileges of the listener, so that it cannot read or write files in the database or the Oracle server address space. This restriction prevents external procedure agents spawned by the listener (or procedures executed by an agent) from inheriting the ability to perform read or write operations. The owner of this separate listener process should not be the owner that installed Oracle Database or executes the Oracle Database instance (such as ORACLE, the default owner). For more information about configuring external procedures in the listener, see Oracle Database Net Services Administrator’s Guide.
****
- Use encryption to secure the data in flight. Strong authentication will help to protect network data encryption.
****
  - Keep the database server behind a firewall. Oracle Database network infrastructure, Oracle Net Services (formerly known as SQL*Net), provides support for a variety of firewalls from various vendors. Supported proxy-enabled firewalls include Gauntlet from Network Associates and Raptor from Axent. Supported packet-filtering firewalls include PIX Firewall from Cisco, and supported stateful inspection firewalls (more sophisticated packet-filtered firewalls) include Firewall-1 from CheckPoint.
  - Ensure that the firewall is placed outside the network to be protected.
  - Configure the firewall to accept only those protocols, applications, or client/server sources that you know are safe.
  - Use a product such as Net8 and Oracle Connection Manager to manage multiplex multiple client network sessions through a single network connection to the database. It can filter on source, destination, and host name. This product enables you to ensure that connections are accepted only from physically secure terminals or from application Web servers with known IP addresses. (Filtering on IP address alone is not enough for authentication, because it can be falsified.)
****
**
- Prevent unauthorized administration of the Oracle listener. For more information about the listener, see Oracle Database Net Services Administrator’s Guide.
****
**
- Check network IP addresses. Use the Oracle Net valid node checking security feature to allow or deny access to Oracle server processes from network clients with specified IP addresses. To use this feature, set the following sqlnet.ora configuration file parameters:
```
tcp.validnode_checking = YES tcp.excluded_nodes = {list of IP addresses} tcp.invited_nodes = {list of IP addresses}
```
```
The `tcp.validnode_checking` parameter enables the feature. The `tcp.excluded_nodes` and `tcp.invited_nodes` parameters deny and enable specific client IP addresses from making connections to the Oracle listener. This helps to prevent potential Denial of Service attacks.
```
****
- Encrypt network traffic. If possible, use Oracle native network data encryption to encrypt network traffic among clients, databases, and application servers.
****
- Secure the host operating system (the system on which Oracle Database is installed). Secure the host operating system by disabling all unnecessary operating system services. Both UNIX and Windows provide a variety of operating system services, most of which are not necessary for typical deployments. These services include FTP, TFTP, TELNET, and so forth. Be sure to close both the UDP and TCP ports for each service that is being disabled. Disabling one type of port and not the other does not make the operating system more secure.
****
  - ALL (default) enables all net protocols to be used for the database links.
````````
  - comma-separated_list_of_protocols can be set TPC, TCPS, or IPC. For example, for a single protocol:
```
ALTER SYSTEM SET OUTBOUND_DBLINK_PROTOCOLS=TCPS;
```
```
  For multiple protocols:
```
```
ALTER SYSTEM SET OUTBOUND_DBLINK_PROTOCOLS=TCP,TCPS,IPC;
```
```
- `NONE` disables any database link communication.
```
****
  - ON enables LDAP lookup for global database links.
  - OFF (default) disables LDAP lookup for global database links.
## Transport Layer Security Connection Security
Oracle provides guidelines for securing Transport Layer Security (TLS).
Transport Layer Security (TLS) is the Internet standard protocol for secure communication, providing mechanisms for data integrity and data encryption. These mechanisms can protect the messages sent and received by you or by applications and servers, supporting secure authentication, authorization, and messaging through certificates and, if necessary, encryption. Good security practices maximize protection and minimize gaps or disclosures that threaten security.
****
- Ensure that configuration files (for example, for clients and listeners) use the correct port for TLS, which is the port configured upon installation. You can run HTTPS on any port, but the standards specify port 443, where any HTTPS-compliant browser looks by default. The port can also be specified in the URL, for example:
```
https://secure.example.com:4445/
```
```
If a firewall is in use, then it too must use the same ports for secure (TLS) communication.
```
****
````
- Ensure that TCPS is specified as the PROTOCOL in the ADDRESS parameter in the tnsnames.ora file (typically on the client or in the LDAP directory). An identical specification must appear in the listener.ora file (typically in the $ORACLE_HOME/network/admin directory).
****
- Ensure that the TLS mode is consistent for both ends of every communication. For example, the database (on one side) and the user or application (on the other) must have the same TLS mode. The mode can specify either client or server authentication (one-way), both client and server authentication (two-way), or no authentication.
****
- Ensure that the server supports the client cipher suites and the certificate key algorithm in use.
****
****``````````
- Enable DN matching for both the server and client, to prevent the server from falsifying its identity to the client during connections. This setting ensures that the server identity is correct by matching its global database name against the DN from the server certificate. You can enable DN matching in the tnsnames.ora file. For example: Note: To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with SSL_ in favor of parameters prefixed with TLS_. During this deprecation period, if both the TLS_ and SSL_ versions of a parameter are configured, then the SSL_ version is ignored.
```
set:TLS_SERVER_CERT_DN="cn=finance,cn=OracleContext,c=us,o=example"
```
```
Otherwise, a client application would not check the server certificate, which could allow the server to falsify its identity.
```
  ****- Do not remove the encryption from your RSA private key inside your server.key file, which requires that you enter your pass phrase to read and parse this file.
**Note:**   A server without TLS does not require a pass phrase.
```
If you decide your server is secure enough, you could remove the encryption from the RSA private key while preserving the original file. This enables system boot scripts to start the database server, because no pass phrase is needed. Ideally, restrict permissions to the root user only, and have the Web server start as `root`, but then log on as another user. Otherwise, anyone who gets this key can impersonate you on the Internet, or decrypt the data that was sent to the server.
```
## Related Topics
  **- Oracle Database Net Services Administrator’s Guide
  - Configuring Transport Layer Security Encryption
  **- Oracle Database Net Services Administrator’s Guide
  - Introduction to Strong Authentication
  **- Oracle Database Net Services Administrator’s Guide
  - Configuring Oracle Database Native Network Encryption and Data Integrity
  **- Oracle Database Net Services Reference
