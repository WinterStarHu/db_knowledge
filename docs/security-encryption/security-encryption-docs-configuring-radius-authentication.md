# About Configuring RADIUS Authentication

Oracle Database supports the RADIUS standard for user authentication.
RADIUS is frequently used for multi-factor authentication (MFA) when it is used to access an Oracle database. The specific MFA technologies (such as smart cards or biometric cards) depend on the RADIUS server. The database server and client support asynchronous and synchronous challenges for MFA.
You can use any RADIUS server that complies with the Internet Engineering Task Force (IETF) RFC #2138, Remote Authentication Dial In User Service (RADIUS), and RFC #2139 RADIUS Accounting standards.
Starting with Oracle Database
19.28, new RADIUS APIs were introduced to support Requests for Comments (RFC) 6613 and 6614 guidelines, and updates to RADIUS security with the latest standards.
From an end user’s perspective, the entire authentication process is transparent. When the user seeks access to an Oracle database server, the Oracle database server, acting as the RADIUS client, notifies the RADIUS server. The RADIUS server then:
- Looks up the user’s security information
- Passes authentication and authorization information between the appropriate authentication server or servers and the Oracle database server
- Grants the user access to the Oracle database server
****
````
- Logs session information, including when, how often, and for how long the user was connected to the Oracle database server Note: Oracle Database does not support RADIUS authentication over database links. To configure Oracle Database to use RADIUS, you will modify parameters in the sqlnet.ora file. The settings in sqlnet.ora apply to all pluggable databases (PDBs).
The following figure illustrates the Oracle Database-RADIUS environment.
Description of the illustration asoag003.png
The Oracle Database server acts as the RADIUS client, passing information between the Oracle client and the RADIUS server. Similarly, the RADIUS server passes information between the Oracle database server and the appropriate authentication servers.
A RADIUS server vendor is often the authentication server vendor as well. In this case authentication can be processed on the RADIUS server.
- About Configuring RADIUS Authentication Oracle Database supports the RADIUS standard for user authentication.
- RADIUS Components RADIUS has a set of authentication components that enable you to manage configuration settings.
- RADIUS Authentication Modes The RADIUS server can authenticate users using technologies such as FIDO and text message authentication codes. In addition, Oracle Database supports synchronous and challenge-response (async) authentication modes.
- RADIUS Parameters Oracle provides a set of RADIUS-specific parameters.
- Enabling RADIUS Authentication, Authorization, and Accounting You can enable RADIUS authentication, authorization, and accounting from the command line. RADIUS authentication can either by configured through the modern configuration introduced in Oracle Database 19.28 or the legacy configuration.
- Using RADIUS to Log in to a Database You can use RADIUS to log into a database by using either synchronous authentication mode or challenge-response mode.
## Related Topics
  **- Oracle Database Net Services Reference
