# Configuring the Oracle Database for Microsoft Azure AD Integration

The Microsoft Azure AD integration with the Oracle Database instance requires the database to be registered with Azure AD.
- Oracle Database Requirements for the Microsoft Azure AD Integration Before you can configure an Oracle Database instance with Microsoft Azure AD, you must ensure that your environment meets special requirements.
- Registering the Oracle Database Instance with a Microsoft Azure AD Tenancy A user with Azure AD administrator privileges uses Microsoft Azure AD to register the Oracle Database instance with the Microsoft Azure AD tenancy.
- Enabling Microsoft Azure AD v2 Access Tokens Oracle Database supports integration with the v1 and v2 Azure AD OAuth2 access token.
- Managing App Roles in Microsoft Azure AD In Azure AD, you can create and manage app roles that will be assigned to Azure AD users and groups and also be mapped to Oracle Database global schemas and roles.
- Enabling Azure AD External Authentication for Oracle Database You need to enable Microsoft Azure AD external authentication with Oracle Database.
- Disabling Azure AD External Authentication for Oracle Database To disable Azure AD External authentication for an Oracle Database instance, you must use the ALTER SYSTEM statement.
## Oracle Database Requirements for the Microsoft Azure AD Integration
Before you can configure an Oracle Database instance with Microsoft Azure AD, you must ensure that your environment meets special requirements.
For an on-premises, non-cloud Oracle database, follow the steps in this document. If your Oracle database is in one of the following DBaaS platforms, then refer to the platform documentation for additional requirements.
**
- Using Oracle Autonomous Database Serverless
**
- Using Oracle Autonomous Database on Dedicated Exadata Infrastructure
- Use Azure Active Directory Authentication with Base Database Service
- Use Azure Active Directory Authentication with Exadata Database on Dedicated Infrastructure
Note the following:
- The Oracle Database server must be able to request the Azure AD public key. Depending on the enterprise network connectivity setup, you may need to configure a proxy setting.
- Users and applications that need to request an Azure AD token must also be able to have network connectivity to Azure AD. You may need to configure a proxy setting for the connection.
- You must configure Transport Layer Security (TLS) between the Oracle Database client and the Oracle Database server so that the token can be transported securely. This TLS connection can be either one-way or mutual.
- You can create the TLS server certificate to be self-signed or be signed by a well known certificate authority. The advantage of using a certificate that is signed by a well known Certificate Authority (CA) is that the database client can use the system default certificate store to validate the Oracle Database server certificate instead of having to create and maintain a local wallet with the root certificate. Note that this applies to Linux and Windows clients only.
## Registering the Oracle Database Instance with a Microsoft Azure AD Tenancy
A user with Azure AD administrator privileges uses Microsoft Azure AD to register the Oracle Database instance with the Microsoft Azure AD tenancy.
- Log in to the Azure portal as an administrator who has Microsoft Azure AD privileges to register applications.
****
- In the Azure Active directory admin center page, from the left navigation bar, select Azure Active Directory.
****
- In the MS - App registrations page, select App registrations from the left navigation bar.
****
- Select New registration. The Register an application window appears.
****
  - In the Name field, enter a name for the Oracle Database instance connection (for example, Example Database).
******
  - Accounts in this organizational directory only (tenant_name only - Single tenant)
****
  - Accounts in any organizational directory (Any Azure AD directory - Multitenant)
****
  - Accounts in any organizational directory (Any Azure AD directory - Multitenant) and personal Microsoft accounts (e.g. Skype, Xbox)
****
  - Personal Microsoft accounts only
- Bypass the Redirect URI (Optional) settings. You do not need to create a redirect URI because Azure AD does not need one for the database server.
**** ****
- Click Register. After you click Register, Azure AD displays the app registration’s Overview pane, which will show the Application (client) ID under Essentials. This value is a unique identifier for the application in the Microsoft identity platform. Note the term Application refers to the Oracle Database instance.
****
  - In the left navigation bar, select Expose an API.
********
```
your_tenancy_url/application_(client)_id
```
````
    - your_tenancy_url must include https as the prefix and the fully qualified domain name of your Azure AD tenancy.
    - application_(client)_id is the ID that was generated when you registered the Oracle Database instance with Azure AD. It is displayed in the Overview pane of the app registration.
For example:
```
https://sales_west.example.com/1aa11111-1a1z-1a11-1a1a-11aa11a1aa1a
```
****
****
```
session:scope:connect
```
    - Scope name specifies a name for the scope. Enter the following name: This name can be any text. However, a scope name must be provided. You will need to use this scope name later when you give consent to the database client application to access the database.
