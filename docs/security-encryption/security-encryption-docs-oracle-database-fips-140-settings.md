# Oracle Database FIPS 140-2 and FIPS 140-3 Settings

Oracle supports the Federal Information Processing Standard (FIPS) standards for 140-2 and 140-3.
- About the Oracle Database FIPS 140-2 Settings Federal Information Processing Standards (FIPS) are standards and guidelines for federal computer systems that are developed by the U.S. National Institute of Standards and Technology (NIST).
- FIPS 140 Support by Cryptographic Provider Oracle Database 19c supports FIPS 140-2 with both cryptographic providers and FIPS 140-3 only with the next-generation cryptographic provider.
- Configuring FIPS 140-2 and FIPS 140-3 for Transparent Data Encryption and DBMS_CRYPTO FIPS configuration for TDE and DBMS_CRYPTO depends on the active cryptographic provider.
- Configuration of FIPS 140-2 and FIPS 140-3 for Transport Layer Security FIPS configuration for Transport Layer Security (TLS) depends on the active cryptographic provider.
- Configuration of FIPS 140-2 and FIPS 140-3 for Native Network Encryption You can configure FIPS for native network encryption by setting parameters in the sqlnet.ora file for both the server and the client.
- Post-Installation Checks for FIPS 140-2 After you configure the FIPS 140-2 settings, you must verify permissions in the operating system.
- Verifying FIPS 140-2 Connections You can use trace files and other methods to verify the FIPS 140-2 connections.
- Ensuring Encryption Algorithms are FIPS 140-3 Compliant Oracle offers support for FIPS 140-3 in Oracle Database 19c depending on the cryptographic provider. Follow these steps to ensure your encryption algorithms are FIPS 140-3 compliant prior to switching from FIPS 140-2 to FIPS 140-3, and prior to upgrading from Oracle Database 19c to Oracle AI Database 26ai.
- FIPS 140-3 Algorithm Restrictions FIPS 140-3 mode restricts 3DES and other algorithms that are not available with the next-generation provider.
- Migrating from FIPS 140-2 to FIPS 140-3 Migrate to the next-generation cryptographic provider and remove algorithms that are not available in FIPS 140-3 mode.
## About the Oracle Database FIPS 140-2 Settings
Federal Information Processing Standards (FIPS) are standards and guidelines for federal computer systems that are developed by the U.S. National Institute of Standards and Technology (NIST).
FIPS was developed in accordance with the Federal Information Security Management Act (FISMA). Although FIPS was developed for use by the federal government, many private sector entities voluntarily use these standards.
Oracle Database 19c supports two FIPS 140 standard versions, depending on the active cryptographic provider:
****
- FIPS 140-2: Available with Dell BSAFE Crypto-C Micro Edition Suite, or MES (legacy cryptographic provider), and with the next-generation cryptographic provider. MES has been validated against FIPS 140-2.
****
- FIPS 140-3: Available with the next-generation cryptographic provider. The module has completed lab testing and is listed on the NIST Cryptographic Provider Validation Program (CMVP) modules in process list. Final FIPS 140-3 certificate issuance is pending. The FIPS 140-3 validation covers all cryptographic algorithms in the next-generation cryptographic provider except the new post-quantum cryptography algorithms.
**Note:** The National Institute of Standards and Technology (NIST) has announced that FIPS 140-2 will be moved to the historical list on September 22, 2026. After this date, NIST will no longer accept FIPS 140-2 validation submissions and will begin transitioning listed modules to the historical list.
### Enabling FIPS Mode with the Legacy provider (Current 19c Default):
The legacy provider requires three settings to enable FIPS 140-2 mode:
``````
- For TLS, set SSLFIPS_140=true in the fips.ora file, located by default in $ORACLE_HOME/ldap/admin.
``````
- For NNE, set SQLNET.FIPS_140=TRUE in the sqlnet.ora file, located by default in $ORACLE_HOME/network/admin.
````
- For TDE and DBMS_CRYPTO, set the DBFIPS_140=true initialization parameter.
### Enabling FIPS Mode with the Next-Generation provider:
The next-generation cryptographic provider uses the following parameters in `fips.ora`:
````
- Set FIPS_140=TRUE in the fips.ora file. This enables FIPS 140-2 mode.
````
- To enable FIPS 140-3 mode, also set FIPS_140_3=TRUE in the fips.ora file.
Only one cryptographic provider can be active at a time. You cannot run FIPS 140-2 and FIPS 140-3 simultaneously in the same database instance.
## FIPS 140 Support by Cryptographic Provider
FIPS support depends on the active cryptographic provider.

