# Securing External Procedures

An external procedure is stored in a `.dll` or an `.so` file, separately from the database, and can be through a credential authentication.
- About Securing External Procedures For safety reasons, Oracle external procedures run in a process that is physically separate from the database.
- General Process for Configuring extproc for a Credential Authentication For better security, you can configure the extproc process to be authenticated through a credential.
- extproc Process Authentication and Impersonation Expected Behaviors The extproc process has a set of behaviors for authentication and impersonation.
````
- Configuring Authentication for External Procedures To configure a credential for extproc processes, you can use the DBMS_CREDENTIAL PL/SQL package.
````
- External Procedures for Legacy Applications For maximum security, set the ENFORCE_CREDENTIAL environment variable to TRUE.
## About Securing External Procedures
For safety reasons, Oracle external procedures run in a process that is physically separate from the database.
In most cases, you configure this process to execute as a user other than the Oracle software account. When your application invokes this external procedure-such as when a library of `.dll` or `.so` files must be accessed-then Oracle Database creates an operating system process called `extproc`. By default, the `extproc` process communicates directly through your server process. In other words, if you do not use a credential, then Oracle Database creates an `extproc` process for you in the default Oracle Database server configuration, and runs `extproc` as the `oracle` software account. Alternatively, it can communicate through the Oracle Database listener.
## General Process for Configuring extproc for a Credential Authentication
For better security, you can configure the `extproc` process to be authenticated through a credential.
The general process is as follows:
- You create a credential. The credential is in an encrypted container. Both public and private synonyms can refer to this credential.Configuring Authentication for External Procedures describes how to create this credential and configure your database to use it.
- You make your initial connection to the database, which you are running in either a dedicated server or a shared server process.
``````
- Your application makes a call to an external procedure. If this is the first call, then Oracle Database creates an extproc process. Note that if you want to use a credential for extproc, then you cannot use the Oracle listener to spawn the extproc process.
``````````
- The extproc process impersonates (that is, it runs on behalf of your supplied credential), loads the requisite .dll, .so, .sl, or .a file, and then sends your data between SQL and C.
## extproc Process Authentication and Impersonation Expected Behaviors
The extproc process has a set of behaviors for authentication and impersonation.
The below table describes the expected behaviors of an `extproc` process based on possible authentication and impersonation scenarios.
In this table, `GLOBAL_EXTPROC_CREDENTIAL` is a reserved credential name for the default credential if the credential is not explicitly specified and if the `ENFORCE_CREDENTIAL` environment variable is set to `TRUE`. Therefore, Oracle strongly recommends that you create a credential by the that name if `ENFORCE_CREDENTIAL` is set to `TRUE`.

| ENFORCE_CREDENTIAL Environment Variable Setting | PL/SQL Library with Credential? | GLOBAL_EXTPROC_CREDENTIAL Credential Existence | Expected Behavior |
|---|---|---|---|
| FALSE | No | No | Uses the pre-release 12c authentication, which authenticates by operating system privilege of the owners of the Oracle listener or Oracle server process. |
| FALSE | No | Yes | Authenticates and impersonates with the Oracle Database instance-wide supplied GLOBAL_EXTPROC_CREDENTIAL. If only the GLOBAL_EXTPROC_CREDENTIAL credential is in use, then the EXECUTE privilege on this global credential is automatically granted to all users implicitly. |
| FALSE | Yes | No | Authenticates and impersonates with the credential defined in the PL/SQL library |
| FALSE | Yes | Yes | Authenticates and impersonates. If both the PL/SQL library and the GLOBAL_EXTPROC_CREDENTIAL settings have credentials defined, then the credential of the PL/SQL library takes precedence. |
| TRUE | No | No | Returns error ORA-28575: unable to open RPC connection to external procedure agent |
| TRUE | No | Yes | Authenticates and impersonates with the Oracle system-wide supplied GLOBAL_EXTPROC_CREDENTIAL (footnote 1) |
| TRUE | Yes | No | Authenticates and impersonates with the credential defined in the PL/SQL library |
| TRUE | Yes | Yes | Authenticates and impersonates (footnote 2) |

