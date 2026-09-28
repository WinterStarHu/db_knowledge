# orapki Utility Syntax

The `orapki` utility syntax specifies an Oracle wallet, a certificate revocation list, or a PKI digital certificate.
The syntax of the `orapki` command-line utility is as follows:
```
orapki module command -parameter value
```
In this specification, *module* can be `wallet` (Oracle wallet), `crl` (certificate revocation list), or `cert` (PKI digital certificate). The available commands depend on the `module` you are using.
For example, if you are working with a `wallet`, then you can add a certificate or a key to the wallet with the `add` command. The following example adds the user certificate located at `/private/lhale/cert.txt` to the wallet located at `$ORACLE_HOME/wallet/ewallet.p12`:
```
orapki wallet add -wallet $ORACLE_HOME/wallet/ewallet.p12 -user_cert -cert /private/lhale/cert.txt
```