| Cryptographic Provider | FIPS Standard | Configuration |
|---|---|---|
| Legacy cryptographic provider | FIPS 140-2 | Use the existing FIPS 140-2 parameters. |
| Next-generation cryptographic provider | FIPS 140-2 and FIPS 140-3 | Set FIPS_140=TRUE; also set FIPS_140_3=TRUE for FIPS 140-3 mode. |

To enable FIPS mode in Oracle Database 19c, follow the configuration steps appropriate for the active cryptographic provider.
**Configuring FIPS with the Legacy provider (Default):**
The legacy provider requires three separate settings:
``````
- For TLS: Set SSLFIPS_140=true in the fips.ora file (default location: $ORACLE_HOME/ldap/admin).
``````
- For NNE: Set SQLNET.FIPS_140=TRUE in the sqlnet.ora file (default location: $ORACLE_HOME/network/admin).
````
- For TDE and DBMS_CRYPTO: Set the DBFIPS_140=true initialization parameter.
This enables FIPS 140-2 mode. The legacy provider supports only FIPS 140-2.
**Configuring FIPS with the Next-Generation provider:** To enable FIPS 140-2 with the next-generation cryptographic provider, set the following parameter in the `fips.ora` file:
```
FIPS_140 = TRUE
```
To enable FIPS 140-3, also set:
```
FIPS_140_3 = TRUE
```
The following legacy FIPS parameters are deprecated when the next-generation provider is active:
  ``````- SSLFIPS_140 in fips.ora: Use FIPS_140 instead.
  ````- SQLNET.FIPS_140 in sqlnet.ora: This parameter is no longer required with the next-generation provider.
  - DBFIPS_140 initialization parameter: This parameter is no longer required with the next-generation provider.
If both `SSLFIPS_140` and `FIPS_140` are present, `FIPS_140` takes precedence.
Restart the database instance and Oracle Net listener after changing FIPS configuration.
To verify that FIPS mode is active, check the database alert log for a message indicating the FIPS mode is in effect.
## Configuring FIPS 140-2 and FIPS 140-3 for Transparent Data Encryption and DBMS_CRYPTO
To enable FIPS mode for Transparent Data Encryption (TDE) and the `DBMS_CRYPTO` PL/SQL package in Oracle Database 19c, follow the configuration steps appropriate for the active cryptographic provider.
**Configuring FIPS with the Legacy provider (Default):** For the legacy provider, set the `DBFIPS_140=true` initialization parameter. This enables FIPS 140-2 mode for TDE and `DBMS_CRYPTO`.
The effect of this parameter depends on the platform.
**Linux or Windows on Intel x86_64:**
  ````- TRUE: TDE and DBMS_CRYPTO program units use Micro Edition Suite (MES) 5.0.3 FIPS mode, which uses RSA BSAFE Crypto-C Micro Edition (CCME) 4.1.5.
  ````- FALSE: TDE and DBMS_CRYPTO program units use Intel Performance Primitives (IPP).
**Solaris 11.1+ on either SPARC T-series or Intel x86_64:**
  ````- TRUE: TDE and DBMS_CRYPTO program units use Micro Edition Suite (MES) 5.0.3 FIPS mode, which uses RSA BSAFE Crypto-C Micro Edition (CCME) 4.1.5.
  ````- FALSE: TDE and DBMS_CRYPTO program units use Solaris Cryptographic Framework (SCF)/UCrypto, which is separately validated for FIPS 140.
**Other operating systems or hardware:**
  ````- TRUE: TDE and DBMS_CRYPTO program units use MES 5.0.3 FIPS mode, which uses RSA BSAFE Crypto-C Micro Edition (CCME) 4.1.5.
  ````- FALSE: TDE and DBMS_CRYPTO program units use MES 5.0.3 non-FIPS mode.
