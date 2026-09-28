# Managing Oracle Wallets with orapki Utility

The `orapki` utility can create, view, modify wallets; it can add and export certificates and certificate requests.
- About Managing Wallets with orapki You should understand the orapki command-line utility syntax used to create and manage Oracle wallets.
- Creating, Viewing, and Modifying Wallets with orapki You can use orapki to perform a range of management activities with Oracle wallets.
- Adding Certificates and Certificate Requests to Oracle Wallets with orapki You can use the orapki utiltiy to perform a range of certificate-related tasks.
- Exporting Certificates and Certificate Requests from Oracle Wallets with orapki You can use the orapki utility to export certificates and certificate requests from Oracle wallets.
## About Managing Wallets with orapki
You should understand the `orapki` command-line utility syntax used to create and manage Oracle wallets.
You can use the `orapki` utility `wallet` module commands in scripts to automate the wallet creation process. For example, you can create PKCS#12 wallets and auto-login wallets. You can create auto-login wallets that are associated with PKCS#12 wallets or auto-login wallets that are local to the computer on which they were created and the user who created them. You can view wallets, modify wallet passwords, and convert wallets to use the AES256 algorithm.
**Note:**   The `-wallet` parameter is mandatory for all `wallet` module commands.
## Creating, Viewing, and Modifying Wallets with orapki
You can use `orapki` to perform a range of management activities with Oracle wallets.
- Creating a PKCS#12 Wallet You can use the orapki utility to create a PKCS#12 Oracle wallet.
- Using OpenSSL to Create a PKCS#12 Wallet That Has a Certificate Chain You can use the OpenSSL utility to create an PKCS#12 wallet so that it has a certificate chain.
- Creating an Auto-Login Wallet You can use the orapki utility to create an auto-login wallet.
- Creating an Auto-Login Wallet That Is Associated with a PKCS#12 Wallet You can create an auto-login wallet that is associated with a PKCS#12 wallet.
- Creating an Auto-Login Wallet That Is Local to the Computer and User Who Created It The orapki utility can create an auto-login wallet that is local to the computer of the user who created it.
- Viewing a Wallet You can use the orapki utility to view a wallet.
- Modifying the Password for a Wallet You can use the orapki utility to modify the password of a wallet.
````
- Converting an Oracle Wallet to Use the AES256 Algorithm By default , an Oracle wallet with the ADMINISTER KEY MANAGEMENT or ALTER SYSTEM statement is encrypted with 3DES.
### Creating a PKCS#12 Wallet
You can use the `orapki` utility to create a PKCS#12 Oracle wallet.
  ````- To create an Oracle PKCS#12 wallet (ewallet.p12), use the orapki wallet create command.
```
orapki wallet create -wallet wallet_location [-pwd password]
```
This command prompts you to enter and reenter a wallet password, if no password has been specified on the command line. It creates a wallet in the location specified for `-wallet`.
**Note:**   The default algorithm is AES
  - For security reasons, Oracle recommends that you do not specify the password at the command line. You should supply the password only when prompted to do so.
### Using OpenSSL to Create a PKCS#12 Wallet That Has a Certificate Chain
You can use the OpenSSL utility to create an PKCS#12 wallet so that it has a certificate chain.
```
cat root.cer sub.cer > ca.certs
```
- Concatenate the CA certificate chain. For example: In this example, root.cer is the root certificate.
```
openssl pkcs12 -export -nodes -certfile ca.certs -inkey user.key -in user.cer
```
- Run openssl to create the PKCS#12 wallet.
- When prompted, provide a password for the wallet. Ensure that this password at at least 8 characters with an alphnumeric character mix.
For more information about how OpenSSL works with PKCS#12 wallets, visit https://www.openssl.org/ and search for “pkcs12”.
### Creating an Auto-Login Wallet
You can use the `orapki` utility to create an auto-login wallet.
  ````- To create an auto-login wallet (cwallet.sso), which does not need a password to open the wallet, use the orapki wallet create command.
