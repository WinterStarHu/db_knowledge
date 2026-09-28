# Introduction to Oracle Database Security

Oracle Database provides a rich set of default security features to manage user accounts, authentication, privileges, application security, encryption, network traffic, and auditing.
- About Oracle Database Security Use Oracle Database’s security features to reduce risk and protect data from theft, destruction, or misuse.
- Additional Oracle Database Security Products In addition to the security resources that are available in a default database installation, Oracle Database provides several other database security products.
## About Oracle Database Security
Use Oracle Database’s security features to reduce risk and protect data from theft, destruction, or misuse.
A few popular areas to focus security efforts on include:
****
- User accounts. When you create user accounts, you can secure them in a variety of ways. You can also create password profiles to better secure password policies for your site.Managing Security for Oracle Database Users, describes how to manage user accounts.
****
- Authentication methods. Oracle Database provides several ways to configure authentication for users and database administrators. For example, you can authenticate users on the database level, from the operating system, and on the network.Configuring Authentication, describes how authentication in Oracle Database works. See also Configuring Centrally Managed Users with Microsoft Active Directory.
****
  - Configuring Privilege and Role Authorization
  - Performing Privilege Analysis to Identify Privilege Use
  - Managing Security for Definer’s Rights and Invoker’s Rights
  - Managing Fine-Grained Access in PL/SQL Packages and Types
  - Managing Security for a Multitenant Environment in Enterprise Manager
****
- Application security. The first step to creating a database application is to ensure that it is properly secure.Managing Security for Application Developers, discusses how to incorporate application security into your application security policies.
****
- User session information using application context. An application context is a name-value pair that holds the session information. You can retrieve session information about a user, such as the user name or terminal, and restrict database and application access for that user based on this information.Using Application Contexts to Retrieve User Information, describes how to use application contexts.
****
- Database access on the row and column level using Virtual Private Database. A Virtual Private Database policy dynamically imbeds a WHERE predicate into SQL statements the user issues.Using Oracle Virtual Private Database to Control Data Access, describes how to create and manage Virtual Private Database policies.
****
- Classify and protect data in different categories. You can find all table columns in a database that hold sensitive data (such as credit card or Social Security numbers), classify this data, and then create a policy that protects this data as a whole for a given class.Using Transparent Sensitive Data Protection, explains how to create Transparent Sensitive Data Protection policies.
****
- Network data encryption. Manually Encrypting Data, explains how to use the DBMS_CRYPTO PL/SQL package to encrypt data as it travels on the network to prevent unauthorized access to that data. You can configure native Oracle Net Services data encryption and integrity for both servers and clients, which are described in Configuring Oracle Database Native Network Encryption and Data Integrity.
****
- Thin JDBC client network configuration. You can configure thin Java Database Connectivity (JDBC) clients to securely connect to Oracle databases.Configuring the Thin JDBC Client Network, provides detailed information.
****
  - Centralized authentication and single sign-on.
  - Kerberos
  - Remote Authentication Dial-in User Service (RADIUS)
  - Transport Layer Security (TLS) (formerly called Secure Sockets Layer)
The following chapters cover strong authentication:
  - Introduction to Strong Authentication
  - Strong Authentication Administration Tools
  - Configuring Kerberos Authentication
  - Configuring Transport Layer Security Encryption
  - Configuring RADIUS Authentication
  - Customizing the Use of Strong Authentication
****
  - Introduction to Auditing
  - Configuring Audit Policies
  - Administering the Audit Trail
In addition, Keeping Your Oracle Database Secure, provides guidelines that you should follow when you secure your Oracle Database installation.
## Additional Oracle Database Security Products
In addition to the security resources that are available in a default database installation, Oracle Database provides several other database security products.
These products are as follows:
****
- Oracle Advanced Security enables you to protect sensitive data by using Transparent Data Encryption and Oracle Data Redaction.
****
- Oracle Label Security applies classification labels to data, allowing you to filter user access to data at the row level.
****
- Oracle Database Vault provides fine-grained access control to your sensitive data, including protecting data from privileged users. For example, you can restrict database administrators from having access to employee information such as salaries.
****
- Oracle Data Safe enables you to analyze the sensitivity and risks of data in your Oracle databases, and based on these findings, create policies that mask sensitive data, create and monitor security controls, assess user security, and monitor user activity.
****
- Oracle Enterprise User Security enables you to manage user security at the enterprise level.
****
- Oracle Enterprise Manager Data Masking and Subsetting Pack can irreversibly replace the original sensitive data with fictitious data so that production data can be shared safely with IT developers or offshore business partners.
****
- Oracle Audit Vault and Database Firewall collects database audit data from sources such as Oracle Database audit trail tables, database operating system audit files, and database redo logs. Using Oracle Audit Vault and Database Firewall, you can create alerts on suspicious activities, and create reports on the history of privileged user changes, schema modifications, and even data-level access.
****
- Oracle Key Vault enables you to accelerate security and encryption deployments by centrally managing encryption keys, Oracle wallets, Java keystores, and credential files. It is optimized for Oracle wallets, Java keystores, and Oracle Advanced Security Transparent Data Encryption (TDE) master keys. Oracle Key Vault supports the OASIS KMIP standard. The full-stack, security-hardened software appliance uses Oracle Linux and Oracle Database technology for security, availability, and scalability, and can be deployed on your choice of compatible hardware.
In addition to these products, you can find the latest information about Oracle Database security, such as new products and important information about security patches and alerts, by visiting the Security Technology Center on Oracle Technology Network at `http://www.oracle.com/technetwork/topics/security/whatsnew/index.html`
