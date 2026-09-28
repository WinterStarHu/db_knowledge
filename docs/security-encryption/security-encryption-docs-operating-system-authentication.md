# Operating System Authentication of Users

Oracle Database can authenticate by using information that is maintained by the operating system.
Using the operating system to authenticate users has both advantages and disadvantages.
This functionality has the following benefits:
  - Once authenticated by the operating system, users can connect to Oracle Database more conveniently, without specifying a user name or password. For example, an operating system-authenticated user can invoke SQL*Plus and omit the user name and password prompts by entering the following command at the command line:
```
SQLPLUS /
```
Within SQL*Plus, you enter:
```
CONNECT /
```
- With control over user authentication centralized in the operating system, Oracle Database does not need to store or manage the cryptographic hashes (also called verifiers) of the user passwords, although it still maintains user names in the database.
``````````
- The audit trail captures the operating system user name and the database user name, where the database user name is the value of the OS_AUTHENT_PREFIX instance initialization parameter prefixed to the operating system user name. For example, if OS_AUTHENT_PREFIX is set to OPS$ and the operating system user name is psmith, then the database user name will be OPS$PSMITH.
****``````
  - Authenticate users by the operating system. You create the user account using the IDENTIFIED EXTERNALLY clause of the CREATE USER statement, and then you set the OS_AUTHENT_PREFIX initialization parameter to specify a prefix that Oracle Database uses to authenticate users attempting to connect to the server.
****
  - Authenticate non-operating system users. These are users who are assigned passwords and authenticated by the database.
****````
  - Authenticate Oracle Database Enterprise User Security users. These user accounts where created using the IDENTIFIED GLOBALLY clause of the CREATE USER statement, and then authenticated by Oracle Internet Directory (OID) currently in the same database.
However, you should be aware of the following drawbacks to using the operating system to authenticate users:
- A user must have an operating system account on the computer that must be accessed. Not all users have operating system accounts, particularly non-administrative users.
- If a user has logged in using this method and steps away from the terminal, another user could easily log in because this user does not need any passwords or credentials. This could pose a serious security problem.
- When an operating system is used to authenticate database users, managing distributed database environments and database links requires special care. Operating system-authenticated database links can pose a security weakness. For this reason, Oracle recommends that you do not use them.
- In a multitenant environment, you can use operating system authentication for a database administrator only for the CDB root. You cannot use it for PDBs, the application root, or application PDBs.
## Related Topics
  **- Oracle Database Administrator’s Guide for more information about authentication, operating systems, distributed database concepts, and distributed data management
  - Operating system-specific documentation by Oracle Database for more information about authenticating by using your operating system
