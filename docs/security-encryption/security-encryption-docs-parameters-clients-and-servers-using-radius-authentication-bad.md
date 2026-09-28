# Parameters for Clients and Servers Using RADIUS Authentication

Oracle provides parameters for RADIUS authentication.
- sqlnet.ora File Parameters You can include RADIUS-specific parameters in the sqlnet.ora file.
````
- Minimum RADIUS Parameters At minimum, you should use the SQLNET.AUTHENTICATION_SERVICES and SQLNET.RADIUS_AUTHENTICATION parameters.
- Initialization File Parameter for RADIUS For RADIUS, you should set the OS_AUTHENT_PREFIX initialization parameter.
## sqlnet.ora File Parameters
You can include RADIUS-specific parameters in the `sqlnet.ora` file.
- SQLNET.AUTHENTICATION_SERVICES The SQLNET.AUTHENTICATION_SERVICES parameter configures the client or the server to use the RADIUS adapter.
- SQLNET.RADIUS_ALTERNATE The SQLNET.RADIUS_ALTERNATE parameter sets the location of an alternate RADIUS server to be used if the primary server is unavailable for fault tolerance.
- SQLNET.RADIUS_ALTERNATE_PORT The SQLNET.RADIUS_ALTERNATE_PORT parameter sets the listening port for the alternate RADIUS server.
- SQLNET.RADIUS_ALTERNATE_TIMEOUT The SQLNET.RADIUS_ALTERNATE_TIMEOUT parameter sets the time for an alternate RADIUS server to wait for a response.
- SQLNET.RADIUS_ALTERNATE_RETRIES The SQLNET.RADIUS_ALTERNATE_RETRIES parameter sets the number of times that the alternate RADIUS server resends messages.
- SQLNET.RADIUS_AUTHENTICATION The SQLNET.RADIUS_AUTHENTICATION parameter sets the location of the primary RADIUS server, either host name or dotted decimal format.
- SQLNET.RADIUS_AUTHENTICATION_INTERFACE The SQLNET.RADIUS_AUTHENTICATION_INTERFACE parameter sets the name of the Java class that contains the GUI when RADIUS is in challenge-response (asynchronous) mode.
- SQLNET.RADIUS_AUTHENTICATION_PORT The SQLNET.RADIUS_AUTHENTICATION_PORT parameter sets the listening port of the primary RADIUS server.
- SQLNET.RADIUS_AUTHENTICATION_TIMEOUT The SQLNET.RADIUS_AUTHENTICATION_TIMEOUT parameter sets the time to wait for response.
- SQLNET.RADIUS_AUTHENTICATION_RETRIES The SQLNET.RADIUS_AUTHENTICATION_RETRIES parameter sets the number of times to resend authentication information.
- SQLNET.RADIUS_CHALLENGE_RESPONSE The SQLNET.RADIUS_CHALLENGE_RESPONSE parameter turns on or turns off the challenge-response or asynchronous mode support.
- SQLNET.RADIUS_CHALLENGE_KEYWORD The SQLNET.RADIUS_CHALLENGE_KEYWORD parameter sets the keyword to request a challenge from the RADIUS server.
- SQLNET.RADIUS_CLASSPATH The SQLNET.RADIUS_CLASSPATH parameter sets the path for Java classes and the JDK Java libraries.
- SQLNET.RADIUS_SECRET The SQLNET.RADIUS_SECRET parameter specifies the file name and location of the RADIUS secret key.
- SQLNET.RADIUS_SEND_ACCOUNTING The SQLNET.RADIUS_SEND_ACCOUNTING parameter turns accounting on or off.
### SQLNET.AUTHENTICATION_SERVICES
The `SQLNET.AUTHENTICATION_SERVICES` parameter configures the client or the server to use the RADIUS adapter.
The following table describes the `SQLNET.AUTHENTICATION_SERVICES` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.AUTHENTICATION_SERVICES=(radius) |
| Default setting | None |

### SQLNET.RADIUS_ALTERNATE
The `SQLNET.RADIUS_ALTERNATE` parameter sets the location of an alternate RADIUS server to be used if the primary server is unavailable for fault tolerance.
The following table describes the `SQLNET.RADIUS_ALTERNATE` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_ALTERNATE=alternate_RADIUS_server_hostname_or_IP_address |
| Default setting | off |

### SQLNET.RADIUS_ALTERNATE_PORT
The `SQLNET.RADIUS_ALTERNATE_PORT` parameter sets the listening port for the alternate RADIUS server.
The following table describes the `SQLNET.RADIUS_ALTERNATE_PORT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_ALTERNATE_PORT=alternate_RADIUS_server_listening_port_number |
| Default setting | 1645 |

### SQLNET.RADIUS_ALTERNATE_TIMEOUT
The `SQLNET.RADIUS_ALTERNATE_TIMEOUT` parameter sets the time for an alternate RADIUS server to wait for a response.
The following table describes the `SQLNET.RADIUS_ALTERNATE_TIMEOUT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_ALTERNATE_TIMEOUT=time_in_seconds |
| Default setting | 5 |