Be aware that setting `DBFIPS_140` to `TRUE` and thus using the underlying library in FIPS mode incurs a certain amount of overhead when the library is first loaded for each process. This is due to the verification of the signature and the execution of the self tests on the library. Once the library is loaded, then there is no other impact on performance.
**Configuring FIPS with the Next-Generation provider:** To enable FIPS 140-2 with the next-generation cryptographic provider, set the following parameter in the `fips.ora` file:
```
FIPS_140 = TRUE
```
To enable FIPS 140-3, also set:
```
FIPS_140_3 = TRUE
```
The `DBFIPS_140` initialization parameter is no longer required with the next-generation provider. If both legacy FIPS parameters and next-generation FIPS parameters are present, the next-generation `FIPS_140` setting takes precedence.
Restart the database instance after changing FIPS configuration.
## Configuration of FIPS 140-2 and FIPS 140-3 for Transport Layer Security
The FIPS configuration parameters configure FIPS mode for Transport Layer Security (TLS).
- Configuring FIPS Parameters for Transport Layer Security Configure FIPS mode for TLS according to the active cryptographic provider.
- Approved TLS Cipher Suites for FIPS 140-2 A cipher suite is a set of authentication, encryption, and data integrity algorithms that exchange messages between network nodes.
### Configuring FIPS Parameters for Transport Layer Security
To enable FIPS mode for TLS in Oracle Database 19c, follow the configuration steps appropriate for the active cryptographic provider.
**Configuring FIPS with the Legacy provider (Default):** **
- Ensure that the fips.ora file is located in the $ORACLE_HOME/ldap/admin directory.
````
```
SSLFIPS_140=TRUE
```
- In the fips.ora file, set the SSLFIPS_140 parameter. This parameter is FALSE by default.
```
SSLFIPS_LIB=$ORACLE_HOME/lib
```
- If you are using Oracle Instant Client, then set SSLFIPS_LIB to the location of the FIPS library. For example:
- Repeat this procedure in any Oracle Database home for any database server or client.
When you set `SSLFIPS_140` to `TRUE`, Transport Layer Security cryptographic operations take place in the embedded RSA/Micro Edition Suite (MES) library in FIPS mode. These cryptographic operations are accelerated by the CPU when hardware acceleration is available and properly configured in the host hardware and software.
If you set `SSLFIPS_140` to `FALSE`, then Transport Layer Security cryptographic operations take place in the embedded RSA/Micro Edition Suite (MES) library in *non*-FIPS mode, and as with the `TRUE` setting, the operations are accelerated if possible.
**Configuring FIPS with the Next-Generation provider:**
To enable FIPS 140-2 with the next-generation cryptographic provider, set the following parameter in the `fips.ora` file:
```
FIPS_140 = TRUE
```
To enable FIPS 140-3, also set:
```
FIPS_140_3 = TRUE
```
The `SSLFIPS_140` parameter is deprecated when the next-generation provider is active. Use `FIPS_140` instead. If both `SSLFIPS_140` and `FIPS_140` are present, `FIPS_140` takes precedence.
Restart the database instance and Oracle Net listener after changing FIPS configuration.
**Note:** The `SSLFIPS_140` parameter replaces the `SQLNET.SSLFIPS_140` parameter used in Oracle Database 10g release 2 (10.2). For the legacy provider, you must set the parameter in the `fips.ora` file, and not the `sqlnet.ora` file.
### Approved TLS Cipher Suites for FIPS 140-2
A cipher suite is a set of authentication, encryption, and data integrity algorithms that exchange messages between network nodes.
During a TLS handshake, for example, the two nodes negotiate to see as to which cipher suite they will use when transmitting messages back and forth.
**Configuring Specific Cipher Suites**
Oracle Database TLS cipher suites are automatically set to FIPS approved cipher suites. If you want to configure specific cipher suites, then you can do so by setting the `TLS_CIPHER_SUITES` parameter in the `sqlnet.ora` or the `listener.ora` file.
```
TLS_CIPHER_SUITES=(TLS_cipher_suite1[,TLS_cipher_suite2[,..]])
```
You can also use Oracle Net Manager to set this parameter on the server and the client.
If a specific cipher suite is not specified, then Oracle Database will use the strongest cipher suite common to both the database server and client. The priority order of cipher suites to be selected are in order as they are listed in the preferred and less preferred cipher lists below. Oracle Database will not select 3DES cipher suites automatically due to their weakness; they must be configured explicitly.
**Preferred Cipher Suites**
The following cipher suites are approved for FIPS validation if you are using Transport Layer Security (TLS) version
1.2:
- TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
- TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384
- TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
- TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256
- TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
- TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
- TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
- TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
The following cipher suites are approved for FIPS validation if you are using Transport Layer Security (TLS) version 1, 1.1, or 1.2:
- TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
- TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
- TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
- TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
**3DES-Based Cipher Suites**
Oracle does not recommend 3DES-based cipher suites because of a weakness in their design. Oracle Database release 21c and later contains support for the following 3DES-based cipher suites. However, they are not enabled by default and must be explicitly configured through the `TLS_CIPHER_SUITES` parameter in the `sqlnet.ora` or the `listener.ora` file.
- TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA
- TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA
- TLS_RSA_WITH_3DES_EDE_CBC_SHA
## Configuration of FIPS 140-2 and FIPS 140-3 for Native Network Encryption
You can configure FIPS for native network encryption by setting parameters for the active cryptographic provider.
- About Configuration of FIPS Mode for Native Network Encryption The configuration of FIPS mode for native network encryption depends on the active cryptographic provider.
- Configuring FIPS Parameters for Native Network Encryption Configure FIPS mode for native network encryption according to the active cryptographic provider.
### About Configuration of FIPS Mode for Native Network Encryption
The configuration of FIPS mode for native network encryption depends on the active cryptographic provider.
With the legacy cryptographic provider, you enable FIPS 140-2 mode for native network encryption by setting `SQLNET.FIPS_140=TRUE` in the `sqlnet.ora` configuration file.
With the next-generation cryptographic provider, you enable FIPS 140-2 mode by setting `FIPS_140=TRUE` in the `fips.ora` file. To enable FIPS 140-3 mode, also set `FIPS_140_3=TRUE`.
The algorithms that FIPS mode supports for native network encryption are as follows:
- Legacy provider in FIPS 140-2 mode: AES128, AES192, and AES256 for encryption; SHA1, SHA256, SHA384, and SHA512 for checksumming.
- Next-generation provider in FIPS 140-3 mode: AES128, AES192, and AES256 for encryption; SHA256, SHA384, and SHA512 for integrity.
### Configuring FIPS Parameters for Native Network Encryption
To enable FIPS mode for native network encryption in Oracle Database 19c, follow the configuration steps appropriate for the active cryptographic provider.
**Configuring FIPS with the Legacy provider (Default):**
- Locate the sqlnet.ora file that is used by the database client or database server.
```
SQLNET.FIPS_140=TRUE
```
- Add the following line to the sqlnet.ora file:
- Repeat this procedure in any Oracle Database home for any database server or client.
When `FIPS_140` is set to `TRUE`, native network encryption cryptographic operations take place in the embedded BSAFE Micro Edition Suite (MES) library in FIPS mode. These cryptographic operations are accelerated by the CPU when hardware acceleration is available and properly configured in the host hardware and software.
**Configuring FIPS with the Next-Generation provider:**
To enable FIPS 140-2 with the next-generation cryptographic provider, set the following parameter in the `fips.ora` file:
```
FIPS_140 = TRUE
```
To enable FIPS 140-3, also set:
```
FIPS_140_3 = TRUE
```
The `SQLNET.FIPS_140` parameter in `sqlnet.ora` is no longer required with the next-generation provider. Restart the database instance and Oracle Net listener after changing FIPS configuration.
## Post-Installation Checks for FIPS 140-2
After you configure the FIPS 140-2 settings, you must verify permissions in the operating system.
The permissions are as follows:
- Set execute permissions on all Oracle executable files to prevent the execution of Oracle Cryptographic Libraries by users who are unauthorized to do so, in accordance with the system security policy.
- Set read and write permissions on all Oracle executable files to prevent accidental or deliberate reading or modification of Oracle Cryptographic Libraries by any user.
To comply with FIPS 140-2 Level 2 requirements, in the security policy, include procedures to prevent unauthorized users from reading, modifying or executing Oracle Cryptographic Libraries processes and the memory they are using in the operating system.
## Verifying FIPS 140-2 Connections
You can use trace files and other methods to verify the FIPS 140-2 connections.
- Verifying FIPS 140-2 Connections for Transport Layer Security You can use trace files to check the FIPS 140-2 connections for Transport Layer Security (TLS).
- Verifying FIPS 140-2 Connections for Network Native Encryption You can use trace files to check the FIPS 140-2 connections for network native encryption.
- Verifying FIPS 140-2 Connections for Transparent Data Encryption and DBMS_CRYPTO You can check if FIPS mode is enabled by using SQL*Plus.
### Verifying FIPS 140-2 Connections for Transport Layer Security
You can use trace files to check the FIPS 140-2 connections for Transport Layer Security (TLS).
```
trace_directory_server=trace_directory trace_file_server=trace_file trace_level_server=trace_level
```
```
trace_directory=/private/oracle/owm trace_file_server=fips_trace.trc trace_level_server=16
```
- Add the following lines to sqlnet.ora to enable tracing: For example: Trace level 16 is the minimum trace level required to check the results of the FIPS self-tests.
- Check the trace files by searching for Provider Type: FIPS140.
### Verifying FIPS 140-2 Connections for Network Native Encryption
You can use trace files to check the FIPS 140-2 connections for network native encryption.
  - Add the following lines to sqlnet.ora to enable tracing:
