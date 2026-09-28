# Global User Authentication and Authorization

Global user authentication and authorization enables you to centralize the management of user-related information.
- About Configuring Global User Authentication and Authorization An LDAP-based directory service centralizes the management of user-related information, including authorizations.
- Configuration of Users Who Are Authorized by a Directory Service You can configure either a global user or multiple enterprise users to be authorized by a directory service.
- Advantages of Global Authentication and Global Authorization There are several advantages of global user authentication and authorization.
## About Configuring Global User Authentication and Authorization
An LDAP-based directory service centralizes the management of user-related information, including authorizations.
This enables users and administrators to be identified in the database as global users, meaning that they are authenticated by TLS and that the management of these users is handled outside of the database by the centralized directory service. Global roles are defined in a database and are known only to that database, but the directory service handles authorizations for global roles.
**Note:**   You can also have users authenticated by Transport Layer Security (TLS), whose authorizations are not managed in a directory, that is, they have local database roles only.
This centralized management enables the creation of **enterprise users** and **enterprise roles**. Enterprise users are defined and managed in the directory. They have unique identities across the enterprise and can be assigned enterprise roles that determine their access privileges across multiple databases. An enterprise role consists of one or more global roles, and might be thought of as a container for global roles.
You also can use centrally managed users to authenticate and authorize users through a directory service such as Microsoft Active Directory.
## Configuration of Users Who Are Authorized by a Directory Service
You can configure either a global user or multiple enterprise users to be authorized by a directory service.
********
- Creating a Global User Who Has a Private Schema You can create a user account who has a private schema by providing an identifier (distinguished name, or DN) meaningful to the enterprise directory.
- Creating Multiple Enterprise Users Who Share Schemas Multiple enterprise users can share a single schema in the database.
### Creating a Global User Who Has a Private Schema
You can create a user account who has a private schema by providing an identifier (**distinguished name**, or **DN**) meaningful to the enterprise directory.
However, be aware that you must create this user in every database that the user must access, plus the directory.
- To create a global user who has a private schema, use the CREATE USER ... IDENTIFIED GLOBALLY SQL statement. You can include standard LDAP Data Interchange Format (LDIF) fields. For example, to create a global user (psmith_gl with a private schema, authenticated by SSL, and authorized by the enterprise directory service:
```
CREATE USER psmith_gl IDENTIFIED GLOBALLY AS 'CN=psmith,OU=division1,O=example,C=US';
```
In this specification:
````
- CN refers to the common name of this user, psmith_gl.
````
- OU refers to the user’s organizational unit, division1.
````
- O refers to the user’s organization, Example.
````
- C refers to the country in which the organization Example is located, the US.
### Creating Multiple Enterprise Users Who Share Schemas
Multiple enterprise users can share a single schema in the database.
These users are authorized by the enterprise directory service but do not own individual private schemas in the database. These users are not individually created in the database. They connect to a shared schema in the database.
  - Create a shared schema in the database using the following example:
```
CREATE USER appschema IDENTIFIED GLOBALLY AS '';
```
```
OU=division1,O=Example,C=US
```
**
- In the directory, create multiple enterprise users and a mapping object. The mapping object tells the database how you want to map the DNs for the users to the shared schema. You can either create a full distinguished name (DN) mapping (one directory entry for each unique DN), or you can map, for each user, multiple DN components to one schema. For example: See Oracle Database Enterprise User Security Administrator’s Guide for an explanation of these mappings.
Most users do not need their own schemas, and implementing schema-independent users separates users from databases. You create multiple users who share the same schema in a database, and as enterprise users, they can also access shared schemas in other databases.
## Advantages of Global Authentication and Global Authorization
There are several advantages of global user authentication and authorization.
- Provides strong authentication using SSL, Kerberos, or Windows native authentication.
- Enables centralized management of users and privileges across the enterprise.
- Is easy to administer: You do not have to create a schema for every user in every database in the enterprise.
- Facilitates single sign-on: Users need to sign on once to only access multiple databases and services. Further, users using passwords can have a single password to access multiple databases accepting password-authenticated enterprise users.
- Because global user authentication and authorization provide password-based access, you can migrate previously defined password-authenticated database users to the directory (using the User Migration Utility) to be centrally administered. This makes global authentication and authorization available for earlier Oracle Database release clients that are still supported.
- CURRENT_USER database links connect as a global user. A local user can connect as a global user in the context of a stored procedure, that is, without storing the global user password in a link definition.
## Related Topics
  - Configuring Transport Layer Security Encryption
  - Strong Authentication, Centralized Management for Administrators
  - Configuring Centrally Managed Users with Microsoft Active Directory
**- Oracle Database Enterprise User Security Administrator’s Guide
