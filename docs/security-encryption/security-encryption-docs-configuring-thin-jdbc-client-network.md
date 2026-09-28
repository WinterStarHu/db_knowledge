# Configuring the Thin JDBC Client Network

Oracle Database native network encryption and strong authentication enables thin Java Database Connectivity (JDBC) clients to securely connect to Oracle databases.
- About the Java Implementation Oracle Database provides a Java implementation of native network encryption and strong authentication.
- Java Database Connectivity Support JDBC, an industry-standard Java interface, is a Java standard for connecting to a relational database from a Java program.
- Thin JDBC Features The Thin JDBC driver provides security features such as strong authentication, data encryption, and data integrity checking.
- Implementation Overview On the server side, the negotiation of algorithms and the generation of keys function exactly the same as Oracle Database native encryption.
- Obfuscation of the Java Cryptography Code The obfuscation of the Java cryptography code protects Java classes and methods that contain encryption and decryption capabilities with obfuscation software.
- Configuration Parameters for the Thin JDBC Network Implementation The Thin JDBC network implementation for the client provides parameters to control encryption, integrity, and the authentication service.
## About the Java Implementation
Oracle Database provides a Java implementation of native network encryption and strong authentication.
The Java implementation of Oracle Database native network encryption and strong authentication provides network authentication, encryption and integrity protection for Thin JDBC clients that must communicate with Oracle Databases that have Oracle Database native network encryption and strong authentication configured.
## Java Database Connectivity Support
JDBC, an industry-standard Java interface, is a Java standard for connecting to a relational database from a Java program.
Sun Microsystems defined the JDBC standard and Oracle implements and extends the standard with its own JDBC drivers.
Oracle JDBC drivers are used to create Java Database Connectivity (JDBC) applications to communicate with Oracle databases. Oracle implements two types of JDBC drivers: Thick JDBC drivers built on top of the C-based Oracle Net client, as well as a Thin (Pure Java) JDBC driver to support downloadable applets. Oracle extensions to JDBC include the following features:
- Data access and manipulation
- LOB access and manipulation
- Oracle object type mapping
- Object reference access and manipulation
- Array access and manipulation
- Application performance enhancement
## Thin JDBC Features
The Thin JDBC driver provides security features such as strong authentication, data encryption, and data integrity checking.
Because the Thin JDBC driver is designed to be used with downloadable applets used over the Internet, Oracle designed a 100 percent Java implementation of Oracle Database native network encryption and strong authentication, encryption, and integrity algorithms, for use with thin clients.
Oracle Database provides the following features for Thin JDBC:
- Strong Authentication
- Data encryption
- Data integrity checking
- Secure connections from Thin JDBC clients to the Oracle RDBMS
- Ability for developers to build applets that transmit data over a secure communication channel
- Secure connections from middle tier servers with Java Server Pages (JSP) to the Oracle RDBMS
- Secure connections from the current release of Oracle Database to older versions of Oracle databases
The Oracle JDBC Thin driver supports the Oracle Database SSL implementation and third-party authentication methods such as RADIUS and Kerberos. Thin JDBC support for authentication methods like RADIUS, Kerberos, and SSL were introduced in Oracle Database 11g release 1 (11.1).
The Oracle Database native network encryption and strong authentication Java implementation provides Java versions of the following encryption algorithms:
- AES256: AES 256-bit key
- AES192: AES 192-bit key
****
- AES128: AES 128-bit key Note: In the preceding list of algorithms, CBC refers to the Cipher Block Chaining mode.
Thin JDBC support for the Advanced Encryption Standard (AES) was introduced in Oracle Database 12c Release 1 (
12.1).
In addition, this implementation provides data integrity checking for Thin JDBC using Secure Hash Algorithm (`SHA1`) and Message Digest 5 (`MD5`). Thin JDBC support for `SHA1` was introduced in Oracle Database 11*g* release 1 (11.1).
**Note:**   MD5 is deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
## Implementation Overview
On the server side, the negotiation of algorithms and the generation of keys function exactly the same as Oracle Database native encryption.
This feature enables backward and forward compatibility of clients and servers.
On the client side, the algorithm negotiation and key generation occur in exactly the same manner as OCI clients. The client and server negotiate encryption algorithms, generate random numbers, use Diffie-Hellman to exchange session keys, and use the Oracle Password Protocol, in the same manner as the traditional Oracle Net clients. Thin JDBC contains a complete implementation of an Oracle Net client in pure Java.
## Obfuscation of the Java Cryptography Code
The obfuscation of the Java cryptography code protects Java classes and methods that contain encryption and decryption capabilities with obfuscation software.
Java byte code obfuscator is a process frequently used to protect intellectual property written in the form of Java programs. It mixes up Java symbols found in the code. The process leaves the original program structure intact, letting the program run correctly while changing the names of the classes, methods, and variables in order to hide the intended behavior. Although it is possible to decompile and read non-obfuscated Java code, obfuscated Java code is sufficiently difficult to decompile to satisfy U.S. government export controls.
## Configuration Parameters for the Thin JDBC Network Implementation
The Thin JDBC network implementation for the client provides parameters to control encryption, integrity, and the authentication service.
- About the Thin JDBC Network Implementation Configuration Parameters The JDBC network implementation configuration parameters control network settings such as the level of security used between client and server connections.
- Client Encryption Level Parameter The CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_LEVEL parameter defines the level of security that the client uses to negotiate with the server.
- Client Encryption Selected List Parameter The CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_TYPES parameter defines the encryption algorithm to be used.
- Client Integrity Level Parameter The CONNECTION_PROPERTY_THIN_NET_CHECKSUM_LEVEL parameter defines the level of security to negotiate with the server for data integrity.
- Client Integrity Selected List Parameter The CONNECTION_PROPERTY_THIN_NET_CHECKSUM_TYPES parameter defines the data integrity algorithm to be used.
- Client Authentication Service Parameter The CONNECTION_PROPERTY_THIN_NET_AUTHENTICATION_SERVICES parameter determines the authentication service to be used.
- AnoServices Constants The oracle.net.ano.AnoServices interface includes the names of the encryption, authentication, and checksum algorithms that the JDBC Thin driver supports.
### About the Thin JDBC Network Implementation Configuration Parameters
The JDBC network implementation configuration parameters control network settings such as the level of security used between client and server connections.
A properties class object containing several configuration parameters is passed to the Oracle Database native network encryption and strong authentication interface.
All JDBC connection properties including the ones pertaining to Oracle Database are defined as constants in the `oracle.jdbc.OracleConnection` interface. The following list enumerates some of these connection properties:
### Client Encryption Level Parameter
The `CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_LEVEL` parameter defines the level of security that the client uses to negotiate with the server.
The following table describes the attributes of this parameter.

