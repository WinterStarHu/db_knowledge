# Managing Password Case Sensitivity

You can manage the password case sensitivity for passwords from user accounts from previous releases.
- SEC_CASE_SENSITIVE_LOGON Parameter and Password Case Sensitivity The SEC_CASE_SENSITIVE_LOGON initialization parameter controls the use of case sensitivity in passwords.
````
- Using the ALTER SYSTEM Statement to Enable Password Case Sensitivity If password case sensitivity has been disabled, then you can enable it by setting the SEC_CASE_SENSITIVE_LOGON parameter to TRUE.
- Management of Case Sensitivity for Secure Role Passwords For better security, you should ensure that the passwords for secure roles are case sensitive.
- Management of Password Versions of Users By default, Oracle Database uses Exclusive Mode, which does not permit case-insensitive passwords, to manage password versions.
- Finding and Resetting User Passwords That Use the 10G Password Version For better security, find and reset passwords for user accounts that use the 10G password version so that they use later, more secure password versions.
````
- How Case Sensitivity Affects Password Files By default, password files are case sensitive. The IGNORECASE argument in the ORAPWD command line utility controls the case sensitivity of password files.
- How Case Sensitivity Affects Passwords Used in Database Link Connections When you create a database link connection, you must define a user name and password for the connection.
## SEC_CASE_SENSITIVE_LOGON Parameter and Password Case Sensitivity
The `SEC_CASE_SENSITIVE_LOGON` initialization parameter controls the use of case sensitivity in passwords.
Only users who have the `ALTER SYSTEM` privilege can set the `SEC_CASE_SENSITIVE_LOGON` parameter. You should ensure that this parameter is set to `TRUE` so that case sensitivity is enforced when a user enters a password. However, you should be aware that the `SEC_CASE_SENSITIVE_LOGON` parameter is deprecated, but is currently retained for backward compatibility.
When you create or modify user accounts, by default, passwords are case sensitive. Case sensitivity affects not only passwords that users enter manually, but it affects password files as well.
Ensure that the `SEC_CASE_SENSITIVE_LOGON` parameter is not set to `FALSE` if the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` parameter is set to `12` or `12a`. This is because the more secure password versions used for this mode only support case-sensitive password checking. For compatibility reasons, Oracle Database does not prevent the use of `FALSE` for `SEC_CASE_SENSITIVE_LOGON` when `SQLNET.ALLOWED_LOGON_VERSION_SERVER` is set to `12` or `12a`. Setting `SEC_CASE_SENSITIVE_LOGON` to `FALSE` when `SQLNET.ALLOWED_LOGON_VERSION_SERVER` is set to `12` or `12a` causes all accounts to become inaccessible. If `SQLNET.ALLOWED_LOGON_VERSION_SERVER` is set to `11` or a lower value, then Oracle recommends that you set `SEC_CASE_SENSITIVE_LOGON` to `TRUE`, because the more secure password versions used in Exclusive Mode (when `SQLNET.ALLOWED_LOGON_VERSION_SERVER` is `12` or `12a`) in Oracle Database 12*c* do not support case insensitive password matching.
In addition to the server-side settings, you should ensure that the client software with which the users are connecting has the `O5L_NP` capability flag. All Oracle Database release 11.2.0.3 and later clients have the `O5L_NP` capability. If you have an earlier client, then you must install the `CPUOct2012` patch.
## Using the ALTER SYSTEM Statement to Enable Password Case Sensitivity
If password case sensitivity has been disabled, then you can enable it by setting the `SEC_CASE_SENSITIVE_LOGON` parameter to `TRUE`.
``````````
````````
``````````
- If you are using a password file, then ensure that it was created with the ORAPWD utility IGNORECASE parameter set to N and the FORMAT parameter set to 12. The IGNORECASE parameter overrides the SEC_CASE_SENSITIVE_LOGON parameter. By default, IGNORECASE is set to N, which means that passwords are treated as case sensitive. Note that the IGNORECASE parameter and the SEC_CASE_SENSITIVE_LOGON system parameter are deprecated. Oracle strongly recommends that you set IGNORECASE to N or omit the IGNORECASE setting entirely.
- Enter the following ALTER SYSTEM statement:
```
ALTER SYSTEM SET SEC_CASE_SENSITIVE_LOGON = TRUE;
```
## Management of Case Sensitivity for Secure Role Passwords
For better security, you should ensure that the passwords for secure roles are case sensitive.
If before upgrading to Oracle Database 12c release 2 (12.2), you created secure roles by using the `IDENTIFIED BY` clause of the `CREATE ROLE` statement, and if upon upgrading to Oracle Database 12c release 12.2, you set the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` parameter to one of the Exclusive Modes `12` or `12a`, then you must change the password for these secure roles in order for them to remain usable. Because Exclusive Mode is now the default, secure roles that were created in earlier releases (such as Oracle Database 10g, in which the `10G` password version was the default) will need to have their passwords changed.
You can query the `PASSWORD_REQUIRED` and `AUTHENTICATION_TYPE` columns of the `DBA_ROLES` data dictionary view to find any secure roles that must have their password changed after upgrade to Oracle Database 12c, in order to become usable again.
Otherwise, the password version for these secure roles cannot be used, unless you set the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` parameter to `8`. If this parameter is set to `12` or `12a`, then you must run the following SQL statement to ensure that case sensitivity is enabled. If not, then secure roles will remain unusable even after their passwords have been changed.
```
ALTER SYSTEM SET SEC_CASE_SENSITIVE_LOGON = "TRUE";
```
## Management of Password Versions of Users
By default, Oracle Database uses Exclusive Mode, which does not permit case-insensitive passwords, to manage password versions.
In a default installation, the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` parameter is set to `12` to enable Exclusive Mode. Exclusive Mode requires that the password-based authentication protocol use one of the case-sensitive password versions (`11G` or `12C`) for the account that is being authenticated. Exclusive Mode excludes the use of the `10G` password version that was used in earlier releases. After you upgrade to Oracle Database 12*c* release 2 (12.2), accounts that use the `10G` password version become inaccessible. This occurs because the server runs in Exclusive Mode by default, and Exclusive Mode cannot use the old `10G` password version to authenticate the client. The server is left with no password version with which to authenticate the client.
The user accounts from Release 10*g* use the `10G` password version. Therefore, you should find the user accounts that use the `10G` password version, and then reset the passwords for these accounts. This generates the appropriate password version based on the setting of the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` parameter, as follows:
````````
- SQLNET.ALLOWED_LOGON_VERSION_SERVER=8 generates all three password versions 10G, 11G, and 12C.
````````
- SQLNET.ALLOWED_LOGON_VERSION_SERVER=12 generates both 11G and 12C password versions, and removes the 10G password version.
````
- SQLNET.ALLOWED_LOGON_VERSION_SERVER=12a generates only the 12C password version.
If you first relax the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` setting to a more permissive value (such as `SQLNET.ALLOWED_LOGON_VERSION_SERVER=8`) and then import the user accounts from an Oracle Database release 10*g* (or earlier) release into the current database release, then because the `10G` password version (used in the older release) is not case sensitive, these users will still be able to log into the database using any case for their password. But when such a user changes their password, the new `11G` and `12C` password versions are generated automatically, and their password will automatically become case sensitive, because the default value for the instance initialization parameter `SEC_CASE_SENSITIVE_LOGON` is `TRUE`. (Be aware that `SEC_CASE_SENSITIVE_LOGON` is deprecated, but is currently retained for backward compatibility.) The following example demonstrates the effect of setting the `SEC_CASE_SENSITIVE_LOGON` parameter to `TRUE`. In this scenario, user `rtaylor` has been imported from Oracle Database release 10*g*, and therefore this account only has the `10G` password version. On the server, the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` is set to `8` because otherwise `rtaylor` would not be able to log in. In addition, the `SEC_CASE_SENSITIVE_LOGON` parameter is set to `TRUE` to enable case sensitivity for the `11G` and `12C` password versions.
  - Check the password versions for user rtaylor:
```
SELECT PASSWORD_VERSIONS FROM DBA_USERS WHERE USERNAME='RTAYLOR';
PASSWORD VERSIONS
-----------------
10G
```
  - Connect as user rtaylor.
```
CONNECT rtaylor
Enter password: "MaresEatOats"
Connected.
```
```
User `rtaylor` can connect to the database because his password still uses the `10G` password version, which is case insensitive. Here, he enters his password in mixed case, though his actual password is all lower case: `mareseatoats`.
```
  - Check the password versions for one of the default users, SCOTT.
```
SELECT PASSWORD_VERSIONS FROM DBA_USERS WHERE USERNAME='SCOTT';
PASSWORD VERSIONS
-----------------
11G 12C
```
  ````- Try connecting as user SCOTT using a mixed case for the password, even though his actual password is all lowercase: luv2walkmyk9.
```
CONNECT SCOTT Enter password: "LuvToWalkMyK9" ERROR: ORA-01017: invalid username/password; logon denied Warning: You are no longer connected to ORACLE.
```
```
Because user `SCOTT`'s password versions are `11G` and `12G`, the password is case sensitive. The password entered in this example is correct, but the case is incorrect.
```
  ````- Alter rtaylor’s password to grumble_mumble2work.
```
ALTER USER rtaylor IDENTIFIED BY grumble_mumble2work;
User altered.
```
  - Connect with the SYSDBA administrative privilege.
```
CONNECT / AS SYSDBA
```
  - Find the password versions for user rtaylor.
```
SELECT PASSWORD_VERSIONS FROM DBA_USERS WHERE USERNAME='RTAYLOR';
PASSWORD VERSIONS
-----------------
10G 11G 12C
```
```
The authentication protocol that was configured with the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` and `SEC_CASE_SENSITIVE_LOGON` settings will enforce the case sensitivity of `rtaylor`'s password, now that he has changed this password.
```
  - Try connecting as rtaylor using a mixed case for the password.
