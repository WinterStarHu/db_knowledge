# Creating Triggers

To create triggers, use either the SQL Developer graphical interface or the DDL statement CREATE TRIGGER.
This section shows how to use both of these ways to create triggers.
By default, a trigger is created in the enabled state. To create a trigger in disabled state, use the CREATE TRIGGER statement with the DISABLE clause.
**Note:**   To create triggers, you must have appropriate privileges; however, for this discussion, you do not need this additional information.
**Note:**   To do the tutorials in this document, you must be connected to Oracle Database as the user HR from SQL Developer.
**See Also:** **
- Oracle Database PL/SQL Language Reference for more information about the CREATE TRIGGER statement
- “Editing Installation Scripts that Create Triggers”
## About OLD and NEW Pseudorecords
When a row-level trigger fires, the PL/SQL runtime system creates and populates the two pseudorecords OLD and NEW. They are called pseudorecords because they have some, but not all, of the properties of records.
For the row that the trigger is processing:
- For an INSERT trigger, OLD contains no values, and NEW contains the new values.
- For an UPDATE trigger, OLD contains the old values, and NEW contains the new values.
- For a DELETE trigger, OLD contains the old values, and NEW contains no values.
To reference a pseudorecord, put a colon before its name-:`OLD` or :`NEW`-as in Example 6-1.
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about OLD and NEW pseudorecords
## Tutorial: Creating a Trigger that Logs Table Changes
This tutorial shows how to use the CREATE TRIGGER statement to create a trigger, EVAL_CHANGE_TRIGGER, which adds a row to the table EVALUATIONS_LOG whenever an INSERT, UPDATE, or DELETE statement changes the EVALUATIONS table.
The trigger adds the row *after* the triggering statement executes, and uses the **conditional predicates** **INSERTING** , **UPDATING** , and **DELETING** to determine which of the three possible DML statements fired the trigger.
EVAL_CHANGE_TRIGGER is a **statement-level trigger** and an **AFTER trigger**.
**To create EVALUATIONS_LOG and EVAL_CHANGE_TRIGGER:**
```
 CREATE TABLE EVALUATIONS_LOG ( log_date DATE
                             , action VARCHAR2(50));
```
- Create the EVALUATIONS_LOG table:
```
 CREATE OR REPLACE TRIGGER EVAL_CHANGE_TRIGGER
   AFTER INSERT OR UPDATE OR DELETE
   ON EVALUATIONS
 DECLARE
   log_action  EVALUATIONS_LOG.action%TYPE;
 BEGIN
   IF INSERTING THEN
     log_action := 'Insert';
   ELSIF UPDATING THEN
     log_action := 'Update';
   ELSIF DELETING THEN
     log_action := 'Delete';
   ELSE
     DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
   END IF;
   INSERT INTO EVALUATIONS_LOG (log_date, action)
     VALUES (SYSDATE, log_action);
 END;
```
- Create EVAL_CHANGE_TRIGGER:
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about conditional predicates
## Tutorial: Creating a Trigger that Generates a Primary Key for a Row Before It Is Inserted
This tutorial shows how to use the SQL Developer Create Trigger tool to create a trigger that fires before a row is inserted into the EVALUATIONS table, and generates the unique number for the primary key of that row, using EVALUATIONS_SEQUENCE.
The sequence EVALUATIONS_SEQUENCE (created in “Tutorial: Creating a Sequence”) generates primary keys for the EVALUATIONS table (created in). However, these primary keys are not inserted into the table automatically.
This tutorial shows how to use the SQL Developer Create Trigger tool to create a trigger named NEW_EVALUATION_TRIGGER, which fires *before* a row is inserted into the EVALUATIONS table, and generates the unique number for the primary key of that row, using EVALUATIONS_SEQUENCE. The trigger fires once *for each row* affected by the triggering INSERT statement.
NEW_EVALUATION_TRIGGER is a **row-level trigger** and a **BEFORE trigger**.
**Steps to create the NEW_EVALUATION trigger:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Triggers.
****
- In the list of choices, select New Trigger.
  - In the Name field, type NEW_EVALUATION_TRIGGER over the default value TRIGGER1.
****
  - For Base Object, select EVALUATIONS from the menu.
**** ********
  - Move INSERT from Available Events to Selected Events. (Select INSERT and select >.)
****
  - Deselect the option Statement Level.
