# Configuring User Resource Limits

A resource limit defines the amount of system resources that are available for a user.
- About User Resource Limits You can set limits on the amount of system resources available to each user as part of the security domain of that user.
- Types of System Resources and Limits You can limit several types of system resources, including CPU time and logical reads, at the session level, call level, or both.
- Values for Resource Limits of Profiles Before you create profiles and set resource limits, you should determine appropriate values for each resource limit.
- Managing Resources with Profiles A profile is a named set of resource limits and password parameters that restrict database usage and instance resources for a user.
## About User Resource Limits
You can set limits on the amount of system resources available to each user as part of the security domain of that user.
By doing so, you can prevent the uncontrolled consumption of valuable system resources such as CPU time.
This resource limit feature is very useful in large, multiuser systems, where system resources are very expensive. Excessive consumption of these resources by one or more users can detrimentally affect the other users of the database. In single-user or small-scale multiuser database systems, the system resource feature is not as important, because user consumption of system resources is less likely to have a detrimental impact.
You manage user resource limits by using Database Resource Manager. You can set password management preferences using profiles, either set individually or using a default profile for many users. Each Oracle database can have an unlimited number of profiles. Oracle Database allows the security administrator to enable or disable the enforcement of profile resource limits universally.
Setting resource limits causes a slight performance degradation when users create sessions, because Oracle Database loads all resource limit data for each user upon each connection to the database.
## Types of System Resources and Limits
You can limit several types of system resources, including CPU time and logical reads, at the session level, call level, or both.
- Limits to the User Session Level When a user connects to a database, a session is created. Sessions use CPU time and memory, on which you can set limits.
- Limits to Database Call Levels Each time a user runs a SQL statement, Oracle Database performs several steps to process the statement.
- Limits to CPU Time When SQL statements and other calls are made to an Oracle database, CPU time is necessary to process the call.
- Limits to Logical Reads Input/output (I/O) is one of the most expensive operations in a database system.
- Limits to Other Resources You can control limits for user concurrent sessions and idle time.
### Limits to the User Session Level
When a user connects to a database, a session is created. Sessions use CPU time and memory, on which you can set limits.
You can set several resource limits at the session level. If a user exceeds a session-level resource limit, then Oracle Database terminates (rolls back) the current statement and returns a message indicating that the session limit has been reached. At this point, all previous statements in the current transaction are intact, and the only operations the user can perform are `COMMIT`, `ROLLBACK`, or disconnect (in this case, the current transaction is committed). All other operations produce an error. Even after the transaction is committed or rolled back, the user cannot accomplish any more work during the current session.
### Limits to Database Call Levels
Each time a user runs a SQL statement, Oracle Database performs several steps to process the statement.
During the SQL statement processing, several calls are made to the database as a part of the different execution phases. To prevent any one call from using the system excessively, Oracle Database lets you set several resource limits at the call level.
If a user exceeds a call-level resource limit, then Oracle Database halts the processing of the statement, rolls back the statement, and returns an error. However, all previous statements of the current transaction remain intact, and the user session remains connected.
### Limits to CPU Time
When SQL statements and other calls are made to an Oracle database, CPU time is necessary to process the call.
Average calls require a small amount of CPU time. However, a SQL statement involving a large amount of data or a runaway query can potentially use a large amount of CPU time, reducing CPU time available for other processing.
To prevent uncontrolled use of CPU time, you can set fixed or dynamic limits on the CPU time for each call and the total amount of CPU time used for Oracle Database calls during a session. The limits are set and measured in CPU one-hundredth seconds (
0.01 seconds) used by a call or a session.
### Limits to Logical Reads
Input/output (I/O) is one of the most expensive operations in a database system.
SQL statements that are I/O-intensive can monopolize memory and disk use and cause other database operations to compete for these resources.
To prevent single sources of excessive I/O, you can limit the logical data block reads for each call and for each session. Logical data block reads include data block reads from both memory and disk. The limits are set and measured in number of block reads performed by a call or during a session.
### Limits to Other Resources
You can control limits for user concurrent sessions and idle time.
Limits to other resources are as follows:
****
- You can limit the number of concurrent sessions for each user. Each user can create only up to a predefined number of concurrent sessions.
********
- You can limit the idle time for a session. If the time between calls in a session reaches the idle time limit, then the current transaction is rolled back, the session is terminated, and the resources of the session are returned to the system. The next call receives an error that indicates that the user is no longer connected to the instance. This limit is set as a number of elapsed minutes. Note: Shortly after a session is terminated because it has exceeded an idle time limit, the process monitor (PMON) background process cleans up after the terminated session. Until PMON completes this process, the terminated session is still counted in any session or user resource limit.
**** ****
- You can limit the elapsed connect time for each session. If the duration of a session exceeds the elapsed time limit, then the current transaction is rolled back, the session is dropped, and the resources of the session are returned to the system. This limit is set as a number of elapsed minutes. Note: Oracle Database does not constantly monitor the elapsed idle time or elapsed connection time. Doing so reduces system performance. Instead, it checks every few minutes. Therefore, a session can exceed this limit slightly (for example, by 5 minutes) before Oracle Database enforces the limit and terminates the session.
************
- You can limit the amount of private System Global Area (SGA) space (used for private SQL areas) for a session. This limit is only important in systems that use the shared server configuration. Otherwise, private SQL areas are located in the Program Global Area (PGA). This limit is set as a number of bytes of memory in the SGA of an instance. Use the charactersKorMto specify kilobytes or megabytes.
## Values for Resource Limits of Profiles
Before you create profiles and set resource limits, you should determine appropriate values for each resource limit.
You can base the resource limit values on the type of operations a typical user performs. For example, if one class of user does not usually perform a high number of logical data block reads, then use the `ALTER RESOURCE COST` SQL statement to set the `LOGICAL_READS_PER_SESSION` setting conservatively.
Usually, the best way to determine the appropriate resource limit values for a given user profile is to gather historical information about each type of resource usage. For example, the database or security administrator can use the `AUDIT` `SESSION` clause to gather information about the limits `CONNECT_TIME`, `LOGICAL_READS_PER_SESSION`.
In an Oracle Data Guard environment, an active standby database is opened in read-only mode. This allows user connections on it in the same way as on a primary database. Hence, all the password resource-related limits of a given user profile will work independently between them, except for the ones that imply or require a user password change in the standby database; this task cannot be performed in a database that is opened in read-only mode.
You can gather statistics for other limits using the Monitor feature of Oracle Enterprise Manager (or SQL*Plus), specifically the Statistics monitor.
## Managing Resources with Profiles
A profile is a named set of resource limits and password parameters that restrict database usage and instance resources for a user.
- About Profiles A profile is a collection of attributes that apply to a user.
- ora_stig_profile User Profile The ora_stig_profile user profile is designed for Security Technical Implementation Guide compliance.
- Creating a Profile A profile can encompass limits for a specific category, such as limits on passwords or limits on resources.
``````
- Creating a CDB Profile or an Application Profile The CREATE PROFILE or ALTER PROFILE statement CONTAINER=ALL clause can create a profile in a CDB or application root.
- Assigning a Profile to a User After you create a profile, you can assign it to users.
- Dropping Profiles You can drop a profile, even if it is currently assigned to a user.
### About Profiles
A profile is a collection of attributes that apply to a user.
The **profile** is used to enable a single point of reference for multiple users who share these attributes.
You should assign a profile to each user. Each user can have only one profile, and creating a new one supersedes an earlier assignment.
You can create and manage user profiles only if resource limits are a requirement of your database security policy. To use profiles, first categorize the related types of users in a database. Just as roles are used to manage the privileges of related users, profiles are used to manage the resource limits of related users. Determine how many profiles are needed to encompass all categories of users in a database and then determine appropriate resource limits for each profile.
User profiles in Oracle Internet Directory contain attributes pertinent to directory usage and authentication for each user. Similarly, profiles in Oracle Label Security contain attributes useful in label security user administration and operations management. Profile attributes can include restrictions on system resources. You can use Database Resource Manager to set these types of resource limits.
In a multitenant environment, profiles are useful for the administration and operations performed in the container databases (CDBs) and application containers, as well as their associated pluggable databases (PDBs). For both CDB and application containers, if you define a common profile, then the profile applies to the entire container and not outside this container. If you create a local profile, then it applies to that PDB only.
Profile resource limits are enforced only when you enable resource limitation for the associated database. Enabling this limitation can occur either before starting the database (using the `RESOURCE_LIMIT` initialization parameter) or while it is open (using the `ALTER SYSTEM` statement).
Though password parameters reside in profiles, they are unaffected by `RESOURCE_LIMIT` or `ALTER SYSTEM` and password management is always enabled. In Oracle Database, Database Resource Manager primarily handles resource allocations and restrictions.
Any authorized database user can create, assign to users, alter, and drop a profile at any time (using the `CREATE USER` or `ALTER USER` statement). Profiles can be assigned only to users and not to roles or other profiles. Profile assignments do not affect current sessions; instead, they take effect only in subsequent sessions.
To find information about current profiles, query the `DBA_PROFILES` view.
### ora_stig_profile User Profile
The `ora_stig_profile` user profile is designed for Security Technical Implementation Guide compliance.
The `ora_stig_profile` user profile addresses STIG requirements such as the need for a password complexity function, maximum failed login attempts, reuse time, and other requirements. The definition for this profile is as follows:
```
CREATE PROFILE ora_stig_profile password_life_time        60 password_grace_time       5 password_reuse_time       365 password_reuse_max        10 failed_login_attempts     3 password_lock_time        unlimited inactive_account_time     35 idle_time                 15 password_verify_function  ora12c_stig_verify_function;
```
### Creating a Profile
A profile can encompass limits for a specific category, such as limits on passwords or limits on resources.
To create a profile, you must have the `CREATE PROFILE` system privilege. To find all existing profiles, you can query the `DBA_PROFILES` view.
  - Use the CREATE PROFILE statement to create a profile.