```
orapki wallet create -wallet wallet_location -auto_login_only
```
You can modify or delete the wallet without using a password. File system permissions provide the necessary security for such auto-login wallets.
You cannot move local auto-login wallets to another computer. They must be used on the host on which they are created.
Even though a local auto-login wallet does not need a password to open, you must supply the password for the associated PKCS#12 wallet in order to modify or delete the wallet. Any update to the PKCS#12 wallet also updates the associated auto-login wallet.
### Creating an Auto-Login Wallet That Is Associated with a PKCS#12 Wallet
You can create an auto-login wallet that is associated with a PKCS#12 wallet.
The auto-login wallet does not need a password to open.
However, you must supply the password for the associated PKCS#12 wallet in order to modify or delete the wallet. Any update to the PKCS#12 wallet also updates the associated auto-login wallet.
  ``````- To create an auto-login wallet (cwallet.sso) that is associated with a PKCS#12 wallet (ewallet.p12), use the orapki wallet create command.
```
orapki wallet create -wallet wallet_location -auto_login [-pwd wallet_password]
```
This command creates a wallet with auto-login enabled (`cwallet.sso`) and associates it with a PKCS#12 wallet (`ewallet.p12`). The command prompts you to enter the password for the PKCS#12 wallet, if no password has been specified at the command line.
If the *wallet_location* already contains a PKCS#12 wallet, then auto-login is enabled for it. You must supply the password for the existing PKCS#12 wallet in order to enable auto-login for it.
If the *wallet_location* does not contain a PKCS#12 wallet, then a new PKCS#12 wallet is created. You must specify a password for the new PKCS#12 wallet.
If you want to turn the auto-login feature off for a PKCS#12 wallet, then use Oracle Wallet Manager.
### Creating an Auto-Login Wallet That Is Local to the Computer and User Who Created It
The `orapki` utility can create an auto-login wallet that is local to the computer of the user who created it.
  - To create a local auto-login wallet that is local to both the computer on which it is created and the user who created it, use the following command:
```
orapki wallet create -wallet wallet_location -auto_login_local [-pwd wallet_password]
```
This command creates an auto-login wallet (`cwallet.sso`). It associates it with a PKCS#12 wallet (`ewallet.p12`). The command prompts you to enter the password for the PKCS#12 wallet, if no password has been specified at the command line.
### Viewing a Wallet
You can use the `orapki` utility to view a wallet.
  - To view an Oracle wallet, use the orapki wallet display command.
```
orapki wallet display -wallet wallet_location
```
This command displays the certificate requests, user certificates, and trusted certificates contained in the wallet, which must be a binary `PKCS12` file, with extension `.p12`. Other files will fail.
### Modifying the Password for a Wallet
You can use the `orapki` utility to modify the password of a wallet.
  - To change the wallet password, use the orapki wallet change_pwd command.
```
orapki wallet change_pwd -wallet wallet_location [-oldpwd wallet_password ] [-newpwd wallet_password]
```
This command changes the current wallet password to the new password. The command prompts you for the old and new passwords if no password is supplied at the command line.
**Note:**   For security reasons, Oracle recommends that you do not specify the password options at the command line. You should supply the password when prompted to do so.
### Converting an Oracle Wallet to Use the AES256 Algorithm
By default , an Oracle wallet with the `ADMINISTER KEY MANAGEMENT` or `ALTER SYSTEM` statement is encrypted with 3DES.
Starting with Oracle Database release
19.22, the default is AES256, not 3DES.
For FIPS 140-2 compliance, Oracle recommends that you change the wallet encryption algorithm 3DES to AES256. You can use the `orapki convert` command to convert the wallet to use the AES256 algorithm, which is stronger than the 3DES algorithm. Note that if you had created the wallet using `ADMINISTER KEY MANAGEMENT` or `ALTER SYSTEM` statement, then by default it uses the AES256 algorithm.
**Note:**   The 3DES112 and 3DES168 algorithms are deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
  - To change the wallet algorithm from 3DES to AES256, use the orapki wallet convert command.
