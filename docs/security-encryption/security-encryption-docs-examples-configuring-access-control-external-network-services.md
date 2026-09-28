# Examples of Configuring Access Control for External Network Services

You can configure access control for a variety of situations, such as for a single role and network connection.
- Example: Configuring Access Control for a Single Role and Network Connection The DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE procedure can configure access control for a single role and network connection.
- Example: Configuring Access Control for a User and Role The DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE can configure access control to deny or grant privileges for a user and a role.
- Example: Using the DBA_HOST_ACES View to Show Granted Privileges The DBA_HOST_ACE data dictionary view shows privileges that have been granted to users.
````
- Example: Configuring ACL Access Using Passwords in a Non-Shared Wallet The DBMS_NETWORK_ACL_ADMIN and UTL_HTTP PL/SQL packages can configure ACL access using passwords in a non-shared wallet.
````
- Example: Configuring ACL Access for a Wallet in a Shared Database Session The DBMS_NETWORK_ACL_ADMIN and UTL_HTTP PL/SQL packages can configure ACL access for a wallet in a shared database session.
## Example: Configuring Access Control for a Single Role and Network Connection
The `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE` procedure can configure access control for a single role and network connection.
Example 10-3 shows how you would configure access control for a single role (`acct_mgr`) and grant this role the `http` privilege for access to the `www.us.example.com` host. The privilege expires January 1, 2013.
Example 10-3 Configuring Access Control for a Single Role and Network Connection
```
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
  host       => 'www.us.example.com',
  lower_port => 80,
  ace        =>  xs$ace_type(privilege_list => xs$name_list('http'),
                           principal_name => 'acct_mgr',
                           principal_type => xs_acl.ptype_db,
                           end_date => TIMESTAMP '2013-01-01 00:00:00.00 -08:00');
END;
/
```
## Example: Configuring Access Control for a User and Role
The `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE` can configure access control to deny or grant privileges for a user and a role.
Afterwards, you can query the `DBA_HOST_ACES` data dictionary view to find information about the privilege grants.
Example 10-4 grants to a database role (`acct_mgr`) but denies a particular user (`psmith`) even if he has the role. The order is important because ACEs are evaluated in the given order. In this case, the deny ACE (`granted => false`) must be appended first or else the user cannot be denied.
Example 10-4 Configuring Access Control Using a Grant and a Deny for User and Role
```
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
  host       => 'www.us.example.com',
  lower_port => 80,
  upper_port => 80,
  ace        =>  xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => 'psmith',
                             principal_type => xs_acl.ptype_db,
                             granted        => false));
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
  host       => 'www.us.example.com',
  lower_port => 80,
  upper_port => 80,
  ace        =>  xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => 'acct_mgr',
                             principal_type => xs_acl.ptype_db,
                             granted        => true));
END;
```
## Example: Using the DBA_HOST_ACES View to Show Granted Privileges
The `DBA_HOST_ACE` data dictionary view shows privileges that have been granted to users.
Example 10-5 shows how the `DBA_HOST_ACES` data dictionary view displays the privilege granted in the previous access control list.
Example 10-5 Using the DBA_HOST_ACES View to Show Granted Privileges
```
SELECT PRINCIPAL, PRIVILEGE, GRANT_TYPE FROM DBA_HOST_ACE WHERE PRIVILEGE = 'HTTP';
PRINCIPAL    PRIVILEGE  GRANT_TYPE
------------ ---------- --------------------
PSMITH       HTTP       FALSE
ACCT_MGR     HTTP       TRUE
```
## Example: Configuring ACL Access Using Passwords in a Non-Shared Wallet
The `DBMS_NETWORK_ACL_ADMIN` and `UTL_HTTP` PL/SQL packages can configure ACL access using passwords in a non-shared wallet.
Example 10-6 configures wallet access for two Human Resources department roles, `hr_clerk` and `hr_manager`. These roles use the `use_passwords` privilege to access passwords stored in the wallet. In this example, the wallet will not be shared with other applications within the same database session.
Example 10-6 Configuring ACL Access Using Passwords in a Non-Shared Wallet
```
**/* 1. At a command prompt, create the wallet. The following example uses the**
**user name hr_access as the alias to identify the user name and password**
**stored in the wallet. You must use this alias name when you call the**
**SET_AUTHENTICATION_FROM_WALLET procedure later on. */**
$ mkstore -wrl $ORACLE_HOME/wallets/hr_wallet -create
Enter password: password
Enter password again: password
$ mkstore -wrl $ORACLE_HOME/wallets/hr_wallet -createCredential hr_access hr_usr
Your secret/Password is missing in the command line
Enter your secret/Password: password
Re-enter your secret/Password: password
Enter wallet password: password
**/* 2. In SQL*Plus, create an access control list to grant privileges for the**
**wallet. The following example grants the use_passwords privilege to the**
**hr_clerk role.*/**
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE (
  wallet_path => 'file:/oracle/wallets/hr_wallet',
  ace         => xs$ace_type(privilege_list => xs$name_list('use_passwords'),
                             principal_name => 'hr_clerk',
                             principal_type => xs_acl.ptype_db));
END;
/
**/* 3. Create a request context and request object, and then set the authentication**
**for the wallet. */**
DECLARE
  req_context  UTL_HTTP.REQUEST_CONTEXT_KEY;
  req          UTL_HTTP.REQ;
BEGIN
 req_context := UTL_HTTP.CREATE_REQUEST_CONTEXT(
     wallet_path          => 'file:/oracle/wallets/hr_wallet',
     wallet_password      => NULL,
     enable_cookies       => TRUE,
     max_cookies          => 300,
     max_cookies_per_site => 20);
  req := UTL_HTTP.BEGIN_REQUEST(
     url                  => 'www.hr_access.example.com',
     request_context      => req_context);
  UTL_HTTP.SET_AUTHENTICATION_FROM_WALLET(
     r                    => req,
     alias                => 'hr_access'),
     scheme               => 'Basic',
     for_proxy            => FALSE);
END;
/
```
## Example: Configuring ACL Access for a Wallet in a Shared Database Session
The `DBMS_NETWORK_ACL_ADMIN` and `UTL_HTTP` PL/SQL packages can configure ACL access for a wallet in a shared database session.
Example 10-7 configures the wallet to be used for a shared database session; that is, all applications within the current database session will have access to this wallet.
Example 10-7 Configuring ACL Access for a Wallet in a Shared Database Session
```
**/* Follow these steps:**
**1. Use Oracle Wallet Manager to create the wallet and add the client**
**certificate.**
**2. In SQL*Plus, configure access control to grant privileges for the wallet.**
**The following example grants the use_client_certificates privilege**
**to the hr_clerk and hr_mgr roles. */**
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE (
  wallet_path => 'file:/oracle/wallets/hr_wallet',
  ace         => xs$ace_type(privilege_list => xs$name_list('use-client_certificates'),
                             principal_name => 'hr_clerk',
                             principal_type => xs_acl.ptype_db));
 DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE (
  wallet_path => 'file:/oracle/wallets/hr_wallet',
  ace         => xs$ace_type(privilege_list => xs$name_list('use_client_certificates'),
                             principal_name => 'hr_mgr',
                             principal_type => xs_acl.ptype_db));
END;
/
COMMIT;
**/* 3. Create a request object to handle the HTTP authentication for the wallet.*/**
DECLARE
  req  UTL_HTTP.req;
BEGIN
  UTL_HTTP.SET_WALLET(
   path            => 'file:/oracle/wallets/hr_wallet',
   password        => NULL);
 req := UTL_HTTP.BEGIN_REQUEST(
   url             => 'www.hr_access.example.com',
   method          => 'POST',
   http_version    => NULL,
   request_context => NULL);
END;
/
```