****
```
 CREATE OR REPLACE
 TRIGGER NEW_EVALUATION_TRIGGER
 BEFORE INSERT ON EVALUATIONS
 FOR EACH ROW
 BEGIN
   NULL;
 END;
```
  - Select OK. The NEW_EVALUATION_TRIGGER pane opens, showing the CREATE TRIGGER statement that created the trigger: The title of the NEW_EVALUATION_TRIGGER pane is in italic font, indicating that the trigger is not yet saved in the database.
```
 :NEW.evaluation_id := evaluations_sequence.NEXTVAL
```
- In the CREATE TRIGGER statement, replace NULL with the following text:
****
- From the File menu, select Save. Oracle Database compiles the procedure and saves it. The title of the NEW_EVALUATION_TRIGGER pane is no longer in italic font.
## Creating an INSTEAD OF Trigger
A view presents the output of a query as a table. If you want to change a view as you would change a table, then you must create INSTEAD OF triggers. Instead of changing the view, they change the underlying tables.
For example, consider the view EMP_LOCATIONS, whose NAME column is created from the LAST_NAME and FIRST_NAME columns of the EMPLOYEES table:
```
CREATE VIEW EMP_LOCATIONS AS
SELECT e.EMPLOYEE_ID,
  e.LAST_NAME || ', ' || e.FIRST_NAME NAME,
  d.DEPARTMENT_NAME DEPARTMENT,
  l.CITY CITY,
  c.COUNTRY_NAME COUNTRY
FROM EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID AND
 d.LOCATION_ID = l.LOCATION_ID AND
 l.COUNTRY_ID = c.COUNTRY_ID
ORDER BY LAST_NAME;
```
To update the view EMP_LOCATIONS.NAME (created in “Creating Views with the CREATE VIEW Statement”), you must update EMPLOYEES.LAST_NAME and EMPLOYEES.FIRST_NAME. This is what the INSTEAD OF trigger in Example 6-1 does.
NEW and OLD are **pseudorecords** that the PL/SQL runtime engine creates and populates whenever a row-level trigger fires. OLD and NEW store the original and new values, respectively, of the record being processed by the trigger. They are called pseudorecords because they do not have all properties of PL/SQL records.
**Example 6-1 Creating an INSTEAD OF Trigger**
```
CREATE OR REPLACE TRIGGER update_name_view_trigger
INSTEAD OF UPDATE ON emp_locations
BEGIN
  UPDATE employees SET
    first_name = substr( :NEW.name, instr( :new.name, ',' )+2),
    last_name = substr( :NEW.name, 1, instr( :new.name, ',')-1)
  WHERE employee_id = :OLD.employee_id;
END;
```
**See Also:** **
- Oracle Database PL/SQL Language Reference for more information about INSTEAD OF triggers
**
- Oracle Database PL/SQL Language Reference for more information about OLD and NEW
## Tutorial: Creating Triggers that Log LOGON and LOGOFF Events
This tutorial shows how to use the CREATE TRIGGER statement to create two triggers, HR_LOGON_TRIGGER and HR_LOGOFF_TRIGGER. *After* someone logs on as user HR, HR_LOGON_TRIGGER adds a row to the table HR_USERS_LOG. *Before* someone logs off as user HR, HR_LOGOFF_TRIGGER adds a row to the table HR_USERS_LOG.
HR_LOGON_TRIGGER and HR_LOGOFF_TRIGGER are **system triggers**. HR_LOGON_TRIGGER is an **AFTER trigger** and HR_LOGOFF_TRIGGER is a **BEFORE trigger**.
**Steps to create HR_USERS_LOG, HR_LOGON_TRIGGER, and HR_LOGOFF_TRIGGER:**
```
 CREATE TABLE hr_users_log (
   user_name VARCHAR2(30),
   activity VARCHAR2(20),
   event_date DATE
 );
```
- Create the HR_USERS_LOG table:
```
 CREATE OR REPLACE TRIGGER hr_logon_trigger
   AFTER LOGON
   ON HR.SCHEMA
 BEGIN
   INSERT INTO hr_users_log (user_name, activity, event_date)
   VALUES (USER, 'LOGON', SYSDATE);
 END;
```
- Create HR_LOGON_TRIGGER:
```
 CREATE OR REPLACE TRIGGER hr_logoff_trigger
   BEFORE LOGOFF
   ON HR.SCHEMA
 BEGIN
   INSERT INTO hr_users_log (user_name, activity, event_date)
   VALUES (USER, 'LOGOFF', SYSDATE);
 END;
```
- Create HR_LOGOFF_TRIGGER:
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about system triggers
