# About Trigger Compilation and Dependencies

Compiled triggers depend on the schema objects on which they are defined. If an object on which a trigger depends is dropped, or changed such that there is a mismatch between the trigger and the object, then the trigger is invalidated.
Running a CREATE TRIGGER statement compiles the trigger being created. If this compilation causes an error, then the CREATE TRIGGER statement fails. To see the compilation errors, use the following statement:
```
SELECT * FROM USER_ERRORS WHERE TYPE = 'TRIGGER';
```
Compiled triggers depend on the schema objects on which they are defined. For example, NEW_EVALUATION_TRIGGER depends on the EVALUATIONS table.
```
CREATE OR REPLACE
TRIGGER NEW_EVALUATION_TRIGGER
BEFORE INSERT ON EVALUATIONS
FOR EACH ROW
BEGIN
  :NEW.evaluation_id := evaluations_seq.NEXTVAL;
END;
```
To see the schema objects on which triggers depend, use the following statement:
```
SELECT * FROM ALL_DEPENDENCIES WHERE TYPE = 'TRIGGER';
```
If an object a trigger depends on is dropped or changed such that there is a mismatch between the trigger and the object, then the trigger is invalidated. The next time the trigger is invoked, it is recompiled. To recompile a trigger immediately, use the ALTER TRIGGER statement with the COMPILE clause, as shown in the following example.
```
ALTER TRIGGER NEW_EVALUATION_TRIGGER COMPILE;
```
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about trigger compilation and dependencies
