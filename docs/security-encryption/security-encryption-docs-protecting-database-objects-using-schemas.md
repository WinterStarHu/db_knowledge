# Protecting Database Objects by Using Schemas

A schema is a security domain that can contain database objects. Privileges granted to users and roles control access to these database objects.
**Caution:**  `PUBLIC` is not a valid schema for application-owned objects. Create application objects in a dedicated application schema or schema-only account, and grant access through roles or explicit object privileges.
- Protecting Database Objects in a Unique Schema Think of most schemas as user names: the accounts that enable users to connect to a database and access the database objects.
- Protection of Database Objects in a Shared Schema For many applications, users only need access to an application schema; they do not need their own accounts or schemas in the database.
## Protecting Database Objects in a Unique Schema
Think of most schemas as user names: the accounts that enable users to connect to a database and access the database objects.
However, a *unique schema* does not allow connections to the database, but is used to contain a related set of objects. Schemas of this sort are created as typical users, and yet are not granted the `CREATE` `SESSION` system privilege (either explicitly or through a role).
  ``````````- To protect the objects, temporarily grant the CREATE SESSION and RESOURCE privilege to a unique schema if you want to use the CREATE SCHEMA statement to create multiple tables and views in a single transaction.
For example, a given schema might own the schema objects for a specific application. If application users have the privileges to do so, then they can connect to the database using typical database user names and use the application and the corresponding objects. However, no user can connect to the database using the schema set up for the application. This configuration prevents access to the associated objects through the schema, and provides another layer of protection for schema objects. In this case, the application could issue an `ALTER SESSION SET CURRENT_SCHEMA` statement to connect the user to the correct application schema.
## Protection of Database Objects in a Shared Schema
For many applications, users only need access to an application schema; they do not need their own accounts or schemas in the database.
For example, users John, Firuzeh, and Jane are all users of the Payroll application, and they need access to the `payroll` schema on the `finance` database. None of them need to create their own objects in the database. They need to only access the `payroll` objects. To address this issue, Oracle Database provides the enterprise users, which are schema-independent users.
Enterprise users, users managed in a directory service, do not need to be created as database users because they use a shared database schema. To reduce administration costs, you can create an enterprise user once in the directory, and point the user at a shared schema that many other enterprise users can also access.
## Related Topics
  **- Oracle Database Enterprise User Security Administrator’s Guide for more information about managing enterprise users
