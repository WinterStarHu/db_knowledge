# SYS_CONTEXT

## Syntax
Description of the illustration sys_context.gif Description of the illustration sys_context.eps
## Purpose
`SYS_CONTEXT` returns the value of *parameter* associated with the context *namespace* at the current instant. You can use this function in both SQL and PL/SQL statements. `SYS_CONTEXT` must be executed locally.
For *namespace* and *parameter*, you can specify either a string or an expression that resolves to a string designating a namespace or an attribute. If you specify literal arguments for *namespace* and *parameter*, and you are using `SYS_CONTEXT` explicitly in a SQL statement-rather than in a PL/SQL function that in turn is in mentioned in a SQL statement-then Oracle Database evaluates `SYS_CONTEXT` only once per SQL statement execution for each call site that invokes the `SYS_CONTEXT` function.
The context *namespace* must already have been created, and the associated *parameter* and its value must also have been set using the `DBMS_SESSION`.`set_context` procedure. The *namespace* must be a valid identifier. The *parameter* name can be any string. It is not case sensitive, but it cannot exceed 30 bytes in length.
The data type of the return value is `VARCHAR2`. The default maximum size of the return value is 256 bytes. You can override this default by specifying the optional *length* parameter, which must be a `NUMBER` or a value that can be implicitly converted to `NUMBER`. The valid range of values is 1 to 4000 bytes. If you specify an invalid value, then Oracle Database ignores it and uses the default.
Oracle provides the following built-in namespaces:
````
- USERENV - Describes the current session. The predefined parameters of namespace USERENV are listed in Table 7-11.
`SYS_SESSION_ROLES` - Indicates whether a specified role is currently enabled for the session. Oracle Database evaluates the `SYS_SESSION_ROLES` context for thecurrent user, and assumes the defining user’s role when it evaluates `SYS_SESSION_ROLES` within a definer’s rights procedure or function. An alternative to using `SYS_SESSION_ROLES` to find the login user’s enabled roles in a definer’s rights procedure is to use `DBMS_SESSION:SESSION_IS_ROLE_ENABLED` function.Invoker’srights, procedures or functions, and/or code based access control (CBAC) are also alternatives.
**See Also:**
**
- Oracle Database Security Guide for information on using the application context feature in your application development
- CREATE CONTEXT for information on creating user-defined context namespaces
**````
- Oracle Database PL/SQL Packages and Types Reference for information on the DBMS_SESSION.set_context procedure
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of SYS_CONTEXT
## Examples
The following statement returns the name of the user who logged onto the database:
```
CONNECT OE Enter password: password SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') FROM DUAL;
SYS_CONTEXT ('USERENV', 'SESSION_USER')
---------------------------------------
OE
```
The following example queries the `SESSION_ROLES` data dictionary view to show that `RESOURCE` is the only role currently enabled for the session. It then uses the `SYS_CONTEXT` function to show that the `RESOURCE` role is currently enabled for the session and the `DBA` role is not.
```
CONNECT OE Enter password: password SELECT role FROM session_roles;
ROLE
--------
RESOURCE SELECT SYS_CONTEXT('SYS_SESSION_ROLES', 'RESOURCE') FROM DUAL SYS_CONTEXT('SYS_SESSION_ROLES','RESOURCE')
--------------------------------------
TRUE SELECT SYS_CONTEXT('SYS_SESSION_ROLES', 'DBA') FROM DUAL;
SYS_CONTEXT('SYS_SESSION_ROLES','DBA')
--------------------------------------
FALSE
```
**Note:**   For simplicity in demonstrating this feature, these examples do not perform the password management techniques that a deployed system normally uses. In a production environment, follow the Oracle Database password management guidelines, and disable any sample accounts. See *Oracle Database Security Guide* for password management guidelines and other security recommendations.
The following hypothetical example returns the group number that was set as the value for the attribute `group_no` in the PL/SQL package that was associated with the context `hr_apps` when `hr_apps` was created:
```
SELECT SYS_CONTEXT ('hr_apps', 'group_no') "User Group" FROM DUAL;
```
Table 11 Predefined Parameters of Namespace USERENV