```
trace_directory_server=trace_directory trace_file_server=trace_file trace_level_server=trace_level
```
```
For example:
```
```
trace_directory=/private/oracle/owm trace_file_server=fips_trace.trc trace_level_server=16
```
```
Trace level 16 is the minimum trace level required to check the results of the FIPS self-tests.
```
  - Check the trace files by searching for FIPS DAC check succeeded.
### Verifying FIPS 140-2 Connections for Transparent Data Encryption and DBMS_CRYPTO
You can check if FIPS mode is enabled by using SQL*Plus.
- Connect to the database instance by using SQL*Plus.
- Execute the following SHOW PARAMETER command:
```
SHOW PARAMETER DBFIPS_140
```
```
Output similar to the following should appear:
```
```
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
DBFIPS_140                           boolean     TRUE
```
## Ensuring Encryption Algorithms are FIPS 140-3 Compliant
FIPS 140-3 desupports 3DES (Triple Data Encryption Standard) encryption algorithms. 3DES encryption is outdated, slow, and no longer considered secure in the modern threat environment. In line with current security best practices, Oracle recommends transitioning to the Advanced Encryption Standard (AES). AES offers improved security, performance, and resistance to known attacks. Review your encryption configurations, including transparent data encryption and network encryption, to ensure that you do not use 3DES. If you have not done so already, convert Oracle Wallets created prior to Oracle Database 19.22 to use AES. If you find any use of 3DES, then transition to a more secure cipher such as AES.
In preparation for this move, you should complete the following checks.
```
select ENCRYPTIONALG from gv$encrypted_tablespaces where ENCRYPTIONALG like '3DES%';
```
**
- Validate that encrypted tablespaces do not use 3DES by running the following: If any tablespaces are found that use 3DES, you should follow Rekeying an Existing Tablespace with Online Conversion in the Oracle Database Advanced Security Guide to rekey your encrypted tablespace with AES256.
```
select encryption_alg from dba_encrypted_columns where ENCRYPTION_ALG like '%DES%';
```
**
- Validate that encrypted columns do not use 3DES by running the following: If any encrypted columns are found that use 3DES, you should follow Changing the Encryption Key or Algorithm for Tables with Encrypted Columns in the Oracle Database Advanced Security Guide to rekey your encrypted columns with AES256.
```
openssl pkcs12 -info -in ./ewallet.p12 -password pass:"" -nodes |grep "PKCS7"
```
```
PKCS7 Encrypted data: PBES2, PBKDF2, AES-256-CBC, Iteration 10000, PRF hmacWithSHA256
```
****
- Validate that your Oracle Wallets use AES256 instead of 3DES by running the following: This should bring back results with a line that looks something like this: If that line does not show AES-256-CBC, then you should follow the procedure at Converting an Oracle Wallet to Use the AES256 Algorithm to convert your wallet to AES256. Note: Wallets created prior to Oracle Database 19.22 (January 2024) are likely to have used 3DES unless explicitly created using AES256.
## FIPS 140-3 Algorithm Restrictions
When FIPS 140-3 mode is active (next-generation provider with `FIPS_140=TRUE` and `FIPS_140_3=TRUE`), the following algorithm restrictions apply in addition to the standard next-generation provider restrictions:
FIPS 140-3 desupports 3DES. 3DES encryption is outdated, slow, and no longer considered secure. Oracle recommends transitioning to AES.
**Algorithms Not Available in FIPS 140-3 Mode:**
  - 3DES168 (network native encryption)
  - TLS cipher suites using 3DES key exchange or encryption
  - All algorithms already restricted by the next-generation provider (DES, RC4, RC2, RC5, SEED, GOST)
