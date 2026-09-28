# Securing LOBs with LOB Locator Signatures

You can secure large objects (LOB) by regenerating their LOB locator signatures.
- About Securing LOBs with LOB Locator Signatures A LOB locator, which is a pointer to the actual location of a large object (LOB) value, can be assigned a signature, which can be used to secure the LOB.
- Managing the Encryption of a LOB Locator Signature Key You can use the ALTER DATABASE DICTIONARY SQL statement to encrypt a LOB locator signature key.
## About Securing LOBs with LOB Locator Signatures
A LOB locator, which is a pointer to the actual location of a large object (LOB) value, can be assigned a signature, which can be used to secure the LOB.
When you create a LOB, Oracle Database automatically assigns a signature to the LOB locator. Oracle Database verifies the signature matches when it receives a locator from a client to ensure that the locator has not been tampered with. Signature-based security can be used for both persistent and temporary LOB locators. It is also used for distributed CLOBs, BLOBs, and NBLOBs that come from index organized table (IOT) locators.
In an Oracle Real Applications Clusters (Oracle RAC) environment, all instances will share the same signature key, which is persisted in the database. In a multitenant environment, each pluggable database (PDB) will have its own signature key. If a LOB locator has been tampered with, the signature verification rejects the LOB and raises an `ORA-64219: invalid LOB locator encountered` error.
You can encrypt, rekey, and delete the LOB signature key that was used to generate LOB signature for LOB locators that are sent from a standalone database or PDB to a client. If you plan to encrypt the signature key, then the database (or PDB) in which the key resides must have an open TDE keystore.
To enable the LOB signature feature, you must set the `LOB_SIGNATURE_ENABLE` initialization parameter to `TRUE`. By default, `LOB_SIGNATURE_ENABLE` is set to `FALSE` for Oracle Database release 19c.
## Managing the Encryption of a LOB Locator Signature Key
You can use the `ALTER DATABASE DICTIONARY` SQL statement to encrypt a LOB locator signature key.
- Log in to the database as a user who has ALTER DATABASE DICTIONARY privileges.
````
- If necessary, enable the LOB signature key feature by setting the LOB_SIGNATURE_ENABLE initialization parameter to TRUE.
```
ALTER SYSTEM SET LOB_SIGNATURE_ENABLE = TRUE;
```
```
Alternatively, you can set the `LOB_SIGNATURE_ENABLE` parameter in the `init.ora` initialization file before a database restart. This enables the LOB signature key feature for all PDBs.
```
- If you plan to encrypt the signature key, then ensure that the database or PDB has an open TDE keystore. You must have the SYSKM administrative privilege to create a TDE keystore. For example, to create and open a software TDE keystore:
```
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/etc/ORACLE/WALLETS/orcl' IDENTIFIED BY password;
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY password;
```
  - To encrypt the LOB locator signature key instead of obfuscating it, execute the following statement:
```
ALTER DATABASE DICTIONARY ENCRYPT CREDENTIALS;
```
```
- To regenerate the LOB locator signature key for LOB locators that will be sent to a client, use the following statement. If the database is in restricted mode, then Oracle Database regenerates a new LOB signature key to encrypt the regenerated signature key. If the database is in non-restricted mode, then a new signature key is not regenerated but instead, Oracle Database uses a new encryption key to encrypt the existing LOB signature key. Oracle recommends that a database administrator or PDB administrator run this statement in restricted mode on a periodic basis, preferably during database down time.
```
```
ALTER DATABASE DICTIONARY REKEY CREDENTIALS;
```
```
- To delete the encrypted LOB locator signature key and then regenerate a new LOB signature key in obfuscated form instead of encrypted form, execute the following statement:
```
```
ALTER DATABASE DICTIONARY DELETE CREDENTIALS;
```
## Related Topics
  - Configuring Transparent Data Encryption
