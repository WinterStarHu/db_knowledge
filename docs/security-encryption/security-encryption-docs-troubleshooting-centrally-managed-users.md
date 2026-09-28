# Troubleshooting Centrally Managed Users

Oracle provides error messages that help you troubleshoot common errors that may arise when a Microsoft Active Directory user tries to log in to an Oracle database.
````
- ORA-28276 Connection Errors The ORA-28276: Invalid ORACLE password attribute error can result from an improperly set orclCommonAttribute attribute.
- ORA-01017 Connection Errors The ORA-01017: invalid username/password logon denied error can be generated due to the differences in how special characters are allowed in Oracle Database and in Microsoft Active Directory.
- ORA-28274 Connection Errors The ORA-28274: No ORACLE password attribute corresponding to user nickname exists error is generated due to problems with the Active Directory schema or the Oracle service directory.
- ORA-28300 Connection Errors The ORA-28030: No permission to read user entry in LDAP directory service error is generated due to permissions problems with the Oracle service directory.
- Using Trace Files to Diagnose CMU Connection Errors The trace setting gdsi tracks centrally managed users (CMU) connection errors.
## ORA-28276 Connection Errors
The `ORA-28276: Invalid ORACLE password attribute` error can result from an improperly set `orclCommonAttribute` attribute.
For example:
```
SQL> connect "myad\dev"@orcl_db Enter password: password ERROR:
ORA-28276: Invalid ORACLE password attribute.
```
This error occurs when the `orclCommonAttribute` attribute has not been correctly populated with user password. For example:
```
$ ldapsearch -h  -p 389 -D "cn=oracleservice,cn=users,dc=myad,dc=example,dc=com" -w **** -U 2 -W "file:wallet_path" -P password -b "dc=myad,dc=example,dc=com" -s sub "(sAMAccountName=def*)" dn orclCommonAttributeCN=def,CN=Users,DC=myad,DC=example,DC=com orclCommonAttribute=
```
To remedy this problem:
****
- Run the opwdintg.exe to install the password filter on every Windows domain controller in the domain for Active Directory.
****
- Restart each Windows domain controller server. Each Windows domain controller must be restarted after you install the password filter. Otherwise, the password filter will not work on the Windows domain controller.
- Assign the Active Directory users to the appropriate ORA_VFR group.
- Reset the user password on Active Directory.
- Run ldapsearch to check that the password has been generated.
## ORA-01017 Connection Errors
The `ORA-01017: invalid username/password logon denied` error can be generated due to the differences in how special characters are allowed in Oracle Database and in Microsoft Active Directory.
User names and passwords that centrally managed users (CMU) create follow different creation rules than the rules for Oracle Database user names and passwords. To remedy the problem of `ORA-01017` errors, enclose the Active Directory user’s user name and password in double quotation marks. For example, for an Active Directory user whose user name is `peter fitch` and whose password is `ILoveMySalads@_home!`, and who is in the same domain as the Oracle service user, the following login works:
```
CONNECT "peter fitch"/"ILoveMySalads@_home!"@orcl
```
If the Active Directory user is in a different domain than the Oracle service user, then the Windows domain (`EXAMPLE` in this case) must be included in the user name:
```
CONNECT "EXAMPLE\peter fitch"/"ILoveMySalads@_home!"@orcl CONNECT "EXAMPLE\peter fitch"@orcl Enter password: password
```
Note that for the password entered at the `Enter password` prompt, there are 22 characters in all: 20 characters for the `ILoveMySalads@_home!` password, plus two characters for the two double quotation marks.
## ORA-28274 Connection Errors
The `ORA-28274: No ORACLE password attribute corresponding to user nickname exists` error is generated due to problems with the Active Directory schema or the Oracle service directory.
The Active Directory schema may not have been extended or it was populated poorly. Alternatively, the Oracle service directory user does not have required permissions to access the `orclCommonAttribute` attribute of the user who tried to log in to Oracle database.
To remedy this problem:
  ****
****
  - Run the opwdintg.exe to install the password filter on every Windows domain controller in the domain for Active Directory.
****
  - Restart each Windows domain controller server. Each Windows domain controller must be restarted after you install the password filter. Otherwise, the password filter will not work on the Windows domain controller.
  - Assign the Active Directory users to the appropriate ORA_VFR group.
  - Reset the user password on Active Directory.
  - Run ldapsearch to check that the password has been generated.
  ****
````
  - Grant the Oracle service directory user account the Read Properties and Write lockoutTime, which are permissions to access the properties of the Active Directory user who tries to log in to the database.
````
  - Set permissions for Control Access on the orclCommonAttribute of the Active Directory users.
## ORA-28300 Connection Errors
The `ORA-28030: No permission to read user entry in LDAP directory service` error is generated due to permissions problems with the Oracle service directory.
You can track this error using the CMU trace. For example:
```
2023-03-27 19:51:55.0 - KZLG_ERR: failed to modify user status Insufficient access 2023-03-27 17:57:27.0 - KZLG_ERR: LDAPERR=50, OER=28300
```
To remedy this problem, In addition), and also the permission
````
- Grant the Oracle service directory user account the Read Properties and Write lockoutTime, which are permissions to access the properties of the Active Directory user who tries to log in to the database.
````
- Set permissions for Control Access on the orclCommonAttribute of the Active Directory users.
## Using Trace Files to Diagnose CMU Connection Errors
The trace setting `gdsi` tracks centrally managed users (CMU) connection errors.
As a user who has the `ALTER SYSTEM` privilege and the `SYSDBA` administrative privilege, you can enable this trace event as follows:
```
ALTER SYSTEM SET EVENTS='TRACE[GDSI] DISK LOW';
```
After the Active Directory user tries to log in, and if the login fails, go to the directory that contains the trace files and `grep` these files for the connection errors.
```
grep -i kzlg *.trc
```
Then you can collect and review the trace file that contains the detailed information.
To disable tracing, you can enter the following command:
```
ALTER SYSTEM SET EVENTS='TRACE[GDSI] OFF';
```
## Related Topics
  - Step 1: Create an Oracle Service Directory User Account on Microsoft Active Directory and Grant Permissions
  - Using Trace Files to Diagnose CMU Connection Errors
