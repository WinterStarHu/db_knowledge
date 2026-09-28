# Controlling MD5 and SHA-1 Certificate Use

You can use the `sqlnet.ora` file to control whether MD5 and SHA-1 signed certificates are accepted.
To control whether the MD5 and SHA-1 signed certificates are accepted, you can edit the `sqlnet.ora` file to enable or disable their use.
**Note:**   MD5 is deprecated in this release. To transition your Oracle Database environment to use stronger algorithms, download and install the patch described in My Oracle Support note 2118136.2.
- Log in to the server where the Oracle database resides.
``````
- Edit the sqlnet.ora file. By default, the sqlnet.ora file is located in the $ORACLE_HOME/dbs directory or in the location set by the TNS_ADMIN environment variable.
``````
  - ACCEPT_MD5_CERTS controls the use of MD5 certificates. The default is FALSE. This parameter replaces the ORACLE_SSL_ALLOW_MD5_CERT_SIGNATURES environment variable.
````
  - ACCEPT_SHA1_CERTS controls the use of SHA-1 certificates. The default is TRUE. .
