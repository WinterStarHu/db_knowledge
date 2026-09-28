# Enabling Clients to Directly Retrieve Azure Tokens

You can set parameters to enable clients to directly retrieve Azure tokens on their own.
This feature is available in environments that use JDBC-thin clients, ODP.NET Core classes, or ODP.NET Managed Driver classes. It enables the client to display authentication requests to the user by using the following methods:
- If the user is using a Web application, then the authentication request appears in a dialog box prompting the user for their authentication.
- If the user is working in a command line shell, then the authentication request appears as a prompt.
To enable this feature for either of these authentication request types, you must set the following parameters in either the client’s `sqlnet.ora` file or in a connect string. The connect string takes precedence over `sqlnet.ora`.
##### `TOKEN_AUTH`
Sets the token authentication. Enter one of the following values:
- AZURE_DEVICE_CODE signals the database driver to follow the device code flow for requesting an Azure AD access token. This is also for human users, when their environment cannot open a browser: a command line only environment. A device code and Azure AD login URL is written out to the standard output of the tool and the user logs into Azure AD on their cellphone or laptop, and then enters the device code. Users are authenticated through a separate channel and then allowed to continue access the database if the authentication is successful.
- AZURE_INTERACTIVE tells the driver that it must flow the Azure OAuth2 interactive (OAuth2 authorization) flow to get an access token for the database. This configures the database client to get the token directly from Azure AD without having to use an external script. This is for human users who are logging into tools such as SQLcl and can also open a browser window in their environment to authenticate to Azure AD.
- AZURE_MANAGED_IDENTITY enables the driver to authenticate as an identity that has been assigned to the host system. The host system must be a resource which is managed by Azure AD, such as a virtual machine.
- AZURE_SERVICE_PRINCIPAL enables the driver to authenticate using a secret or certificate of the registered application.
##### `AZURE_CLIENT_ID`
The unique application (client) ID assigned to your app by Azure AD when the app was registered. This app is your database client that will request to get an access token for the database for the user.
##### `AZURE_DB_APP_ID_URI`
The application ID URI is a URI that uniquely identifies the application in your Azure AD. You get this value from the overview screen of your database Azure AD app registration.
##### `AZURE_TENANT_ID`
Specifies the Azure tenancy ID of the database.