```
CONNECT rtaylor
Enter password: "Grumble_Mumble2Work"
ERROR: ORA-01017: invalid username/password; logon denied
Warning: You are no longer connected to ORACLE.
```
```
The password entered fails because it was not entered using the case in which the password was created.
```
  - Try connecting as rtaylor again but with the password using the correct case
```
CONNECT rtaylor
Enter password: "grumble_mumble2work"
Connected.
```
```
User `rtaylor` can connect.
```
The case sensitivity of the `rtaylor` account is a result of the server’s default setting for `SEC_CASE_SENSITIVE_LOGON`, which is `TRUE`. If this setting is `FALSE`, then case-insensitive matching can be restored because the `rtaylor` account still has the `10G` password version. However, Oracle does not recommend this setting. The `SEC_CASE_SENSITIVE_LOGON` parameter is deprecated for this reason. For greater security, Oracle strongly recommends that you keep case-sensitive password authentication enabled.
## Finding and Resetting User Passwords That Use the 10G Password Version
For better security, find and reset passwords for user accounts that use the `10G` password version so that they use later, more secure password versions.
**Finding All Password Versions of Current Users** You can query the `DBA_USERS` data dictionary view to find a list of all the password versions configured for user accounts.
For example:
```
SELECT USERNAME,PASSWORD_VERSIONS FROM DBA_USERS;
USERNAME                       PASSWORD_VERSIONS
------------------------------ -----------------
JONES                          10G 11G 12C
ADAMS                          10G 11G
CLARK                          10G 11G
PRESTON                        11G
BLAKE                          10G
```
The `PASSWORD_VERSIONS` column shows the list of password versions that exist for the account. `10G` refers to the earlier case-insensitive Oracle password version, `11G` refers to the SHA-1-based password version, and `12C` refers to the SHA-2-based SHA-512 password version.
**````
- User jones: The password for this user was reset in Oracle Database 12c Release 12.1 when the SQLNET.ALLOWED_LOGON_VERSION_SERVER parameter setting was 8. This enabled all three password versions to be created.
````******``````
- Users adams and clark: The passwords for these accounts were originally created in Oracle Database 10g and then reset in Oracle Database 11g. The Oracle Database 11g software was using the default SQLNET.ALLOWED_LOGON_VERSION setting of 8 at that time. Because case insensitivity is enabled by default, their passwords are now case sensitive, as is the password for preston.
**
- User preston: This account was imported from an Oracle Database 11g database that was running in Exclusive Mode (SQLNET.ALLOWED_LOGON_VERSION = 12).
**
- User blake: This account still uses the Oracle Database 10g password version. At this stage, user blake is prevented from logging in.
**Resetting User Passwords That Use the 10G Password Version**
For better security, remove the `10G` password version from the accounts of all users. In the following procedure, to reset the passwords of users who have the `10G` password version, you must temporarily relax the `SQLNET.ALLOWED_LOGON_VERSION_SERVER` setting, which controls the ability level required of clients before login can be allowed. Relaxing the setting enables these users to log in and change their passwords, and hence generate the newer password versions in addition to the `10G` password version. Afterward, you can set the database to use Exclusive Mode and ensure that the clients have the `O5L_NP` capability. Then the users can reset their passwords again, so that their password versions no longer include `10G`, but only have the more secure `11G` and `12C` password versions.
  ````- Query the DBA_USERS view to find users who only use the 10G password version.
