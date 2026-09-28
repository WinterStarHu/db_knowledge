# Procedure Privileges

The `EXECUTE` privilege enables users to run procedures and functions, either standalone or in packages.
- The Use of the EXECUTE Privilege for Procedure Privileges The EXECUTE privilege is a very powerful privilege that should be handled with caution.
- Procedure Execution and Security Domains The EXECUTE object privilege for a procedure can be used to execute a procedure or compile a program unit that references the procedure.
- System Privileges Required to Create or Replace a Procedure You must have specific privileges to create or replace a procedure in your own schema or in another user’s schema.
- System Privileges Required to Compile a Procedure You must have specific privileges to compile both standalone procedures and procedures that are part of a package.
- How Procedure Privileges Affect Packages and Package Objects The powerful EXECUTE privilege enables users to run any public procedures or functions within a package.
## The Use of the EXECUTE Privilege for Procedure Privileges
The EXECUTE privilege is a very powerful privilege that should be handled with caution.
The `EXECUTE`**** privilege is the only **object privilege** for procedures, including standalone procedures and functions, and for those within packages.
You should grant this privilege only to users who must run a procedure or compile another procedure that calls a desired procedure. You can find the privileges that a user has been granted by querying the DBA_SYS_PRIVS data dictionary view.
## Procedure Execution and Security Domains
The `EXECUTE` object privilege for a procedure can be used to execute a procedure or compile a program unit that references the procedure.
Oracle Database performs a run-time privilege check when any PL/SQL unit is called. A user with the `EXECUTE` `ANY` `PROCEDURE` system privilege can execute any procedure in the database. Privileges to run procedures can be granted to a user through roles.
## System Privileges Required to Create or Replace a Procedure
You must have specific privileges to create or replace a procedure in your own schema or in another user’s schema.
To create or replace a procedure in your own schema, you must have the `CREATE PROCEDURE` system privilege. To create or replace a procedure in another user’s schema, you must have the `CREATE ANY PROCEDURE` system privilege.
The user who owns the procedure also must have privileges for schema objects referenced in the procedure body. To create a procedure, you need to have been explicitly granted the necessary privileges (system or object) on all objects referenced by the procedure. You cannot obtain the required privileges through roles. This includes the `EXECUTE` privilege for any procedures that are called inside the procedure being created.
**Note:**   Triggers require that privileges on referenced objects be granted directly to the owner of the trigger. Anonymous PL/SQL blocks can use any privilege, whether the privilege is granted explicitly or through a role.
## System Privileges Required to Compile a Procedure
You must have specific privileges to compile both standalone procedures and procedures that are part of a package.
To compile a standalone procedure, you should run the `ALTER PROCEDURE` statement with the `COMPILE` clause. To compile a procedure that is part of a package, you should run the `ALTER PACKAGE` statement.
The following example shows how to compile a standalone procedure.
```
ALTER PROCEDURE psmith.remove_emp COMPILE;
```
If the standalone or packaged procedure is in another user’s schema, you must have the `ALTER ANY PROCEDURE` privilege to recompile it. You can recompile procedures in your own schema without any privileges.
## How Procedure Privileges Affect Packages and Package Objects
The powerful `EXECUTE` privilege enables users to run any public procedures or functions within a package.
- About the Effect of Procedure Privileges on Packages and Package Objects The EXECUTE object privilege for a package applies to any procedure or function within this package.
- Example: Procedure Privileges Used in One Package The CREATE PACKAGE BODY statement can create a package body that contains procedures to manage procedure privileges used in one package.
- Example: Procedure Privileges and Package Objects The CREATE PACKAGE BODY statement can create a package body containing procedure definitions to manage procedure privileges and package objects.
### About the Effect of Procedure Privileges on Packages and Package Objects
The `EXECUTE` object privilege for a package applies to any procedure or function within this package.
A user with the`EXECUTE` object privilege for a package can execute any public procedure or function in the package, and can access or modify the value of any public package variable.
You cannot grant specific `EXECUTE` privileges for individual constructs in a package. Therefore, you may find it useful to consider two alternatives for establishing security when developing procedures, functions, and packages for a database application. The following examples describe these alternatives.
### Example: Procedure Privileges Used in One Package
The CREATE PACKAGE BODY statement can create a package body that contains procedures to manage procedure privileges used in one package.
Example 4-7 shows four procedures created in the bodies of two packages.
Example 4-7 Procedure Privileges Used in One Packagee
```
CREATE PACKAGE BODY hire_fire AS
  PROCEDURE hire(...) IS
    BEGIN
      INSERT INTO employees . . .
    END hire;
  PROCEDURE fire(...) IS
    BEGIN
      DELETE FROM employees . . .
    END fire;
END hire_fire;
CREATE PACKAGE BODY raise_bonus AS
  PROCEDURE give_raise(...) IS
    BEGIN
      UPDATE employees SET salary = . . .
    END give_raise;
  PROCEDURE give_bonus(...) IS
    BEGIN
      UPDATE employees SET bonus = . . .
    END give_bonus;
END raise_bonus;
```
The following `GRANT EXECUTE` statements enable the `big_bosses` and `little_bosses` roles to run the appropriate procedures:
```
GRANT EXECUTE ON hire_fire TO big_bosses;
GRANT EXECUTE ON raise_bonus TO little_bosses;
```
### Example: Procedure Privileges and Package Objects
The CREATE PACKAGE BODY statement can create a package body containing procedure definitions to manage procedure privileges and package objects.
Example 4-8 shows four procedure definitions within the body of a single package. Two additional standalone procedures and a package are created specifically to provide access to the procedures defined in the main package.
Example 4-8 Procedure Privileges and Package Objects
```
CREATE PACKAGE BODY employee_changes AS
  PROCEDURE change_salary(...) IS BEGIN ... END;
  PROCEDURE change_bonus(...) IS BEGIN ... END;
  PROCEDURE insert_employee(...) IS BEGIN ... END;
  PROCEDURE delete_employee(...) IS BEGIN ... END;
END employee_changes;
CREATE PROCEDURE hire
  BEGIN
    employee_changes.insert_employee(...)
  END hire;
CREATE PROCEDURE fire
  BEGIN
    employee_changes.delete_employee(...)
  END fire;
PACKAGE raise_bonus IS
  PROCEDURE give_raise(...) AS
    BEGIN
      employee_changes.change_salary(...)
    END give_raise;
  PROCEDURE give_bonus(...)
    BEGIN
      employee_changes.change_bonus(...)
    END give_bonus;
```
Using this method, the procedures that actually do the work (the procedures in the `employee_changes` package) are defined in a single package and can share declared global variables, cursors, on so on. By declaring top-level procedures,` hire` and `fire`, and an additional package, `raise_bonus`, you can grant selective `EXECUTE` privileges on procedures in the main package:
```
GRANT EXECUTE ON hire, fire TO big_bosses;
GRANT EXECUTE ON raise_bonus TO little_bosses;
```
Be aware that granting `EXECUTE` privilege for a package provides uniform access to all package objects.
## Related Topics
  - About Definer's Rights and Invoker's Rights
**- Oracle Database PL/SQL Packages and Types Reference for more information about how Oracle Database checks privileges at run-time
