# Changing Triggers

To change a trigger, use either the SQL Developer tool Edit or the DDL statement CREATE TRIGGER with the OR REPLACE clause.
## Steps to change a trigger using the Edit tool:
****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Triggers.
- In the list of triggers, click the trigger to change.
- In the frame to the right of the Connections frame, the Code pane appears, showing the code that created the trigger. The Code pane is in write mode. (Clicking the pencil icon switches the mode from write mode to read only, or the reverse.)
- In the Code pane, change the code. The title of the pane is in italic font, indicating that the change is not yet saved in the database.
****
- From the File menu, select Save. Oracle Database compiles the trigger and saves it. The title of the pane is no longer in italic font.
**See Also:**
- “About Data Definition Language (DDL) Statements” for general information that applies to the CREATE OR REPLACE TRIGGER statement
**
- Oracle Database PL/SQL Language Reference for more information about the CREATE OR REPLACE TRIGGER statement