For example, to create a profile that defines password limits:
```
CREATE PROFILE password_prof LIMIT FAILED_LOGIN_ATTEMPTS 6 PASSWORD_LIFE_TIME 60 PASSWORD_REUSE_TIME 60 PASSWORD_REUSE_MAX 5 PASSWORD_LOCK_TIME 1/24 PASSWORD_GRACE_TIME 10 PASSWORD_VERIFY_FUNCTION DEFAULT;
```
The following example shows how to create a resource limits profile.
```
CREATE PROFILE app_user LIMIT SESSIONS_PER_USER          UNLIMITED CPU_PER_SESSION            UNLIMITED CPU_PER_CALL               3500 CONNECT_TIME               50 LOGICAL_READS_PER_SESSION  DEFAULT LOGICAL_READS_PER_CALL     1200 PRIVATE_SGA                20K COMPOSITE_LIMIT            7500000;
```
### Creating a CDB Profile or an Application Profile
The `CREATE PROFILE` or `ALTER PROFILE` statement `CONTAINER=ALL` clause can create a profile in a CDB or application root.
You cannot create local profiles in the CDB root or the application root. The profile that you create will be applied to all PDBs that are associated with the CDB root or the application root. Create the profile using the same parameters that you would in a non-multitenant environment.
``````
- To create a profile in a CDB root or an application root, optionally include the CONTAINER=ALL clause in the CREATE PROFILE or ALTER PROFILE statement. The CONTAINER=ALL clause is optional because it is the default when the statement is processed.
For example:
```
CREATE PROFILE password_prof LIMIT
  FAILED_LOGIN_ATTEMPTS 6
  PASSWORD_LIFE_TIME 60
  PASSWORD_REUSE_TIME 60
  PASSWORD_REUSE_MAX 5
  PASSWORD_LOCK_TIME 1/24
  PASSWORD_GRACE_TIME 10
  PASSWORD_VERIFY_FUNCTION DEFAULT
  CONTAINER=ALL;
```
### Assigning a Profile to a User
After you create a profile, you can assign it to users.
You can assign a profile to a user who has already been assigned a profile, but the most recently assigned profile takes precedence. When you assign a profile to an external user or a global user, the password parameters do not take effect for that user.
To find the profiles that are currently assigned to users, you can query the `DBA_USERS` view.
  - Use the ALTER USER statement to assign the profile to a user.
For example:
```
ALTER USER psmith PROFILE app_user;
```
### Dropping Profiles
You can drop a profile, even if it is currently assigned to a user.
When you drop a profile, the drop does not affect currently active sessions. Only sessions that were created after a profile is dropped use the modified profile assignments. To drop a profile, you must have the `DROP PROFILE` system privilege. You cannot drop the default profile.
  ````- Use the SQL statement DROP PROFILE to drop a profile. To drop a profile that is currently assigned to a user, use the CASCADE option.
For example:
```
DROP PROFILE clerk CASCADE;
```
Any user currently assigned to a profile that is dropped is automatically is assigned to the `DEFAULT` profile. The `DEFAULT` profile cannot be dropped.
## Related Topics
  **- Oracle Database Administrator’s Guide
  **- Oracle Database Administrator’s Guide for detailed information about managing resources
  **- Oracle Database SQL Language Reference
  **- Oracle Database SQL Language Reference
