# orapki Utility Commands Summary

The `orapki` commands perform a variety of wallet, certificate revocation lists (CRL), and certificate management tasks.
- orapki cert create The orapki cert create command creates a signed certificate for testing purposes.
- orapki cert display The orapki cert display command displays details of a specific certificate.
- orapki crl delete Command The orapki crl delete command deletes a certificate revocation list (CRL) from Oracle Internet Directory.
- orapki crl display The orapki crl display command displays a specified certificate revocation list (CRL) that is stored in Oracle Internet Directory.
- orapki crl hash The orapki crl hash command generates a hash value of the certificate revocation list (CRL) issuer to identify the CRL file system location for certificate validation.
- orapki crl list The orapki crl list command displays a list of certificate revocation lists (CRLs) stored in Oracle Internet Directory.
- orapki crl upload The orapki crl upload command uploads a certificate revocation list (CRL) to the CRL subtree in Oracle Internet Directory.
- orapki wallet add The orapki wallet add command adds certificate requests and certificates to an Oracle wallet.
- orapki wallet convert The orapki wallet convert command changes the Oracle wallet’s encryption algorithm from 3DES to AES256.
- orapki wallet create The orapki wallet create command creates an Oracle wallet or enables auto-login for an Oracle wallet.
- orapki wallet display The orapki wallet display command displays the certificate requests, user certificates, and trusted certificates in an Oracle wallet.
- orapki wallet export The orapki wallet export command exports certificate requests and certificates from an Oracle wallet.
## orapki cert create
The `orapki cert create` command creates a signed certificate for testing purposes.
**Syntax**
```
orapki cert create [-wallet wallet_location] -request certificate_request_location -cert certificate_location -validity number_of_days [-sign_alg md5|sha1|sha256|sha384|sha512|mldsa44|mldsa65|mldsa87] [-summary]
[-cert_validation_mode strict|non-strict]
```
- wallet specifies the wallet containing the user certificate and private key that will be used to sign the certificate request.
- request (mandatory) specifies the location of the certificate request for the certificate you are creating.
- cert (mandatory) specifies the directory location where the tool places the new signed certificate.
- validity (mandatory) specifies the number of days, starting from the current date, that this certificate will be valid.
````````
- sign_alg specifies the certificate signature algorithm. For an ML-DSA operation, specify mldsa44, mldsa65, or mldsa87 to match the selected ML-DSA variant.
``````
- cert_validation_mode specifies if strict certificate validation, conforming to the RFC#5280 standard is (strict) or is not (non-strict) being used.
## orapki cert display
The `orapki cert display` command displays details of a specific certificate.
**Syntax**
```
orapki cert display -cert certificate_location [-summary|-complete]
```
- cert specifies the location of the certificate you want to display.
````
  - summary displays the certificate and its expiration date
  - complete displays additional certificate information, including the serial number and public key
## orapki crl delete Command
The `orapki crl delete `command deletes a certificate revocation list (CRL) from Oracle Internet Directory.
The user who deletes the CRLs from the directory by using `orapki` must be a member of the `CRLAdmins` (`cn=CRLAdmins,cn=groups,%s_OracleContextDN%`) directory group.
**Prerequisites**
None
**Syntax**
```
orapki crl delete -issuer issuer_name -ldap hostname:ssl_port -user username [-wallet wallet_location] [-summary]
```
- issuer specifies the name of the certificate authority (CA) who issued the CRL.
- ldap specifies the host name and SSL port for the directory where the CRLs are to be deleted. Note that this must be a directory SSL port with no authentication. See also Uploading CRLs to Oracle Internet Directory for more information about this port.
- user specifies the user name of the directory user who has permission to delete CRLs from the CRL subtree in the directory.
- wallet (optional) specifies the location of the wallet that contains the certificate of the certificate authority (CA) who issued the CRL. Using it causes the tool to verify the validity of the CRL against the CA’s certificate prior to deleting it from the directory.
- summary is optional. It displays the CRL LDAP entry that was deleted.
## orapki crl display
The `orapki crl display` command displays a specified certificate revocation list (CRL) that is stored in Oracle Internet Directory.
**Syntax**
```
orapki crl display -crl crl_location [-wallet wallet_location] [-summary|-complete]
```
````
- crl parameter specifies the location of the CRL in the directory. It is convenient to paste the CRL location from the list that displays when you use the orapki crl list command. See orapki crl list.
- wallet (optional) specifies the location of the wallet that contains the certificate of the certificate authority (CA) who issued the CRL. Using it causes the tool to verify the validity of the CRL against the CA’s certificate prior to displaying it.
````
  - summary provides a listing that contains the CRL issuer’s name and the CRL’s validity period
  - complete provides a list of all revoked certificates that the CRL contains. Note that this option may take a long time to display, depending on the size of the CRL.