| Parameter | Return Value |
|---|---|
| ACTION | Identifies the position in the module (application name) and is set through the DBMS_APPLICATION_INFO package or OCI. |
| IS_APPLICATION_ROOT | Identifies whether or not an application is the application root. |
| IS_APPLICATION_PDB | Identifies whether or not a container is an Application PDB . |
| AUDITED_CURSORID | Returns the cursor ID of the SQL that triggered the audit. This parameter is not valid in a fine-grained auditing environment. If you specify it in such an environment, then Oracle Database always returns null. |
| AUTHENTICATED_IDENTITY | Returns the identity used in authentication. In the list that follows, the type of user is followed by the value returned: Kerberos-authenticated enterprise user: kerberos principal nameKerberos-authenticated external user : kerberos principal name; same as the schema nameSSL-authenticated enterprise user: the DN in the user's PKI certificateSSL-authenticated external user: the DN in the user's PKI certificatePassword-authenticated enterprise user: nickname; same as the login namePassword-authenticated database user: the database username; same as the schema nameOS-authenticated external user: the external operating system user nameRadius-authenticated external user: the schema nameProxy with DN : Oracle Internet Directory DN of the clientProxy with certificate: certificate DN of the clientProxy with username: database user name if client is a local database user; nickname if client is an enterprise user.SYSDBA/SYSOPER using Password File: login name SYSDBA/SYSOPER using OS authentication: operating system user name Password-authenticated OCI IAM user: IAM user name; same as the login name IAM token-authenticated enterprise user: IAM user name |
| AUTHENTICATION_DATA | Data being used to authenticate the login user. For X.503 certificate authenticated sessions, this field returns the context of the certificate in HEX2 format.Note: You can change the return value of the AUTHENTICATION_DATA attribute using the length parameter of the syntax. Values of up to 4000 are accepted. This is the only attribute of USERENV for which Oracle Database implements such a change. |
| AUTHENTICATION_METHOD | Returns the method of authentication. In the list that follows, the type of user is followed by the method returned: Password-authenticated enterprise user, local database user, or user with the SYSDBA or SYSOPER administrative privilege using a password file; proxy with username using password: PASSWORDPassword-authenticated enterprise user, OCI IAM user, local database user, or user with the SYSDBA or SYSOPER administrative privilege using a password file; proxy with username using password: PASSWORD_GLOBALOCI IAM token-authenticated enterprise user: TOKEN_GLOBALKerberos-authenticated enterprise user or external user (with no administrative privileges): KERBEROSKerberos-authenticated enterprise user (with administrative privileges): KERBEROS_GLOBALKerberos-authenticated external user (with administrative privileges): KERBEROS_EXTERNALSSL-authenticated enterprise or external user (with no administrative privileges): SSLSSL-authenticated enterprise user (with administrative privileges): SSL_GLOBALSSL-authenticated external user (with administrative privileges): SSL_EXTERNALRadius-authenticated external user: RADIUSOS-authenticated external user or use with the SYSDBA or SYSOPER administrative privilege: OSProxy with certificate, DN, or username without using password: NONEBackground process (job queue slave process): JOBParallel Query Slave process: PQ_SLAVEFor non-administrative connections, you can use IDENTIFICATION_TYPE to distinguish between external and enterprise users when the authentication method is PASSWORD, KERBEROS, or SSL. For administrative connections, AUTHENTICATION_METHOD is sufficient for the PASSWORD, SSL_EXTERNAL, and SSL_GLOBAL authentication methods. |
| BG_JOB_ID | Job ID of the current session if it was established by an Oracle Database background process. Null if the session was not established by a background process. |
| CDB_DOMAIN | CDB_DOMAIN is the DB_DOMAIN of the CDB and is the same for all the PDBs associated with it. |
| CDB_NAME | If queried while connected to a multitenant container database (CDB), returns the name of the CDB. Otherwise, returns null. |
| CLIENT_IDENTIFIER | Returns an identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER procedure, the OCI attribute OCI_ATTR_CLIENT_IDENTIFIER, or Oracle Dynamic Monitoring Service (DMS). This attribute is used by various database components to identify lightweight application users who authenticate as the same database user. |
| CLIENT_INFO | Returns up to 64 bytes of user session information that can be stored by an application using the DBMS_APPLICATION_INFO package. |
| CLIENT_PROGRAM_NAME | The name of the program used for the database session. |
| CON_ID | If queried when connected to an Oracle Database with pluggable databases enabled, returns the current container ID that the session is connected to.If queried when connected to an Oracle Database running in non-CDB mode, returns 0. |
| CON_NAME | If queried while connected to a CDB, returns the current container name. Otherwise, returns the name of the database as specified in the DB_NAME initialization parameter. |
| CURRENT_BIND | The bind variables for fine-grained auditing. You can specify this attribute only inside the event handler for the fine-grained auditing feature. |
| CURRENT_EDITION_ID | The identifier of the current edition. |
| CURRENT_EDITION_NAME | The name of the current edition. |
| CURRENT_SCHEMA | The name of the currently active default schema. This value may change during the duration of a session through use of an ALTER SESSION SET CURRENT_SCHEMA statement. This may also change during the duration of a session to reflect the owner of any active definer's rights object. When used directly in the body of a view definition, this returns the default schema used when executing the cursor that is using the view; it does not respect views used in the cursor as being definer's rights.Note: Oracle recommends against issuing the SQL statement ALTER SESSION SET CURRENT_SCHEMA from within all types of stored PL/SQL units except logon triggers. |
| CURRENT_SCHEMAID | Identifier of the currently active default schema. |
| CURRENT_SQLCURRENT_SQLn | CURRENT_SQL returns the first 4K bytes of the current SQL that triggered the fine-grained auditing event. The CURRENT_SQLn attributes return subsequent 4K-byte increments, where n can be an integer from 1 to 7, inclusive. CURRENT_SQL1 returns bytes 4K to 8K; CURRENT_SQL2 returns bytes 8K to 12K, and so forth. You can specify these attributes only inside the event handler for the fine-grained auditing feature. |
| CURRENT_SQL_LENGTH | The length of the current SQL statement that triggers fine-grained audit or row-level security (RLS) policy functions or event handlers. You can specify this attribute only inside the event handler for the fine-grained auditing feature. |
| CURRENT_USER | The name of the database user whose privileges are currently active. This may change during the duration of a database session as Real Application Security sessions are attached or detached, or to reflect the owner of any active definer's rights object. When no definer's rights object is active, CURRENT_USER returns the same value as SESSION_USER. When used directly in the body of a view definition, this returns the user that is executing the cursor that is using the view; it does not respect views used in the cursor as being definer's rights. For enterprise users, returns schema. If a Real Application Security user is currently active, returns user XS$NULL.See Also: Oracle Database 2 Day + Security Guide for more information on user XS$NULL |
| CURRENT_USERID | The identifier of the database user whose privileges are currently active. |
| DATABASE_ROLE | The database role using the SYS_CONTEXT function with the USERENV namespace. The role is one of the following: PRIMARY, PHYSICAL STANDBY, LOGICAL STANDBY, SNAPSHOT STANDBY. |
| DB_DOMAIN | Domain of the database as specified in the DB_DOMAIN initialization parameter. |
| DB_NAME | Name of the database as specified in the DB_NAME initialization parameter. |
| DB_SUPPLEMENTAL_LOG_LEVEL | If supplemental logging is enabled, returns a string containing the list of enabled supplemental logging levels. Possible values are: ALL_COLUMN, FOREIGN_KEY, MINIMAL, PRIMARY_KEY, PROCEDURAL, and UNIQUE_INDEX. If supplemental logging is not enabled, returns null. |
| DB_UNIQUE_NAME | Name of the database as specified in the DB_UNIQUE_NAME initialization parameter. |
| DBLINK_INFO | Returns the source of a database link session. Specifically, it returns a string of the form:SOURCE_GLOBAL_NAME=dblink_src_global_name, DBLINK_NAME=dblink_name, SOURCE_AUDIT_SESSIONID=dblink_src_audit_sessionidFor a multitenant database, it returns the string above with an additional field SOURCE_DB_NAME SOURCE_GLOBAL_NAME=dblink_src_global_name, SOURCE_DB_NAME=source_database_name, DBLINK_NAME=dblink_name, SOURCE_AUDIT_SESSIONID=dblink_src_audit_sessionidwhere: dblink_src_global_name is the unique global name of the source database dblink_name is the name of the database link on the source database dblink_src_audit_sessionid is the audit session ID of the session on the source database that initiated the connection to the remote database using dblink_nameSOURCE_DB_NAME is the database identifier of the source database |
| DRAIN_STATUS | Displays the draining status for the current session. If the session is a candidate for drain, returns DRAINING, else returns NONE. |
| ENTRYID | The current audit entry number. The audit entryid sequence is shared between fine-grained audit records and regular audit records. You cannot use this attribute in distributed SQL statements. The correct auditing entry identifier can be seen only through an audit handler for standard or fine-grained audit. |
| ENTERPRISE_IDENTITY | Returns the user's enterprise-wide identity: For enterprise users: the Oracle Internet Directory DN. For external users: the external identity (Kerberos principal name, Radius schema names, OS user name, Certificate DN). For local users and SYSDBA/SYSOPER logins: NULL. The value of the attribute differs by proxy method: For a proxy with DN: the Oracle Internet Directory DN of the clientFor a proxy with certificate: the certificate DN of the client for external users; the Oracle Internet Directory DN for global usersFor a proxy with username: the Oracle Internet Directory DN if the client is an enterprise users; Null if the client is a local database user.For OCI IAM users: the Oracle Cloud Identifier (OCID). |
| FG_JOB_ID | If queried from within a job that was created using the DBMS_JOB package: Returns the job ID of the current session if it was established by a client foreground process. Null if the session was not established by a foreground process.Otherwise: Returns 0. |
| GLOBAL_CONTEXT_MEMORY | Returns the number being used in the System Global Area by the globally accessed context. |
| GLOBAL_UID | Returns the global user ID (GUID) from Active Directory for Centrally Managed Users (CMU) logins, or from Oracle Internet Directory for Enterprise User Security (EUS) logins. Returns null for all other logins. |
| HOST | Name of the host machine from which the client has connected. |
| IDENTIFICATION_TYPE | Returns the way the user's schema was created in the database. Specifically, it reflects the IDENTIFIED clause in the CREATE/ALTER USER syntax. In the list that follows, the syntax used during schema creation is followed by the identification type returned: IDENTIFIED BY password: LOCALIDENTIFIED EXTERNALLY: EXTERNALIDENTIFIED GLOBALLY: GLOBAL SHAREDIDENTIFIED GLOBALLY AS DN: GLOBAL PRIVATEGLOBAL EXCLUSIVE for exclusive global user mapping. GLOBAL SHARED for shared user mapping. NONE when the schema is created with no authentication. |
| INSTANCE | The instance identification number of the current instance. |
| INSTANCE_NAME | The name of the instance. |
| IP_ADDRESS | IP address of the machine from which the client is connected. If the client and server are on the same machine and the connection uses IPv6 addressing, then ::1 is returned. |
| IS_APPLY_SERVER | Returns TRUE if queried from within a SQL Apply server in a logical standby database. Otherwise, returns FALSE. |
| IS_DG_ROLLING_UPGRADE | Returns TRUE if a rolling upgrade of the database software in a Data Guard configuration, initiated by way of the DBMS_ROLLING package, is active. Otherwise, returns FALSE. |
| ISDBA | Returns TRUE if the user has been authenticated as having DBA privileges either through the operating system or through a password file. |
| LANG | The abbreviated name for the language, a shorter form than the existing ‘LANGUAGE’ parameter. |
| LANGUAGE | The language and territory currently used by your session, along with the database character set, in this form:language_territory.characterset |
| LDAP_SERVER_TYPE | Returns the configured LDAP server type, one of OID, AD(Active Directory), OID_G, OPENLDAP. |
| MODULE | The application name (module) set through the DBMS_APPLICATION_INFO package or OCI. |
| MULTIFACTOR_AUTHENTICATION_METHODS | Returns the methods of authentication used as additional factors. It can have the following values: CERT_AUTH: If certificate-based authentication is configured. OMA_PUSH: If Oracle Mobile Authenticator is configured. NULL: If multi-factor authentication is not configured. |
| NETWORK_PROTOCOL | Network protocol being used for communication, as specified in the ‘PROTOCOL=protocol’ portion of the connect string. |
| NLS_CALENDAR | The current calendar of the current session. |
| NLS_CURRENCY | The currency of the current session. |
| NLS_DATE_FORMAT | The date format for the session. |
| NLS_DATE_LANGUAGE | The language used for expressing dates. |
| NLS_SORT | BINARY or the linguistic sort basis. |
| NLS_TERRITORY | The territory of the current session. |
| ORACLE_HOME | The full path name for the Oracle home directory. |
| OS_USER | Operating system user name of the client process that initiated the database session. |
| PLATFORM_SLASH | The slash character that is used as the file path delimiter for your platform. |
| POLICY_INVOKER | The invoker of row-level security (RLS) policy functions. |
| PROXY_ENTERPRISE_IDENTITY | Returns the Oracle Internet Directory DN when the proxy user is an enterprise user. |
| PROXY_USER | Name of the database user who opened the current session on behalf of SESSION_USER. |
| PROXY_USERID | Identifier of the database user who opened the current session on behalf of SESSION_USER. |
| SCHEDULER_JOB | Returns Y if the current session belongs to a foreground job or background job. Otherwise, returns N. |
| SERVER_HOST | The host name of the machine on which the instance is running. |
| SERVICE_NAME | The name of the service to which a given session is connected. |
| SESSION_DEFAULT_COLLATION | The default collation for the session, which is set by the ALTER SESSION SET DEFAULT_COLLATION … statement. |
| SESSION_EDITION_ID | The identifier of the session edition. |
| SESSION_EDITION_NAME | The name of the session edition. |
| SESSION_USER | The name of the session user (the user who logged on). This may change during the duration of a database session as Real Application Security sessions are attached or detached. For enterprise users, returns the schema. For other users, returns the database user name. If a Real Application Security session is currently attached to the database session, returns user XS$NULL.See Also: Oracle Database 2 Day + Security Guide for more information on user XS$NULL |
| SESSION_USERID | The identifier of the session user (the user who logged on). |
| SESSIONID | The auditing session identifier. You cannot use this attribute in distributed SQL statements. |
| SID | The session ID. |
| STATEMENTID | The auditing statement identifier. STATEMENTID represents the number of SQL statements audited in a given session. You cannot use this attribute in distributed SQL statements. The correct auditing statement identifier can be seen only through an audit handler for standard or fine-grained audit. |
| TERMINAL | The operating system identifier for the client of the current session. In distributed SQL statements, this attribute returns the identifier for your local session. In a distributed environment, this is supported only for remote SELECT statements, not for remote INSERT, UPDATE, or DELETE operations. (The return length of this parameter may vary by operating system.) |
| UNIFIED_AUDIT_SESSIONID | If queried while connected to a database that uses unified auditing or mixed mode auditing, returns the unified audit session ID.If queried while connected to a database that uses traditional auditing, returns null. |
