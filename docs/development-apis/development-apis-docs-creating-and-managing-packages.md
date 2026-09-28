# Creating and Managing Packages

You can create and manage PL/SQL packages.
**See Also:**   “Tutorial: Declaring Variables and Constants in a Subprogram”, which shows how to change a package body
## About Package Structure
A package always has a specification, and usually has a body. The specification defines the package itself, and is an application program interface (API). The body defines the queries for the declared cursors, and the code for the subprograms, that are declared in the package specification.
The **package specification** defines the package, declaring the types, variables, constants, exceptions, declared cursors, and subprograms that can be referenced from outside the package. A package specification is an **application program interface (API)** : It has all the information that client programs need to invoke its subprograms, but no information about their implementation.
The **package body** defines the queries for the declared cursors, and the code for the subprograms, that are declared in the package specification (therefore, a package with neither declared cursors nor subprograms does not need a body). The package body can also define **local subprograms** , which are not declared in the specification and can be invoked only by other subprograms in the package. Package body contents are hidden from client programs. You can change the package body without invalidating the applications that call the package.
**See Also:** **
- Oracle Database PL/SQL Language Reference for more information about the package specification
**
- Oracle Database PL/SQL Language Reference for more information about the package body
## Tutorial: Creating a Package Specification
This tutorial shows how to use the Create Package tool to create a specification for a package named EMP_EVAL, which appears in many tutorials and examples in this document.
To create a package specification, use either the SQL Developer tool Create Package or the DDL statement CREATE PACKAGE.
**Steps to create a package specification using Create Package tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Packages.
****
- In the list of choices, click New Package. The Create Package window opens. The field Schema has the value HR, the field Name has the default value PACKAGE1, and the check box Add New Source In Lowercase is deselected.
- For Schema, accept the default value, HR.
- For Name, change the value PACKAGE1 to EMP_EVAL.
```
 CREATE OR REPLACE PACKAGE emp_eval AS
 /* TODO enter package declarations (types, exceptions, methods etc) here */
 END emp_eval;
```
- Click OK. The EMP_EVAL pane opens, showing the CREATE PACKAGE statement that created the package: The title of the pane is in italic font, indicating that the package is not saved to the database.
- (Optional) In the CREATE PACKAGE statement, replace the comment with declarations. If you do not do this step now, you can do it later, as in “Tutorial: Changing a Package Specification”.
****
- From the File menu, select Save. Oracle Database compiles the package and saves it. The title of the EMP_EVAL pane is no longer in italic font.
**See Also:**   *Oracle Database PL/SQL Language Reference* for information about the CREATE PACKAGE statement (for the package specification)
## Tutorial: Changing a Package Specification
This tutorial shows how to use the Edit tool to change the specification for the EMP_EVAL package, which appears in many tutorials and examples in this document. Specifically, the tutorial shows how to add declarations for a procedure, EVAL_DEPARTMENT, and a function, CALCULATE_SCORE.
To change a package specification, use either the SQL Developer tool Edit or the DDL statement CREATE PACKAGE with the OR REPLACE clause.
**Steps to change EMP_EVAL package specification using the Edit tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Packages.
****
- In the list of packages, right-click EMP_EVAL.
****
```
 CREATE OR REPLACE PACKAGE emp_eval AS
 /* TODO enter package declarations (types, exceptions, methods etc) here */
 END emp_eval;
```
- In the list of choices, click Edit. The EMP_EVAL pane opens, showing the CREATE PACKAGE statement that created the package: The title of the pane is not in italic font, indicating that the package is saved in the database.
```
 PROCEDURE eval_department ( dept_id IN NUMBER );
 FUNCTION calculate_score ( evaluation_id IN NUMBER
                         , performance_id IN NUMBER)
                         RETURN NUMBER;
```
- In the EMP_EVAL pane, replace the comment with this code: The title of the EMP_EVAL pane changes to italic font, indicating that the changes have not been saved to the database.
****
- Click the icon Compile. The changed package specification compiles and is saved to the database. The title of the EMP_EVAL pane is no longer in italic font.
**See Also:**   *Oracle Database PL/SQL Language Reference* for information about the CREATE PACKAGE statement with the `OR` `REPLACE` clause
## Tutorial: Creating a Package Body
This tutorial shows how to use the Create Body tool to create a body for the EMP_EVAL package, which appears in many examples and tutorials in this document.
To create a package body, use either the SQL Developer tool Create Body or the DDL statement CREATE PACKAGE BODY.
**Steps to create a body for the package EMP_EVAL using the Create Body tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Packages.
****
- In the list of packages, right-click EMP_EVAL.
****
```
 CREATE OR REPLACE
 PACKAGE BODY EMP_EVAL AS
 PROCEDURE eval_department(dept_id IN NUMBER) AS
 BEGIN
     -- TODO implementation required for PROCEDURE EMP_EVAL.eval_department
     NULL;
 END eval_department;
 FUNCTION calculate_score ( evaluation_id IN NUMBER
                         , performance_id IN NUMBER)
                         RETURN NUMBER AS
 BEGIN
     -- TODO implementation required for FUNCTION EMP_EVAL.calculate_score
     RETURN NULL;
 END calculate_score;
 END EMP_EVAL;
```
- In the list of choices, click Create Body. The EMP_EVAL Body pane appears, showing the automatically generated code for the package body: The title of the pane is in italic font, indicating that the code is not saved in the database.
  - Replace the comments with executable statements.
  - (Optional) In the executable part of the procedure, either delete NULL or replace it with an executable statement.
  - (Optional) In the executable part of the function, either replace NULL with another expression.
If you do not complete this step now, you can do it later, as in “Tutorial: Declaring Variables and Constants in a Subprogram”.
****
- Click the icon Compile. The changed package body compiles and is saved to the database. The title of the EMP_EVAL Body pane is no longer in italic font.
**See Also:**   *Oracle Database PL/SQL Language Reference* for information about the CREATE PACKAGE BODY statement (for the package body)
## Dropping a Package
To drop a package (both specification and body), use either the SQL Developer Connections frame and Drop tool, or the DDL statement DROP PACKAGE.
**Caution:**   Do not drop the package EMP_EVAL—you need it for later tutorials. If you want to practice dropping packages, create simple ones and then drop them.
**Steps to drop a package using the Drop tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Packages. A list of packages appears.
- In the list of packages, right-click the name of the package to drop.
****
- In the list of choices, click Drop Package.
****
- In the Drop window, click Apply.
****
- In the Confirmation window, click OK.
**See Also:**   *Oracle Database PL/SQL Language Reference* for information about the DROP PACKAGE statement
