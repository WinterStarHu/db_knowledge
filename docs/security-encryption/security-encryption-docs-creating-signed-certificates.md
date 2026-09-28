# Creating Signed Certificates for Testing Purposes

The `orapki` utility provides a convenient, lightweight way to create signed certificates for testing purposes.
  - To create a signed certificate for testing purposes, use the following command:
```
orapki cert create [-wallet wallet_location] -request certificate_request_location -cert certificate_location -validity number_of_days [-summary] [-cert_validation_mode strict|non-strict]
```
This command creates a signed certificate from the certificate request.
- The -wallet parameter specifies the wallet containing the user certificate and private key that will be used to sign the certificate request.
- The -validity parameter specifies the number of days, starting from the current date, that this certificate will be valid. Specifying a certificate and certificate request is mandatory for this command.
``````
- The -cert_validation_mode parameter specifies if strict certificate validation, conforming to the RFC#5280 standard is (strict) or is not (non-strict) being used.
