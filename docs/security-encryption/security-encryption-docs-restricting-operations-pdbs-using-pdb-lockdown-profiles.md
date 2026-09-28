# Restricting Operations on PDBs Using PDB Lockdown Profiles

You can use PDB lockdown profiles in a multitenant environment to restrict sets of user operations in pluggable databases (PDBs).
This section contains the following topics:
- About PDB Lockdown Profiles A PDB lockdown profile is a named set of features that controls a group of operations.
- PDB Lockdown Profile Inheritance PDB lockdown profiles have inheritance behaviors between the CDB root, the application root, and their associated PDBs.
- Default PDB Lockdown Profiles Oracle Database provides a set of default PDB lockdown profiles that you can customize for your site requirements.
- Creating a PDB Lockdown Profile To create a PDB lockdown profile, you must have the CREATE LOCKDOWN PROFILE system privilege.
- Enabling or Disabling a PDB Lockdown Profile To enable or disable a PDB lockdown profile, use the PDB_LOCKDOWN initialization parameter
- Dropping a PDB Lockdown Profile To drop a PDB lockdown profile, you must have the DROP LOCKDOWN PROFILE system privilege and be logged into the CDB or application root.
## About PDB Lockdown Profiles
A PDB lockdown profile is a named set of features that controls a group of operations.
In some cases, you can enable or disable operations individually. For example, a PDB lockdown profile can contain settings to disable specific clauses that come with the `ALTER SYSTEM` statement.
PDB lockdown profiles restrict user access to the functionality the features provided, similar to resource limits that are defined for users. As the name suggests, you use PDB lockdown profiles in a CDB, for an application container, or for a PDB or application PDB. You can create custom profiles to accommodate the requirements of your site. PDB profiles enable you to define custom security policies for an application. In addition, you can create a lockdown profile that is based on another profile, called a **base profile**. You can configure this profile to be dynamically updated when the base profile is modified, or configure it to be static (unchanging) when the base profile is updated. Lockdown profiles are designed for both Oracle Cloud and on-premises environments.
When identities are shared between PDBs, elevated privileges may exist. You can use lockdown profiles to prevent this elevation of privileges. Identities can be shared in the following situations:
- At the operating system level, when the database interacts with operating system resources such as files or processes
- At the network level, when the database communicates with other systems, and network identity is important
- Inside the database, as PDBs access or create common objects or they communicate across container boundaries using features such as database links
The features that use shared identifies and that benefit from PDB lockdown profiles are in the following categories:
****````````````
- Network access features. These are operations that use the network to communicate outside the PDB. For example, the PL/SQL packages UTL_TCP, UTL_HTTP, UTL_MAIL, UTL_SNMP, UTL_INADDR, and DBMS_DEBUG_JDWP perform these kinds of operations. Currently, ACLs are used to control this kind of access to share network identity.
****
- Common user or object access. These are operations in which a local user in the PDB can proxy through common user accounts or access objects in a common schema. These kinds of operations include adding or replacing objects in a common schema, granting privileges to common objects, accessing common directory objects, granting the INHERIT PRIVILEGES role to a common user, and manipulating a user proxy to a common user.
****````
- Operating System access. For example, you can restrict access to the UTL_FILE or DBMS_FILE_TRANSFER PL/SQL packages.
****
- Connections. For example, you can restrict common users from connecting to the PDB or you can restrict a local user who has the SYSOPER administrative privilege from connecting to a PDB that is open in restricted mode.
The general procedure for creating a PDB lockdown profile is to first create it in the CDB root or the application root using the `CREATE LOCKDOWN PROFILE` statement, and then use the `ALTER LOCKDOWN PROFILE` statement to add the restrictions.
To enable a PDB lockdown profile, you can use the `ALTER SYSTEM` statement to set the `PDB_LOCKDOWN` parameter. You can find information about existing PDB lockdown profiles by connecting to CDB or application root and querying the `DBA_LOCKDOWN_PROFILES` data dictionary view. A local user can find the contents of a PDB lockdown parameter by querying the `V$LOCKDOWN_RULES` dynamic data dictionary view.
## PDB Lockdown Profile Inheritance
PDB lockdown profiles have inheritance behaviors between the CDB root, the application root, and their associated PDBs.
````````
  - The PDB_LOCKDOWN parameter setting in a CDB PDB takes precedence over the PDB_LOCKDOWN parameter setting in the CDB root. Similarly, the PDB_LOCKDOWN setting in an application PDB takes precedence over a PDB_LOCKDOWN setting in the application root.
````
  - If a CDB PDB (or an application PDB) does not have the PDB_LOCKDOWN parameter set, then the PDB inherits the settings of the PDB_LOCKDOWN parameter in the CDB root (or the application root).
````
  - If the application root does not have the PDB_LOCKDOWN parameter set, then the application root inherits the settings of the PDB_LOCKDOWN parameter in the CDB root.
