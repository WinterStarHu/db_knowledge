# Who Should Be Granted Privileges?

You grant privileges to users so they can accomplish tasks required for their jobs.
You should grant a privilege only to a user who requires that privilege to accomplish the necessary work. Excessive granting of unnecessary privileges can compromise security. For example, you never should grant `SYSDBA` or `SYSOPER` administrative privilege to users who do not perform administrative tasks.
You can grant privileges to a user in two ways:
****````
- You can grant privileges to users explicitly. For example, you can explicitly grant to user psmith the privilege to insert records into the employees table.
****````````
- You can grant privileges to a role (a named group of privileges), and then grant the role to one or more users. For example, you can grant the privileges to select, insert, update, and delete records from the employees table to the role named clerk, which in turn you can grant to users psmith and robert.
Because roles allow for easier and better management of privileges, you should usually grant privileges to roles and not to specific users.
## Related Topics
  - Guidelines for Securing User Accounts and Privileges for best practices to follow when granting privileges
**- Oracle Database Vault Administrator’s Guide if you are concerned about excessive privilege grants **- Oracle Database SQL Language Reference for the complete list of system privileges and their descriptions
