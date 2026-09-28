# Configuring Azure AD Client Connections to the Oracle Database

You can configure client connections to connect with the Azure AD registered database
- About Configuring Client Connections to Azure ADs There are numerous ways that you can configure a client to connect with an Oracle Database instance using Azure AD tokens.
- Supported Client Drivers for Azure AD Connections Oracle Database supports several types of client drivers for Azure AD connections.
- Using Centralized Oracle Cloud Infrastructure Services for Net Naming and Secrets You can use the Oracle Cloud Infrastructure (OCI) object store and vault to centrally store net names and secrets.
- Operational Flow for SQL*Plus Client Connection in PowerShell to Oracle Database The connection between the Azure user, Azure AD, and the Oracle database relies on the passing of the OAuth2 token throughout these components.
- Registering a Client with Azure AD Application Registration This type of registration is similar to registering Oracle Database with Azure AD app registration.
- Examples of Retrieving Azure AD OAuth2 Tokens These examples show different ways that you can retrieve Azure AD OAuth2 tokens.
* *
- [Configuring SQLPlus for Azure AD Access Tokens](configuring-sqlplus-azure-ad-access-tokens.html#GUID-89CB6E1E-E383-476A-8B46-4343CEF8512E) You must configure SQLPlus to retrieve the Azure AD database access token from a location and use it when the / slash login is used.
- Creating a Network Proxy for the Database to Connect with the Internet This network proxy will enable the Oracle database to reach the Azure AD endpoint.
- Enabling Clients to Directly Retrieve Azure Tokens You can set parameters to enable clients to directly retrieve Azure tokens on their own.
