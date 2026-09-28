# User Authentication Data Dictionary Views

Oracle Database provides data dictionary views that list information about user authentication, such as roles that users have or profiles they use.
The following table lists the data dictionary views.

| View | Description |
|---|---|
| DBA_PROFILES | Displays information about profiles, including their settings and limits |
| DBA_ROLES | Displays the kind of authentication used for a database role to log in to the database, such as NONE or GLOBAL (query the AUTHENTICATION_TYPE column) |
| DBA_USERS | Among other user information, displays the kind of authentication the user used to log in to the database, such as PASSWORD or EXTERNAL (AUTHENTICATION_TYPE column), and the list of versions of password versions (also known as hashes) that exist for the user account (PASSWORD_VERSIONS column). |
| DBA_USERS_WITH_DEFPWD | Displays whether the user account password is a default password |
| PROXY_USERS | Displays users who are currently authorized to connect through a middle tier |
| V$DBLINK | Displays user accounts for existing database links (DB_LINK, OWNER_ID columns); applies to the current pluggable database (PDB) |
| V$PWFILE | Lists the names and granted administrative privileges of the administrative users who are included in the password file |
| V$SESSION | Querying the USERNAME column displays concurrently logged in users to the current PDB |

## Related Topics
**- Oracle Database Reference
