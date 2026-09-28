# Creating Global Application Contexts

The `CREATE CONTEXT` SQL statement creates the global application context, which is then located in the `SYS` schema.
- Ownership of the Global Application Context A global application context is owned by the SYS schema.
- Creating a Global Application Context As with local application contexts, the global application context is created and stored in the security administrator’s database schema.
## Ownership of the Global Application Context
A global application context is owned by the `SYS` schema.
The ownership of the global application context is as follows: Even though a user who has been granted the `CREATE ANY CONTEXT` and `DROP ANY CONTEXT` privileges can create and drop the global application context, it is owned by the `SYS` schema.
Oracle Database associates the context with the schema account that created it, but if you drop this user, the context still exists in the `SYS` schema. As user `SYS`, you can drop the application context.
## Creating a Global Application Context
As with local application contexts, the global application context is created and stored in the security administrator’s database schema.
You must have the `CREATE ANY CONTEXT` system privilege before you can create a global application context, and the `DROP ANY CONTEXT` privilege before you can drop the context with the `DROP CONTEXT` statement.
  ````- To create a global application context, use the CREATE CONTEXT SQL statement to create the application context and include the ACCESSED GLOBALLY clause in the statement.
For example:
```
CREATE OR REPLACE CONTEXT global_hr_ctx USING hr_ctx_pkg ACCESSED GLOBALLY CONTAINER = ALL;
```
