# When You Should Create Invoker’s Rights Procedures

Oracle recommends that you create invoker’s rights procedures in certain situations.
These situations are as follows:
****
- When creating a PL/SQL procedure in a high-privileged schema. When lower-privileged users invoke the procedure, then it can do no more than those users are allowed to do. In other words, the invoker’s rights procedure runs with the privileges of the invoking user.
****``````````
- When the PL/SQL procedure contains no SQL and is available to other users. The DBMS_OUTPUT PL/SQL package is an example of a PL/SQL subprogram that contains no SQL and is available to all users. The reason you should use an invoker’s rights procedure in this situation is because the unit issues no SQL statements at run time, so the run-time system does not need to check their privileges. Specifying AUTHID CURRENT_USER makes invocations of the procedure more efficient, because when an invoker’s right procedure is pushed onto, or comes from, the call stack, the values of CURRENT_USER and CURRENT_SCHEMA, and the currently enabled roles do not change.
## Related Topics
  - Configuration of Oracle Virtual Private Database Policies
  - About ANY Privileges and the PUBLIC Role
**- Oracle Database PL/SQL Packages and Types Reference for information about how Oracle Database handles name resolution and privilege checking at runtime using invoker's and definer's rights **- Oracle Database PL/SQL Packages and Types Reference for more information about the differences between invoker's rights and definer's rights units **- Oracle Database PL/SQL Packages and Types Reference for information about defining explicit cursors in the CREATE PACKAGE statement
