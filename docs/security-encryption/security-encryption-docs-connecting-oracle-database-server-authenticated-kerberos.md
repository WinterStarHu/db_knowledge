# Connecting to an Oracle Database Server Authenticated by Kerberos

After Kerberos is configured, you can connect to an Oracle database server without using a user name or password.
  - Use the following syntax to connect to the database without using a user name or password:
```
$ sqlplus /@net_service_name
```
In this specification, *net_service_name* is an Oracle Net Services service name. For example:
```
$ sqlplus /@oracle_dbname
```
## Related Topics
**- Oracle Database Heterogeneous Connectivity User’s Guide for information about external authentication
