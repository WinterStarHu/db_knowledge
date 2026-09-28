# Configuring Multi-Factor Authentication

Multi-Factor Authentication (MFA) through push notifications or certificate-based authentication can be configured for Oracle Database native users.
MFA requires users to provide two or more distinct forms of identification before gaining access to an account or system. It adds an extra layer of protection beyond just a username and password.
Oracle Database allows MFA configuration for native users in the form of either push notifications through Oracle Mobile Authenticator (OMA) or Cisco Duo, or certificate-based authentication. MFA can also be implemented by existing external authentication methods for human users with OCI IAM, MS-EI, and RADIUS. The methods described here are for native database users.
MFA will work for administrative privilege accounts (SYSDBA, SYSOPER, …) in the CDB root and the PDB when the database is opened. However, push notification MFA is not supported when the database is closed, and the login will error out if the user is configured for push notification and the database is closed. The certificate with password MFA is supported when the database is closed.
To prevent users from potentially removing their own second factor authentication, only users with the ALTER USER privilege will be able to modify or remove the second factor authentication. Users will not be able to drop their own second-factor authentication.
MFA is not supported for the following:
- Direct login RAS users
- Applications, including server-to-server connections
- Centrally managed user (CMU) connections
- Admin connections using external password file for OMA and Duo push
- HTTP digest authentication
- Role passwords
- MFA Push Notifications You can add push notifications as an additional authentication method for database users.
- MFA Certificate-based Authentication You can add a PKI certificate as a second factor authentication for native database users.
- Auditing Multi-factor Authentication Failures For second factor authentication failures, the details will be captured in the additional_info column in the unified audit table.
- Database Links and Multi-factor Authentication Database links used by scripts or applications should not have MFA enabled. However, there are no restrictions in place to prevent the enablement of MFA for database links.
## MFA Push Notifications
You can add push notifications as an additional authentication method for database users.
In multi-factor authentication, push notifications can be added as a secondary verification step, where a user receives a prompt on their mobile device to approve or deny a login attempt. The push notifications can be configured to be used with either the Oracle Mobile Authenticator (OMA) or Cisco Duo apps.
When the database or PDB is closed, multi-factor authentication through push notifications will fail. Only certificate-based authentication is supported as the second factor when the database is closed.
**Note:**  Push notifications are not supported in either Oracle Autonomous Database on Dedicated Exadata Infrastructure or Oracle Autonomous Database Serverless.
- Cisco Duo Cisco Duo push notifications can be added as a secondary authentication method for native database users.
- Oracle Mobile Authenticator (OMA) Oracle Mobile Authenticator (OMA) push notifications can be added as a secondary authentication method for native database users.
- MFA External Account Updates and Cleanup Sometimes the administrator must access the external service accounts to perform tasks such as allowing users to change their device or email address, resending device registration links, or temporarily bypassing MFA in Cisco Duo.
### Cisco Duo
Cisco Duo push notifications can be added as a secondary authentication method for native database users.
**Prerequisites**
- A Cisco Duo account is required.
  - API hostname
  - Integration key
  - Secret key
- An email integration is needed to register users. This would normally integrate with your existing corporate email system via the SMTP port. Have the service account username and password available.
**Configuring Cisco Duo in the Database**
```
ALTER SYSTEM SET MFA_DUO_API_HOST = "api-855fd6a0.duosecurity.com";
```
  - MFA_DUO_API_HOST For example,
```
ALTER SYSTEM SET MFA_SMTP_HOST =
   "smtp.email.us-sanjose-1.oci.oraclecloud.com";
```
  - MFA_SMTP_HOST For example,
```
ALTER SYSTEM SET MFA_SMTP_PORT = 587;
```
  - MFA_SMTP_PORT For example,
```
ALTER SYSTEM SET MFA_SENDER_EMAIL_ID =
   "database_mfa_registration@example.com";
```
  - MFA_SENDER_EMAIL_ID For example,
```
ALTER SYSTEM SET MFA_SENDER_EMAIL_DISPLAYNAME = "Database MFA Registration";
```
  - MFA_SENDER_EMAIL_DISPLAYNAME For example,
For more information see the MFA parameters in the *Oracle Database Reference* guide.
```
cd
```
````
  - Navigate to the location of the server wallet: For PDB, the wallet location is //mfa and for CDB root, the wallet location is /mfa
```
orapki wallet create -wallet ./ -pwd  -auto_login -compat_v12
```
  - If you don’t have an existing wallet, create it:
```
mkstore -wrl ./ -createEntry oracle.security.mfa.duo.integrationkey
```
    - oracle.security.mfa.duo.integrationkey
