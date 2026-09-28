# Managing Security for Application Developers

A security policy for application developers should encompass areas such as password management and securing external procedures and application privileges.
- About Application Security Policies An application security policy is a list of application security requirements and rules that regulate user access to database objects.
- Considerations for Using Application-Based Security An application security implementation should consider both application and database users and whether to enforce security in the application or in the database.
- Securing Passwords in Application Design Oracle provides strategies for securely invoking password services, such as from scripts, and for applying these strategies to other sensitive data.
````
- Securing External Procedures An external procedure is stored in a .dll or an .so file, separately from the database, and can be through a credential authentication.
- Securing LOBs with LOB Locator Signatures You can secure large objects (LOB) by regenerating their LOB locator signatures.
- Managing Application Privileges Most database applications involve different privileges on different schema objects.
- Advantages of Using Roles to Manage Application Privileges Grouping application privileges in a role aids privilege management.
- Creating Secure Application Roles to Control Access to Applications A secure application role is only enabled through its associated PL/SQL package or procedure.
- Association of Privileges with User Database Roles Ensure that users have only the privileges associated with the current database role.
- Protecting Database Objects by Using Schemas A schema is a security domain that can contain database objects. Privileges granted to users and roles control access to these database objects.
- Object Privileges in an Application When you design an application, consider the types of users and the level access they need.
- Parameters for Enhanced Security of Database Communication Parameters can be used to manage security, such as handling bad packets from protocol errors or configuring the maximum number of authentication errors.