```
SELECT USERNAME FROM DBA_USERS
WHERE ( PASSWORD_VERSIONS = '10G '
OR PASSWORD_VERSIONS = '10G HTTP ')
AND USERNAME <> 'ANONYMOUS';
```
````  - Edit the SQLNET.ALLOWED_LOGON_VERSION_SERVER setting in the sqlnet.ora file so that it is more permissive than the default. For example:
```
SQLNET.ALLOWED_LOGON_VERSION_SERVER=11
```
        - Restart the database.
````
``````
```
ALTER USER username PASSWORD EXPIRE;
```
- Expire the users that you found when you queried the DBA_USERS view to find users who only use the 10G password version. You must expire the users who have only the 10G password version, and do not have one or both of the 11G or 12C password versions. For example:
````````
- Ask the users whose passwords you expired to log in. When the users log in, they are prompted to change their passwords. The database generates the missing 11G and 12C password versions for their account, in addition to the 10G password version. The 10G password version continues to be present, because the database is running in the permissive mode.
- Ensure that the client software with which the users are connecting has the O5L_NP ability. All Oracle Database release 11.2.0.3 and later clients have the O5L_NP ability. If you have an earlier Oracle Database client, then you must install the CPUOct2012 patch.
``````  - Remove the SEC_CASE_SENSITIVE_LOGON parameter setting from the instance initialization file, or set SEC_CASE_SENSITIVE_LOGON to TRUE.
```
SEC_CASE_SENSITIVE_LOGON = TRUE
```
      ``````````  - Remove the SQLNET.ALLOWED_LOGON_VERSION_SERVER parameter from the server sqlnet.ora file, or set the value of SQLNET.ALLOWED_LOGON_VERSION_SERVER in the server sqlnet.ora file back to 12, to set it to an Exclusive Mode.
