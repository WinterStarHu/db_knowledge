# ALTER USER

## Purpose
Use the `ALTER` `USER` statement:
- To change the authentication or database resource characteristics of a database user
- To permit a proxy server to connect as a client without authentication
******
- In an Oracle Automatic Storage Management (Oracle ASM) cluster, to change the password of a user in the password file that is local to the Oracle ASM instance of the current node See Also: Oracle Database Security Guide for detailed information about user authentication methods
## Prerequisites
In general, you must have the `ALTER` `USER` system privilege. However, the current user can change his or her own password without this privilege.
To change the `SYS` password, the password file must exist, and an account granted alter user privilege must have the `SYSDBA` administrative role in order to have the ability to change the `SYS` password.
You must be authenticated `AS` `SYSASM` to change the password of a user other than yourself in an Oracle ASM instance password file.
To specify the `CONTAINER` clause, you must be connected to a multitenant container database (CDB). If the current container is the root, then you can specify `CONTAINER` `=` `ALL` or `CONTAINER` `=` `CURRENT`. If the current container is a pluggable database (PDB), then you can specify only `CONTAINER` `=` `CURRENT`.
To set and modify `CONTAINER_DATA` attributes using the *container_data_clause*, you must be connected to a CDB and the current container must be the root.
## Syntax
## *alter_user*::=
Description of the illustration alter_user.eps (*size_clause::=*)
## *container_data_clause*::=
Description of the illustration container_data_clause.eps
## *proxy_clause*::=
Description of the illustration proxy_clause.eps
## *db_user_proxy_clauses*::=
Description of the illustration db_user_proxy_clauses.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to alter an existing user.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
The keywords, parameters, and clauses described in this section are unique to `ALTER` `USER` or have different semantics than they have in `CREATE` `USER`. Keywords, parameters, and clauses that do not appear here have the same meaning as in the `CREATE` `USER` statement.
**Note:**   Oracle recommends that user names and passwords be encoded in ASCII or EBCDIC characters only, depending on your platform.
**See Also:**   CREATE USER for information on the keywords and parameters and CREATE PROFILE for information on assigning limits on database resources to a user
## IDENTIFIED Clause
**BY** ***password*** Specify `BY` *password* to specify a new password for the user. Passwords are case sensitive. Any subsequent `CONNECT` string used to connect this user to the database must specify the password using the same case (upper, lower, or mixed) that is used in this `ALTER` `USER` statement. Passwords can contain single-byte, or multibyte characters, or both from your database character set.
**Note:**   Oracle Database expects a different timestamp for each resetting of a particular password. If you reset one password multiple times within one second (for example, by cycling through a set of passwords using a script), then the database may return an error message that the password cannot be reused. For this reason, Oracle recommends that you avoid using scripts to reset passwords.
You can omit the `REPLACE` clause if you are setting your own password or you have the `ALTER` `USER` system privilege and you are changing another user’s password. However, unless you have the `ALTER` `USER` system privilege, you must always specify the `REPLACE` clause if a password complexity verification function has been enabled, either by running the `UTLPWDMG.SQL` script or by specifying such a function in the `PASSWORD_VERIFY_FUNCTION` parameter of a profile that has been assigned to the user.
In an Oracle ASM cluster, you can use this clause to change the password of a user in the password file that is local to an Oracle ASM instance of the current node. You must be authenticated `AS` `SYSASM` to specify `IDENTIFIED` `BY` *password* without the `REPLACE` *old_password* clause. If you are not authenticated `AS` `SYSASM`, then you can only change your own password by specifying `REPLACE` *old_password*.
Oracle Database does not check the old password, even if you provide it in the `REPLACE` clause, unless you are changing your own existing password.
**Changing a Password to Begin the Gradual Database Password Rollover Period** **Prerequisite** Enable gradual database password rollover period by setting a non-zero value to the `PASSWORD_ROLLOVER_TIME` user profile parameter using `CREATE PROFILE` or `ALTER PROFILE` .
After you set the `PASSWORD_ROLLOVER_TIME` to specify the duration of the gradual password rollover period in the profile of the user, you can use the `ALTER USER` statement to change the user’s password, which will allow clients to login using both the old password and the new password until the password rollover period expires.
During the password rollover period, you must propagate the new password to all clients (before the ` PASSWORD_ROLLOVER_TIME` ends). If you successfully propagated the new password to all clients early (before the end of the password rollover period) then you can use the `EXPIRE PASSWORD ROLLOVER PERIOD` clause to end the password rollover (finalizing the password change, so that only the new password can be used).
**Changing a Password During the Gradual Database Password Rollover Period** You can change the password during the password rollover period (before the rollover period expires) using `ALTER USER` with or without the `REPLACE` clause.
For example, say user `u1` has an original password `p1`, and `p2` is the new password that started the rollover process. Now you want to switch to `p3` instead of `p2`. You can use any one of the statements to change the password to `p3`:
```
ALTER USER u1 IDENTIFIED BY p3;
```
```
ALTER USER u1 IDENTIFIED BY p3 REPLACE p1;
```
```
ALTER USER u1 IDENTIFIED BY p3 REPLACE p2;
```
After you change the password to `p3`, the user can log in using either `p1` or `p3`. Logging in with `p2` returns error `Invalid credential or not authorized; logon denied ` and is recorded as a failed login attempt.
The rollover start time remains set to the password change timestamp, this is the time the password of the user was changed. The rollover start time and password change time are not affected by any further password change made during the password rollover period. The old password can be used for at most `PASSWORD_ROLLOVER_TIME` days.
**See Also:**   *Oracle Database Security Guide* for guidelines on creating passwords **GLOBALLY** Refer to CREATE USER for more information on this clause.
You can change a user’s access verification method *from* `IDENTIFIED` `GLOBALLY` to either `IDENTIFIED` `BY` *password* or `IDENTIFIED` `EXTERNALLY`. You can change a user’s access verification method *to* `IDENTIFIED` `GLOBALLY` from one of the other methods only if all external roles granted explicitly to the user are revoked.
**EXTERNALLY** Refer to CREATE USER for more information on this clause.
**See Also:**   *Oracle Database Enterprise User Security Administrator’s Guide* for more information on globally and externally identified users, “Changing User Identification: Example”, and “Changing User Authentication: Examples”
## NO AUTHENTICATION Clause
Use this clause to change an existing user account with authentication to a schema account without authentication to prevent logins to the account.
## ADD | UPDATE | DROP FACTOR
Specify these clauses to enable second factor authentication for native database users.
## DEFAULT COLLATION Clause
Use this clause to change the default collation for the schema owned by the user. The new default collation is assigned to tables, views, and materialized views that are subsequently created in the schema. It does not influence default collations for existing tables views, and materialized views. Refer to the DEFAULT COLLATION Clause clause of `CREATE` `USER` for the full semantics of this clause.
## DEFAULT TABLESPACE Clause
Use this clause to assign or reassign a tablespace for the user’s permanent segments. This clause overrides any default tablespace that has been specified for the database.
**Restriction on Default Tablespaces** You cannot specify a locally managed temporary tablespace, including an undo tablespace, or a dictionary-managed temporary tablespace, as a user’s default tablespace.
## [LOCAL] TEMPORARY TABLESPACE Clause
Use this clause to assign or reassign a temporary tablespace or tablespace group for the user’s temporary segments.
**````````````
- Specify tablespace to indicate the user’s temporary tablespace. Specify TEMPORARY TABLESPACE to indicate a shared temporary tablespace. Specify LOCAL TEMPORARY TABLESPACE to indicate a local temporary tablespace. If you are connected to a CDB, then you can specify CDB$DEFAULT to use the CDB-wide default temporary tablespace.
****
- Specify tablespace_group_name to indicate that the user can save temporary segments in any tablespace in the tablespace group specified by tablespace_group_name. Local temporary tablespaces cannot be part of a tablespace group.
**Restriction on User Temporary Tablespace** Any individual tablespace you assign or reassign as the user’s temporary tablespace must be a temporary tablespace and must have a standard block size.
**See Also:**   “Assigning a Tablespace Group: Example”
## DEFAULT ROLE Clause
Specify the roles enabled by default for the user at logon.This clause can contain only roles that have been granted directly to the user with a `GRANT` statement, or roles created by the user with the `CREATE` `ROLE` privilege. You cannot use the `DEFAULT` `ROLE` clause to specify:
- Roles not granted to the user
- Roles granted through other roles
- Roles managed by an external service (such as the operating system), or by the Oracle Internet Directory
````****
- Roles that are enabled by the SET ROLE statement, such as password-authenticated roles and secure application roles See Also: CREATE ROLE
**Assigning Default Roles to Common Users in a CDB**
You can modify the default role assigned to a common user both in the current container and across all containers in a CDB.
While assigning a default role to a common user across all containers, `role` must be a common role that was commonly granted to the common user.
While assigning a default role to a common user in the current container, `role` must be one of the following:
- A local role that was granted to the common user in the current container
- A common role that was granted to the common user, either commonly or locally in the current container
## EXPIRE PASSWORD ROLLOVER PERIOD Clause
You can manually end the password rollover period with `EXPIRE PASSWORD ROLLOVER PERIOD` .
## ENABLE EDITIONS
This clause is not reversible. Specify `ENABLE` `EDITIONS` to allow the user to create multiple versions of editionable objects in this schema using editions. Editionable objects in non-editions-enabled schemas cannot be editioned.
Use the `FOR` clause to specify one or more object types for which the user can create editionable objects. For a list of valid values for *object_type*, query the `V$EDITIONABLE_TYPES` dynamic performance view. If you omit the `FOR` clause, then the user can create editionable objects for all editionable object types.
If you omit the `FOR` clause, then the types that become editionable in the schema are `VIEW`, `SYNONYM`, `PROCEDURE`, `FUNCTION`, `PACKAGE`, `PACKAGE BODY`, `TRIGGER`, `TYPE`, `TYPE BODY`, and `LIBRARY`.
To enable edition for other object types that are not enabled by default, you must explicitly specify the object type in the `FOR` clause.
**Example: Enable Edition Not Enabled By Default**
```
ALTER USER username ENABLE EDITIONS FOR SQL TRANSLATION PROFILE;
```
```

```
If the schema to be editions-enabled contains any objects that are not editionable and that depend on editionable type objects in the schema, then you must specify `FORCE` to enable editions for this schema. In this case, all the objects that are not editionable and that depend on the editionable type objects in the schema being editions-enabled become invalid.
## [HTTP] DIGEST Clause
This clause lets you enable or disable HTTP Digest Access Authentication for the user.
````````````
```
ALTER USER user PASSWORD EXPIRE HTTP DIGEST ENABLE;
```
- Specify ENABLE to enable HTTP Digest Access Authentication. After you specify this clause, the user’s password must be changed. This causes the database to generate an HTTP Digest verifier for the new password. Only then will HTTP Digest Access Authentication take effect. One way to ensure that the user’s password is changed after you issue this clause is to specify the PASSWORD EXPIRE clause in the same statement with the HTTP DIGEST ENABLE clause, as follows: This causes the database to prompt the user for a new password on his or her next attempt to log in to the database. After that, HTTP Digest Access Authentication will take effect for the user.
Specify `DISABLE` to disable HTTP Digest Access Authentication for the user. You do not need to change the user’s password in order for this clause to take effect. Specifying the `DISABLE` clause removes the HTTP Digest from dictionary tables.
```
ALTER USER user PASSWORD EXPIRE HTTP DIGEST DISABLE;
```
Refer to [HTTP] DIGEST Clause in the documentation on `CREATE` `USER` for more information on this clause.
## CONTAINER Clause
If the current container is a PDB, then you can specify `CONTAINER` `=` `CURRENT` to change the attributes of a local user, or the container-specific attributes (such as the default tablespace) of a common user, in the current container. If the current container is the root, then you can specify `CONTAINER` `=` `ALL` to change the attributes of a common user across the entire CDB. If you omit this clause and the current container is a PDB, then `CONTAINER` `=` `CURRENT` is the default. If you omit this clause and the current container is the root, then `CONTAINER` `=` `ALL` is the default.
**Restriction on Modifying Common Users in a CDB** Certain attributes of a common user must be modified for all the containers in a CDB and not for only some containers. Therefore, when you use any of the following clauses to modify a common user, ensure that you modify all of the containers by connecting to the root and specifying `CONTAINER=ALL`:
- IDENTIFIED clause
- PASSWORD clause
````
- [HTTP] DIGEST clause
## *container_data_clause*
The *container_data_clause* allows you the set and modify `CONTAINER_DATA` attributes for a common user. Use the `FOR` clause to indicate whether to set or modify the default `CONTAINER_DATA` attribute or an object-specific `CONTAINER_DATA` attribute. These attributes determine the set of containers (which can never exclude the root) whose data will be visible via `CONTAINER_DATA` objects to the specified common user when the current session is the root.
To specify the *container_data_clause*, the current session must be the root and you must specify `CONTAINER` `=` `CURRENT`.
**SET CONTAINER_DATA**
Use this clause to set the default `CONTAINER_DATA` attribute or an object-specific `CONTAINER_DATA` attribute for a common user. When you specify this clause, you replace the existing value, if any, of the `CONTAINER_DATA` attribute.
Use *container_name* to specify one or more containers that will be accessible to the user.
Use `ALL` to specify that all current and future containers in the CDB will be accessible to the user.
Use `DEFAULT` to specify the default behavior, which is as follows:
- For a default CONTAINER_DATA attribute, the current container, that is, the root, and the CDB as a whole will be accessible to the user.
````****``````
- For an object-specific CONTAINER_DATA attribute, the database will use the user’s default CONTAINER_DATA attribute. Note: CONTAINER_DATA attributes that are set to DEFAULT are not visible in the DBA_CONTAINER_DATA view.
**ADD CONTAINER_DATA** Use this clause to add containers to the default `CONTAINER_DATA` attribute or an object-specific `CONTAINER_DATA` attribute for a common user. Use *container_name* to specify one or more containers to add.
You cannot use this clause if the default `CONTAINER_DATA` attribute is set to `ALL`. If you use this clause when the default `CONTAINER_DATA` attribute is set to `DEFAULT`, then `CDB$ROOT` will automatically be added to the set of containers, unless the set already contains `CDB$ROOT`.
You cannot use this clause if the object-specific `CONTAINER_DATA` attribute is set to `ALL` or `DEFAULT`.
**REMOVE CONTAINER_DATA** Use this clause to remove containers from the default `CONTAINER_DATA` attribute or an object-specific `CONTAINER_DATA` attribute for a common user. Use *container_name* to specify one or more containers to remove.
You cannot use this clause if the default `CONTAINER_DATA` attribute or object-specific `CONTAINER_DATA` attribute is set to `ALL` or `DEFAULT`.
**FOR** ***container_data_object*** If you specify the `FOR` clause, then you can set and modify the object-specific `CONTAINER_DATA` attribute for *container_data_object* for a common user. *container_data_object* must be a `CONTAINER_DATA` table or view. If you omit *schema*, then Oracle Database assumes that *container_data_object* is in your own schema.
If you omit the `FOR` clause, then you can set and modify the default `CONTAINER_DATA` attribute for a common user.
**See Also:**   *Oracle Database Security Guide* for more information about enabling common users to view information about PDB objects
## *proxy_clause*
The *proxy_clause* lets you control the ability of an enterprise user (a user outside the database) or a database proxy (another database user) to connect as the database user being altered.
**GRANT CONNECT THROUGH** Specify `GRANT` `CONNECT` `THROUGH` to allow the connection.
**REVOKE CONNECT THROUGH** Specify `REVOKE` `CONNECT` `THROUGH` to prohibit the connection.
**ENTERPRISE USER** This clause lets you expose *user* to proxy use by enterprise users. The administrator working in Oracle Internet Directory must then grant privileges for appropriate enterprise users to act on behalf of *user*.
***db_user_proxy*** This clause lets you expose *user* to proxy use by database user *db_user_proxy* (the proxy).
- The proxy will have all privileges that were directly granted to user.
****
- The proxy will have all roles associated with user, unless you specify the WITH clauses of db_user_proxy_clauses to limit the proxy to some or none of the roles of user. For each role associated with the proxy, if the role is enabled by default for user at login, then that role will also be enabled by default for the proxy at login.
## *db_user_proxy_clauses*
You can enable password-protected roles in a proxy session. Both secure application role and password-protected roles provide a secure method for enabling a role in a session. Oracle recommends using secure password roles instead of password protected roles in instances where the password has to be maintained and transmitted over insecure channels, or if more than one person needs to know the password. Password-protected roles in a proxy session are suitable for situations where automation is used to set the role.
Proxy users can access password-protected roles. Specify the `WITH` clauses to limit the proxy to some or none of the roles associated with *user*, and the `AUTHENTICATION` `REQUIRED` clause to specify whether authentication is required.
**WITH ROLE** `WITH` `ROLE` *role_name* permits the proxy to connect as the specified user and to activate only the roles that are specified by *role_name*. This clause can contain only roles that are associated with *user*. Password protected roles and secure application roles also need to be listed in the `WITH` `ROLE` clause if the Proxy user will need to use these secure roles. These secure roles will be included with the `WITH ROLE ALL` clause (the default if `WITH ROLE` is not specified). If `WITH ROLE` doesn’t specify the secure roles, then those cannot be enabled even with right password.
**WITH ROLE ALL EXCEPT** `WITH` `ROLE` `ALL` `EXCEPT` *role_name* permits the proxy to connect as the specified user and to activate all roles associated with that user except those specified for *role_name*. This clause can contain only roles that are associated with *user*.
**WITH NO ROLES** `WITH` `NO` `ROLES` permits the proxy to connect as the specified user, but prohibits the proxy from activating any of that user’s roles after connecting, even the secure roles like password protected roles and secure application roles.
**AUTHENTICATION REQUIRED** Oracle Database does not expect the proxy to authenticate the user unless you specify the `AUTHENTICATION` `REQUIRED` clause. This clause ensures that authentication credentials for the user must be presented when the user is authenticated through the specified proxy. The credential is a password.
**AUTHENTICATED USING** The `AUTHENTICATED` `USING` clauses, which appeared in the syntax of earlier releases, have been deprecated and are no longer needed. If you specify the `AUTHENTICATED` `USING` `PASSWORD` clause, then Oracle Database converts it to the `AUTHENTICATION` `REQUIRED` clause. Specifying the `AUTHENTICATED` `USING` `CERTIFICATE` clause or the `AUTHENTICATED` `USING` `DISTINGUISHED` `NAME` clause is equivalent to omitting the `AUTHENTICATION` `REQUIRED` clause.
**See Also:** **
- Oracle Security Overview for an overview of database security and for information on middle-tier systems and proxy authentication
**
- Oracle Database Security Guide for more information on proxies and their use of the database and “Proxy Users: Examples”
## Examples
**Changing User Identification: Example** The following statement changes the password of the user `sidney` (created in “Creating a Database User: Example”) `second_2nd_pwd` and default tablespace to the tablespace `example`:
```
ALTER USER sidney
    IDENTIFIED BY second_2nd_pwd
    DEFAULT TABLESPACE example;
```
The following statement assigns the `new_profile` profile (created in “Creating a Profile: Example”) to the sample user `sh`:
```
ALTER USER sh
    PROFILE new_profile;
```
In subsequent sessions, `sh` is restricted by limits in the `new_profile` profile.
The following statement makes all roles granted directly to `sh` default roles, except the `dw_manager` role:
```
ALTER USER sh
    DEFAULT ROLE ALL EXCEPT dw_manager;
```
At the beginning of `sh`’s next session, Oracle Database enables all roles granted directly to `sh` except the `dw_manager` role.
**Changing User Authentication: Examples** The following statement changes the authentication mechanism of user `app_user1` (created in “Creating a Database User: Example”`)`:
```
ALTER USER app_user1 IDENTIFIED GLOBALLY AS 'CN=tom,O=oracle,C=US';
```
The following statement causes user `sidney`’s password to expire:
```
ALTER USER sidney PASSWORD EXPIRE;
```
If you cause a database user’s password to expire with `PASSWORD` `EXPIRE`, then the user (or the DBA) must change the password before attempting to log in to the database following the expiration. However, tools such as SQL*Plus allow the user to change the password on the first attempted login following the expiration.
**Assigning a Tablespace Group: Example** The following statement assigns `tbs_grp_01` (created in “Adding a Temporary Tablespace to a Tablespace Group: Example”) as the tablespace group for user `sh`:
```
ALTER USER sh
  TEMPORARY TABLESPACE tbs_grp_01;
```
**Proxy Users: Examples** The following statement alters the user `app_user1`. The example permits the `app_user1` to connect through the proxy user `sh`. The example also allows `app_user1` to enable its `warehouse_user` role (created in “Creating a Role: Example”) when connected through the proxy `sh`:
```
ALTER USER app_user1
   GRANT CONNECT THROUGH sh
   WITH ROLE warehouse_user;
```
To show basic syntax, this example uses the sample database Sales History user (`sh`) as the proxy. Normally a proxy user would be an application server or middle-tier entity. For information on creating the interface between an application user and a database by way of an application server, refer to *Oracle Call Interface Programmer’s Guide.* **See Also:**
- “Creating External Database Users: Examples” to see how to create the app_user user
- “Creating a Role: Example” to see how to create the dw_user role
The following statement takes away the right of user `app_user1` to connect through the proxy user `sh`:
```
ALTER USER app_user1 REVOKE CONNECT THROUGH sh;
```
The following hypothetical examples shows another method of proxy authentication:
```
ALTER USER sully GRANT CONNECT THROUGH OAS1
   AUTHENTICATED USING PASSWORD;
```
The following example exposes the user `app_user1` to proxy use by enterprise users. The enterprise users cannot act on behalf of `app_user1` until the Oracle Internet Directory administrator has granted them appropriate privileges:
```
ALTER USER app_user1
   GRANT CONNECT THROUGH ENTERPRISE USERS;
```
