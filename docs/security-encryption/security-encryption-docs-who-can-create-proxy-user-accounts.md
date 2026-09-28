# Who Can Create Proxy User Accounts?

To create proxy user accounts, users must have special privileges.
These privileges are as follows:
- The CREATE USER system privilege to create a database user account that will be used as a proxy user account
- The DV_ACCTMGR role if Oracle Database Vault is enabled, to create the proxy user account
- The ability to grant the CREATE SESSION system privilege to the proxy user account
****
- The ALTER USER system privilege to enable existing user accounts to connect to the database through the proxy account Note: In an Oracle Database Vault environment, when operations control is enabled, common users cannot proxy as local users in a PDB.