```
mkstore -wrl ./ -createEntry oracle.security.mfa.duo.secretkey
```
    - oracle.security.mfa.duo.secretkey
```
mkstore -wrl ./ -createEntry oracle.security.mfa.smtp.user
```
****
    - oracle.security.mfa.smtp.user Note: If you are using default SMTP server on Linux host, typically they don’t need authentication and you don’t need to add this property to the server wallet.
```
mkstore -wrl ./ -createEntry oracle.security.mfa.smtp.password
```
****
    - oracle.security.mfa.smtp.password Note: If you are using default SMTP server on Linux host, typically they don’t need authentication and you don’t need to add this property to the server wallet.
- Add the CA root trust certificate of your SMTP server to the database server’s system certificate store. This step is required if the SMTP server doesn’t use a CA root of trust that already exists in the database server default certificate store. A separate wallet is not required for this since the database server will look in the default certificate store for the host OS.
````
- In the database server sqlnet.ora file, set the SQLNET.INBOUND_CONNECT_TIMEOUT parameter to more than 60 seconds. This is an end to end authentication timeout setting. If this value is less than Cisco Duo’s Push Authentication Timeout which is 60 seconds, then the server may not write the audit log for failed authentication due to push notification expiry.
**Configuring Cisco Duo for Users**
```
CREATE USER  IDENTIFIED BY  AND FACTOR 'DUO_PUSH' AS '';
```
```
CREATE USER jsmith IDENTIFIED BY j2Ax7r-st3z0g-qY24vp AND FACTOR 'DUO_PUSH' AS 'jason.smith@xyz.com';
```
  - Database administrators with the CREATE USER privilege can create database users that have Cisco Duo as a secondary authentication method with a password being the primary authentication method. For example,
```
ALTER USER  ADD FACTOR 'DUO_PUSH' AS '';
```
```
ALTER USER jsmith ADD FACTOR 'DUO_PUSH' AS 'jason.smith@xyz.com';
```
  - Database administrators with the ALTER USER privilege can alter existing database users to add Cisco Duo as a secondary authentication method with a password being the primary authentication method. For example,
When `DUO_PUSH` is added as the second factor for the user, the database creates the user (with *`\`* as the user name in above example) in Cisco Duo account that is configured in the PDB and sends email to the user to register their device with the Cisco Duo application. If the user already exists in the Duo acount then no email is sent to the user. Currently, emails are sent in a fixed format in English only, and no customization is available at this time. The enrollment link and QR code sent in the email will expire after 24 hours.
### Oracle Mobile Authenticator (OMA)
Oracle Mobile Authenticator (OMA) push notifications can be added as a secondary authentication method for native database users.
**Prerequisites**
- An Oracle IAM account is required. For more details about paid and free accounts see OCI Identity and Access Management. End-users will not need to access OCI IAM, but a DBA will need some information regarding OCI IAM access.
- Have the IAM domain URL available. For more information see Identity Domain Details in the OCI documentation.
````
- The client should have the User Administrator and MFA Client roles in OCI IAM.
****
- Have the client ID and secret available as these need to be stored in the wallet to access the endpoint. This can be found in the General Information section of the integrated application. For more information see Registering a Client Application in the OCI documentation.
- An email integration is needed to register users. This would normally integrate with your existing corporate email system via the SMTP port. Have the service account username and password available.
**Configuring OMA in the Database**
```
ALTER SYSTEM SET MFA_OMA_IAM_DOMAIN_URL = "https://idcs-cbcb9aaca84945e78466ab5b2e576360.identity.oraclecloud.com";
```
  - MFA_OMA_IAM_DOMAIN_URL For example,
```
ALTER SYSTEM SET MFA_SMTP_HOST = "smtp.email.us-sanjose-1.oci.oraclecloud.com";
```
  - MFA_SMTP_HOST For example,
```
ALTER SYSTEM SET MFA_SMTP_PORT = 587;
```
  - MFA_SMTP_PORT For example,
```
ALTER SYSTEM SET MFA_SENDER_EMAIL_ID = "database_mfa_registration@example.com";
```
  - MFA_SENDER_EMAIL_ID For example,
```
ALTER SYSTEM SET MFA_SENDER_EMAIL_DISPLAYNAME = "Database MFA Registration";
```
  - MFA_SENDER_EMAIL_DISPLAYNAME For example,
For more information see the MFA parameters in the *Oracle Database Reference* guide.
```
cd
```
````
  - Navigate to the location of the server wallet: For PDB, the wallet location is //mfa and for CDB root, the wallet location is /mfa
```
orapki wallet create -wallet ./ -pwd  -auto_login -compat_v12
```
  - If you don’t have an existing wallet, create it:
```
mkstore -wrl ./ -createEntry oracle.security.mfa.oma.clientid
```
  - oracle.security.mfa.oma.clientid
```
mkstore -wrl ./ -createEntry oracle.security.mfa.oma.clientsecret
```
  - oracle.security.mfa.oma.clientsecret
```
mkstore -wrl ./ -createEntry oracle.security.mfa.smtp.user
```
  - oracle.security.mfa.smtp.user
**Note:**  If you are using default SMTP server on Linux host, typically they don’t need authentication and you don’t need to add this property to the server wallet.
```
    - `oracle.security.mfa.smtp.password`
mkstore -wrl ./ -createEntry oracle.security.mfa.smtp.password &lt;smtp password&gt;
      **Note:**  If you are using default SMTP server on Linux host, typically they don't need authentication and you don't need to add this property to the server wallet.
      {: .infoboxnote}
```
- Add the CA root trust certificate of your SMTP server to the database server’s system certificate store. This step is required if the SMTP server doesn’t use a CA root of trust that already exists in the database server default certificate store. A separate wallet is not required for this since the database server will look in the default certificate store for the host OS.
````
- In the database server sqlnet.ora file, set the SQLNET.INBOUND_CONNECT_TIMEOUT parameter to more than 60 seconds. This is an end to end authentication timeout setting. If this value is less than OMA’s Push Authentication Timeout which is 60 seconds, then the server may not write the audit log for failed authentication due to push notification expiry.
**Configuring OMA for Users**
````
```
curl -X PATCH "${DOMAIN_URL}/admin/v1/AuthenticationFactorSettings/AuthenticationFactorSettings" \
 -H 'Content-Type: application/json' \
 -H "Authorization: Bearer $AUTH_TOKEN" \
 -d '{
  "schemas": [
    "urn:ietf:params:scim:api:messages:2.0:PatchOp"
  ],
  "Operations": [
    {
      "op": "replace",
      "path": "totpSettings.jwtValidityDurationInSecs",
      "value": 86400
    }
  ]
 }'
