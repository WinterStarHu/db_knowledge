# Utilities for the Kerberos Authentication Adapter

The Oracle Kerberos authentication adapter utilities are designed for an Oracle client with Oracle Kerberos authentication support installed.
- okinit Utility Options for Obtaining the Initial Ticket The okinit utility obtains and caches Kerberos tickets.
- oklist Utility Options for Displaying Credentials The oklist utility displays the list of tickets held.
````
- okdstry Utility Options for Removing Credentials from the Cache File The okdstry (okdestroy) utility removes credentials from the cache file.
- okcreate Utility Options for Automatic Keytab Creation The okcreate utility automates the creation of keytabs from either the KDC or a service endpoint.
## okinit Utility Options for Obtaining the Initial Ticket
The `okinit` utility obtains and caches Kerberos tickets.
This utility is typically used to obtain the ticket-granting ticket, using a password entered by the user to decrypt the credential from the key distribution center (KDC). The ticket-granting ticket is then stored in the user’s credential cache.
The following table lists the options available with `okinit`. To use the functionality that is described in this table, you must set the `sqlnet.ora` `SQLNET.KERBEROS5_CONF_MIT` parameter to `TRUE`. (Note that `SQLNET.KERBEROS5_CONF_MIT` is deprecated, but is retained for backward compatibility for `okinit`.)

