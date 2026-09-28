# Authentication of Database Administrators

You can authenticate database administrators by using strong authentication, from the operating system, or from the database using passwords.
- About Authentication of Database Administrators Database administrators perform special administrative operations, such as shutting down or starting databases.
- Strong Authentication, Centralized Management for Administrators Strong authentication methods for centrally managed databases include directory authentication, Kerberos authentication, and SSL authentication.
- Authentication of Database Administrators by Using the Operating System For both Windows and UNIX systems, you use DBA-privileged groups to authenticate for the operating system.
- Authentication of Database Administrators by Using Their Passwords Password files are used to authenticate database administrators.
- Risks of Using Password Files for Database Administrator Authentication Be aware that using password files may pose security risks.
## About Authentication of Database Administrators
Database administrators perform special administrative operations, such as shutting down or starting databases.
Oracle Database provides methods to secure the authentication of database administrators who have the `SYSDBA`, `SYSOPER`, `SYSBACKUP`, `SYSDG`, or `SYSKM` administrative privilege.
## Strong Authentication, Centralized Management for Administrators
Strong authentication methods for centrally managed databases include directory authentication, Kerberos authentication, and SSL authentication.
````
- About Strong Authentication for Database Administrators Strong authentication lets you centrally control SYSDBA and SYSOPER access to multiple databases.
- Configuring Directory Authentication for Administrative Users Oracle Internet Directory configures directory authentication for administrative users.
- Configuring Kerberos Authentication for Administrative Users Oracle Internet Directory can be used to configure Kerberos authentication for administrative users.
- Configuring User Authentication with Transport Layer Security Both the client and server side can authenticate administrative users with Transport Layer Security (TLS).
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CLIENT_AUTHENTICATION` and `SSL_CLIENT_AUTHENTICATION` parameters are configured, then the `SSL_CLIENT_AUTHENTICATION` parameter is ignored.
### About Strong Authentication for Database Administrators
Strong authentication lets you centrally control `SYSDBA` and `SYSOPER` access to multiple databases.
Consider using this type of authentication for database administration for the following situations:
- You have concerns about password file vulnerability.
- Your site has very strict security requirements.
- You want to separate the identity management from your database. By using a directory server such as Oracle Internet Directory (OID), for example, you can maintain, secure, and administer that server separately.
To enable the Oracle Internet Directory server to authorize `SYSDBA` and `SYSOPER` connections, use one of the following methods described in this section, depending on your environment.
### Configuring Directory Authentication for Administrative Users
Oracle Internet Directory configures directory authentication for administrative users.
- Configure the administrative user by using the same procedures you would use to configure a typical user.
````
````
- In Oracle Internet Directory, grant the SYSDBA or SYSOPER administrative privilege to the user for the database that this user will administer. Grant SYSDBA or SYSOPER only to trusted users.
````
- Set the LDAP_DIRECTORY_SYSAUTH initialization parameter to YES:
```
ALTER SYSTEM SET LDAP_DIRECTORY_SYSAUTH = YES;
```
```
When set to `YES`, the `LDAP_DIRECTORY_SYSAUTH` parameter enables `SYSDBA` and `SYSOPER` users to authenticate to the database by using a strong authentication method.
```
  ``````- Set the LDAP_DIRECTORY_ACCESS parameter to either PASSWORD or SSL. For example:
```
ALTER SYSTEM SET LDAP_DIRECTORY_ACCESS = PASSWORD;
```
```
Ensure that the `LDAP_DIRECTORY_ACCESS` initialization parameter is not set to `NONE`. Setting this parameter to `PASSWORD` or `SSL` ensures that users can be authenticated using the `SYSDBA` or `SYSOPER` administrative privileges through Oracle Internet Directory.
In an Oracle Real Application Clusters (Oracle RAC) environment, ensure that all instances have the same `LDAP_DIRECTORY_ACCESS` setting, either through the `ALTER SYSTEM` statement or through the `init.ora` file.
In an Oracle Data Guard or Active Data Guard environment, ensure that the standby database has the same `LDAP_DIRECTORY_ACCESS` setting as the primary database. In this environment, the `ALTER SYSTEM` statement propagates its settings from the primary database to the standby database. If you choose to update the `init.ora` file, remember that the `init.ora` parameters are used by both the primary database and the standby database, so you do not need to manually propagate this setting from one database to the other.
```
Afterward, this user can log in by including the net service name in the `CONNECT` statement in SQL*Plus. For example, to log on as `SYSDBA` if the net service name is `orcl`:
```
CONNECT someuser@orcl AS SYSDBA Enter password: password
```
If the database is configured to use a password file for remote authentication, Oracle Database checks the password file first.
### Configuring Kerberos Authentication for Administrative Users
Oracle Internet Directory can be used to configure Kerberos authentication for administrative users.
- Configure the administrative user by using the same procedures you would use to configure a typical user. See Configuring Kerberos Authentication, for more information.
**
- Configure Oracle Internet Directory for Kerberos authentication. See Oracle Database Enterprise User Security Administrator’s Guide for more information.
````
````
- In Oracle Internet Directory, grant the SYSDBA or SYSOPER administrative privilege to the user for the database that this user will administer. Grant SYSDBA or SYSOPER only to trusted users. See Guidelines for Securing User Accounts and Privileges for advice on this topic.
````
- Set the LDAP_DIRECTORY_SYSAUTH initialization parameter to YES:
```
ALTER SYSTEM SET LDAP_DIRECTORY_SYSAUTH = YES;
```
```
When set to `YES`, the `LDAP_DIRECTORY_SYSAUTH` parameter enables `SYSDBA` and `SYSOPER` users to authenticate to the database by using strong authentication methods. See [*Oracle Database Reference*](unilink:REFRN10281) for more information about `LDAP_DIRECTORY_SYSAUTH`.
```
  ``````- Set the LDAP_DIRECTORY_ACCESS parameter to either PASSWORD or SSL. For example:
```
ALTER SYSTEM SET LDAP_DIRECTORY_ACCESS = SSL;
```
```
Ensure that the `LDAP_DIRECTORY_ACCESS` initialization parameter is not set to `NONE`. Setting this parameter to `PASSWORD` or `SSL` ensures that users can be authenticated using `SYSDBA` or `SYSOPER` through Oracle Internet Directory. See [*Oracle Database Reference*](unilink:REFRN10251) for more information about `LDAP_DIRECTORY_ACCESS`.
In an Oracle Real Application Clusters (Oracle RAC) environment, ensure that all instances have the same `LDAP_DIRECTORY_ACCESS` setting, either through the `ALTER SYSTEM` statement or through the `init.ora` file.
In an Oracle Data Guard or Active Data Guard environment, ensure that the standby database has the same `LDAP_DIRECTORY_ACCESS` setting as the primary database. In this environment, the `ALTER SYSTEM` statement propagates its settings from the primary database to the standby database. If you choose to update the `init.ora` file, remember that the `init.ora` parameters are used by both the primary database and the standby database, so you do not need to manually propagate this setting from one database to the other.
```
Afterward, this user can log in by including the net service name in the `CONNECT` statement in SQL*Plus. For example, to log on as `SYSDBA` if the net service name is `orcl`:
```
CONNECT /@orcl AS SYSDBA
```
### Configuring User Authentication with Transport Layer Security
Both the client and server side can authenticate administrative users with Transport Layer Security (TLS).
- For both the client and the server, get user certificates signed by the same root Certificate Authority (CA) certificate, either public or self-signed.
  - Add the signed user certificate to the client wallet. The CA root trust certificate should already be in the client wallet. Ensure that any intermediate certificates that are required for the user certificate are added to the wallet before you add the user certificate. You can use orapki to configure the client wallet and user certificate.
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
  - Set TLS as an authentication service in the sqlnet.ora file.
****
  - Optionally, for better security, set the client to use full or partial DN matching. When DN matching is enabled, the client will check the server certificate to ensure that host names will match what the client is configured to match. You perform this step when you enable Oracle Internet Directory to use TLS. Note: The database client and server will use the strongest TLS protocol and cipher suite to establish a connection. Therefore, you do not need to specify the TLS version and cipher suites unless you have specific security requirements that require it. Be aware that if you set specific TLS versions and cipher suites, you will need to update the configuration when the older versions are no longer used.
```
LISTENER = (DESCRIPTION_LIST = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = example.com)(PORT = 1521)) (ADDRESS = (PROTOCOL = TCPS)(HOST = example.com)(PORT = 1522)) ) )
```
  - Create a separate listener entry for TLS connections using the secure database port 1522. For example:
  - Comment out the non-TLS listener entry (for example, the line with PROTOCOL = TCP) or leave it in for non-TLS required connections.
````
````
  - Add TLS_CLIENT_AUTHENTICATION = FALSE to the sqlnet.ora file so the database server authenticates the client, not the listener. The same wallet that the server uses can be used by the listener, along with the same server certificate. The listener will look for the wallet using the standard Oracle Database wallet search order. Alternatively, you can specify the wallet location in the listener by setting the WALLET_LOCATION parameter. (You cannot use the WALLET_ROOT parameter for this purpose, because the listener cannot use it.)
````````
  - In the sqlnet.ora file, set TLS_CLIENT_AUTHENTICATION to FALSE (or OFF) to enable one-way TLS.
  - Set the WALLET_ROOT parameter to a location for the TLS server.
````
    - Create the tls directory under WALLET_ROOT/pdb_guid.
    - Move the TLS server wallet to the WALLET_ROOT/pdb_guid/tls directory.
```
TLS_CLIENT_AUTHENTICATION=TRUE
```
````
  - In the sqlnet.ora file, add the following parameter: If you want to restrict authentication to only TCPS, then set AUTHENTICATION_SERVICES to TCPS.
```
CREATE USER user_name IDENTIFIED EXTERNALLY AS 'user DN on certificate';
```
```
CREATE USER user_name IDENTIFIED EXTERNALLY AS 'user DN on certificate'
  WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
**
```
CREATE USER user_name IDENTIFIED EXTERNALLY AS ''
  WITH THUMBPRINT 'SHA256:certificate_thumbprint';
```
- Create a new schema or alter an existing schema to map to the user. You can add the WITH THUMBPRINT clause to map the user to the certificate thumbprint. The same clause is available with the ALTER USER statement. To identify the user only by the certificate thumbprint, enable thumbprint-only authentication and specify an empty certificate DN. For more information about PKI_CERT_AUTH_METHOD, see the Oracle Database Reference.
````
```
CONNNECT /@pdb_name AS SYSOPER
```
- Grant the database schema to appropriate administrative privileges, such as SYSDBA, SYSOPER, and so on. Administrative users with TLS authentication can authenticate with TLS. To enable these users, grant the appropriate administrative privilege to the user schema. The administrative user must log in using this administrative privilege. For example, for a user who was granted the SYSOPER administrative privilege:
Afterward, this user can log in by including the net service name in the `CONNECT` statement in SQL*Plus. For example, to log on as `SYSDBA` if the net service name is `orcl`:
```
CONNECT /@orcl AS SYSDBA
```
## Authentication of Database Administrators by Using the Operating System
For both Windows and UNIX systems, you use `DBA`-privileged groups to authenticate for the operating system.
Operating system authentication for a database administrator typically involves establishing a group on the operating system, granting `DBA` privileges to that group, and then adding the names of persons who should have those privileges to that group. (On UNIX systems, the group is the **dba** group.)
**Note:**   In a multitenant environment, you can use operating system authentication for a database administrator only for the CDB root. You cannot use it for for PDBs, the application root, or application PDBs.
On Microsoft Windows systems:
````
- Users who connect with the SYSDBA administrative privilege can take advantage of the Windows native authentication. If these users work with Oracle Database using their domain accounts, then you must explicitly grant them local administrative privileges and ORA_DBA membership.
- Oracle recommends that you run Oracle Database services using a low privileged Microsoft Windows user account rather than a Microsoft Windows built-in account.
## Authentication of Database Administrators by Using Their Passwords
Password files are used to authenticate database administrators.
That is, Oracle Database users who have been granted the `SYSDBA`, `SYSOPER`, `SYSASM`, `SYSBACKUP`, `SYSDG`, and `SYSKM` administrative privileges are first authenticated using database-specific password files.
These privileges enable the following activities:
````````````````````````````
- The SYSOPER system privilege lets database administrators perform STARTUP, SHUTDOWN, ALTER DATABASE OPEN/MOUNT, ALTER DATABASE BACKUP, ARCHIVE LOG, and RECOVER operations. SYSOPER also includes the RESTRICTED SESSION privilege.
````````````
- The SYSDBA administrative privilege has all system privileges with ADMIN OPTION, including the SYSOPER administrative privilege, and permits CREATE DATABASE and time-based recovery.
````````````````````
````````**
- A password file containing users who have the SYSDBA, SYSOPER, SYSASM, SYSBACKUP, SYSDG, and SYSKM administrative privileges can be shared between different databases. In addition, this type of password file authentication can be used in a Transport Layer Security (TLS) or Kerberos configuration, and for common administrative users in a multitenant environment. You can have a shared password file that contains users in addition to the SYS user. To share a password file among different databases, set the REMOTE_LOGIN_PASSWORDFILE parameter in the init.ora file to SHARED. If you set the REMOTE_LOGIN_PASSWORDFILE initialization parameter to EXCLUSIVE or SHARED from NONE, then ensure that the password file is synchronized with the dictionary passwords. See Oracle Database Administrator’s Guide for more information.
**
- For Automatic Storage Management (ASM) environments, you can create shared ASM password files. Remember that you must have the SYSASM system privilege to create an ASM password file. See Oracle Automatic Storage Management Administrator’s Guide for more information.
- The SYSDG administrative privilege must be included in a password file for sharding administrators to perform tasks that involve file transfer and Oracle Recovery Manager (RMAN) activities.
``````````````
``````
- Password file-based authentication is enabled by default. This means that the database is ready to use a password file for authenticating users that have SYSDBA, SYSOPER, SYSASM, SYSBACKUP, SYSDG, and SYSKM administrative privileges. Password file-based authentication is activated as soon as you create a password file by using the ORAPWD utility. Anyone who has EXECUTE privileges and write privileges to the $ORACLE_HOME/dbs directory can run the ORAPWD utility.
````******
```
- To find a list of users who are included in the password file, you can query the `V$PWFILE_USERS` data dictionary view.
- Connections requested `AS SYSDBA` or `AS SYSOPER` must use these phrases. Without them, the connection fails.
```
- Password limits such as FAILED_LOGIN_ATTEMPTS and PASSWORD_LIFE_TIME are enforced for administrative logins, if the password file is created in the Oracle Database 12c release 2 ( 12.2) format.  Note:
## Risks of Using Password Files for Database Administrator Authentication
Be aware that using password files may pose security risks.
For this reason, consider using the authentication methods described in Strong Authentication, Centralized Management for Administrators.
Examples of password security risks are as follows:
- An intruder could steal or attack the password file.
- Many users do not change the default password.
- The password could be easily guessed.
- The password is vulnerable if it can be found in a dictionary.
******
- Passwords that are too short, chosen perhaps for ease of typing, are vulnerable if an intruder obtains the cryptographic hash of the password. Note: Oracle Database Administrator’s Guide for information about creating and maintaining password files
## Related Topics
  - Guidelines for Securing User Accounts and Privileges
  **- Oracle Database Reference
  **- Oracle Database Reference
  - Your Oracle Database operating system-specific documentation for information about configuring operating system authentication of database administrators