```
orapki wallet convert -wallet wallet_location [-pwd wallet_password] [-compat_v12]
```
The `compat_v12` setting performs the conversion from 3DES to AES
256.
## Adding Certificates and Certificate Requests to Oracle Wallets with orapki
You can use the `orapki` utiltiy to perform a range of certificate-related tasks.
- Adding a Certificate Request to an Oracle Wallet You can use the orapki utility to add certificates and certificate requests to Oracle wallets.
- Adding a Trusted Certificate to an Oracle Wallet You can use the orapki utility to add trusted certificates to an Oracle wallet.
- Adding a Root Certificate to an Oracle Wallet You can use the orapki utility to add a root certificate to an Oracle wallet.
- Adding a User Certificate to an Oracle Wallet You can use the orapki utility to add a user certificate to an Oracle wallet.
- Verifying Credentials on the Hardware Device That Uses a PKCS#11 Wallet You can verify credentials on the hardware device using the PKCS#11 wallet.
- Adding PKCS#11 Information to an Oracle Wallet A wallet that contains PKCS#11 information can be used like any Oracle wallet.
### Adding a Certificate Request to an Oracle Wallet
You can use the `orapki` utility to add certificates and certificate requests to Oracle wallets.
  - To add a certificate request to an Oracle wallet, use the orapki wallet add command.
```
orapki wallet add -wallet wallet_location -dn user_dn -keySize 512|1024|2048
```
This command adds a certificate request to a wallet for the user with the specified distinguished name (`user_dn`). The request also specifies the requested certificate’s key size (512, 1024, or 2048 bits). To sign the request, export it with the export option.
### Adding a Trusted Certificate to an Oracle Wallet
You can use the `orapki` utility to add trusted certificates to an Oracle wallet.
  - To add a trusted certificate to an Oracle wallet, use the orapki wallet add command.
```
orapki wallet add -wallet wallet_location -trusted_cert -cert certificate_location
```
This command adds a trusted certificate, at the specified location (`-cert certificate_location`), to a wallet. You must add all trusted certificates in the certificate chain of a user certificate before adding a user certificate, or the command to add the user certificate will fail.
### Adding a Root Certificate to an Oracle Wallet
You can use the `orapki` utility to add a root certificate to an Oracle wallet.
  - To add a root certificate to an Oracle wallet, use the orapki wallet add command.
```
orapki wallet add -wallet wallet_location -dn certificate_dn -keySize 512\|1024\|2048 -self_signed -validity number_of_days [-cert_validation_mode strict|non-strict]
```
This command creates a new self-signed (root) certificate and adds it to the wallet.
- The -validity parameter (mandatory) specifies the number of days, starting from the current date, that this certificate will be valid.
- You can specify a key size for this root certificate (-keySize) of 512, 1024, or 2048 bits.
``````
- The -cert_validation_mode parameter specifies if strict certificate validation, conforming to the RFC#5280 standard is (strict) or is not (non-strict) being used.
### Adding a User Certificate to an Oracle Wallet
You can use the `orapki` utility to add a user certificate to an Oracle wallet.
  - To add a user certificate to an Oracle wallet, use the orapki wallet add command.
```
orapki wallet add -wallet wallet_location -user_cert -cert certificate_location
```
This command adds the user certificate at the location specified with the `-cert` parameter to the Oracle wallet at the `wallet_location`.
 **Note:**   For security reasons, Oracle recommends that you do not specify the password at the command line. You should supply the password when prompted to do so.
### Verifying Credentials on the Hardware Device That Uses a PKCS#11 Wallet
You can verify credentials on the hardware device using the PKCS#11 wallet.
  - To verify the credential details, use the orapki wallet p11_verify command.
```
orapki wallet p11_verify -wallet wallet_location [-pwd wallet_password]
```
**Tip:**
`orapki p11_verify` Native Failure Reporting
Starting with Oracle Database 19.32, the `orapki wallet p11_verify` command now reports an error when native PKCS#11 verification fails, instead of allowing the failure to go undetected or be reported unclearly.
Making PKCS#11 wallet verification failures visible to users improves accuracy and usability. Users can troubleshoot faster and experience less confusion during wallet validation.
### Adding PKCS#11 Information to an Oracle Wallet
A wallet that contains PKCS#11 information can be used like any Oracle wallet.
The private keys are stored on a hardware device. The cryptographic operations are also performed on the device.
  - To add PKCS#11 information to a wallet, use the orapki wallet p11_add command.