**Algorithms Supported in FIPS 140-3 Mode:**
  - AES (128, 192, 256) for encryption
  - SHA-256, SHA-384, SHA-512 for integrity
  - RSA (2048-bit minimum; NIST recommends 3072-bit minimum after 2030) for key exchange and signing
  ``````- ECC with approved curves: secp521r1, secp384r1, and secp256r1
  - ECDSA and ECDH with approved curves
  - ML-KEM and ML-DSA (post-quantum algorithms)
**Minimum Key Strengths in FIPS Mode:**
  - RSA, DH, and DSA: 2048-bit minimum
  - ECC: 224-bit minimum
  - Minimum security strength: 112 bits
**Note:** In non-FIPS mode, the default minimum security strength is 80 bits.
**Note:** PQC algorithms (ML-KEM, ML-DSA) are supported in FIPS 140-3 mode and non-FIPS mode, but are not available in FIPS 140-2 mode.
## Migrating from FIPS 140-2 to FIPS 140-3
To migrate from FIPS 140-2 (legacy provider) to FIPS 140-3 (next-generation provider), perform the following steps:
  - Identify all TLS connections using TLS 1.0 or TLS 1.1. These must be upgraded to TLS 1.2 or later before migration.
  - Identify all configurations, like TDE, DBMS_CRYPTO, and Oracle Wallet, using 3DES. FIPS 140-3 desupports 3DES. 3DES encryption is outdated, slow, and no longer considered secure. Oracle recommends transitioning to AES.
  - Identify all certificates signed with SHA-1 or MD5. These must be replaced with certificates using SHA-256 or stronger. Check certificate details with orapki wallet display -wallet wallet_dir -complete -details.
  - Identify all configurations using DES (deprecated), RC2, RC4 (deprecated), RC5, SEED (desupported), GOST (desupported), or ARIA (only supported in non-FIPS mode). These algorithms are not available when moving to FIPS 140-3.
      ````  - Check wallet encryption. Wallets created before Oracle Database 19.22 may use 3DES. Check with openssl pkcs12 -info -in ./ewallet.p12 -nodes. Convert with orapki wallet convert -wallet wallet_location -compat_v12.
        - Verify RSA key lengths meet FIPS minimums (2048-bit minimum; NIST recommends 3072-bit after 2030). Verify ECC key lengths (224-bit minimum).
  - Update TLS version configurations to use TLS 1.2 or TLS 1.3.
```
SQLNET.ENCRYPTION_TYPES_SERVER = (AES256)
```
  - Replace 3DES with AES in all encryption configurations. If SQLNET.ENCRYPTION_TYPES_SERVER is not set, no changes are needed. If the parameter is set, remove deprecated algorithms and use:
        - Re-issue certificates using SHA-256 or stronger signing algorithms.
        - Replace legacy encryption algorithms with AES equivalents.
        - Convert any 3DES-encrypted wallets to AES-256.
```
SQLNET.CRYPTO_CHECKSUM_TYPES_SERVER = (SHA512)
```
  - If you use explicit NNE checksum configuration, update the checksum to SHA512:
````  - SSLFIPS_140=true from fips.ora
      ````  - SQLNET.FIPS_140=TRUE from sqlnet.ora
        - DBFIPS_140=true initialization parameter
Add the following next-generation provider FIPS settings in `fips.ora`:
```
FIPS_140 = TRUE FIPS_140_3 = TRUE
```
```
$ python $ORACLE_HOME/bin/set_crypto_provider.py next-generation
```
- Switch the cryptographic provider:
- Restart the database instance and Oracle Net listener.
- Verify FIPS 140-3 mode is active by checking the database alert log.
- Test all TLS connections, encryption operations, and certificate-based authentication.
**Note:** This migration cannot be performed incrementally. You must resolve all incompatibilities before switching the cryptographic provider, as the switch is an all-or-nothing operation for the entire database instance.
### Rollback Procedure:
If issues arise after switching to the next-generation provider, you can revert to the legacy provider:
```
python $ORACLE_HOME/bin/set_crypto_provider.py legacy
```
- Switch back:
``````
- Restore the legacy provider FIPS settings: SSLFIPS_140, SQLNET.FIPS_140, and DBFIPS_140.
- Restart the database instance and Oracle Net listener.
**Note:** PQC certificates (ML-DSA) created while the next-generation provider was active will not function with the legacy provider.
## Related Topics
  - Ensuring Encryption Algorithms are FIPS 140-3 Compliant
  - FIPS 140-3 Algorithm Restrictions
  - Switching the Cryptographic Provider for Oracle Database 19c
**- Oracle Database Reference