## orapki crl hash
The `orapki crl hash` command generates a hash value of the certificate revocation list (CRL) issuer to identify the CRL file system location for certificate validation.
**Syntax**
```
orapki crl hash -crl crl_filename\|URL [-wallet wallet_location] [-symlink|-copy] crl_directory [-summary]
```
- crl specifies the filename that contains the CRL or the URL where it can be found.
- wallet (optional) specifies the location of the wallet that contains the certificate of the certificate authority (CA) who issued the CRL. Using it causes the tool to verify the validity of the CRL against the CA’s certificate prior to uploading it to the directory.
````
````
  - (UNIX) symlink creates a symbolic link to the CRL at the crl_directory location
````
  - (Windows) copy creates a copy of the CRL at the crl_directory location
- summary (optional) displays the CRL issuer’s name.
## orapki crl list
The `orapki crl list` command displays a list of certificate revocation lists (CRLs) stored in Oracle Internet Directory.
**Syntax** This is useful for browsing to locate a particular CRL to view or download to your local file system.
```
orapki crl list -ldap hostname:ssl_port
```
`ldap` specifies the host name and SSL port for the directory server from where you want to list CRLs. Note that this must be a directory SSL port with no authentication.
## orapki crl upload
The `orapki crl upload` command uploads a certificate revocation list (CRL) to the CRL subtree in Oracle Internet Directory.
Note that you must be a member of the directory administrative group `CRLAdmins` (`cn=CRLAdmins,cn=groups,%s_OracleContextDN%`) to upload CRLs to the directory.
**Syntax**
```
orapki crl upload -crl crl_location -ldap hostname:ssl_port -user username [-wallet wallet_location] [-summary]
```
- crl specifies the directory location or the URL where the CRL is located that you are uploading to the directory.
- ldap specifies the host name and SSL port for the directory where you are uploading the CRLs. Note that this must be a directory SSL port with no authentication. See also Uploading CRLs to Oracle Internet Directory for more information about this port.
- user specifies the user name of the directory user who has permission to add CRLs to the CRL subtree in the directory.
- wallet specifies the location of the wallet that contains the certificate of the certificate authority (CA) who issued the CRL. This is an optional parameter. Using it causes the tool to verify the validity of the CRL against the CA’s certificate prior to uploading it to the directory.
- summary is optional. It displays the CRL issuer’s name and the LDAP entry where the CRL is stored in the directory.
## orapki wallet add
The `orapki wallet add` command adds certificate requests and certificates to an Oracle wallet.
**Syntax** To add a certificate request, use the syntax for the selected public-key algorithm.
```
orapki wallet add -wallet wallet_location -dn user_dn -asym_alg RSA -keySize 512|1024|2048|4096|8192|16384 [-sign_alg md5|sha1|sha256|sha384|sha512|mldsa44|mldsa65|mldsa87] [-cert_validation_mode strict|non-strict]
```
```
orapki wallet add -wallet wallet_location -dn user_dn -asym_alg ECC -eccurve p192|p224|p256|p384|p521|k163|k233|k283|k409|k571|b163|b233|b283|b409|b571 [-sign_alg md5|sha1|sha256|sha384|sha512|mldsa44|mldsa65|mldsa87] [-cert_validation_mode strict|non-strict]
```
```
orapki wallet add -wallet wallet_location -dn user_dn -asym_alg ML-DSA-44|ML-DSA-65|ML-DSA-87 [-sign_alg md5|sha1|sha256|sha384|sha512|mldsa44|mldsa65|mldsa87] [-cert_validation_mode strict|non-strict]
```
- wallet specifies the location of the wallet to which you want to add a certificate request.
- dn specifies the distinguished name of the certificate owner.
````````````
- asym_alg specifies the certificate public-key algorithm. Specify RSA, ECC, ML-DSA-44, ML-DSA-65, or ML-DSA-87.
````
- keySize specifies the RSA key size. Do not specify -keySize for ML-DSA.
````````````````````````````````
- eccurve specifies the ECC curve. Specify p192, p224, p256, p384, p521, k163, k233, k283, k409, k571, b163, b233, b283, b409, or b571.
````````````````````````
- sign_alg specifies the certificate signature algorithm. Specify md5, sha1, sha256, sha384, sha512, mldsa44, mldsa65, or mldsa87. For an ML-DSA operation, specify mldsa44, mldsa65, or mldsa87 to match the selected ML-DSA variant.
- To sign the request, export it with the export option. Refer to orapki wallet export
``````
- cert_validation_mode specifies if strict certificate validation, conforming to the RFC#5280 standard is (strict) or is not (non-strict) being used.
To add trusted certificates:
```
orapki wallet add -wallet wallet_location -trusted_cert -cert certificate_location
```
  ````- trusted_cert adds the trusted certificate, at the location specified with -cert, to the wallet.
