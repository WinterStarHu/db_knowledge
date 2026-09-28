# Controlling Definer’s Rights Privileges for Database Links

You can control privilege grants for definer’s rights procedures if your applications use database links and definer’s rights procedures.
- About Controlling Definer’s Rights Privileges for Database Links When a definer’s rights procedure connects to a database link, operations on the database link should use the procedure owner’s credentials.
- Grants of the INHERIT REMOTE PRIVILEGES Privilege to Other Users The INHERIT REMOTE PRIVILEGES privilege enables the current user to have explicit privileges over the connected user in the database.
- Example: Granting INHERIT REMOTE PRIVILEGES on a Connected User You can grant the INHERIT REMOTE PRIVILEGES privilege on a connected user to the current user.
````
- Grants of the INHERIT ANY REMOTE PRIVILEGES Privilege to Other Users The INHERIT ANY REMOTE PRIVILEGES privilege enables the grantee user to open a connected_user database link as any user.
````
- Revokes of the INHERIT [ANY] REMOTE PRIVILEGES Privilege The methods for revoking the INHERIT REMOTE PRIVILEGES and INHERIT ANY REMOTE PRIVILEGES privileges differ.
````
- Example: Revoking the INHERIT REMOTE PRIVILEGES Privilege The REVOKE SQL statement can revoke the INHERIT REMOTE PRIVILEGES privilege.
``````
- Example: Revoking the INHERIT REMOTE PRIVILEGES Privilege from PUBLIC The REVOKE SQL statement can revoke the INHERIT REMOTE PRIVILEGES from PUBLIC, as well as from individual procedure owners.
- Tutorial: Using a Database Link in a Definer’s Rights Procedure This tutorial demonstrates how the INHERIT REMOTE PRIVILEGES privilege works in a definer’s rights procedure that uses a database link.
## About Controlling Definer’s Rights Privileges for Database Links
When a definer’s rights procedure connects to a database link, operations on the database link should use the procedure owner’s credentials.
The `INHERIT REMOTE PRIVILEGES` and `INHERIT ANY REMOTE PRIVILEGES` privileges apply when a connected user database link is used with a definer’s rights procedure. These privileges allow the use of the credentials of the logged-in user for connected user database link operations with definer rights procedures.
You can perform a grant of the `INHERIT REMOTE PRIVILEGES` and `INHERIT ANY REMOTE PRIVILEGES` privileges so the users who invoke the definer’s rights procedure can use a connected user database link within a definer’s rights block. A definer’s rights procedure executes with the privileges of the procedure owner. However, a connected user database link operation must have the credentials of the logged in user. Hence, the `INHERIT REMOTE PRIVILEGES` and `INHERIT ANY REMOTE PRIVILEGES` privileges are required to be granted to enable the database link operations within the definer’s rights block.
Be aware that during an upgrade, the `INHERIT REMOTE PRIVILEGES` and `INHERIT ANY REMOTE PRIVILEGES` privileges are not granted by default to any existing users.
The `INHERIT REMOTE PRIVILEGES` and `INHERIT ANY REMOTE PRIVILEGES` privileges apply only to situations in which users are trying to connect to user database links in a definer’s rights procedure. In addition, these privileges apply to both privately created and publicly created database links. By default, database links are created as private links. In addition, by default, `INHERIT REMOTE PRIVILEGES` is not granted to `PUBLIC`.
The ways that you can perform grants of these privileges are as follows:
``````````
- GRANT INHERIT REMOTE PRIVILEGES ON USER dbuser_1 TO dbuser_2: In this scenario, dbuser_1 can explicitly grant the INHERIT REMOTE PRIVILEGE privilege to dbuser_2 and use a definer’s rights procedure that user dbuser_2 owns.
````````
- GRANT INHERIT REMOTE PRIVILEGES ON USER dbuser_1 TO PUBLIC. In this scenario, dbuser_1 grants the INHERIT REMOTE PRIVILEGE privilege to public. This grant enables dbuser_1 to use the definer’s rights procedures that any other user owns.
````
- GRANT INHERIT ANY REMOTE PRIVILEGES TO dbuser_2: In this scenario, any user can use the definer’s rights procedures that dbuser_2 owns.
If the user does not have the `INHERIT REMOTE PRIVILEGE` privilege and tries to execute the definer’s rights privilege, then the `ORA-25433: User does not have INHERIT REMOTE PRIVILEGES` error appears.
## Grants of the INHERIT REMOTE PRIVILEGES Privilege to Other Users
The `INHERIT REMOTE PRIVILEGES` privilege enables the current user to have explicit privileges over the connected user in the database.
The syntax for granting the `INHERIT REMOTE PRIVILEGES` privilege is as follows:
```
GRANT INHERIT REMOTE PRIVILEGES ON USER connected_user TO current_user:
```
In this specification:
- connected_user is the user who runs the definer’s rights procedure.
````
- current_user is the user who owns the definer’s right procedure. This value must be a database user account. As an alternative to granting the INHERIT REMOTE PRIVILEGES privilege to the procedure’s owner, you can grant the privilege to a role that is in turn granted to the procedure.
Users or roles who own the definer’s rights procedures must have the `INHERIT REMOTE PRIVILEGES` privilege granted to them by users who will run their definer’s rights procedures.
Any user can grant or revoke the `INHERIT REMOTE PRIVILEGES` privilege on themselves to the user whose definer’s rights procedures they want to run.
## Example: Granting INHERIT REMOTE PRIVILEGES on a Connected User
You can grant the `INHERIT REMOTE PRIVILEGES` privilege on a connected user to the current user.
In this example, the connected user, `jward`, must have remote privileges on the current user, `ebrown`. This enables `jward` to execute the definer’s right procedure that `ebrown` created.
Example 9-4 shows how an administrator (or user `jward`) can grant the `INHERIT REMOTE PRIVILEGES` on user `jward` to user `ebrown`. This privilege grant enables any definer’s rights procedure that `ebrown` writes, or will write in the future, to access `ebrown`’s privileges when the procedure is run.
Example 9-4 Granting INHERIT REMOTE PRIVILEGES on a Connected User to the Current User
```
GRANT INHERIT REMOTE PRIVILEGES on user jward to ebrown;
```
## Grants of the INHERIT ANY REMOTE PRIVILEGES Privilege to Other Users
The `INHERIT ANY REMOTE PRIVILEGES` privilege enables the grantee user to open a `connected_user` database link as any user.
As with all `ANY` privileges, `INHERIT ANY REMOTE PRIVILEGES` is a powerful privilege that must only be granted to trusted users. By default, user `SYS` has the `INHERIT ANY REMOTE PRIVILEGES` system privilege `WITH GRANT OPTION`. To find users who have been granted the `INHERIT ANY REMOTE PRIVILEGES` privilege, query the `DBA_SYS_PRIVS` data dictionary view.
For better security in a multitenant environment, Oracle recommends that you protect the `INHERIT ANY REMOTE PRIVILEGES` privilege with a PDB lockdown profile. A PDB lockdown profile prevents local pluggable database (PDB) users from opening a connected user database link as a common user, irrespective of the kind of `INHERIT REMOTE PRIVILEGE` the PDB user has. If the PDB is protected by a PDB lockdown profile, then grants such as `GRANT INHERIT REMOTE PRIVILEGES` and `GRANT INHERIT ANY REMOTE` privileges succeed but the effects of these grants do not apply as long as the PDB lockdown continues.
The syntax for granting the `INHERIT ANY REMOTE PRIVILEGES` privilege is as follows:
```
GRANT INHERIT ANY REMOTE PRIVILEGES TO current_user;
```
In this specification, `current_user` is the user who owns the define’s right procedure.
## Revokes of the INHERIT [ANY] REMOTE PRIVILEGES Privilege
The methods for revoking the `INHERIT REMOTE PRIVILEGES` and `INHERIT ANY REMOTE PRIVILEGES` privileges differ.
The `INHERIT REMOTE PRIVILEGES` privilege can be revoked by a user from another user. The `INHERIT ANY REMOTE PRIVILEGES` privilege must be revoked by a user with administrative privileges.
The revocation syntax is as follows
```
REVOKE INHERIT REMOTE PRIVILEGES ON USER connected_user FROM current_user;
```
In this specification:
- connected_user is the user who runs the definer’s rights procedure.
- current_user is the user who owns the definer’s rights procedure.
If you want to revoke the `INHERIT REMOTE PRIVILEGES` or `INHERIT ANY REMOTE PRIVILEGES` privilege from a user, use the standard revocation syntax, as follows:
```
REVOKE INHERIT REMOTE PRIVILEGES FROM connected_user;
REVOKE INHERIT ANY REMOTE PRIVILEGES FROM current_user;
```
## Example: Revoking the INHERIT REMOTE PRIVILEGES Privilege
The `REVOKE` SQL statement can revoke the `INHERIT REMOTE PRIVILEGES` privilege.
After you revoke the `INHERIT REMOTE PRIVILEGES` privilege, if user `jward` executes a definer’s rights procedure that `jward` owns, then any operation on a connected user database link inside the definer’s rights procedure fails because `jward` has explicitly denied `ebrown` the privilege to open a connected user database link using `jward`‘credentials.
Example 9-5 shows how to revoke the `INHERIT REMOTE PRIVILEGES` procedure on the connecting user, `jward`, from the procedure owner, `ebrown`.
Example 9-5 Revoking the INHERIT REMOTE PRIVILEGES Privilege
```
REVOKE INHERIT REMOTE PRIVILEGES ON USER jward FROM ebrown;
```
## Example: Revoking the INHERIT REMOTE PRIVILEGES Privilege from PUBLIC
The `REVOKE` SQL statement can revoke the `INHERIT REMOTE PRIVILEGES` from `PUBLIC`, as well as from individual procedure owners.
Example 9-6 shows how to revoke this privilege from `PUBLIC`.
Example 9-6 Revoking the INHERIT REMOTE PRIVILEGES Privilege from PUBLIC
```
REVOKE INHERIT REMOTE PRIVILEGES FROM PUBLIC;
```
## Tutorial: Using a Database Link in a Definer’s Rights Procedure
This tutorial demonstrates how the `INHERIT REMOTE PRIVILEGES` privilege works in a definer’s rights procedure that uses a database link.
- About This Tutorial In this tutorial, you test the privilege grant and revoke of the INHERIT REMOTE PRIVILEGES privilege.
- Step 1: Create User Accounts You must create a user who creates a definer’s rights procedure that has a database link, and a second user who executes this procedure.
- Step 2: As User dbuser2, Create a Table to Store User IDs The user IDs in this table are the IDs that the database link uses.
- Step 3: As User dbuser1, Create a Database Link and Definer’s Rights Procedure User dbuser1 is ready to create a database link and then a definer’s rights procedure that references the database link.
``````
- Step 4: Test the Definer’s Rights Procedure User dbuser2 must grant INHERIT REMOTE PRIVILEGES to dbuser1 before the definer’s rights procedure can be tested.
- Step 5: Remove the Components of This Tutorial If you no longer need the components of this tutorial, then you can remove them.
### About This Tutorial
In this tutorial, you test the privilege grant and revoke of the `INHERIT REMOTE PRIVILEGES` privilege.
To accomplish this, you must create two users, one who creates a definer’s rights procedure that refers to a database link, and a second user to execute this definer’s rights procedure. Both users create identical look-up tables in their schemas. The definer’s rights procedure must enable the second user to query the lookup table that belongs to the definer’s rights users.
### Step 1: Create User Accounts
You must create a user who creates a definer’s rights procedure that has a database link, and a second user who executes this procedure.
- Connect as a user who has privileges to create users and perform privilege grants. For example:
```
sqlplus sec_admin Enter password: password
```
  - Create the user accounts as follows:
```
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO dbuser1 IDENTIFIED BY password;
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO dbuser2 IDENTIFIED BY password;
```
```
Follow the guidelines in [Minimum Requirements for Passwords](minimum-requirements-passwords.html#GUID-AA1AA635-1CD5-422E-B8CA-681ED7C253CA) to replace *password* with a password that is secure.
```
### Step 2: As User dbuser2, Create a Table to Store User IDs
The user IDs in this table are the IDs that the database link uses.
  ````- Connect as user dbuser2 to instance inst1.
```
connect dbuser2@inst1
Enter password: password
```
  - Create the following table:
```
CREATE TABLE dbusertab(ID NUMBER(2));
```
  - Populate this table with the ID value 10.
```
INSERT INTO dbusertab VALUES(10);
```
### Step 3: As User dbuser1, Create a Database Link and Definer’s Rights Procedure
User `dbuser1` is ready to create a database link and then a definer’s rights procedure that references the database link.
  ````- Connect as user dbuser1 to instance inst1.
```
connect dbuser1@inst1 Enter password: password
```
  - Create a database link, which will be used in the definer’s rights procedure.
```
CREATE DATABASE LINK dblink USING 'inst1';
```
  ````- Create a dbusertab table and then populate it with the ID 20.
```
CREATE TABLE DBUSERTAB(ID NUMBER(2));
INSERT INTO dbusertab VALUES(20);
```
  - Create a definer’s rights procedure that contains a reference to the database lnk
