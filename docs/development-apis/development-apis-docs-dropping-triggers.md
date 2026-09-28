# Dropping Triggers

You must drop a trigger before dropping the objects on which it depends.
To drop a trigger, use either the SQL Developer Connections frame and Drop tool, or the DDL statement DROP TRIGGER.
This statement drops the trigger EVAL_CHANGE_TRIGGER:
```
DROP TRIGGER EVAL_CHANGE_TRIGGER;
```
## Steps to drop a trigger using the Drop tool:
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Triggers.
- In the list of triggers, right-click the name of the trigger to drop.
****
- In the list of choices, click Drop Trigger.
****
- In the Drop window, click Apply.
- In the Confirmation window, click y.
**See Also:**
- “About Data Definition Language (DDL) Statements” for general information that applies to the DROP TRIGGER statement
**
- Oracle Database PL/SQL Language Reference for information about the DROP TRIGGER statement
