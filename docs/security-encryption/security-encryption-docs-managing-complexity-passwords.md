# Managing the Complexity of Passwords

Oracle Database provides a set of functions that you can use to manage the complexity of passwords.
- About Password Complexity Verification Complexity verification checks that each password is complex enough to protect against intruders who try to guess user passwords.
- How Oracle Database Checks the Complexity of Passwords Oracle Database provides four password verification functions to check password complexity.
- Who Can Use the Password Complexity Functions? The password complexity functions enable you to customize how users access your data.
**
- verify_function_11G Function Password Requirements The verify_function_11G function originated in Oracle Database Release 11g.
**
- ora12c_verify_function Password Requirements The ora12c_verify_function function fulfills the Department of Defense Database Security Technical Implementation Guide requirements.
- ora12c_strong_verify_function Function Password Requirements The ora12c_strong_verify_function function is a stringent password verify function.
- ora12c_stig_verify_function Password Requirements The ora12c_stig_verify_function function fulfills the Security Technical Implementation Guides (STIG) requirements.
- About Customizing Password Complexity Verification Oracle Database enables you to customize password complexity for your site.
- Enabling Password Complexity Verification The catpvf.sql script can be customized to enable password complexity verification.
## About Password Complexity Verification
Complexity verification checks that each password is complex enough to protect against intruders who try to guess user passwords.
Using a complexity verification function forces users to create strong, secure passwords for database user accounts. You must ensure that the passwords for your users are complex enough to provide reasonable protection against intruders who try to break into the system by guessing passwords.
## How Oracle Database Checks the Complexity of Passwords
Oracle Database provides four password verification functions to check password complexity.
These functions are in the `catpvf.sql ` PL/SQL script (located in `$ORACLE_HOME/rdbms/admin`). When these functions are enabled, they can check whether users are correctly creating or modifying their passwords. When enabled, password complexity checking is not enforced for user `SYS`; it only applies to non-`SYS` users. For better security of passwords, Oracle recommends that you associate the password verification function with the default profile. About Customizing Password Complexity Verification provides an example of how to accomplish this.
## Who Can Use the Password Complexity Functions?
The password complexity functions enable you to customize how users access your data.
Before you can use the password complexity verification functions in the `CREATE PROFILE` or `ALTER PROFILE` statement, you must be granted the `EXECUTE` privilege on them.
The password verification functions are located in the `SYS` schema.
## verify_function_11G Function Password Requirements
The `verify_function_11G` function originated in Oracle Database Release 11*g*.
**Note:**   The `verify_function_11G` function has been deprecated because it enforces the weaker password restrictions from earlier releases of Oracle Database. Instead, you should use the `ORA12C_VERIFY_FUNCTION`, `ORA12C_STRONG_VERIFY_FUNCTION`, `ORA12C_STIG_VERIFY_FUNCTION` functions, which enforce stronger, more up-to-date password verification restrictions.
This function checks for the following requirements when users create or modify passwords:
- The password contains no fewer than 8 characters and includes at least one numeric and one alphabetic character.
- The password is not the same as the user name, nor is it the user name reversed or with the numbers 1–100 appended.
- The password is not the same as the server name or the server name with the numbers 1–100 appended.
````
- The password does not contain oracle (for example, oracle with the numbers 1–100 appended).
``````````````````
- The password is not too simple (for example, welcome1, database1, account1, user1234, password1, oracle123, computer1, abcdefg1, or change_on_install).
- The password differs from the previous password by at least 3 characters.
The following internal check is also applied:
  - The password does not contain the double-quotation character ("). However, it can be surrounded by double-quotation marks.
## ora12c_verify_function Password Requirements
The `ora12c_verify_function` function fulfills the *Department of Defense Database Security Technical Implementation Guide* requirements.
This function checks for the following requirements when users create or modify passwords:
- The password contains no fewer than 8 characters and includes at least one numeric and one alphabetic character.
- The password is not the same as the user name or the user name reversed.
- The password is not the same as the database name.
````
- The password does not contain the word oracle (such as oracle123).
- The password differs from the previous password by at least 3 characters.
- The password contains at least 1 special character.
The following internal check is also applied:
  - The password does not contain the double-quotation character ("). However, it can be surrounded by double-quotation marks.
## ora12c_strong_verify_function Function Password Requirements
The `ora12c_strong_verify_function` function is a stringent password verify function.
This function checks for the following requirements when users create or modify passwords:
- The password contains no fewer than 9 characters.
- The password contains at least 2 upper case letters.
- The password contains at least 2 lower case letters.
- The password contains at least 2 numeric characters.
- The password contains at least 2 special characters. These special characters are as follows:
```
' ~ ! @ # $ % ^ & * ( ) _ - + = { } [ ] \ /  , . ; ? ' : | (space)
```
  - The password differs from the previous password by at least 4 characters.
The following internal check is also applied:
  - The password does not contain the double-quotation character ("). It can be surrounded by double-quotation marks, however.
## ora12c_stig_verify_function Password Requirements
The `ora12c_stig_verify_function` function fulfills the Security Technical Implementation Guides (STIG) requirements.
This function checks for the following requirements when users create or modify passwords:
- The password has at least 15 characters.
- The password has at least 1 lower case character and at least 1 upper case character.
- The password has at least 1 digit.
- The password has at least 1 special character.
- The password differs from the previous password by at least 8 characters.
The following internal check is also applied:
  - The password does not contain the double-quotation character ("). However, it can be surrounded by double-quotation marks.
The `ora12c_stig_verify_function` function is the default handler for the `ORA_STIG_PROFILE` profile, which is available in a newly-created or upgraded Oracle database.
## About Customizing Password Complexity Verification
Oracle Database enables you to customize password complexity for your site.
You can create your own password complexity verification function in the `SYS` schema, similar to the functions that are defined in `admin/catpvf.sql`. In fact, Oracle recommends that you do so to further secure your site’s passwords.
Note the following:
- Do not include Data Definition Language (DDL) statements in the custom password complexity verification function. DDLs are not allowed during the execution of password complexity verification functions.
- Do not modify the admin/catpvf.sql script or the Oracle-supplied password complexity functions. You can create your own functions based on the contents of these files.
````
- If you make no modifications to the utlpwdmg.sql script, then it uses the ora12c_verify_function function as the default function.
## Enabling Password Complexity Verification
The `catpvf.sql` script can be customized to enable password complexity verification.
To enable password complexity verification, you must edit the `catpvf.sql` script to use the password verification function that you want, and then run the script to enable it.
- Log in to SQL*Plus with administrative privileges. For example:
```
CONNECT SYSTEM
Enter password: password
```
  ````- Run the catpvf.sql script (or your modified version of this script) to create the password complexity functions in the SYS schema.
```
@$ORACLE_HOME/rdbms/admin/catpvf.sql
```
- Grant any users who must use this function the EXECUTE privilege on it. For example:
```
GRANT pmsith EXECUTE ON ora12c_strong_verify_function;
```
````
``````
  - Log in to SQL*Plus with administrator privileges and use the CREATE PROFILE or ALTER PROFILE statement to enable the function. Ensure that you have the EXECUTE privilege on the function. For example, to update the default profile to use the ora12c_strong_verify_function function:
```
ALTER PROFILE default LIMIT PASSWORD_VERIFY_FUNCTION ora12c_strong_verify_function;
```
```
- In Oracle Enterprise Manager Cloud Control, from the **Administration** menu, select **Security**, and then **Profiles**. Select the **Password** tab. Under **Complexity**, from the **Complexity function** list, select the name of the complexity function that you want. Click **Apply**.
```
After you have enabled password complexity verification, it takes effect immediately. If you must disable it, then run the following statement:
```
ALTER PROFILE DEFAULT LIMIT PASSWORD_VERIFY_FUNCTION NULL;
```
```

```
## Related Topics
  - Guideline 1 in Guidelines for Securing Passwords for general advice on creating passwords
