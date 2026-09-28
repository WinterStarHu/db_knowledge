# Managing Passwords for Administrative Users

The passwords of administrative users have special protections, such as password files and password complexity functions.
- About Managing Passwords for Administrative Users The passwords of administrative users are stored outside of the database so that the users can be authenticated even when the database is not open.
- Setting the LOCK and EXPIRED Status of Administrative Users Administrative users whose accounts have been locked cannot connect to the database.
- Password Profile Settings for Administrative Users There are several user profile password settings that are enforced for administrative users.
- Last Successful Login Time for Administrative Users The last successful login time of administrative user connections that use password file-based authentication is captured.
``````
- Management of the Password File of Administrative Users Setting the ORAPWD utility FORMAT parameter to 12.2 enables you to manage the password profile parameters for administrative users.
````
- Migration of the Password File of Administrative Users The ORAPWD utility input_file parameter or DBUA can be used to migrate from earlier password file formats to the 12 or 12.2 format.
- How the Multitenant Option Affects Password Files for Administrative Users In a multitenant environment, the password information for the local and common administrative users is stored in different locations.
- Password Complexity Verification Functions for Administrative Users For better security, use password complexity verification functions for the passwords of administrative users.
## About Managing Passwords for Administrative Users
The passwords of administrative users are stored outside of the database so that the users can be authenticated even when the database is not open.
There is no special protection with the password file. The password verifiers must be stored outside of the database so that authentication can be performed even when the database is not open. In previous releases, password complexity functions were available for non-administrative users only. Starting with Oracle Database release 12c (12.2), password complexity functions can be used for both non-administrative users and administrative users.
## Setting the LOCK and EXPIRED Status of Administrative Users
Administrative users whose accounts have been locked cannot connect to the database.
  - To unlock locked or expired administrative accounts, use the ALTER USER statement.
For example:
```
ALTER USER hr_admin ACCOUNT UNLOCK;
```
If the administrative user’s password has expired, then the next time the user attempts to log in, the user will be prompted to create a new password.
## Password Profile Settings for Administrative Users
There are several user profile password settings that are enforced for administrative users.
These password profile parameters are as follows:
- FAILED_LOGIN_ATTEMPT
- INACTIVE_ACCOUNT_TIME
- PASSWORD_LOCK_TIME
- PASSWORD_LIFE_TIME
- PASSWORD_GRACE_TIME
## Last Successful Login Time for Administrative Users
The last successful login time of administrative user connections that use password file-based authentication is captured.
To find this login time, query the `LAST_LOGIN` column of the `V$PWFILE_USERS` dynamic performance view.
## Management of the Password File of Administrative Users
Setting the `ORAPWD` utility `FORMAT` parameter to `12.2` enables you to manage the password profile parameters for administrative users.
The password file is particularly important for administrative users because it stores the administrative user’s credentials in an external file, not in the database itself. This enables the administrative user to log in to a database that is not open and perform tasks such as querying the data dictionary views. To create the password file, you must use the `ORAPWD` utility.
The `FORMAT` parameter setting of `12.2`, which is the default setting, enables the password file to accommodate the password profile information for the administrative user.
For example:
```
orapwd file=orapworcl input_file=orapwold format=12.2
...
```
Setting `FORMAT` to `12.2` enforces the following rules:
- The password contains no fewer than 8 characters and includes at least one numeric and one alphabetic character.
- The password does not contain the user name or the user name reversed.
````
- The password does not contain the word oracle (such as oracle123).
- The password contains at least 1 special character.
`FORMAT=12.2` also applies the following internal checks:
- The password does not exceed 30 bytes.
- The password does not contain the double-quotation character ("). However, it can be surrounded by double-quotation marks.
The following user profile password settings are enforced for administrative users:
- FAILED_LOGIN_ATTEMPT
- INACTIVE_ACCOUNT_TIME
- PASSWORD_GRACE_TIME
- PASSWORD_LIFE_TIME
- PASSWORD_LOCK_TIME
You can find the administrative users who have been included in the password file and their administrative privileges by querying the `V$PWFILE_USERS` dynamic view.
## Migration of the Password File of Administrative Users
The `ORAPWD` utility `input_file` parameter or DBUA can be used to migrate from earlier password file formats to the 12 or 12.2 format.
You can migrate from earlier password file formats to the 12 or 12.2 format by using either the `ORAPWD` utility file and `input_file` parameters, or by using Oracle Database Upgrade Assistant (DBUA).
****``````
- The ORAPWD FILE and INPUT_FILE parameters: To migrate using the ORAPWD utility, set the FILE parameter to a name for the new password file and the INPUT_FILE parameter to the name of the earlier password file. For example:
```
orapwd file=orapworcl input_file=orapwold format=12.2
```
  ****````````- DBUA:To migrate from the earlier formats of password files (FORMAT = LEGACY and FORMAT = 12), you can use the DBUA when you upgrade an earlier database to the current release. However, ensure that the database is open in read-only mode. You can check the database read-only status by querying the OPEN_MODE column of the V$DATABASE dynamic view.
## How the Multitenant Option Affects Password Files for Administrative Users
In a multitenant environment, the password information for the local and common administrative users is stored in different locations.
****
- For CDB administrative users: The password information (hashes of the password) for the CDB common administrative users to whom administrative privileges were granted in the CDB root is stored in the password file.
****
- For all users in a CDB to whom administrative privileges were granted outside the CDB root: To view information about the password hash information of these users, query the $PWFILE_USERS dynamic view.
## Password Complexity Verification Functions for Administrative Users
For better security, use password complexity verification functions for the passwords of administrative users.
Note the following:
****````````
- Profiles: You can specify a password complexity verification function for the SYS user by using the PASSWORD_VERIFY_FUNCTION clause of the CREATE PROFILE or ALTER PROFILE statement. Oracle recommends that you use password verification functions to better protect the passwords of administrative users.
****````````````
  - The password contains no fewer than 8 characters and includes at least one numeric character, one alphabetic character, and one special character.
  - The password is not the same as the user name or the user name reversed.
````
  - The password does not contain the word oracle (such as oracle123).
  - The password differs from the previous password by at least three characters.
The following internal checks are also applied:
  - The password does not exceed 30 bytes.
  - The password does not contain the double-quotation character ("). However, it can be surrounded by double-quotation marks.
## Related Topics
  - Managing Resources with Profiles
**- Oracle Database Administrator’s Guide
  - Managing the Complexity of Passwords
