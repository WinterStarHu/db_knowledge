# Grants of Roles Using the Operating System or Network

Using the operating system or network to manage roles can help centralize the role management in a large enterprise.
- About Granting Roles Using the Operating System or Network The operating system on which Oracle Database runs can be used to grant roles to users at connect time.
- Operating System Role Identification The OS_ROLES initialization parameter can be used to control how the operating system identifies roles.
- Operating System Role Management When you use operating system-managed roles, remember that database roles are being granted to an operating system user.
````
- Role Grants and Revokes When OS_ROLES Is Set to TRUE Setting the OS_ROLES initialization parameter to TRUE enables the operating system to manage role grants and revokes to users.
``````
- Role Enablements and Disablements When OS_ROLES Is Set to TRUE Setting the OS_ROLES initialization parameter to TRUE enables the SET ROLE statement to dynamically enable roles granted by the operating system.
- Network Connections with Operating System Role Management By default, users cannot connect to the database through a shared server if the operating system manages roles.
## About Granting Roles Using the Operating System or Network
The operating system on which Oracle Database runs can be used to grant roles to users at connect time.
This feature is an alternative to a security administrator explicitly having to granting and revoking database roles to and from users using `GRANT` and `REVOKE` statements.
Roles can be administered using the operating system and passed to Oracle Database when a user creates a session. As part of this mechanism, the default roles of a user and the roles granted to a user with the `ADMIN` option can be identified. If the operating system is used to authorize users for roles, then all roles must be created in the database and privileges assigned to the role with `GRANT` statements.
Roles can also be granted through a network service.
The advantage of using the operating system to identify the database roles of a user is that privilege management for an Oracle database can be externalized. The security facilities offered by the operating system control user privileges. This option may offer advantages of centralizing security for several system activities, such as the following situation:
- MVS Oracle administrators want RACF groups to identify database user roles.
- UNIX Oracle administrators want UNIX groups to identify database user roles.
- VMS Oracle administrators want to use rights identifiers to identify database user roles.
The main disadvantage of using the operating system to identify the database roles of a user is that privilege management can only be performed at the role level. Individual privileges cannot be granted using the operating system, but they can still be granted inside the database using `GRANT` statements.
A second disadvantage of using this feature is that, by default, users cannot connect to the database through the shared server or any other network connection if the operating system is managing roles. However, you can change this default as described in Network Connections with Operating System Role Management.
In a multitenant environment, you can use operating system authentication for a database administrator only for the CDB root. You cannot use it for PDBs, the application root, or application PDBs.
**Note:**   The features described in this section are available only on some operating systems. See your operating system-specific Oracle Database documentation to determine if you can use these features.
## Operating System Role Identification
The `OS_ROLES` initialization parameter can be used to control how the operating system identifies roles.
To have the database use the operating system to identify the database roles of each user when a session is created, you can set the initialization parameter `OS_ROLES` to `TRUE`.
If the instance is current running, you must restart the instance. When a user tries to create a session with the database, Oracle Database initializes the user security domain using the database roles identified by the operating system.
To identify database roles for a user, the operating system account for each Oracle Database user must have operating system identifiers (these may be called groups, rights identifiers, or other similar names) that indicate which database roles are to be available for the user. Role specification can also indicate which roles are the default roles of a user and which roles are available with the `ADMIN` option. No matter which operating system is used, the role specification at the operating system level follows the format:
```
ora_ID_ROLE[[_d][_a][_da]]
```
In this specification:
``````
``````
- ID has a definition that varies on different operating systems. For example, on VMS, ID is the instance identifier of the database; on VMS, it is the computer type; and on UNIX, it is the system ID. ID is case-sensitive to match your ORACLE_SID. ROLE is not case-sensitive.
- ROLE is the name of the database role.
- d is an optional character that indicates this role is to be a default role of the database user.
````
````
- a is an optional character that indicates this role is to be granted to the user with the ADMIN option. This allows the user to grant the role to other roles only. Roles cannot be granted to users if the operating system is used to manage roles. If either the d or a character is specified, then precede that character by an underscore (_).
For example, suppose an operating system account has the following roles identified in its profile:
```
ora_PAYROLL_ROLE1
ora_PAYROLL_ROLE2_a
ora_PAYROLL_ROLE3_d
ora_PAYROLL_ROLE4_da
```
When the corresponding user connects to the `payroll` instance of Oracle Database, `role3` and `role4` are defaults, while `role2` and `role4` are available with the `ADMIN` option.
## Operating System Role Management
When you use operating system-managed roles, remember that database roles are being granted to an operating system user.
Any database user to which the operating system user is able to connect will have the authorized database roles enabled. For this reason, you should consider defining all Oracle Database users as `IDENTIFIED EXTERNALLY` if you are using `OS_ROLES = TRUE`, so that the database accounts are tied to the operating system account that was granted privileges.
## Role Grants and Revokes When OS_ROLES Is Set to TRUE
Setting the `OS_ROLES` initialization parameter to `TRUE` enables the operating system to manage role grants and revokes to users.
Any previous granting of roles to users using `GRANT` statements do not apply. However, they are still listed in the data dictionary. Only the role grants to users made at the operating system level apply. Users can still grant privileges to roles and users.
**Note:**   If the operating system grants a role to a user with the `ADMIN` option, then the user can grant the role only to other roles.
## Role Enablements and Disablements When OS_ROLES Is Set to TRUE
Setting the `OS_ROLES` initialization parameter to `TRUE` enables the `SET ROLE` statement to dynamically enable roles granted by the operating system.
This still applies, even if the role was defined to require a password or operating system authorization. However, any role not identified in the operating system account of a user cannot be specified in a `SET ROLE` statement, even if a role was granted using a `GRANT` statement when `OS_ROLES = FALSE`. (If you specify such a role, then Oracle Database ignores it.) When `OS_ROLES` is set to `TRUE`, then the user can enable up to 148 roles. Remember that this number includes other roles that may have been granted to the role.
## Network Connections with Operating System Role Management
By default, users cannot connect to the database through a shared server if the operating system manages roles.
This restriction is the default because a remote user could impersonate another operating system user over an unsecure connection.
If you are not concerned with this security risk and want to use operating system role management with the shared server, or any other network connection, then set the initialization parameter `REMOTE_OS_ROLES` to `TRUE`. The change takes effect the next time you start the instance and mount the database. The default setting of this parameter is `FALSE`.
