# Configuring Access Control for External Network Services

The `DBMS_NETWORK_ACL` packages configures access control for external network services.
- Syntax for Configuring Access Control for External Network Services You can use the DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE procedure to grant the access control privileges to a user.
- Enabling the Listener to Recognize Access Control for External Network Services A TNS-01166: Listener rejected registration or update of service ACL error can result if the listener is not configured to recognize access control for external network services.
- Example: Configuring Access Control for External Network Services The DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE procedure can configure access control for external network services.
- Revoking Access Control Privileges for External Network Services You can remove access control privileges for external network services.
- Example: Revoking External Network Services Privileges The DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE procedure can be used to revoke external network privileges.
## Syntax for Configuring Access Control for External Network Services
You can use the `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE` procedure to grant the access control privileges to a user.
This procedure appends an access control entry (ACE) with the specified privilege to the ACL for the given host, and creates the ACL if it does not exist yet. The resultant configuration resides in the `SYS` schema, not the schema of the user who created it.
The syntax is as follows:
```
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE (
  host         => 'host_name',
  lower_port   => null|port_number,
  upper_port   => null|port_number,
  ace          => ace_definition);
END;
```
In this specification:
  - host: Enter the name of the host. It can be the host name or an IP address of the host. You can use a wildcard to specify a domain or an IP subnet. (See Precedence Order for a Host Computer in Multiple Access Control List Assignments for the precedence order when you use wildcards in domain names.) The host or domain name is case insensitive. Examples are as follows:
```
host     => 'www.example.com',
host     => '*example.com',
```
````````
- lower_port: (Optional) For TCP connections, enter the lower boundary of the port range. Use this setting for the connect privilege only. Omit it for the resolve privilege. The default is null, which means that there is no port restriction (that is, the ACL applies to all ports). The range of port numbers is between 1 and 65535. For example:
```
lower_port => 80,
```
````````
- upper_port: (Optional) For TCP connections, enter the upper boundary of the port range. Use this setting for connect privileges only. Omit it for the resolve privilege. The default is null, which means that there is no port restriction (that is, the ACL applies to all ports). The range of port numbers is between 1 and 65535 For example:
```
upper_port => 3999);
```
If you enter a value for the `lower_port` and leave the `upper_port` at `null` (or just omit it), then Oracle Database assumes the `upper_port` setting is the same as the `lower_port`. For example, if you set `lower_port` to `80` and omit `upper_port`, the `upper_port` setting is assumed to be `80`.
The `resolve` privilege in the access control list has no effect when a port range is specified in the access control list assignment.
  ````- ace: Define the ACE by using the XS$ACE_TYPE constant, in the following format:
```
ace    => xs$ace_type(privilege_list => xs$name_list('privilege'), principal_name => 'user_or_role', principal_type => xs$ace_type_user));
```
In this specification:
````
````````````````
``````
  - http: Makes an HTTP request to a host through the UTL_HTTP package and the HttpUriType type
``````````
  - http_proxy: Makes an HTTP request through a proxy through the UTL_HTTP package and the HttpUriType type. You must include http_proxy in conjunction to the http privilege if the user makes the HTTP request through a proxy.
``````
  - smtp: Sends SMTP to a host through the UTL_SMTP and UTL_MAIL packages
````
  - resolve: Resolves a network host name or IP address through the UTL_INADDR package
``````````````
  - connect: Grants the user permission to connect to a network service at a host through the UTL_TCP, UTL_SMTP, UTL_MAIL, UTL_HTTP, and DBMS_LDAP packages, or the HttpUriType type
  - jdwp: Used for Java Debug Wire Protocol debugging operations for Java or PL/SQL stored procedures. See Configuring Network Access for Java Debug Wire Protocol Operations for more information.
````
- principal_name: Enter a database user name or role. This value is case insensistive, unless you enter it in double quotation marks (for example, '"ACCT_MGR'").
``````````
- principal_type: Enter XS_ACL.PTYPE_DB for a database user or role. You must specify PTYPE_DB because the principal_type value defaults to PTYPE_XS, which is used to specify an Oracle Database Real Application Security application user.
## Enabling the Listener to Recognize Access Control for External Network Services
A `TNS-01166: Listener rejected registration or update of service ACL` error can result if the listener is not configured to recognize access control for external network services.
```
LOCAL_REGISTRATION_ADDRESS_LISTENER = ON
```
- Add the following line to the listener.ora file:
```
./lsnrctl stop
./lsnrctl start
```
- Restart the listener.
## Example: Configuring Access Control for External Network Services
The `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE` procedure can configure access control for external network services.
Example 10-1 shows how to grant the `http` and `smtp` privileges to the `acct_mgr` database role for an ACL created for the host `www.example.com`.
Example 10-1 Granting Privileges to a Database Role External Network Services
```
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
  host       => 'www.example.com',
  ace        =>  xs$ace_type(privilege_list => xs$name_list('http', 'smtp'),
                             principal_name => 'acct_mgr',
                             principal_type => xs_acl.ptype_db));
END;
/
```
## Revoking Access Control Privileges for External Network Services
You can remove access control privileges for external network services.
  - To revoke access control privileges for external network services, run the DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE procedure.
## Example: Revoking External Network Services Privileges
The `DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE` procedure can be used to revoke external network privileges.
Example 10-2 shows how to revoke external network privileges.
Example 10-2 Revoking External Network Services Privileges
```
BEGIN
 DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE (
  host       => 'www.example.com',
  lower_port => 80,
  upper_port => upper_port => 3999,
  ace        => xs$ace_type(privilege_list => xs$name_list('http', 'smtp'),
                            principal_name => 'acct_mgr',
                            principal_type => xs_acl.ptype_db),
  remove_empty_acl => TRUE);
END;
/
```
In this specification, the `TRUE` setting for `remove_empty_acl` removes the ACL when it becomes empty when the ACE is removed.
## Related Topics
**````````````- Oracle Database Real Application Security Administrator’s and Developer’s Guide for information about additional XS$ACE_TYPE parameters that you can include for the ace parameter setting: granted, inverted, start_date, and end_date **- Oracle Database PL/SQL Packages and Types Reference for more information about the DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE procedure
