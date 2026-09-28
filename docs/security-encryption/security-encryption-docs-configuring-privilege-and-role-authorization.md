# Configuring Privilege and Role Authorization

Privilege and role authorization controls the permissions that users have to perform day-to-day tasks.
- About Privileges and Roles Authorization permits users to access, process, or alter data; it also creates limitations on user access or actions.
- Who Should Be Granted Privileges? You grant privileges to users so they can accomplish tasks required for their jobs.
- How the Oracle Multitenant Option Affects Privileges In a multitenant environment, all users, including common users, can exercise their privileges only within the current container.
- Managing Administrative Privileges Administrative privileges can be used for both general and specific database operations.
- Managing System Privileges To perform actions on schema objects, you must be granted the appropriate system privileges.
- Managing Commonly and Locally Granted Privileges In a multitenant environment, privileges can be granted commonly for an entire CDB or application container, or granted locally to a specific PDB.
- Managing Common Roles and Local Roles A common role is a role that is created in the root; a local role is created in a PDB.
- Managing User Roles A user role is a named collection of privileges that you can create and assign to other users.
- Restricting Operations on PDBs Using PDB Lockdown Profiles You can use PDB lockdown profiles in a multitenant environment to restrict sets of user operations in pluggable databases (PDBs).
- Managing Object Privileges Object privileges enable you to perform actions on schema objects, such as tables or indexes.
- Table Privileges Object privileges for tables enable table security at the DML or DDL level of operation.
- View Privileges You can apply DML object privileges to views, similar to tables.
- Procedure Privileges The EXECUTE privilege enables users to run procedures and functions, either standalone or in packages.
- Type Privileges You can control system and object privileges for types, methods, and objects.
- Grants of User Privileges and Roles The GRANT statement provides privileges for a user to perform specific actions, such as executing a procedure.
- Revokes of Privileges and Roles from a User When you revoke system or object privileges, be aware of the cascading effects of revoking a privilege.
- Grants and Revokes of Privileges to and from the PUBLIC Role You can grant and revoke privileges and roles from the role PUBLIC.
- Grants of Roles Using the Operating System or Network Using the operating system or network to manage roles can help centralize the role management in a large enterprise.
- How Grants and Revokes Work with SET ROLE and Default Role Settings Privilege grants and the SET ROLE statement affect when and how grants and revokes take place.
- User Privilege and Role Data Dictionary Views You can use special queries to find information about various types of privilege and role grants.
