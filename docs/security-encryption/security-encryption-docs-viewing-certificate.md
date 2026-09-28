# Viewing a Certificate

After you create a certificate, you can use the `orapki` utility to view it.
  - To view a certificate, use the following command:
```
orapki cert display -cert certificate_location [-summary | -complete]
```
This command enables you to view a test certificate that you have created with `orapki`. You can choose either `-summary` or `-complete`, which determines how much detail the command will display. If you choose `-summary`, the command will display the certificate and its expiration date. If you choose `-complete`, it will display additional certificate information, including the serial number and public key.
