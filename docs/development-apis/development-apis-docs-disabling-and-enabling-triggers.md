# Disabling and Enabling Triggers

You might need to temporarily disable triggers that reference objects that are unavailable, or to upload a large amount of data without the delay that triggers cause (as in a recovery operation). After the referenced objects become available, or you have finished uploading the data, you can re-enable the triggers.
**See Also:** **````
- Oracle Database PL/SQL Language Reference for more information about the ALTER TRIGGER statement
**````
- Oracle Database SQL Language Reference for more information about the ALTER TABLE statement
## Disabling or Enabling a Single Trigger
To disable or enable a single trigger, use either the Disable Trigger or Enable Trigger tool or the ALTER TRIGGER statement with the DISABLE or ENABLE clause.
For example, these statements disable and enable the eval_change_trigger:
```
ALTER TRIGGER eval_change_trigger DISABLE;
ALTER TRIGGER eval_change_trigger ENABLE;
```
**To use the Disable Trigger or Enable Trigger tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Triggers.
- In the list of triggers, right-click the desired trigger.
********
- In the list of choices, select Disable or Enable.
****
- In the Disable or Enable window, select Apply.
****
- In the Confirmation window, select OK.
## Disabling or Enabling All Triggers on a Single Table
To disable or enable all triggers on a specific table, use either the Disable All Triggers or Enable All Triggers tool or the ALTER TABLE statement with the DISABLE ALL TRIGGERS or ENABLE ALL TRIGGERS clause.
For example, the following statements disable and enable all triggers on the evaluations table:
```
ALTER TABLE evaluations DISABLE ALL TRIGGERS;
ALTER TABLE evaluations ENABLE ALL TRIGGERS;
```
**To use the Disable All Triggers or Enable All Triggers tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Tables.
- In the list of tables, right-click the desired table.
****
- In the list of choices, select Triggers.
********
- In the list of choices, select Disable All or Enable All.
****
- In the Disable All or Enable All window, select Apply.
****
- In the Confirmation window, select OK.