| Attribute | Description |
|---|---|
| Parameter Type | String |
| Parameter Class | Static |
| Permitted Values | REJECTED; ACCEPTED; REQUESTED; REQUIRED |
| Default Value | ACCEPTED |
| Syntax | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_LEVEL, level);, where prop is an object of the Properties class |
| Example | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_LEVEL,"REQUIRED");, where prop is an object of the Properties class |

### Client Encryption Selected List Parameter
The `CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_TYPES` parameter defines the encryption algorithm to be used.
The following table describes attributes of this parameter.

| Attribute | Description |
|---|---|
| Parameter Type | String |
| Parameter Class | Static |
| Permitted Values | AES256 (AES 256-bit key), AES192 (AES 192-bit key), AES128 (AES 128-bit key), |
| Syntax | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_TYPES, algorithm);, where prop is an object of the Properties class |
| Example | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_TYPES, "( AES256, AES192 )");, where prop is an object of the Properties class |

### Client Integrity Level Parameter
The `CONNECTION_PROPERTY_THIN_NET_CHECKSUM_LEVEL` parameter defines the level of security to negotiate with the server for data integrity.
The following table describes the attributes of this parameter.

| Attribute | Description |
|---|---|
| Parameter Type | String |
| Parameter Class | Static |
| Permitted Values | REJECTED; ACCEPTED; REQUESTED; REQUIRED |
| Default Value | ACCEPTED |
| Syntax | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_CHECKSUM_LEVEL, level);, where prop is an object of the Properties class |
| Example | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_CHECKSUM_LEVEL,"REQUIRED");, where prop is an object of the Properties class |

### Client Integrity Selected List Parameter
The `CONNECTION_PROPERTY_THIN_NET_CHECKSUM_TYPES` parameter defines the data integrity algorithm to be used.
The following table describes this parameter’s attributes.

| Attribute | Description |
|---|---|
| Parameter Type | String |
| Parameter Class | Static |
| Permitted Values | SHA1 |
| Syntax | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_CHECKSUM_TYPES, algorithm);, where prop is an object of the Properties class |
| Example | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_CHECKSUM_TYPES,"( SHA1 )");, where prop is an object of the Properties class |

### Client Authentication Service Parameter
The `CONNECTION_PROPERTY_THIN_NET_AUTHENTICATION_SERVICES` parameter determines the authentication service to be used.
The following table describes this parameter’s attributes.

| Attribute | Description |
|---|---|
| Parameter Type | String |
| Parameter Class | Static |
| Permitted Values | RADIUS, KERBEROS, SSL |
| Syntax | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_AUTHENTICATION_SERVICES, authentication);, where prop is an object of the Properties class |
| Example | prop.setProperty(OracleConnection.CONNECTION_PROPERTY_THIN_NET_AUTHENTICATION_SERVICES,"( RADIUS, KERBEROS, SSL)");, where prop is an object of the Properties class |