```
- When you add OMA as an additional authentication method for a database user, they will receive an email to download OMA and register their device with OMA. The value of totpSettings.jwtValidityDurationInSecs in OCI IAM dictates how long the information in the registration email is valid. Consider changing the value to give database users more time to register their devices. Change the value of totpSettings.jwtValidityDurationInSecs in OCI IAM from it’s default value of 300 seconds to 86,400 (i.e. one day) to provide enough time for the user to enroll the device. See the following API and payload information to change the value of totpSettings.jwtValidityDurationInSecs.
```
CREATE USER  IDENTIFIED BY  AND FACTOR 'OMA_PUSH' AS '';
```
```
CREATE USER jsmith IDENTIFIED BY j2Ax7r-st3z0g-qY24vp AND FACTOR 'OMA_PUSH' AS 'jason.smith@xyz.com';
```
  - Database administrators with the CREATE USER privilege can create database users that have OMA as a secondary authentication method with a password being the primary authentication method. For example,
```
ALTER USER  ADD FACTOR 'OMA_PUSH' AS '';
```
```
ALTER USER jsmith ADD FACTOR 'OMA_PUSH' AS 'jason.smith@xyz.com';
```
  - Database administrators with the ALTER USER privilege can alter existing database users to add OMA as a secondary authentication method with a password being the primary authentication method. For example,
When `OMA_PUSH` is added as the second factor for the user, the database creates the user (with *`\`* as the user name in above example) in OCI IAM domain that is configured in the PDB and sends email to the user to register their device with the OMA application. If the user already exists in the OCI IAM domain and the device is already registered for MFA factor then no email is sent to the user. Currently, emails are sent in a fixed format in English only, and no customization is available at this time. The enrollment link and QR code sent in the email expire after configured token validity duration in `AuthenticationFactorSettings` in OCI IAM.
### MFA External Account Updates and Cleanup
Sometimes the administrator must access the external service accounts to perform tasks such as allowing users to change their device or email address, resending device registration links, or temporarily bypassing MFA in Cisco Duo.
The following are several use cases for which administrators may need to update or delete user account in external services.
**** **
- Cleanup of Disabled User Accounts - Cisco Duo and OMA The user has left the organization or moved to a different department, and their account has been deleted from all databases. The administrator should log in to the push notification service account to delete the user.
**** **
```
ALTER USER  UPDATE FACTOR '' AS '';
```
- User Switching Devices - Cisco Duo and OMA The user is changing their device after previously registering one using OMA or Cisco Duo. The administrator should log in to the push notification service account and delete the user. Execute the following ALTER USER command to resend the device registration link:
**** **
```
ALTER USER  UPDATE FACTOR '' AS '';
```
- User’s Email ID Changed - Cisco Duo and OMA The email ID used by the user for enabling second-factor authentication has been updated. The administrator should log in to the push notification service account and clean up the account associated with the old email ID. Execute the following ALTER USER command to update the email ID and resend the device registration link:
**** **
```
ALTER USER  UPDATE FACTOR 'DUO_PUSH' AS '';
```
- Device Registration Link Expired - Cisco Duo The user did not complete device registration for second-factor authentication before the link expired. The administrator should log in to the push notification service account and delete the user Execute the following ALTER USER command to resend the device registration link:
**** **
```
ALTER USER  UPDATE FACTOR 'OMA_PUSH' AS '';
```
- Device Registration Link Expired - OMA The user did not complete device registration for second-factor authentication before the link expired. Execute the following ALTER USER command to resend the device registration link:
**** **
```
ALTER USER  UPDATE FACTOR 'DUO_PUSH' AS '';
```
- Deleted Account from Authenticator - Cisco Duo The user removed their device registration by deleting the account from the mobile authenticator app. The administrator should log in to the push notification service account and delete the user. Execute the following ALTER USER command to resend the device registration link:
**** **
```
ALTER USER  UPDATE FACTOR 'OMA_PUSH' AS '';
```
- Deleted Account from Authenticator - OMA The user removed their device registration by deleting the account from the mobile authenticator app. Execute the following ALTER USER command to resend the device registration link:
**** **
````
- Temporarily Bypass MFA for a User - Cisco Duo The administrator temporarily bypasses MFA for a user if the user has lost their device or the device is currently inaccessible. This is not available for OMA The administrator should log in to the Cisco Duo account and change the user’s status from Active to Bypass (skip two-factor authentication).
****
**
  - OMA - Deactive the user
  - Cisco Duo - Disable the user by changing their status to Disabled
## MFA Certificate-based Authentication
You can add a PKI certificate as a second factor authentication for native database users.
When a PKI certificate is added as the second factor, the user can log in to the database using a signed user certificate stored in their wallet or on a smart card. The authentication process combines the existing PKI certificate authentication method, establishing a mutual TLS connection along with password authentication.
Certificate-based MFA is supported for administrative privileged accounts (SYS*) when the database is open or closed.
**Configuring Certificate-based Authentication**
``````
- Ensure that users have a signed certificate with the DN value, "cn = ", matching what is in the WALLET_LOCATION specified in the sqlnet.ora. For more information on how to configure certificate-based authentication see Configuring Transport Layer Security Encryption. This will also create a mutual TLS connection with the database.
```
CREATE USER  IDENTIFIED BY  AND FACTOR 'CERT_AUTH' AS 'cn=';
```
```
CREATE USER jsmith IDENTIFIED BY j2Ax7r-st3z0g-qY24vp AND FACTOR 'CERT_AUTH' AS 'cn=jason.smith';
```
  - Database administrators with the CREATE USER privilege can create database users that have certificate-based authentication as a secondary authentication method with a password being the primary authentication method. For example,
```
ALTER USER  ADD FACTOR 'CERT_AUTH' AS 'cn=';
```
```
ALTER USER jsmith ADD FACTOR 'CERT_AUTH' AS 'cn=jason.smith';
```
****
````````
  - Database administrators with the ALTER USER privilege can alter existing database users to add certificate-based authentication as a secondary authentication method with a password being the primary authentication method. For example, Note: To add multi-factor authentication for a SYS* privileged user or to grant SYS* privileges to a user with multi-factor authentication, the password file must be in 12.2 format. Otherwise, the ALTER USER operation will fail. If the password file is not in 12.2 format, it should be migrated using orapwd. Migration of the Password File of Administrative Users
``````
```
SQLNET.AUTHENTICATION_SERVICES = (TCPS)
```
- Ensure that the SQLNET.AUTHENTICATION_SERVICES parameter in the sqlnet.ora file, located at $ORACLE_HOME/network/admin/sqlnet.ora, must include TCPS.
## Auditing Multi-factor Authentication Failures
For second factor authentication failures, the details will be captured in the `additional_info` column in the unified audit table.
## Database Links and Multi-factor Authentication
Database links used by scripts or applications should not have MFA enabled. However, there are no restrictions in place to prevent the enablement of MFA for database links.
Both fixed user and connected user database links can be configured for MFA push notification with the target database, but this would not be the normal use case.
