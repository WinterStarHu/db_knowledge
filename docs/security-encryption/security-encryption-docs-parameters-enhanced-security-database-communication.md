# Parameters for Enhanced Security of Database Communication

Parameters can be used to manage security, such as handling bad packets from protocol errors or configuring the maximum number of authentication errors.
- Bad Packets Received on the Database from Protocol Errors The SEC_PROTOCOL_ERROR_TRACE_ACTION initialization parameter controls how trace files are managed when protocol errors are generated.
- Controlling Server Execution After Receiving a Bad Packet The SEC_PROTOCOL_ERROR_FURTHER_ACTION initialization parameter controls server execution after the server receives a bad packet.
- Configuration of the Maximum Number of Authentication Attempts The SEC_MAX_FAILED_LOGIN_ATTEMPTS initialization parameter sets the number of authentication attempts before the database will drop a failed connection.
- Configuring the Display of the Database Version Banner The SEC_RETURN_SERVER_RELEASE_BANNER initialization parameter can be used to prevent the display of detailed product information during authentication.
````
- Configuring Banners for Unauthorized Access and Auditing User Actions The SEC_USER_UNAUTHORIZED_ACCESS_BANNER and SEC_USER_AUDIT_ACTION_BANNER initialization parameters control the display of banners for unauthorized access and for auditing users.
## Bad Packets Received on the Database from Protocol Errors
The `SEC_PROTOCOL_ERROR_TRACE_ACTION` initialization parameter controls how trace files are managed when protocol errors are generated.
Networking communication utilities such as Oracle Call Interface (OCI) or Two-Task Common (TTC) can generate a large disk file containing the stack trace and heap dump when the server receives a bad packet, out-of-sequence packet, or a private or an unused remote procedure call.
Typically, this disk file can grow quite large. An intruder can potentially cripple a system by repeatedly sending bad packets to the server, which can result in disk flooding and Denial of Service (DOS) attacks. An unauthenticated client can also mount this type of attack.
You can prevent these attacks by setting the `SEC_PROTOCOL_ERROR_TRACE_ACTION` initialization parameter to one of the following values:
- None: Configures the server to ignore the bad packets and does not generate any trace files or log messages. Use this setting if the server availability is overwhelmingly more important than knowing that bad packets are being received. For example:
```
SEC_PROTOCOL_ERROR_TRACE_ACTION = None
```
- Trace (default setting): Creates the trace files, but it is useful for debugging purposes, for example, when a network client is sending bad packets as a result of a bug. For example:
```
SEC_PROTOCOL_ERROR_TRACE_ACTION = Trace
```
- Log: Writes a short, one-line message to the server trace file. This choice balances some level of auditing with system availability. For example:
```
SEC_PROTOCOL_ERROR_TRACE_ACTION = Log
```
- Alert: Sends an alert message to a database administrator or monitoring console. For example:
```
SEC_PROTOCOL_ERROR_TRACE_ACTION = Alert
```
## Controlling Server Execution After Receiving a Bad Packet
The `SEC_PROTOCOL_ERROR_FURTHER_ACTION` initialization parameter controls server execution after the server receives a bad packet.
After Oracle Database detects a client or server protocol error, it must continue execution. However, this could subject the server to further bad packets, which could lead to disk flooding or denial-of-service attacks.
  - Continue: Continues the server execution. However, be aware that the server may be subject to further attacks. For example:
