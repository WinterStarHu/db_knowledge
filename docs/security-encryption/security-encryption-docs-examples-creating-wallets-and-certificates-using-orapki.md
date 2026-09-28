# orapki Usage

Examples of `orapki` commands include creating wallets, user certificates, and wallets with self-signed certificates, and exporting certificates.
````
- Example: Wallet with a Self-Signed Certificate and Export of the Certificate The orapki wallet add command can create a wallet with a self-signed certificate; the orapki wallet export can export the certificate.
- Example: Creating a Wallet and a User Certificate The orapki utility can create wallets and user certificates.
## Example: Wallet with a Self-Signed Certificate and Export of the Certificate
The `orapki wallet add` command can create a wallet with a self-signed certificate; the `orapki wallet export` can export the certificate.
Example F-1 illustrates the steps to create a wallet with a self-signed certificate, view the wallet, and then export the certificate to a file.
Example F-1 Creating a Wallet with a Self-Signed Certificate and Exporting the Certificate
- Create a wallet. For example:
```
orapki wallet create -wallet /private/user/orapki_use/root
```
```
The wallet is created at the location, `/private/user/orapki_use/root`.
```
  - Add a self-signed certificate to the wallet.
```
orapki wallet add -wallet /private/user/orapki_use/root -dn 'CN=root_test,C=US' -keysize 2048 -self_signed -validity 3650
```
```
This creates a self-signed certificate with a validity of 3650 days. The distinguished name of the subject is `CN=root_test,C=US`. The key size for the certificate is 2048 bits.
```
  - View the wallet.
```
orapki wallet display -wallet /private/user/orapki_use/root
```
```
This is used to view the certificate contained in the wallet.
```
  - Export the certificate.
```
orapki wallet export -wallet /private/user/orapki_use/root -dn 'CN=root_test,C=US' -cert /private/user/orapki_use/root/b64certificate.txt
```
```
This exports the self-signed certificate to the file, `b64certificate.txt`. Note that the distinguished name used is the same as in step [2](#GUID-F298AB11-0E9F-43EB-9BEF-154D75102FF5__BABBBFJJ).
```
## Example: Creating a Wallet and a User Certificate
The `orapki` utility can create wallets and user certificates.
Example F-2 illustrates miscellaneous tasks related to creating user certificates.
The following steps illustrate creating a wallet, creating a certificate request, exporting the certificate request, creating a signed certificate from the request for testing, viewing the certificate, adding a trusted certificate to the wallet and adding a user certificate to the wallet.
Example F-2 Creating a Wallet and a User Certificate
- Create a wallet with auto-login enabled. For exmaple:
```
orapki wallet create -wallet /private/user/orapki_use/server -auto_login
```
```
This creates a wallet at `/private/user/orapki_use/server` with auto-login enabled.
```
  - Add a certificate request to the wallet.
```
orapki wallet add -wallet /private/user/orapki_use/server/ewallet.p12 -dn 'CN=server_test,C=US' -keysize 2048
```
```
This adds a certificate request to the wallet that was created (`ewallet.p12`). The distinguished name of the subject is `CN=server_test,C=US`. The key size specified is 2048 bits.
```
  - Export the certificate request to a file.
```
orapki wallet export -wallet /private/user/orapki_use/server -dn 'CN=server_test,C=US' -request /private/user/orapki_use/server/creq.txt
```
```
This exports the certificate request to the specified file, which is `creq.txt` in this case.
```
  - Create a signed certificate from the request for test purposes.
```
orapki cert create -wallet /private/user/orapki_use/root -request /private/user/orapki_use/server/creq.txt -cert /private/user/orapki_use/server/cert.txt -validity 3650
```
```
This creates a certificate, `cert.txt` with a validity of 3650 days. The certificate is created from the certificate request generated in the preceding step.
```
  - View the certificate.
```
orapki cert display -cert /private/user/orapki_use/server/cert.txt -complete
```
```
This displays the certificate generated in the preceding step. The `-complete` option enables you to display additional certificate information, including the serial number and public key.
```
  - Add a trusted certificate to the wallet.
```
orapki wallet add -wallet /private/user/orapki_use/server/ewallet.p12 -trusted_cert -cert /private/user/orapki_use/root/b64certificate.txt
```
```
This adds a trusted certificate, `b64certificate.txt` to the `ewallet.p12` wallet. You must add all trusted certificates in the certificate chain of a user certificate before adding a user certificate.
```
  - Add a user certificate to the wallet.
```
orapki wallet add -wallet /private/user/orapki_use/server/ewallet.p12 -user_cert -cert /private/user/orapki_use/server/cert.txt
```
```
This command adds the user certificate, `cert.txt` to the `ewallet.p12` wallet.
```
