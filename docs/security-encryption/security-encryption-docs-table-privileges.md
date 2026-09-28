# Table Privileges

Object privileges for tables enable table security at the DML or DDL level of operation.
````````
- How Table Privileges Affect Data Manipulation Language Operations You can grant privileges to use the DELETE, INSERT, SELECT, and UPDATE DML operations on tables and views.
``````
- How Table Privileges Affect Data Definition Language Operations The ALTER, INDEX, and REFERENCES privileges allow DDL operations to be performed on a table.
## How Table Privileges Affect Data Manipulation Language Operations
You can grant privileges to use the `DELETE`, `INSERT`, `SELECT`, and `UPDATE` DML operations on tables and views.
Grant these privileges only to users and roles that need to query or manipulate data in a table.
You can restrict `INSERT` and `UPDATE` privileges for a table to specific columns of the table. With a selective `INSERT` privilege, a privileged user can insert a row with values for the selected columns. All other columns receive `NULL` or the default value of the column. With a selective `UPDATE` privilege, a user can update only specific column values of a row. You can use selective `INSERT` and `UPDATE` privileges to restrict user access to sensitive data.
For example, if you do not want data entry users to alter the `salary` column of the `employees` table, then selective `INSERT` or `UPDATE` privileges can be granted that exclude the `salary` column. Alternatively, a view that excludes the `salary` column could satisfy this need for additional security.
## How Table Privileges Affect Data Definition Language Operations
The `ALTER`, `INDEX`, and `REFERENCES` privileges allow DDL operations to be performed on a table.
Because these privileges allow other users to alter or create dependencies on a table, you should grant these privileges conservatively. A user attempting to perform a DDL operation on a table may need additional system or object privileges. For example, to create a trigger on a table, the user requires both the `ALTER` `TABLE` object privilege for the table and the `CREATE` `TRIGGER` system privilege.
As with the `INSERT` and `UPDATE` privileges, you can grant the `REFERENCES` privilege on specific columns of a table. The `REFERENCES` privilege enables the grantee to use the table on which the grant is made as a parent key to any foreign keys that the grantee wishes to create in his or her own tables. This action is controlled with a special privilege because the presence of foreign keys restricts the data manipulation and table alterations that can be done to the parent key. A column-specific `REFERENCES` privilege restricts the grantee to using the named columns (which, of course, must include at least one primary or unique key of the parent table).
## Related Topics
**- Oracle Database SQL Language Reference for more information about DML operations **- Oracle Database Concepts for more information about how data integrity works with primary keys, unique keys, and integrity constraints
