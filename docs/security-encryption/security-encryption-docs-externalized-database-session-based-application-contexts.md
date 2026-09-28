# Externalized Database Session-Based Application Contexts

Many applications store attributes used for fine-grained access control within a database metadata table.
For example, an `employees` table could include cost center, title, signing authority, and other information useful for fine-grained access control. Organizations also centralize user information for user management and access control in LDAP-based directories, such as Oracle Internet Directory. Application context attributes can be stored in Oracle Internet Directory, and assigned to one or more enterprise users. They can also be retrieved automatically upon login for an enterprise user, and then used to initialize an application context.
## Related Topics
  - Initializing Database Session-Based Application Contexts Externally for information about initializing local application context through external resources such as an OCI interface, a job queue process, or a database link
  - Initializing Database Session-Based Application Contexts Globally for information about initializing local application context through a centralized resource, such as Oracle Internet Directory
**- Oracle Database Enterprise User Security Administrator’s Guide for information about enterprise users
