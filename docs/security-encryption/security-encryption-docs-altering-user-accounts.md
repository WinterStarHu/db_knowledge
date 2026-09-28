# Altering User Accounts

The `ALTER USER` statement modifies user accounts, such their default tablespace or profile, or changing a user’s password.
- About Altering User Accounts Changing user security settings affects the future user sessions, not the current session.
````
- Methods of Altering Common or Local User Accounts You can use the ALTER USER statement or the PASSWORD command to alter both common and local user accounts.
- Changing Non-SYS User Passwords Users can change their own passwords but to change other users’ passwords, they must have the correct privileges.
````````
- Changing the SYS User Password To change the SYS user password, you can use the ALTER USER statement, the PASSWORD command, or the ORAPWD command line utility.
## About Altering User Accounts
Changing user security settings affects the future user sessions, not the current session.
In most cases, you can alter user security settings with the `ALTER USER` SQL statement. Users can change their own passwords. However, to change any other option of a user security domain, you must have the `ALTER USER` system privilege. Security administrators are typically the only users that have this system privilege, as it allows a modification of *any* user security domain. This privilege includes the ability to set tablespace quotas for a user on any tablespace in the database, even if the user performing the modification does not have a quota for a specified tablespace.
You must have the commonly granted `ALTER USER` system privilege to alter common user accounts. To alter local user accounts, you must have a commonly granted `ALTER USER` privilege or a locally granted `ALTER USER` privilege in the PDB in which the local user account resides.
## Methods of Altering Common or Local User Accounts
You can use the `ALTER USER` statement or the `PASSWORD` command to alter both common and local user accounts.
You cannot change an existing common user account to be a local user account, or a local user account to be made into a common user account. In this case, you must create a new account, as either a common user account or a local user account.
The following example shows how to use the `ALTER USER` statement to restrict user `c##hr_admin`’s ability to view `V$SESSION` rows to those that pertain to sessions that are connected to `CDB$ROOT`, and to the `emp_db` and `hr_db` PDBs.
```
CONNECT SYSTEM
Enter password: password
Connected.
ALTER USER c##hr_admin
 DEFAULT TABLESPACE data_ts
 TEMPORARY TABLESPACE temp_ts
 QUOTA 100M ON data_ts
 QUOTA 0 ON test_ts
 SET CONTAINER_DATA = (emp_db, hr_db) FOR V$SESSION
 CONTAINER = CURRENT;
```
The `ALTER USER` statement here changes the security settings for the user `c##hr_admin` as follows:
````````
- DEFAULT TABLESPACE and TEMPORARY TABLESPACE are set explicitly to data_ts and temp_ts, respectively.
````
- QUOTA 100M gives the data_ts tablespace 100 MB.
````
- QUOTA 0 revokes the quota on the temp_ts tablespace.
``````````
- SET CONTAINER_DATA enables user c##hr_admin to have access to data related to the emp_db and hr_db PDBs as well as the root when he queries the V$SESSION view from the root.
To change passwords, you can use `ALTER USER`, but Oracle recommends that you use the `PASSWORD` command to change passwords, for both non-`SYS` and `SYS` user accounts.
## Changing Non-SYS User Passwords
Users can change their own passwords but to change other users’ passwords, they must have the correct privileges.
````
- About Changing Non-SYS User Passwords Users can use either the PASSWORD command or ALTER USER statement to change a password.
````
- Using the PASSWORD Command or ALTER USER Statement to Change a Password Most users can change their own passwords with the SQL*Plus PASSWORD command or the ALTER USER SQL statement.
### About Changing Non-SYS User Passwords
Users can use either the `PASSWORD` command or `ALTER USER` statement to change a password.
No special privileges (other than those to connect to the database and create a session) are required for a user to change his or her own password. Encourage users to change their passwords frequently. You can find existing users for the current database instance by querying the `ALL_USERS` view.
For better security, use the `PASSWORD` command to change the account’s password. The `ALTER USER` statement displays the new password on the screen, where it can be seen by any overly curious coworkers. The `PASSWORD` command does not display the new password, so it is only known to you, not to your co-workers. The `PASSWORD` command also encrypts the password on the network. `ALTER USER` will send the password in clear text, so you should not use it unless the network connection between the client and database is encrypted or the session is a local session not routed over the network.
Users must have the `PASSWORD` and `ALTER USER` privilege to switch between methods of authentication. Usually, only an administrator has this privilege.
### Using the PASSWORD Command or ALTER USER Statement to Change a Password
Most users can change their own passwords with the SQL*Plus `PASSWORD` command or the `ALTER USER` SQL statement.
In a multitenant environment, a CDB common user must change his or her password in the CDB root, and an application common user must change his or her password in the application root.
  - To use the SQL*Plus PASSWORD command to change a password, supply the user’s name, and when prompted, enter the new password. For example:
```
PASSWORD andy
Changing password for andy
New password: password
Retype new password: password
```
````
- To use the ALTER USER SQL statement change a password, include the IDENTIFIED BY clause. For example:
```
ALTER USER andy IDENTIFIED BY password;
```
## Changing the SYS User Password
To change the `SYS` user password, you can use the `ALTER USER` statement, the `PASSWORD` command, or the `ORAPWD` command line utility.
````````
- About Changing the SYS User Password The method of changing the SYS password that you choose depends on the setting of the parameter REMOTE_LOGIN_PASSWORDFILE in the PFILE or SPFILE used by an RDBMS or ASM instance.
````
- ORAPWD Utility for Changing the SYS User Password The ORAPWD utility enables you to change the SYS user password.
### About Changing the SYS User Password
The method of changing the `SYS` password that you choose depends on the setting of the parameter `REMOTE_LOGIN_PASSWORDFILE` in the `PFILE` or `SPFILE` used by an RDBMS or ASM instance.
You an use the `PASSWORD` command, the `ALTER USER` statement, or the `ORAPWD` utility to change `SYS` password.
As with non-`SYS` user accounts, there are good reasons for using `PASSWORD` to change the `SYS` user account. `PASSWORD` does not show the new password on the screen, and `PASSWORD` also encrypts the password over the network. `ALTER USER` will send the password in clear text, so you should not use it unless the network connection between the client and database is encrypted or the session is a local session not routed over the network. Hence, you should use `PASSWORD` for remote connections.
The `ALTER USER` statement has the following advantages over using `ORAPWD`:
- It enables you to change the SYS user password from within the Oracle database instance.
- In an Oracle Data Guard environment, it propagates the SYS password change to Oracle Data Guard instances.
Be aware that in an Oracle Real Application Clusters (Oracle RAC) environment, the default and recommended setup is to a have a single cluster-wide password file for all ASM instances and a single cluster-wide password file for all RDBMS instances of each RAC enabled database on a shared disk, preferably in an ASM disk group.
Irrespective of the password file present on a shared or non-shared disk, the recommended value for `REMOTE_LOGIN_PASSWORDFILE` parameter is `EXCLUSIVE` and it will be set by default. If the password file is not located on a shared disk or path and the password is changed, you must copy the password file to all the nodes in the Oracle RAC cluster.
If the `REMOTE_LOGIN_PASSWORDFILE` initialization parameter is set and you want to use `ALTER USER` to change the `SYS` password, then note the following:
````
- Ensure that the REMOTE_LOGIN_PASSWORDFILE initialization parameter is set to EXCLUSIVE. Otherwise, the password change attempt will fail.
``````
- If REMOTE_LOGIN_PASSWORDFILE is set to NONE, then the password change attempt fails with ORA-01994: Password file missing or disabled.
``````
- If REMOTE_LOGIN_PASSWORDFILE is set to SHARED, then the password change attempt fails with ORA-01999: password file cannot be updated in SHARED mode.
If you want to use `ORAPWD` to change the `SYS` password, then note the following:
- Before you can change the password of the SYS user account, a password file must exist for this account.
``````````
- If the instance initialization parameter REMOTE_LOGIN_PASSWORDFILE is set to SHARED or NONE, then you must use ORAPWD to change the SYS password.
The following applies to both the `ALTER USER` and `ORAPWD` methods of changing the `SYS` user password:
````````````````````
- New accounts are created with the SHA-2 (SHA-512) verifier. SYS user verifiers are generated based on the sqlnet.ora parameter ALLOWED_LOGON_VERSION_SERVER. You can identify these accounts by querying the PASSWORD_VERSIONS column of the DBA_USERS data dictionary view. (These verifiers are listed as 12C in the PASSWORD_VERSIONS column of the DBA_USERS view output.)
- In an Oracle Real Application Clusters (Oracle RAC) environment, store the password in the ASM disk group so that it can be shared by multiple Oracle RAC instances.
### ORAPWD Utility for Changing the SYS User Password
The `ORAPWD` utility enables you to change the `SYS` user password.
You can use the `ORAPWD` utility with the `INPUT_FILE` parameter to change the `SYS` user password. To migrate the password files to a specific format, include the `FORMAT` option. By default, the format is `12.2` if you do not specify the `FORMAT` option.
To set a new password for the `SYS` user using the `ORAPWD` utility, set the `SYS` option to `Y` (yes), use the `INPUT_FILE` parameter to specify the current password file name, and use the `FILE` parameter to create the password file to which the original password file is migrated. The new database password file replaces the existing database password file. Therefore, `FORCE` must be set to `Y`. For example:
```
orapwd INPUT_FILE=$ORACLE_HOME/dbs/orapw$ORACLE_SID FILE=$ORACLE_HOME/dbs/orapw$ORACLE_SID SYS=Y FORCE=Y
Enter password for SYS: new_password
```
Replace *new_password* with a password that is secure. If you do not want to migrate the password file to a different format, then you can specify the same format as the `input_file`. For example, assuming that the input file `orapworcl` format is `12` and you want to change the `SYS` user password:
```
orapwd FILE=/u01/oracle/dbs/orapworcl INPUT_FILE=/u01/oracle/dbs/orapworcl FORMAT=12 SYS=Y FORCE=Y
Enter password for SYS: new_password
```
**Note:**   `ORAPWD` cannot migrate an input password file that is stored in an Oracle ASM disk group
## Related Topics
  - Configuring Multi-Factor Authentication
**- Oracle Database SQL Language Reference
  - About Changing the SYS User Password
  - About Changing the SYS User Password
  - Minimum Requirements for Passwords
  - Guidelines for Securing Passwords
  - Configuring Authentication
  - REMOTE_LOGIN_PASSWORDFILE
  - Ensuring Against Password Security Threats by Using the 12C Password Version
**- Oracle Database Administrator’s Guide **- Oracle Database Administrator’s Guide
