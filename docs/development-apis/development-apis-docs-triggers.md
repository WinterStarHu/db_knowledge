# About Triggers

A **trigger** is a PL/SQL unit that is stored in the database and (if it is in the enabled state) automatically executes (“fires”) in response to a specified event.
A trigger has the following structure:
```
TRIGGER trigger_name
  triggering_event
  [ trigger_restriction ]
BEGIN
  triggered_action;
END;
```
The trigger_name must be unique for triggers in the schema. A trigger can have the same name as another kind of object in the schema (for example, a table); however, Oracle recommends using a naming convention that avoids confusion.
If the trigger is in the **enabled** state, the triggering_event causes the database to execute the triggered_action if the trigger_restriction is either TRUE or omitted. The triggering_event is associated with either a table, a view, a schema, or the database, and it is one of these:
- DML statement (described in “About Data Manipulation Language (DML) Statements”)
- DDL statement (described in “About Data Definition Language (DDL) Statements”)
- Database operation (SERVERERROR, LOGON, LOGOFF, STARTUP, or SHUTDOWN)
If the trigger is in the **disabled** state, the triggering_event does not cause the database to execute the triggered_action, even if the trigger_restriction is TRUE or omitted.
By default, a trigger is created in the enabled state. You can disable an enabled trigger, and enable a disabled trigger.
Unlike a subprogram, a trigger cannot be invoked directly. A trigger is invoked only by its triggering event, which can be caused by any user or application. You might be unaware that a trigger is executing unless it causes an error that is not handled properly.
A **simple trigger** can fire at exactly one of these **timing points** :
****
- Before the triggering event executes (statement-level BEFORE trigger)
****
- After the triggering event executes (statement-level AFTER trigger)
****
- Before each row that the event affects (row-level BEFORE trigger)
****
- After each row that the event affects (row-level AFTER trigger)
A **compound trigger** can fire at multiple timing points. For information about compound triggers, see *Oracle Database PL/SQL Language Reference*.
An **INSTEAD OF trigger** is defined on a view, and its triggering event is a DML statement. Instead of executing the DML statement, Oracle Database executes the INSTEAD OF trigger. For more information, see “Creating an INSTEAD OF Trigger”.
A **system trigger** is defined on a schema or the database. A trigger defined on a schema fires for each event associated with the owner of the schema (the current user). A trigger defined on a database fires for each event associated with all users.
One use of triggers is to enforce business rules that apply to all client applications. For example, suppose that data added to the EMPLOYEES table must have a certain format, and that many client applications can add data to this table. A trigger on the table can ensure the proper format of all data added to it. Because the trigger executes whenever any client adds data to the table, no client can circumvent the rules, and the code that enforces the rules can be stored and maintained only in the trigger, rather than in every client application. For other uses of triggers, see *Oracle Database PL/SQL Language Reference*.
**See Also:**   *Oracle Database PL/SQL Language Reference* for complete information about triggers
