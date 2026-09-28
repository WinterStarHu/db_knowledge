# Managing Security for Definer’s Rights and Invoker’s Rights

Invoker’s rights and definer’s rights have several security advantages when used to control access to privileges during user-defined procedure executions.
- About Definer’s Rights and Invoker’s Rights Definer’s rights and invoker’s rights are used to control access to the privileges necessary during the execution of a user-created procedure, or program unit.
**
- How Procedure Privileges Affect Definer’s Rights The owner of a procedure, called the definer, must have the necessary object privileges for objects that the procedure references.
- How Procedure Privileges Affect Invoker’s Rights An invoker’s rights procedure executes with all of the invoker’s privileges.
- When You Should Create Invoker’s Rights Procedures Oracle recommends that you create invoker’s rights procedures in certain situations.
````
- Controlling Invoker’s Rights Privileges for Procedure Calls and View Access The INHERIT PRIVILEGES and INHERIT ANY PRIVILEGES privileges regulate the privileges used when invoker’s rights procedures are run.
````
- Definer’s Rights and Invoker’s Rights in Views The BEQEATH clause in the CREATE VIEW SQL statement can control definer’s rights and invoker’s rights in user-created views.
- Using Code Based Access Control for Definer’s Rights and Invoker’s Rights Code based access control, used to attach database roles to PL/SQL functions, procedures, or packages, works well with invoker’s rights and definer’s procedures.
- Controlling Definer’s Rights Privileges for Database Links You can control privilege grants for definer’s rights procedures if your applications use database links and definer’s rights procedures.