## Configuring Authentication for External Procedures
To configure a credential for `extproc` processes, you can use the `DBMS_CREDENTIAL` PL/SQL package.
  ````- Log in to SQL*Plus as a user who has been granted the CREATE CREDENTIAL or CREATE ANY CREDENTIAL privilege.
```
sqlplus psmith Enter password: password Connected.
```
```
In a multitenant environment, you must connect to the appropriate pluggable database (PDB). For example:
```
```
sqlplus psmith@hpdb Enter password: password Connected.
```
```
In addition, ensure that you also have the `CREATE LIBRARY` or `CREATE ANY LIBRARY` privilege, and the `EXECUTE` object privilege on the library that contains the external calls.
```
- Using the DBMS_CREDENTIAL PL/SQL package, create a new credential. For example:
```
BEGIN DBMS_CREDENTIAL.CREATE_CREDENTIAL ( credential_name   => 'smith_credential', user_name         => 'tjones', password          => 'password') END;
/
```
```
In this example:
- `credential_name`: Enter the name of the credential. Optionally, prefix it with the name of a schema (for example, `psmith.smith_credential`). If the `ENFORCE_CREDENTIAL` environment variable is set to `TRUE`, then you should create a credential with credential_name `GLOBAL_EXTPROC_CREDENTIAL`.
- `user_name`: Enter a valid operating system user name to be to used to run as the user.
- `password`: Enter the password for the `user_name` user.
```
- Associate the credential with a PL/SQL library. For example:
```
CREATE OR REPLACE LIBRARY ps_lib AS 'smith_lib.so' IN DLL_LOC CREDENTIAL smith_credential;
```
```
In this example, `DLL_LOC` is a directory object that points to the `$ORACLE_HOME/bin` directory. Oracle does not recommend using absolute paths to the DLL.
When the PL/SQL library is loaded by an external procedure call through the `extproc` process, `extproc` now can authenticate and impersonate on behalf of the defined `smith_credential` credential.
```
````````
- Register the external procedure by creating a PL/SQL procedure or function that tells PL/SQL how to call the external procedure and what arguments to pass to it. For example, to create a function that registers an external procedure that was written in C, only use the AS LANGUAGE C, LIBRARY, and NAME clauses of the CREATE FUNCTION statement, as follows:
```
CREATE OR REPLACE FUNCTION getInt (x VARCHAR2, y BINARY_INTEGER)
RETURN BINARY_INTEGER
AS LANGUAGE C
LIBRARY ps_lib
NAME "get_int_vals"
PARAMETERS (x STRING, y int);
```
## External Procedures for Legacy Applications
For maximum security, set the `ENFORCE_CREDENTIAL` environment variable to `TRUE`.
However, if you must accommodate backward compatibility, then set `ENFORCE_CREDENTIAL` to `FALSE`. `FALSE` enables the `extproc` process to authenticate, impersonate, and perform user-defined callout functions on behalf of the supplied credential when either of the following occurs:
- The credential is defined with a PL/SQL library.
- The credential is not defined but the GLOBAL_EXTPROC_CREDENTIAL credential exists.
If neither of these credential definitions is in place, then setting the `ENFORCE_CREDENTIAL` parameter to `FALSE` sets the `extproc` process to be authenticated by the operating system privilege of the owners of the Oracle listener or Oracle server process.
For legacy applications that run on top of `extproc` processes, ideally you should change the legacy application code to associate all alias libraries with credentials. If you cannot do this, then Oracle Database uses the `GLOBAL_EXTPROC_CREDENTIAL` credential to determine how authentication will be handled. If the `GLOBAL_EXTPROC_CREDENTIAL` credential is not defined, then the `extproc` process is authenticated by the operating system privilege of the owners of the Oracle listener or Oracle server process.
## Related Topics
  - Guideline for Securing External Procedures
  - Guideline for Securing External Procedures
**- Oracle Database PL/SQL Packages and Types Reference, for information about the DBMS_CREDENTIAL package **- Oracle Call Interface Programmer’s Guide for information about the extproc agent **- Oracle Database Net Services Administrator’s Guide for detailed information about the extproc.ora file
