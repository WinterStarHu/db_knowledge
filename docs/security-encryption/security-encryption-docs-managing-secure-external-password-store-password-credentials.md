# Managing the Secure External Password Store for Password Credentials

The secure external password store is a client-side wallet that is used to store password credentials.
- About the Secure External Password Store You can store password credentials database connections by using a client-side Oracle wallet.
- How Does the Secure External Password Store Work? Users (and applications, batch jobs, and scripts) connect to databases by using a standard CONNECT statement that specifies a database connection string.
- About Configuring Clients to Use the Secure External Password Store If your client is configured to use external authentication, such as Windows native authentication or SSL, then Oracle Database uses that authentication method.
- Configuring a Client to Use the Secure External Password Store You can configure a client to use the secure external password store feature by using the mkstore command-line utility.
- Example: Sample sqlnet.ora File with Wallet Parameters Set You can set special parameters in the sqlnet.ora file to control how wallets are managed.
- Managing External Password Store Credentials The mkstore command-line utility manages credentials from an external password store.
## About the Secure External Password Store
You can store password credentials database connections by using a client-side Oracle wallet.
An Oracle wallet is a secure software container that stores authentication and signing credentials. This wallet usage can simplify large-scale deployments that rely on password credentials for connecting to databases. When this feature is configured, application code, scripts no longer need embedded user names and passwords. This reduces risk because the passwords are no longer exposed, and password management policies are more easily enforced without changing application code whenever user names or passwords change.
**Note:**   The external password store of the wallet is separate from the area where public key infrastructure (PKI) credentials are stored. Consequently, you cannot use Oracle Wallet Manager to manage credentials in the external password store of the wallet. Instead, use the command-line utility `mkstore` to manage these credentials.
## How Does the Secure External Password Store Work?
Users (and applications, batch jobs, and scripts) connect to databases by using a standard `CONNECT` statement that specifies a database connection string.
This string can include a user name and password, and an Oracle Net service name identifying the database on an Oracle Database network. If the password is omitted, the connection prompts the user for the password.
For example, the service name could be the URL that identifies that database, or a TNS alias you entered in the `tnsnames.ora` file in the database. Another possibility is a *host:port:sid* string.
The following examples are standard `CONNECT` statements that could be used for a client that is not configured to use the external password store:
```
CONNECT salesapp@sales_db.us.example.com
Enter password: password
CONNECT salesapp@orasales
Enter password: password
CONNECT salesapp@ourhost37:1527:DB17
Enter password: password
```
In these examples, `salesapp` is the user name, with the unique connection string for the database shown as specified in three different ways. You could use its URL `sales_db.us.example.com`, or its TNS alias `orasales` from the `tnsnames.ora` file, or its *host:port:sid* string.
However, when clients are configured to use the secure external password store, applications can connect to a database with the following `CONNECT` statement syntax, without specifying database login credentials:
```
CONNECT /@db_connect_string
CONNECT /@db_connect_string AS SYSDBA
CONNECT /@db_connect_string AS SYSOPER
```
In this specification, *db_connect_string* is a valid connection string to access the intended database, such as the service name, URL, or alias as shown in the earlier examples. Each user account must have its own unique connection string; you cannot create one connection string for multiple users.
In this case, the database credentials, user name and password, are securely stored in an Oracle wallet created for this purpose. The autologin feature of this wallet is turned on, so the system does not need a password to open the wallet. From the wallet, it gets the credentials to access the database for the user they represent.
## About Configuring Clients to Use the Secure External Password Store
If your client is configured to use external authentication, such as Windows native authentication or SSL, then Oracle Database uses that authentication method.
The same credentials used for this type of authentication are typically also used to log in to the database. For clients not using such authentication methods or wanting to override them for database authentication, you can set the `SQLNET.WALLET_OVERRIDE` parameter in `sqlnet.ora` to `TRUE`. The default value for `SQLNET.WALLET_OVERRIDE` is `FALSE`, allowing standard use of authentication credentials as before.
## Configuring a Client to Use the Secure External Password Store
You can configure a client to use the secure external password store feature by using the `mkstore` command-line utility.
  - Create a wallet on the client by using the following syntax at the command line:
```
mkstore -wrl wallet_location -create
```
```
For example:
```
```
mkstore -wrl c:\oracle\product\19.1.0\db_1\wallets -create
Enter password: password
```
```
*wallet_location* is the path to the directory where you want to create and store the wallet. This command creates an Oracle wallet with the autologin feature enabled at the location you specify. The autologin feature enables the client to access the wallet contents without supplying a password.
The `mkstore` utility `-create` option uses password complexity verification. See [About Password Complexity Verification](managing-complexity-passwords.html#GUID-A39E191B-4A06-442D-94C7-5882B73DDCFA) for more information.
```
  - Create database connection credentials in the wallet by using the following syntax at the command line:
```
mkstore -wrl wallet_location -createCredential db_connect_string username
Enter password: password
```
```
For example:
```
```
mkstore -wrl c:\oracle\product\19.1.0\db_1\wallets -createCredential orcl system
Enter password: password
```
```
In this specification:
- *wallet_location* is the path to the directory where you created the wallet in Step [1](#GUID-3EA07020-A9F3-4FF9-9518-E1AEA3BDDBBE__CHDCAGGI).
- *db_connect_string* is the TNS alias you use to specify the database in the `tnsnames.ora` file or any service name you use to identify the database on an Oracle network. By default, `tnsnames.ora` is located in the `$ORACLE_HOME/network/admin` directory on UNIX systems and in *ORACLE_HOME*`\network\admin` on Windows.
- *username* is the database login credential. When prompted, enter the password for this user.
Repeat this step for each database you want accessible using the `CONNECT /@`*db_connect_string* syntax. The *db_connect_string* used in the `CONNECT /@`*db_connect_string* statement must be identical to the *db_connect_string* specified in the `-createCredential` command.
```
````
``````
- In the client sqlnet.ora file, enter the WALLET_LOCATION parameter and set it to the directory location of the wallet you created in Step 1. For example, if you created the wallet in $ORACLE_HOME/network/admin and your Oracle home is set to /private/ora11, then you need to enter the following into your client sqlnet.ora file:
```
WALLET_LOCATION =
  (SOURCE =
    (METHOD = FILE)
    (METHOD_DATA =
  (DIRECTORY = /private/ora11/network/admin)
  )
 )
```
  ``````- In the client sqlnet.ora file, enter the SQLNET.WALLET_OVERRIDE parameter and set it to TRUE as follows:
