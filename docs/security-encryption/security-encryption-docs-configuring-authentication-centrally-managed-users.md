# Configuring Authentication for Centrally Managed Users

You can configure password authentication, Kerberos authentication, or public key infrastructure (PKI) authentication.
- Configuring Password Authentication for Centrally Managed Users Configuring password authentication for centrally managed users entails the use of a password filter with Active Directory to generate and store Oracle Database password verifiers on Active Directory.
- Configuring Kerberos Authentication for Centrally Managed Users If you plan to use Kerberos authentication, then you must configure Kerberos in the Oracle database that will be integrated with Microsoft Active Directory.
- Configuring Authentication Using PKI Certificates for Centrally Managed Users If you plan to use PKI certificates for the authentication of centrally managed users, then you must configure Transport Layer Security in the Oracle database that will be integrated with Microsoft Active Directory.
## Configuring Password Authentication for Centrally Managed Users
Configuring password authentication for centrally managed users entails the use of a password filter with Active Directory to generate and store Oracle Database password verifiers on Active Directory.
- About Configuring Password Authentication for Centrally Managed Users To configure password authentication, you must deploy a password filter, extend the Active Directory schema by adding one user attribute, and create groups for generating different versions of password verifiers on Active Directory.
- Configuring Password Authentication for a Centrally Managed User You must perform password authentication configuration on Active Directory servers, and also on Oracle databases if it is required that Active Directory users will log in to Oracle databases with administrative privileges.
- Logging in to an Oracle Database Using Password Authentication For password authentication, centrally managed users have choices of how to log in to the database.
### About Configuring Password Authentication for Centrally Managed Users
To configure password authentication, you must deploy a password filter, extend the Active Directory schema by adding one user attribute, and create groups for generating different versions of password verifiers on Active Directory.
For Active Directory users to log in Oracle database with administrative privileges, you must also set a password file with Oracle database.
For password authentication, because Oracle Database does not pass Active Directory users’ passwords through the `ldapbind` command to authenticate with Active Directory, you must install an Oracle filter and extend the Active Directory schema. The Oracle filter that you install in Active Directory creates Oracle-specific password verifiers when Active Directory users update their passwords. The Oracle filter does not generate all required Oracle password verifiers when it is first installed; the Oracle filter only generates the Oracle password verifier for a user when the user changes his or her Active Directory password.
To maintain backward compatibility (if your site requires it), the Oracle filter can generate password verifiers to work with Oracle Database clients for releases 11g, 12c, and 18c. The Oracle password filter uses Active Directory groups named `ORA_VFR_MD5` (for `WebDAV`), `ORA_VFR_11G` (for release 11g) and `ORA_VFR_12C` (for releases 12c and 18c) to determine which Oracle Database password verifiers to generate. These groups must be created in Active Directory for the Oracle password verifiers to be generated for group member users. These are separate groups that dictate which specific verifiers should be generated for the Active Directory users. For example, if ten directory users need to log in to a newly created Oracle Database release 18c database that only communicated with Oracle Database release 18c and 12c clients, then an Active Directory group `ORA_VFR_12C` will have ten Active Directory users as members. The Oracle filter will only generate `12C` verifiers for these ten Active Directory users when they change passwords with Active Directory (18c verifiers are the same as 12c verifiers). If an Active Directory user no long needs to log in to Oracle databases, in order to clear the Oracle password verifiers generated for the Active Directory user, remove the user from any `ORA_VFR` groups, and reset the password (or require password change) for this user. You can also manually clear the `orclCommonAttribute` attribute for this user. Oracle password verifiers will no longer be generated after the user has been removed from `ORA_VFR` groups.
### Configuring Password Authentication for a Centrally Managed User
You must perform password authentication configuration on Active Directory servers, and also on Oracle databases if it is required that Active Directory users will log in to Oracle databases with administrative privileges.
``````````
````
  - To deploy the opwdintg.exe executable, copy this file to the Active Directory server and then have the Active Directory administrator run the opwdintg.exe utility tool.
  - Log in to Microsoft Active Directory as a user who has privileges to create and manage user groups.
````````
  - Check for the following password verifier user groups: ORA_VFR_MD5, ORA_VFR_11G, and ORA_VFR_12C. If these groups do not exist, then rerun the opwdintg.exe utility tool.
**
    - If either the client or the server only permits Oracle Database release 12c authentication, then add the user to the ORA_VFR_12C group. (Oracle Database release 18c uses the same verifier as Oracle Database release 12c.)
