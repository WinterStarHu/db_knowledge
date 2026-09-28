# Checking Privilege Assignments That Affect User Access to Network Hosts

Both administrators and users can check network connection and domain privileges.
- About Privilege Assignments that Affect User Access to Network Hosts Oracle provides DBA-specific data dictionary views to find information about privilege assignments.
- How to Check User Network Connection and Domain Privileges A database administrator can query the DBA_HOST_ACES data dictionary view to find the privileges that have been granted for specific users or roles.
- Example: Administrator Checking User Network Access Control Permissions The DBA_HOST_ACES data dictionary view can check the network access control permissions for users.
- How Users Can Check Their Network Connection and Domain Privileges Users can query the USER_HOST_ACES data dictionary view to check their network and domain permissions.
- Example: User Checking Network Access Control Permissions The USER_HOST_ACES data dictionary view shows network access control permissions for a host computer.
## About Privilege Assignments that Affect User Access to Network Hosts
Oracle provides DBA-specific data dictionary views to find information about privilege assignments.
Database administrators can use the `DBA_HOST_ACES` data dictionary view to query network privileges that have been granted to or denied from database users and roles in the access control lists, and whether those privileges take effect during certain times only Using the information provided by the view, you may need to combine the data to determine if a user is granted the privilege at the current time, the roles the user has, the order of the access control entries, and so on.
Users without database administrator privileges do not have the privilege to access the access control lists or to invoke those `DBMS_NETWORK_ACL_ADMIN` functions. However, they can query the `USER_HOST_ACES` data dictionary view to check their privileges instead.
Database administrators and users can use the following `DBMS_NETWORK_ACL_UTILITY` functions to determine if two hosts, domains, or subnets are equivalent, or if a host, domain, or subnet is equal to or contained in another host, domain, or subnet:
- EQUALS_HOST: Returns a value to indicate if two hosts, domains, or subnets are equivalent
- CONTAINS_HOST: Returns a value to indicate if a host, domain, or subnet is equal to or contained in another host, domain, or subnet, and the relative order of precedence of the containing domain or subnet for its ACL assignments
If you do not use IPv6 addresses, database administrators and users can use the following `DBMS_NETWORK_ACL_UTILITY` functions to generate the list of domains or IPv4 subnet a host belongs to and to sort the access control lists by their order of precedence according to their host assignments:
- DOMAINS: Returns a list of the domains or IP subnets whose access control lists may affect permissions to a specified network host, subdomain, or IP subnet
- DOMAIN_LEVEL: Returns the domain level of a given host
## How to Check User Network Connection and Domain Privileges
A database administrator can query the `DBA_HOST_ACES` data dictionary view to find the privileges that have been granted for specific users or roles.
The `DBA_HOST_ACES` view shows the access control lists that determine the access to the network connection or domain, and then determines if each access control list grants (`GRANTED`), denies (`DENIED`), or does not apply (`NULL`) to the access privilege of the user. Only the database administrator can query this view.
## Example: Administrator Checking User Network Access Control Permissions
The `DBA_HOST_ACES` data dictionary view can check the network access control permissions for users.
Example 10-8 shows how a database administrator can check the privileges for user `preston` to connect to `www.us.example.com`.
In this example, user `preston` was granted privileges for all the network host connections found for `www.us.example.com`. However, suppose `preston` had been granted access to a host connection on port 80, but then denied access to the host connections on ports 3000-3999. In this case, you must configure access control for the host connection on port 80, and a separate access control configuration for the host connection on ports 3000-3999.
Example 10-8 Administrator Checking User Network Access Control Permissions
```
SELECT HOST, LOWER_PORT, UPPER_PORT,
       ACE_ORDER, PRINCIPAL, PRINCIPAL_TYPE,
       GRANT_TYPE, INVERTED_PRINCIPAL, PRIVILEGE,
       START_DATE, END_DATE
  FROM (SELECT ACES.*,
DBMS_NETWORK_ACL_UTILITY.CONTAINS_HOST('www.us.example.com', HOST) PRECEDENCE
          FROM DBA_HOST_ACES ACES)
 WHERE PRECEDENCE IS NOT NULL
 ORDER BY PRECEDENCE DESC,
          LOWER_PORT NULLS LAST,
          UPPER_PORT NULLS LAST,
          ACE_ORDER;
HOST               LOWER_PORT UPPER_PORT ACE_ORDER PRINCIPAL PRINCIPAL_TYPE   GRANT_TYPE INVERTED_PRINCIPAL PRIVILEGE START_DATE END_DATE
------------------ ---------- ---------- --------- --------- ---------------- ---------- ------------------ --------- ---------- --------
www.us.example.com         80        80          1 PRESTON DATABASE USER      GRANT      NO                 HTTP
www.us.example.com         80        80          2 SEBASTIAN DATABASE USER    GRANT      NO                 HTTP
*.us.example.com                                 1 ACCT_MGR DATABASE USER     GRANT      NO                 CONNECT
* 1 HR_DBA DATABASE USER       GRANT      NO                 CONNECT
* 1 HR_DBA DATABASE USER       GRANT      NO                 RESOLVE
```
## How Users Can Check Their Network Connection and Domain Privileges
Users can query the `USER_HOST_ACES` data dictionary view to check their network and domain permissions.
The `USER_HOST_ACES` view is `PUBLIC`, so all users can query it.
This view hides the access control lists from the user. It evaluates the permission status for the user (`GRANTED` or `DENIED`) and filters out the `NULL` case because the user does not need to know when the access control lists do not apply to him or her. In other words, Oracle Database only shows the user on the network hosts that explicitly grant or deny access to him or her. Therefore, the output does not display the `*.example.com` and `*` that appear in the output from the database administrator-specific `DBA_HOST_ACES` view.
## Example: User Checking Network Access Control Permissions
The USER_HOST_ACES data dictionary view shows network access control permissions for a host computer.
Example 10-9 shows how user `preston` can check her privileges to connect to `www.us.example.com`.
Example 10-9 User Checking Network Access Control Permissions
```
SELECT HOST, LOWER_PORT, UPPER_PORT, PRIVILEGE, STATUS
  FROM (SELECT ACES.*,
DBMS_NETWORK_ACL_UTILITY.CONTAINS_HOST('www.us.example.com', HOST) PRECEDENCE
          FROM USER_HOST_ACES ACES)
 WHERE PRECEDENCE IS NOT NULL
 ORDER BY PRECEDENCE DESC,
          LOWER_PORT NULLS LAST,
          UPPER_PORT NULLS LAST;
HOST               LOWER_PORT UPPER_PORT PRIVILEGE STATUS
------------------ ---------- ---------- --------- -------
www.us.example.com         80        80  HTTP      GRANTED
```
