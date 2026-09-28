# Uses of the orapki Utility

The `orapki` utility manages public key infrastructure (PKI) elements, such as wallets and certificate revocation lists, from the command line.
This way, you can automate these tasks by using scripts. Providing a way to incorporate the management of PKI elements into scripts makes it possible to automate many of the routine tasks of maintaining a PKI.
You can use the `orapki` command-line utility to perform the following tasks:
- Creating and viewing signed certificates for testing purposes
  - Create and display Oracle wallets
  - Add and remove certificate requests
  - Add and remove certificates
  - Add and remove trusted certificates
  - Renaming CRLs with a hash value for certificate validation
******
  - Uploading, listing, viewing, and deleting CRLs in Oracle Internet Directory Note: The use of PKI encryption with Transparent Data Encryption is deprecated. To configure Transparent Data Encryption, use the ADMINISTER KEY MANAGEMENT SQL statement. See Oracle Database Advanced Security Guide for more information.
