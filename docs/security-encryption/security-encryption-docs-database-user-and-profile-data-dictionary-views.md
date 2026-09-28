# Database User and Profile Data Dictionary Views

Oracle Database provides a set of data dictionary views that provide information about the settings that you used to create users and profiles.
- Data Dictionary Views That List Information About Users and Profiles Oracle Database provides a set of data dictionary views that contain information about database users and profiles.
- Query to Find All Users and Associated Information The DBA_USERS data dictionary view shows all users and their associated information as defined in the database.
- Query to List All Tablespace Quotas The DBA_TS_QUOTAS data dictionary view lists all tablespace quotas assigned to each user.
- Query to List All Profiles and Assigned Limits The DBA_PROFILE view lists all profiles in the database and associated settings for each limit in each profile.
- Query to View Memory Use for Each User Session The V$SESSION dynamic view lists the memory use for each user session.
## Data Dictionary Views That List Information About Users and Profiles
Oracle Database provides a set of data dictionary views that contain information about database users and profiles.
The following table lists these data dictionary views.

| View | Description |
|---|---|
| ALL_OBJECTS | Describes all objects accessible to the current user |
| ALL_USERS | Lists users visible to the current user, but does not describe them |
| DBA_PROFILES | Displays all profiles and their limits |
| DBA_TS_QUOTAS | Describes tablespace quotas for users |
| DBA_OBJECTS | Describes all objects in the database |
| DBA_USERS | Describes all users of the database |
| DBA_USERS_WITH_DEFPWD | Lists all user accounts that have default passwords |
| PROXY_USERS | Describes users who can assume the identity of other users |
| RESOURCE_COST | Lists the cost for each resource in terms of CPUs for each session, reads for each session, connection times, and SGA |
| USER_PASSWORD_LIMITS | Describes the password profile parameters that are assigned to the user |
| USER_RESOURCE_LIMITS | Displays the resource limits for the current user |
| USER_TS_QUOTAS | Describes tablespace quotas for users |
| USER_OBJECTS | Describes all objects owned by the current user |
| USER_USERS | Describes only the current user |
| V$SESSION | Lists session information for the current database session |
| V$SESSTAT | Displays user session statistics |
| V$STATNAME | Displays decoded statistic names for the statistics shown in the V$SESSTAT view |

