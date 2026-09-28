# Using Proxy Authentication with the Secure External Password Store

Use a secure external password store if you are concerned about the password used in proxy authentication being obtained by a malicious user.
To accomplish this, you use the secure external password store with the proxy authentication to store the password credentials in a wallet.
Connecting to Oracle Database using proxy authentication and the secure external password store is ideal for situations such as running batch files. When a proxy user connects to the database and authenticates using a secure external password, the password is not exposed in the event that a malicious user tries to obtain the password.
To use proxy authentication with the secure external password store:
- Configure the proxy authentication account, as shown in the procedure in Proxy User Accounts and the Authorization of Users to Connect Through Them.
- Configure the secure external password store, as described in About Configuring Clients to Use the Secure External Password Store.
Afterward, the user can connect using the proxy but without having to specify a password. For example:
```
sqlplus [preston]/@db_alias
```
When you use the secure external password store, the user logging in does not need to supply the user name and password. Only the `SERVICE_NAME` value (that is, `db_alias`) from the `tnsnames.ora` file must be specified.
