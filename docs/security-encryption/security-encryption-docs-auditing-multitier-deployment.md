# Auditing SQL Statements and Privileges in a Multitier Environment

You can create a unified audit policy to audit the activities of a client in a multitier environment.
In a multitier environment, Oracle Database preserves the identity of a client through all tiers. Thus, you can audit actions taken on behalf of the client by a middle-tier application, by using the `BY` *user* clause in the `AUDIT` statement for your policy. The audit applies to all user sessions, including proxy sessions.
The middle tier can also set the user client identity in a database session, enabling the auditing of end-user actions through the middle-tier application. The end-user client identity then shows up in the audit trail.
For example, suppose the proxy user `apphr` can connect as user `jackson`. The policy and enablement can be as follows:
```
CREATE AUDIT POLICY prox_pol ACTIONS LOGON;
AUDIT POLICY prox_pol BY jackson;
```
You can audit user activity in a multitier environment. Once audited, you can verify these activities by querying the `UNIFIED_AUDIT_TRAIL` data dictionary view. For example:
```
SELECT DBUSERNAME, DB_PROXY_USERNAME, PROXY_SESSIONID, ACTION_NAME
FROM UNIFIED_AUDIT_TRAIL
WHERE DBPROXY_USERNAME IS NOT NULL;
```
Output similar to the following appears:
```
DBUSERNAME  DBPROXY_USERNAME  PROXY_SESSIONID  ACTION_NAME
----------  ----------------  ---------------  -----------
JACKSON     APPHR             1214623540       LOGON
```
The following figure illustrates how you can audit proxy users by querying the `PROXY_SESSIONID`, `ACTION_NAME`, and `SESSION_ID` columns of the `UNIFIED_AUDIT_TRAIL` view. In this scenario, both the database user and proxy user accounts are known to the database. Session pooling can be used.
Description of the illustration dbseg_vm_004.png The following figure illustrates how you can audit client identifier information across multiple database sessions by querying the `CLIENT_ID` column of the `DBA_AUDIT_TRAIL` data dictionary view. In this scenario, the client identifier has been set to `CLIENT_A`. As with the proxy user-database user scenario, session pooling can be used.
Description of the illustration dbseg_vm_003.png
## Related Topics
  - Preserving User Identity in Multitiered Environments
