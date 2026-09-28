# Editing Installation Scripts that Create Triggers

If your application has a BEFORE INSERT trigger on a source table, and you *will* insert data from that source table into the corresponding new table, you must decide if you want the trigger to fire before each INSERT statement in the installation script inserts data into the new table.
For example, NEW_EVALUATION_TRIGGER (created in “Tutorial: Creating a Trigger that Generates a Primary Key for a Row Before It Is Inserted”) fires before a row is inserted into the EVALUATIONS table. The trigger generates the unique number for the primary key of that row, using EVALUATIONS_SEQUENCE.
The source EVALUATIONS table is populated with primary keys. If you do not want the installation script to put new primary key values in the new EVALUATIONS table, then you must edit the CREATE TRIGGER statement in the installation script as shown:
```
CREATE OR REPLACE
TRIGGER NEW_EVALUATION_TRIGGER
BEFORE INSERT ON EVALUATIONS
FOR EACH ROW
BEGIN
  IF :NEW.evaluation_id IS NULL THEN
    :NEW.evaluation_id := evaluations_sequence.NEXTVAL
  END IF;
END;
```
Also, if the current value of the sequence is not greater than the maximum value in the primary key column, then you must make it greater.
You can edit the installation script in either the Worksheet or any text editor.
The following steps are two alternatives to editing the installation script:
- Change the trigger definition in the source file and then re-create the installation script. For information about changing triggers, see “Changing Triggers”.
- Disable the trigger before running the data installation script, and then re-enable it afterward. For information about disabling and enabling triggers, see “Disabling and Enabling Triggers”.
**See Also:**   “Creating Triggers”