The following sections present examples of using these views. These examples assume that the following statements have been run. The users are all local users.
```
CREATE PROFILE clerk LIMIT
 SESSIONS_PER_USER 1
 IDLE_TIME 30
 CONNECT_TIME 600;
CREATE USER jfee
 IDENTIFIED BY password
 DEFAULT TABLESPACE example
 TEMPORARY TABLESPACE temp
 QUOTA 500K ON example
 PROFILE clerk
 CONTAINER = CURRENT;
CREATE USER dcranney
 IDENTIFIED BY password
 DEFAULT TABLESPACE example
 TEMPORARY TABLESPACE temp
 QUOTA unlimited ON example
 CONTAINER = CURRENT;
CREATE USER userscott
 IDENTIFIED BY password
 CONTAINER = CURRENT;
```
## Query to Find All Users and Associated Information
The `DBA_USERS` data dictionary view shows all users and their associated information as defined in the database.
For detailed information about the `DBA_USERS` view, see *Oracle Database Reference*.
For example:
```
col username format a11
col profile format a10
col account_status format a19
col authentication_type format a29
SELECT USERNAME, PROFILE, ACCOUNT_STATUS, AUTHENTICATION_TYPE FROM DBA_USERS;
USERNAME        PROFILE         ACCOUNT_STATUS   AUTHENTICATION_TYPE
--------------- --------------- ---------------  -------------------
SYS             DEFAULT         OPEN             PASSWORD
SYSTEM          DEFAULT         OPEN             PASSWORD
USERSCOTT       DEFAULT         OPEN             PASSWORD
JFEE            CLERK           OPEN             GLOBAL
DCRANNEY        DEFAULT         OPEN             EXTERNAL
```
## Query to List All Tablespace Quotas
The `DBA_TS_QUOTAS` data dictionary view lists all tablespace quotas assigned to each user.
For detailed information about this view, see *Oracle Database Reference*.
For example:
```
SELECT * FROM DBA_TS_QUOTAS;
TABLESPACE    USERNAME    BYTES     MAX_BYTES    BLOCKS    MAX_BLOCKS
----------    ---------  --------   ----------   -------   ----------
EXAMPLE       JFEE              0       512000         0          250
EXAMPLE       DCRANNEY          0           -1         0           -1
```
When specific quotas are assigned, the exact number is indicated in the `MAX_BYTES` column. This number is always a multiple of the database block size, so if you specify a tablespace quota that is not a multiple of the database block size, then it is rounded up accordingly. Unlimited quotas are indicated by `-1`.
## Query to List All Profiles and Assigned Limits
The `DBA_PROFILE` view lists all profiles in the database and associated settings for each limit in each profile.
For example:
```
SELECT * FROM DBA_PROFILES
   ORDER BY PROFILE;
PROFILE             RESOURCE_NAME              RESOURCE_TYPE   LIMIT
-----------------   -----------------------    -------------  --------------
CLERK               COMPOSITE_LIMIT            KERNEL         DEFAULT
CLERK               FAILED_LOGIN_ATTEMPTS      PASSWORD       DEFAULT
CLERK               PASSWORD_LIFE_TIME         PASSWORD       DEFAULT
CLERK               PASSWORD_REUSE_TIME        PASSWORD       DEFAULT
CLERK               PASSWORD_REUSE_MAX         PASSWORD       DEFAULT
CLERK               PASSWORD_VERIFY_FUNCTION   PASSWORD       DEFAULT
CLERK               PASSWORD_LOCK_TIME         PASSWORD       DEFAULT
CLERK               PASSWORD_GRACE_TIME        PASSWORD       DEFAULT
CLERK               PRIVATE_SGA                KERNEL         DEFAULT
CLERK               CONNECT_TIME               KERNEL         600
CLERK               IDLE_TIME                  KERNEL         30
CLERK               LOGICAL_READS_PER_CALL     KERNEL         DEFAULT
CLERK               LOGICAL_READS_PER_SESSION  KERNEL         DEFAULT
CLERK               CPU_PER_CALL               KERNEL         DEFAULT
CLERK               CPU_PER_SESSION            KERNEL         DEFAULT
CLERK               SESSIONS_PER_USER          KERNEL         1
DEFAULT             COMPOSITE_LIMIT            KERNEL         UNLIMITED
DEFAULT             PRIVATE_SGA                KERNEL         UNLIMITED
DEFAULT             SESSIONS_PER_USER          KERNEL         UNLIMITED
DEFAULT             CPU_PER_CALL               KERNEL         UNLIMITED
DEFAULT             LOGICAL_READS_PER_CALL     KERNEL         UNLIMITED
DEFAULT             CONNECT_TIME               KERNEL         UNLIMITED
DEFAULT             IDLE_TIME                  KERNEL         UNLIMITED
DEFAULT             LOGICAL_READS_PER_SESSION  KERNEL         UNLIMITED
DEFAULT             CPU_PER_SESSION            KERNEL         UNLIMITED
DEFAULT             FAILED_LOGIN_ATTEMPTS      PASSWORD       10
DEFAULT             PASSWORD_LIFE_TIME         PASSWORD       180
DEFAULT             PASSWORD_REUSE_MAX         PASSWORD       UNLIMITED
DEFAULT             PASSWORD_LOCK_TIME         PASSWORD       1
DEFAULT             PASSWORD_GRACE_TIME        PASSWORD       7
DEFAULT             PASSWORD_VERIFY_FUNCTION   PASSWORD       UNLIMITED
DEFAULT             PASSWORD_REUSE_TIME        PASSWORD       UNLIMITED
DEFAULT             INACTIVE_ACCOUNT_TIME      KERNEL         UNLIMITED
DEFAULT             PASSWORD_ROLLOVER_TIME     PASSWORD       0
34 rows selected.
```
To find the default profile values, you can run the following query:
```
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';
PROFILE             RESOURCE_NAME              RESOURCE_TYPE  LIMIT
-----------------   -------------------------  -------------  --------------
DEFAULT             COMPOSITE_LIMIT            KERNEL         UNLIMITED
DEFAULT             SESSIONS_PER_USER          KERNEL         UNLIMITED
DEFAULT             CPU_PER_SESSION            KERNEL         UNLIMITED
DEFAULT             CPU_PER_CALL               KERNEL         UNLIMITED
DEFAULT             LOGICAL_READS_PER_SESSION  KERNEL         UNLIMITED
DEFAULT             LOGICAL_READS_PER_CALL     KERNEL         UNLIMITED
DEFAULT             IDLE_TIME                  KERNEL         UNLIMITED
DEFAULT             CONNECT_TIME               KERNEL         UNLIMITED
DEFAULT             PRIVATE_SGA                KERNEL         UNLIMITED
DEFAULT             FAILED_LOGIN_ATTEMPTS      PASSWORD       10
DEFAULT             PASSWORD_LIFE_TIME         PASSWORD       180
DEFAULT             PASSWORD_REUSE_TIME        PASSWORD       UNLIMITED
DEFAULT             PASSWORD_REUSE_MAX         PASSWORD       UNLIMITED
DEFAULT             PASSWORD_VERIFY_FUNCTION   PASSWORD       NULL
DEFAULT             PASSWORD_LOCK_TIME         PASSWORD       1
DEFAULT             PASSWORD_GRACE_TIME        PASSWORD       7
16 rows selected.
```
## Query to View Memory Use for Each User Session
The `V$SESSION` dynamic view lists the memory use for each user session.
For detailed information on this view, see *Oracle Database Reference*.
The following query lists all current sessions, showing the Oracle Database user and current User Global Area (UGA) memory use for each session:
```
SELECT USERNAME, VALUE || 'bytes' "Current UGA memory"
   FROM V$SESSION sess, V$SESSTAT stat, V$STATNAME name
WHERE sess.SID = stat.SID
   AND stat.STATISTIC# = name.STATISTIC#
   AND name.NAME = 'session uga memory';
USERNAME                       Current UGA memory
------------------------------ ---------------------------------------------
                               18636bytes
                               17464bytes
                               19180bytes
                               18364bytes
                               39384bytes
                               35292bytes
                               17696bytes
                               15868bytes
USERSCOTT                      42244bytes
SYS                            98196bytes
SYSTEM                         30648bytes
11 rows selected.
```
To see the maximum UGA memory allocated to each session since the instance started, replace `'session uga memory'` in the preceding query with `'session uga memory max'.`
## Related Topics
**- Oracle Database Reference **- Oracle Database Reference
