# Configuring an External Service to Authenticate Users and Passwords

An external service (the operating system or the network) can administer passwords and authenticate users.
- About External Authentication With external authentication, Oracle Database maintains the user account, but an external service performs the password administration and user authentication.
- Advantages of External Authentication External authentication provides several advantages.
- Enabling External Authentication To enable external authentication, you can set the initialization parameter OS_AUTHENT_PREFIX, and use this prefix in Oracle Database user names.
- Creating a User Who Is Authenticated Externally Externally authenticated users are authenticated by the operating system or network service.
- Authentication of User Logins By Using the Operating System Oracle Database allows operating system-authenticated logins only over secure connections, which precludes using Oracle Net and a shared server configuration.
- Authentication of User Logins Using Network Authentication Oracle strong authentication performs network authentication, which you can configure to use a third-party service such as Kerberos.
## About External Authentication
With external authentication, Oracle Database maintains the user account, but an external service performs the password administration and user authentication.
This external service can be the operating system or a network service, such as Oracle Net. If you are authenticating users through a password file, then you can configure external authentication for users who have been granted the `SYSDBA`, `SYSOPER`, `SYSASM`, `SYSBACKUP`, `SYSDG`, and `SYSKM` administrative privileges.
With external authentication, your database relies on the underlying operating system or network authentication service to restrict access to database accounts. A database password is not used for this type of login. If your operating system or network service permits, then it can authenticate users before they can log in to the database.
You also can use centrally managed users to authenticate and authorize users through a directory service such as Microsoft Active Directory.
1.md#GUID-D104205B-FCC0-46B9-AB95-5ACAA0AF269A)
  - Configuring Centrally Managed Users with Microsoft Active Directory
## Advantages of External Authentication
External authentication provides several advantages.
These advantages are as follows:
- More choices of authentication mechanisms are available, such as smart cards, fingerprints, Kerberos, or the operating system.
- Many network authentication services, such as Kerberos support single sign-on, enabling users to have fewer passwords to remember.
- If you are already using an external mechanism for authentication, such as one of those listed earlier, then there may be less administrative overhead to use that mechanism with the database.
## Enabling External Authentication
To enable external authentication, you can set the initialization parameter `OS_AUTHENT_PREFIX`, and use this prefix in Oracle Database user names.
The `OS_AUTHENT_PREFIX` parameter defines a prefix that Oracle Database adds to the beginning of the operating system account name of every user. Oracle Database compares the prefixed user name with the Oracle Database user names in the database when a user attempts to connect.
````
- Set OS_AUTHENT_PREFIX to a null string (an empty set of double quotation marks: ""). Using a null string eliminates the addition of any prefix to operating system account names, so that Oracle Database user names exactly match operating system user names. For example:
```
OS_AUTHENT_PREFIX=""
```
  - Ensure that the OS_AUTHENT_PREFIX remains the same for the life of a database. If you change the prefix, then any database user name that includes the old prefix cannot be used to establish a connection, unless you alter the user name to have it use password authentication.
The default value of the `OS_AUTHENT_PREFIX` parameter is `OPS$` for backward compatibility with previous versions of Oracle Database. For example, assume that you set `OS_AUTHENT_PREFIX` as follows:
```
OS_AUTHENT_PREFIX=OPS$
```
If a user with an operating system account named `tsmith` is to connect to an Oracle database installation and be authenticated by the operating system, then Oracle Database checks that there is a corresponding database user `OPS$tsmith` and, if so, lets the user connect. All references to a user authenticated by the operating system must include the prefix, `OPS$`, as seen in `OPS$tsmith`.
 **Note:**   The text of the `OS_AUTHENT_PREFIX` initialization parameter is case-sensitive on some operating systems. See your operating system-specific Oracle Database documentation for more information about this initialization parameter.
## Creating a User Who Is Authenticated Externally
Externally authenticated users are authenticated by the operating system or network service.
You can create users who are authenticated externally. Oracle Database then relies on this external login authentication when it provides that specific operating system user with access to the database resources of a specific user.
  ````- Use the IDENTIFIED EXTERNALLY clause of the CREATE USER statement to create users who are authenticated externally.
The following example creates a user who is identified by Oracle Database and authenticated by the operating system or a network service. This example assumes that the `OS_AUTHENT_PREFIX` parameter has been set to a blank space (`" "`).
```
CREATE USER psmith IDENTIFIED EXTERNALLY;
```
## Authentication of User Logins By Using the Operating System
Oracle Database allows operating system-authenticated logins only over secure connections, which precludes using Oracle Net and a shared server configuration.
This type of operating system authentication is the default. This restriction prevents a remote user from impersonating another operating system user over a network connection.
Setting the `REMOTE_OS_AUTHENT` parameter to `TRUE` in the database initialization parameter file forces the database to accept the client operating system user name received over an unsecure connection and use it for account access. Because clients, in general, such as PCs, are not trusted to perform operating system authentication properly, it is very poor security practice to turn on this feature.
The default setting, `REMOTE_OS_AUTHENT = FALSE`, creates a more secure configuration that enforces proper, server-based authentication of clients connecting to an Oracle database.
Be aware that the `REMOTE_OS_AUTHENT` parameter was deprecated in Oracle Database 11*g* Release 1 (11.1), and is retained only for backward compatibility.
Any change to this parameter takes effect the next time you start the instance and mount the database. Generally, user authentication through the host operating system offers faster and more convenient connection to Oracle Database without specifying a separate database user name or password. Also, user entries correspond in the database and operating system audit trails.
## Authentication of User Logins Using Network Authentication
Oracle strong authentication performs network authentication, which you can configure to use a third-party service such as Kerberos.
If you are using Oracle strong authentication as your only external authentication service, then the `REMOTE_OS_AUTHENT` parameter setting is irrelevant, because Oracle strong authentication permits only secure connections.
## Related Topics
  - [Management of the Password File of Administrative Users](managing-passwords-administrative-users