To add a self-signed certificate:
```
orapki wallet add -wallet wallet_location -dn certificate_dn -asym_alg public_key_algorithm [-keySize key_size] [-eccurve ec_curve] [-sign_alg signature_algorithm] -self_signed (-validity number_of_days|-valid_from date -valid_until date)
```
- self_signed creates a self-signed certificate.
``````
- Specify -validity to set the number of days, starting from the current date, that the certificate is valid. Alternatively, specify both -valid_from and -valid_until to set the validity period.
``````````
- asym_alg specifies the public-key algorithm used to generate the certificate. For ML-DSA certificates, specify ML-DSA-44, ML-DSA-65, or ML-DSA-87; do not specify -keySize.
To add user certificates:
```
orapki wallet add -wallet wallet_location -user_cert -cert certificate_location
```
  ````- user_cert adds the user certificate at the location specified with the -cert parameter to the wallet. Before you add a user certificate to a wallet, you must add all the trusted certificates that make up the certificate chain. If all trusted certificates are not installed in the wallet before you add the user certificate, then adding the user certificate will fail.
## orapki wallet convert
The `orapki wallet convert` command changes the Oracle wallet’s encryption algorithm from 3DES to AES256.
**Syntax**
```
orapki wallet convert -wallet wallet_location [-pwd wallet_password] [-compat_v12]
```
- wallet specifies a location for the new wallet or the location of the wallet for which you want to turn on auto-login.
- pwd is the wallet password.
- compat_v12 performs the conversion from 3DES to AES256.
## orapki wallet create
The `orapki wallet create` command creates an Oracle wallet or enables auto-login for an Oracle wallet.
**Syntax**
```
orapki wallet create -wallet wallet_location [-auto_login|-auto_login_local]
```
The default algorithm is AES256.
- wallet specifies a location for the new wallet or the location of the wallet for which you want to turn on auto-login.
````
**
- auto_login creates an auto-login wallet, or it turns on automatic login for the wallet specified with the -wallet option. See also Oracle Database Enterprise User Security Administrator’s Guide for details about auto-login wallet.
````
- auto_login_local creates a local auto-login wallet, or it turns on local automatic login for the wallet specified with the -wallet option.
## orapki wallet display
The `orapki wallet display` command displays the certificate requests, user certificates, and trusted certificates in an Oracle wallet.
The `orapki wallet display` command is a superset of the information that is shown in the `orapki secretstore list_entries` command. `orapki wallet display` shows everything, including the secret store entries’ thumbprint. It inlcudes both the SHA-1 and SHA-256 thumbprint information for a private key. These thumbprints select a particular certificate from the wallet and are displayed when you run the `orapki wallet display` command. You can specify an alias when you store a private key. The alias and thumbprint enable you to specify the exact private key to use with the connect string.
**Syntax**
```
orapki wallet display [-wallet [wallet_file_directory]] [-summary | [-complete | -complete -details]] [-pwd wallet_password] [-ssvs]
```
- wallet specifies a location for the wallet you want to open if it is not located in the current working directory.
````
- summary displays a summary of the wallet information; complete displays more details.
- ssvs displays the version of the wallet.
  - summary is the subject name.
````````````````````````
  - complete contains Alias, Subject, Issuer, Not Before, Not After, Serial Number, Key Length, MD5 digest, SHA-256 digest, SHA-1 digest, Thumbprint
``````````````````````````````````````
  - details contains Alias, Subject, Version, Subject, Issuer, Serial Number, Not Before, Not After, Fingerprint, Signature Algorithm, MD5 digest, SHA-256 digest (thumbprint), SHA-1 digest (thumbprint), Subject Public Key Information (which includes Key Algorithm, Key Length, and Key Data), and, if any, Certificate Extensions.
**Example**
```
orapki  wallet display -wallet $ORACLE_HOME/admin/db_unique_name/wallet
```
## orapki wallet export
The `orapki wallet export` command exports certificate requests and certificates from an Oracle wallet.
**Syntax** To export a certificate from an Oracle wallet:
```
orapki wallet export -wallet wallet_location -dn certificate_dn -cert certificate_filename
```
- wallet specifies the location of the wallet from which you want to export the certificate.
- dn specifies the distinguished name of the certificate.
- cert specifies the name of the file that contains the exported certificate.
To export a certificate request from an Oracle wallet:
```
orapki wallet export -wallet wallet_location -dn certificate_request_dn -request certificate_request_filename
```
  - request specifies the name of the file that contains the exported certificate request.
## Related Topics
  - Uploading CRLs to Oracle Internet Directory for more information about this port