```
CREATE OR REPLACE PROCEDURE test_remote_db_link
AS
v_id varchar(50);
BEGIN
    SELECT ID INTO v_id FROM dbusertab@dblink;
    DBMS_OUTPUT.PUT_LINE('v_id : ' || v_id);
END ;
/
```
  - Test the definer’s rights procedure.
```
SET SERVEROUTPUT ON
EXEC test_remote_db_link;
```
```
The output should be as follows, indicating that user `dbuser1` has executed the procedure on his own version of the table `dbusertab`:
```
```
v_id : 20
```
  ``````- Grant the user dbuser2 the EXECUTE privilege on the test_remote_db_link procedure.
```
GRANT EXECUTE ON test_remote_db_link TO dbuser2;
```
### Step 4: Test the Definer’s Rights Procedure
User `dbuser2` must grant `INHERIT REMOTE PRIVILEGES` to `dbuser1` before the definer’s rights procedure can be tested.
  ````- Connect as user dbuser2 to instance inst1.
```
connect dbuser2@inst1
Enter password: password
```
  ``````- Grant the INHERIT REMOTE PRIVILEGE privilege on user dbuser2 to dbuser1.
```
GRANT INHERIT REMOTE PRIVILEGES ON user dbuser2 TO dbuser1;
```
  - Relog back in, because the grant does not take effect until you start a new session.