**
    - If both the client and the server only permit authentication lower than Oracle Database release 12c (that is, they have Oracle Database releases 11g, or 12.1.0.1 clients), then add the user to the ORA_VFR_11G group.
````
  - If a user must authenticate through an Oracle Database WebDAV client, then the user must be a member of the ORA_VFR_MD5 group.
This configuration enables fine-grained control over the generation of the Oracle Database password verifiers. Only the required verifiers for the required users are generated. For example, if Microsoft Active Directory user `pfitch` is added to the `ORA_VFR_12C` and `ORA_VFR_11G` groups, then both the `12C` and `11G` verifiers will be generated for `pfitch`. This ensures that when applicable, the most secure and strongest verifier is chosen, while in other cases, the `11G` verifier is chosen for the Oracle Database release 11g clients.
  - As a user with administrative privileges, log in to the host where the database that is to be used for the Microsoft Active Directory connection resides.
  - Go to the $ORACLE_HOME/dbs directory.
  - Run the ORAPWD utility to set the format to 12.2. For example:
```
orapwd FILE='/app/oracle/product/18.1/db_1/dbs/orapwdb181' FORMAT=12.2
```
```
 This setting ensures that you can grant the various administrative privileges such as `SYSOPOER` and `SYSBACKUP` to the global user.
```
  - Log in to the database instance as a user who has the ALTER SYSTEM privilege.
````````
  - Make sure that the LDAP_DIRECTORY_SYSAUTH parameter is set to YES in the spfile or the init.ora file.
````````
  - Set the REMOTE_LOGIN_PASSWORDFILE parameter to EXCLUSIVE in the spfile or the init.ora file.
  - Restart the database instance.
```
SHUTDOWN IMMEDIATE
STARTUP
```
### Logging in to an Oracle Database Using Password Authentication
For password authentication, centrally managed users have choices of how to log in to the database.
To log in to a database that is configured to connect to Active Directory, an Active Directory user can use the following logon user name syntax if he or she is using password authentication:
```
sqlplus /nolog
connect "Windows_domain\Active_Directory_user_name"@tnsname_of_database
Password: password
```
The following connection assumes the Windows domain name is `production`:
```
connect "production\pfitch"@inst1
```
If the Active Directory user is in the same Active Directory domain as the Oracle Service Directory User Account configured in the database wallet, then an Active Directory user can use this user name (`samAccountName`) directly to log on to the database:
```
sqlplus samAccountName@tnsname_of_database
Enter password: password
```
For example:
```
connect pfitch@instl
Enter password: password
```
Alternatively, the user can use their Active Directory Windows user logon name with the DNS domain name.
```
connect "Active_Directory_user_name@Windows_DNS_domain_name"@tnsname_of_database
Password: password
```
For example:
```
connect "pfitch@production.examplecorp.com"@inst1
```
## Configuring Kerberos Authentication for Centrally Managed Users
If you plan to use Kerberos authentication, then you must configure Kerberos in the Oracle database that will be integrated with Microsoft Active Directory.
CMU-Active Directory only supports the Microsoft Active Directory Kerberos server. Other non-Active Directory Kerberos servers are not supported with CMU-Active Directory.
**Note:**  You do not create database users identified externally as an Active Directory user’s Kerberos UPN. Instead, you use global users that are mapped to Active Directory users or groups.
## Configuring Authentication Using PKI Certificates for Centrally Managed Users
If you plan to use PKI certificates for the authentication of centrally managed users, then you must configure Transport Layer Security in the Oracle database that will be integrated with Microsoft Active Directory.
While Kerberos authentication with CMU requires use of the Microsoft Active Directory-Active Directory Kerberos server, PKI authentication can use third-party CA services, not just the one with Microsoft Active Directory-Active Directory.
**Note:**  You use an Active Directory user certificate when you configure Transport Layer Security Authentication. However, you do not create database users identified externally as the DN of the Active Directory user certificate. Instead, you use global users that are mapped to Active Directory users or groups.
## Related Topics
  - Step 2: For Password Authentication, Install the Password Filter and Extend the Microsoft Active Directory Schema
  - Mapping a Directory Group to a Shared Database Global User
  - Exclusively Mapping a Directory User to a Database Global User
  - Enabling Kerberos Authentication
  - Configuring Transport Layer Security Encryption
  - Public Key Infrastructure in an Oracle Environment
