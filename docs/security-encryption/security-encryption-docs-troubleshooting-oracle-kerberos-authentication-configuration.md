# Troubleshooting the Oracle Kerberos Authentication Configuration

Oracle provides guidance for common Kerberos configuration problems.
Common problems are as follows:
  - Ensure that the default realm is correct by examining the krb.conf file.
  - Ensure that the KDC is running on the host specified for the realm.
  - Ensure that the KDC has an entry for the user principal and that the passwords match.
````
  - Ensure that the krb.conf and krb.realms files are readable by Oracle.
````
  - Ensure that the TNS_ADMIN environment variable is pointing to the directory containing the sqlnet.ora configuration file.
  - After trying to connect, check for a service ticket.
  - Check that the sqlnet.ora file on the database server side has a service name that corresponds to a service known by Kerberos.
````
  - Check that the clocks on all systems involved are set to times that are within a few minutes of each other or change the SQLNET.KERBEROS5_CLOCKSKEW parameter in the sqlnet.ora file.
  - Check the clocks on the client and database server.
````
  - Check that the v5srvtab file exists in the correct location and is readable by Oracle. Remember to set the sqlnet.ora parameters.
````
  - Check that the v5srvtab file has been generated for the service named in the sqlnet.ora file on the database server side.
  - Check that the initial ticket is forwardable. You must have obtained the initial ticket by running the okinit utility.
  - Check the expiration date on the credentials. If the credentials have expired, then close the connection and run okinit to get a new initial ticket.
- Common Kerberos Configuration Problems Oracle provides guidance for common Kerberos configuration problems.
- ORA-12631 Errors in the Kerberos Configuration The ORA-12631: username retrieval failed error can result from the wrong or incorrectly formatted principal being used for the Kerberos authentication
````
- ORA-28575 Errors in the Kerberos Configuration The ORA-28575: unable to open RPC connection to external procedure agent error can occur when the client is remote and the EXTPROC process is spawned.
````
- ORA-01017 Errors in the Kerberos Configuration The ORA-01017: invalid username/password; logon denied error can result if okinit fails and there is no valid ticket in the SQL*Plus connection.
````
- Enabling Tracing for Kerberos okinit Operations The KRB5_TRACE environment variable enables you to trace Kerberos okinit operations.
## Common Kerberos Configuration Problems
Oracle provides guidance for common Kerberos configuration problems.
Common problems are as follows:
  - Ensure that the default realm is correct by examining the krb.conf file.
  - Ensure that the KDC is running on the host specified for the realm.
  - Ensure that the KDC has an entry for the user principal and that the passwords match.
````
  - Ensure that the krb.conf and krb.realms files are readable by Oracle.
````
  - Ensure that the TNS_ADMIN environment variable is pointing to the directory containing the sqlnet.ora configuration file.
  - After trying to connect, check for a service ticket.
  - Check that the sqlnet.ora file on the database server side has a service name that corresponds to a service known by Kerberos.
````
  - Check that the clocks on all systems involved are set to times that are within a few minutes of each other or change the SQLNET.KERBEROS5_CLOCKSKEW parameter in the sqlnet.ora file.
  - Check the clocks on the client and database server.
````
  - Check that the v5srvtab file exists in the correct location and is readable by Oracle. Remember to set the sqlnet.ora parameters.
````
  - Check that the v5srvtab file has been generated for the service named in the sqlnet.ora file on the database server side.
  - Check that the initial ticket is forwardable. You must have obtained the initial ticket by running the okinit utility.
  - Check the expiration date on the credentials. If the credentials have expired, then close the connection and run okinit to get a new initial ticket.
