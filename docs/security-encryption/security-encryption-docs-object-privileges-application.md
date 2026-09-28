# Object Privileges in an Application

The script content on this page is for navigation purposes only and does not alter the content in any way.
When you design an application, consider the types of users and the level access they need.
- What Application Developers Must Know About Object Privileges Object privileges enable end users to perform actions on objects such as tables, views, sequences, procedures, functions, or packages.
- SQL Statements Permitted by Object Privileges As you implement and test your application, you should create each necessary role.
## What Application Developers Must Know About Object Privileges
Object privileges enable end users to perform actions on objects such as tables, views, sequences, procedures, functions, or packages.
The following table summarizes the object privileges available for each type of object.

| Object Privilege | Applies to Table? | Applies to View? | Applies to Sequence? | Applies to Procedure?1 |
|---|---|---|---|---|
| ALTER | Yes | No | Yes | No |
| DELETE | Yes | Yes | No | No |
| EXECUTE | No | No | No | Yes |
| INDEX | Yes2 | No | No | No |
| INSERT | Yes | Yes | No | No |
| REFERENCES | Yes2 | No | No | No |
| SELECT | Yes | Yes3 | Yes | No |
| UPDATE | Yes | Yes | No | No |

## SQL Statements Permitted by Object Privileges
As you implement and test your application, you should create each necessary role.
Test the usage scenario for each role to ensure that the users of your application will have proper access to the database. After completing your tests, coordinate with the administrator of the application to ensure that each user is assigned the proper roles.
The following table lists the SQL statements permitted by the object privileges shown in the preceding table.

| Object Privilege | SQL Statements Permitted |
|---|---|
| ALTER | ALTER object (table or sequence); CREATE TRIGGER ON object (tables only) |
| DELETE | DELETE FROM object (table, view, or synonym) |
| EXECUTE | EXECUTE object (procedure or function); references to public package variables |
| INDEX | CREATE INDEX ON object (table, view, or synonym) |
| INSERT | INSERT INTO object (table, view, or synonym) |
| REFERENCES | CREATE or ALTER TABLE statement defining a FOREIGN KEY integrity constraint on object (tables only) |
| SELECT | SELECT…FROM object (table, view, synonym, or snapshot); SQL statements using a sequence |

## Related Topics
  - Auditing Object Actions
  - About Privileges and Roles
- Standalone stored procedures, functions, and public package constructs ↩
- Privilege that cannot be granted to a role ↩ ↩2
- Can also be granted for snapshots ↩
