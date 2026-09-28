# Using Database Session-Based Application Contexts

A database session-based application context enables you to retrieve session-based information about a user.
- About Database Session-Based Application Contexts A database session-based application context retrieves session information for database users.
- Components of a Database Session-Based Application Context A database session-based application context retrieves and sets data for the context and then sets this context when a user logs in.
- Creating Database Session-Based Application Contexts A database session-based application context is a named object that stores the user’s session information.
- Creating a Package to Set a Database Session-Based Application Context A PL/SQL package can be used to retrieve the session information and set the name-value attributes of the application context.
- Logon Triggers to Run a Database Session Application Context Package Users must run database session application context package after when they log in to the database instance.
- Example: Creating a Simple Logon Trigger The CREATE TRIGGER statement can create a simple logon trigger.
- Example: Creating a Logon Trigger for a Production Environment The CREATE TRIGGER statement can create a logon trigger for a production environment.
- Example: Creating a Logon Trigger for a Development Environment The CREATE TRIGGER statement can create a logon trigger for a development environment.
- Tutorial: Creating and Using a Database Session-Based Application Context This tutorial demonstrates how to create an application context that checks the ID of users who try to log in to the database.
- Initializing Database Session-Based Application Contexts Externally Initializing database session-based application contexts externally increases performance because the application context is stored in the user global area (UGA).
- Initializing Database Session-Based Application Contexts Globally When a database session-based application is stored in a centralized location, it can be used globally from an LDAP directory.
- Externalized Database Session-Based Application Contexts Many applications store attributes used for fine-grained access control within a database metadata table.
