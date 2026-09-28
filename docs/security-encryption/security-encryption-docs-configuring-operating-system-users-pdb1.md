# Configuring Operating System Users for a PDB

The `DBMS_CREDENTIAL.CREATE_CREDENTIAL` procedure configures user accounts to be operating system users for a PDB.
- About Configuring Operating System Users for a PDB Instead the oracle operating system user, you can set a specific user account to be the operating system user for that PDB.
- Configuring an Operating System User for a PDB The DBMS_CREDENTIAL.CREATE_CREDENTIAL procedure can set an operating system user for a PDB.
## About Configuring Operating System Users for a PDB
Instead the `oracle` operating system user, you can set a specific user account to be the operating system user for that PDB.
If you do not set a specific user to be the operating system user for the PDB, then by default the PDB uses the `oracle` operating system user. For the root, you can use the `oracle` operating system user when you must interact with the operating system.
For better security, Oracle recommends that you set a unique operating system user for each PDB in a multitenant environment. Doing so helps to ensure that operating system interactions are performed as a less powerful user than the `oracle` operating system user, and helps to protect data that belongs to one PDB from being accessed by users who are connected to other PDBs.
## Configuring an Operating System User for a PDB
The `DBMS_CREDENTIAL.CREATE_CREDENTIAL` procedure can set an operating system user for a PDB.
``````
```
sqlplus c##sec_admin Enter password: password
```
- Log in to the database instance root as a user who has the EXECUTE privilege for the DBMS_CREDENTIAL PL/SQL package and the ALTER SYSTEM system privilege. For example:
```
BEGIN DBMS_CREDENTIAL.CREATE_CREDENTIAL ( credential_name => 'PDB1_OS_USER', username        => 'os_admin', password        => 'password');
END;
/
```
- Run the DBMS_CREDENTIAL.CREATE_CREDENTIAL procedure to create an Oracle credential for the operating system user. For example, to set the credential for a user named os_admin:
```
CONNECT cc##sec_admin@hrpdb Enter password: password
```
````
- Connect to the PDB for which the operating system user will be used. For example: To find the available PDBs, run the show pdbs command. To check the current PDB, run the show con_name command.
```
ALTER SYSTEM SET PDB_OS_CREDENTIAL = PDB1_OS_USER SCOPE = SPFILE;
```
````
- Set the PDB_OS_CREDENTIAL initialization parameter for the user whose credential was set in Step 2. For example: The PDB_OS_CREDENTIAL parameter is a static parameter, so you must set it using the SCOPE = SPFILE clause.
```
SHUTDOWN IMMEDIATE STARTUP
```
- Restart the database instance.
## Related Topics
  - Minimum Requirements for Passwords
