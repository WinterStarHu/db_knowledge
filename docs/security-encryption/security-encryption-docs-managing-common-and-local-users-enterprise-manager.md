# Managing Common and Local Users in Enterprise Manager

In a multitenant environment, Oracle Enterprise Manager enables you to create, edit, and drop common and local users.
This section contains the following topics:
- Creating a Common User Account in Enterprise Manager A common user is a user that exists in the root and can access PDBs in the CDB.
- Editing a Common User Account in Enterprise Manager You can edit a common user account from the root.
- Dropping a Common User Account in Enterprise Manager You can drop a common user from the CDB root.
- Creating a Local User Account in Enterprise Manager A local user is a user that exists only in a specific PDB and does not have access to any other PDBs in the multitenant environment.
- Editing a Local User Account in Enterprise Manager You can edit a local user from the PDB in which the local user resides.
- Dropping a Local User Account in Enterprise Manager You can drop a local user from the PDB in which the local user resides.
## Creating a Common User Account in Enterprise Manager
A common user is a user that exists in the root and can access PDBs in the CDB.
````
- From the Enterprise Manager database home page, log in to the root as a common user who has the common CREATE USER and SET CONTAINER privileges.
************
- From the Administration menu, select Security, then Users. If prompted, enter your login information. Afterward, the Users page appears.
****
- Click Create. The Create User page appears. Description of the illustration em_com_user_create2.gif
````
- Select the options to create a common user and grant this user privileges. Ensure that you preface the user name with C## or c##.
********
- Click OK or Apply. The common user is created in the root and will appear in the Users page for any associated PDBs.
## Editing a Common User Account in Enterprise Manager
You can edit a common user account from the root.
````
````
  - If you are logging into the root, then ensure that you are a common user who has the common CREATE USER and SET CONTAINER privileges.
  - If you are logging into a PDB, ensure that you have the CREATE USER privilege for that PDB.
************
- From the Administration menu, select Security, then Users. If prompted, enter your login information. Afterward, the Users page appears. In the root, only common users are listed. In the PDB, both common and local users are listed.
****
- Select the common user to be edited and then click Edit. The Edit User page appears. For a common user in the root, you can modify all settings for the common user. For a common user in a PDB, you cannot change the user password, default tablespace, and temporary tablespace. The settings that you make apply only to the current PDB. The following screen shows how a common user Edit User page appears in a PDB. Description of the illustration em_com_user_edit.gif
- Modify the common user as necessary.
****
- Click Apply.
## Dropping a Common User Account in Enterprise Manager
You can drop a common user from the CDB root.
````
- From the Enterprise Manager database home page, log in to the root as a common user who has the common CREATE USER and SET CONTAINER privileges. You cannot drop common users from PDBs.
************
- From the Administration menu, select Security, then Users. If prompted, enter your login information. Afterward, the Users page appears, listing only common users.
****
- Select the common user that you want to drop and then click Delete.
- Confirm that you want to delete the common user.
## Creating a Local User Account in Enterprise Manager
A local user is a user that exists only in a specific PDB and does not have access to any other PDBs in the multitenant environment.
- From the Enterprise Manager database home page, log in to the root as a local or common user who has the local CREATE USER privilege.
************
- From the Administration menu, select Security, then Users. If prompted, enter your login information. Afterward, the Users page appears, showing only local users for the current PDB.
****
- Click Create. The Create User page appears.
````
- Select the options that create a local user and grant this user privileges. Ensure that you do not preface the user name with C## or c##.
****
- Click OK. The local user is created in the current PDB.
## Editing a Local User Account in Enterprise Manager
You can edit a local user from the PDB in which the local user resides.
- From the Enterprise Manager database home page, log in to the PDB as a local or common user who has the local CREATE USER privilege.
************
- From the Administration menu, select Security, then Users. If prompted, enter your login information. Afterward, the Users page appears, showing only local users for the current PDB and common users.
****
- Select the local user to be edited and then click Edit. The Edit User page appears.
- Modify the local user as necessary.
****
- Click Apply.
## Dropping a Local User Account in Enterprise Manager
You can drop a local user from the PDB in which the local user resides.
- From the Enterprise Manager database home page, log in to the PDB as a local or common user who has the local CREATE USER privilege.
************
- From the Administration menu, select Security, then Users. If prompted, enter your login information. Afterward, the Users page appears, showing only local users for the current PDB and common users. (You cannot drop common users from a PDB.)
****
- Select the local user you want to drop and then click Delete. Enterprise Manager prompts you to confirm deletion of the user.
- Confirm that you want to delete the local user.
## Related Topics
  - Logging into a Multitenant Environment in Enterprise Manager
  - Methods of Altering Common or Local User Accounts
  - About Creating Local User Accounts
