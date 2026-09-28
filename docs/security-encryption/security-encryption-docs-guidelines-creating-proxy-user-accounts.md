# Guidelines for Creating Proxy User Accounts

Oracle provides special guidelines for when you create proxy user accounts.
- For better security and to adhere to the principle of least privilege, only grant the proxy user account the CREATE SESSION privilege. Do not grant this user any other privileges. The proxy user account is designed to only enable another user to connect using the proxy account. Any privileges that must be exercised during the connection should belong to the connecting user, not to the proxy account.
- As with all passwords, ensure that the password you create for the proxy user is strong and not easily guessed. Remember that multiple users will be connecting as the proxy user, so it is especially important that this password be strong.
- Consider using the Oracle strong authentication network connection features, to prevent network eavesdropping.
``````
- For further fine-tuning of the amount of control that the connecting user has, consider restricting the roles used by the connecting user when he or she is connected through the proxy account. The ALTER USER statement WITH ROLE clause enables you to configure the user to connect using specified roles, any role except a specified role, or with no roles at all. Be aware that the proxy user can only activate those roles that are included in the WITH ROLE clause. The proxy user session will have all the privileges that were directly granted to the client (that is, current) user.
````````
- A proxy user in a proxy session can enable a password-protected role or secure application role only if the role has been allowed to be enabled with the WITH ROLE or WITH ROLE ALL clause. (If this clause is not specified, then WITH ROLE ALL is the default.) If WITH ROLE does not specify the secure roles, then those roles cannot be enabled, even with the correct password.
## Related Topics
  - Guidelines for Securing Passwords
