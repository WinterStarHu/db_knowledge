# Schema-Only Accounts

You can create schema-only accounts, that is, the schema user has no password.
- About Schema-Only Accounts A schema-only account cannot log in to the database but can proxy in a single session proxy.
- Creating a Schema-Only Account The CREATE USER SQL statement creates schema-only accounts.
- Altering a Schema-Only Account The ALTER USER SQL statement can be used to modify schema-only accounts.
## About Schema-Only Accounts
A schema-only account cannot log in to the database but can proxy in a single session proxy.
This type of account, designed for some Oracle-provided schemas along with some user-created schemas, can be created without the specification of a password or an authentication type. It cannot be authenticated unless an authentication method is assigned by using the `ALTER USER` statement. A schema-only account does not contain an entry in the `DBA_USERS_WITH_DEFPWD` data dictionary view.
By default, most of the predefined schema user accounts that are available with Oracle Database, such as the sample schema user accounts (for example, `HR`), are schema-only accounts. You can assign these accounts passwords if you want to, but for better security, Oracle recommends that you set them back to being schema-only afterwards. To check if a schema user account is schema only, query the `AUTHENTICATION_TYPE` column of the `DBA_USERS` data dictionary view. `NONE` indicates that the account is schema only.
Note the following rules about using schema only accounts:
- Schema only accounts can be used for both administrator and non-administrator accounts.
- Schema only accounts must be created on the database instance only, not in Oracle Automatic Storage Management (ASM) environments.
````
- You can grant system privileges (such as CREATE ANY TABLE) and administrator roles (such as DBA) to schema only accounts. Schema only accounts can create objects such as tables or procedures, assuming they have had to correct privileges granted to them.
- You can configure schema only accounts to be used as client users in a proxy authentication in a single session proxy. This is because in a single session proxy, only the credentials of the proxy user are verified, not the credentials of the client user. Therefore, a schema only account can be a client user. However, you cannot configure schema only accounts for a two-proxy scenario, because the client credentials must be verified. Hence, the authentication for a schema only account will fail.
- Schema only accounts cannot connect through database links, either with connected user links, fixed user links, or current user links.
## Creating a Schema-Only Account
The `CREATE USER` SQL statement creates schema-only accounts.
You can run the `CREATE USER` statement with the `NO AUTHENTICATION` clause only on a database instance. You cannot run it on an Oracle Automatic Storage Management (ASM) instance.
````
- Use the CREATE USER statement with the NO AUTHENTICATION clause. For example:
```
CREATE USER psmith NO AUTHENTICATION;
```
## Altering a Schema-Only Account
The `ALTER USER` SQL statement can be used to modify schema-only accounts.
- Check if the schema user has administrative privileges. You can query the V$PWFILE_USERS to find if the schema user has administrative privileges.
- If the schema user has administrative privileges, then use the REVOKE statement to revoke these privileges.
````
- Use the ALTER USER SQL statement with the NO AUTHENTICATION clause to modify the schema account to have no authentication. For example:
```
ALTER USER psmith NO AUTHENTICATION;
```
You can use `ALTER USER` to enable authentication for a schema-only account.
## Related Topics
  - Predefined Sample Schema User Accounts