```
SQLNET.WALLET_OVERRIDE = TRUE
```
```
This setting causes all `CONNECT /@`*db_connect_string* statements to use the information in the wallet at the specified location to authenticate to databases.
When external authentication is in use, an authenticated user with such a wallet can use the `CONNECT /@`*db_connect_string* syntax to access the previously specified databases without providing a user name and password. However, if a user fails that external authentication, then these connect statements also fail.
```
**Note:**   If an application uses SSL for encryption, then the `sqlnet.ora` parameter, `SQLNET.AUTHENTICATION_SERVICES`, specifies SSL and an SSL wallet is created. If this application wants to use secret store credentials to authenticate to databases (instead of the SSL certificate), then those credentials must be stored in the SSL wallet. After SSL authentication, if `SQLNET.WALLET_OVERRIDE = TRUE`, then the user names and passwords from the wallet are used to authenticate to databases. If `SQLNET.WALLET_OVERRIDE = FALSE`, then the SSL certificate is used.
## Example: Sample sqlnet.ora File with Wallet Parameters Set
You can set special parameters in the sqlnet.ora file to control how wallets are managed.
Example 3-2 shows a sample `sqlnet.ora` file with the `WALLET_LOCATION` and the `SQLNET.WALLET_OVERRIDE` parameters set as described in Steps 3 and 4 of Configuring a Client to Use the Secure External Password Store.
Example 3-2 Sample sqlnet.ora File with Wallet Parameters Set
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CLIENT_AUTHENTICATION` and `SSL_CLIENT_AUTHENTICATION` parameters are configured, then the `SSL_CLIENT_AUTHENTICATION` parameter is ignored.
```
WALLET_LOCATION = (SOURCE = (METHOD = FILE) (METHOD_DATA = (DIRECTORY = /private/ora_db/network/admin) ) ) SQLNET.WALLET_OVERRIDE = TRUE TLS_CLIENT_AUTHENTICATION = FALSE TLS_VERSION = UNDETERMINED
```
## Managing External Password Store Credentials
The `mkstore` command-line utility manages credentials from an external password store.
- Listing External Password Store Contents You can view the contents, including specific credentials, of a client wallet external password store.
- Adding Credentials to an External Password Store You can store multiple credentials in one client wallet.
- Modifying Credentials in an External Password Store You can modify the database login credentials that are stored in the wallet if the database connection strings change.
- Deleting Credentials from an External Password Store You can delete login credentials for a database from a wallet if the database no longer exists or to disable connections to a specific database.
### Listing External Password Store Contents
You can view the contents, including specific credentials, of a client wallet external password store.
Listing the external password store contents provides information you can use to decide whether to add or delete credentials from the store.
  - To list the contents of the external password store, enter the following command at the command line:
```
mkstore -wrl wallet_location -listCredential
```
For example:
```
mkstore -wrl c:\oracle\product\19.1.0\db_1\wallets -listCredential
```
*wallet_location* specifies the path to the directory where the wallet, whose external password store contents you want to view, is located. This command lists all of the credential database service names (aliases) and the corresponding user name (schema) for that database. Passwords are not listed.
### Adding Credentials to an External Password Store
You can store multiple credentials in one client wallet.
For example, if a client batch job connects to `hr_database` and a script connects to `sales_database`, then you can store the login credentials in the same client wallet. You cannot, however, store multiple credentials (for logging in to multiple schemas) for the same database in the same wallet. If you have multiple login credentials for the same database, then they must be stored in separate wallets.
  - To add database login credentials to an existing client wallet, enter the following command at the command line:
```
mkstore -wrl wallet_location -createCredential db_alias username
```
For example:
```
mkstore -wrl c:\oracle\product\19.1.0\db_1\wallets -createCredential orcl system Enter password: password
```
In this specification:
**
- wallet_location is the path to the directory where the client wallet to which you want to add credentials is stored.
**
- db_alias can be the TNS alias you use to specify the database in the tnsnames.ora file or any service name you use to identify the database on an Oracle network.
**
- username is the database login credential for the schema to which your application connects. When prompted, enter the password for this user.
### Modifying Credentials in an External Password Store
You can modify the database login credentials that are stored in the wallet if the database connection strings change.
  - To modify database login credentials in a wallet, enter the following command at the command line:
```
mkstore -wrl wallet_location -modifyCredential db_alias username
```
For example:
```
mkstore -wrl c:\oracle\product\19.1.0\db_1\wallets -modifyCredential sales_db Enter password: password
```
In this specification:
**
- wallet_location is the path to the directory where the wallet is located.
**
- db_alias is a new or different alias you want to use to identify the database. It can be a TNS alias you use to specify the database in the tnsnames.ora file or any service name you use to identify the database on an Oracle network.
**
- username is the new or different database login credential. When prompted, enter the password for this user.
### Deleting Credentials from an External Password Store
You can delete login credentials for a database from a wallet if the database no longer exists or to disable connections to a specific database.
  - To delete database login credentials from a wallet, enter the following command at the command line:
```
mkstore -wrl wallet_location -deleteCredential db_alias
```
For example:
```
mkstore -wrl c:\oracle\product\19.1.0\db_1\wallets -deleteCredential orcl
```
In this specification:
**
- wallet_location is the path to the directory where the wallet is located.
**
- db_alias is the TNS alias you use to specify the database in the tnsnames.ora file, or any service name you use to identify the database on an Oracle Database network.
## Related Topics
  - Using Proxy Authentication with the Secure External Password Store
  **- Oracle Database Enterprise User Security Administrator’s Guide
  **- Oracle Database Enterprise User Security Administrator’s Guide