| Option | Description |
|---|---|
| -f \| -F | Requests forwardable or non-forwardable tickets. This option is necessary to follow database links. |
| -l lifetime | Specifies the lifetime of the ticket-granting ticket and all subsequent tickets. By default, the ticket-granting ticket is good for eight (8) hours, but shorter or longer-lived credentials may be desired. The KDC can ignore this option or put site-configured limits on what can be specified. The lifetime value is a string that consists of a number qualified by w (weeks), d (days), h (hours), m (minutes), or s (seconds), as in the following example: okinit -l 2wld6h20m30s. The example requests a ticket-granting ticket that has a lifetime of 2 weeks, 1 day, 6 hours, 20 minutes, and 30 seconds. |
| -s start_time | Specifies the duration of the delay before the ticket can become valid. Tickets are issued with the invalid flag set. |
| -r renewable_life | Requests renewable tickets with a total lifetime of renewable_life |
| -p \| -P | Requests proxiable or non-proxiable tickets |
| -a | Requests tickets that are restricted to the local address of the host |
| -A | Requests tickets not restricted by address |
| -E | Treats the principal name as an enterprise name |
| -v | Requests that the ticket-granting ticket in the cache be passed to the KDC for validation. If the ticket is within the requested time range, then the cache is replaced with the validated ticket. |
| -R | Requests renewal of the ticket-granting ticket |
| -k [-t keytab_file] | Requests a ticket, which is obtained from a key in the local host’s keytab |
| -n | Requests anonymous processing |
| -C | Requests canonicalization of the principal name, and enables the KDC to reply with a different client principal from the one that was requested |
| -c cache_name | Specifies the name of a cache as a cache location. For UNIX, the default is /tmp/krb5cc_uid. You can also specify the alternate credential cache by using the SQLNET.KERBEROS5_CC_NAME parameter in the sqlnet.ora file. |
| -I input_cache | Specifies the name of a credential cache that already contains a ticket. When it obtains that ticket, if the information about how the ticket was obtained is stored in cache, then the same information will be used to affect how new credentials are obtained. |
| -T armor_cache | If supported by the KDC, this cache is used to armor the request, preventing offline dictionary attacks and enabling the use of additional pre-authentication mechanisms. |
| -X attribute[=value | Specifies a pre-authentication attribute and value. Specifies one of the following values: X509_user_identity=value specifies where to find the user’s X509 identity information, X509_anchors=value specifies where to find trusted X509 anchor information, and flag_RSA_PROTOCOL[=yes] specifies the use of RSA rather than the default Diffie-Hellman protocol. |
| -? | List command line options. |

## oklist Utility Options for Displaying Credentials
The `oklist` utility displays the list of tickets held.
The following table lists the available `oklist` options. To use the functionality that is described in this table, you must set the `sqlnet.ora` `SQLNET.KERBEROS5_CONF_MIT` parameter to `TRUE`. (Note that `SQLNET.KERBEROS5_CONF_MIT` is deprecated, but is retained for backward compatibility for `oklist`.)

| Option | Description |
|---|---|
| -f | Show flags with credentials. Relevant flags are: I, credential is a ticket-granting ticket; F, credential is forwardable; f, credential is forwarded. |
| -c | Specify an alternative credential cache. In UNIX, the default is /tmp/krb5cc_uid. The alternate credential cache can also be specified by using the SQLNET.KERBEROS5_CC_NAME parameter in the sqlnet.ora file. |
| -k | List the entries in the service table (default /etc/v5srvtab) on UNIX. The alternate service table can also be specified by using the SQLNET.KERBEROS5_KEYTAB parameter in the sqlnet.ora file. |
| -e | Displays the encryption types of the session key and the ticket for each credential in the credential cache, or each key in the keytab file. |
| -l | If a cache collection is available, displays a table summarizing the caches present in the collection. |
| -A | If a cache collection is available, displays the contents of all of the caches in the collection |
| -s | Runs utility without producing output. Utility will exit with status 1 if the cache cannot be read or is expired, else with status 0 |
| -a | Displays a list of addresses in the credential |
| -n | Shows numeric addresses instead of reverse-resolving addresses |
| -C | Lists configuration data that has been stored in the credentials cache when klist encounters it. By default, configuration data is not listed. |
| -t | Displays the time entry timestamps for each keytab entry in the keytab file |
| -K | Displays the value of the encryption key in each keytab entry in the keytab file |
| -V | Displays the Kerberos version number and exit. |

The show flag option (`-f`) displays additional information, as shown in the following example:
```
% oklist -f 04-Aug-2015 21:57:51   28-Aug-2015 05:58:14 krbtgt/EXAMPLE.COM@EXAMPLE.COM Flags: FI
```
## okdstry Utility Options for Removing Credentials from the Cache File
The `okdstry` (`okdestroy`) utility removes credentials from the cache file.
The following table lists the available `okdstry` options. To use the functionality that is described in this table, you must set the `sqlnet.ora` `SQLNET.KERBEROS5_CONF_MIT` parameter to `TRUE`. (Note that `SQLNET.KERBEROS5_CONF_MIT` is deprecated, but is retained for backward compatibility for `okdstry`.)

| Option | Description |
|---|---|
| -A | Destroys all caches in the collection, if a cache collection is available |
| -q | Runs quietly. Normally okdstry beeps if it fails to destroy the user’s tickets. This flag suppresses this behavior. |
| -c cache_name | Uses cache_name as the credentials (ticket) cache name and location. For UNIX, the default is /tmp/krb5cc_uid. You can also specify the alternate credential cache by using the SQLNET.KERBEROS5_CC_NAME parameter in the sqlnet.ora file. |

## okcreate Utility Options for Automatic Keytab Creation
The `okcreate` utility automates the creation of keytabs from either the KDC or a service endpoint.
The following table lists the available `okcreate` options.

| Option | Description |
|---|---|
| -name service_name | Specifies the service name of the kerberized service for which to get a keytab.The default is oracle. |
| -hosts path-to_hosts_list | Specifies either a comma-separated list of hosts for which to get the keytab, or the path to a text file that contains a list of the hosts. The default is none. |
| -out path_to_output | Specifies the output path to store the resulting keytabs. The default is the current directory. Ensure that this directory is readable only by the root user. Never send keytabs over the network in clear text. |
| -k | For use if the operation is performed on the KDC. Do not use this option if you are using -s. |
| -s | For use if the operation is performed on a Kerberized service. Do not use this option if you are using -k. |
| -u KDC_username | Specifies the user name for the KDC. Only use this setting on a Kerberized service endpoint. If you specify the -s and omit this setting, then okcreate prompts for the KDCuser@KDCmachine. |
| -r | Specifies the Kerberos realm |
| -p | Specifies the Kerberos principal |
| -q | Specifies the Kerberos query |
| -d | Specifies the KDC database name |
| -e | Specifies the salt list to be used for any new keys that are created |
| -m | Specifies to prompt for the KDC master password |
