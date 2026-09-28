# Network Authentication of Users

You can authenticate users over a network by using Transport Layer Security with third-party services.
- Authentication with Transport Layer Security The Transport Layer Security (TLS) protocol is an application layer protocol.
- Authentication with Third-Party Services The third-party services Kerberos, RADIUS, directory-based services, and public key infrastructure can authenticate Oracle Database over a network.
## Authentication with Transport Layer Security
The Transport Layer Security (TLS) protocol is an application layer protocol.
You can use TLS for user authentication to a database, and it is independent of global user management in Oracle Internet Directory. That is, users can use TLS to authenticate to the database without a directory server in place.
## Authentication with Third-Party Services
The third-party services Kerberos, RADIUS, directory-based services, and public key infrastructure can authenticate Oracle Database over a network.
- About Authentication Using Third-Party Services You must use third-party network authentication services if you want to authenticate Oracle Database users over a network.
- Authentication with Kerberos Kerberos is a trusted third-party authentication system that relies on shared secrets.
- Authentication with RADIUS Remote Authentication Dial-In User Service (RADIUS) is a standard lightweight protocol used for user authentication, authorization, and accounting.
- Authentication with Directory-Based Services Using a central directory can make authentication and its administration efficient.
- Authentication with Public Key Infrastructure Authentication systems based on public key infrastructure (PKI) issue digital certificates to user clients.
### About Authentication Using Third-Party Services
You must use third-party network authentication services if you want to authenticate Oracle Database users over a network.
Prominent examples include Kerberos, PKI (public key infrastructure), the RADIUS (Remote Authentication Dial-In User Service), and directory-based services.
If network authentication services are available to you, then Oracle Database can accept authentication from the network service. If you use a network authentication service, then some special considerations arise for network roles and database links.
### Authentication with Kerberos
Kerberos is a trusted third-party authentication system that relies on shared secrets.
Kerberos presumes that the third party is secure, and provides single sign-on capabilities, centralized password storage, database link authentication, and enhanced PC security. It does this through a Kerberos authentication server, or through Cybersafe Active Trust, a commercial Kerberos-based authentication server.
### Authentication with RADIUS
Remote Authentication Dial-In User Service (RADIUS) is a standard lightweight protocol used for user authentication, authorization, and accounting.
RADIUS also enables users to use the RSA One-Time Password Specifications (OTPS) to authenticate to the Oracle database.
### Authentication with Directory-Based Services
Using a central directory can make authentication and its administration efficient.
Directory-based services include the following:
****
- Oracle Internet Directory, which uses the Lightweight Directory Access Protocol (LDAP), uses a central repository to store and manage information about users (called enterprise users) whose accounts were created in a distributed environment. Although database users must be created (with passwords) in each database that they need to access, enterprise user information is accessible centrally in the Oracle Internet Directory. You can also integrate this directory with Microsoft Active Directory and SunOne.
****
- Oracle Enterprise Security Manager lets you store and retrieve roles from Oracle Internet Directory, which provides centralized privilege management to make administration easier and increase security levels.
### Authentication with Public Key Infrastructure
Authentication systems based on public key infrastructure (PKI) issue digital certificates to user clients.
These clients can use these certificates to authenticate directly to servers in the enterprise without directly involving an authentication. Oracle Database provides a PKI for using public keys and certificates, consisting of the following components:
****
- Authentication and secure session key management using SSL. See Authentication with Transport Layer Security for more information.
****
- Trusted certificates. These are used to identify third-party entities that are trusted as signers of user certificates when an identity is being validated. When the user certificate is being validated, the signer is checked by using trust points or a trusted certificate chain of certificate authorities stored in the validating system. If there are several levels of trusted certificates in this chain, then a trusted certificate at a lower level is simply trusted without needing to have all its higher-level certificates reverified.
******
  - Generates a public-private key pair and creates a certificate request for submission to a certificate authority, and creates wallets
  - Installs a certificate for the entity
  - Manages X.509 version 3 certificates on Oracle Database clients and servers
  - Configures trusted certificates for the entity
  - Opens a wallet to enable access to PKI-based services
****
- X.509 version 3 certificates obtained from (and signed by) a trusted entity, a certificate authority. Because the certificate authority is trusted, these certificates verify that the requesting entity’s information is correct and that the public key on the certificate belongs to the identified entity. The certificate is loaded into an Oracle wallet to enable future authentication.
## Related Topics
  - Configuring Transport Layer Security Encryption
  - Configuring Kerberos Authentication
  - Configuring RADIUS Authentication for information about configuring RADIUS
  - RSA documentation about OTPS