## ORA-12631 Errors in the Kerberos Configuration
The `ORA-12631: username retrieval failed` error can result from the wrong or incorrectly formatted principal being used for the Kerberos authentication
Check the `sqlnet` server trace files for `Wrong principal in request` in the output.
To remedy this problem, edit the `krb5.conf` file and check the `[domain_realm]` settings. These settings are case sensitive, so even if the `domain_realm` name is correct, it will fail to parse correctly if it is lower case. Ensure that this setting is upper case. For example:
```
[domain_realm] .country. = SECWIN.LOCAL country. = SECWIN.LOCAL
```
## ORA-28575 Errors in the Kerberos Configuration
The `ORA-28575: unable to open RPC connection to external procedure agent` error can occur when the client is remote and the `EXTPROC` process is spawned.
There is no need to have Kerberos authentication with an external procedure call. To remedy this problem, add `BEQ` in front of the `KERBEROS5` and `KERBEROS5PRE` parameters in the `sqlnet.ora` file.
## ORA-01017 Errors in the Kerberos Configuration
The `ORA-01017: invalid username/password; logon denied` error can result if `okinit` fails and there is no valid ticket in the SQL*Plus connection.
The `okinit` trace file will show the following errors:
```
nauk5l_sendto_kdc: entry snauk5l_sendto_kdc: exit snauk5l_sendto_kdc: exit nauk5la_get_in_tkt: Returning 25: Additional pre-authentication required .
snauk5l_sendto_kdc: exit snauk5l_sendto_kdc: exit nauk5la_get_in_tkt: Returning 24: Preauthentication failed .
nauk5la_get_in_tkt: exit nauk5zi_kinit: Getting TGT failed: Preauthentication failed .
nauk5fq_free_principal: entry nauk5fq_free_principal: exit nauk5fq_free_principal: entry nauk5fq_free_principal: exit nauk5zi_kinit: Returning 24: Preauthentication failed .
nauk5zi_kinit: exit
```
To remedy this problem:
````
```
default_tgs_enctypes = aes256-cts-hmac-sha1-96
default_tkt_enctypes = aes256-cts-hmac-sha1-96
```
- Set the default_tkt_enctypes parameter in the krb5.conf file. This enables you to control the encryption types that are requested from the client. For example:
```
okinit user_name
```
```
okinit user_name
Kerberos Utilities for Solaris: Version 23.0.0.0.0 - Production on 15-MAY-2023 11:50:39
Copyright (c) 1996, 2023 Oracle. All rights reserved.
Password for user_name@domain:
okinit: KDC has no support for encryption type
okinit user_name
Kerberos Utilities for Solaris: Version 23.0.0.0.0 - Production on 15-MAY-2023 11:50:39
Copyright (c) 1996, 2023 Oracle. All rights reserved.
Password for user_name@domain:
okinit: Preauthentication failed
```
```
okinit user_name
Kerberos Utilities for Solaris: Version 23.0.0.0.0 - Production on 15-MAY-2023 11:50:39
Copyright (c) 1996, 2023 Oracle. All rights reserved.
Password for user_name@domain:
```
````
```
% sqlplus /@service_name
```
- Test okinit with the following option: If DES encryption algorithm is not implemented in an Active Directory server, the okinit fails: However, the following succeeds: The oklist utility lists the user principal from the ticket and as long as a valid ticket is present one can connect in the usual way. After okinit has completed successfully, you can connect to an Oracle Database server without using a user name or password, as follows:.
## Enabling Tracing for Kerberos okinit Operations
The `KRB5_TRACE` environment variable enables you to trace Kerberos `okinit` operations.
You can use this method verifying any encryption type that has been set using the `default_tkt_enctypes` setting in the `krb.conf`.
````
```
export KRB5_TRACE="/oracle/work/krb5.trc"
```
- Run the export command on the KRB5_TRACE environment variable. For example, for a trace file named krb5.trc:
```
okinit user_name
```
```
Kerberos Utilities for Linux: Version 23.0.0.0.0 - Development on 15-MAY-2023 21:37:39
Copyright (c) 1996, 2023 Oracle. All rights reserved.
Configuration file : /oracle/work/krb/krb.conf.
Password for user_name@US.EXAMPLE.COM:
pfitch@sales_us:/oracle/work/
```
- Run the okinit command as follows: Output similar to the following appears:
````
```
/oracle/work/fgrep aes256-cts krb5.trc [4072148] 1683321391.149999: Selected etype info: etype aes256-cts, salt "US.EXAMPLE.COMoratst", params "" [4072148] 1683321393.375503: AS key obtained from gak_fct: aes256-cts/95C0 [4072148] 1683321393.375504: Decrypted AS reply; session key is: aes256-cts/40F6 [4072182] 1683321415.915360: Selected etype info: etype aes256-cts, salt "US.EXAMPLE.COMoratst", params "" [4072182] 1683321417.701784: AS key obtained from gak_fct: aes256-cts/95C0 [4072182] 1683321417.701785: Decrypted AS reply; session key is: aes256-cts/859E [4075441] 1683322653.162464: Selected etype info: etype aes256-cts, salt "US.EXAMPLE.COMoratst", params "" [4075441] 1683322656.084028: AS key obtained from gak_fct: aes256-cts/1938 [4075455] 1683322659.360899: Selected etype info: etype aes256-cts, salt "US.EXAMPLE.COMoratst", params "" [4075455] 1683322661.242404: AS key obtained from gak_fct: aes256-cts/95C0 [4075455] 1683322661.242405: Decrypted AS reply; session key is: aes256-cts/3580
```
- Use the grep command to find the default_tkt_enctype setting in the trace file. For example:
