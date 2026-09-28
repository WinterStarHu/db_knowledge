# Integrating Authentication Devices Using RADIUS

The RADIUS challenge-response user interface further enhances authentication in a RADIUS configuration.
- About the RADIUS Challenge-Response User Interface You can use third-party authentication vendors to customize the RADIUS challenge-response user interface to fit a particular device.
- Customizing the RADIUS Challenge-Response User Interface You can customize OracleRadiusInterface interface by creating your own class.
- Example: Using the OracleRadiusInterface Interface You can use the OracleRadiusInterface interface to retrieve a user name and password.
## About the RADIUS Challenge-Response User Interface
You can use third-party authentication vendors to customize the RADIUS challenge-response user interface to fit a particular device.
You can set up any authentication device that supports the RADIUS standard to authenticate Oracle users. When your authentication device uses the challenge-response mode, a graphical interface prompts the end user first for a password and then for additional information (for example, a dynamic password that the user obtains from a token card). This interface is Java-based to provide optimal platform independence.
Third-party vendors of authentication devices must customize this graphical user interface to fit their particular device. For example, a smart card vendor customizes the Oracle client to issue the challenge to the smart card reader. Then, when the smart card receives a challenge, it responds by prompting the user for more information, such as a PIN.
## Customizing the RADIUS Challenge-Response User Interface
You can customize `OracleRadiusInterface` interface by creating your own class.
**````````
- Open the sqlnet.ora file. By default, the sqlnet.ora file is located in the ORACLE_HOME/network/admin directory or in the location set by the TNS_ADMIN environment variable. Ensure that you have properly set the TNS_ADMIN variable to point to the correct sqlnet.ora file.
````
- Locate the SQLNET.RADIUS_AUTHENTICATION_INTERFACE parameter, and replace the name of the class listed there (DefaultRadiusInterface), with the name of the new class that you have created. When you make this change in the sqlnet.ora file, the class is loaded on the Oracle client in order to handle the authentication process.
- Save and exit the sqlnet.ora file
The third party must implement the `OracleRadiusInterface` interface, which is located in the `ORACLE.NET.RADIUS` package.
## Example: Using the OracleRadiusInterface Interface
You can use the OracleRadiusInterface interface to retrieve a user name and password.
Example D-1 shows how to use the `OracleRadiusInterface` interface.
Example D-1 Using the OracleRadiusInterface Interface
```
public interface OracleRadiusInterface { public void radiusRequest();
public void radiusChallenge(String challenge);
public String getUserName();
public String getPassword();
}
```
In this specification:
``````
- radiusRequest prompts the end user for a user name and password, which will later be retrieved through getUserName and getPassword.
- getUserName extracts the user name the user enters. If this method returns an empty string, it is assumed that the user wants to cancel the operation. The user then receives a message indicating that the authentication attempt failed.
``````
- getPassword extracts the password the user enters. If getUserName returns a valid string, but getPassword returns an empty string, the challenge keyword is replaced as the password by the database. If the user enters a valid password, a challenge may or may not be returned by the RADIUS server.
- radiusChallenge presents a request sent from the RADIUS server for the user to respond to the server’s challenge.
``````
- getResponse extracts the response the user enters. If this method returns a valid response, then that information populates the User-Password attribute in the new Access-Request packet. If an empty string is returned, the operation is aborted from both sides by returning the corresponding value.
## Related Topics
  - Configuring RADIUS Authentication
**- SQLPlus User’s Guide and Reference* for more information and examples of setting the TNS_ADMIN variable
