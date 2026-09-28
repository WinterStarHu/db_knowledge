# Authenticating and Authorizing Microsoft Azure Active Directory Users for Oracle Databases

An Oracle Database can be configured for Microsoft Azure AD users to connect using single-sign on.
- Introduction to Oracle Database Integration with Microsoft Azure AD Before you begin configuring Microsoft Azure AD to access an Oracle database, you must understand the overall process.
- Configuring the Oracle Database for Microsoft Azure AD Integration The Microsoft Azure AD integration with the Oracle Database instance requires the database to be registered with Azure AD.
- Mapping Oracle Database Schemas and Roles Azure AD users will be mapped to one database schema and optionally to one or more database roles.
- Configuring Azure AD Client Connections to the Oracle Database You can configure client connections to connect with the Azure AD registered database
- Configuring Microsoft Azure AD Proxy Authentication Proxy authentication allows an Azure AD user to proxy to a database schema for tasks such as application maintenance.
````
- Troubleshooting Microsoft Azure AD Connections You can use trace files to diagnose problems with Microsoft Azure AD connections. You also can easily remedy ORA-12599 and ORA-03114 errors.