```
connect dbuser2@inst1 Enter password: password
```
  - Execute the test_remote_db_link definer’s rights procedure:
```
SET SERVEROUTPUT ON EXEC dbuser1.test_remote_db_link;
```
```
The output shows the following, which indicates that user `dbuser1` is able to use the database link to connect to the schema of `dbuser2` and access the values in the `dbusertab` table in `dbuser2`'s schema.
```
```
v_id : 10
```
  ``````- Revoke the INHERIT REMOTE PRIVILEGE privilege on dbuser2 from dbuser1.
```
REVOKE INHERIT REMOTE PRIVILEGES ON USER dbuser2 FROM dbuser1;
```
  - Try executing the test_remote_db_link definer’s rights procedure again.
```
EXEC dbuser1.test_remote_db_link;
```
```
The `ORA-25433: User DBUSER1 does not have INHERIT REMOTE PRIVILEGES on connected user DBUSER2` error should appear.
```
### Step 5: Remove the Components of This Tutorial
If you no longer need the components of this tutorial, then you can remove them.
- Connect as a user who has privileges to drop user accounts and database links For example:
```
connect sec_admin
Enter password: password
```
  - Drop the user accounts.
```
DROP USER dbuser1 CASCADE;
DROP USER dbuser2 CASCADE;
```
  - Drop the dblink database link.
```
DROP PUBLIC DATABASE LINK dblink;
```
## Related Topics
  - Restricting Operations on PDBs Using PDB Lockdown Profiles
**- Oracle Database SQL Language Reference for more information about the REVOKE SQL statement
