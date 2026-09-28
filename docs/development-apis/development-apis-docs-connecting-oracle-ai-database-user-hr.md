# Connecting to Oracle Database as User HR

To complete the tutorials and examples in this topic, you must connect to Oracle Database as the user `HR`.
The user `HR` owns the `HR` sample schema that the examples and tutorials in this topic use.
## Unlocking the HR Account
You must unlock the HR account and reset its password before you can connect to Oracle Database as the user HR.
By default, when the HR schema is installed, the HR account is locked and its password is expired.
**Note:**   For the following procedure, you need the name and password of a user who has the ALTER USERsystem privilege.
**Steps to unlock the HR account and reset its password:**
- Using SQL*Plus, connect to Oracle Database as a user with the ALTER USER system privilege.
******
- At the SQL> prompt, unlock the HR account and reset its password: Caution: Choose a secure password. For guidelines for secure passwords, see Oracle Database Security Guide.
```
```
ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY password;
```
The system responds:
```
User altered.
```
The `HR` account is unlocked and its password is password.
```
You can now connect to Oracle Database as user HR with the password password.
**See Also:** **- Oracle SQL Developer User’s Guide for information about accessing SQL*Plus within SQL Developer
## Connecting to Oracle Database as User HR from SQL*Plus
You can use SQL*Plus to connect to Oracle Database as the HR user.
**Note:**   If the HR account is locked, see “Unlocking the HR Account” and then return to this section.
**Steps to connect to Oracle Database as user HR from SQL*Plus:** **Note:**   For this task, you need the password for the HR account.
- If you are connected to Oracle Database, close your current connection.
- Follow the directions in “Connecting to Oracle Database from SQL*Plus”, entering the user name HR at step 3 and the password for the HR account at step 4. You are now connected to Oracle Database as the user HR.
**See Also:**   *SQL*Plus User’s Guide and Reference* for an example of using SQL*Plus to create an `HR` connection
## Connecting to Oracle Database as User HR from SQL Developer
You can use SQL Developer to connect to Oracle Database as the HR user.
**Note:**   If the HR account is locked, see “Unlocking the HR Account” and then return to this section.
**Steps to connect to Oracle Database as user HR from SQL Developer:** **Note:**   For this task, you need the password for the HR account.
Follow the directions in “Connecting to Oracle Database from SQL Developer”, entering the following values at steps 3:
- For Connection Name, enter hr_conn. (You can enter a different name, but the tutorials in this document assume that you named the connection hr_conn.)
- For Username, enter HR.
- For Password, enter the password for the HR account.
You are now connected to Oracle Database as the user HR.
