# About Access Control to Oracle Wallets

When accessing remote Web server-protected Web pages, users can authenticate themselves with passwords and client certificates stored in an Oracle wallet.
The Oracle wallet provides secure storage of user passwords and client certificates.
To configure access control to a wallet, you must have the following components:
****
- An Oracle wallet. You can create the wallet using the Oracle Database mkstore utility or Oracle Wallet Manager. The HTTP request will use the external password store or the client certificate in the wallet to authenticate the user
****
- An access control list to grant privileges to the user to use the wallet. To configure the access control list, you use the DBMS_NETWORK_ACL_ADMIN PL/SQL package.
The use of Oracle wallets is beneficial because it provides secure storage of passwords and client certificates necessary to access protected Web pages.
## Related Topics
  - Configuring Access Control to an Oracle Wallet
