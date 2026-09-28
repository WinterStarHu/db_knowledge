# Global Application Contexts

You can use a global application context to access application values across database sessions, including an Oracle Real Application Clusters environment.
- About Global Application Contexts A global application context enables application context values to be accessible across database sessions, including Oracle RAC instances.
- Uses for Global Application Contexts There are three general uses for global application contexts.
- Components of a Global Application Context A global application context uses a package to manage its attributes and middle-tier application to manage the client session ID.
- Global Application Contexts in an Oracle Real Application Clusters Environment In an Oracle RAC environment, whenever a global application context is loaded or changed, it is visible only to the existing active instances.
````
- Creating Global Application Contexts The CREATE CONTEXT SQL statement creates the global application context, which is then located in the SYS schema.
- PL/SQL Package to Manage a Global Application Context The DBMS_SESSION PL/SQL package to manages global application contexts.
- Embedding Calls in Middle-Tier Applications to Manage the Client Session ID You can embed calls in middle-tier applications to manage client session IDs.
- Tutorial: Creating a Global Application Context That Uses a Client Session ID This tutorial demonstrates how you can create a global application context that uses a client session ID.
- Global Application Context Processes A simple global application context uses a database user account create the user session; a global application context is for lightweight users.
