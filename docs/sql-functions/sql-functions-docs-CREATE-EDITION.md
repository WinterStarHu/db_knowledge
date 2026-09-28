# CREATE EDITION

## Purpose
This statement creates a new edition as a child of an existing edition. An edition makes it possible to have two or more versions of the same editionable objects in the database. When you create an edition, it immediately inherits all of the editionable objects of its parent edition. The following object types are editionable:
- Synonym
- View
- Function
- Procedure
- Package (specification and body)
- Type (specification and body)
- Library
- Trigger
An editionable object is an object of one of the above editionable object types in an editions-enabled schema. The ability to have multiple versions of these objects in the database greatly facilitates online application upgrades.
**Note:**   All database object types not listed above are not editionable. Changes to object types that are not editionable are immediately visible across all editions in the database.
Every newly created or upgraded Oracle Database has one default edition named `ORA$BASE`, which serves as the parent of the first edition created with a `CREATE` `EDITION` statement. You can subsequently designate a user-defined edition as the database default edition using an `ALTER` `DATABASE` `DEFAULT` `EDITION` statement.
**See Also:** **
- Oracle Database Development Guide for a more complete discussion of editionable object types and editions
````
- The ALTER DATABASE “DEFAULT EDITION Clause” for information on designating an edition as the default edition for the database
## Prerequisites
To create an edition, you must have the `CREATE` `ANY` `EDITION` system privilege, granted either directly or through a role. To create an edition as a child of another edition, you must have the `USE` object privilege on the parent edition.
## Syntax
## *create_edition*::=
Description of the illustration create_edition.eps
## Semantics
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the edition does not exist, a new one is created at the end of the statement.
- If the edition exists, it is detected and a new one is not created.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## *edition*
Specify the name of the edition to be created. The name must satisfy the requirements listed in “Database Object Naming Rules”.
To view the editions that have been created for the database, query the `EDITION_NAME` column of the `DBA_OBJECTS` or `ALL_OBJECTS` data dictionary view.
When you create an edition, the system automatically grants you the `USE` object privilege `WITH` `GRANT` `OPTION` on the edition you create.
 **Note:**   Oracle strongly recommends that you do not name editions with the prefixes `ORA`, `ORACLE`, `SYS`, `DBA`, and `DBMS`, as these prefixes are reserved for internal use.
## AS CHILD OF Clause
If you use this clause, then the new edition is created as a child of *parent_edition*. If you omit this clause, then the new edition is created as a child of the leaf edition. At the time of its creation, the new edition inherits all editioned objects from its parent edition.
**Restriction on Editions**
An edition can have only one child edition. If you specify for *parent_edition* an edition that already has a child edition, then an error is returned.
## Examples
The following very simple examples are intended to show the syntax for creating and working with an edition. For realistic examples of using editions refer to *Oracle Database Development Guide*.
In the following statements, the user `HR` is given the privileges needed to create and use an edition:
```
GRANT CREATE ANY EDITION, DROP ANY EDITION to HR;
Grant succeeded.
ALTER USER hr ENABLE EDITIONS;
User altered.
```
`HR` creates a new edition `TEST_ED` for testing purposes:
```
CREATE EDITION test_ed;
```
`HR` then creates an editioning view `ed_view` in the default edition `ORA$BASE` for testing purposes, first verifying that the current edition is the default edition:
```
SELECT SYS_CONTEXT('userenv', 'current_edition_name') FROM DUAL;
SYS_CONTEXT('USERENV','CURRENT_EDITION_NAME')
--------------------------------------------------------------------------------
ORA$BASE 1 row selected.
CREATE EDITIONING VIEW e_view AS SELECT last_name, first_name, email FROM employees;
View created.
DESCRIBE e_view Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
LAST_NAME                                 NOT NULL VARCHAR2(25) FIRST_NAME                                         VARCHAR2(20) EMAIL                                     NOT NULL VARCHAR2(25)
```
The view is then actualized in the `TEST_ED` edition when `HR` uses the `TEST_ED` edition and re-creates the view in a different form:
```
ALTER SESSION SET EDITION = TEST_ED;
Session altered.
CREATE OR REPLACE EDITIONING VIEW e_view AS SELECT last_name, first_name, email, salary FROM employees;
View created.
```
The view in the `TEST_ED` edition has an additional column:
```
DESCRIBE e_view Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
LAST_NAME                                 NOT NULL VARCHAR2(25) FIRST_NAME                                         VARCHAR2(20) EMAIL                                     NOT NULL VARCHAR2(25) SALARY                                             NUMBER(8,2)
```
The view in the `ORA$BASE` edition remains isolated from the test environment:
```
ALTER SESSION SET EDITION = ora$base;
Session altered.
DESCRIBE e_view;
Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
LAST_NAME                                 NOT NULL VARCHAR2(25) FIRST_NAME                                         VARCHAR2(20) EMAIL                                     NOT NULL VARCHAR2(25)
```
Even if the view is dropped in the test environment, it remains in the `ORA$BASE` edition:
```
ALTER SESSION SET EDITION = TEST_ED;
Session altered.
DROP VIEW e_view;
View dropped.
ALTER SESSION SET EDITION = ORA$BASE;
Session altered.
DESCRIBE e_view;
Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
LAST_NAME                                 NOT NULL VARCHAR2(25) FIRST_NAME                                         VARCHAR2(20) EMAIL                                     NOT NULL VARCHAR2(25)
```
When the testing of upgrade that necessitated the `TEST_ED` edition is complete, the edition can be dropped:
```
DROP EDITION TEST_ED;
```
