# Managing User Roles

A user role is a named collection of privileges that you can create and assign to other users.
- About User Roles User roles are useful in a variety of situations, such as restricting DDL usage.
- Predefined Roles in an Oracle Database Installation Oracle Database provides a set of predefined roles to help in database administration.
- Creating a Role You can create a role that is authenticated with or without a password. You also can create external or global roles.
- Specifying the Type of Role Authorization You can configure a role to be authorized through different sources, such the database or an external source.
- Granting and Revoking Roles You can grant or revoke privileges to and from roles, and then grant these roles to users or to other roles.
- Dropping Roles Dropping a role affects the security domains of users or roles who had been granted the role.
* *
- [Restricting SQLPlus Users from Using Database Roles](restricting-sqlplus-users-using-database-roles.html#GUID-14A1A8A2-24AD-44A3-A8F0-FA0D08BF07E8) You should restrict SQLPlus users from using database roles, which helps to safeguard the database from intruder attacks.
- Role Privileges and Secure Application Roles A secure application role can be enabled only by an authorized PL/SQL package or procedure.
