# Examples of Retrieving Azure AD OAuth2 Tokens

These examples show different ways that you can retrieve Azure AD `OAuth2` tokens.
- Example: Using PowerShell to Get a Token Using Resource Owner Password Credentials This example shows how to use PowerShell to get an Azure AD access token by using Resource Owner Password Credentials (ROPC).
- Example: Using Python with Microsoft Authentication Library Using an Authorization Flow Because this example with the Microsoft Authentication Library (MSAL) is in Python, it can be run on a variety of platforms such as PowerShell and Linux.
- Example: Using Curl with a Resource Owner Password Credential Flow This example shows how to use the curl command against the Azure AD API using a Resource Owner Password Credential (ROPC) flow with a public Azure AD client.
- Example: Azure CLI Using Authorization Flow This example shows how to use the Azure CLI to retrieve an access token and then write the token to a file.
## Example: Using PowerShell to Get a Token Using Resource Owner Password Credentials
This example shows how to use PowerShell to get an Azure AD access token by using Resource Owner Password Credentials (ROPC).
You can retrieve the `OAuth2` access token by making a REST call from PowerShell. This configuration requires several values that were generated or that you specified when you registered the Oracle Database instance with Azure AD.
- If necessary install the Azure Active Directory PowerShell module. Follow the instructions in the Microsoft article Install the Azure Az PowerShell module to download and install Azure PowerShell. It takes about 20 minutes or longer to perform the installation. You may want to set debug options for Azure PowerShell so that you can see how the installation is progressing.
```
$TenantDomain = "example.com"
```
  - $TenantDomain = "user_tenancy_domain_name" This value is the tenancy domain name. For example:
****
```
$AppClientId ="111a1a1a-aa1a-1a1a-11aa-1a11111111aa"
```
  - $AppClientId ="application_client_id" This value sets the application client ID for the database client, not the database server. This is the Application (client) ID value in the app registration’s Overview pane. For example:
```
$Username = "peter.fitch@example.com"
```
  - $Username = "user_name", which This value is the name of the Azure user who wants to access the Oracle Database instance. For example:
  - $securePassword = Read-Host " Enter Password" -AsSecureString
  - $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
``````
```
$Scope = "https://example.com/111aa1aa-1111-1111-a1a1-1a11a111111a/session:scope:connect"
```
  - $Scope = "database_app_id_uri/scope" This value sets the app ID URI for the database and the scope (permission) for the database, separated by a / slash. These values can be found in the database app registration Expose an API page. In the following example, https://example.com/111aa1aa-1111-1111-a1a1-1a11a111111a is the app ID URI and session:scope:connect is the scope.
  - $requestBody = @{client_id=$AppClientId;grant_type="password";username=$Username;password=$Password;scope=$Scope;} This is the request body of the upcoming REST call.
  - $OAuthResponse = Invoke-RestMethod -Method Post -Uri https://login.microsoftonline.com/$TenantDomain/oauth2/v2.0/token -Body $requestBody This gets the OAuth2 access token for the user.
    - $securePassword = $null, for secure password strings
    - $Password = $null, for clear text password strings
````
  - $AccessToken = $OAuthResponse.access_token | Out-File -FilePath .\token -Encoding ASCII, which writes the OAuth2 token to the current file location using ASCII encoding
  - The default PowerShell UTF16 file encoding cannot be used for the token. Use ASCII encoding as an alternative.
  - Tokens may not work cross-platform (for example, Windows to Linux or Linux to Windows), depending on encoding changes to the file when it is moved.
At this stage, the `OAuth2` access token has been retrieved and stored as a file. The next step is to enable the SQL*Plus client to use the store access token and send it to the database.
## Example: Using Python with Microsoft Authentication Library Using an Authorization Flow
Because this example with the Microsoft Authentication Library (MSAL) is in Python, it can be run on a variety of platforms such as PowerShell and Linux.
When multi-factor authentication is enabled for the user, an `OAuth2` authorization flow is necessary for a user to add the second authentication. Because the authorization flow requires two round trips to Azure AD, it is best handled using the MSAL. See the Microsoft article Get Azure AD tokens by using the Microsoft Authentication Library for how to use a python script with MSAL. These instructions are for the Databricks service, but the scope is changed to the database App ID URI and scope instead of the Databricks scope.
- Bypass the steps to set up the client app registration, since you have already accomplished that step except make sure you add a Redirect URI (http://localhost) for your client app registration.
**** ****
```
scopes = ['https://example.com/1111aa1a-a1aa-1a11-11aa-1a1a11aa1111/session:connect']
```
- Go directly to Get Azure AD tokens by using the MSAL Python library. You will need the Directory (tenant) ID, Client ID for the public app client, and the database App ID URI and scope. You will see a code section for scopes with directions to not modify this variable. Because this python code was written for Databricks scope, you will need to change this scope variable to the scope of your database. For example:
```
stdout_backup = sys.stdout
with open('token', 'w') as token_file:
    sys.stdout = token_file
    print(acquire_tokens_result['access_token'])
sys.stdout = stdout_backup
```
- Modify the code to write the token to a file location. Use the following example code and append it to the print statements at the end. Note the extra lines to back up and restore the original stdout.
## Example: Using Curl with a Resource Owner Password Credential Flow
This example shows how to use the `curl` command against the Azure AD API using a Resource Owner Password Credential (ROPC) flow with a public Azure AD client.
The cleartext password is part of this command so this is not so much for end-users as it is for applications. This would need to be protected.
```
curl -X POST -H 'Content-Type: application/x-www-form-urlencoded' https://login.microsoftonline.com/az207oracleoutlook.onmicrosoft.com/oauth2/v2.0/token
-d 'client_id=571c3f0a-aa3c-4f0a-93ed-4f75748955ea' -d 'scope=https://example.com/383fe7ee-1433-4844-a2d5-5b80d811256d/session:scope:connect'
-d 'username=peter.fitch@example.com' -d 'password=password' -d 'grant_type=password'
```
- Enter the following curl command:
The response is a JSON file with token type, scope, expiration, and then the actual token. This file will need to be parsed so only the access token is written and stored in a file.
## Example: Azure CLI Using Authorization Flow
This example shows how to use the Azure CLI to retrieve an access token and then write the token to a file.
See the Microsoft Azure article Install the Azure CLI on Linux for information about installing the Azure CLI.
```
$ az login
```
- Log in to your Azure tenancy.
```
token=$(az account get-access-token --resource=database_app_id_uri --query accessToken --output tsv)
```
```
token=$(az account get-access-token --resource=https://example.com/1111aa1a-a1aa-1a11-11aa-1a1a11aa1111 --query accessToken --output tsv)
```
********
- Get an access token and assign it to the token variable using the following syntax: For example: If you get an error saying that the Azure CLI client app ID does not have permission to access the database resource, then copy the Azure CLI client app ID from the error message and add it to the list of authorized client applications for the database resource. (Go to the database app registration in Azure AD, click Expose an API and then Add a client application).
```
$ echo "$token" >> token
```
- Write the token to a file.
