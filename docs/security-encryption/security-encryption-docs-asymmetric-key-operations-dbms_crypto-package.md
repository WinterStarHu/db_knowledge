# Asymmetric Key Operations with the DBMS_CRYPTO Package

The `DBMS_CRYPTO` package provides four functions that enable you to perform asymmetric key operations for encryption, decryption, signing, and verification.
Asymmetric key operations (also called public key cryptography) use a public key and private key to encrypt and decrypt a message in order to protect it from unauthorized access.
The asymmetric key operation functions are as follows:
````
- PKDECRYPT decrypts RAW data using a private key assisted with key algorithm and encryption algorithm.
````
- PKENCRYPT encrypts RAW data using a public key assisted with key algorithm and encryption algorithm.
````
- SIGN signs RAW data using a private key assisted with key algorithm and sign algorithm
````
- VERIFY verifies RAW data using signature, public key assisted with key algorithm and sign algorithm.
## Related Topics
**- Oracle Database PL/SQL Packages and Types Reference
