# About the Application

The script content on this page is for navigation purposes only and does not alter the content in any way.
The application has the following purpose, structure, and naming conventions.
## Purpose of the Application
The application is intended for two kinds of users in a company.
- Typical users (managers of employees)
- Application administrators
Typical users can complete the following tasks:
- Get the employees in a given department
- Get the job history for a given employee
- Show general information for a given employee (name, department, job, manager, salary, and so on)
- Change the salary of a given employee
- Change the job of a given employee
Application administrators can complete the following tasks:
- Change the ID, title, or salary range of an existing job
- Add a new job
- Change the ID, name, or manager of an existing department
- Add a new department
## Structure of the Application
The application uses the following schema objects and schemas.
### Schema Objects of the Application
The application is composed of these schema objects:
  - Jobs
  - Departments
  - Employees
  - Job history of employees
- Four editioning views, which cover the tables, enabling you to use edition-based redefinition (EBR) to upgrade the finished application when it is in use
- Two triggers, which enforce business rules
- Two sequences that generate unique primary keys for new departments and new employees
  - employees_pkg, the application program interface (API) for typical users
  - admin_pkg, the API for application administrators
The typical users and application administrators access the application only through its APIs. Therefore, they can change the data only by invoking package subprograms.
**See Also:**
- “About Oracle Database” for information about schema objects
**
- Oracle Database Development Guide for information about EBR
### Schemas for the Application
For security, the application uses the following five schemas (or users), each of which has *only* the privileges that it needs.
- app_data owns all the schema objects except the packages and loads its tables with data from tables in the sample schema HR The developers who create the packages never work in this schema. Therefore, they cannot accidently alter or drop application schema objects.
- app_code owns only the package employees_pkg The developers of employees_pkg work in this schema.
- app_admin owns only the package admin_pkg The developers of admin_pkg work in this schema.
- app_user, the typical application user, owns nothing and can only run employees_pkg The middle-tier application server connects to the database in the connection pool as app_user. If this schema is compromised—by a SQL injection bug, for example—the attacker can see and change only what employees_pkg subprograms let it see and change. The attacker cannot drop tables, escalate privileges, create or alter schema objects, or anything else.
- app_admin_user, an application administrator, owns nothing and can only run admin_pkg and employees_pkg The connection pool for this schema is very small, and only privileged users can access it. If this schema is compromised, the attacker can see and change only what admin_pkg and employees_pkg subprograms let it see and change.
Suppose that instead of app_user and app_admin_user, the application had only one schema that owned nothing and could execute both employees_pkg and admin_pkg. The connection pool for this schema would have to be large enough for both the typical users and the application administrators. If there were a SQL injection bug in employees_pkg, a typical user who exploited that bug could access admin_pkg.
Suppose that instead of app_data, app_code, and app_admin, the application had only one schema that owned all the schema objects, including the packages. The packages would then have all privileges on the tables, which would be both unnecessary and undesirable.
For example, suppose that you have an audit trail table, AUDIT_TRAIL. You want the developers of employees_pkg to be able to write to AUDIT_TRAIL, but not read or change it. You want the developers of admin_pkg to be able to read AUDIT_TRAIL and write to it, but not change it. If AUDIT_TRAIL, employees_pkg, and admin_pkg belong to the same schema, then the developers of the two packages have all privileges on AUDIT_TRAIL. However, if AUDIT_TRAIL belongs to app_data, employees_pkg belongs to app_code, and admin_pkg belongs to app_admin, then you can connect to the database as app_data and do this:
```
GRANT INSERT ON AUDIT_TRAIL TO app_code;
GRANT INSERT, SELECT ON AUDIT_TRAIL TO app_admin;
```
**See Also:**
- “About Oracle Database” for information about schemas
- “About Sample Schema HR” for information about sample schema HR
- “Recommended Security Practices”
## Naming Conventions in the Application
The application uses these naming conventions.

| Item | Name |
|---|---|
| Table | table# |
| Editioning view for table# | table |
| Trigger on editioning view table | table_{a\|b}event[_fer] where: a identifies an AFTER trigger.b identifies a BEFORE trigger.fer identifies a FOR EACH ROW trigger.event identifies the event that fires the trigger. For example: i for INSERT, iu for INSERT or UPDATE, d for DELETE. |
| PRIMARY KEY constraint in table# | table_pk |
| NOT NULL constraint on table#.column | table_column_not_null (Footnote 1) |
| UNIQUE constraint on table#.column | table_column_unique (Footnote 1) |
| CHECK constraint on table#.column | table_column_check (Footnote 1) |
| REF constraint on table1#.column to table2#.column | table1_to_table2_fk (Footnote 1) |
| REF constraint on table1#.column1 to table2#.column2 | table1_col1totable2_col2_fk (Footnote 1) (Footnote 2) |
| Sequence for table# | table_sequence |
| Parameter name | p_name |
| Local variable name | l_name |

**Footnote 1:** *table*, *table1*, and *table2* are abbreviated to emp for employees, dept for departments, and job_hist for job_history.
**Footnote 2:** *col1* and *col2* are abbreviations of column names *column1* and *column2*. A constraint name cannot have more than 30 characters.