************
    - Who can consent specifies the necessary permissions. Select Admins and users, or for higher restrictions, Admins only.
****
    - Admin consent display name describes the scope’s purpose (for example, Connect to Oracle), which only administrators can see.
****
    - Admin consent display name describes the scope’s purpose (for example, Connect to Example Database), which only administrators can see.
************
    - User consent display name is a short description of the purpose of the scope (for example, Connect to Example Database), which users can see if you specify Admins and users in Who can consent.
************
    - User consent description is a more detailed description of the purpose of the scope (for example, Connect to Example Database), which users can see if you specify Admins and users in Who can consent.
********
    - State enables or disables the connection. Select Enabled.
After you complete these steps, you are ready to add one or more Azure app roles, and then perform the mappings of Oracle schemas and roles.
## Enabling Microsoft Azure AD v2 Access Tokens
Oracle Database supports integration with the v1 and v2 Azure AD `OAuth2` access token.
The Azure AD v2 access token, supports a wider range of access scenarios than the v1 token, including authentication for both organizational accounts (Azure AD) and personal Microsoft accounts (MSA). You can use this token with applications that are registered in the Azure portal using the **App registrations** experience.
When you use the Azure AD v2 `OAuth2` access token, the credential flow continues to work as it did before without any changes. However, the `upn:` claim must be added when you use v2 tokens with the interactive flow.
- Check the version of the Azure AD access token that you are using.
- Log in to the Microsoft Azure portal.
****
- Search for and select Azure Active Directory.
********
- Under Manage, select App registrations.
- Choose the application for which you want to configure optional claims based on your scenario and desired outcome.
********
- Under Manage, select Token configuration.
********
- Click Add optional claim and select upn.
When you use v2 tokens, the `aud:` claim only reflects the APP ID value. You do not need to set the `https:domain` prefix to the APP ID URI when v2 tokens are being used. This simplifies the configuration for the database because the default APP ID URI can be used.
## Managing App Roles in Microsoft Azure AD
In Azure AD, you can create and manage app roles that will be assigned to Azure AD users and groups and also be mapped to Oracle Database global schemas and roles.
- Creating a Microsoft Azure AD App Role Azure AD users, groups, and applications that need to connect to the database will be assigned to the database app roles.
- Assigning Users and Groups to the Microsoft Azure AD App Role Before Microsoft Azure AD users can have access to the Oracle database, they must first be assigned to the app roles that will be mapped to Oracle Database schema users or roles.
- Assigning an Application to an App Role An application that must connect to the database using the client credential flow must to be assigned to an app role.
### Creating a Microsoft Azure AD App Role
Azure AD users, groups, and applications that need to connect to the database will be assigned to the database app roles.
See the Microsoft Azure article Create and assign a custom role in Azure Active Directory for detailed steps on how to create an app role. The following steps describe how to create the app role for use with an Oracle database.
- Log in to Azure AD as an administrator who has privileges for creating app roles.
****
  - Use the Directory + subscription filter to locate the Azure Active Directory tenant that contains the Oracle Database app registration.
****
  - Select Azure Active Directory.
********
  - Under Manage, select App registrations, and then select the Oracle Database instance that you registered earlier.
********
- Under Manage, select App roles.
****
- In the App roles page, select Create app role.
****
  - Display name is the displayed name of the role (for example, HR App Schema). You can include spaces in this name.
****
  - Value is the actual name of the role (for example, HR_APP). Ensure that this setting matches exactly the string that is referenced in the database mapping to a schema or role. Do not include spaces in this name.
****
  - Description provides a description of the purpose of this role.
****
  - Do you want to enable this app role? enables you to activate the role.
****
- Click Apply. The app role appears in the App roles pane. Description of the illustration azure-app-roles-creation.png
### Assigning Users and Groups to the Microsoft Azure AD App Role
Before Microsoft Azure AD users can have access to the Oracle database, they must first be assigned to the app roles that will be mapped to Oracle Database schema users or roles.
See the Microsoft Azure article Add app roles to your application and receive them in the token for detailed steps assigning users and groups to an app role. The following steps explain how to do this for an Oracle database.
- Log in to Azure AD as an administrator who has privileges for assigning Azure AD users and groups to app roles.
****
  - Use the Directory + subscription filter to locate the Azure Active Directory tenant that contains the Oracle connection.
