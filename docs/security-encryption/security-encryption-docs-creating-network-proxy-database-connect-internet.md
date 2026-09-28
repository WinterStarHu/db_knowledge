# Creating a Network Proxy for the Database to Connect with the Internet

This network proxy will enable the Oracle database to reach the Azure AD endpoint.
- About Creating a Network Proxy for the Database to Connect with the Internet The Oracle database must connect to Azure AD endpoints and it may require network configuration and default trust store access.
- Testing the Accessibility of the Azure Endpoint You must ensure that your Oracle Database instance can access the Azure AD endpoint.
- Creating the Network Proxy for the Default Oracle Database Environment To create the network proxy, you must set environment variables and then restart the listener.
- Creating the Network Proxy for an Oracle Real Application Clusters Environment To create the network proxy, you must set an environment variable and then restart the database.
- Creating the Network Proxy in the Windows Registry Editor To create the network proxy in a Windows environment, you must update the Registry Editor (regedit).
## About Creating a Network Proxy for the Database to Connect with the Internet
The Oracle database must connect to Azure AD endpoints and it may require network configuration and default trust store access.
You can configure the database when HTTP network proxy is in place in an enterprise, for a default Oracle Database environment and for an Oracle Real Applications Clusters environment. The database establishes a Transport Layer Security (TLS) link to Azure AD, so it also needs access to the default trust store on the database server. To enable this, ensure that the database server has access to the system default certificate store.
## Testing the Accessibility of the Azure Endpoint
You must ensure that your Oracle Database instance can access the Azure AD endpoint.
For an Oracle database to accept Azure AD `OAuth2` tokens, the database must request the public key from the Azure AD endpoint.
```
SET SERVEROUTPUT ON SIZE 40000
DECLARE
  req UTL_HTTP.REQ;
  resp UTL_HTTP.RESP;
BEGIN
  UTL_HTTP.SET_WALLET(path => 'system:');
  req := UTL_HTTP.BEGIN_REQUEST('https://login.windows.net/common/discovery/keys');
  resp := UTL_HTTP.GET_RESPONSE(req);
  DBMS_OUTPUT.PUT_LINE('HTTP response status code: ' || resp.status_code);
  UTL_HTTP.END_RESPONSE(resp);
END;
/
```
```
ORA-29273: HTTP request failed
ORA-24247: network access denied by access control list (ACL)
```
```
BEGIN
DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
  host => '*',
  ace  =>  xs$ace_type(privilege_list => xs$name_list('connect'),
                       principal_name => 'username_placeholder',
                       principal_type => xs_acl.ptype_db));
END;
/
```
```
BEGIN
DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
  host => '*',
  ace  =>  xs$ace_type(privilege_list => xs$name_list('connect'),
                       principal_name => 'DBA_DEBRA',
                       principal_type => xs_acl.ptype_db));
END;
/
```
  - Set the ACL as follows: Replace username_placeholder with the user name of the database user who is running the test. For example:
  - Try running the test again.
```
BEGIN
DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
  host => '*',
  ace  =>  xs$ace_type(privilege_list => xs$name_list('connect'),
                       principal_name => 'DBA_DEBRA',
                       principal_type => xs_acl.ptype_db));
END;
/
```
  - Remove the ACL, because you now no longer need it. For example, assuming your user name is dba_debra:
If the database cannot connect with the Azure AD endpoint, even after you set the ACL policy, you will most likely need to set the `HTTP_PROXY` package for your database. Review the topics listed in Related Topics, depending if you are using a default Oracle Database environment or an Oracle Real Application Clusters RAC environment. Your network administrator should be able to tell you what the correct `HTTP_PROXY` setting should be.
## Creating the Network Proxy for the Default Oracle Database Environment
To create the network proxy, you must set environment variables and then restart the listener.
You do not need to restart the database.
```
export http_proxy=http://www-proxy-example.com:80/
```
- In the server where the Oracle database is installed, set the http_proxy environment variable. For example:
```
lsnrctl stop
lsnrctl start
```
- Restart the listener.
## Creating the Network Proxy for an Oracle Real Application Clusters Environment
To create the network proxy, you must set an environment variable and then restart the database.
```
http_proxy=http://....:80/
```
```
srvctl setenv database -db db_name -env "http_proxy=http://www-proxy.example.com:80/"
```
- In the server where the Oracle database is installed, set the http_proxy environment variable. Use this syntax to set the network proxies. the proxy command that you enter must have http:// preceding the proxy name and must have the port number at the end of the proxy: For example:
```
$srvctl stop database -db db_name
```
- Stop the database.
```
$ srvctl getenv database -db db_name
```
```
db_name:
http_proxy=http://www-proxy.example.com:80/
https_proxy=http://www-proxy.example.com:80/
```
- Display the environment variable values to ensure that they are correctly set. Output similar to the following should appear:
```
$ srvctl start database -db db_name
```
- Restart the database.
## Creating the Network Proxy in the Windows Registry Editor
To create the network proxy in a Windows environment, you must update the Registry Editor (`regedit`).
- Start the Registry Editor (regedit).
- Locate the \HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\OracleServicerversion key.
****
- Select this key, and then in the right panel, locate Environment.
****
- Edit Environment to add a new multi-string value to it. The following example uses the domain of example.com: Description of the illustration regedit_env.png
****
- Click OK.
```
net start Oracle_service_name
sqlplus "/as sysdba"
startup;
```
- Restart the database server. For example:
```
ALTER PLUGGABLE DATABASE ALL OPEN;
```
- Open the PDBs.
## Related Topics
  - Creating the Network Proxy for an Oracle Real Application Clusters Environment
  - Creating the Network Proxy for an Oracle Real Application Clusters Environment
