# Configuring Interoperability with a Windows 2008 Domain Controller KDC

You can configure Oracle Database to interoperate with a Microsoft Windows 2008 domain controller key distribution center (KDC).
- About Configuring Interoperability with a Microsoft Windows Server Domain Controller KDC Oracle Database complies with MIT Kerberos.
- Step 1: Configure Oracle Kerberos Client for Windows 2008 Domain Controller You can configure the Oracle Kerberos client to interoperate with a Microsoft Windows 2008 Domain Controller KDC.
- Step 2: Configure a Microsoft Windows Server Domain Controller KDC for the Oracle Client Next, you are ready to configure a Microsoft Windows Server Domain Controller KDC to interoperate with an Oracle Client.
- Step 3: Configure Oracle Database for a Microsoft Windows Server Domain Controller KDC You must configure the Oracle database for the domain controller on the host computer where the Oracle database is installed.
- Step 4: Obtain an Initial Ticket for the Kerberos/Oracle User Before a client can connect to the database, the client must request an initial ticket.
## About Configuring Interoperability with a Microsoft Windows Server Domain Controller KDC
Oracle Database complies with MIT Kerberos.
This enables Oracle Database to interoperate with tickets that are issued by a Kerberos Key Distribution Center (KDC) on a Microsoft Windows Server domain controller. This process enables Kerberos authentication with an Oracle database.
## Step 1: Configure Oracle Kerberos Client for Windows 2008 Domain Controller
You can configure the Oracle Kerberos client to interoperate with a Microsoft Windows 2008 Domain Controller KDC.
- Step 1A: Create the Client Kerberos Configuration Files You must configure a set of client Kerberos configuration files that refer to the Windows 2008 domain controller as the Kerberos KDC.
- Step 1B: Specify the Oracle Configuration Parameters in the sqlnet.ora File Configuring an Oracle client to interoperate with a Microsoft Windows Server Domain Controller Kerberos Key Distribution Center (KDC) uses the same sqlnet.ora file parameters that are used for configuring Kerberos on the client and on the database server.
- Step 1C: Optionally, Specify Additional Kerberos Principals Using tnsnames.ora You can configure additional Kerberos principal users to connect from an Oracle Database client.
- Step 1D: Specify the Listening Port Number The Microsoft Windows Server domain controller KDC listens on UDP/TCP port 88.
### Step 1A: Create the Client Kerberos Configuration Files
You must configure a set of client Kerberos configuration files that refer to the Windows 2008 domain controller as the Kerberos KDC.
````````````
****
  - krb.conf file For example:
```
SALES3854.US.EXAMPLE.COM SALES3854.US.EXAMPLE.COM sales3854.us.example.com admin server
```
****
- krb5.conf file For example:
```
[libdefaults] default_realm=SALES.US.EXAMPLE.COM [realms] SALES.US.EXAMPLE.COM= { kdc=sales3854.us.example.com:88 } [domain_realm] .us.example.com=SALES.US.EXAMPLE.COM
```
****
- krb5.realms file For example:
```
us.example.com SALES.US.EXAMPLE.COM
```
### Step 1B: Specify the Oracle Configuration Parameters in the sqlnet.ora File
Configuring an Oracle client to interoperate with a Microsoft Windows Server Domain Controller Kerberos Key Distribution Center (KDC) uses the same `sqlnet.ora` file parameters that are used for configuring Kerberos on the client and on the database server.
  - Set the following parameters in the sqlnet.ora file on the client:
```
SQLNET.KERBEROS5_CONF=pathname_to_Kerberos_configuration_file SQLNET.KERBEROS5_CONF_MIT=TRUE SQLNET.AUTHENTICATION_KERBEROS5_SERVICE=Kerberos_service_name SQLNET.AUTHENTICATION_SERVICES=(BEQ,KERBEROS5)
```
Note the following:
````````
- The SQLNET.KERBEROS5_CONF_MIT parameter has been deprecated, but is retained for backward compatibility for the okint, oklist, and okdstry utilities.
````
- Ensure that the SQLNET.KERBEROS5_CONF_MIT parameter is set to TRUE because the Windows Server operating system is designed to interoperate only with security services that are based on MIT Kerberos version 5.
- If you want to use multiple Kerberos principal users, then you can specify them as part of a connect string or in tnsnames.ora.
### Step 1C: Optionally, Specify Additional Kerberos Principals Using tnsnames.ora
You can configure additional Kerberos principal users to connect from an Oracle Database client.
``````
``````
```
krbuser1 = (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=hostname)(PORT=port_number)) (CONNECT_DATA=(SERVICE_NAME=db.example.com)) (SECURITY=(**KERBEROS5_CC_NAME = /tmp/krbuser1/krb.cc**) (**KERBEROS5_PRINCIPAL = krbprinc1@example.com**))) krbuser2 = (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=hostname)(PORT=port_number)) (CONNECT_DATA=(SERVICE_NAME=db.example.com)) (SECURITY=(**KERBEROS5_CC_NAME = /tmp/krbuser2/krb.cc**) (**KERBEROS5_PRINCIPAL = krbprinc2@example.com**)))
```
- Add the KERBEROS5_CC_NAME and KERBEROS5_PRINCIPAL settings to the tnsnames.ora connect string. KERBEROS5_CC_NAME is mandatory for all additional Kerberos users and principals, but the KERBEROS5_PRINCIPAL setting is optional. Oracle Database checks KERBEROS5_PRINCIPAL against the value that is retrieved from the credential cache. If the two values do not match, then the user is not authenticated. For example:
### Step 1D: Specify the Listening Port Number
The Microsoft Windows Server domain controller KDC listens on UDP/TCP port 88.
  - Ensure that the system file entry for kerberos5 is set to UDP/TCP port 88.
2.
  **Note:**  This step is only required when using the `KERBEROS5PRE` adapter. This step can be skipped when using the `KERBEROS5` adapter. The use of the `KERBEROS5PRE` adapter is deprecated with Oracle Database 21c. Oracle recommends that you use the `KERBEROS5` adapter instead.
```
For the UNIX environment, ensure that the first `kerberos5` entry in the `/etc/services` file is set to 88.
```
## Step 2: Configure a Microsoft Windows Server Domain Controller KDC for the Oracle Client
Next, you are ready to configure a Microsoft Windows Server Domain Controller KDC to interoperate with an Oracle Client.
- Step 2A: Create the User Account You must create a user account for the Microsoft Windows Server Domain Controller KDC.
- Step 2B: Create the Oracle Database Principal User Account and Keytab After you create the user account, you are ready to create the Oracle Database principal user account.
### Step 2A: Create the User Account
You must create a user account for the Microsoft Windows Server Domain Controller KDC.
  - On the Microsoft Windows Server domain controller, create a new user account for the Oracle client in Microsoft Active Directory.
### Step 2B: Create the Oracle Database Principal User Account and Keytab
After you create the user account, you are ready to create the Oracle Database principal user account.
After you create this account on the Windows Server domain controller, you must use the `okcreate` utility to register it with the principal keytab. You can run this utilty on the same KDC to create all the service keytabs rather than creating them individually, or you can run `okcreate` from a service endpoint that connects to the KDC, run the ncessary commands, and then copy the resulting keytab back to the service endpoint.
````
````
- Create a new user account for the Oracle database in Microsoft Active Directory. For example, if the Oracle database runs on the host sales3854.us.example.com, then use Active Directory to create a user with the user name sales3854.us.example.com. Do not create a user as host/hostname.dns.com, such as oracle/sales3854.us.example.com, in Active Directory. Microsoft’s KDC does not support multipart names like an MIT KDC does. An MIT KDC allows multipart names to be used for service principals because it treats all principals as user names. However, Microsoft’s KDC does not.
- Run the okcreate command to create a keytab that will use this user account. The syntax is as follows:
```
okcreate (-s [-u KDCuser@KDCmachine] | -k) [-name service_name] [-hosts path_to_host_list] [-out path_to_output] [-r realm] [-p principal] [-q query] [-d dbname] [-e enc:salt...] [-m] [-x db_args]
```
```
For example:
```
```
okcreate -s -u kdcuser1@kdcmachine1 -name oracle -hosts sales3854.us.example.com -out /OSsecured/keytablocation
```
````
- Copy the extracted keytab file to the host computer where the Oracle database is installed. For example, the keytab that was created in the previous step can be copied to /krb5/v5svrtab.
## Step 3: Configure Oracle Database for a Microsoft Windows Server Domain Controller KDC
You must configure the Oracle database for the domain controller on the host computer where the Oracle database is installed.
- Step 3A: Set Configuration Parameters in the sqlnet.ora File You must first set configuration parameters for the database.
- Step 3B: Create an Externally Authenticated Oracle User After you set the configuration parameters, you are ready to create an externally authenticated Oracle user.
### Step 3A: Set Configuration Parameters in the sqlnet.ora File
You must first set configuration parameters for the database.
  - Specify values for the following parameters in the sqlnet.ora file for the database server:
```
SQLNET.KERBEROS5_CONF=pathname_to_Kerberos_configuration_file
SQLNET.KERBEROS5_KEYTAB=pathname_to_Kerberos_principal/key_table
SQLNET.KERBEROS5_CONF_MIT=TRUE
SQLNET.AUTHENTICATION_KERBEROS5_SERVICE=Kerberos_service_name
SQLNET.AUTHENTICATION_SERVICES=(BEQ,KERBEROS5)
```
```

```
### Step 3B: Create an Externally Authenticated Oracle User
After you set the configuration parameters, you are ready to create an externally authenticated Oracle user.
- Follow the procedure under Step 8: Create an Externally Authenticated Oracle User to create an externally authenticated Oracle user. Ensure that you create the username in all uppercase characters (for example, ORAKRB@SALES.US.EXAMPLE.COM).
## Step 4: Obtain an Initial Ticket for the Kerberos/Oracle User
Before a client can connect to the database, the client must request an initial ticket.
- To request an initial ticket, follow the task information for Step 9: Get an Initial Ticket for the Kerberos/Oracle User. The user does not need to explicitly request for an initial ticket, using the okinit command, when using the Windows native cache. If the Oracle client is running on Microsoft Windows Server or later, then the Kerberos ticket is automatically retrieved when the user logs in to Windows. See also the Microsoft documentation for details about the Kerbtray.exe utility, which can be used to display Kerberos ticket information for a system.
````
```
okinit krbprinc1@example.com
```
- For each Kerberos principal user that you have added to tnsnames.ora, run the okinit command in the client. For example:
## Related Topics
  - Step 6A: Configure Kerberos on the Client and on the Database Server
  - Step 1C: Optionally, Specify Additional Kerberos Principals Using tnsnames.ora
  **- Oracle Database Net Services Reference
  - Microsoft documentation for information about how to create users in Active Directory.
  - Step 6: Configure Kerberos Authentication for information about using Oracle Net Manager to set the sqlnet.ora file parameters.
