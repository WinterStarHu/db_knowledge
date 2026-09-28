# Database Authentication of Users

Database authentication of users entails using information within the database itself to perform the authentication.
- About Database Authentication of Users Oracle Database can authenticate users attempting to connect to a database by using information stored in that database itself.
- Advantages of Database Authentication There are three advantages of using the database to authenticate users.
- Creating Users Who Are Authenticated by the Database When you create a user who is authenticated by the database, you assign this user a password.
## About Database Authentication of Users
Oracle Database can authenticate users attempting to connect to a database by using information stored in that database itself.
To configure Oracle Database to use database authentication, you must create each user with an associated password. User names can use the National Language Support (NLS) character format, but you cannot include double quotation mark characters in the password. The user must provide this user name and password when attempting to establish a connection.
Oracle Database generates a one-way hash of the user’s password and stores it for use when verifying the provided login password. In order to support older clients, Oracle Database can be configured to generate the one-way hash of the user’s password using a variety of different hashing algorithms. The resulting password hashes are known as password versions, which have the short names `10G`, `11G`, and `12C`. The short names `10G`, `11G`, and `12C` serve as abbreviations for the details of the one-way password hashing algorithms, which are described in more detail in the documentation for the `PASSWORD_VERSIONS` column of the `DBA_USERS` view. To find the list of password versions for any given user, query the `PASSWORD_VERSIONS` column of the `DBA_USERS` view.
By default, there are currently two versions of the one-way hashing algorithm in use in Oracle Database: the salted SHA-1 hashing algorithm, and the salted PKBDF2 SHA-2 SHA-512 hashing algorithm. The salted SHA-1 hashing algorithm generates the hash that is used for the `11G` password version. The salted PKBDF2 SHA-2 SHA-512 hashing algorithm generates the hash that is used for the `12C` password version. This hash generation takes place for the same password; that is, both algorithms run for the same password. Oracle Database records these password versions in the `DBA_USERS` data dictionary view. When you query this view, you will see two password versions. For example:
```
SELECT USERNAME, PASSWORD_VERSIONS FROM DBA_USERS;
USERNAME  PASSWORD_VERSIONS
--------  -----------------
ADAMS     11G, 12C
SYS       11G, 12C
...
```
To specify which authentication protocol to allow during authentication of a client or of a database server acting as a client, you can explicitly set the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` parameter in the server `sqlnet.ora` file. (The client version of this parameter is `SQLNET.ALLOWED_LOGON_VERSION_CLIENT`.) Each connection attempt is tested, and if the client or server does not meet the client ability requirements specified by its partner, authentication fails with an `ORA-28040 No matching authentication protocol` error in the “Ability Required of the Client” in the “SQLNET.ALLOWED_LOGON_VERSION_SERVER Settings” table under the description of the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` parameter in *Oracle Database Net Services Reference*. The parameter can take the values `12a`, `12`, `11`, `10`, `9`, or `8`. The default value is `12`, which is Exclusive Mode. These values represent the version of the authentication protocol. Oracle recommends the value `12`. However, be aware that if you set `SQLNET.ALLOWED_LOGON_VERSION_SERVER` and `SQLNET.ALLOWED_LOGON_VERSION_CLIENT` to `11`, then pre-Oracle Database Release 11.1 client applications including JDBC thin clients cannot authenticate to the Oracle database using password-based authentication.
To enhance security when using database authentication, Oracle recommends that you use password management, including account locking, password aging and expiration, password history, and password complexity verification.
If you are not using external authentication and only using local database password authentication, then set `AUTHENTICATION_SERVICES=(none)` in the client `sqlnet.ora` file. This setting improves performance because the default for this value is `ALL`, which forces the client to check external authentication as well as database password authentication.
## Advantages of Database Authentication
There are three advantages of using the database to authenticate users.
These advantages are as follows:
- User accounts and all authentication are controlled by the database. There is no reliance on anything outside of the database.
- Oracle Database provides strong password management features to enhance security when using database authentication.
- It is easier to administer when there are small user communities.
## Creating Users Who Are Authenticated by the Database
When you create a user who is authenticated by the database, you assign this user a password.
  - To create a user who is authenticated by the database, include the IDENTIFIED BY clause when you create the user.
For example, the following SQL statement creates a user who is identified and authenticated by Oracle Database. User `sebastian` must specify the assigned password whenever they connect to Oracle Database.
```
CREATE USER sebastian IDENTIFIED BY password;
```
## Related Topics
  - SQLNET.ALLOWED_LOGON_VERSION_CLIENT
  - SQLNET.ALLOWED_LOGON_VERSION_SERVER
  - SQLNET.AUTHENTICATION_SERVICES
  - About Password Complexity Verification
  - Using a Password Management Policy
  - Management of Password Versions of Users
  - Creating User Accounts
  - Configuring Multi-Factor Authentication