````
- If the PDB_LOCKDOWN parameter in a CDB PDB or an application PDB is set to a CDB lockdown profile, then the PDB ignores any lockdown profiles that are set by the PDB_LOCKDOWN parameter in the CDB root or the application root.
````
- PDB lockdown parameters can inherit rules that are stipulated in an application lockdown profile, including the disable rules that come from a CDB lockdown profile that was set in its nearest ancestor (that is, an application root or the CDB root). This applies in the case of when a PDB_LOCKDOWN parameter in an application PDB is set to an application lockdown profile while the PDB_LOCKDOWN parameter in the application root or the CDB root is set to a CDB lockdown profile.
````
- Sometimes a conflict arises between the rules that comprise a CDB lockdown profile and an application lockdown profile. In this case, the rules in the CDB lockdown profile take precedence. For example, the setting for an OPTION_VALUE clause in the CDB lockdown profile takes precedence over the setting for the OPTION_VALUE clause in an application lockdown profile.
## Default PDB Lockdown Profiles
Oracle Database provides a set of default PDB lockdown profiles that you can customize for your site requirements.
By default, most of these profiles are empty. They are designed to be a placeholder or template for you to configure, depending on your deployment requirements.
Detailed information about these profiles is as follows:
  - Must have the same database administrator for each PDB
  - Different users permitted to connect to the database
  - Different applications permitted
`PRIVATE_DBAAS` permits users to connect to the PDBs but prevents them from using Oracle Database administrative features.
  - Must have the same database administrator for each PDB
  - Different users permitted to connect to the database
  - Must use the same application
The `SAAS` lockdown profile is more restrictive than the `PRIVATE_DBAAS` profile. Users can be different, but the application code is the same; users are prevented from directly connecting and must connect only through the application; and users are not granted the ability to perform any administrative features.
  - Different DBAs in each PDB
  - Different users
  - Different applications
The `PUBLIC_DBAAS` lockdown profile is the most restrictive of the lockdown profiles.
## Creating a PDB Lockdown Profile
To create a PDB lockdown profile, you must have the `CREATE LOCKDOWN PROFILE` system privilege.
After you create the lockdown profile, you can add restrictions before enabling it.
```
CONNECT c##sec_admin
Enter password: password
```
- Connect to the CDB root or the application root as a user who has the CREATE LOCKDOWN PROFILE system privilege. For example, to connect to the CDB root:
```
CREATE LOCKDOWN PROFILE profile_name
[FROM static_base_profile | INCLUDING dynamic_base_profile];
```
``````
  - profile_name is the name that you assign the lockdown profile. You can find existing names by querying the PROFILE_NAMES column of the DBA_LOCKDOWN_PROFILES data dictionary view.
  - FROM static_base_profile creates a new lockdown profile by using the values from an existing profile. Any subsequent changes to the base profile will not affect the new profile.
````````
  - INCLUDING dynamic_base_profile also creates a new lockdown profile by using the values from an existing base profile, except that this new lockdown profile will inherit the DISABLE STATEMENT rules that comprise the base profile, as well as any subsequent changes to the base profile. If rules that are explicitly added to the new profile conflict with the rules in the base profile, then the rules in the base profile take precedence. For example, an OPTION_VALUE clause in the base profile takes precedence over the OPTION_VALUE clause in the new profile.
The following two PDB lockdown profile statements demonstrate how the inheritance works:
```
CREATE LOCKDOWN PROFILE hr_prof INCLUDING PRIVATE_DBAAS;
CREATE LOCKDOWN PROFILE hr_prof2 FROM hr_prof;
```
In the first statement, `hr_prof` inherits any changes made to the `PRIVATE_DBAAS` base profile. If a new statement is enabled for `PRIVATE_DBAAS`, then it is enabled for `hr_prof`. In the second statement, in contrast, when `hr_prof` changes, then `hr_prof2` does *not* change because it is independent of its base profile.
```
ALTER LOCKDOWN PROFILE hr_prof DISABLE STATEMENT  = ('ALTER SYSTEM');
ALTER LOCKDOWN PROFILE hr_prof ENABLE STATEMENT = ('ALTER SYSTEM') clause = ('flush shared_pool');
ALTER LOCKDOWN PROFILE hr_prof DISABLE FEATURE = ('XDB_PROTOCOLS');
```
````
  - DISABLE STATEMENT = ('ALTER SYSTEM') disables the use of all ALTER SYSTEM statements for the PDB.
``````
  - ENABLE STATEMENT = ('ALTER SYSTEM') clause = ('flush shared_pool') enables only the use of the FLUSH_SHARED_POOL clause for ALTER SYSTEM.
  - DISABLE FEATURE = ('XDB_PROTOCOLS') prohibits the use of the XDB protocols (FTP, HTTP, HTTPS) by this PDB