### AnoServices Constants
The `oracle.net.ano.AnoServices` interface includes the names of the encryption, authentication, and checksum algorithms that the JDBC Thin driver supports.
The following constants are in the `oracle.net.ano.AnoServices` interface:
```
// ---- SUPPORTED ENCRYPTION ALG -----
public static final String ENCRYPTION_RC4_40 = "RC4_40";
public static final String ENCRYPTION_RC4_56 = "RC4_56";
public static final String ENCRYPTION_RC4_128 = "RC4_128";
public static final String ENCRYPTION_RC4_256 = "RC4_256";
public static final String ENCRYPTION_DES40C = "DES40C";
public static final String ENCRYPTION_DES56C = "DES56C";
public static final String ENCRYPTION_3DES112 = "3DES112";
public static final String ENCRYPTION_3DES168 = "3DES168";
public static final String ENCRYPTION_AES128 = "AES128";
public static final String ENCRYPTION_AES192 = "AES192";
public static final String ENCRYPTION_AES256 = "AES256";
// ---- SUPPORTED INTEGRITY ALG ----
public static final String CHECKSUM_MD5 = "MD5";
public static final String CHECKSUM_SHA1 = "SHA1";
// ---- SUPPORTED AUTHENTICATION ADAPTORS ----
public static final String AUTHENTICATION_RADIUS = "RADIUS";
public static final String AUTHENTICATION_KERBEROS = "KERBEROS";
```
**Note:**   The DES40, 3DES112, 3DES168, MD5, RC4_40, RC4_56, RC4_128, and RC4-256 algorithms are deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
You can use these constants to set the encryption, integrity, and authentication parameters. Example 19-1 illustrates one such scenario.
Example 19-1 Using AnoServices Constants in JDBC Client Code
```
import java.sql.*;
import java.util.Properties;import oracle.jdbc.*;
import oracle.net.ano.AnoServices;
/**
 * JDBC thin driver demo: new security features in 11gR1.
 *
 * This program attempts to connect to the database using the JDBC thin
 * driver and requires the connection to be encrypted with either AES256 or AES192
 * and the data integrity to be verified with SHA1.
 *
 * In order to activate encryption and checksumming in the database you need to
 * modify the sqlnet.ora file. For example:
 *
 * SQLNET.ENCRYPTION_TYPES_SERVER = (AES256,AES192,AES128)
 * SQLNET.ENCRYPTION_SERVER = accepted
 * SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER= (SHA1)
 * SQLNET.CRYPTO_CHECKSUM_SERVER = accepted
 *
 * This output of this program is:
 * Connection created! Encryption algorithm is: AES256, data integrity algorithm
 * is: SHA1
 *
 */
public class DemoAESAndSHA1
{
  static final String USERNAME= "hr";
  static final String PASSWORD= "hr";
  static final String URL =
"jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=somehost.us.example.com)(PORT=5561))"  +"(CONNECT_DATA=(SERVICE_NAME=itydemo.regress.rdbms.dev.us.example.com)))";
  public static final void main(String[] argv)
  {
    DemoAESAndSHA1 demo = new DemoAESAndSHA1();
    try
    {
      demo.run();
    }catch(SQLException ex)
    {
      ex.printStackTrace();
    }
  }
  void run() throws SQLException
  {
    OracleDriver dr = new OracleDriver();
    Properties prop = new Properties();
    // We require the connection to be encrypted with either AES256 or AES192.
    // If the database doesn't accept such a security level, then the connection
    // attempt will fail.
    prop.setProperty(
OracleConnection.CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_LEVEL,AnoServices.ANO_REQUIRED);
    prop.setProperty(
      OracleConnection.CONNECTION_PROPERTY_THIN_NET_ENCRYPTION_TYPES,      "( " + AnoServices.ENCRYPTION_AES256 + "," +AnoServices.ENCRYPTION_AES192 + ")");
    // We also require the use of the SHA1 algorithm for data integrity checking.
    prop.setProperty(
OracleConnection.CONNECTION_PROPERTY_THIN_NET_CHECKSUM_LEVEL,AnoServices.ANO_REQUIRED);
    prop.setProperty(
      OracleConnection.CONNECTION_PROPERTY_THIN_NET_CHECKSUM_TYPES,      "( " + AnoServices.CHECKSUM_SHA1 + " )");
    prop.setProperty("user",DemoAESAndSHA1.USERNAME);
    prop.setProperty("password",DemoAESAndSHA1.PASSWORD);
    OracleConnection oraConn =
 (OracleConnection)dr.connect(DemoAESAndSHA1.URL,prop);
    System.out.println("Connection created! Encryption algorithm is: "+oraConn.getEncryptionAlgorithmName()    +", data integrity algorithm is: "+oraConn.getDataIntegrityAlgorithmName());
    oraConn.close();
  }
}
```
## Related Topics
**- Oracle Database JDBC Developer’s Guide for information about JDBC, including examples **- Oracle Database JDBC Developer’s Guide for details on configuring authentication, encryption, and integrity for thin JDBC clients.
**- Oracle Database JDBC Developer’s Guide for detailed information on configuration parameters and configuration examples
