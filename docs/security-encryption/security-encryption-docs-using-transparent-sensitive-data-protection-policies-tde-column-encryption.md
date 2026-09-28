# Using Transparent Sensitive Data Protection Policies with TDE Column Encryption

The TSDP procedures and Transparent Data Encryption column encryption statements can combine the protections of these two features.
- About Using TSDP Policies with TDE Column Encryption A TSDP policy can enable the encryption of columns that use Transparent Data Encryption.
````````````
- TDE Column Encryption ENCRYPT Clause Settings Used with TSDP Policies The CREATE TABLE and ALTER TABLE statement ENCRYPT clause settings can be used in the POLICY_ENABLE_OPTIONS parameter for the DBMS_TSDP_PROTECT.ADD_POLICY or DBMS_TSDP_PROTECT.ALTER_POLICY procedure.
## About Using TSDP Policies with TDE Column Encryption
A TSDP policy can enable the encryption of columns that use Transparent Data Encryption.
The `DBMS_TSDP_PROTECT.ADD_POLICY` and `DBMS_TSDP_PROTECT.ALTER_POLICY` procedures enable you to specify the `ENCRYPT` clause settings from the `CREATE TABLE` or `ALTER TABLE` statement.
This feature works as follows:
````````
- You can create a TSDP policy by using the DBMS_TSDP_PROTECT.ADD_POLICY procedure. In the ADD_POLICY procedure, you can configure the policy for column encryption by setting the SECURITY_FEATURE parameter to DBMS_TSDP_PROTECT.COLUMN_ENCRYPTION. This setting enables encryption on the sensitive column when the TSDP policy is enabled on the object.
````
- You create a TSDP policy with the necessary table encryption settings. The TSDP policy uses parameter settings from the CREATE TABLE or ALTER TABLE SQL statement.TDE Column Encryption ENCRYPT Clause Settings Used with TSDP Policies lists these settings.
- You associate the TSDP policy with the necessary sensitive types by using the DBMS_TSDP_PROTECT.ASSOCIATE_POLICY procedure.
- You then enable TSDP protection by using any of the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_* procedures.
````````
- You enable the TSDP policy. At this point, Oracle Database creates an internal TSDP policy that uses the encrypted table settings that you created earlier in this procedure. The name of the internal policy begins with ORA$TDECE_ followed by a random alpha-numeric string (for example, ORA#TDECE_6J6L3RSJSN2VAN0XF). You can find this policy by querying the TSDP_POLICY column of DBA_TSDP_POLICY_PROTECTION view.
````
- When users try to perform an action on the table that is being protected by the policies, the output for the column is based on both the TDE column protections and the TSDP policy that are now in place. You can check if the column has been encrypted after you enabled the TSDP policy by querying the ENCRYPTION_ALG column of the DBA_ENCRYPTED_COLUMNS view.
``````
- These protections remain in place until you disable the TSDP policy for this column. At that point, Oracle Database internally issues an ALTER TABLE statement on the table that contains the sensitive column, so that the sensitive column is decrypted. If you reenable the TSDP policy, then TSDP internally executes the ALTER TABLE statement with the ENCRYPT clause for the column.
**Note:**   It is possible to create two policies on the same column with each policy specifying a different encryption algorithm. In this case, the stronger of the two algorithms is enforced on the sensitive column.
## TDE Column Encryption ENCRYPT Clause Settings Used with TSDP Policies
The `CREATE TABLE` and `ALTER TABLE` statement `ENCRYPT` clause settings can be used in the `POLICY_ENABLE_OPTIONS` parameter for the `DBMS_TSDP_PROTECT.ADD_POLICY` or `DBMS_TSDP_PROTECT.ALTER_POLICY` procedure.
The following table describes these settings.

| Parameter | Description | Default |
|---|---|---|
| encrypt_algorithm | Available values: 3DES168, AES128, AES192, AES256, ARIA128, ARIA192, ARIA256, SEED128, and GOST256. | AES192 |
| salt | Available values: SALT and NO SALT. | SALT |
| integrity_algorithm | Available values: SHA-1 and NOMAC. | SHA-1 |