```
orapki wallet p11_add -wallet wallet_location -p11_lib pkcs11Lib [-p11_tokenlabel tokenLabel] [-p11_tokenpw tokenPassphrase] [-p11_certlabel certLabel] [-pwd wallet_password]
```
In this specification:
- wallet specifies the wallet location.
- p11_lib specifies the path to the PKCS#11 library. This includes the library filename.
- p11_tokenlabel specifies the token or smart card used on the device. Use this when there are multiple tokens on the device. Token labels are set using vendor tools.
- p11_tokenpw specifies the password that is used to access the token. Token passwords are set using vendor tools.
- p11_certlabel is used to specify a certificate label on the token. Use this when a token contains multiple certificates. Certificate labels are set using vendor tools.
- pwd is used to specify the wallet password.
## Exporting Certificates and Certificate Requests from Oracle Wallets with orapki
You can use the `orapki` utility to export certificates and certificate requests from Oracle wallets.
  - To export a certificate from an Oracle wallet, use the orapki wallet export command.
```
orapki wallet export -wallet wallet_location -dn certificate_dn -cert certificate_filename
```
This command exports a certificate with the subject’s distinguished name (`-dn`) from a wallet to a file that is specified by `-cert`.
To export a certificate request from an Oracle wallet, use the following command:
```
orapki wallet export -wallet wallet_location -dn certificate_request_dn -request certificate_request_filename
```
This command exports a certificate request with the subject’s distinguished name (`-dn`) from a wallet to a file that is specified by `-request`.
## Post-Quantum Certificates with orapki
Starting with Oracle Database 19.32, the `orapki` utility supports creating self-signed ML-DSA certificates, reading ML-DSA certificates, and adding ML-DSA certificates to an Oracle wallet regardless of which cryptographic provider is enabled. This capability requires JDK 24 or later.
To create a self-signed certificate with an ML-DSA key:
```
orapki wallet add -wallet wallet_location -dn "CN=example" \ -keyAlg ML-DSA-65 -validity 365
```
Supported post-quantum key algorithms for `orapki`:

| Algorithm | Approximate Classical Equivalent |
|---|---|
| ML-DSA-44 | Approximately equivalent to RSA 2048-bit key |
| ML-DSA-65 | Approximately equivalent to RSA 3072-bit key |
| ML-DSA-87 | Approximately equivalent to RSA 4096-bit key |

**Recommended Classic Certificate Algorithms:**
For classic (non-PQC) certificates, the following are recommended in order of strength:
  - ECC: ecdsa_secp521r1_sha512, equivalent to an RSA 15360-bit key
  - ECC: ecdsa_secp384r1_sha384, equivalent to an RSA 7680-bit key
  - ECC: ecdsa_secp256r1_sha256, equivalent to an RSA 3072-bit key
  - RSA: 2048-bit minimum. NIST recommends at least 3072-bit after 2030.
To check the certificate algorithm and key length:
```
orapki wallet display -wallet wallet_dir -complete -details
```
Prerequisites:
  - The next-generation provider must be active for ML-DSA certificates.
  - JDK 24 or later must be installed and configured in the JAVA_HOME environment variable.
**Wallet Encryption Check:**
Wallets created before Oracle Database 19.22 may use 3DES encryption. To determine the encryption algorithm:
```
openssl pkcs12 -info -in ./ewallet.p12 -nodes
```
If the wallet uses 3DES, convert it to AES-256:
```
orapki wallet convert -wallet wallet_location -compat_v12
```
## Related Topics
  **- Oracle Database Enterprise User Security Administrator’s Guide for more information
  - Ensuring Encryption Algorithms are FIPS 140-3 Compliant
  - Post-Quantum Cryptography in Oracle Database
  - Exporting Certificates and Certificate Requests from Oracle Wallets with orapki
