# Data Encryption Challenges

In cases where encryption can provide additional security, there are some associated technical challenges.
- Encrypted Indexed Data Special difficulties arise when encrypted data is indexed.
- Generated Encryption Keys Encrypted data is only as secure as the key used for encrypting it.
- Transmitted Encryption Keys If the encryption key is to be passed by the application to the database, then you must encrypt it.
- Storing Encryption Keys You can store encryption keys in the database or on an operating system.
- Importance of Changing Encryption Keys Prudent security practice dictates that you periodically change encryption keys.
- Encryption of Binary Large Objects Certain data types require more work to encrypt.
## Encrypted Indexed Data
Special difficulties arise when encrypted data is indexed.
For example, suppose a company uses a national identity number, such as the U.S. Social Security number (SSN), as the employee number for its employees. The company considers employee numbers to be sensitive data, and, therefore, wants to encrypt data in the `employee_number` column of the `employees` table. Because `employee_number` contains unique values, the database designers want to have an index on it for better performance.
However, if `DBMS_CRYPTO` (or another mechanism) is used to encrypt data in a column, then an index on that column will also contain encrypted values. Although an index can be used for equality checking (for example, `SELECT * FROM emp WHERE employee_number = '987654321'`), if the index on that column contains encrypted values, then the index is essentially unusable for any other purpose. You should not encrypt indexed data.
Oracle recommends that you do not use national identity numbers as unique IDs. Instead, use the `CREATE SEQUENCE` statement to generate unique identity numbers. Reasons to avoid using national identity numbers are as follows:
- There are privacy issues associated with overuse of national identity numbers (for example, identity theft).
- Sometimes national identity numbers can have duplicates, as with U.S. Social Security numbers.
## Generated Encryption Keys
Encrypted data is only as secure as the key used for encrypting it.
An encryption key must be securely generated using secure cryptographic key generation. Oracle Database provides support for secure random number generation, with the `RANDOMBYTES` function of `DBMS_CRYPTO`. (This function replaces the capabilities provided by the `GetKey` procedure of the earlier `DBMS_OBFUSCATION_TOOLKIT`, which has been deprecated.) `DBMS_CRYPTO` calls the secure random number generator (RNG) previously certified by RSA Security.
**Note:**   Do not use the `DBMS_RANDOM` package. The `DBMS_RANDOM` package generates pseudo-random numbers, which, as Randomness Recommendations for Security (RFC-1750) states that using pseudo-random processes to generate secret quantities can result in pseudo-security.
Be sure to provide the correct number of bytes when you encrypt a key value. For example, you must provide a 16-byte key for the `ENCRYPT_AES128` encryption algorithm.
## Transmitted Encryption Keys
If the encryption key is to be passed by the application to the database, then you must encrypt it.
Otherwise, an intruder could get access to the key as it is being transmitted. Network data encryption protects all data in transit from modification or interception, including cryptographic keys.
## Storing Encryption Keys
You can store encryption keys in the database or on an operating system.
- About Storing Encryption Keys Storing encryption keys is one of the most important, yet difficult, aspects of encryption.
- Storage of Encryption Keys in the Database Storing encryption keys in the database does not always prevent a database administrator from accessing encrypted data.
- Storage of Encryption Keys in the Operating System When you store encryption keys in an operating system flat file, you can make callouts from PL/SQL to retrieve these encryption keys.
- Users Managing Their Own Encryption Keys Having the user supply the key assumes the user will be responsible with the key.
- Manual Encryption with Transparent Database Encryption and Tablespace Encryption Transparent database encryption and tablespace encryption provide secure encryption with automatic key management for the encrypted tables and tablespaces.
### About Storing Encryption Keys
Storing encryption keys is one of the most important, yet difficult, aspects of encryption.
To recover data encrypted with a symmetric key, the key must be accessible to an authorized application or user seeking to decrypt the data. At the same time, the key must be inaccessible to someone who is maliciously trying to access encrypted data that he is not supposed to see.
### Storage of Encryption Keys in the Database
Storing encryption keys in the database does not always prevent a database administrator from accessing encrypted data.
An all-privileged database administrator could still access tables containing encryption keys. However, it can often provide good security against the casual curious user or against someone compromising the database file on the operating system.
As a trivial example, suppose you create a table (`EMP`) that contains employee data. You want to encrypt the employee Social Security number (SSN) stored in one of the columns. You could encrypt employee SSN using a key that is stored in a separate column. However, anyone with `SELECT` access on the entire table could retrieve the encryption key and decrypt the matching SSN.
While this encryption scheme seems easily defeated, with a little more effort you can create a solution that is much harder to break. For example, you could encrypt the SSN using a technique that performs some additional data transformation on the `employee_number` before using it to encrypt the SSN. This technique might be as simple as using an `XOR` operation on the `employee_number` and the birth date of the employee to determine the validity of the values.
As additional protection, PL/SQL source code performing encryption can be wrapped, (using the `WRAP` utility) which obfuscates (scrambles) the code. The `WRAP` utility processes an input SQL file and obfuscates the PL/SQL units in it. For example, the following command uses the `keymanage.sql` file as the input:
```
wrap iname=/mydir/keymanage.sql
```
A developer can subsequently have a function in the package call the `DBMS_CRYPTO` package calls with the key contained in the wrapped package.
Oracle Database enables you to obfuscate dynamically generated PL/SQL code. The `DBMS_DDL` package contains two subprograms that allow you to obfuscate dynamically generated PL/SQL program units. For example, the following block uses the `DBMS_DDL.CREATE_WRAPPED` procedure to wrap dynamically generated PL/SQL code.
```
BEGIN
......
SYS.DBMS_DDL.CREATE_WRAPPED(function_returning_PLSQL_code());
......
END;
```
While wrapping is not unbreakable, it makes it harder for an intruder to get access to the encryption key. Even in cases where a different key is supplied for each encrypted data value, you should not embed the key value within a package. Instead, wrap the package that performs the key management (that is, data transformation or padding).
An alternative to wrapping the data is to have a separate table in which to store the encryption key and to envelope the call to the keys table with a procedure. The key table can be joined to the data table using a primary key to foreign key relationship. For example, `employee_number` is the primary key in the `employees` table that stores employee information and the encrypted SSN. The `employee_number` column is a foreign key to the `ssn_keys` table that stores the encryption keys for the employee SSN. The key stored in the `ssn_keys` table can also be transformed before use (by using an `XOR` operation), so the key itself is not stored unencrypted. If you wrap the procedure, then that can hide the way in which the keys are transformed before use.
The strengths of this approach are:
- Users who have direct table access cannot see the sensitive data unencrypted, nor can they retrieve the keys to decrypt the data.
- Access to decrypted data can be controlled through a procedure that selects the encrypted data, retrieves the decryption key from the key table, and transforms it before it can be used to decrypt the data.
- The data transformation algorithm is hidden from casual snooping by wrapping the procedure, which obfuscates the procedure code.
- SELECT access to both the data table and the keys table does not guarantee that the user with this access can decrypt the data, because the key is transformed before use.
The weakness to this approach is that a user who has `SELECT` access to both the key table and the data table, and who can derive the key transformation algorithm, can break the encryption scheme.
The preceding approach is not infallible, but it is adequate to protect against easy retrieval of sensitive information stored in clear text.
### Storage of Encryption Keys in the Operating System
When you store encryption keys in an operating system flat file, you can make callouts from PL/SQL to retrieve these encryption keys.
However, if you store keys in the operating system and make callouts to it, then your data is only as secure as the protection on the operating system.
If your primary security concern is that the database can be broken into from the operating system, then storing the keys in the operating system makes it easier for an intruder to retrieve encrypted data than storing the keys in the database itself.
### Users Managing Their Own Encryption Keys
Having the user supply the key assumes the user will be responsible with the key.
Considering that 40 percent of help desk calls are from users who have forgotten their passwords, you can see the risks of having users manage encryption keys. In all likelihood, users will either forget an encryption key, or write the key down, which then creates a security weakness. If a user forgets an encryption key or leaves the company, then your data is not recoverable.
If you do decide to have user-supplied or user-managed keys, then you need to ensure you are using native network encryption so that the key is not passed from the client to the server in the clear. You also must develop key archive mechanisms, which is also a difficult security problem. Key archives and backdoors create the security weaknesses that encryption is attempting to solve.
### Manual Encryption with Transparent Database Encryption and Tablespace Encryption
Transparent database encryption and tablespace encryption provide secure encryption with automatic key management for the encrypted tables and tablespaces.
If the application requires protection of sensitive column data stored on the media, then these two types of encryption are a simple and fast way of achieving this.
## Importance of Changing Encryption Keys
Prudent security practice dictates that you periodically change encryption keys.
For stored data, this requires periodically unencrypting the data, and then reencrypting it with another well-chosen key.
You would most likely change the encryption key while the data is not being accessed, which creates another challenge. This is especially true for a Web-based application encrypting credit card numbers, because you do not want to shut down the entire application while you switch encryption keys.
## Encryption of Binary Large Objects
Certain data types require more work to encrypt.
For example, Oracle Database supports storage of binary large objects (BLOBs), which stores very large objects (for example, multiple gigabytes) in the database. A BLOB can be either stored internally as a column, or stored in an external file.
## Related Topics
  - Configuring Oracle Database Native Network Encryption and Data Integrity
**````- Oracle Database PL/SQL Packages and Types Reference for additional information about the WRAP command line utility and the DBMS_DDL subprograms for dynamic wrapping **- Oracle Database Advanced Security Guide for more information about Transparent Data Encryption
  - Example: Encryption and Decryption Procedures for BLOB Data
