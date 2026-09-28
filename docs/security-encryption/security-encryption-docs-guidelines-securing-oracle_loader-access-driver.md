# Guidelines for Securing the ORACLE_LOADER Access Driver

Oracle provides guidelines to secure the `ORACLE_LOADER` access driver.
****
- Create a separate operating system directory to store the access driver preprocessors. You (or the operating system manager) may need to create multiple directories if different Oracle Database users will run different preprocessors. If you want to prevent one set of users from using one preprocessor while allowing those users access to another preprocessor, then place the preprocessors in separate directories. If all the users need equal access, then you can place the preprocessors together in one directory. After you create these operating system directories, in SQL*Plus, you can create a directory object for each directory.
****
- Grant the operating system user ORACLE the correct operating system privileges to run the access driver preprocessor. In addition, protect the preprocessor program from WRITE access by operating system users other than the user responsible for managing the preprocessor program.
****``````
- Grant the EXECUTE privilege to each user who will run the preprocessor program in the directory object. Do not grant this user the WRITE privilege on the directory object. Never grant users both the EXECUTE and WRITE privilege for directory objects.
****
- Grant the WRITE privilege sparingly to anyone who will manage directory objects that contain preprocessors. This prevents database users from accidentally or maliciously overwriting the preprocessor program.
  - **Create a separate operating system directory and directory object for any data files that are required for external tables.** Ensure that these are separate from the directory and directory object used by the access directory preprocessor. Work with the operating system manager to ensure that only the appropriate operating system users have access to this directory. Grant the `ORACLE` operating system user `READ` access to any directory that has a directory object with `READ` privileges granted to database users. Similarly, grant the `ORACLE` operating system user `WRITE` access to any directory that has the `WRITE` privilege granted to database users.
****
- Create a separate operating system directory and directory object for any files that the access driver generates. This includes log files, bad files, and discarded files. You and the operating system manager must ensure that this directory and directory object have the proper protections, similar to those described in Guideline 5. The database user may need to access these files when resolving problems in data files, so you and the operating system manager must determine a way for this user to read those files.
****
- Grant the CREATE ANY DIRECTORY and DROP ANY DIRECTORY privileges sparingly. Users who have these privileges and users who have been granted the DBA role have full access to all directory objects.
****
- Consider auditing the DROP ANY DIRECTORY privilege. See Auditing System Privileges for more information about auditing privileges.
****- Consider auditing the directory object. See Auditing Object Actions for more information.
## Related Topics
**- Oracle Database Utilities for more information about the ORACLE_DATAPUMP access driver
