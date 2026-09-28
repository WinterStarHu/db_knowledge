# Importing a User-Supplied or Trusted Certificate into an Oracle Wallet

You can add a user-supplied or trusted certificate to an Oracle wallet.
  ````- To add a trusted certificate to an Oracle wallet, orapki wallet add with the -trusted_cert parameter.
```
orapki wallet add -wallet wallet_location [-pwd wallet_password] -trusted_cert -cert root_and/or_intermediate_certificate_file
```
  ````- To add a user-created certificate to an Oracle wallet, use orapki wallet add with the -user_cert parameter.
```
orapki wallet add -wallet wallet_location [-pwd wallet_password] -user_cert -cert user_certificate_file
```