```
SQLNET.ALLOWED_LOGON_VERSION_SERVER = 12
```
  - Restart the database.
- Find the accounts that still have the 10G password version.
```
SELECT USERNAME FROM DBA_USERS
WHERE PASSWORD_VERSIONS LIKE '%10G%'
AND USERNAME <> 'ANONYMOUS';
```
  - Expire the accounts that still have the 10G password version.
```
ALTER USER username PASSWORD EXPIRE;
```
``````
- Ask these users to log in to their accounts. When the users log in, they are prompted to reset their passwords. The database then generates only the 11G and 12C password versions for their accounts. Because the database is running in Exclusive Mode, the 10G password version is no longer generated.
- Rerun the following query:
```
SELECT USERNAME FROM DBA_USERS WHERE PASSWORD_VERSIONS LIKE '%10G%' AND USERNAME <> 'ANONYMOUS';
```
```
If this query does not return any results, then it means that no user accounts have the `10G` password version. Hence, the database is running in a more secure mode than in previous releases.
```
## How Case Sensitivity Affects Password Files
By default, password files are case sensitive. The `IGNORECASE` argument in the `ORAPWD` command line utility controls the case sensitivity of password files.
The default value for `IGNORECASE` is `N` (no), which enforces case sensitivity. For better security, set `IGNORECASE` to `N` or omit the `ignorecase` argument entirely. Note that `IGNORECASE` is deprecated.
The following example shows how to enable case sensitivity in password files.
```
orapwd file=orapw entries=100 Enter password for SYS: password
```
This command creates a case sensitive password file called `orapw`. By default, passwords are case sensitive. Afterward, if you connect using this password, it succeeds-as long as you enter it using the *exact* case in which it was created. If you enter the same password but with a different case, then the authentication attempt that uses the password fails.
Alternatively, you can turn the `IGNORECASE` parameter off by using password file migration from one format to another format. For example:
```
orapwd input_file=input_password_file file=output_password_file
```
If you imported user accounts from a previous release and these accounts were created with `SYSDBA` or `SYSOPER` administrative privilege, then they will be included in the password file. The passwords for these accounts are case insensitive. The next time these users change their passwords, and assuming case sensitivity is enabled, the passwords become case sensitive. For greater security, have these users change their passwords.
## How Case Sensitivity Affects Passwords Used in Database Link Connections
When you create a database link connection, you must define a user name and password for the connection.
When you create the database link connection, the password is case sensitive. How a user enters his or her password for connections depends on the release in which the database link was created:
- Users can connect from a pre-Oracle Database 12c database to a Oracle Database 12c database. Because case sensitivity is enabled, then the user must enter the password using the case that was used when the account was created.
**
- If the user connects from a Oracle Database 12c database to a pre-Oracle Database 12c database, and if the SEC_CASE_SENSITIVE_LOGON parameter in the pre-Release 12c database had been set to FALSE, then the password for this database link can be specified using any case.
You can find the user accounts for existing database links by querying the `V$DBLINK` view. For example:
```
SELECT DB_LINK, OWNER_ID FROM V$DBLINK;
```
See *Oracle Database Reference* for more information about the `V$DBLINK` view.
## Related Topics
  **- Oracle Database Administrator’s Guide
