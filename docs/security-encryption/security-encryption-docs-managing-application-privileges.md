# Managing Application Privileges

Most database applications involve different privileges on different schema objects.
Keeping track of the privileges that are required for each application can be complex. In addition, authorizing users to run an application can involve many `GRANT` operations.
- To simplify application privilege management, create a role for each application and grant that role all the privileges a user must run the application. In fact, an application can have several roles, each granted a specific subset of privileges that allow greater or lesser capabilities while running the application.
For example, suppose every administrative assistant uses the Vacation application to record the vacation taken by members of the department. To best manage this application, you should:
- Create a VACATION role.
- Grant all privileges required by the Vacation application to the VACATION role.
````
- Grant the VACATION role to all administrative assistants. Better yet, create a role that defines the privileges the administrative assistants have, and then grant the VACATION role to that role.
## Related Topics
  - Configuring Privilege and Role Authorization, for a complete discussion of creating, enabling, and disabling roles, and granting and revoking privileges
  ``````- User Privilege and Role Data Dictionary Views for more information about the security uses of the ROLE_TAB_PRIVS, ROLE_SYS_PRIVS, and DBA_ROLE_PRIVS data dictionary views
