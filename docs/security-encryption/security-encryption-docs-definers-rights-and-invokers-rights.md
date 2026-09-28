# About Definer’s Rights and Invoker’s Rights

Definer’s rights and invoker’s rights are used to control access to the privileges necessary during the execution of a user-created procedure, or program unit.
In a definer’s rights procedure, the procedure executes with the privileges of the owner. The privileges are bound to the schema in which they were created. An invoker’s rights procedure executes with the privileges of the current user, that is, the user who invokes the procedure.
For example, suppose user `bixby` creates a procedure that is designed to modify table `cust_records` and then he grants the `EXECUTE` privilege on this procedure to user `rlayton`. If `bixby` had created the procedure with definer’s rights, then the procedure would look for table `cust_records` in `bixby`’s schema. Had the procedure been created with invoker’s rights, then when `rlayton` runs it, the procedure would look for table `cust_records` in `rlayton`’s schema.
By default, all procedures are considered definer’s rights. You can designate a procedure to be an invoker’s rights procedure by using the `AUTHID CURRENT_USER` clause when you create or modify it, or you can use the `AUTHID DEFINER` clause to make it a definer’s rights procedure.
Starting with Oracle Database 12.1, the `SYSDBA` administrative privilege is disabled during execution of definer’s rights procedures. Definer’s rights procedures execute only with the privileges granted directly to the owner of the procedure. Administrative privileges such as `SYSDBA` are not inherited from the invoking session, even if the caller is connected `AS SYSDBA`.
As a result, operations that require `SYSDBA` privileges cannot be performed from within a definer’s rights procedure. This behavior is enforced as a security measure to prevent privilege escalation through stored program units.
You can create privilege analysis policies to capture privilege use of definer’s rights and invoker’s rights procedures.
## Related Topics
  - Performing Privilege Analysis to Identify Privilege Use
**- Oracle Database PL/SQL Language Reference