### SQLNET.RADIUS_ALTERNATE_RETRIES
The `SQLNET.RADIUS_ALTERNATE_RETRIES` parameter sets the number of times that the alternate RADIUS server resends messages.
The following table describes the `SQLNET.RADIUS_ALTERNATE_RETRIES` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_ALTERNATE_RETRIES=n_times_to_resend |
| Default setting | 3 |

### SQLNET.RADIUS_AUTHENTICATION
The `SQLNET.RADIUS_AUTHENTICATION` parameter sets the location of the primary RADIUS server, either host name or dotted decimal format.
If the RADIUS server is on a different computer from the Oracle server, you must specify either the host name or the IP address of that computer.
The following table describes the `SQLNET.RADIUS_AUTHENTICATION` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_AUTHENTICATION=RADIUS_server_IP_address |
| Default setting | localhost |

### SQLNET.RADIUS_AUTHENTICATION_INTERFACE
The `SQLNET.RADIUS_AUTHENTICATION_INTERFACE` parameter sets the name of the Java class that contains the GUI when RADIUS is in challenge-response (asynchronous) mode.
The following table describes the `SQLNET.RADIUS_AUTHENTICATION_INTERFACE` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_AUTHENTICATION_INTERFACE=Java_class_name |
| Default setting | DefaultRadiusInterface (oracle/net/radius/DefaultRadiusInterface) |

### SQLNET.RADIUS_AUTHENTICATION_PORT
The `SQLNET.RADIUS_AUTHENTICATION_PORT` parameter sets the listening port of the primary RADIUS server.
The following table describes the `SQLNET.RADIUS_AUTHENTICATION_PORT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_AUTHENTICATION_PORT=port_number |
| Default setting | 1645 |

### SQLNET.RADIUS_AUTHENTICATION_TIMEOUT
The `SQLNET.RADIUS_AUTHENTICATION_TIMEOUT` parameter sets the time to wait for response.
The following table describes the `SQLNET.RADIUS_AUTHENTICATION_TIMEOUT` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_AUTHENTICATION_TIMEOUT=time_in_seconds |
| Default setting | 5 |

### SQLNET.RADIUS_AUTHENTICATION_RETRIES
The `SQLNET.RADIUS_AUTHENTICATION_RETRIES` parameter sets the number of times to resend authentication information.
The following table describes the `SQLNET.RADIUS_AUTHENTICATION_RETRIES` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_AUTHENTICATION_RETRIES=n_times_to_resend |
| Default setting | 3 |

### SQLNET.RADIUS_CHALLENGE_RESPONSE
The `SQLNET.RADIUS_CHALLENGE_RESPONSE` parameter turns on or turns off the challenge-response or asynchronous mode support.
The following table describes the `SQLNET.RADIUS_CHALLENGE_RESPONSE` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_CHALLENGE_RESPONSE=on |
| Default setting | off |

### SQLNET.RADIUS_CHALLENGE_KEYWORD
The `SQLNET.RADIUS_CHALLENGE_KEYWORD` parameter sets the keyword to request a challenge from the RADIUS server.
The user types no password on the client.
The following table describes the `SQLNET.RADIUS_CHALLENGE_KEYWORD` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_CHALLENGE_KEYWORD=keyword |
| Default setting | challenge |

### SQLNET.RADIUS_CLASSPATH
The `SQLNET.RADIUS_CLASSPATH` parameter sets the path for Java classes and the JDK Java libraries.
If you decide to use the challenge-response authentication mode, then RADIUS presents the user with a Java-based graphical interface requesting first a password, then additional information, for example, a dynamic password that the user obtains from a token card.
Add the `SQLNET.RADIUS_CLASSPATH` parameter in the `sqlnet.ora` file to set the path for the Java classes for that graphical interface, and to set the path to the JDK Java libraries.
The following table describes the `SQLNET.RADIUS_CLASSPATH` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_CLASSPATH=path_to_GUI_Java_classes |
| Default setting | $ORACLE_HOME/jlib/netradius.jar:$ORACLE_HOME/JRE/lib/sparc/native_threads |

### SQLNET.RADIUS_SECRET
The `SQLNET.RADIUS_SECRET` parameter specifies the file name and location of the RADIUS secret key.
The following table describes the `SQLNET.RADIUS_SECRET` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_SECRET=path_to_RADIUS_secret_key |
| Default setting | $ORACLE_HOME/network/security/radius.key |

### SQLNET.RADIUS_SEND_ACCOUNTING
The `SQLNET.RADIUS_SEND_ACCOUNTING` parameter turns accounting on or off.
If you enable accounting, packets will be sent to the active RADIUS server at the listening port plus one. By default, packets are sent to port 1646. You need to turn this feature on only when your RADIUS server supports accounting and you want to keep track of the number of times the user is logging on to the system.
The following table describes the `SQLNET.RADIUS_SEND_ACCOUNTING` parameter attributes.

| Attribute | Description |
|---|---|
| Syntax | SQLNET.RADIUS_SEND_ACCOUNTING=on |
| Default setting | off |

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
