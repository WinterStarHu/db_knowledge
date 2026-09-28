# Configuring Network Access for Java Debug Wire Protocol Operations

Before you can debug Java PL/SQL procedures, you must be granted the `jdwp` ACL privilege.
If you want to debug Java PL/SQL procedures in the database through a Java Debug Wire Protocol (JDWP)-based debugger, such as SQL Developer, JDeveloper, or Oracle Developer Tools For Visual Studio (ODT), then you must be granted the `jdwp` ACL privilege to connect your database session to the debugger at a particular host.
The `jdwp` privilege is needed in conjunction with the `DEBUG CONNECT SESSION` system privilege.
If you have not been granted the `jdwp` ACL privilege, then when you try to debug your Java and PL/SQL stored procedures from a remote host, the following errors may appear:
```
ORA-24247: network access denied by access control list (ACL)
ORA-06512: at "SYS.DBMS_DEBUG_JDWP", line line_number
```
  - To configure network access for JDWP operations, use the DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE procedure.
The following example illustrates how to configure network access for JDWP operations.
```
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host         => 'host',
    lower_port   => null|port_number,
    upper_port   => null|port_number,
    ace => xs$ace_type(privilege_list => xs$name_list('jdwp'),
                       principal_name => 'username',
                       principal_type => xs_acl.ptype_db));
END;
/
```
In this specification:
**
- host can be a host name, domain name, IP address, or subnet.
**````
- port_number enables you to specify a range of ports. If you want to use any port, then omit the lower_port and upper_port values.
**
- username is case-insensitive unless it is quoted (for example, principal_name => '"PSMITH"').
## Related Topics
**- Oracle Database Java Developer’s Guide for more information about debugging server applications with JDWP **- Oracle SQL Developer User’s Guide for information about remote debugging in SQL Developer
