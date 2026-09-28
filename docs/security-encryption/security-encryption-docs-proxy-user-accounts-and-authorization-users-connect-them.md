# Proxy User Accounts and the Authorization of Users to Connect Through Them

The `CREATE USER` statement enables you to create the several types of user accounts, all of which can be used as proxy accounts.
These accounts are as follows:
- Database user accounts, which are authenticated by passwords
- External user accounts, which are authenticated by external sources, such as Secure Socket Layer (SSL) or Kerberos
- Global user accounts, which are authenticated by an enterprise directory service (Oracle Internet Directory).
Note the following:
****````
- The proxy user can only perform activities that the user preston has privileges to perform. Remember that the proxy user itself, appuser, only has the minimum privileges (CREATE SESSION).
****
- Using roles with middle-tier clients. You can also specify roles that the middle tier is permitted to activate when connecting as the client. Operations performed on behalf of a client by a middle-tier server can be audited.
****
- Finding proxy users. To find the users who are currently authorized to connect through a middle tier, query the PROXY_USERS data dictionary view, for example:
```
SELECT * FROM PROXY_USERS;
```
****````````- Removing proxy connections. Use the REVOKE CONNECT THROUGH clause of ALTER USER to disallow a proxy connection. For example, to revoke user preston from connecting through the proxy user appuser, enter the following statement:
```
ALTER USER preston REVOKE CONNECT THROUGH appuser;
```
****- Password expiration and proxy connections. Middle-tier use of password expiration does not apply to accounts that are authenticated through a proxy. Instead, lock the account rather than expire the password.
## Related Topics
  - Auditing SQL Statements and Privileges in a Multitier Environment
**- Oracle Database Enterprise User Security Administrator’s Guide