After you create a PDB lockdown profile, you are ready to enable it by using the `ALTER SYSTEM SET PDB_LOCKDOWN` SQL statement.
## Enabling or Disabling a PDB Lockdown Profile
To enable or disable a PDB lockdown profile, use the `PDB_LOCKDOWN` initialization parameter You can use `ALTER SYSTEM SET PDB_LOCKDOWN` to enable a lockdown profile in any of the following contexts:
- CDB (affects all PDBs)
- Application root (affects all application PDBs in the container)
- Application PDB
- PDB
**Note:**   It is not necessary to restart the instance to enable the profile. When the `ALTER SYSTEM SET PDB_LOCKDOWN` statement completes, the profile rules take effect immediately.
When you set `PDB_LOCKDOWN` in the CDB root, every PDB and application root inherits this setting unless `PDB_LOCKDOWN` is set at the container level. To disable lockdown profiles, set `PDB_LOCKDOWN` to null. If you set this parameter to null in the CDB root, then lockdown profiles are disabled for all PDBs except those that explicitly set a profile within the PDB.
A CDB common user who has been commonly granted the `SYSDBA` administrative privilege or the `ALTER SYSTEM` system privilege can set `PDB_LOCKDOWN` only to a lockdown profile that was created in the CDB root. An application common user with the application common `SYSDBA` administrative privilege or the `ALTER SYSTEM` system privilege can set `PDB_LOCKDOWN` only to a lockdown profile created in an application root.
````
```
CONNECT c##sec_admin Enter password: password
```
- Log in to the desired container as a user who has the commonly granted ALTER SYSTEM or commonly granted SYSDBA privilege. For example, to enable the profile for all PDBs, log in to the CDB root:
```
ALTER SYSTEM SET PDB_LOCKDOWN = hr_prof;
```
```
ALTER SYSTEM RESET PDB_LOCKDOWN;
```
```
ALTER SYSTEM RESET PDB_LOCKDOWN SCOPE = BOTH;
```
```
ALTER SYSTEM SET PDB_LOCKDOWN = '' SCOPE = BOTH;
```
````
- Run the ALTER SYSTEM SET PDB_LOCKDOWN statement. For example, the following statement enables the lockdown profile named hr_prof for all PDBs: The following statement resets the PDB_LOCKDOWN parameter: This variation of the preceding statement includes the SCOPE clause:: The following statement disables all lockdown profiles in the CDB except those that are explicitly set at the PDB level: To find the names of PDB lockdown profiles, query the PROFILE_NAME column of the DBA_LOCKDOWN_PROFILES data dictionary view.
```
SET LINESIZE 150
COL PROFILE_NAME FORMAT a20
COL RULE FORMAT a20
COL CLAUSE FORMAT a25
SELECT PROFILE_NAME, RULE, CLAUSE, STATUS FROM CDB_LOCKDOWN_PROFILES;
```
```
PROFILE_NAME         RULE                 CLAUSE                    STATUS
-------------------- -------------------- ------------------------- -------
HR_PROF              XDB_PROTOCOLS                                  DISABLE
HR_PROF              ALTER SYSTEM                                   DISABLE
HR_PROF              ALTER SYSTEM         FLUSH SHARED_POOL         ENABLE
HR_PROF2                                                            EMPTY
PRIVATE_DBAAS                                                       EMPTY
PUBLIC_DBAAS                                                        EMPTY
SAAS                                                                EMPTY
```
- Optionally, review information about the profiles by querying DBA_LOCKDOWN_PROFILES. For example, run the following query: Sample output appears below:
## Dropping a PDB Lockdown Profile
To drop a PDB lockdown profile, you must have the `DROP LOCKDOWN PROFILE` system privilege and be logged into the CDB or application root.
You can find the names of existing PDB lockdown profiles by querying the `DBA_LOCKDOWN_PROFILES` data dictionary view.
```
CONNECT c##sec_admin
Enter password: password
```
- Connect to the CDB root or the application root as a user who has the DROP LOCKDOWN PROFILE system privilege. For example, to connect to the CDB root:
- Run the DROP LOCKDOWN_PROFILE statement. For example:
```
DROP LOCKDOWN PROFILE hr_prof2;
```
```
SET LINESIZE 150
COL PROFILE_NAME FORMAT a20
COL RULE FORMAT a20
COL CLAUSE FORMAT a25
SELECT PROFILE_NAME, RULE, CLAUSE, STATUS FROM CDB_LOCKDOWN_PROFILES;
```
```
PROFILE_NAME         RULE                 CLAUSE                    STATUS
-------------------- -------------------- ------------------------- -------
HR_PROF              XDB_PROTOCOLS                                  DISABLE
HR_PROF              ALTER SYSTEM                                   DISABLE
HR_PROF              ALTER SYSTEM         FLUSH SHARED_POOL         ENABLE
PRIVATE_DBAAS                                                       EMPTY
PUBLIC_DBAAS                                                        EMPTY
SAAS                                                                EMPTY
```
- Optionally, review the current list of profiles by querying DBA_LOCKDOWN_PROFILES. For example, run the following query: Sample output appears below:
