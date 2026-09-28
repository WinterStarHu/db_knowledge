# RADIUS Parameters

Oracle provides a set of RADIUS-specific parameters.
- RADIUS Parameters for Clients and Servers Oracle Database provides client and server parameters for using RADIUS authentication.
````
- Minimum RADIUS Parameters At minimum, you should use the SQLNET.AUTHENTICATION_SERVICES and SQLNET.RADIUS_AUTHENTICATION parameters.
- Initialization File Parameter for RADIUS For RADIUS, you should set the OS_AUTHENT_PREFIX initialization parameter.
## RADIUS Parameters for Clients and Servers
Oracle Database provides client and server parameters for using RADIUS authentication.
The following table lists parameters to insert into the configuration files for clients and servers using RADIUS.

| Parameter | Description |
|---|---|
| SQLNET.AUTHENTICATION_SERVICES | Enables one or more authentication services |
| SQLNET.RADIUS_ALTERNATE | Specifies an alternate RADIUS server if the primary server is unavailable |
| SQLNET.RADIUS_ALTERNATE_PORT | Specifies the listening port of the alternate RADIUS server |
| SQLNET.RADIUS_ALTERNATE_RETRIES | Specifies the number of times that the database resends messages to alternate RADIUS servers |
| SQLNET.RADIUS_ALTERNATE_TIMEOUT | Sets the time for an alternate RADIUS server to wait for a response |
| SQLNET.RADIUS_AUTHENTICATION | Specifies a primary RADIUS server location, either by its host name or its IP address |
| SQLNET.RADIUS_AUTHENTICATION_INTERFACE | Specifies the class that contains the user interface for interacting with users |
| SQLNET.RADIUS_AUTHENTICATION_PORT | Specifies the listening port of a primary RADIUS server |
| SQLNET.RADIUS_AUTHENTICATION_RETRIES | Specifies the number of times the database should resend messages to a primary RADIUS server |
| SQLNET.RADIUS_AUTHENTICATION_TIMEOUT | Specifies the amount of time that the database should wait for a response from a primary RADIUS server |
| SQLNET.RADIUS_DEFAULT_CHALLENGE_KEYWORD | Sets the keyword to request a challenge from the RADIUS server |
| SQLNET.RADIUS_CHALLENGE_RESPONSE | Enables or disables challenge responses |
| SQLNET.RADIUS_CLASSPATH | Sets the path for Java classes and the JDK Java libraries |
| SQLNET.RADIUS_SECRET | Specifies the location of a RADIUS secret key |
| SQLNET.RADIUS_SEND_ACCOUNTING | Enable and disables accounting |

## Minimum RADIUS Parameters
At minimum, you should use the `SQLNET.AUTHENTICATION_SERVICES` and `SQLNET.RADIUS_AUTHENTICATION` parameters.
Use the following settings:
```
sqlnet.authentication_services = (radius) sqlnet.radius_authentication   = IP-address-of-RADIUS-server
```
## Initialization File Parameter for RADIUS
For RADIUS, you should set the `OS_AUTHENT_PREFIX` initialization parameter.
For example:
```
OS_AUTHENT_PREFIX=""
```
## Related Topics
  **- Oracle Database Net Services Reference