```
SEC_PROTOCOL_ERROR_FURTHER_ACTION = Continue
```
****
- (Delay,m): Delays the client m seconds before the server can accept the next request from the same client connection. This setting prevents malicious clients from excessively using server resources while legitimate clients experience a degradation in performance but can continue to function. When you enter this setting, enclose it in parentheses. For example:
```
SEC_PROTOCOL_ERROR_FURTHER_ACTION = (Delay,3)
```
```
If you are setting `SEC_PROTOCOL_ERROR_FURTHER_ACTION` by using the `ALTER SYSTEM` or `ALTER SESSION` SQL statement, then you must enclose the `Delay` setting in either single or double quotation marks.
```
```
ALTER SYSTEM SEC_PROTOCOL_ERROR_FURTHER_ACTION = '(Delay,3)';
```
****````
- (Drop,n): Forcefully terminates the client connection after n bad packets. This setting enables the server to protect itself at the expense of the client, for example, loss of a transaction. However, the client can still reconnect, and attempt the same operation again. Enclose this setting in parentheses. The default value of SEC_PROTOCOL_ERROR_FURTHER_ACTION is (Drop,3). For example:
```
SEC_PROTOCOL_ERROR_FURTHER_ACTION = (Drop,10)
```
```
Similar to the `Delay` setting, you must enclose the `Drop` setting in single or double quotation marks if you are using `ALTER SYSTEM` or `ALTER SESSION` to change this setting.
```
## Configuration of the Maximum Number of Authentication Attempts
The `SEC_MAX_FAILED_LOGIN_ATTEMPTS` initialization parameter sets the number of authentication attempts before the database will drop a failed connection.
As part of connection creation, the listener starts the server process and attaches it to the client. Using this physical connection, the client is this able to authenticate the connection. After a server process starts, client authenticates with this server process. An intruder could start a server process, and then issue an unlimited number of authenticated requests with different user names and passwords in an attempt to gain access to the database.
You can limit the number of failed login attempts for application connections by setting the `SEC_MAX_FAILED_LOGIN_ATTEMPTS` initialization parameter to restrict the number of authentication attempts on a connection. After the specified number of authentication attempts fail, the database process drops the connection and the server process is terminated. By default, `SEC_MAX_FAILED_LOGIN_ATTEMPTS` is set to `3`.
Remember that the `SEC_MAX_FAILED_LOGIN_ATTEMPTS` initialization parameter is designed to prevent potential intruders from attacking your applications, as well as valid users who have forgotten their passwords. The `sqlnet.ora` `INBOUND_CONNECT_TIMEOUT` parameter and the `FAILED_LOGIN_ATTEMPTS` profile parameter also restrict failed logins, but the difference is that these two parameters only apply to valid user accounts.
For example, to limit the maximum attempts to 5, set `SEC_MAX_FAILED_LOGIN_ATTEMPTS` as follows in the `init`*sid*`.ora` initialization parameter file:
```
SEC_MAX_FAILED_LOGIN_ATTEMPTS = 5
```
## Configuring the Display of the Database Version Banner
The `SEC_RETURN_SERVER_RELEASE_BANNER` initialization parameter can be used to prevent the display of detailed product information during authentication.
Detailed product version information should not be accessible before a client connection (including an Oracle Call Interface client) is authenticated. An intruder could use the database version to find information about security vulnerabilities that may be present in the database software.
````**``````
````
- To restrict the display of the database version banner to unauthenticated clients, set the SEC_RETURN_SERVER_RELEASE_BANNER initialization parameter in the initsid.ora initialization parameter file to either TRUE or FALSE. By default, SEC_RETURN_SERVER_RELEASE_BANNER is set to FALSE.
For example, if you set it to `TRUE`, then Oracle Database displays the full correct database version. For example, for Release 19.1.0.0:
```
Oracle Database 19c Enterprise Edition Release 19.1.0.0 - Production
```
If a release number uses point release notation (for example, Oracle Database Release 19.1.0.1), then the banner displays as follows:
```
Oracle Database 19c Enterprise Edition Release 19.1.0.1 - Production
```
However, if in that same release, you set it to `NO`, then Oracle Database restricts the banner to display the following fixed text starting with Release 19.1, which instead of 19.1.0.1 is 19.1.0.0.0:
```
Oracle Database 19c Release 19.1.0.0.0 - Production
```
## Configuring Banners for Unauthorized Access and Auditing User Actions
The `SEC_USER_UNAUTHORIZED_ACCESS_BANNER` and `SEC_USER_AUDIT_ACTION_BANNER` initialization parameters control the display of banners for unauthorized access and for auditing users.
You should create and configure banners to warn users against unauthorized access and possible auditing of user actions. The notices are available to the client application when it logs into the database.
  - SEC_USER_UNAUTHORIZED_ACCESS_BANNER. For example:
```
SEC_USER_UNAUTHORIZED_ACCESS_BANNER = /opt/Oracle/12c/dbs/unauthaccess.txt
```
  - SEC_USER_AUDIT_ACTION_BANNER. For example:
```
SEC_USER_AUDIT_ACTION_BANNER = /opt/Oracle/12c/dbs/auditactions.txt
```
By default, these parameters are not set. In addition, be aware that there is a 512-byte limitation for the number of characters used for the banner text.
After you set these parameters, the Oracle Call Interface application must use the appropriate OCI APIs to retrieve these banners and present them to the end user.
