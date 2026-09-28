# Creating Proxy User Accounts and Authorizing Users to Connect Through Them

The `CREATE USER` and `ALTER USER` statements can be used to create a proxy user and authorize users to connect through it.
A proxy user in a proxy session can enable a password-protected role or secure application role only if the role has been allowed to be enabled with the `WITH ROLE` or `WITH ROLE ALL` clause. (If this clause is not specified, then `WITH ROLE ALL` is the default.) If `WITH ROLE` does not specify the secure roles, then those roles cannot be enabled, even with the correct password.
- Use the CREATE USER statement to create the proxy user account. For example:
```
CREATE USER appuser IDENTIFIED BY password;
```
````
- Use the GRANT CONNECT THROUGH clause of the ALTER USER statement to enable an existing user to connect through the proxy user account. For example:
```
ALTER USER preston GRANT CONNECT THROUGH appuser;
```
```
Be aware that the user name and proxy combination must not exceed 250 characters.
Suppose user `preston` has a large number of roles, but you only want this user to use one role (for example, the `appuser_role`) when this user is connected to the database through the `appuser` proxy account. You can use the following `ALTER USER` statement:
```
```
ALTER USER preston GRANT CONNECT THROUGH appuser WITH ROLE appuser_role;
```
```
Any other roles that user `preston` has will not be available to her as long as this user is connecting as the `appuser` proxy.
```
After you complete these steps, user `preston` can connect using the `appuser` proxy user as follows:
```
CONNECT appuser[preston] Enter password: appuser_password
```
## Related Topics
  **- Oracle Database SQL Language Reference
  **- Oracle Database SQL Language Reference