****
  - Select Azure Active Directory.
********
  - Under Manage, select Enterprise applications, and then select the Oracle Database app registration name that you registered earlier.
****
- Under Getting Started, select Assign users and groups.
****
- Select Add user/group.
****
- In the Add assignment window, select Users and groups to display a list of users and security groups.
****
- From this list, select the users and groups that you want to assign to the app role, and then click Select.
****
- In the Add assignment window, select Select a role to display a list of the app roles that you have created.
****
- Select the app role and then select Select.
****
- Click Assign.
### Assigning an Application to an App Role
An application that must connect to the database using the client credential flow must to be assigned to an app role.
- Log in to Azure AD as an administrator who has privileges for assigning Azure AD users and groups to app roles.
- Access the app registration for the application.
****
- Under Manage, select API permissions.
****
- In the Configured permissions area, select + Add a permission.
****
- In the Request API permission pane, select the My APIs tab.
****
- Select the Oracle Database app that you want to give permission for this application to access. Then select the Application permissions option.
****
- Select the database app roles to assign to the application and then click the Add Permission box at the bottom of the screen to assign the app roles and close the dialog box. Ensure that the app roles that you just assigned appear under Configured permissions. Description of the illustration azure-grant-consent.png
**********
- Select Grant admin consent for tenancy to grant consent for the tenancy users, then select Yes in the confirmation dialog box.
## Enabling Azure AD External Authentication for Oracle Database
You need to enable Microsoft Azure AD external authentication with Oracle Database.
For additional information about Azure AD authentication for your platform, see the documentation links below.
- Log in to the Oracle Database instance as a user who has been granted the ALTER SYSTEM system privilege.
```
ALTER SYSTEM SET IDENTITY_PROVIDER_TYPE=AZURE_AD SCOPE=BOTH;
```
- Set the IDENTITY_PROVIDER_TYPE parameter as follows:
```
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME='identity_provider_type';
```
```
NAME                    VALUE
----------------------  -------
identity_provider_type  AZURE_AD
```
- Ensure that you set the IDENTITY_PROVIDER_TYPE parameter correctly. The following output should appear:
```
ALTER SYSTEM SET IDENTITY_PROVIDER_CONFIG = '{ application_id_uri : string , // from registered app, to be mapped in jwt "aud" claim;
// Domain qualified to support cross tenancy resource access tenant_id : string,           // from tenant config app_id: string                // from registered resource app }' SCOPE=BOTH;
```
```
ALTER SYSTEM SET IDENTITY_PROVIDER_CONFIG = '{ "application_id_uri" : "https://www.example.com/11aa1a11-aaaa-1111-1111-1111aa11111", "tenant_id" : "111a1111-a11a-111a-1a1a-1111111111a", "app_id" : "11aa1a11-aaaa-1111-1111-1111aa11111" }' SCOPE=BOTH;
```
- Set the IDENTITY_PROVIDER_CONFIG parameter by using the following syntax: For example:
See the following platform-specific documentation for information about enabling Oracle Database for Azure AD external authentication, in addition to the information detailed in this document for on-premises (non-cloud) Oracle databases.
**
- Using Oracle Autonomous Database Serverless
**
- Oracle Autonomous Database on Dedicated Exadata Infrastructure
## Disabling Azure AD External Authentication for Oracle Database
To disable Azure AD External authentication for an Oracle Database instance, you must use the `ALTER SYSTEM` statement.
In addition to Oracle Database, this procedure can be used for Oracle Autonomous Database on Dedicated Exadata Infrastructure and Oracle Exadata Cloud Service (Oracle ExaCS). If you want to disable Azure AD external authentication with these products, see their product documentation.
To disable Azure AD from Oracle Autonomous Database Serverless, see *Using Oracle Autonomous Database Serverless*. The following procedure applies to all other platforms:
- Log in to the Oracle Database instance as a user who has been granted the ALTER SYSTEM system privilege.
```
ALTER SYSTEM RESET IDENTITY_PROVIDER_CONFIG SCOPE=BOTH;
ALTER SYSTEM RESET IDENTITY_PROVIDER_TYPE SCOPE=BOTH;
```
- Set the identity provider parameters as follows:
## Related Topics
  - Transport Layer Security Connection without a Client Wallet
  - Quickstart: Register an application with the Microsoft identity platform
  - Checking the Azure AD Access Token Version
  - Configure the admin consent workflow
