# Data Encryption Storage with the DBMS_CRYPTO Package

The `DBMS_CRYPTO` package provides several ways to address security issues.
While encryption is not the ideal solution for addressing several security threats, it is clear that selectively encrypting sensitive data before storage in the database does improve security. Examples of such data could include credit card numbers and national identity numbers.
Oracle Database provides the PL/SQL package `DBMS_CRYPTO` to encrypt and decrypt stored data. This package supports several industry-standard encryption and hashing algorithms, including the Advanced Encryption Standard (AES) encryption algorithm. AES was approved by the National Institute of Standards and Technology (NIST) to replace the Data Encryption Standard (DES).
The `DBMS_CRYPTO` package enables encryption and decryption for common Oracle Database data types, including `RAW` and large objects (LOBs), such as images and sound. Specifically, it supports BLOBs and CLOBs. In addition, it provides Globalization Support for encrypting data across different database character sets.
The following cryptographic algorithms are supported:
- Advanced Encryption Standard (AES)
  - HASH_SH256
  - HASH_SH384
  - HASH_SH512
- SHA-2 Message Authentication Code (MAC)
Block cipher modifiers are also provided with `DBMS_CRYPTO`. You can choose from several padding options, including Public Key Cryptographic Standard (PKCS) #5, and from four block cipher chaining modes, including Cipher Block Chaining (CBC). Padding must be done in multiples of eight bytes.
**Note:**
- DES is no longer recommended by the National Institute of Standards and Technology (NIST).
  - (MD5 has been deprecated starting in Oracle Database 21c.)
Starting with Oracle Database 21c, older encryption and hashing algorithms are deprecated. Deprecated algorithms include MD4, MD5, DES, 3DES, and RC4-related algorithms. Removing older, less secure cryptography algorithms prevents accidental use of these APIs. To meet your security requirements, Oracle recommends that you use more modern cryptography algorithms such as AES.
Starting with Oracle Database 21c, older encryption and hashing algorithms are deprecated.
As a consequence of this deprecation, Oracle recommends that you review your network encryption configuration to see if you have specified use of any of the deprecated algorithms. If any are found, then switch to using a more modern cipher, such as AES. See Improving Native Network Encryption Security for more information.
- Usage of SHA-2 is more secure than SHA-1.
- Keyed MD5 is not vulnerable.
The following table summarizes the `DBMS_CRYPTO` package features.

| Feature | DBMS_CRYPTO Supported Functionality |
|---|---|
| Block cipher chaining modes | CBC, CFB, ECB, OFB |
| Cryptographic algorithms | AES |
| Cryptographic hash algorithms | SHA-1, SHA-2, HASH_SH256, HASH_SH384, HASH_SH512 |
| Cryptographic pseudo-random number generator | RAW, NUMBER, BINARY_INTEGER |
| Database types | RAW, CLOB, BLOB |
| Keyed hash (MAC) algorithms | HMAC_MD5, HMAC_SH1, HMAC_SH256, HMAC_SH384, HMAC_SH512 |
| Padding forms | PKCS5, zeroes |

The following table shows supported SHA hash functions, many of which can be used with RSA environments.

| Hash Algorithm | Description |
|---|---|
| SIGN_RSA_PKCS1_OAEP_SHA256 | RSA with Public Key Cryptographic Standards, SHA 256 bit hash function and OAEP padding |
| SIGN_SHA1_ECDSA | SHA hash function with Elliptic Curve Digital Signature Algorithm |
| SIGN_SHA1_RSA | SHA hash function with RSA |
| SIGN_SHA1_RSA_X931 | SHA hash function with RSA and X931 padding |
| SIGN_SHA224_ECDSA | SHA 224 bit hash function with Elliptic Curve Digital Signature Algorithm |
| SIGN_SHA224_RSA | SHA 224 bit hash function with RSA |
| SIGN_SHA256_ECDSA | SHA 256 bit hash function with Elliptic Curve Digital Signature Algorithm |
| SIGN_SHA256_RSA | SHA 256 bit hash function with RSA |
| SIGN_SHA256_RSA_X931 | SHA 256 bit hash function with RSA and X931 padding |
| SIGN_SHA384_ECDSA | SHA 384 bit hash function with Elliptic Curve Digital Signature Algorithm |
| SIGN_SHA384_RSA | SHA 384 bit hash function with RSA |
| SIGN_SHA384_RSA_X931 | SHA 384 bit hash function with RSA and X931 padding |
| SIGN_SHA512_ECDSA | SHA 512bit hash function with Elliptic Curve Digital Signature Algorithm |
| SIGN_SHA512_RSA | SHA 384 bit hash function with RSA |
| SIGN_SHA512_RSA_X931 | SHA 384 bit hash function with RSA and X931 padding |

The following table shows supported encryption and decryption algorithms.

| Algorithm | Description |
|---|---|
| PKENCRYPT_ECDH | Elliptic Curve Diffie Hellman |
| PKENCRYPT_RSA_PKCS1_OAEP | RSA Public Key Cryptosystem with PKCS1 and OAEP padding |

The following table shows other supported algorithms.

| Algorithm | Description |
|---|---|
| KEY_TYPE_RSA | RSA key type |
| SIGN_ECDSA | Elliptic Curve Digital Signature Algorithm |

`DBMS_CRYPTO` supports a range of algorithms that accommodate both new and existing systems. Although 3DES_2KEY and MD4 are provided for backward compatibility, you achieve better security using 3DES, AES, or SHA-1. Therefore, 3DES_2KEY is not recommended.
The `DBMS_CRYPTO` package includes cryptographic checksum capabilities (MD5), which are useful for comparisons, and the ability to generate a secure random number (the `RANDOMBYTES` function). Secure random number generation is an important part of cryptography; predictable keys are easily guessed keys; and easily guessed keys may lead to easy decryption of data. Most cryptanalysis is done by finding weak keys or poorly stored keys, rather than through brute force analysis (cycling through all possible keys).
**Note:**   Do not use `DBMS_RANDOM`, because it is unsuitable for cryptographic key generation.
Key management is programmatic. That is, the application (or caller of the function) must supply the encryption key. This means that the application developer must find a way of storing and retrieving keys securely. The relative strengths and weaknesses of various key management techniques are discussed in the sections that follow. The DES algorithm itself has an effective key length of 56-bits.
