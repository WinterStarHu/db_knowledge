# Example: Creating a Simple Logon Trigger

The `CREATE TRIGGER` statement can create a simple logon trigger.
Example 13-2 shows a simple logon trigger that executes a PL/SQL procedure.
Example 13-2 Creating a Simple Logon Trigger
```
CREATE OR REPLACE TRIGGER set_empno_ctx_trig AFTER LOGON ON DATABASE
 BEGIN
  sec_mgr.set_empno_ctx_proc;
 END;
```
