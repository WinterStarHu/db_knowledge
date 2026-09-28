# Configuring Access Control to an Oracle Wallet

Fine-grained access control for Oracle wallets provide user access to network services that require passwords or certificates.
- About Configuring Access Control to an Oracle Wallet You can configure access control to grant access to passwords and client certificates.
- Step 1: Create an Oracle Wallet An Oracle wallet can use both standard and PKCS11 wallet types, as well as being an auto-login wallet.
- Step 2: Configure Access Control Privileges for the Oracle Wallet After you have created the wallet, you are ready to configure access control privileges for the wallet.
- Step 3: Make the HTTP Request with the Passwords and Client Certificates The UTL_HTTP package can create an HTTP request object to hold wallet information, which can authenticate using a client certificate or a password.
- Revoking Access Control Privileges for Oracle Wallets You can revoke access control privileges for an Oracle wallet.
- Troubleshooting ORA-29024 Errors The ORA-29024: Certificate validation failure error occurs when the facility, component, or product or a failing operation is expecting an Oracle wallet.
## About Configuring Access Control to an Oracle Wallet
You can configure access control to grant access to passwords and client certificates.
These passwords and client certificates are stored in an Oracle wallet. The access control that you configure enables users to authenticate themselves to an external network service when using the PL/SQL network utility packages.
This enables the user to gain access to the network service that requires password or certificate identification.
## Step 1: Create an Oracle Wallet
An Oracle wallet can use both standard and PKCS11 wallet types, as well as being an auto-login wallet.
- To create the wallet, use either the mkstore command-line utility or the Oracle Wallet Manager user interface. To store passwords in the wallet, you must use the mkstore utility.
- Ensure that you have exported the wallet to a file.
- Make a note of the directory in which you created the wallet. You will need this directory path when you complete the procedures in this section.
## Step 2: Configure Access Control Privileges for the Oracle Wallet
After you have created the wallet, you are ready to configure access control privileges for the wallet.
  - Use the DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE procedure to configure the wallet access control privileges.
The syntax for the `DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE` procedure is as follows:
```
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE (
  wallet_path => 'directory_path_to_wallet',
  ace         => xs$ace_type(privilege_list => xs$name_list('privilege'),
                             principal_name => 'user_or_role',
                             principal_type => xs$ace_type_user));
END;
```
In this specification:
  ````````- wallet_path: Enter the path to the directory that contains the wallet that you created in Step 1: Create an Oracle Wallet. When you specify the wallet path, you must use an absolute path and include file: before this directory path. Do not use environment variables, such as $ORACLE_HOME, nor insert a space after file: and before the path name. For example:
```
wallet_path   => 'file:/oracle/wallets/hr_wallet',
```
  ````- ace: Define the ACL by using the XS$ACE_TYPE constant. For example:
```
ace         =>  xs$ace_type(privilege_list => xs$name_list(privilege),
                           principal_name => 'hr_clerk',
                           principal_type => xs_acl.ptype_db);
```
In this specification, *privilege* must be one of the following when you enter wallet privileges using `xs$ace_type` (note the use of underscores in these privilege names):
- use_client_certificates
- use_passwords
For detailed information about these parameters, see the `ace` parameter description in Syntax for Configuring Access Control for External Network Services. Be aware that for wallets, you must specify either the `use_client_certificates` or `use_passwords` privileges.
## Step 3: Make the HTTP Request with the Passwords and Client Certificates
The `UTL_HTTP` package can create an HTTP request object to hold wallet information, which can authenticate using a client certificate or a password.
- Making the HTTPS Request with the Passwords and Client Certificates The UTL_HTTP package makes Hypertext Transfer Protocol (HTTP) callouts from SQL and PL/SQL.
- Using a Request Context to Hold the Wallet When Sharing the Session with Other Applications You should use a request context to hold the wallet when other applications share the database session.
- Use of Only a Client Certificate to Authenticate Only a client certificate can authenticate users, as long as the user has been granted the appropriate privilege in the ACL wallet.
- Use of a Password to Authenticate If the protected URL being requested requires username and password authentication, then set the username and password from the wallet to authenticate.
### Making the HTTPS Request with the Passwords and Client Certificates
The `UTL_HTTP` package makes Hypertext Transfer Protocol (HTTP) callouts from SQL and PL/SQL.
  - Use the UTL_HTTP PL/SQL package to create a request context object that is used privately with the HTTP request and its response.
For example:
```
DECLARE
 req_context UTL_HTTP.REQUEST_CONTEXT_KEY;
 req         UTL_HTTP.REQ;
BEGIN
 req_context := UTL_HTTP.CREATE_REQUEST_CONTEXT (
              wallet_path          => 'file:path_to_directory_containing_wallet',
              wallet_password      => 'wallet_password'|NULL);
 req := UTL_HTTP.BEGIN_REQUEST(
              url                  => 'URL_to_application',
              request_context      => 'request_context'|NULL);
 ...
END;
```
In this specification:
``````
- req_context: Use the UTL_HTTP.CREATE_REQUEST_CONTEXT_KEY data type to create the request context object. This object stores a randomly-generated numeric key that Oracle Database uses to identify the request context. The UTL_HTTP.CREATE_REQUEST_CONTEXT function creates the request context itself.
````
- req: Use the UTL_HTTP.REQ data type to create the object that will be used to begin the HTTP request. You will refer to this object later on, when you set the user name and password from the wallet to access a password-protected Web page.
``````
- wallet_path: Enter the path to the directory that contains the wallet. Ensure that this path is the same path you specified when you created access control list in Step 2: Configure Access Control Privileges for the Oracle Wallet in the previous section. You must include file: before the directory path. Do not use environment variables, such as $ORACLE_HOME. For example:
```
wallet_path          => 'file:/oracle/wallets/hr_wallet',
```
  ````- wallet_password: Enter the password used to open the wallet. The default is NULL, which is used for auto-login wallets. For example:
```
wallet_password      => 'wallet_password');
```
- url: Enter the URL to the application that uses the wallet. For example:
```
url                  => 'www.hr_access.example.com',
```
- request_context: Enter the name of the request context object that you created earlier in this section. This object prevents the wallet from being shared with other applications in the same database session. For example:
```
request_context      => req_context);
```
### Using a Request Context to Hold the Wallet When Sharing the Session with Other Applications
You should use a request context to hold the wallet when other applications share the database session.
If your application has exclusive use of the database session, you can hold the wallet in the database session by using the `UTL_HTTP.SET_WALLET` procedure.
  - Use the UTL_HTTP.SET_WALLET procedure to configure the request to hold the wallet.
For example:
```
DECLARE
 req         UTL_HTTP.REQ;
BEGIN
 UTL_HTTP.SET_WALLET(
              path          => 'file:path_to_directory_containing_wallet',
              password      => 'wallet_password'|NULL);
 req := UTL_HTTP.BEGIN_REQUEST(
              url           => 'URL_to_application');
 ...
END;
```
If the protected URL being requested requires the user name and password to authenticate, then you can use the `SET_AUTHENTICATION_FROM_WALLET` procedure to set the user name and password from the wallet to authenticate.
### Use of Only a Client Certificate to Authenticate
Only a client certificate can authenticate users, as long as the user has been granted the appropriate privilege in the ACL wallet.
If the protected URL being requested requires only the client certificate to authenticate, then the `BEGIN_REQUEST` function sends the necessary client certificate from the wallet. assuming the user has been granted the `use_client_certificates` privilege in the ACL assigned to the wallet.
The authentication should succeed at the remote Web server and the user can proceed to retrieve the HTTP response by using the `GET_RESPONSE` function.
### Use of a Password to Authenticate
If the protected URL being requested requires username and password authentication, then set the username and password from the wallet to authenticate.
For example:
```
DECLARE
 req_context UTL_HTTP.REQUEST_CONTEXT_KEY;
 req         UTL_HTTP.REQ;
BEGIN
...
 UTL_HTTP.SET_AUTHENTICATION_FROM_WALLET(
  r               => HTTP_REQUEST,
  alias           => 'alias_to_retrieve_credentials_stored_in_wallet',
  scheme          => 'AWS|Basic',
  for_proxy       => TRUE|FALSE);
END;
```
In this specification:
  ````- r: Enter the HTTP request defined in the UTL_HTTP.BEGIN_REQUEST procedure that you created above, in the previous section. For example:
```
r               => req,
```
  ````- alias: Enter the alias used to identify and retrieve the user name and password credential stored in the Oracle wallet. For example, assuming the alias used to identify this user name and password credential is hr_access.
```
alias           => 'hr_access',
```
  - AWS: Specifies the Amazon Simple Storage Service (S3) scheme. Use this scheme only if you are configuring access to the Amazon.com Web site. (Contact Amazon for more information about this setting.)
````
  - Basic: Specifies HTTP basic authentication. The default is Basic.
For example:
```
scheme          => 'Basic',
```
````
- for_proxy: Specify whether the HTTP authentication information is for access to the HTTP proxy server instead of the Web server. The default is FALSE. For example:
```
for_proxy       => TRUE);
```
The use of the user name and password in the wallet requires the `use_passwords` privilege to be granted to the user in the ACL assigned to the wallet.
## Revoking Access Control Privileges for Oracle Wallets
You can revoke access control privileges for an Oracle wallet.
  - To revoke privileges from access control entries (ACE) in the access control list (ACL) of a wallet, run the DBMS_NETWORK_ACL_ADMIN.REMOVE_WALLET_ACE procedure.
For example:
```
BEGIN
 DBMS_NETWORK_ACL_ADMIN.REMOVE_WALLET_ACE (
  wallet_path   => 'file:/oracle/wallets/hr_wallet',
  ace           =>  xs$ace_type(privilege_list => xs$name_list(privilege),
                             principal_name => 'hr_clerk',
                             principal_type => xs_acl.ptype_db),
  remove_empty_acl  => TRUE);
END;
/
```
In this example, the `TRUE` setting for `remove_empty_acl` removes the ACL when it becomes empty when the wallet ACE is removed.
## Troubleshooting ORA-29024 Errors
The `ORA-29024: Certificate validation failure` error occurs when the facility, component, or product or a failing operation is expecting an Oracle wallet.
You can troubleshoot this error by using the following methods, in this order:
**
- Check is the relevant Oracle documentation for the steps related to the failing configuration. For example, if this error is occurs while using UTL_HTTP, then it means that a secure web site is being accessed without a wallet and this operation needs a wallet created. See Oracle Database PL/SQL Packages and Types Reference for information about using the UTL_HTTP PL/SQL package. In another example, the error can occur while making a remote connection to the database server over a TLS connection, which indicates that this connection is expecting an Oracle wallet. Troubleshooting this problem requires a proper understanding of Oracle Wallets and certificates. See Configuring Transport Layer Security Encryption.
```
orapki wallet display -wallet wallet_file_directory
```
  - Open the wallet using the orapki utility as follows: If this command fails, then it means that the wallet is corrupt. Create a new wallet and recheck the scenario.
  - If the current configuration needs a wallet with a user and trusted certificates, then check whether both the user and trusted certificates are valid and not expired or revoked.
  - If this error occurs while using the wallet with a UTL_HTTP configuration, then check whether all the certificates of the secure web site are there in the wallet and the certificate chain is complete.
  - If there is a proxy server involved, then ensure that the target website is in the proxy allowlist.
See the following My Oracle Support notes for information about getting a complete certificate chain of a secure site for a `UTL_HTTPS` call.
- MOS Note 169768.1, Configuring Wallet Manager to enable HTTPS connections via UTL_HTTP.REQUEST
- MOS Note 230917.1, Troubleshooting the UTL_HTTP Package
## Related Topics
  - Example: Configuring ACL Access Using Passwords in a Non-Shared Wallet
  - Example: Configuring ACL Access for a Wallet in a Shared Database Session
**````````````- Oracle Database Real Application Security Administrator’s and Developer’s Guide for information about additional XS$ACE_TYPE parameters that you can include for the ace parameter setting: granted, inverted, start_date, and end_date **- Oracle Database PL/SQL Packages and Types Reference for detailed information about the UTL_HTTP package
